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

-- Apply default carry speed upgrade to bots
function TeamAIMovement:set_carry_speed_modifier(...)
	TeamAIMovement.super.set_carry_speed_modifier(self, ...)

	if self._carry_speed_modifier then
		local carry_upgrade = managers.player:upgrade_value("carry", "movement_speed_multiplier", 1)
		self._carry_speed_modifier = math.clamp(self._carry_speed_modifier * carry_upgrade, 0, 1)
	end
end

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
