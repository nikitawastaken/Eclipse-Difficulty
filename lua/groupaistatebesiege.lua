local mvec_add = mvector3.add
local mvec_cpy = mvector3.copy
local mvec_dir = mvector3.direction
local mvec_dis = mvector3.distance
local mvec_dis_sq = mvector3.distance_sq
local mvec_lerp = mvector3.lerp
local mvec_mul = mvector3.multiply
local mvec_set = mvector3.set
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()

-- Move the hostage hesitation delay to control instead of anticipation
local _begin_assault_task_original = GroupAIStateBesiege._begin_assault_task
function GroupAIStateBesiege:_begin_assault_task(...)
	self._task_data.assault.was_first = self._task_data.assault.is_first

	_begin_assault_task_original(self, ...)

	if self._hostage_headcount > 0 then
		local assault_task = self._task_data.assault
		local anticipation_duration = self:_get_anticipation_duration(self._tweak_data.assault.anticipation_duration, assault_task.was_first)
		assault_task.phase_end_t = self._t + anticipation_duration
	end
end

Hooks:PostHook(GroupAIStateBesiege, "_end_regroup_task", "eclipse_end_regroup_task", function(self)
	local assault_task = self._task_data.assault
	if self._hostage_headcount > 0 then
		local hesitation_delay = self:_get_difficulty_dependent_value(self._tweak_data.assault.hostage_hesitation_delay)
		local hostage_situation = managers.player:upgrade_value("team", "hostage_situation", 0)
		local hostage_multiplier = math.clamp(self._hostage_headcount, 1, 4)
		assault_task.is_hesitating = true
		if assault_task.next_dispatch_t then
			assault_task.voice_delay = assault_task.next_dispatch_t - self._t
			assault_task.next_dispatch_t = assault_task.next_dispatch_t + (hesitation_delay + hostage_situation) * hostage_multiplier
		end
	end
end)

-- Fix reenforce group delay
local _begin_reenforce_task_original = GroupAIStateBesiege._begin_reenforce_task
function GroupAIStateBesiege:_begin_reenforce_task(...)
	local next_dispatch_t = self._task_data.reenforce.next_dispatch_t or 0

	_begin_reenforce_task_original(self, ...)

	self._task_data.reenforce.next_dispatch_t = next_dispatch_t
end

-- Old fade behavior but less abusable
local _upd_assault_task_original = GroupAIStateBesiege._upd_assault_task
function GroupAIStateBesiege:_upd_assault_task(...)
	local task_data = self._task_data.assault
	local t = self._t

	if not task_data.active then
		return
	end

	if task_data.phase ~= "fade" or self._hunt_mode then
		return _upd_assault_task_original(self, ...)
	end

	self:_assign_recon_groups_to_retire()

	local end_assault = false
	local enemies_left = self:_count_police_force("assault")

	if not self._hunt_mode then
		local min_enemies_left = 7

		if enemies_left < min_enemies_left or task_data.phase_end_t + 100 < t then
			if task_data.phase_end_t - 8 < t and not task_data.said_retreat then
				if self._drama_data.amount < tweak_data.drama.assault_fade_end then
					task_data.said_retreat = true

					self:_police_announce_retreat()
				end
			elseif task_data.phase_end_t < t and self._drama_data.amount < tweak_data.drama.assault_fade_end and self:_count_criminals_engaged_force(5) <= 4 then
				end_assault = true
			end
		end

		if task_data.force_end or end_assault then
			task_data.active = nil
			task_data.phase = nil
			task_data.said_retreat = nil
			task_data.force_end = nil
			local force_regroup = task_data.force_regroup
			task_data.force_regroup = nil

			if self._draw_drama then
				self._draw_drama.assault_hist[#self._draw_drama.assault_hist][2] = t
			end

			managers.mission:call_global_event("end_assault")
			self:_begin_regroup_task(force_regroup)
			return
		end
	end

	if self._drama_data.amount <= tweak_data.drama.low then
		for criminal_key, criminal_data in pairs(self._player_criminals) do
			self:criminal_spotted(criminal_data.unit)

			for _, group in pairs(self._groups) do
				if group.objective.charge then
					for _, u_data in pairs(group.units) do
						u_data.unit:brain():clbk_group_member_attention_identified(nil, criminal_key)
					end
				end
			end
		end
	end

	local primary_target_area = task_data.target_areas[1]
	if self:is_area_safe_assault(primary_target_area) then
		local target_pos = primary_target_area.pos
		local nearest_area, nearest_dis

		for _, criminal_data in pairs(self._player_criminals) do
			if not criminal_data.status then
				local dis = mvec_dis_sq(target_pos, criminal_data.m_pos)

				if not nearest_dis or dis < nearest_dis then
					nearest_dis = dis
					nearest_area = self:get_area_from_nav_seg_id(criminal_data.tracker:nav_segment())
				end
			end
		end

		if nearest_area then
			primary_target_area = nearest_area
			task_data.target_areas[1] = nearest_area
		end
	end

	if task_data.use_smoke_timer < self._t then
		task_data.use_smoke = true
	end

	self:detonate_queued_smoke_grenades()

	self:_assign_enemy_groups_to_assault(task_data.phase)
end

-- Improve reenforce task handling to allow dynamic scaling of dispatch times
function GroupAIStateBesiege:_upd_reenforce_tasks()
	local reenforce_tasks = self._task_data.reenforce.tasks
	local overshot_groups = {}
	local undershot_tasks = {}

	-- Check reenforce tasks
	for i = #reenforce_tasks, 1, -1 do
		local task_data = reenforce_tasks[i]
		local force_settings = task_data.target_area.factors.force
		local force_required = force_settings and force_settings.force or 0
		local force_occupied = 0

		local occupied_groups = {}
		for _, group in pairs(self._groups) do
			if (group.objective.target_area or group.objective.area) == task_data.target_area and group.objective.type == "reenforce_area" then
				local size = group.has_spawned and group.size or group.initial_size
				force_occupied = force_occupied + size
				table.insert(occupied_groups, {
					group = group,
					size = size,
				})
			end
		end

		if force_occupied > force_required then
			table.sort(occupied_groups, function(a, b)
				return a.size < b.size
			end)
			for _, group_data in pairs(occupied_groups) do
				force_occupied = force_occupied - group_data.size
				if force_occupied < force_required then
					break
				else
					table.insert(overshot_groups, group_data.group)
				end
			end
		elseif force_occupied < force_required then
			if not self._task_data.regroup.active and self._task_data.assault.phase ~= "fade" and self:is_area_safe(task_data.target_area) then
				table.insert(undershot_tasks, task_data)
			end
		end

		if force_required == 0 then
			table.remove(reenforce_tasks, i)
		end
	end

	-- Handle areas that need reenforce
	for _, task_data in pairs(undershot_tasks) do
		local overshot_group = table.remove(overshot_groups)
		if overshot_group then
			overshot_group.objective.target_area = task_data.target_area
		elseif self._task_data.reenforce.next_dispatch_t < self._t then
			local spawned

			if task_data.use_spawn_event then
				task_data.use_spawn_event = false
				spawned = self:_try_use_task_spawn_event(self._t, task_data.target_area, "reenforce")
			end

			if not spawned and not next(self._spawning_groups) then
				local spawn_group, spawn_group_type = self:_find_spawn_group_near_area(task_data.target_area, self._tweak_data.reenforce.groups)
				if spawn_group then
					self:_spawn_in_group(spawn_group, spawn_group_type, {
						attitude = "avoid",
						scan = true,
						pose = "stand",
						type = "reenforce_area",
						stance = "hos",
						area = spawn_group.area,
						target_area = task_data.target_area,
					})
					spawned = true
				end
			end

			-- Adjust next reinforce dispatch time based on the amount of tasks still needed
			if spawned then
				self._task_data.reenforce.next_dispatch_t = self._t + self:_get_difficulty_dependent_value(self._tweak_data.reenforce.interval) / #undershot_tasks
				break
			end
		else
			break
		end
	end

	-- Retire overshot groups
	for _, group in pairs(overshot_groups) do
		if group.has_spawned then
			self:_assign_group_to_retire(group)
		end
	end

	self:_assign_enemy_groups_to_reenforce()
end

-- Improve in_place check to prevent enemy groups from getting stuck
-- Moved these functions that were all pretty much identical to a helper function
function GroupAIStateBesiege:_assign_enemy_groups_to_assault(phase)
	self:_assign_enemy_groups_to_task(phase, "assault_area", self._set_assault_objective_to_group)
end

function GroupAIStateBesiege:_assign_enemy_groups_to_recon(phase)
	self:_assign_enemy_groups_to_task(phase, "recon_area", self._set_recon_objective_to_group)
end

function GroupAIStateBesiege:_assign_enemy_groups_to_reenforce(phase)
	self:_assign_enemy_groups_to_task(phase, "reenforce_area", self._set_reenforce_objective_to_group)
end

function GroupAIStateBesiege:_assign_enemy_groups_to_task(phase, objective_type, objective_func)
	for _, group in pairs(self._groups) do
		if group.has_spawned and group.objective.type == objective_type then
			if group.objective.moving_out then
				local done_moving

				for _, u_data in pairs(group.units) do
					local objective = u_data.unit:brain():objective()
					if objective and objective.grp_objective == group.objective then
						if objective.in_place then
							done_moving = true
						else
							done_moving = false
							break
						end
					end
				end

				if done_moving then
					group.objective.moving_out = nil
					group.in_place_t = self._t
					group.objective.moving_in = nil
					self:_voice_move_complete(group)
				end
			end

			if not group.objective.moving_in then
				objective_func(self, group, phase)
			end
		end
	end
end

-- Improve and heavily simplify objective assignment code, fix pull back and open fire objectives
-- Basically, a lot of this function was needlessly complex and had oversights or incorrect conditions
Hooks:OverrideFunction(GroupAIStateBesiege, "_set_assault_objective_to_group", function(self, group, phase)
	local phase_is_anticipation = phase == "anticipation"
	local current_objective = group.objective
	local approach, open_fire, pull_back
	local obstructed_area = self:_chk_group_areas_tresspassed(group)
	local group_leader_u_key, group_leader_u_data = self._determine_group_leader(group.units)
	local tactics_map = group_leader_u_data and group_leader_u_data.tactics_map or {}
	local in_place_duration = group.in_place_t and self._t - group.in_place_t or 0
	local objective_area = current_objective.area

	-- Clear objective tactic if it no longer fits
	if current_objective.tactic and not tactics_map[current_objective.tactic] then
		current_objective.tactic = nil
	end

	-- Check deathguard
	if tactics_map.deathguard and not phase_is_anticipation then
		if current_objective.tactic == "deathguard" then
			local u_data = alive(current_objective.follow_unit) and self._char_criminals[current_objective.follow_unit:key()]
			if u_data and u_data.status and u_data.status ~= "electrified" and current_objective.area.nav_segs[u_data.seg] then
				return
			end
		end

		local closest_crim_u_data
		local closest_crim_dis_sq = math.huge
		for _, u_data in pairs(self._char_criminals) do
			if u_data.status then
				local _, _, closest_u_dis_sq = self._get_closest_group_unit_to_pos(u_data.m_pos, group.units)
				if closest_u_dis_sq and closest_u_dis_sq < closest_crim_dis_sq then
					closest_crim_u_data = u_data
					closest_crim_dis_sq = closest_u_dis_sq
				end
			end
		end

		if closest_crim_u_data then
			local coarse_path = managers.navigation:search_coarse({
				id = "GroupAI_deathguard",
				from_tracker = group_leader_u_data.tracker,
				to_tracker = closest_crim_u_data.tracker,
				access_pos = self._get_group_acces_mask(group),
			})

			if coarse_path then
				self:_voice_deathguard_start(group)
				self:_set_objective_to_enemy_group(group, {
					distance = 800,
					type = "assault_area",
					attitude = "engage",
					pose = "stand",
					tactic = "deathguard",
					moving_in = true,
					follow_unit = closest_crim_u_data.unit,
					area = self:get_area_from_nav_seg_id(coarse_path[#coarse_path][1]),
					coarse_path = coarse_path,
				})
				return
			end
		end
	end

	if current_objective.open_fire then
		if not current_objective.moving_out and (tactics_map.charge or not tactics_map.ranged_fire or in_place_duration > 10) then
			approach = not self:_can_group_see_target(group)
		end
	else
		local spotter_u_data
		if phase_is_anticipation or obstructed_area or tactics_map.ranged_fire then
			spotter_u_data = self:_can_group_see_target(group, tactics_map.flank and "optimal" or "far")
		end
		if spotter_u_data then
			if obstructed_area then
				if phase_is_anticipation then
					pull_back = true
				else
					objective_area = obstructed_area
					open_fire = true
				end
			else
				objective_area = self:get_area_from_nav_seg_id(spotter_u_data.tracker:nav_segment())
				open_fire = true
			end
		elseif not current_objective.moving_out then
			approach = true
		end
	end

	if open_fire then
		self:_chk_say_group(group, "open_fire")
		self:_set_objective_to_enemy_group(group, {
			attitude = "engage",
			pose = "stand",
			type = "assault_area",
			stance = "hos",
			open_fire = true,
			tactic = current_objective.tactic,
			area = objective_area,
			coarse_path = {
				{
					objective_area.pos_nav_seg,
					mvector3.copy(objective_area.pos),
				},
			},
		})
	elseif approach then
		local assault_area, assault_path, assault_from
		local to_search_areas = {
			objective_area,
		}
		local found_areas = {
			[objective_area] = objective_area,
		}
		local group_access_mask = self._get_group_acces_mask(group)
		local flank_chance = 2 -- First is shortest path to criminal, second is first actual flank path

		repeat
			local search_area = table.remove(to_search_areas, 1)
			if not self:is_area_safe_assault(search_area) then
				local flank = tactics_map.flank and found_areas[search_area] ~= objective_area
				if not flank or math.random() < flank_chance then
					local new_assault_path = managers.navigation:search_coarse({
						id = "GroupAI_assault",
						from_seg = objective_area.pos_nav_seg,
						to_seg = flank and found_areas[search_area].pos_nav_seg or search_area.pos_nav_seg,
						access_pos = group_access_mask,
						verify_clbk = callback(self, self, "is_nav_seg_safe"),
					})

					if new_assault_path then
						self:_merge_coarse_path_by_area(new_assault_path)
						assault_path = new_assault_path
						assault_area = search_area
						assault_from = found_areas[search_area]

						if flank then
							found_areas[search_area] = nil
							flank_chance = flank_chance * 0.5
						else
							break
						end
					end
				end
			else
				for _, other_area in pairs(search_area.neighbours) do
					if not found_areas[other_area] then
						table.insert(to_search_areas, other_area)
						found_areas[other_area] = search_area
					end
				end
			end
		until #to_search_areas == 0

		if assault_area and assault_path then
			local push = assault_from == objective_area

			if push then
				if tactics_map.no_push then
					return
				end

				if phase_is_anticipation then
					if self._hostage_headcount > 0 then
						self:_chk_say_group(group, "hostage_delay")
					end
					return
				end

				local detonate_pos
				local c_key = tactics_map.charge and table.random_key(assault_area.criminal.units)
				if c_key then
					detonate_pos = mvec_cpy(assault_area.criminal.units[c_key].m_pos)
				end

				-- Check which grenade to use to push, grenade use is required for the push to be initiated
				-- If grenade isn't available, push regardless anyway after a short delay
				if not self:_chk_group_use_grenade(assault_area, group, detonate_pos) then
					if not group.ignore_grenade_check_t then
						local delay = tweak_data.group_ai.no_grenade_push_delay * (tactics_map.charge and 0.66 or 1)
						group.ignore_grenade_check_t = self._t + math.map_range_clamped(table.size(assault_area.criminal.units), 1, 4, delay, delay * 0.75)
						return
					elseif group.ignore_grenade_check_t > self._t then
						return
					end
				end
			else
				-- If we aren't pushing, we go to one area before the criminal area
				if #assault_path > 2 and assault_area.nav_segs[assault_path[#assault_path][1]] then
					table.remove(assault_path)
				end
				assault_area = assault_from
			end

			if not assault_area.hostages or not self:_chk_say_group(group, "watch_background") then
				if flank_chance >= 1 or not self:_chk_say_group(group, "flank") then
					self:_chk_say_group(group, push and "push" or "go_go")
				end
			end

			self:_set_objective_to_enemy_group(group, {
				type = "assault_area",
				stance = "hos",
				area = assault_area,
				coarse_path = assault_path,
				pose = push and "crouch" or "stand",
				attitude = push and "engage" or "avoid",
				moving_in = push,
				open_fire = push,
				pushed = push,
				charge = tactics_map.charge,
				interrupt_dis = tactics_map.charge and 0,
			})
		elseif not current_objective.assigned_t and in_place_duration > 15 and not self:_can_group_see_target(group) then
			-- Log and remove groups that get stuck
			local element_id = group.spawn_group_element and group.spawn_group_element._id or 0
			local element_name = group.spawn_group_element and group.spawn_group_element._editor_name or ""
			Eclipse:warn(string.format("Group %s spawned from element %u (%s) is stuck, removing it!", group.id, element_id, element_name))

			for _, u_data in pairs(group.units) do
				u_data.unit:brain():set_active(false)
				u_data.unit:set_slot(0)
			end
		end
	elseif pull_back then
		local retreat_area
		for _, u_data in pairs(group.units) do
			local nav_seg_id = u_data.tracker:nav_segment()
			if self:is_nav_seg_safe(nav_seg_id) then
				retreat_area = self:get_area_from_nav_seg_id(nav_seg_id)
				break
			end
		end

		if not retreat_area and current_objective.coarse_path then
			local forwardmost_i_nav_point = self:_get_group_forwardmost_coarse_path_index(group)
			if forwardmost_i_nav_point then
				-- Try retreating to the previous coarse path nav point
				local nav_point = current_objective.coarse_path[forwardmost_i_nav_point - 1] or current_objective.coarse_path[forwardmost_i_nav_point]
				retreat_area = self:get_area_from_nav_seg_id(nav_point[1])
			end
		end

		if retreat_area then
			self:_set_objective_to_enemy_group(group, {
				attitude = "avoid",
				stance = "hos",
				pose = "crouch",
				type = "assault_area",
				area = retreat_area,
				open_fire = true,
				coarse_path = {
					{
						retreat_area.pos_nav_seg,
						mvector3.copy(retreat_area.pos),
					},
				},
			})
		end
	end
end)

-- Helper to check if any group member has visuals on their focus target
function GroupAIStateBesiege:_can_group_see_target(group, limit_range)
	local preferred_range = math.huge
	if limit_range then
		for _, u_data in pairs(group.units) do
			local internal_data = u_data.unit:brain()._logic_data.internal_data
			local weapon_range = internal_data and internal_data.weapon_range
			preferred_range = math.min(preferred_range, weapon_range and weapon_range[limit_range] or 3000)
		end
	end

	for _, u_data in pairs(group.units) do
		local logic_data = u_data.unit:brain()._logic_data
		if logic_data.objective and logic_data.objective.grp_objective == group.objective then
			local focus_enemy = logic_data.attention_obj
			if focus_enemy and focus_enemy.verified and focus_enemy.reaction > AIAttentionObject.REACT_AIM then
				if not limit_range or focus_enemy.dis < preferred_range then
					return u_data
				end
			end
		end
	end
end

-- Add custom grenade usage function
function GroupAIStateBesiege:_chk_group_use_grenade(assault_area, group, detonate_pos)
	local task_data = self._task_data.assault
	if not task_data.use_smoke then
		return
	end

	local grenade_types = {
		smoke_grenade = (not task_data.smoke_grenade_next_t or task_data.smoke_grenade_next_t < self._t) or nil,
		flash_grenade = (not task_data.flash_grenade_next_t or task_data.flash_grenade_next_t < self._t) or nil,
	}
	local grenade_candidates = {}
	for grenade_type, _ in pairs(grenade_types) do
		for _, u_data in pairs(group.units) do
			if u_data.tactics_map and u_data.tactics_map[grenade_type] then
				table.insert(grenade_candidates, { grenade_type, u_data })
			end
		end
	end

	if #grenade_candidates == 0 then
		return
	end

	local grenade_type, grenade_user = unpack(table.random(grenade_candidates))

	local door_pos
	local detonate_offset, detonate_offset_pos = tmp_vec1, tmp_vec2
	local nav_seg = managers.navigation._nav_segments[grenade_user.tracker:nav_segment()]
	for neighbour_nav_seg_id, door_list in pairs(nav_seg.neighbours) do
		if assault_area.nav_segs[neighbour_nav_seg_id] then
			local random_door_id = door_list[math.random(#door_list)]
			if type(random_door_id) == "number" then
				door_pos = managers.navigation._room_doors[random_door_id].center
			else
				door_pos = random_door_id:script_data().element:nav_link_end_pos()
			end
			break
		end
	end

	-- Offset grenade a bit to avoid spawning exactly on the player/door
	if detonate_pos and grenade_type == "flash_grenade" then
		mvec_dir(detonate_offset, detonate_pos, door_pos or grenade_user.m_pos)
		mvec_mul(detonate_offset, math.random(200, 400))
	elseif door_pos then
		detonate_pos = door_pos
		mvec_dir(detonate_offset_pos, detonate_pos, assault_area.pos)
		mvec_mul(detonate_offset_pos, math.random(50, 150))
		mvec_dir(detonate_offset, grenade_user.m_pos, assault_area.pos)
		mvec_mul(detonate_offset, math.random(150))
		mvec_add(detonate_offset, detonate_offset_pos)
	else
		return
	end

	mvec_set(detonate_offset_pos, detonate_pos)
	mvec_add(detonate_offset_pos, detonate_offset)

	-- If players camp a specific area for too long, turn a smoke grenade into a teargas grenade instead
	local use_teargas
	if grenade_type == "smoke_grenade" and not assault_area.hostages and assault_area.criminal_entered_t and table.size(assault_area.neighbours) <= 2 then
		local teargas_chance_times = tweak_data.group_ai.cs_grenade_chance_times or { 60, 240 }
		local teargas_chance = math.map_range(self._t - assault_area.criminal_entered_t, teargas_chance_times[1], teargas_chance_times[2], 0, 1)
		if math.random() < teargas_chance then
			local teargas_pos = managers.navigation:find_random_position_in_segment(assault_area.pos_nav_seg)
			mvec_lerp(detonate_offset_pos, teargas_pos, assault_area.pos, 0.75)

			local c_key = table.random_key(assault_area.criminal.units)
			if c_key then
				mvec_lerp(detonate_offset_pos, detonate_offset_pos, assault_area.criminal.units[c_key].m_pos, 0.5)
			end

			assault_area.criminal_entered_t = assault_area.criminal_entered_t - teargas_chance_times[2]
			use_teargas = true
		end
	end

	-- Make sure the grenade stays inside AI navigation (on the ground)
	local grenade_tracker = managers.navigation:create_nav_tracker(detonate_offset_pos)
	detonate_pos = grenade_tracker:field_position()
	managers.navigation:destroy_nav_tracker(grenade_tracker)

	local timeout
	if use_teargas then
		self:detonate_cs_grenade(detonate_pos, mvec_cpy(grenade_user.m_pos), tweak_data.group_ai.cs_grenade_lifetime or 10)

		timeout = tweak_data.group_ai.cs_grenade_timeout or tweak_data.group_ai.smoke_and_flash_grenade_timeout
	else
		if grenade_type == "flash_grenade" and grenade_user.char_tweak.chatter.flash_grenade then
			self:chk_say_enemy_chatter(grenade_user.unit, grenade_user.m_pos, "flash_grenade")
		elseif grenade_type == "smoke_grenade" and grenade_user.char_tweak.chatter.smoke then
			self:chk_say_enemy_chatter(grenade_user.unit, grenade_user.m_pos, "smoke")
		end

		self:detonate_smoke_grenade(detonate_pos, mvec_cpy(grenade_user.m_pos), tweak_data.group_ai[grenade_type .. "_lifetime"] or 10, grenade_type == "flash_grenade", false)

		timeout = tweak_data.group_ai[grenade_type .. "_timeout"] or tweak_data.group_ai.smoke_and_flash_grenade_timeout
	end

	task_data.use_smoke = false
	-- Minimum grenade cooldown
	task_data.use_smoke_timer = self._t + tweak_data.group_ai.min_grenade_timeout
	-- Individual grenade cooldowns
	task_data[grenade_type .. "_next_t"] = self._t + math.lerp(timeout[1], timeout[2], math.random())

	return true
end

-- Keep recon groups around during anticipation
-- Making them retreat only afterwards gives them more time to complete their objectives
local _assign_recon_groups_to_retire_original = GroupAIStateBesiege._assign_recon_groups_to_retire
function GroupAIStateBesiege:_assign_recon_groups_to_retire(...)
	if not self._rescue_allowed then
		return _assign_recon_groups_to_retire_original(self, ...)
	end
end

-- Tweak importance of spawn group distance in spawn group weight based on the groups to spawn
-- Also slightly optimized this function to properly check all areas
function GroupAIStateBesiege:_find_spawn_group_near_area(target_area, allowed_groups, target_pos, max_dis, verify_clbk)
	target_pos = target_pos or target_area.pos
	max_dis = max_dis or math.huge

	local t = self._t
	local valid_spawn_groups = {}
	local valid_spawn_group_distances = {}
	local shortest_dis = math.huge
	local longest_dis = -math.huge

	for _, area in pairs(self._area_data) do
		local spawn_groups = area.spawn_groups
		if spawn_groups then
			for _, spawn_group in ipairs(spawn_groups) do
				if spawn_group.delay_t <= t and (not verify_clbk or verify_clbk(spawn_group)) then
					local dis_id = tostring(spawn_group.nav_seg) .. "-" .. tostring(target_area.pos_nav_seg)

					if not self._graph_distance_cache[dis_id] then
						local path = managers.navigation:search_coarse({
							access_pos = "swat",
							from_seg = spawn_group.nav_seg,
							to_seg = target_area.pos_nav_seg,
							id = dis_id,
						})

						if path and #path >= 2 then
							local dis = 0
							local current = spawn_group.pos
							for i = 2, #path do
								local nxt = path[i][2]
								if current and nxt then
									dis = dis + mvec_dis(current, nxt)
								end
								current = nxt
							end
							self._graph_distance_cache[dis_id] = dis
						end
					end

					local my_dis = self._graph_distance_cache[dis_id]
					if my_dis and my_dis < max_dis then
						local spawn_group_id = spawn_group.mission_element:id()
						valid_spawn_groups[spawn_group_id] = spawn_group
						valid_spawn_group_distances[spawn_group_id] = my_dis
						shortest_dis = my_dis < shortest_dis and my_dis or shortest_dis
						longest_dis = my_dis > longest_dis and my_dis or longest_dis
					end
				end
			end
		end
	end

	if not next(valid_spawn_group_distances) then
		return
	end

	local total_weight = 0
	local candidate_groups = {}
	local low_weight = allowed_groups == self._tweak_data.reenforce.groups and 0.1 or allowed_groups == self._tweak_data.recon.groups and 0.4 or 0.7
	local single_choice = longest_dis == shortest_dis
	for i, dis in pairs(valid_spawn_group_distances) do
		local my_wgt = single_choice and 1 or math.map_range(dis, shortest_dis, longest_dis, 1, low_weight)
		local my_spawn_group = valid_spawn_groups[i]
		local my_group_types = my_spawn_group.mission_element:spawn_groups()
		my_spawn_group.distance = dis
		total_weight = total_weight + self:_choose_best_groups(candidate_groups, my_spawn_group, my_group_types, allowed_groups, my_wgt)
	end

	if total_weight == 0 then
		return
	end

	return self:_choose_best_group(candidate_groups, total_weight)
end

-- Reorder task updates so groups that have finished spawning immediately get their objectives instead of waiting for the next update
function GroupAIStateBesiege:_upd_police_activity()
	if self._police_activity_blocked or not self._ai_enabled then
		return
	end

	self:_upd_SO()
	self:_upd_grp_SO()

	if not self._enemy_weapons_hot then
		return
	end

	self:_claculate_drama_value()

	self:_check_spawn_phalanx()
	self:_check_phalanx_group_has_spawned()
	self:_check_phalanx_damage_reduction_increase()

	-- Do _upd_group_spawning and _begin_new_tasks before the various task updates
	self:_upd_group_spawning()
	self:_begin_new_tasks()
	self:_upd_regroup_task()
	self:_upd_reenforce_tasks()
	self:_upd_recon_tasks()
	self:_upd_assault_task()
	self:_upd_groups()
end

-- Update police activity in consistent intervals
-- Don't use the task queue for it since this function is called in GroupAIStateBesiege:update anyways
function GroupAIStateBesiege:_queue_police_upd_task()
	if self._t >= self._next_police_upd_task then
		self._next_police_upd_task = self._t + 1
		self:_upd_police_activity()
	end
end

-- Overhaul group spawning and fix forced group spawns not actually forcing the entire group to spawn
-- Group spawning now always spawns the entire group at once but uses a cooldown that prevents any group spawns of the same type for a short duration
-- The special limit check is now done earlier to prevent groups that can't actually spawn from being picked and wasting a spawn cycle
function GroupAIStateBesiege:force_spawn_group(group, group_types, guarantee)
	if not self._ai_enabled then
		return
	end

	local best_groups = {}
	local total_weight = self:_choose_best_groups(best_groups, group, group_types, self._tweak_data[self._task_data.assault.active and "assault" or "recon"].groups, 1)
	if total_weight <= 0 and not guarantee then
		return
	end

	local spawn_group, spawn_group_type = self:_choose_best_group(best_groups, total_weight or 1)
	if not spawn_group then
		return
	end

	local grp_objective = {
		attitude = "avoid",
		stance = "hos",
		pose = "crouch",
		type = "assault_area",
		area = spawn_group.area,
		coarse_path = {
			{
				spawn_group.area.pos_nav_seg,
				spawn_group.area.pos,
			},
		},
	}

	if self:_spawn_in_group(spawn_group, spawn_group_type, grp_objective) then
		self:_perform_group_spawning(self._spawning_groups[#self._spawning_groups], true)
	end
end

function GroupAIStateBesiege:_is_spawn_task_type_on_cooldown(spawn_task)
	local group_objective_type = spawn_task.group.objective.type
	return self._next_group_spawn_t[group_objective_type] and self._next_group_spawn_t[group_objective_type] > self._t
end

function GroupAIStateBesiege:_set_spawn_task_type_cooldown(spawn_task, cooldown)
	local group_objective_type = spawn_task.group.objective.type
	self._next_group_spawn_t[group_objective_type] = self._t + cooldown
end

function GroupAIStateBesiege:_upd_group_spawning()
	for _, spawn_task in ipairs(self._spawning_groups) do
		if spawn_task.group.size > 0 or not self:_is_spawn_task_type_on_cooldown(spawn_task) then
			self:_perform_group_spawning(spawn_task)
			return
		end
	end
end

function GroupAIStateBesiege:_perform_group_spawning(spawn_task, force)
	local produce_data = {
		name = true,
		spawn_ai = {},
	}
	local unit_categories = tweak_data.group_ai.unit_categories
	local current_unit_type = tweak_data.levels:get_ai_group_type()
	local skip_delays = force or spawn_task.group.size > 0

	local function _try_spawn_unit(u_type_name, spawn_entry)
		local u_category = unit_categories[u_type_name]
		if not u_category then
			Eclipse:error("Unit category %s does not exist", u_type_name)
			return true
		end

		local hopeless = true
		for _, sp_data in ipairs(spawn_task.spawn_group.spawn_pts) do
			local has_access = sp_data.accessibility == "any" or u_category.access[sp_data.accessibility]
			if has_access and (not sp_data.amount or sp_data.amount > 0) and sp_data.mission_element:enabled() then
				hopeless = false

				if (skip_delays and sp_data.delay_t - sp_data.interval or sp_data.delay_t) < self._t then
					produce_data.name = table.random(u_category.unit_types[current_unit_type])
					produce_data.name = managers.modifiers:modify_value("GroupAIStateBesiege:SpawningUnit", produce_data.name)

					local spawned_unit = sp_data.mission_element:produce(produce_data)

					local objective
					if spawn_task.objective then
						objective = self.clone_objective(spawn_task.objective)
					else
						objective = spawn_task.group.objective.element:get_random_SO(spawned_unit)

						if not objective then
							spawned_unit:set_slot(0)
							return true
						end

						objective.grp_objective = spawn_task.group.objective
					end

					local u_key = spawned_unit:key()
					local u_data = self._police[u_key]

					self:set_enemy_assigned(objective.area, u_key)

					if spawn_entry.tactics then
						u_data.tactics = spawn_entry.tactics
						u_data.tactics_map = table.list_to_set(spawn_entry.tactics)
					end

					spawned_unit:brain():set_spawn_entry(spawn_entry, u_data.tactics_map)

					u_data.rank = spawn_entry.rank

					self:_add_group_member(spawn_task.group, u_key)

					if spawned_unit:brain():is_available_for_assignment(objective) then
						if objective.element then
							objective.element:clbk_objective_administered(spawned_unit)
						end
						spawned_unit:brain():set_objective(objective)
					else
						spawned_unit:brain():set_followup_objective(objective)
					end

					if spawn_task.ai_task then
						spawn_task.ai_task.force_spawned = spawn_task.ai_task.force_spawned + 1
						spawned_unit:brain()._logic_data.spawned_in_phase = spawn_task.ai_task.phase
					end

					sp_data.delay_t = self._t + sp_data.interval

					if sp_data.amount then
						sp_data.amount = sp_data.amount - 1
					end

					return true
				end
			end
		end

		if hopeless then
			Eclipse:warn("Spawn group %s failed to spawn unit %s", spawn_task.spawn_group.id, u_type_name)
			return true
		end
	end

	-- Try spawning units that are picky about their access first
	for u_type_name, spawn_info in pairs(spawn_task.units_remaining) do
		if not unit_categories[u_type_name].access.acrobatic then
			for _ = spawn_info.amount, 1, -1 do
				if _try_spawn_unit(u_type_name, spawn_info.spawn_entry) then
					spawn_info.amount = spawn_info.amount - 1
				else
					break
				end
			end
		end
	end

	local complete = true
	for u_type_name, spawn_info in pairs(spawn_task.units_remaining) do
		for _ = spawn_info.amount, 1, -1 do
			if _try_spawn_unit(u_type_name, spawn_info.spawn_entry) then
				spawn_info.amount = spawn_info.amount - 1
			else
				complete = false
				break
			end
		end
	end

	-- If there are still units to spawn, return and try spawning the rest in the next call
	if not complete then
		return
	end

	table.delete(self._spawning_groups, spawn_task)

	spawn_task.group.has_spawned = true
	if spawn_task.group.size <= 0 then
		self._groups[spawn_task.group.id] = nil
	end

	-- Set a dynamic enemy spawnrate that scales with player count and difficulty value
	local spawn_rate_player_mul = self:_get_balancing_multiplier(self._tweak_data.assault.spawnrate_balance_mul)
	local spawn_rate = self:_get_difficulty_dependent_value(self._tweak_data.assault.spawnrate)
	self:_set_spawn_task_type_cooldown(spawn_task, spawn_task.group.size * spawn_rate * spawn_rate_player_mul)
end

local function spawn_group_id(spawn_group)
	return spawn_group.mission_element:id()
end

function GroupAIStateBesiege:_choose_best_group(best_groups, total_weight)
	local rand_wgt = total_weight * math.random()
	local best_grp, best_grp_type = nil

	for i, candidate in ipairs(best_groups) do
		rand_wgt = rand_wgt - candidate.wght

		if rand_wgt <= 0 then
			-- fuck u240.3 (prob not setting it back to 15, 20 though cause i already reduced spawns after the update)
			-- https://imgur.com/a/v9T4mwq
			self._spawn_group_timers[spawn_group_id(candidate.group)] = TimerManager:game():time() + math.random(10, 15)

			best_grp = candidate.group
			best_grp_type = candidate.group_type
			best_grp.delay_t = self._t + best_grp.interval

			break
		end
	end

	return best_grp, best_grp_type
end

function GroupAIStateBesiege:_spawn_in_group(spawn_group, spawn_group_type, grp_objective, ai_task)
	local spawn_group_desc = tweak_data.group_ai.enemy_spawn_groups[spawn_group_type]

	local wanted_nr_units
	if type(spawn_group_desc.amount) == "number" then
		wanted_nr_units = spawn_group_desc.amount
	else
		wanted_nr_units = math.random(spawn_group_desc.amount[1], spawn_group_desc.amount[2])
	end

	local valid_unit_types = deep_clone(spawn_group_desc.spawn)
	local total_weight = 0
	local group_size = 0
	local spawn_task = {
		objective = not grp_objective.element and self._create_objective_from_group_objective(grp_objective),
		units_remaining = {},
		spawn_group = spawn_group,
		spawn_group_type = spawn_group_type,
		ai_task = ai_task,
	}

	table.insert(self._spawning_groups, spawn_task)

	local function _add_unit_type_to_spawn_task(i, spawn_entry)
		local add_amount = 1
		if spawn_entry.amount_min then
			add_amount = math.max(spawn_entry.amount_min, add_amount)
			spawn_entry.amount_min = nil
		end

		if wanted_nr_units < add_amount then
			add_amount = wanted_nr_units
			Eclipse:warn("Can not satisfy amount_min for unit category %s in spawn group type %s", spawn_entry.unit, spawn_group_type)
		end

		spawn_task.units_remaining[spawn_entry.unit] = spawn_task.units_remaining[spawn_entry.unit] or {
			amount = 0,
			spawn_entry = spawn_entry,
		}
		spawn_task.units_remaining[spawn_entry.unit].amount = spawn_task.units_remaining[spawn_entry.unit].amount + add_amount

		group_size = group_size + add_amount
		wanted_nr_units = wanted_nr_units - add_amount

		if spawn_entry.amount_max then
			if add_amount >= spawn_entry.amount_max then
				table.remove(valid_unit_types, i)
				total_weight = total_weight - spawn_entry.freq
				return true
			else
				spawn_entry.amount_max = spawn_entry.amount_max - add_amount
			end
		end
	end

	local i = 1
	while wanted_nr_units > 0 and i <= #valid_unit_types do
		local spawn_entry = valid_unit_types[i]

		total_weight = total_weight + spawn_entry.freq

		local entry_removed = spawn_entry.amount_min and spawn_entry.amount_min > 0 and _add_unit_type_to_spawn_task(i, spawn_entry)
		if not entry_removed then
			i = i + 1
		end
	end

	local unit_categories = tweak_data.group_ai.unit_categories
	while wanted_nr_units > 0 and #valid_unit_types > 0 do
		local roll = math.random() * total_weight
		local rand_entry

		i = 1
		repeat
			rand_entry = valid_unit_types[i]
			roll = roll - rand_entry.freq
			i = i + 1
		until roll <= 0

		local cat_data = unit_categories[rand_entry.unit]
		local special_type = cat_data and not cat_data.is_captain and cat_data.special_type
		if special_type and managers.job:current_spawn_limit(special_type) <= self:_get_special_unit_type_count(special_type) then
			table.remove(valid_unit_types, i - 1)
			total_weight = total_weight - rand_entry.freq
		else
			_add_unit_type_to_spawn_task(i - 1, rand_entry)
		end
	end

	local group = self:_create_group({
		size = group_size,
		type = spawn_group_type,
	})

	group.objective = grp_objective
	group.objective.moving_out = true
	group.team = self._teams[spawn_group.team_id or tweak_data.levels:get_default_team_ID("combatant")]
	group.spawn_group_element = spawn_group.mission_element

	spawn_task.group = group

	return group
end

function GroupAIStateBesiege:_choose_best_groups(best_groups, group, group_types, allowed_groups, weight)
	local total_weight = 0
	local spawn_groups = tweak_data.group_ai.enemy_spawn_groups
	local unit_categories = tweak_data.group_ai.unit_categories

	for _, group_type in ipairs(group_types) do
		local spawn_group_desc = spawn_groups[group_type]
		local cat_weights = allowed_groups[group_type]
		if spawn_group_desc and cat_weights then
			for _, spawn_entry in ipairs(spawn_group_desc.spawn) do
				local cat_data = unit_categories[spawn_entry.unit]
				local special_type = cat_data and not cat_data.is_captain and cat_data.special_type
				if special_type and managers.job:current_spawn_limit(special_type) < self:_get_special_unit_type_count(special_type) + (spawn_entry.amount_min or 0) then
					cat_weights = nil
					break
				end
			end

			if cat_weights then
				local cat_weight = self:_get_difficulty_dependent_value(cat_weights)
				local mod_weight = weight * cat_weight

				table.insert(best_groups, {
					group = group,
					group_type = group_type,
					wght = mod_weight,
					cat_weight = cat_weight,
					dis_weight = weight,
				})

				total_weight = total_weight + mod_weight
			end
		end
	end

	return total_weight
end

-- Make a generic group voice function instead of individual ones and make retiring groups play retreat lines
function GroupAIStateBesiege:_chk_say_group(group, chatter_type)
	for _, unit_data in pairs(group.units) do
		if unit_data.char_tweak.chatter[chatter_type] and not unit_data.unit:brain():is_current_logic("intimidated") then
			if self:chk_say_enemy_chatter(unit_data.unit, unit_data.m_pos, chatter_type) then
				return true
			end
		end
	end
end

Hooks:PostHook(GroupAIStateBesiege, "_assign_group_to_retire", "sh__assign_group_to_retire", function(self, group)
	if not group.said_retreat then
		group.said_retreat = self:_chk_say_group(group, "retreat")
	end
end)

-- When scripted spawns are assigned to group ai, use a generic group type instead of using their category as type
-- This ensures they are not retired immediatley cause they are not part of assault/recon group types
Hooks:OverrideFunction(GroupAIStateBesiege, "assign_enemy_to_group_ai", function(self, unit, team_id)
	local area = self:get_area_from_nav_seg_id(unit:movement():nav_tracker():nav_segment())
	local grp_objective = {
		type = self._task_data.assault.active and "assault_area" or "recon_area",
		area = area,
		moving_out = false,
	}

	local objective = unit:brain():objective()
	if objective then
		grp_objective.area = objective.area or objective.nav_seg and self:get_area_from_nav_seg_id(objective.nav_seg) or grp_objective.area
		objective.grp_objective = grp_objective
	end

	local group = self:_create_group({
		size = 1,
		type = self._task_data.assault.active and "custom_assault" or "custom_recon",
	})
	group.team = self._teams[team_id]
	group.objective = grp_objective
	group.has_spawned = true

	self:_add_group_member(group, unit:key())
	self:set_enemy_assigned(area, unit:key())
end)

-- Fix for potential crash when a group objective does not have a coarse path
local _get_group_forwardmost_coarse_path_index_original = GroupAIStateBesiege._get_group_forwardmost_coarse_path_index
function GroupAIStateBesiege:_get_group_forwardmost_coarse_path_index(group, ...)
	if group.objective and group.objective.coarse_path then
		return _get_group_forwardmost_coarse_path_index_original(self, group, ...)
	end
end

-- Simplify reenforce objective assignment and prevent them from being stuck at spawn
Hooks:OverrideFunction(GroupAIStateBesiege, "_set_reenforce_objective_to_group", function(self, group)
	if not group.has_spawned then
		return
	end

	if group.obstructed_t and group.obstructed_t > self._t then
		return
	end

	local current_objective = group.objective
	local objective_area = current_objective.area
	local target_area = current_objective.target_area
	if not target_area or current_objective.moving_out or objective_area == target_area then
		return
	end

	local obstructed
	local search_params = {
		id = "GroupAI_reenforce",
		from_seg = objective_area.pos_nav_seg,
		to_seg = target_area.pos_nav_seg,
		access_pos = self._get_group_acces_mask(group),
		verify_clbk = callback(self, self, "is_nav_seg_safe"),
	}

	local coarse_path = managers.navigation:search_coarse(search_params)
	if coarse_path then
		self:_merge_coarse_path_by_area(coarse_path)
	elseif current_objective.obstructed then
		group.obstructed_t = self._t + 6
		return
	else
		search_params.verify_clbk = nil
		coarse_path = managers.navigation:search_coarse(search_params)

		if not coarse_path then
			return
		end

		self:_merge_coarse_path_by_area(coarse_path)

		local is_safe = true
		for i = 1, #coarse_path do
			if is_safe then
				is_safe = self:is_nav_seg_safe(coarse_path[i][1])
			else
				table.remove(coarse_path)
			end
		end

		if #coarse_path <= 2 then
			return
		end

		obstructed = true
	end

	local move_in = objective_area.neighbours[target_area.id]
	if not move_in then
		table.remove(coarse_path)
	elseif next(target_area.criminal.units) then
		local u_key, u_data = self._determine_group_leader(group.units)
		local tactics_map = u_data and u_data.tactics_map or {}
		if tactics_map.no_push then
			return
		elseif self:_can_group_see_target(group, "close") then
			return
		elseif not self:_chk_group_use_grenade(target_area, group) then
			if not group.in_place_t or self._t - group.in_place_t < tweak_data.group_ai.no_grenade_push_delay * 0.5 then
				return
			end
		end
	end

	self:_chk_say_group(group, "go_go")
	self:_set_objective_to_enemy_group(group, {
		scan = true,
		pose = move_in and "crouch" or "stand",
		type = "reenforce_area",
		stance = "hos",
		attitude = move_in and "engage" or "avoid",
		moving_in = move_in and true,
		obstructed = obstructed,
		area = self:get_area_from_nav_seg_id(coarse_path[#coarse_path][1]),
		target_area = target_area,
		coarse_path = coarse_path,
	})
end)

-- Simplify and improve recon objective assignment
Hooks:OverrideFunction(GroupAIStateBesiege, "_set_recon_objective_to_group", function(self, group)
	if not group.has_spawned then
		return
	end

	local current_objective = group.objective
	local objective_area = current_objective.area
	local target_area = current_objective.target_area or objective_area
	if target_area and (target_area.loot or target_area.hostages) then
		if current_objective.moving_out then
			if not current_objective.coarse_path then
				return
			end

			local safe = true
			local forwardmost_i_nav_point = self:_get_group_forwardmost_coarse_path_index(group) or #current_objective.coarse_path
			for i = forwardmost_i_nav_point + 1, #current_objective.coarse_path do
				if not self:is_nav_seg_safe(current_objective.coarse_path[i][1]) then
					objective_area = self:get_area_from_nav_seg_id(current_objective.coarse_path[forwardmost_i_nav_point][1])
					safe = false
					break
				end
			end

			if safe then
				return
			end
		elseif objective_area == target_area then
			return
		end
	end

	local coarse_path
	local to_search_areas = {
		objective_area,
	}
	local found_areas = {
		[objective_area] = objective_area,
	}
	local group_access_mask = self._get_group_acces_mask(group)

	local base_score = 1
	local target_area_score = math.huge

	local function area_score(area, base)
		if not area or not area.loot and not area.hostages then
			return math.huge
		end
		local score = base + table.size(area.police.units)
		if next(area.criminal.units) then
			score = score * 1.5
		end
		if area == target_area then
			score = score * 0.75
		end
		return score
	end

	repeat
		local search_area = table.remove(to_search_areas, 1)
		local search_area_score = area_score(search_area, base_score)

		if search_area_score < target_area_score then
			local new_recon_path = managers.navigation:search_coarse({
				id = "GroupAI_recon",
				from_seg = objective_area.pos_nav_seg,
				to_seg = search_area.pos_nav_seg,
				access_pos = group_access_mask,
				verify_clbk = callback(self, self, "is_nav_seg_safe"),
			})

			if new_recon_path then
				self:_merge_coarse_path_by_area(new_recon_path)
				coarse_path = new_recon_path
				target_area = search_area
				target_area_score = search_area_score
			end
		end

		if not next(search_area.criminal.units) then
			for _, other_area in pairs(search_area.neighbours) do
				if not found_areas[other_area] then
					table.insert(to_search_areas, other_area)
					found_areas[other_area] = search_area
				end
			end
		end

		base_score = base_score + 1
	until #to_search_areas == 0

	if not coarse_path then
		return
	end

	local move_in = objective_area.neighbours[target_area.id]
	if not move_in then
		table.remove(coarse_path)
	elseif next(target_area.criminal.units) then
		local u_key, u_data = self._determine_group_leader(group.units)
		local tactics_map = u_data and u_data.tactics_map or {}
		if tactics_map.no_push then
			return
		elseif self:_can_group_see_target(group, "close") then
			return
		elseif not self:_chk_group_use_grenade(target_area, group) then
			if not group.in_place_t or self._t - group.in_place_t < tweak_data.group_ai.no_grenade_push_delay * 0.5 then
				return
			end
		end
	end

	self:_chk_say_group(group, target_area.hostages and "get_hostages" or "get_loot")
	self:_set_objective_to_enemy_group(group, {
		scan = true,
		type = "recon_area",
		stance = "hos",
		pose = move_in and "crouch" or "stand",
		attitude = "avoid",
		moving_in = move_in,
		area = self:get_area_from_nav_seg_id(coarse_path[#coarse_path][1]),
		target_area = target_area,
		coarse_path = coarse_path,
	})
end)

-- New designated ponr ai state
GroupAIStatePonr = GroupAIStatePonr or class(GroupAIStateBesiege)

function GroupAIStatePonr:init(state, data)
	-- Grab all information from the previous ai state
	for k, v in pairs(data) do
		if type(v) ~= "function" then
			self[k] = v
		end
	end
	-- Set the group ai tweak table
	self._tweak_data = tweak_data.group_ai["ponr"]
	self:_parse_teammate_comments()
	self:sync_assault_mode(false)
	self:set_bain_state(true)
	self:set_difficulty(1)
	self:_set_rescue_state(true)
	self:_init_unit_type_filters()
	self:_init_team_tables()
	if Network:is_server() and managers.navigation:is_data_ready() then
		self:_queue_police_upd_task()
	end
	self._delayed_hud_banner_update = false
	self:force_end_assault_phase(true)
end

-- Put the game into endless assault after anticipation ends if the game state is Full Force Onslaught
local _upd_assault_task_original_ponr = GroupAIStatePonr._upd_assault_task
function GroupAIStatePonr:_upd_assault_task(...)
	local task_data = self._task_data.assault

	if not task_data.active then
		return
	end

	local t = self._t

	if task_data.phase ~= "anticipation" then
		return _upd_assault_task_original_ponr(self, ...)
	end

	self:_assign_recon_groups_to_retire()

	local force_pool = self:_get_difficulty_dependent_value(self._tweak_data.assault.force_pool) * self:_get_balancing_multiplier(self._tweak_data.assault.force_pool_balance_mul)
	local task_spawn_allowance = force_pool - (self._hunt_mode and 0 or task_data.force_spawned)

	if task_data.phase == "anticipation" then
		if task_spawn_allowance <= 0 then
			print("spawn_pool empty: -----------FADE-------------")

			task_data.phase = "fade"
			task_data.phase_end_t = t + self._tweak_data.assault.fade_duration
		elseif task_data.phase_end_t < t or self._drama_data.zone == "high" then
			self._assault_number = self._assault_number + 1
			self:_set_rescue_state(false)
			task_data.is_hesitating = nil
			self:set_wave_mode("hunt") -- when anticipation ends - enter endless
		else
			managers.hud:check_anticipation_voice(task_data.phase_end_t - t)
			managers.hud:check_start_anticipation_music(task_data.phase_end_t - t)

			if task_data.is_hesitating and task_data.voice_delay < self._t then
				if self._hostage_headcount > 0 then
					local best_group = nil

					for _, group in pairs(self._groups) do
						if not best_group or group.objective.type == "reenforce_area" then
							best_group = group
						elseif best_group.objective.type ~= "reenforce_area" and group.objective.type ~= "retire" then
							best_group = group
						end
					end

					if best_group and self:_voice_delay_assault(best_group) then
						task_data.is_hesitating = nil
					end
				else
					task_data.is_hesitating = nil
				end
			end
		end
	end

	if self._drama_data.amount <= tweak_data.drama.low then
		for criminal_key, criminal_data in pairs(self._player_criminals) do
			self:criminal_spotted(criminal_data.unit)

			for _, group in pairs(self._groups) do
				if group.objective.charge then
					for _, u_data in pairs(group.units) do
						u_data.unit:brain():clbk_group_member_attention_identified(nil, criminal_key)
					end
				end
			end
		end
	end

	local primary_target_area = task_data.target_areas[1]

	if self:is_area_safe_assault(primary_target_area) then
		local target_pos = primary_target_area.pos
		local nearest_area, nearest_dis

		for _, criminal_data in pairs(self._player_criminals) do
			if not criminal_data.status then
				local dis = mvec_dis_sq(target_pos, criminal_data.m_pos)

				if not nearest_dis or dis < nearest_dis then
					nearest_dis = dis
					nearest_area = self:get_area_from_nav_seg_id(criminal_data.tracker:nav_segment())
				end
			end
		end

		if nearest_area then
			primary_target_area = nearest_area
			task_data.target_areas[1] = nearest_area
		end
	end

	local nr_wanted = task_data.force - self:_count_police_force("assault")

	if task_data.phase == "anticipation" then
		nr_wanted = nr_wanted - 5
	end

	if nr_wanted > 0 and task_data.phase ~= "fade" then
		local used_event = nil

		if task_data.use_spawn_event and task_data.phase ~= "anticipation" then
			task_data.use_spawn_event = false

			if self:_try_use_task_spawn_event(t, primary_target_area, "assault") then
				used_event = true
			end
		end

		if not used_event then
			if next(self._spawning_groups) then
				-- Nothing
			else
				self:_check_spawn_timed_groups(primary_target_area, task_data)

				local spawn_group, spawn_group_type = self:_find_spawn_group_near_area(primary_target_area, self._tweak_data.assault.groups, nil, nil, nil)

				if spawn_group then
					local grp_objective = {
						attitude = "avoid",
						stance = "hos",
						pose = "crouch",
						type = "assault_area",
						area = spawn_group.area,
						coarse_path = {
							{
								spawn_group.area.pos_nav_seg,
								spawn_group.area.pos,
							},
						},
					}

					self:_spawn_in_group(spawn_group, spawn_group_type, grp_objective, task_data)
				end
			end
		end
	end

	self:_assign_enemy_groups_to_assault(task_data.phase)
end

function GroupAIStatePonr._extract_group_desc_structure(spawn_entry_outer, valid_unit_entries)
	for spawn_entry_key, spawn_entry in ipairs(spawn_entry_outer) do
		if spawn_entry.unit then
			table.insert(valid_unit_entries, clone(spawn_entry))
		else
			GroupAIStatePonr._extract_group_desc_structure(spawn_entry, valid_unit_entries)
		end
	end

	for spawn_entry_key, spawn_entry in pairs(spawn_entry_outer) do
		if (type(spawn_entry_key) ~= "number" or spawn_entry_key > #spawn_entry_outer) and #spawn_entry ~= 0 then
			local i_rand = math.random(#spawn_entry)
			local rand_branch = spawn_entry[i_rand]

			if rand_branch.unit then
				table.insert(valid_unit_entries, clone(rand_branch))
			else
				GroupAIStatePonr._extract_group_desc_structure(rand_branch, valid_unit_entries)
			end
		end
	end
end

function GroupAIStatePonr:set_assault_endless(enabled)
	if not managers.hud._hud_assault_corner then
		self._delayed_hud_banner_update = true
		self._delayed_hud_banner_update_arg = enabled
	else
		GroupAIStatePonr.super.set_assault_endless(self, enabled)
	end
end

function GroupAIStatePonr:update(t, dt)
	GroupAIStatePonr.super.update(self, t, dt)

	if self._delayed_hud_banner_update and managers.hud._hud_assault_corner then
		GroupAIStatePonr.super.set_assault_endless(self, self._delayed_hud_banner_update_arg)
		self._delayed_hud_banner_update = false
	end
end
