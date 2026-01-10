local level_id = Eclipse.utils.level_id()

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

Hooks:PreHook(GroupAIStateBase, "on_enemy_weapons_hot", "eclipse_on_enemy_weapons_hot", function(self)
	if self._ai_enabled and not self._enemy_weapons_hot then
		self._next_difficulty_step_t = self._t + tweak_data.group_ai.difficulty_scaling.assault_delay
		self:add_difficulty(tweak_data.group_ai.difficulty_scaling.diff_init)
	end
end)

function GroupAIStateBase:_get_scripted_tier()
	local scripted_tiers = self._tweak_data and self._tweak_data.scripted_tiers
	if not scripted_tiers then
		return "CS"
	end

	local diff = self._difficulty_value or 0
	local curve_point = tweak_data.group_ai.difficulty_curve_points[1] or 0.5
	local index = diff >= 1 and 3 or diff >= curve_point and 2 or 1
	local tier = scripted_tiers[index]

	return tier or "CS"
end

-- add diff when killing civilians, and track accumulated penalty through mission script diff changes
-- scale scripted spawn tier with current diff value
function GroupAIStateBase:update_scripted_spawn_tiers()
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

Hooks:PostHook(GroupAIStateBase, "_calculate_difficulty_ratio", "eclipse__calculate_difficulty_ratio", GroupAIStateBase.update_scripted_spawn_tiers)

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

	if self._point_of_no_return_id == -1 or not get_mission_script_element(self._point_of_no_return_id) then
		self._point_of_no_return_timer = self._point_of_no_return_timer - dt
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
	self._deployable_nav_segs = {}

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

-- Add a function to check if a deployble is within a nav_seg
function GroupAIStateBase:chk_deployable_nav_seg(nav_seg_id)
	return self._deployable_nav_segs[nav_seg_id]
end

-- Add megaphone cop lines to specific heists (from Restoration Mod)
function GroupAIStateBase:_post_megaphone_event(event)
	local level_tweak = tweak_data.levels[level_id]

	if not level_tweak then
		return
	end

	if not level_tweak.has_megaphone_cop then
		return
	end

	if not self:enemy_weapons_hot() then
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
	if self._t >= self._mga_said_deploy_snipers_t then
		self:_post_megaphone_event("mga_deploy_snipers")

		-- Put the "deploy Snipers" line on a cooldown
		self._mga_said_deploy_snipers_t = self._t + 120
	end
end

-- Make difficulty progress smoother
function GroupAIStateBase:_update_difficulty_value()
	-- No difficulty updates during stealth
	if not self:enemy_weapons_hot() then
		return
	-- Check for difficulty min/max clamps if one was set after the last diff step
	elseif self._next_difficulty_step_t and self._t < self._next_difficulty_step_t then
		if self._check_difficulty_clamps then
			self._check_difficulty_clamps = nil
			self._difficulty_value = self:_get_clamped_difficulty(self._difficulty_value)
			self:_calculate_difficulty_ratio()
		end
		return
	end

	self._check_difficulty_clamps = nil
	self._next_difficulty_step_t = self._t + math.lerp(tweak_data.group_ai.difficulty_scaling.diff_step_interval[1], tweak_data.group_ai.difficulty_scaling.diff_step_interval[2], math.random())

	local is_decrease = self._difficulty_value > self._target_difficulty
	local clamp_func = is_decrease and math.max or math.min
	local diff_step = tweak_data.group_ai.difficulty_scaling.diff_step * (is_decrease and -1 or 1)
	local new_diff = clamp_func(self._difficulty_value + diff_step, self._target_difficulty)
	self._difficulty_value = self:_get_clamped_difficulty(new_diff)
	self:_calculate_difficulty_ratio()
end

Hooks:PostHook(GroupAIStateBase, "update", "eclipse_update", GroupAIStateBase._update_difficulty_value)

-- Final diff can be extremely slightly off from the target when using math.clamp, floating point shenanigans
-- Unsure if "works funny on my machine" moment, 0.4 ~= 0.4000696969 as expected but sometimes 0.4 ~= 0.4 apparently anyway
function GroupAIStateBase:_get_clamped_difficulty(value)
	value = value or self._difficulty_value
	if value > self._difficulty_max then
		value = self._difficulty_max
	elseif value < self._difficulty_min then
		value = self._difficulty_min
	end
	return value
end

function GroupAIStateBase:set_difficulty(value)
	self._target_difficulty = value
	self:_update_difficulty_value()
end

function GroupAIStateBase:add_difficulty(value)
	self._target_difficulty = self._target_difficulty + value
	self:_update_difficulty_value()
end

function GroupAIStateBase:min_difficulty(value)
	self._difficulty_min = value or self._difficulty_min
	self._check_difficulty_clamps = true
	self:_update_difficulty_value()
end

function GroupAIStateBase:max_difficulty(value)
	self._difficulty_max = value or self._difficulty_max
	self._check_difficulty_clamps = true
	self:_update_difficulty_value()
end

-- Killing hostages in Pro Jobs increases diff
Hooks:PostHook(GroupAIStateBase, "hostage_killed", "eclipse_hostage_killed", function(self)
	if not alive(killer_unit) then
		return
	end

	if killer_unit:base() and killer_unit:base().thrower_unit then
		killer_unit = killer_unit:base():thrower_unit()
		if not alive(killer_unit) then
			return
		end
	end

	local criminal = self._criminals[killer_unit:key()]
	if not criminal then
		return
	end

	if not self._hunt_mode and self._assault_number and self._assault_number >= 1 then
		self._mga_hostage_kills = self._mga_hostage_kills + 1 -- have to track separately to self._hostages_killed because some may be killed before going loud

		local mga_killed_civ_line = self._mga_hostage_kills == 1 and "mga_killed_civ_1st" or self._mga_hostage_kills < 4 and "mga_killed_civ_2nd" or nil

		if self._t >= self._mga_said_hostage_kill_t and mga_killed_civ_line then
			self:_post_megaphone_event(mga_killed_civ_line)

			-- Put the "civilian killed" line on a cooldown
			self._mga_said_hostage_kill_t = self._t + 5
		end
	end

	local hostage_kill_add = tweak_data.group_ai.difficulty_scaling.hostage_kill_add

	if hostage_kill_add then
		self:add_difficulty(hostage_kill_add)
	end
end)

-- Limit the number of dominated cops to 4 in all cases
function GroupAIStateBase:has_room_for_police_hostage()
	return self._police_hostage_headcount + table.size(self._converted_police) < 4
end

-- Delay spawn points when enemies die close to them
Hooks:PostHook(GroupAIStateBase, "on_enemy_unregistered", "sh_on_enemy_unregistered", function(self, unit)
	if Network:is_client() or not unit:character_damage():dead() then
		return
	end

	local e_data = self._police[unit:key()]
	if not e_data.group or not e_data.group.has_spawned or not e_data.spawn_group then
		return
	end

	local dis = mvector3.distance(e_data.spawn_group.pos, e_data.m_pos)
	local max_dis = tweak_data.group_ai.spawn_kill_max_dis
	if dis > max_dis then
		return
	end

	local delay_t = self._t + math.map_range(dis, 0, max_dis, tweak_data.group_ai.spawn_kill_cooldown, 0)
	e_data.spawn_group.delay_t = math.max(e_data.spawn_group.delay_t, delay_t)
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
	objective_data.objective.interrupt_dis = 800
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
-- Make it less prone to spamming Cloakers (tweakdata delay is applied on spawn, not when junk groups are found)
-- Add a tweakdata limit on the number of hiding Cloaker groups
-- Reduced hide durations - see elementspecialobjectivegroup
-- Cloakers coming out of hiding will eventually get a new hide SO or switch to assaulting
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
	if not hiding_cloaker_tweak or not tweak_data.group_ai.use_reworked_cloaker_task then
		if _process_recurring_grp_SO_original(self, recurring_id, data, ...) then
			managers.network:session():send_to_peers_synched("group_ai_event", self:get_sync_event_id("cloaker_spawned"), 0)
			managers.hud:post_event("cloaker_spawn")
			return true
		end
		return
	end

	data.interval = hiding_cloaker_tweak.interval or data.interval

	if data.groups then
		local junk_groups = self:_evaluate_hiding_cloaker_groups(data, hiding_cloaker_tweak)
		if junk_groups then
			self:_handle_junk_hiding_cloaker_groups(junk_groups, data, hiding_cloaker_tweak)
		end
	end

	return self:_try_spawn_hiding_cloaker(data, hiding_cloaker_tweak)
end

-- Prioritize hide SOs near criminals rather than picking at complete random
function GroupAIStateBase:_get_hiding_cloaker_SO(data, group, hiding_cloaker_tweak)
	if not data.followups or #data.followups == 0 then
		return
	end

	local repeat_hiding_spots = hiding_cloaker_tweak.repeat_hiding_spots or {
		avoid = true,
		min_elements = 3,
		min_distance = 1500,
	}
	local last_element = group and group.last_element
	if not repeat_hiding_spots.avoid or #data.followups < repeat_hiding_spots.min_elements then
		last_element = nil
	end
	local last_element_pos = last_element and last_element:value("position")

	local SO_weighting = hiding_cloaker_tweak.SO_weighting or {
		near_distance = 1000,
		far_distance = 3000,
		far_chance_mul = 0.1,
		too_far_distance = 5000,
		too_close_distance = 1000,
	}
	local element_weights = {}
	local total_w = 0
	local criminal_pos = self:_get_units_center_pos(self:all_char_criminals())
	local pos_is_zero = not criminal_pos or mvector3.is_zero(criminal_pos)

	local function should_continue(element, element_pos, so_grp)
		if not element then
			Eclipse:warn_console("Nil element in _get_hiding_cloaker_SO()! SO group ID: " .. (so_grp and so_grp:id() or "missing"))
			return true
		elseif not element_pos then
			Eclipse:warn_console("Nil element pos in _get_hiding_cloaker_SO()! Element ID: " .. (element:id() or "missing") .. " SO group ID: " .. (so_grp and so_grp:id() or "missing"))
			return true
		elseif last_element and last_element == element then
			return true
		elseif last_element_pos and mvector3.distance(element_pos, last_element_pos) < repeat_hiding_spots.min_distance then
			return true
		elseif not data.groups then
			return false
		end

		for _, grp in pairs(data.groups) do
			if grp ~= group and grp.last_element == element then
				return true
			end
		end
	end

	local function collect_element_weights(skip_ignore_distances)
		for _, followup_data in ipairs(data.followups) do
			local element, element_w, so_grp = followup_data[1], followup_data[2], followup_data[3]
			local element_pos = element:value("position")
			if should_continue(element, element_pos, so_grp) then
				goto __continue
			end

			if pos_is_zero then
				table.insert(element_weights, { element, element_w })
				total_w = total_w + element_w
			else
				local element_dis = mvector3.distance(criminal_pos, element_pos)
				if skip_ignore_distances or SO_weighting.too_far_distance > element_dis and SO_weighting.too_close_distance < element_dis then
					element_w = math.map_range_clamped(element_dis, SO_weighting.near_distance, SO_weighting.far_distance, element_w, element_w * SO_weighting.far_chance_mul)
					table.insert(element_weights, { element, element_w })
					total_w = total_w + element_w
				end
			end

			::__continue::
		end
	end

	collect_element_weights()
	if #element_weights == 0 then
		last_element, last_element_pos = nil
		collect_element_weights(true)
	end

	local rand_w = total_w * math.random()
	for _, weight_data in ipairs(element_weights) do
		rand_w = rand_w - weight_data[2]
		if rand_w <= 0 then
			return weight_data[1]
		end
	end
end

function GroupAIStateBase:_evaluate_hiding_cloaker_groups(data, hiding_cloaker_tweak)
	local junk_groups = nil
	local hide_retry_delay = hiding_cloaker_tweak.hide_retry_delay or { 10, 20 }

	for group_id, group in pairs(data.groups) do
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
				for _, u_data in pairs(group.units) do
					junk_reason = junk_reason_no_objective
					local objective = u_data.unit:brain():objective()
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
							-- Eclipse:log_console(string.format("Retry delay expired for hiding Cloaker %s", group_id))
						end
					else
						-- Eclipse:log_console(string.format("Objective failed for hiding Cloaker %s", group_id))
						group.objective.fail_t = self._t
						junk_reason = nil
					end
				elseif group.objective.fail_t then
					-- Eclipse:log_console(string.format("Hiding Cloaker %s is no longer junk", group_id))
					group.objective.fail_t = nil
				end
			end

			if junk_reason then
				-- Eclipse:log_console(string.format("Found junk hiding Cloaker %s: %s", group_id, junk_reason))
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

function GroupAIStateBase:_handle_junk_hiding_cloaker_groups(junk_groups, data, hiding_cloaker_tweak)
	for group_id, junk_reason in pairs(junk_groups) do
		local group = data.groups[group_id]
		local assault = group and ((group.rehide_attempts or 0) >= (group.max_rehide_attempts or 0))
		if not group or remove_group_reasons[junk_reason] then
			data.groups[group_id] = nil
		elseif assault then
			self:_reassign_hiding_cloaker(data, group_id, group, hiding_cloaker_tweak)
		else
			self:_rehide_hiding_cloaker(data, group_id, group, hiding_cloaker_tweak)
		end
	end

	if not next(data.groups) then
		data.groups = nil
	end

	-- Vanilla thing, disabled - don't delay spawns because of junk Cloaker groups
	-- data.delay_t = math.max(data.delay_t, self._t + math.lerp(data.interval[1], data.interval[2], math.random()))
end

-- _spawn_in_group() still returns a new group even if the group cannot actually spawn
-- TODO: detach hiding Cloakers from regular Cloaker spawn limits while hiding
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

	local so_element = self:_get_hiding_cloaker_SO(data, nil, hiding_cloaker_tweak)
	if not so_element then
		-- Eclipse:log_console("No SO element")
		return
	end

	local grp_objective = so_element:get_grp_objective()
	local spawn_group, spawn_group_type = self:_find_spawn_group_near_area(grp_objective.area, hiding_cloaker_tweak.groups, so_element:value("position"), nil, nil)
	if not spawn_group then
		-- Eclipse:log_console("No spawn group")
		return
	end

	local new_group = self:_spawn_in_group(spawn_group, spawn_group_type, grp_objective, nil)
	if new_group then
		local max_rehide_attempts = hiding_cloaker_tweak.max_rehide_attempts or { 0, 3 }
		data.groups = data.groups or {}
		data.groups[new_group.id] = new_group
		new_group.hiding_cloaker_data = data
		new_group.last_element = so_element
		new_group.rehide_attempts = 0
		new_group.max_rehide_attempts = math.random(max_rehide_attempts[1], max_rehide_attempts[2])

		if hiding_cloaker_tweak.use_spawn_noise ~= false then
			managers.network:session():send_to_peers_synched("group_ai_event", self:get_sync_event_id("cloaker_spawned"), 0)
			managers.hud:post_event("cloaker_spawn")
		end

		self:_delay_new_hiding_cloakers(data, data.interval)
	end

	return new_group and true
end

function GroupAIStateBase:_delay_new_hiding_cloakers(data, time_tbl)
	time_tbl = time_tbl or data.interval or { 20, 40 }
	data.delay_t = math.max(data.delay_t, self._t + math.rand(time_tbl[1], time_tbl[2]))
end

function GroupAIStateBase:_retire_hiding_cloaker(data, group_id, group, hiding_cloaker_tweak)
	data.groups[group_id] = nil
	self:_delay_new_hiding_cloakers(data, hiding_cloaker_tweak.group_removed_delay_t or { 2, 7 })
	self:_assign_group_to_retire(group)
end

function GroupAIStateBase:_reassign_hiding_cloaker(data, group_id, group, hiding_cloaker_tweak)
	local group_center_pos = self:_get_units_center_pos(group.units)
	local no_join_groups = hiding_cloaker_tweak.no_join_groups or {}
	local function try_reassign_to_task(obj_type)
		local grps = {}
		for grp_id, grp in pairs(self._groups) do
			if not data.groups[grp_id] and not no_join_groups[grp.type] and grp.objective.type == obj_type then
				table.insert(grps, grp)
			end
		end

		local new_grp = self:_get_closest_group(group_center_pos, grps)
		if new_grp then
			data.groups[group_id] = nil
			self:_delay_new_hiding_cloakers(data, hiding_cloaker_tweak.group_removed_delay_t or { 2, 7 })
			for u_key, u_data in pairs(group.units) do
				self:unit_leave_group(u_data.unit, false)
				self:_add_group_member(new_grp, u_key)
			end
			return true
		end
	end

	local ordered_obj_types = {
		"assault_area",
		-- "recon_area",
		-- "reenforce_area",
	}
	for _, obj_type in ipairs(ordered_obj_types) do
		if try_reassign_to_task(obj_type) then
			return true
		end
	end

	self:_retire_hiding_cloaker(data, group_id, group, hiding_cloaker_tweak)
	return false
end

-- interrupt_health being set before assignment can cause the objective to fail immediately if the Cloaker was damaged
-- Set it only after assignment so the Cloaker hides again but is also interrupted by any new damage
function GroupAIStateBase:_rehide_hiding_cloaker(data, group_id, group, hiding_cloaker_tweak)
	local so_element = self:_get_hiding_cloaker_SO(data, group, hiding_cloaker_tweak)
	if not so_element then
		self:_retire_hiding_cloaker(data, group_id, group, hiding_cloaker_tweak)
		return false
	end

	group.last_element = so_element
	local grp_objective = so_element:get_grp_objective()
	self:_set_objective_to_enemy_group(group, grp_objective)

	for u_key, u_data in pairs(group.units) do
		local objective = so_element:get_random_SO(u_data.unit)
		if not objective then
			self:_retire_hiding_cloaker(data, group_id, group, hiding_cloaker_tweak)
			return false
		end

		objective.interrupt_health = nil
		objective.grp_objective = grp_objective

		local u_brain = u_data.unit:brain()
		if u_brain:objective() and not u_brain:is_available_for_assignment(objective) then
			u_brain:set_followup_objective(objective)
		else
			self:set_enemy_assigned(objective.area or grp_objective.area, u_key)

			if objective.element then
				objective.element:clbk_objective_administered(u_data.unit)
			end

			u_brain:set_objective(objective)
		end
		objective.interrupt_health = u_data.unit:character_damage():health_ratio() - 0.01

		local u_objective = u_brain:objective()
		if not u_objective or (u_objective ~= objective and u_objective.followup_objective ~= objective) then
			self:_retire_hiding_cloaker(data, group_id, group, hiding_cloaker_tweak)
			return false
		end
	end

	group.rehide_attempts = (group.rehide_attempts or 0) + 1

	return true
end

-- _remove_group_member() returns true if the group was emptied
Hooks:PostHook(GroupAIStateBase, "_remove_group_member", "eclipse__remove_group_member", function(self, group, _, is_casualty)
	local data = is_casualty and Hooks:GetReturn() and group.hiding_cloaker_data
	if data and data.delay_t then
		local hiding_cloaker_tweak = self._tweak_data.cloaker
		self:_delay_new_hiding_cloakers(data, hiding_cloaker_tweak and hiding_cloaker_tweak.group_removed_delay_t or { 2, 7 })
	end
end)

-- Make getting individual SOs for hiding Cloakers easier
Hooks:PostHook(GroupAIStateBase, "_process_grp_SO", "eclipse__process_grp_SO", function(self, grp_so_id, element)
	local grp_SO_data = self._recurring_grp_SO and self._recurring_grp_SO[element:value("mode")]
	if not grp_SO_data then
		return
	end

	local followup_elements = element:value("followup_elements")
	if not followup_elements then
		return
	end

	local base_chance = element:value("base_chance")
	for _, id in ipairs(followup_elements) do
		local followup = element:get_mission_element(id)
		if followup then
			grp_SO_data.followups = grp_SO_data.followups or {}
			table.insert(grp_SO_data.followups, { followup, followup:chance() * base_chance, element })
		end
	end
end)

-- Vanilla code doesn't seem to properly support removing SO groups
-- Add it here for hiding Cloaker use
Hooks:PostHook(GroupAIStateBase, "remove_grp_SO", "eclipse_remove_grp_SO", function(self, id)
	local element = managers.mission:get_element_by_id(id)
	if not element then
		return
	end

	local grp_SO_data = self._recurring_grp_SO and self._recurring_grp_SO[element:value("mode")]
	if not grp_SO_data then
		return
	end

	if grp_SO_data.elements then
		for i, elmnt in table.reverse_ipairs(grp_SO_data.elements) do
			if elmnt == element then
				table.remove(grp_SO_data.elements, i)
			end
		end
	end

	if grp_SO_data.followups then
		for i, followup_data in table.reverse_ipairs(grp_SO_data.followups) do
			if followup_data[3] == element then
				table.remove(grp_SO_data.followups, i)
			end
		end
	end
end)

function GroupAIStateBase:_distance_to_units_center(from_pos, units, as_square)
	local mvec_func = as_square and mvector3.distance_sq or mvector3.distance
	return mvec_func(from_pos, self:_get_units_center_pos(units))
end

-- Adapted from GroupAIStateBesiege:_draw_enemy_activity(...)
-- Use with an enemy group's units, or GroupAI's criminals tables
function GroupAIStateBase:_get_units_center_pos(units)
	local center_pos = Vector3()
	local nr_units = 0
	for _, u_data in pairs(units) do
		local movement_ext = alive(u_data.unit) and u_data.unit:movement()
		if movement_ext and movement_ext.m_pos then
			nr_units = nr_units + 1
			mvector3.add(center_pos, movement_ext:m_pos())
		end
	end
	if nr_units > 1 then
		mvector3.divide(center_pos, nr_units)
	end
	return center_pos
end

function GroupAIStateBase:_get_closest_group(from_pos, groups)
	local best_group, best_group_dis
	for _, group in pairs(groups) do
		local group_dis = self:_distance_to_units_center(from_pos, group.units)
		if not best_group or group_dis < best_group_dis then
			best_group = group
			best_group_dis = group_dis
		end
	end
	return best_group, best_group_dis
end
