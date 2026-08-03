-- Fix for some broken reload anim time check code
setmetatable(HuskPlayerMovement.reload_times, {
	__index = function(t, k)
		if type(k) == "table" then
			for _, v in pairs(k) do
				local r = rawget(t, v)
				if r then
					return r
				end
			end
		end
		rawset(t, k, 2)
		return 2
	end,
})

-- Properly load secondary weapons from factory IDs
function TeamAIMovement:add_weapons()
	if Network:is_server() then
		local char_name = self._ext_base._tweak_table
		local loadout = managers.criminals:get_loadout_for(char_name)
		local crafted = managers.blackmarket:get_crafted_category_slot("primaries", loadout.primary_slot)

		if crafted then
			self._unit:inventory():add_unit_by_factory_blueprint(loadout.primary, false, false, crafted.blueprint, crafted.cosmetics)
		elseif loadout.primary then
			self._unit:inventory():add_unit_by_factory_name(loadout.primary, false, false, nil, "")
		else
			local weapon = self._ext_base:default_weapon_name("primary")
			local _ = weapon and self._unit:inventory():add_unit_by_factory_name(weapon, false, false, nil, "")
		end

		local sec_weap_name = self._ext_base:default_weapon_name("secondary")
		local _ = sec_weap_name and self._unit:inventory():add_unit_by_factory_name(sec_weap_name, false, false, nil, "")
	else
		TeamAIMovement.super.add_weapons(self)
	end
end

Hooks:PostHook(TeamAIMovement, "clbk_inventory", "eclipse_clbk_inventory", function(self)
	local weapon = self._ext_inventory:equipped_unit()
	if not alive(weapon) then
		return
	end

	local weap_tweak = weapon:base():weapon_tweak_data()

	-- Fix broken hold types
	if type(weap_tweak.hold) == "table" then
		local num = #weap_tweak.hold + 1
		for i, hold_type in ipairs(weap_tweak.hold) do
			self._machine:set_global(hold_type, self:get_hold_type_weight(hold_type) or num - i)
			table.insert(self._weapon_hold, hold_type)
		end
	end

	if not weap_tweak.reload_time then
		return
	end

	if self._looped_reload_time then
		self._looped_reload_time = weap_tweak.reload_time
		self._reload_speed_multiplier = (0.45 * (weap_tweak.looped_reload_single and 1 or weap_tweak.CLIP_AMMO_MAX)) / self._looped_reload_time
	else
		self._reload_speed_multiplier = HuskPlayerMovement:get_reload_animation_time(weap_tweak.reload or weap_tweak.hold) / weap_tweak.reload_time
	end
end)

if not Network:is_server() then
	return
end

Hooks:PostHook(TeamAIMovement, "init", "eclipse_init", function(self)
	self._carry_table = {}
	self._queued_actions = {}
end)

Hooks:PostHook(TeamAIMovement, "set_allow_fire", "set_allow_fire_ub", function(self, state)
	if state then
		self._switch_upper_body_to_idle_t = nil
	end
end)

TeamAIMovement.chk_action_forbidden = CopMovement.chk_action_forbidden

Hooks:PostHook(TeamAIMovement, "set_should_stay", "set_should_stay_ub", function(self, should_stay, pos)
	if should_stay and pos then
		self._should_stay_pos = mvector3.copy(pos)
	end

	local objective = self._ext_brain:objective()
	if not objective or not objective.forced then
		self._ext_brain:set_objective(managers.groupai:state():_determine_objective_for_criminal_AI(self._unit))
	end
end)

-- Bag stuff!
function TeamAIMovement:has_crew_carrystacker()
	return managers.player:has_category_upgrade("team", "crew_ai_carry_stacker")
end

function TeamAIMovement:carrying_bag()
	return self._carry_table and #self._carry_table > 0 or false
end

function TeamAIMovement:set_carrying_bag(unit)
	local dropped
	if unit then
		table.insert(self._carry_table, unit)
	elseif #self._carry_table > 0 then
		table.remove(self._carry_table)
	end

	local name_label = managers.hud:_get_name_label(self._unit:unit_data().name_label_id)
	if name_label then
		local bag_panel = name_label.panel and name_label.panel:child("bag")
		if bag_panel then
			bag_panel:set_visible(unit or dropped)
		end
	end

	self:set_carry_speed_modifier()
end

-- returns top if no args given
function TeamAIMovement:carry_unit(idx)
	idx = idx or #self._carry_table

	return self._carry_table and self._carry_table[idx] and alive(self._carry_table[idx]) and self._carry_table[idx]
end

-- attempt to fix a possible race condition
local in_use_carries = {}
function TeamAIMovement:get_secure_carry()
	local idx = #self._carry_table
	if in_use_carries[idx] then
		idx = idx - 1
	end

	if idx == 0 then
		return false
	end

	in_use_carries[idx] = true

	return self._carry_table and self._carry_table[idx] and alive(self._carry_table[idx]) and self._carry_table[idx], idx
end

function TeamAIMovement:clear_in_use_carry(idx)
	in_use_carries[idx] = false
end

-- returns top if no args given
function TeamAIMovement:carry_id(idx)
	idx = idx or #self._carry_table

	local carry_ext = self:carry_data(idx)

	return carry_ext and carry_ext:carry_id()
end

-- returns top if no args given
function TeamAIMovement:carry_data(idx)
	idx = idx or #self._carry_table

	return self._carry_table and self._carry_table[idx] and alive(self._carry_table[idx]) and self._carry_table[idx]:carry_data()
end

-- returns top if no args given
function TeamAIMovement:carry_tweak(idx)
	idx = idx or #self._carry_table

	local carry_ext = self:carry_data(idx)

	return carry_ext and carry_ext:carry_tweak()
end

-- returns top if no args given
function TeamAIMovement:carry_type_tweak(idx)
	idx = idx or #self._carry_table

	local carry_ext = self:carry_data(idx)

	return carry_ext and carry_ext:carry_type_tweak()
end

function TeamAIMovement:bank_carry()
	for i = 1, #self._carry_table do
		local carry_data = self:carry_data(i)

		if carry_data then
			managers.loot:secure(carry_data:carry_id(), carry_data:multiplier())
			self._carry_table[i]:set_slot(0)

			self._carry_table[i] = nil
		end
	end
end

function TeamAIMovement:throw_bag(target_unit, reason)
	if not self:carrying_bag() then
		return
	end

	local idx = #self._carry_table
	local carry_unit = self._carry_table[idx]
	self._was_carrying = {
		unit = carry_unit,
		reason = reason,
	}

	if carry_unit and alive(carry_unit) and carry_unit:carry_data() then
		carry_unit:carry_data():unlink()

		if Network:is_server() then
			self:sync_throw_bag(carry_unit, target_unit)
			managers.network:session():send_to_peers("sync_ai_throw_bag", self._unit, carry_unit, target_unit)
		end
	end
	self._carry_table[idx] = nil

	if idx == 2 then
		carry_unit = self._carry_table[1]
		carry_unit:set_visible(true)
	end
end

function TeamAIMovement:was_carrying_bag()
	return self._was_carrying
end

function TeamAIMovement:sync_throw_bag(carry_unit, target_unit)
	if alive(target_unit) then
		local dir = target_unit:position() - self._unit:position()

		mvector3.set_z(dir, math.abs(dir.x + dir.y) * 0.5)

		local carry_type_tweak = carry_unit:carry_data():carry_type_tweak()
		local throw_distance_multiplier = carry_type_tweak and carry_type_tweak.throw_distance_multiplier or 1

		carry_unit:push(tweak_data.ai_carry.throw_force, (dir - carry_unit:velocity()) * throw_distance_multiplier)
	end
end

-- Apply default carry speed upgrade to bots
function TeamAIMovement:set_carry_speed_modifier(...)
	TeamAIMovement.super.set_carry_speed_modifier(self, ...)

	if self._carry_speed_modifier then
		local carry_upgrade = managers.player:upgrade_value("carry", "movement_speed_multiplier", 1)
		self._carry_speed_modifier = math.clamp(self._carry_speed_modifier * carry_upgrade, 0, 1)
	end
end
