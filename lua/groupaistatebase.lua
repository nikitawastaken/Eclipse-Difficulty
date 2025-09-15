local level_id = Eclipse.utils.level_id()
local ffo_heists = Eclipse:require("ffo_heists")

GroupAIStateBase.MEGAPHONE_EVENTS = {
	"mga_deploy_snipers",
	"mga_killed_civ_1st",
	"mga_killed_civ_2nd",
	"mga_hostage_assault_delay",
	"mga_generic_a",
	"mga_generic_b",
	"mga_generic_c",
	"mga_robbers_clever",
	"mga_leave",
}
table.list_append(GroupAIStateBase.EVENT_SYNC, GroupAIStateBase.MEGAPHONE_EVENTS)

Hooks:PostHook(GroupAIStateBase, "on_enemy_weapons_hot", "eclipse_on_enemy_weapons_hot", function(self)
	self._on_enemy_weapons_hot_t = self._on_enemy_weapons_hot_t or self._t
end)

function GroupAIStateBase:_get_scripted_tier()
	local state = managers.groupai and managers.groupai:state_name()

	if not state then
		return "CS"
	end

	local diff_rounded = self._difficulty_value >= 1 and 1 or self._difficulty_value < tweak_data.group_ai.difficulty_curve_points[1] and 0 or 0.5
	local index = 1 + (diff_rounded / 0.5)
	local tier = tweak_data.group_ai[state] and tweak_data.group_ai[state].faction[index]

	return tier or "CS"
end

-- add diff when killing civilians, and track accumulated penalty through mission script diff changes
-- scale scripted spawn tier with current diff value
local _calculate_difficulty_ratio = GroupAIStateBase._calculate_difficulty_ratio
function GroupAIStateBase:_calculate_difficulty_ratio(...)
	_calculate_difficulty_ratio(self, ...)

	local tier = self:_get_scripted_tier()
	if not tier or self._last_scripted_tier == tier then
		return
	end

	for _, script in pairs(managers.mission._scripts) do
		for _, element in pairs(script._elements) do
			self._last_scripted_tier = tier

			if getmetatable(element) == ElementSpawnEnemyDummy then
				local mapped_unit = element:get_replacement_enemy_name(tier)

				if mapped_unit then
					element:replace_enemy_name(mapped_unit)
				end
			end
		end
	end
end

-- Scale gained drama with player count
function GroupAIStateBase:criminal_hurt_drama(unit, attacker, dmg_percent)
	self._drama_data.drama_bal_mul = tweak_data.drama.drama_balance_mul
	local drama_data = self._drama_data
	local drama_player_mul = self:_get_balancing_multiplier(self._drama_data.drama_bal_mul)
	local drama_amount = drama_data.actions.criminal_hurt * dmg_percent * drama_player_mul

	if alive(attacker) then
		local dis_lerp = math.min(1, mvector3.distance(attacker:movement():m_pos(), unit:movement():m_pos()) / drama_data.max_dis)
		dis_lerp = math.lerp(1, drama_data.dis_mul, dis_lerp)
		drama_amount = drama_amount * dis_lerp
	end

	self:_add_drama(drama_amount)
end

-- Code from Dr. Newbie
local _old_update_point_of_no_return = GroupAIStateBase._update_point_of_no_return
function GroupAIStateBase:_update_point_of_no_return(t, dt)
	local get_mission_script_element = function(id)
		for _, script in pairs(managers.mission:scripts()) do
			if script:element(id) then
				return script:element(id)
			end
		end
	end

	if ffo_heists[level_id] then
		self._point_of_no_return_timer = self._point_of_no_return_timer - dt
	end

	if self._point_of_no_return_id == -1 or not get_mission_script_element(self._point_of_no_return_id) then
		if self._point_of_no_return_timer <= 0 then
			if Network:is_server() then
				managers.groupai:set_state("ponr")
				managers.network:session():send_to_peers("sync_assault_ponr")
				self:set_difficulty(1)
			end
			self:remove_point_of_no_return_timer(-1)
		else
			managers.hud:feed_point_of_no_return_timer(self._point_of_no_return_timer)
		end
	else
		_old_update_point_of_no_return(self, t, dt)
	end
end
-- End code from Dr. Newbie

function GroupAIStateBase:chk_allow_drop_in()
	if not self._allow_dropin then
		return false
	end

	return true
end

-- Set up needed variables
Hooks:PostHook(GroupAIStateBase, "init", "eclipse_init", function(self)
	self._next_police_upd_task = 0
	self._next_group_spawn_t = {}
	self._marking_sentries = {}
	self._hiding_cloakers_set_to_assault = {}

	self._mga_hostage_kills = self._mga_hostage_kills or 0
	self._mga_said_hostage_kill_t = self._mga_said_hostage_kill_t or self._t
	self._mga_said_deploy_snipers_t = self._mga_said_deploy_snipers_t or self._t

	self._difficulty_min = tweak_data.group_ai.difficulty_scaling.diff_min or 0
	self._difficulty_max = tweak_data.group_ai.difficulty_scaling.diff_max or 1
	-- New diff curve blocks diff increases (including initializing these variables) until X time after enemy weapons hot
	self._difficulty_value = self._difficulty_value or 0
	self._difficulty_point_index = self._difficulty_point_index or 1
	self._difficulty_ramp = self._difficulty_ramp or 0
end)

-- Add the marksman enemy to special unit types
Hooks:PostHook(GroupAIStateBase, "_init_misc_data", "eclipse_init_misc_data", function(self)
	self._special_unit_types = {
		shield = true,
		medic = true,
		taser = true,
		tank = true,
		spooc = true,
		marksman = true,
	}
end)

Hooks:PostHook(GroupAIStateBase, "on_simulation_started", "eclipse_on_simulation_started", function(self)
	self._special_unit_types = {
		shield = true,
		medic = true,
		taser = true,
		tank = true,
		spooc = true,
		marksman = true,
	}
end)

-- Add megaphone cop lines to specific heists (from Restoration Mod)
function GroupAIStateBase:_post_megaphone_event(event)
	local level_tweak = tweak_data.levels[level_id]

	if not level_tweak then
		return
	end

	if not level_tweak.has_megaphone_cop then
		return
	end

	local pos = level_tweak.megaphone_pos or Vector3(0, 0, 0)
	local sound_source = SoundDevice:create_source("megaphone")

	local mga_voice_line = event
	if type(mga_voice_line) == "table" then
		mga_voice_line = table.random(mga_voice_line)
	end

	sound_source:set_position(pos)
	sound_source:post_event(mga_voice_line)

	if self._is_server then
		local event_id = self:get_sync_event_id(mga_voice_line)
		if event_id then
			managers.network:session():send_to_peers_synched("group_ai_event", event_id, 0)
		end
	end
end

local sync_event_orig = GroupAIStateBase.sync_event
function GroupAIStateBase:sync_event(event_id, ...)
	local event_name = self.EVENT_SYNC[event_id]
	if table.contains(self.MEGAPHONE_EVENTS, event_name) then
		self:_post_megaphone_event(event_name)
		return
	end
	return sync_event_orig(self, event_id, ...)
end

function GroupAIStateBase:megaphone_announce_snipers()
	if not self:enemy_weapons_hot() then
		return
	end

	if self._t >= self._mga_said_deploy_snipers_t then
		self:_post_megaphone_event("mga_deploy_snipers")

		-- Put the "deploy Snipers" line on a cooldown
		self._mga_said_deploy_snipers_t = self._t + 120
	end
end

-- Make difficulty progress smoother
function GroupAIStateBase:_update_difficulty_value()
	if self:enemy_weapons_hot() and self._t >= ((self._on_enemy_weapons_hot_t or 0) + tweak_data.group_ai.difficulty_scaling.assault_delay) then
		if self._target_difficulty and self._t >= self._next_difficulty_step_t then
			local diff_step = tweak_data.group_ai.difficulty_scaling.diff_step * (self._difficulty_value > self._target_difficulty and -1 or 1)

			self._difficulty_value = math.min(self._difficulty_value + diff_step, self._target_difficulty)
			self._difficulty_value = math.clamp(self._difficulty_value, self._difficulty_min, self._difficulty_max)

			if self._difficulty_value >= self._target_difficulty then
				self._target_difficulty = self._difficulty_value
			else
				self._next_difficulty_step_t = self._t
					+ math.lerp(tweak_data.group_ai.difficulty_scaling.diff_step_interval[1], tweak_data.group_ai.difficulty_scaling.diff_step_interval[2], math.random())
			end
			self:_calculate_difficulty_ratio()
		end
	end
end

function GroupAIStateBase:set_difficulty(forced_value)
	self._next_difficulty_step_t = self._next_difficulty_step_t or self._t

	if not self._set_initial_diff then
		self._difficulty_value = 0
		self._target_difficulty = tweak_data.group_ai.difficulty_scaling.diff_init

		self._set_initial_diff = true

		self:_update_difficulty_value()

		return
	end

	if forced_value then
		self._target_difficulty = forced_value

		self:_update_difficulty_value()
	end
end

Hooks:PostHook(GroupAIStateBase, "update", "sh_update", GroupAIStateBase._update_difficulty_value)

function GroupAIStateBase:add_difficulty(value)
	self._target_difficulty = self._target_difficulty + value

	self:_update_difficulty_value()
end

function GroupAIStateBase:min_difficulty(value)
	self._difficulty_min = value or self._difficulty_min

	self:_update_difficulty_value()
end

function GroupAIStateBase:max_difficulty(value)
	self._difficulty_max = value or self._difficulty_max

	self:_update_difficulty_value()
end

--Killing hostages in Pro Jobs increases diff
Hooks:PostHook(GroupAIStateBase, "hostage_killed", "eclipse_hostage_killed", function(self)
	if not self._hunt_mode and self._assault_number and self._assault_number >= 1 then
		self._mga_hostage_kills = self._mga_hostage_kills + 1 -- have to track separately to self._hostages_killed because some may be killed before going loud

		local mga_killed_civ_line = self._mga_hostage_kills == 1 and "mga_killed_civ_1st" or self._mga_hostage_kills < 4 and "mga_killed_civ_2nd" or nil

		if self._t >= self._mga_said_hostage_kill_t and mga_killed_civ_line then
			self:_post_megaphone_event(mga_killed_civ_line)

			-- Put the "civilian killed" line on a cooldown
			self._mga_said_hostage_kill_t = self._t + 5
		end
	end

	local hostage_kill_add = tweak_data.group_ai.difficulty_scaling.hostage_add

	if hostage_kill_add then
		self:add_difficulty(hostage_kill_add)
	end
end)

-- Limit the number of dominated cops to 4 in all cases
function GroupAIStateBase:has_room_for_police_hostage()
	return self._police_hostage_headcount + table.size(self._converted_police) < 4
end

-- Fully count all criminals for the balancing multiplier
function GroupAIStateBase:_get_balancing_multiplier(balance_multipliers)
	return balance_multipliers[math.clamp(table.size(self._char_criminals), 1, #balance_multipliers)]
end

-- Balancing multiplier for players only (used for hostage situation aced)
function GroupAIStateBase:_get_balancing_multiplier_players_only(balance_multipliers)
	return balance_multipliers[math.clamp(table.size(self._player_criminal), 1, #balance_multipliers)]
end

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

	local max_dis = tweak_data.group_ai.spawn_kill_distance or 1500
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

-- Fix this function doing nothing
function GroupAIStateBase:_merge_coarse_path_by_area(coarse_path)
	local i_nav_seg = #coarse_path
	local area, last_area
	while i_nav_seg > 0 and #coarse_path > 2 do
		area = self:get_area_from_nav_seg_id(coarse_path[i_nav_seg][1])
		if last_area and last_area == area then
			table.remove(coarse_path, i_nav_seg)
		else
			last_area = area
		end
		i_nav_seg = i_nav_seg - 1
	end
end

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

function GroupAIStateBase:is_nav_seg_area_safe(skip_areas, nav_seg)
	for _, area in pairs(skip_areas) do
		if area.nav_segs[nav_seg] then
			return true
		end
	end
	return self:is_area_safe(self:get_area_from_nav_seg_id(nav_seg))
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

-- Check for criminals around the unit
function GroupAIStateBase:is_a_criminal_within(mvec_pos, radius)
	local units = World:find_units_quick("sphere", mvec_pos, radius, managers.slot:get_mask("criminals"))

	return units and #units > 1
end

-- Do not update detected position and time on nav segment change
-- Log time when criminals enter an area to use for the teargas check
Hooks:OverrideFunction(GroupAIStateBase, "on_criminal_nav_seg_change", function(self, unit, nav_seg_id)
	local u_key = unit:key()
	local u_sighting = self._criminals[u_key]
	if not u_sighting then
		return
	end

	u_sighting.seg = nav_seg_id

	local prev_area = u_sighting.area
	local area = self:get_area_from_nav_seg_id(nav_seg_id)
	if prev_area ~= area then
		if prev_area and not u_sighting.ai then
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

		if prev_area then
			prev_area.criminal.units[u_key] = nil
		end

		u_sighting.area = area
		area.criminal.units[u_key] = u_sighting
	end

	if area.is_safe then
		area.is_safe = nil
		self:_on_area_safety_status(area, {
			reason = "criminal",
			record = u_sighting,
		})
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

GroupAIStateBase.dynamic_SO_adjustment_funcs = {}

function GroupAIStateBase.dynamic_SO_adjustment_funcs.carrysteal(self, objective_data)
	objective_data.interval = 4
	objective_data.search_dis_sq = 4000000
	objective_data.objective.interrupt_dis = 600
	objective_data.objective.interrupt_health = 0.8
	objective_data.objective.pose = nil
end

function GroupAIStateBase.dynamic_SO_adjustment_funcs.rescue(self, objective_data)
	self.dynamic_SO_adjustment_funcs.carrysteal(self, objective_data)
end

function GroupAIStateBase.dynamic_SO_adjustment_funcs.drill_sabotage(self, objective_data)
	objective_data.access = managers.navigation:convert_access_filter_to_number({ "swat" })
end

-- Adjust objective data for various dynamic SOs
Hooks:PreHook(GroupAIStateBase, "add_special_objective", "eclipse_add_special_objective", function(self, id, objective_data)
	if type(id) ~= "string" then
		return
	end

	for func_id, func in pairs(self.dynamic_SO_adjustment_funcs) do
		if id:match("^" .. tostring(func_id)) then
			func(self, objective_data)
			break
		end
	end
end)

-- Setup sentry marking via host
function GroupAIStateBase:register_marking_sentry(unit)
	if unit:base().sentry_gun and unit:base():has_marking() then
		self._marking_sentries[unit:key()] = unit
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
Hooks:PostHook(GroupAIStateBase, "update", "eclipse_update", function(self, t, dt)
	if Network:is_server() then
		for _, sentry in pairs(self._marking_sentries) do
			sentry:base():_update_omniscience(t, dt)
		end
	end
	self:_update_hiding_cloakers_set_to_assault()
end)

-- Disable drama zones to prevent skipping of anticipation, build and regroup phases
-- The zones are only used for that, which makes the phases inconsistent for no real reason
function GroupAIStateBase:_add_drama(amount)
	self._drama_data.amount = math.clamp(self._drama_data.amount + amount, 0, 1)
	self._drama_data.zone = nil
end

-- Set a minimum gunshot and bullet impact alert range in loud
Hooks:PreHook(GroupAIStateBase, "propagate_alert", "sh_propagate_alert", function(self, alert_data)
	if alert_data[1] == "bullet" and alert_data[3] and self:enemy_weapons_hot() then
		alert_data[3] = math.max(alert_data[3], 800)
	end
end)

-- Spawn events are probably not used anywhere, but for the sake of correctness, fix this function
-- All the functions that call this expect it to return true when it's used
function GroupAIStateBase:_try_use_task_spawn_event(t, target_area, task_type, target_pos, force)
	target_pos = target_pos or target_area.pos

	local max_dis_sq = 3000 ^ 2
	for _, event_data in pairs(self._spawn_events) do
		if (event_data.task_type == task_type or event_data.task_type == "any") and mvec_dis_sq(target_pos, event_data.pos) < max_dis_sq then
			if force or math.random() < event_data.chance then
				self._anticipated_police_force = self._anticipated_police_force + event_data.amount
				self._police_force = self._police_force + event_data.amount
				self:_use_spawn_event(event_data)
				return true
			else
				event_data.chance = math.min(1, event_data.chance + event_data.chance_inc)
			end
		end
	end
end

-- Make this function properly set rescue state again for checking if recon tasks are allowed
Hooks:OverrideFunction(GroupAIStateBase, "_set_rescue_state", function(self, state)
	self._rescue_allowed = state
end)

-- disable ai trades when all players are in custody, if you fucked up - you fucked up
function GroupAIStateBase:is_ai_trade_possible()
	return false
end

-- Overhaul hiding Cloaker task
-- Make it less prone to spamming Cloakers
-- Add a tweakdata limit on the number of hiding Cloaker groups
-- Reduced hide durations - see elementspecialobjectivegroup
-- Cloakers coming out of hiding will eventually get a new hide SO or switch to assaulting - NOT FULLY IMPLEMENTED YET
-- Cloakers getting new hide SOs can be set to not use the same one they just used - NOT IMPLEMENTED YET
-- Spawn noise being used is now a tweakdata flag
-- Idle noise and goggles being on while hiding are now tweakdata flags
local junk_reason_group_nil = "group_nil"
local junk_reason_group_mismatch = "groups_mismatched"
local junk_reason_group_empty = "group_empty"
local junk_reason_no_objective = "no_objective"
local junk_reason_mismatched_objective = "mismatched_objective"
local _process_recurring_grp_SO_original = GroupAIStateBase._process_recurring_grp_SO
function GroupAIStateBase:_process_recurring_grp_SO(recurring_id, data, ...)
	if recurring_id ~= "recurring_cloaker_spawn" then
		return _process_recurring_grp_SO_original(self, recurring_id, data, ...)
	end

	local hiding_cloaker_tweak = self._tweak_data.cloaker
	if not hiding_cloaker_tweak then
		Eclipse:error_console("Hiding Cloaker task tweakdata missing!")
		return _process_recurring_grp_SO_original(self, recurring_id, data, ...)
	end

	data.interval = hiding_cloaker_tweak.interval or data.interval

	if data.groups then
		local junk_groups = self:_evaluate_hiding_cloaker_groups(data.groups, hiding_cloaker_tweak)
		if junk_groups then
			self:_handle_junk_hiding_cloaker_groups(junk_groups, data, hiding_cloaker_tweak)
		end
	end

	return self:_try_spawn_hiding_cloaker(data, hiding_cloaker_tweak)
end

-- Hiding Cloakers switched to assault retire after the assault ends
-- TODO: set to re-hide instead once implemented
function GroupAIStateBase:_update_hiding_cloakers_set_to_assault()
	local hiding_cloakers_set_to_assault = self._hiding_cloakers_set_to_assault
	if not hiding_cloakers_set_to_assault then
		return
	end

	if not self:_should_retire_hiding_cloakers_set_to_assault() then
		return
	end

	for group_id, group in pairs(hiding_cloakers_set_to_assault) do
		self:_retire_hiding_cloaker(group_id, group)
	end
end

-- Assault task is still active during regroup, when other assault groups retire
function GroupAIStateBase:_should_retire_hiding_cloakers_set_to_assault()
	local task_data = self._task_data
	if not task_data then
		return
	end

	local regroup_active = task_data.regroup and task_data.regroup.active
	if regroup_active then
		return true
	end

	local assault_active = task_data.assault and task_data.assault.active
	return not assault_active
end

function GroupAIStateBase:_retire_hiding_cloaker(group_id, group)
	self._hiding_cloakers_set_to_assault[group_id] = nil
	self:_assign_group_to_retire(group)
	Eclipse:log_console(string.format('Set assaulting "hide" Cloaker group to retire: %s', group_id))
end

function GroupAIStateBase:_get_hiding_cloaker_SO(elements, last_element, hiding_cloaker_tweak)
	if last_element then
		local min_elements = math.max(2, hiding_cloaker_tweak.avoid_repeat_hiding_spots_min_elements or 2)
		if #elements < min_elements or hiding_cloaker_tweak.avoid_repeat_hiding_spots == false then
			last_element = nil
		end
	end

	local total_w = 0
	for _, element in ipairs(elements) do
		if not last_element or last_element ~= element then
			total_w = total_w + element:value("base_chance")
		end
	end

	local rand_w = total_w * math.random()
	for _, element in ipairs(elements) do
		if not last_element or last_element ~= element then
			rand_w = rand_w - element:value("base_chance")

			if rand_w <= 0 then
				return element
			end
		end
	end

	Eclipse:error_console("GroupAIStateBase:_get_hiding_cloaker_SO() had no return, picking element at random!")
	return table.random(elements)
end

function GroupAIStateBase:_evaluate_hiding_cloaker_groups(groups, hiding_cloaker_tweak)
	local junk_groups = nil
	local hide_retry_delay = hiding_cloaker_tweak.hide_retry_delay or {
		10,
		20,
	}

	for group_id, group in pairs(groups) do
		if not group.objective.hide_retry_delay then
			group.objective.hide_retry_delay = math.lerp(hide_retry_delay[1], hide_retry_delay[2], math.random())
		end

		if group.has_spawned then
			local junk_reason = nil
			if not self._groups[group_id] then
				junk_reason = junk_reason_group_nil
			elseif self._groups[group_id] ~= group then
				junk_reason = junk_reason_group_mismatch
			end

			if not junk_reason then
				junk_reason = junk_reason_group_empty
				for u_key, unit_data in pairs(group.units) do
					junk_reason = junk_reason_no_objective
					local objective = unit_data.unit:brain():objective()
					if not objective then
						-- Nothing, probably waiting to be assigned
					elseif objective.grp_objective == group.objective then
						junk_reason = nil
						break
					else
						junk_reason = junk_reason_mismatched_objective
					end
				end

				if junk_reason then
					if group.objective.fail_t then
						local retry_delay = tonumber(group.objective.hide_retry_delay) or hide_retry_delay[1]
						if self._t - group.objective.fail_t < retry_delay then
							-- Eclipse:log_console(string.format("Retry delay has not expired for hiding Cloaker %s", group_id))
							junk_reason = nil
						else
							Eclipse:log_console(string.format("Retry delay expired for hiding Cloaker %s", group_id))
						end
					else
						Eclipse:log_console(string.format("Objective failed for hiding Cloaker %s", group_id))
						group.objective.fail_t = self._t
						junk_reason = nil
					end
				elseif group.objective.fail_t then
					Eclipse:log_console(string.format("Hiding Cloaker %s is no longer junk", group_id))
					group.objective.fail_t = nil
				end
			end

			if junk_reason then
				Eclipse:log_console(string.format("Found junk hiding Cloaker %s: %s", group_id, junk_reason))
				junk_groups = junk_groups or {}
				junk_groups[group_id] = junk_reason
			end
		end
	end

	return junk_groups
end

-- Reasons not in this table are valid for rehide/switch to assault
local remove_group_reasons = table.list_to_set({
	junk_reason_group_nil,
	junk_reason_group_mismatch,
	junk_reason_group_empty,
})

-- TODO: figure out rehiding
function GroupAIStateBase:_handle_junk_hiding_cloaker_groups(junk_groups, data, hiding_cloaker_tweak)
	local assault_chance = hiding_cloaker_tweak.assault_on_objective_failed_chance or 0.5
	local retire_instead_of_assault = self:_should_retire_hiding_cloakers_set_to_assault()
	for group_id, junk_reason in pairs(junk_groups) do
		local assault = assault_chance == 1 or math.random() < assault_chance
		local group = data.groups[group_id]
		if not group or remove_group_reasons[junk_reason] then
			data.groups[group_id] = nil
		elseif assault then
			data.groups[group_id] = nil
			if retire_instead_of_assault then
				self:_retire_hiding_cloaker(group_id, group)
			else
				Eclipse:log_console(string.format("Hiding Cloaker %s set to assault", group_id))
				local _, leader_data = self._determine_group_leader(group.units)
				local new_objective = {
					moving_out = group.objective.moving_out,
					area = leader_data.assigned_area,
					type = "assault_area",
				}
				self:_set_objective_to_enemy_group(group, new_objective)
				self._hiding_cloakers_set_to_assault[group_id] = group
			end
		else
			data.groups[group_id] = nil
			self:_retire_hiding_cloaker(group_id, group)
		end
	end

	-- Unsure why this is in vanilla
	if not next(data.groups) then
		data.groups = nil
	end

	-- Vanilla thing, disabled - don't delay spawns because of junk Cloaker groups
	-- data.delay_t = math.max(data.delay_t, self._t + math.lerp(data.interval[1], data.interval[2], math.random()))
end

-- _spawn_in_group() still returns a new group even if the Cloaker limit is reached
function GroupAIStateBase:_try_spawn_hiding_cloaker(data, hiding_cloaker_tweak)
	if self._t < data.delay_t then
		return
	end

	local cloaker_limit = managers.job:current_spawn_limit("spooc") or -math.huge
	local active_cloakers = self:_get_special_unit_type_count("spooc") or math.huge
	if active_cloakers >= cloaker_limit then
		-- Eclipse:log_console("Too many alive Cloakers")
		return
	end

	local simultaneous_hiding_limit = hiding_cloaker_tweak.simultaneous_hiding_limit or 1
	if data.groups and table.size(data.groups) >= simultaneous_hiding_limit then
		-- Eclipse:log_console("Too many hiding Cloakers")
		return
	end

	local element = self:_get_hiding_cloaker_SO(data.elements, nil, hiding_cloaker_tweak)
	local grp_objective = element:get_grp_objective()
	local spawn_group, spawn_group_type = self:_find_spawn_group_near_area(grp_objective.area, hiding_cloaker_tweak.groups, element:value("position"), nil, nil)
	if not spawn_group then
		Eclipse:log_console("No spawn group")
		return
	end

	local new_group = self:_spawn_in_group(spawn_group, spawn_group_type, grp_objective, nil)
	if new_group then
		data.groups = data.groups or {}
		data.groups[new_group.id] = new_group
		new_group.last_element = element

		if hiding_cloaker_tweak.use_spawn_noise ~= false then
			managers.network:session():send_to_peers_synched("group_ai_event", self:get_sync_event_id("cloaker_spawned"), 0)
			managers.hud:post_event("cloaker_spawn")
		end
	end

	data.delay_t = math.max(data.delay_t, self._t + math.lerp(data.interval[1], data.interval[2], math.random()))

	return new_group and true
end
