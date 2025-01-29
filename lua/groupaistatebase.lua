local ffo_heists = Eclipse.ffo_heists

--Peak scripting
function GroupAIStateBase:_get_scripted_tier()
	local diff_rounded = self._difficulty_value >= 1 and 1 or self._difficulty_value < 0.5 and 0 or 0.5
	local index = 1 + (diff_rounded / 0.5)
	local state = managers.groupai:state_name()
	local tier = tweak_data.group_ai[state] and tweak_data.group_ai[state].faction[index]

	return tier or "CS"
end

-- Set up needed variables
Hooks:PostHook(GroupAIStateBase, "_calculate_difficulty_ratio", "eclipse_calculate_difficulty_ratio", function(self)
	for name, script in pairs(managers.mission._scripts) do
		for k, element in pairs(script._elements) do
			if getmetatable(element) == ElementSpawnEnemyDummy then
				local tier = self:_get_scripted_tier()
				local mapped_name = element.enemy_mapping[element._enemy_name:key()]
				local mapped_unit = element.faction_mapping[tier] and element.faction_mapping[tier][mapped_name]

				if type(mapped_unit) == "table" then
					element._enemy_table = mapped_unit
				elseif mapped_unit then
					element._enemy_name = Idstring(mapped_unit)
				end
			end
		end
	end
end)

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

	if ffo_heists[level_id] then
		self._point_of_no_return_timer = self._point_of_no_return_timer - dt
	end

	if self._point_of_no_return_id == -1 or not get_mission_script_element(self._point_of_no_return_id) then
		if self._point_of_no_return_timer <= 0 then
			if Network:is_server() then
				managers.groupai:set_state("ponr")
				LuaNetworking:SendToPeers("sync_assault_ponr", "0")
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
end)

-- Restore scripted cloaker spawn noise
local _process_recurring_grp_SO_original = GroupAIStateBase._process_recurring_grp_SO
function GroupAIStateBase:_process_recurring_grp_SO(...)
	if _process_recurring_grp_SO_original(self, ...) then
		managers.network:session():send_to_peers_synched("group_ai_event", self:get_sync_event_id("cloaker_spawned"), 0)
		managers.hud:post_event("cloaker_spawn")
		return true
	end
end

-- Make difficulty progress smoother
function GroupAIStateBase:_update_difficulty_value()
	if self._target_difficulty and self._t >= self._next_difficulty_step_t then
		self._difficulty_value = math.min(self._difficulty_value + self._difficulty_step, self._target_difficulty)
		if self._difficulty_value >= self._target_difficulty then
			self._target_difficulty = nil
		else
			self._next_difficulty_step_t = self._t + 15
		end
		self:_calculate_difficulty_ratio()
	end
end

local set_difficulty_original = GroupAIStateBase.set_difficulty
function GroupAIStateBase:set_difficulty(value, ...)
	if not managers.game_play_central or managers.game_play_central:get_heist_timer() < 1 or value < self._difficulty_value then
		self._target_difficulty = nil

		return set_difficulty_original(self, value, ...)
	end

	self._difficulty_step = 0.05
	self._target_difficulty = value
	self._next_difficulty_step_t = self._next_difficulty_step_t or self._t

	self:_update_difficulty_value()
end

Hooks:PostHook(GroupAIStateBase, "update", "sh_update", GroupAIStateBase._update_difficulty_value)

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
Hooks:PostHook(GroupAIStateBase, "update", "eclipse_sentry_update", function(self, t, dt)
	if Network:is_server() then
		for _, sentry in pairs(self._marking_sentries) do
			sentry:base():_update_omniscience(t, dt)
		end
	end
end)

-- Add chance for enemies to comment on squad member deaths
Hooks:PostHook(GroupAIStateBase, "_remove_group_member", "sh__remove_group_member", function(self, group, u_key, is_casualty)
	if is_casualty and math.random() < 0.2 then
		self:_chk_say_group(group, "group_death")
	end
end)

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

-- disable ai trades when all players are in custody on pro jobs, if you fucked up - you fucked up
function GroupAIStateBase:is_ai_trade_possible()
	if managers.groupai:state():whisper_mode() then
		return false
	end

	if next(self._player_criminals) then
		return false
	end

	local is_pro = Global.game_settings and Global.game_settings.one_down
	if is_pro then
		return false
	end

	local ai_disabled = true
	for u_key, u_data in pairs(self._ai_criminals) do
		if u_data.status ~= "dead" and u_data.status ~= "disabled" then
			ai_disabled = false

			break
		end
	end

	return not ai_disabled and (self._hostage_headcount > 0 or next(self._converted_police) or managers.trade:is_trading())
end
