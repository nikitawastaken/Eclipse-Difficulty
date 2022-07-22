local math_min = math.min
local math_lerp = math.lerp
local math_random = math.random
local table_insert = table.insert
local table_remove = table.remove
local mvec_add = mvector3.add
local mvec_dis = mvector3.distance
local mvec_dis_sq = mvector3.distance_sq
local mvec_set = mvector3.set
local mvec_set_l = mvector3.set_length
local mvec_set_z = mvector3.set_z
local mvec_sub = mvector3.subtract
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()

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

	if task_data.phase ~= "fade" then
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


-- Add an alternate in_place check to prevent enemy groups from getting stuck
function GroupAIStateBesiege:_assign_enemy_groups_to_assault(phase)
	for _, group in pairs(self._groups) do
		if group.has_spawned and group.objective.type == "assault_area" then
			if group.objective.moving_out then
				local done_moving

				for _, u_data in pairs(group.units) do
					local objective = u_data.unit:brain():objective()
					if objective and objective.grp_objective == group.objective then
						if objective.in_place or objective.area and objective.area.nav_segs[u_data.unit:movement():nav_tracker():nav_segment()] then
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
				self:_set_assault_objective_to_group(group, phase)
			end
		end
	end
end


-- Improve and heavily simplify objective assignment code, fix pull back and open fire objectives
-- Basically, a lot of this function was needlessly complex and had oversights or incorrect conditions
Hooks:OverrideFunction(GroupAIStateBesiege, "_set_assault_objective_to_group", function (self, group, phase)
	local phase_is_anticipation = phase == "anticipation"
	local current_objective = group.objective
	local approach, open_fire, pull_back, charge
	local obstructed_area = self:_chk_group_areas_tresspassed(group)
	local group_leader_u_key, group_leader_u_data = self._determine_group_leader(group.units)
	local in_place_duration = group.in_place_t and self._t - group.in_place_t or 0
	local tactics_map = {}

	if group_leader_u_data and group_leader_u_data.tactics then
		for _, tactic_name in ipairs(group_leader_u_data.tactics) do
			tactics_map[tactic_name] = true
		end

		if current_objective.tactic and not tactics_map[current_objective.tactic] then
			current_objective.tactic = nil
		end

		for i_tactic, tactic_name in ipairs(group_leader_u_data.tactics) do
			if tactic_name == "deathguard" and not phase_is_anticipation then
				if current_objective.tactic == tactic_name then
					for u_key, u_data in pairs(self._char_criminals) do
						if u_data.status and current_objective.follow_unit == u_data.unit then
							if current_objective.area.nav_segs[u_data.tracker:nav_segment()] then
								return
							end
						end
					end
				end

				local closest_crim_u_data, closest_crim_dis_sq
				for u_key, u_data in pairs(self._char_criminals) do
					if u_data.status then
						local closest_u_id, closest_u_data, closest_u_dis_sq = self._get_closest_group_unit_to_pos(u_data.m_pos, group.units)
						if closest_u_dis_sq and (not closest_crim_dis_sq or closest_u_dis_sq < closest_crim_dis_sq) then
							closest_crim_u_data = u_data
							closest_crim_dis_sq = closest_u_dis_sq
						end
					end
				end

				if closest_crim_u_data then
					local coarse_path = managers.navigation:search_coarse({
						id = "GroupAI_deathguard",
						from_tracker = group_leader_u_data.unit:movement():nav_tracker(),
						to_tracker = closest_crim_u_data.tracker,
						access_pos = self._get_group_acces_mask(group)
					})

					if coarse_path then
						local grp_objective = {
							distance = 800,
							type = "assault_area",
							attitude = "engage",
							tactic = "deathguard",
							moving_in = true,
							follow_unit = closest_crim_u_data.unit,
							area = self:get_area_from_nav_seg_id(coarse_path[#coarse_path][1]),
							coarse_path = coarse_path
						}
						group.is_chasing = true

						self:_set_objective_to_enemy_group(group, grp_objective)
						self:_voice_deathguard_start(group)
						return
					end
				end
			elseif tactic_name == "charge" and not current_objective.moving_out then
				charge = true
			end
		end
	end

	local objective_area = current_objective.area
	if obstructed_area then
		if phase_is_anticipation then
			-- If we run into enemies during anticipation, pull back
			pull_back = true
		elseif current_objective.moving_out and tactics_map.ranged_fire then
			-- If we run into enemies while moving out, open fire (if we aren't already doing that)
			open_fire = not current_objective.open_fire
		elseif not current_objective.pushed or charge and not current_objective.charge then
			-- If we run into enemies and haven't pushed yet, approach
			approach = true
		end
	elseif not current_objective.moving_out then
		-- If we aren't moving out to an objective, approach or open fire if we have ranged_fire tactics and see an enemy
		approach = charge or not tactics_map.ranged_fire or in_place_duration > 10 or group.is_chasing or not self:_can_group_see_target(group)
		open_fire = not approach and not current_objective.open_fire
	elseif tactics_map.ranged_fire and not current_objective.open_fire and self:_can_group_see_target(group, true) then
		-- If we see an enemy while moving out and have the ranged_fire tactics, open fire and stay in position for a bit
		local forwardmost_i_nav_point = self:_get_group_forwardmost_coarse_path_index(group)
		if forwardmost_i_nav_point then
			open_fire = true
			objective_area = self:get_area_from_nav_seg_id(current_objective.coarse_path[forwardmost_i_nav_point][1])
		end
	end

	if open_fire then
		objective_area = obstructed_area or objective_area
		local grp_objective = {
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
					mvector3.copy(objective_area.pos)
				}
			}
		}

		self:_set_objective_to_enemy_group(group, grp_objective)
		self:_voice_open_fire_start(group)
	elseif approach then
		local assault_area, alternate_assault_area, alternate_assault_area_from, assault_path, alternate_assault_path
		local to_search_areas = {
			objective_area
		}
		local found_areas = {
			[objective_area] = objective_area
		}
		local group_access_mask = self._get_group_acces_mask(group)

		repeat
			local search_area = table_remove(to_search_areas, 1)

			if next(search_area.criminal.units) then
				local assault_from_here = true

				if tactics_map.flank then
					local assault_from_area = found_areas[search_area]

					if assault_from_area ~= objective_area then
						assault_from_here = false

						if not alternate_assault_area or math_random() < 0.5 then
							local new_alternate_assault_path = managers.navigation:search_coarse({
								id = "GroupAI_assault",
								from_seg = current_objective.area.pos_nav_seg,
								to_seg = search_area.pos_nav_seg,
								access_pos = group_access_mask,
								verify_clbk = callback(self, self, "is_nav_seg_safe")
							})

							if new_alternate_assault_path then
								self:_merge_coarse_path_by_area(new_alternate_assault_path)
								alternate_assault_path = new_alternate_assault_path
								alternate_assault_area = search_area
								alternate_assault_area_from = assault_from_area
							end
						end

						found_areas[search_area] = nil
					end
				end

				if assault_from_here then
					assault_path = managers.navigation:search_coarse({
						id = "GroupAI_assault",
						from_seg = current_objective.area.pos_nav_seg,
						to_seg = search_area.pos_nav_seg,
						access_pos = group_access_mask,
						verify_clbk = callback(self, self, "is_nav_seg_safe")
					})

					if assault_path then
						self:_merge_coarse_path_by_area(assault_path)
						assault_area = search_area
						break
					end
				end
			else
				for _, other_area in pairs(search_area.neighbours) do
					if not found_areas[other_area] then
						table_insert(to_search_areas, other_area)
						found_areas[other_area] = search_area
					end
				end
			end
		until #to_search_areas == 0

		if alternate_assault_area then
			assault_area = alternate_assault_area
			found_areas[assault_area] = alternate_assault_area_from
			assault_path = alternate_assault_path
		end

		if assault_area and assault_path then
			local push = found_areas[assault_area] == objective_area
			local used_grenade

			if push then
				local detonate_pos
				local c_key = charge and table.random_key(assault_area.criminal.units)
				if c_key then
					detonate_pos = assault_area.criminal.units[c_key].unit:movement():m_pos()
				end

				-- Check which grenade to use to push, grenade use is required for the push to be initiated
				-- If grenade isn't available, push regardless anyway after a short delay
				used_grenade = self:_chk_group_use_grenade(group, detonate_pos) or group.ignore_grenade_check_t and group.ignore_grenade_check_t <= self._t

				if used_grenade then
					self:_voice_move_in_start(group)
				elseif not group.ignore_grenade_check_t then
					group.ignore_grenade_check_t = self._t + 4 / math.max(1, table.size(assault_area.criminal.units))
				end
			else
				-- If we aren't pushing, we go to one area before the criminal area
				assault_area = found_areas[assault_area]
				if #assault_path > 2 and assault_area.nav_segs[assault_path[#assault_path - 1][1]] then
					table_remove(assault_path)
				end
			end

			if not push or used_grenade then
				local grp_objective = {
					type = "assault_area",
					stance = "hos",
					area = assault_area,
					coarse_path = assault_path,
					pose = push and "crouch" or "stand",
					attitude = push and "engage" or "avoid",
					moving_in = push,
					open_fire = push,
					pushed = push,
					charge = charge,
					interrupt_dis = charge and 0
				}
				group.is_chasing = group.is_chasing or push

				self:_set_objective_to_enemy_group(group, grp_objective)
			end
		elseif in_place_duration > 10 and not self:_can_group_see_target(group) then
			-- Log and remove groups that get stuck
			local element_id = group.spawn_group_element and group.spawn_group_element._id or 0
			local element_name = group.spawn_group_element and group.spawn_group_element._editor_name or ""
			StreamHeist:log(string.format("[Warning] Group %s spawned from element %u (%s) is stuck, removing it!", group.id, element_id, element_name))

			for _, u_data in pairs(group.units) do
				u_data.unit:brain():set_active(false)
				u_data.unit:set_slot(0)
			end
		end
	elseif pull_back then
		local retreat_area

		for _, u_data in pairs(group.units) do
			local nav_seg_id = u_data.tracker:nav_segment()

			if current_objective.area.nav_segs[nav_seg_id] then
				retreat_area = current_objective.area
				break
			end

			if self:is_nav_seg_safe(nav_seg_id) then
				retreat_area = self:get_area_from_nav_seg_id(nav_seg_id)
				break
			end
		end

		if not retreat_area and current_objective.coarse_path then
			local forwardmost_i_nav_point = self:_get_group_forwardmost_coarse_path_index(group)
			if forwardmost_i_nav_point then
				retreat_area = self:get_area_from_nav_seg_id(current_objective.coarse_path[forwardmost_i_nav_point][1])
			end
		end

		if retreat_area then
			local new_grp_objective = {
				attitude = "avoid",
				stance = "hos",
				pose = "crouch",
				type = "assault_area",
				area = retreat_area,
				coarse_path = {
					{
						retreat_area.pos_nav_seg,
						mvector3.copy(retreat_area.pos)
					}
				}
			}
			group.is_chasing = nil

			self:_set_objective_to_enemy_group(group, new_grp_objective)
		end
	end
end)


-- Helper to check if any group member has visuals on their focus target
function GroupAIStateBesiege:_can_group_see_target(group, limit_range)
	local logic_data, focus_enemy
	for _, u_data in pairs(group.units) do
		logic_data = u_data.unit:brain()._logic_data
		focus_enemy = logic_data and logic_data.attention_obj
		if focus_enemy and focus_enemy.reaction >= AIAttentionObject.REACT_AIM and focus_enemy.verified then
			if not limit_range or focus_enemy.verified_dis < (logic_data.internal_data.weapon_range and logic_data.internal_data.weapon_range.far or 3000) then
				return true
			end
		end
	end
end


-- Add custom grenade usage function
function GroupAIStateBesiege:_chk_group_use_grenade(group, detonate_pos)
	local task_data = self._task_data.assault
	if not task_data.use_smoke then
		return
	end

    local grenade_types = {
        smoke_grenade = (not task_data.smoke_grenade_next_t or task_data.smoke_grenade_next_t < self._t) or nil,
        flash_grenade = (not task_data.flash_grenade_next_t or task_data.flash_grenade_next_t < self._t) or nil
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

	local candidate = table.random(grenade_candidates)
	local grenade_type = candidate[1]
	local grenade_user = candidate[2]

	local area
	local detonate_offset, detonate_offset_pos = tmp_vec1, tmp_vec2
	if detonate_pos then
		-- Offset grenade a bit to avoid spawning exactly on the player
		mvec_set(detonate_offset, grenade_user.m_pos)
		mvec_sub(detonate_offset, detonate_pos)
		mvec_set_z(detonate_offset, 0)
		mvec_set_l(detonate_offset, math.random(100, 300))
		mvec_set(detonate_offset_pos, detonate_pos)
		mvec_add(detonate_offset_pos, detonate_offset)

		local ray = World:raycast("ray", detonate_pos, detonate_offset_pos, "slot_mask", managers.slot:get_mask("world_geometry"))
		if ray then
			mvec_set_l(detonate_offset, math.max(0, ray.distance - 50))
			mvec_set(detonate_offset_pos, detonate_pos)
			mvec_add(detonate_offset_pos, detonate_offset)
		end

		detonate_pos = detonate_offset_pos
		area = self:get_area_from_nav_seg_id(managers.navigation:get_nav_seg_from_pos(detonate_pos, true))
	else
		local nav_seg = managers.navigation._nav_segments[grenade_user.tracker:nav_segment()]
		for neighbour_nav_seg_id, door_list in pairs(nav_seg.neighbours) do
			area = self:get_area_from_nav_seg_id(neighbour_nav_seg_id)
			if task_data.target_areas[1].nav_segs[neighbour_nav_seg_id] or next(area.criminal.units) then
				local random_door_id = door_list[math_random(#door_list)]
				if type(random_door_id) == "number" then
					detonate_pos = managers.navigation._room_doors[random_door_id].center
				else
					detonate_pos = random_door_id:script_data().element:nav_link_end_pos()
				end
				break
			end
		end
	end

	if not detonate_pos then
		return
	end

	-- If players camp a specific area for too long, turn a smoke grenade into a teargas grenade instead
	local use_teargas
	local can_use_teargas = grenade_type == "smoke_grenade" and area and area.criminal_entered_t and table.size(area.neighbours) <= 2
	if can_use_teargas and math_random() < (self._t - area.criminal_entered_t - 60) / 180 then
		-- Check if a player actually currently is in this area
		local num_player_criminals = 0
		detonate_pos = tmp_vec1
		for _, c_data in pairs(area.criminal.units) do
			if not c_data.ai then
				num_player_criminals = num_player_criminals + 1
				mvector3.add(detonate_pos, c_data.m_pos)
			end
		end
		if num_player_criminals > 0 then
			mvector3.divide(detonate_pos, num_player_criminals)
			mvector3.lerp(detonate_pos, detonate_pos, area.pos, 0.5)
			mvector3.set_z(detonate_pos, area.pos.z)
			-- If detonate pos is a roofed area, use teargas
			use_teargas = World:raycast("ray", detonate_pos, detonate_pos + math.UP * 1000, "slot_mask", managers.slot:get_mask("world_geometry"), "report")
		end
	end

	local timeout
	if use_teargas then
		area.criminal_entered_t = nil

		self:detonate_cs_grenade(detonate_pos, mvector3.copy(grenade_user.m_pos), tweak_data.group_ai.cs_grenade_lifetime or 10)

		timeout = tweak_data.group_ai.cs_grenade_timeout or tweak_data.group_ai.smoke_and_flash_grenade_timeout
	else
		if grenade_type == "flash_grenade" and grenade_user.char_tweak.chatter.flash_grenade then
			self:chk_say_enemy_chatter(grenade_user.unit, grenade_user.m_pos, "flash_grenade")
		elseif grenade_type == "smoke_grenade" and grenade_user.char_tweak.chatter.smoke then
			self:chk_say_enemy_chatter(grenade_user.unit, grenade_user.m_pos, "smoke")
		end

		self:detonate_smoke_grenade(detonate_pos, mvector3.copy(grenade_user.m_pos), tweak_data.group_ai[grenade_type .. "_lifetime"] or 10, grenade_type == "flash_grenade")

		timeout = tweak_data.group_ai[grenade_type .. "_timeout"] or tweak_data.group_ai.smoke_and_flash_grenade_timeout
	end

	task_data.use_smoke = false
	-- Minimum grenade cooldown
	task_data.use_smoke_timer = self._t + 10
	-- Individual grenade cooldowns
	task_data[grenade_type .. "_next_t"] = self._t + math_lerp(timeout[1], timeout[2], math_random())

	return true
end


-- Keep recon groups around during anticipation
-- Making them retreat only afterwards gives them more time to complete their objectives
local _assign_recon_groups_to_retire_original = GroupAIStateBesiege._assign_recon_groups_to_retire
function GroupAIStateBesiege:_assign_recon_groups_to_retire(...)
	if self._task_data.assault.phase == "anticipation" then
		return
	end
	return _assign_recon_groups_to_retire_original(self, ...)
end


-- Reduce the importance of spawn group distance in spawn group weight to encourage enemies spawning from more directions
-- Also slightly optimized this function to properly check all areas
function GroupAIStateBesiege:_find_spawn_group_near_area(target_area, allowed_groups, target_pos, max_dis, verify_clbk)
	target_pos = target_pos or target_area.pos
	max_dis = max_dis and max_dis * max_dis

	local t = self._t
	local valid_spawn_groups = {}
	local valid_spawn_group_distances = {}

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
							id = dis_id
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

					if self._graph_distance_cache[dis_id] then
						local my_dis = self._graph_distance_cache[dis_id]
						if not max_dis or my_dis < max_dis then
							local spawn_group_id = spawn_group.mission_element:id()
							valid_spawn_groups[spawn_group_id] = spawn_group
							valid_spawn_group_distances[spawn_group_id] = my_dis
						end
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
	for i, dis in pairs(valid_spawn_group_distances) do
		local my_wgt = math_lerp(1, 0.75, math_min(1, dis / 5000))
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
	self._police_upd_task_queued = false

	if self._police_activity_blocked then
		return
	end

	if self._ai_enabled then
		self:_upd_SO()
		self:_upd_grp_SO()
		self:_check_spawn_phalanx()
		self:_check_phalanx_group_has_spawned()
		self:_check_phalanx_damage_reduction_increase()

		-- Do _upd_group_spawning and _begin_new_tasks before the various task updates
		if self._enemy_weapons_hot then
			self:_claculate_drama_value()
			self:_upd_group_spawning()
			self:_begin_new_tasks()
			self:_upd_regroup_task()
			self:_upd_reenforce_tasks()
			self:_upd_recon_tasks()
			self:_upd_assault_task()
			self:_upd_groups()
		end
	end

	self:_queue_police_upd_task()
end


-- Update police activity in consistent intervals
function GroupAIStateBesiege:_queue_police_upd_task()
	if not self._police_upd_task_queued then
		self._police_upd_task_queued = true
		managers.enemy:queue_task("GroupAIStateBesiege._upd_police_activity", self._upd_police_activity, self, self._t + 1)
	end
end


-- Overhaul group spawning and fix forced group spawns not actually forcing the entire group to spawn
-- Group spawning now always spawns the entire group at once but uses a cooldown that prevents any regular group spawns
-- for a number of seconds equal to the amount of spawned units
local force_spawn_group_original = GroupAIStateBesiege.force_spawn_group
function GroupAIStateBesiege:force_spawn_group(...)
	self._force_next_group_spawn = true
	force_spawn_group_original(self, ...)
	self._force_next_group_spawn = nil
end

Hooks:OverrideFunction(GroupAIStateBesiege, "_perform_group_spawning", function (self, spawn_task, force, use_last)
	-- Prevent regular group spawning if cooldown is active unless it's a forced spawn
	if self._next_group_spawn_t and self._next_group_spawn_t > self._t and not force and not self._force_next_group_spawn then
		return
	end

	local produce_data = {
		name = true,
		spawn_ai = {}
	}
	local unit_categories = tweak_data.group_ai.unit_categories
	local current_unit_type = tweak_data.levels:get_ai_group_type()
	local spawn_points = spawn_task.spawn_group.spawn_pts

	local function _try_spawn_unit(u_type_name, spawn_entry)
		local hopeless = true
		for _, sp_data in ipairs(spawn_points) do
			local category = unit_categories[u_type_name]
			if (sp_data.accessibility == "any" or category.access[sp_data.accessibility]) and (not sp_data.amount or sp_data.amount > 0) and sp_data.mission_element:enabled() then
				hopeless = false

				if sp_data.delay_t < self._t then
					local units = category.unit_types[current_unit_type]
					produce_data.name = units[math.random(#units)]
					produce_data.name = managers.modifiers:modify_value("GroupAIStateBesiege:SpawningUnit", produce_data.name)
					local spawned_unit = sp_data.mission_element:produce(produce_data)
					local u_key = spawned_unit:key()
					local objective = nil

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

					local u_data = self._police[u_key]

					self:set_enemy_assigned(objective.area, u_key)

					if spawn_entry.tactics then
						u_data.tactics = spawn_entry.tactics
						u_data.tactics_map = {}

						for _, tactic_name in ipairs(u_data.tactics) do
							u_data.tactics_map[tactic_name] = true
						end
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
			StreamHeist:warn("Spawn group", spawn_task.spawn_group.id, "failed to spawn unit", u_type_name)
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

	table.remove(self._spawning_groups, use_last and #self._spawning_groups or 1)

	spawn_task.group.has_spawned = true
	if spawn_task.group.size <= 0 then
		self._groups[spawn_task.group.id] = nil
	end

	-- Set a cooldown before new units can be spawned via regular spawn tasks
	self._next_group_spawn_t = self._t + spawn_task.group.size * 0.75
end)


-- Save spawn group element in group description for debugging stuck groups
local _spawn_in_group_original = GroupAIStateBesiege._spawn_in_group
function GroupAIStateBesiege:_spawn_in_group(spawn_group, ...)
	local group = _spawn_in_group_original(self, spawn_group, ...)
	if group then
		group.spawn_group_element = spawn_group.mission_element
		return group
	end
end


-- Make push use a unique voiceline, add retreat lines
function GroupAIStateBesiege:_voice_move_in_start(group)
	for u_key, unit_data in pairs(group.units) do
		if unit_data.char_tweak.chatter.push and self:chk_say_enemy_chatter(unit_data.unit, unit_data.m_pos, "push") then
			break
		end
	end
end

function GroupAIStateBesiege:_voice_retreat(group)
	for u_key, unit_data in pairs(group.units) do
		if unit_data.char_tweak.chatter.retreat and self:chk_say_enemy_chatter(unit_data.unit, unit_data.m_pos, "retreat") then
			break
		end
	end
end

Hooks:PostHook(GroupAIStateBesiege, "_assign_group_to_retire", "sh__assign_group_to_retire", function (self, group)
	self:_voice_retreat(group)
end)

-- When scripted spawns are assigned to group ai, use a generic group type instead of using their category as type
-- This ensures they are not retired immediatley cause they are not part of assault/recon group types
Hooks:OverrideFunction(GroupAIStateBesiege, "assign_enemy_to_group_ai", function (self, unit, team_id)
	local area = self:get_area_from_nav_seg_id(unit:movement():nav_tracker():nav_segment())
	local grp_objective = {
		type = self._task_data.assault.active and "assault_area" or "recon_area",
		area = area,
		moving_out = false
	}

	local objective = unit:brain():objective()
	if objective then
		grp_objective.area = objective.area or objective.nav_seg and self:get_area_from_nav_seg_id(objective.nav_seg) or grp_objective.area
		objective.grp_objective = grp_objective
	end

	local group = self:_create_group({
		size = 1,
		type = self._task_data.assault.active and "custom_assault" or "custom_recon"
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