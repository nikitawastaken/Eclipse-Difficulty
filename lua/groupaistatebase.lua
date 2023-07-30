-- Scale gained drama with player count
function GroupAIStateBase:criminal_hurt_drama(unit, attacker, dmg_percent)
	self._drama_data.drama_bal_mul = tweak_data.drama.drama_balance_mul
	local drama_data = self._drama_data
	local drama_player_mul = self:_get_balancing_multiplier(self._drama_data.drama_bal_mul)
	local drama_amount = drama_data.actions.criminal_hurt * dmg_percent * drama_player_mul

	if alive(attacker) then
		local max_dis = drama_data.max_dis
		local dis_lerp = math.min(1, mvector3.distance(attacker:movement():m_pos(), unit:movement():m_pos()) / drama_data.max_dis)
		dis_lerp = math.lerp(1, drama_data.dis_mul, dis_lerp)
		drama_amount = drama_amount * dis_lerp
	end

	self:_add_drama(drama_amount)
end

local _update_whitelist = {
	hox_1 = true,
	hox_2 = true,
	red2 = true,
	spa = true,
	flat = true,
	rvd2 = true,
	dinner = true,
	pbr2 = true,
	born = true,
	peta2 = true,
}

-- Code from Dr. Newbie
local _old_update_point_of_no_return = GroupAIStateBase._update_point_of_no_return

function GroupAIStateBase:_update_point_of_no_return(t, dt)
	local get_mission_script_element = function(id)
		for name, script in pairs(managers.mission:scripts()) do
			if script:element(id) then
				return script:element(id)
			end
		end
	end

	local level_id = managers.job:has_active_job() and managers.job:current_level_id() or ""

	if _update_whitelist[level_id] then
		self._point_of_no_return_timer = self._point_of_no_return_timer - dt
	end

	if self._point_of_no_return_id == -1 or not get_mission_script_element(self._point_of_no_return_id) then
		if self._point_of_no_return_timer <= 0 then
            managers.groupai:set_state("ponr")
			self:remove_point_of_no_return_timer(-1)
			self:set_difficulty(1)
		else
			managers.hud:feed_point_of_no_return_timer(self._point_of_no_return_timer)
		end
	else
		_old_update_point_of_no_return(self, t, dt)
	end
end
-- End code from Dr. Newbie

-- Set up needed variables
Hooks:PostHook(GroupAIStateBase, "init", "sh_init", function(self)
	self._next_police_upd_task = 0
	self._next_group_spawn_t = {}
	self._marking_sentries = {}
end)

-- Make elite dozers register as specials
local function register_special_types(gstate)
	gstate._special_unit_types.tank_elite = true
	gstate._special_unit_mappings = {
		tank_elite = { "tank" },
	}
end

Hooks:PostHook(GroupAIStateBase, "_init_misc_data", "sh__init_misc_data", register_special_types)
Hooks:PostHook(GroupAIStateBase, "on_simulation_started", "sh_on_simulation_started", register_special_types)

local register_special_unit_original = GroupAIStateBase.register_special_unit
function GroupAIStateBase:register_special_unit(u_key, category_name, ...)
	local mapping = self._special_unit_mappings[category_name]
	if mapping then
		for _, v in pairs(mapping) do
			register_special_unit_original(self, u_key, v, ...)
		end
	else
		register_special_unit_original(self, u_key, category_name, ...)
	end
end

local unregister_special_unit_original = GroupAIStateBase.unregister_special_unit
function GroupAIStateBase:unregister_special_unit(u_key, category_name, ...)
	local mapping = self._special_unit_mappings[category_name]
	if mapping then
		for _, v in pairs(mapping) do
			unregister_special_unit_original(self, u_key, v, ...)
		end
	else
		unregister_special_unit_original(self, u_key, category_name, ...)
	end
end

-- Restore scripted cloaker spawn noise
local _process_recurring_grp_SO_original = GroupAIStateBase._process_recurring_grp_SO
function GroupAIStateBase:_process_recurring_grp_SO(...)
	if _process_recurring_grp_SO_original(self, ...) then
		managers.network:session():send_to_peers_synched("group_ai_event", self:get_sync_event_id("cloaker_spawned"), 0)
		managers.hud:post_event("cloaker_spawn")
		return true
	end
end

-- Log time when criminals enter an area to use for the teargas check
Hooks:PreHook(GroupAIStateBase, "on_criminal_nav_seg_change", "sh_on_criminal_nav_seg_change", function(self, unit, nav_seg_id)
	local u_sighting = self._criminals[unit:key()]
	if not u_sighting or u_sighting.ai then
		return
	end

	local prev_area = u_sighting.area
	local area = self:get_area_from_nav_seg_id(nav_seg_id)
	if prev_area and prev_area ~= area then
		if table.count(prev_area.criminal.units, function(c_data)
			return not c_data.ai
		end) <= 1 then
			prev_area.criminal_left_t = self._t
			prev_area.old_criminal_entered_t = prev_area.criminal_entered_t
			prev_area.criminal_entered_t = nil
		end
		if not area.criminal_entered_t then
			if area.criminal_left_t and area.old_criminal_entered_t then
				area.criminal_entered_t = math.lerp(area.old_criminal_entered_t, self._t, math.min((self._t - area.criminal_left_t) / 20, 1))
			else
				area.criminal_entered_t = self._t
			end
		end
	end
end)

-- Delay spawn points when enemies die close to them
Hooks:PostHook(GroupAIStateBase, "on_enemy_unregistered", "sh_on_enemy_unregistered", function(self, unit)
	if Network:is_client() or not unit:character_damage():dead() then
		return
	end

	local e_data = self._police[unit:key()]
	if not e_data.group or not e_data.group.has_spawned then
		return
	end

	local spawn_point = unit:unit_data().mission_element
	if not spawn_point then
		return
	end

	local max_dis = 1000
	local dis = mvector3.distance(spawn_point:value("position"), e_data.m_pos)
	if dis > max_dis then
		return
	end

	for _, area in pairs(self._area_data) do
		if area.spawn_groups then
			for _, group in pairs(area.spawn_groups) do
				if group.spawn_pts then
					for _, point in pairs(group.spawn_pts) do
						if point.mission_element == spawn_point then
							local delay_t = self._t + math.lerp(tweak_data.group_ai.spawn_kill_cooldown, 0, dis / max_dis)
							group.delay_t = math.max(group.delay_t, delay_t)
							return
						end
					end
				end
			end
		end
	end
end)

-- Ignore disabled criminals for area safety checks
function GroupAIStateBase:is_area_safe(area)
	for _, u_data in pairs(self._criminals) do
		if u_data.status ~= "disabled" and u_data.status ~= "dead" and area.nav_segs[u_data.tracker:nav_segment()] then
			return
		end
	end
	return true
end

function GroupAIStateBase:is_area_safe_assault(area)
	for _, u_data in pairs(self._char_criminals) do
		if u_data.status ~= "disabled" and u_data.status ~= "dead" and area.nav_segs[u_data.tracker:nav_segment()] then
			return
		end
	end
	return true
end

function GroupAIStateBase:is_nav_seg_safe(nav_seg)
	for _, u_data in pairs(self._criminals) do
		if u_data.status ~= "disabled" and u_data.status ~= "dead" and u_data.tracker:nav_segment() == nav_seg then
			return
		end
	end
	return true
end

-- Don't count recon as assault force and vice versa
function GroupAIStateBase:_count_police_force(task_name)
	local amount = 0
	local objective_type = task_name .. "_area"
	for _, group in pairs(self._groups) do
		if group.objective.type == objective_type then
			amount = amount + (group.has_spawned and group.size or group.initial_size)
		end
	end
	return amount
end

-- Set accurate criminal position
Hooks:PostHook(GroupAIStateBase, "criminal_spotted", "sh_criminal_spotted", function(self, unit)
	local u_sighting = self._criminals[unit:key()]
	mvector3.set(u_sighting.pos, u_sighting.m_det_pos)
end)

Hooks:PostHook(GroupAIStateBase, "on_criminal_nav_seg_change", "sh_on_criminal_nav_seg_change", function(self, unit)
	local u_sighting = self._criminals[unit:key()]
	if u_sighting then
		mvector3.set(u_sighting.pos, u_sighting.m_det_pos)
	end
end)

-- Make jokers follow their actual owner instead of the closest player
local _determine_objective_for_criminal_AI_original = GroupAIStateBase._determine_objective_for_criminal_AI
function GroupAIStateBase:_determine_objective_for_criminal_AI(unit, ...)
	local logic_data = unit:brain()._logic_data
	if logic_data.is_converted and alive(logic_data.minion_owner) then
		return {
			type = "follow",
			scan = true,
			follow_unit = logic_data.minion_owner,
		}
	end

	return _determine_objective_for_criminal_AI_original(self, unit, ...)
end

-- Adjust objective data for rescue and steal SOs
Hooks:PreHook(GroupAIStateBase, "add_special_objective", "sh_add_special_objective", function(self, id, objective_data)
	if type(id) ~= "string" or not id:match("^carrysteal") and not id:match("^rescue") then
		return
	end

	objective_data.interval = 4
	objective_data.search_dis_sq = 4000000
	objective_data.objective.interrupt_dis = 600
	objective_data.objective.interrupt_health = 0.8
	objective_data.objective.pose = nil
end)

-- Fully count all criminals for the balancing multiplier
function GroupAIStateBase:_get_balancing_multiplier(balance_multipliers)
	return balance_multipliers[math.clamp(table.size(self._char_criminals), 1, #balance_multipliers)]
end

-- Setup sentry marking via host
function GroupAIStateBase:register_marking_sentry(unit)
	if unit:base().sentry_gun and unit:base():has_marking() then
		self._marking_sentries[unit:key()] = unit
		EclipseDebug:log(1, "Marking sentry set!")
	end
end

-- Remove sentries from marking table on destruction
-- Have to work around this bc sh framework :weirdge:
function GroupAIStateBase:unregister_marking_sentry(unit)
	if unit:base().sentry_gun and unit:base():has_marking() then
		self._marking_sentries[unit:key()] = nil
	end
end

-- Do sentry marking if you are the host
Hooks:PostHook(GroupAIStateBase, "update", "eclipse_sentry_update", function(self, t, dt)
	if Network:is_server() then
		for _, sentry in pairs(self._marking_sentries) do
			sentry:base():_update_omniscience(t, dt)
		end
	end
end)
