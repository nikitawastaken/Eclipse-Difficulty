local mvec3_add = mvector3.add
local mvec3_cross = mvector3.cross
local mvec3_dir = mvector3.direction
local mvec3_dis_sq = mvector3.distance_sq
local mvec3_lerp = mvector3.lerp
local mvec3_mul = mvector3.multiply
local mvec3_neg = mvector3.negate
local mvec3_normalize = mvector3.normalize
local mvec3_set = mvector3.set
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
local tmp_vec3 = Vector3()
local tmp_vec4 = Vector3()

-- Reuse function of idle logic to make enemies in an area aware of a player entering the area
CopLogicTravel.on_area_safety = CopLogicIdle.on_area_safety

-- Update pathing immediately when receiving travel logic or pathing results
Hooks:PostHook(CopLogicTravel, "enter", "sh_enter", CopLogicTravel.upd_advance)

function CopLogicTravel.on_pathing_results(data)
	local my_data = data.internal_data

	CopLogicTravel._upd_pathing(data, my_data)

	if data.internal_data ~= my_data then
		return
	end

	CopLogicTravel.upd_advance(data)
end

-- Follow pathing improvement, use continuous instead of segmented path
function CopLogicTravel._use_segmented_coarse_path(data)
	return not data.objective or data.objective.type ~= "follow" or data.path_fail_t and data.t - data.path_fail_t < 2
end

local _begin_coarse_pathing_original = CopLogicTravel._begin_coarse_pathing
function CopLogicTravel._begin_coarse_pathing(data, my_data, ...)
	if CopLogicTravel._use_segmented_coarse_path(data) then
		return _begin_coarse_pathing_original(data, my_data, ...)
	end

	local nav_seg, pos
	if alive(data.objective.follow_unit) then
		local follow_tracker = data.objective.follow_unit:movement():nav_tracker()
		nav_seg = follow_tracker:nav_segment()
		pos = follow_tracker:field_position()
	else
		nav_seg = data.objective.nav_seg or data.objective.area and data.objective.area.pos_nav_seg
		pos = managers.navigation._nav_segments[nav_seg].pos
	end

	my_data.coarse_path_index = 1
	my_data.coarse_path = {
		{
			data.unit:movement():nav_tracker():nav_segment(),
			mvector3.copy(data.m_pos),
		},
		{
			nav_seg,
			pos,
		},
	}
end

local _get_allowed_travel_nav_segs_original = CopLogicTravel._get_allowed_travel_nav_segs
function CopLogicTravel._get_allowed_travel_nav_segs(data, ...)
	-- Returning nothing allows all nav segments
	if CopLogicTravel._use_segmented_coarse_path(data) then
		return _get_allowed_travel_nav_segs_original(data, ...)
	end
end

-- Fix need for another queued task to update pathing after expired cover leave time
-- Reposition when the current destination position is too far from the follow unit
Hooks:PreHook(CopLogicTravel, "upd_advance", "sh_upd_advance", function(data)
	local unit = data.unit
	local my_data = data.internal_data
	local t = TimerManager:game():time()
	if my_data.cover_leave_t and my_data.cover_leave_t < t and not unit:movement():chk_action_forbidden("walk") and not data.unit:anim_data().reload then
		my_data.cover_leave_t = nil
	end

	CopLogicTravel._chk_relocate(data, my_data)
end)

function CopLogicTravel._chk_relocate(data, my_data)
	local objective = data.objective
	if not objective or not alive(objective.follow_unit) or not my_data.advancing or not my_data.coarse_path or my_data.processing_coarse_path then
		return
	end

	local destination_pos = my_data.coarse_path[#my_data.coarse_path][2]
	local follow_pos = objective.follow_unit:movement():nav_tracker():field_position()
	if mvector3.distance_sq(destination_pos, follow_pos) < 3000 ^ 2 then
		return
	end

	data.brain:action_request({
		body_part = 2,
		type = "idle",
	})

	CopLogicTravel._begin_coarse_pathing(data, my_data)
end

-- Make groups move together (remove close to criminal check to avoid splitting groups)
function CopLogicTravel.chk_group_ready_to_move(data)
	local my_objective = data.objective
	if not my_objective.grp_objective or my_objective.type == "follow" then
		return true
	end

	local my_dis = mvec3_dis_sq(my_objective.area.pos, data.m_pos)
	if my_dis > 4000000 then
		return true
	end

	my_dis = my_dis * (1.15 ^ 2)
	for u_key, u_data in pairs(data.group.units) do
		if u_key ~= data.key and alive(u_data.unit) then
			local his_objective = u_data.unit:brain():objective()
			if his_objective and his_objective.grp_objective == my_objective.grp_objective and not his_objective.in_place then
				if my_dis < mvec3_dis_sq(his_objective.area.pos, u_data.m_pos) then
					return false
				end
			end
		end
	end

	return true
end

-- Find a random fallback position in the nav segment if no covers are available
-- This is done to prevent enemies stacking in one spot if no positions next to walls are available
-- Also add different positioning for shield_cover groups, sticking close to and behind their follow units
local _get_exact_move_pos_original = CopLogicTravel._get_exact_move_pos
function CopLogicTravel._get_exact_move_pos(data, nav_index, ...)
	local my_data = data.internal_data
	local nav_manager = managers.navigation

	if alive(data.objective.cover_unit) then
		if my_data.moving_to_cover then
			nav_manager:release_cover(my_data.moving_to_cover[1])
			my_data.moving_to_cover = nil
		end

		local pos = CopLogicTravel._get_pos_behind_unit(data, data.objective.cover_unit, 75, 300)
		return pos or _get_exact_move_pos_original(data, nav_index, ...)
	end

	local coarse_path = my_data.coarse_path
	if nav_index >= #coarse_path or data.objective.follow_unit or data.objective.path_style == "destination" then
		return _get_exact_move_pos_original(data, nav_index, ...)
	end

	if my_data.moving_to_cover then
		nav_manager:release_cover(my_data.moving_to_cover[1])
		my_data.moving_to_cover = nil
	end

	local nav_seg_id = coarse_path[nav_index][1]
	local next_nav_seg_id = coarse_path[nav_index + 1][1]
	local nav_seg_pos = nav_manager._nav_segments[nav_seg_id].pos

	-- Pick cover positions that are close to nav segment doors
	local doors = nav_manager:find_segment_doors(nav_seg_id, function(seg_id)
		return seg_id == next_nav_seg_id
	end)
	local door = table.random(doors)
	local to_pos = door and door.center or coarse_path[nav_index][2] or nav_seg_pos

	local cover = nav_manager:find_cover_in_nav_seg_2(nav_seg_id, to_pos)
	if cover then
		nav_manager:reserve_cover(cover, data.pos_rsrv_id)
		my_data.moving_to_cover = { cover }
		to_pos = cover[1]
	else
		mvector3.step(tmp_vec1, to_pos, nav_seg_pos, 200)
		mvector3.set(tmp_vec2, math.UP)
		mvector3.random_orthogonal(tmp_vec2)
		mvector3.multiply(tmp_vec2, 100)
		mvector3.add(tmp_vec1, tmp_vec2)

		local ray_params = {
			pos_from = nav_seg_pos,
			pos_to = tmp_vec1,
			allow_entry = true,
			trace = true,
		}
		nav_manager:raycast(ray_params)
		to_pos = ray_params.trace[1]
	end

	return to_pos
end

local _determine_destination_occupation_original = CopLogicTravel._determine_destination_occupation
function CopLogicTravel._determine_destination_occupation(data, objective, ...)
	if objective.cover or objective.pos or data.kpr_keep_position then
		return _determine_destination_occupation_original(data, objective, ...)
	end

	if alive(objective.follow_unit) and objective.type ~= "revive" then
		local follow_tracker = objective.follow_unit:movement():nav_tracker()
		local follow_nav_seg = follow_tracker:nav_segment()
		local follow_pos = follow_tracker:field_position()

		local cover
		if data.attention_obj and data.attention_obj.nav_tracker and data.attention_obj.reaction >= AIAttentionObject.REACT_COMBAT then
			cover = managers.navigation:find_cover_in_nav_seg_3(follow_nav_seg, nil, follow_pos, threat_pos)
		end

		if not cover and data.team.foes.criminal1 then
			cover = CopLogicTravel._find_cover(data, objective.nav_seg or follow_nav_seg, follow_pos)
		end

		if cover then
			return {
				type = "defend",
				cover = {
					cover,
				},
			}
		else
			return {
				type = "defend",
				pos = CopLogicTravel._get_pos_on_wall(follow_pos, objective.called and 600),
			}
		end
	elseif objective.type == "defend_area" then
		local cover = CopLogicTravel._find_cover(data, objective.nav_seg)
		if cover then
			return {
				type = "defend",
				seg = objective.nav_seg,
				cover = {
					cover,
				},
				radius = objective.radius,
			}
		else
			return {
				type = "defend",
				seg = objective.nav_seg,
				pos = CopLogicTravel._get_pos_on_wall(managers.navigation:find_random_position_in_segment(objective.nav_seg), 500),
				radius = objective.radius,
			}
		end
	end

	return _determine_destination_occupation_original(data, objective, ...)
end

function CopLogicTravel._get_pos_behind_unit(data, unit, min_dis, max_dis)
	local threat_dir, threat_side, pos, unit_pos = tmp_vec1, tmp_vec2, tmp_vec3, tmp_vec4
	local unit_movement = unit:movement()

	mvec3_set(unit_pos, unit_movement:m_pos())
	local walk_to_pos = unit_movement.get_walk_to_pos and unit_movement:get_walk_to_pos()
	if walk_to_pos then
		mvec3_lerp(unit_pos, unit_pos, walk_to_pos, math.min(mvector3.distance(unit_pos, data.m_pos) / 1000, 1))
	end

	if data.attention_obj and data.attention_obj.reaction >= AIAttentionObject.REACT_AIM then
		mvec3_dir(threat_dir, data.attention_obj.m_pos, unit_pos)
	else
		mvec3_set(threat_dir, unit_movement.m_fwd and unit_movement:m_fwd() or unit_movement:m_head_rot():y())
		mvec3_neg(threat_dir)
	end

	mvec3_cross(threat_side, threat_dir, math.UP)

	local fallback_pos
	local rays = 7
	local min_dis_sq = min_dis ^ 2
	local nav_manager = managers.navigation
	local ray_params = {
		trace = true,
		pos_from = unit_pos,
		pos_to = pos,
	}
	local rsrv_desc = {
		radius = 40,
	}

	repeat
		if math.random() < 0.5 then
			mvec3_neg(threat_side)
		end

		-- Get a random vector between main threat direction and side threat direction
		mvec3_lerp(pos, threat_dir, threat_side, math.random() * 0.5)
		mvec3_normalize(pos)
		mvec3_mul(pos, math.random(min_dis, max_dis))
		mvec3_add(pos, unit_pos)

		if not nav_manager:raycast(ray_params) or mvec3_dis_sq(ray_params.trace[1], unit_pos) > min_dis_sq then
			rsrv_desc.position = ray_params.trace[1]
			if nav_manager:is_pos_free(rsrv_desc) then
				return ray_params.trace[1]
			elseif not fallback_pos then
				fallback_pos = ray_params.trace[1]
			end
		end

		rays = rays - 1
	until rays <= 0

	return fallback_pos
end

-- Fix cover wait time being set to 0 if players aren't literally next to enemy
Hooks:PostHook(CopLogicTravel, "action_complete_clbk", "sh_action_complete_clbk", function(data, action)
	if action:type() ~= "walk" then
		return
	end

	local my_data = data.internal_data
	if not my_data.cover_leave_t then
		return
	end

	if not my_data.coarse_path or my_data.coarse_path_index == #my_data.coarse_path or data.objective and data.objective.follow_unit then
		my_data.cover_leave_t = nil
	elseif my_data.cover_leave_t == data.t then
		my_data.cover_leave_t = data.t + (my_data.coarse_path_index == #my_data.coarse_path - 1 and 0.3 or math.rand(0.6, 1))
	end
end)

-- Stop existing advancing action on exit to a new travel logic
-- This allows enemies to start their new path immediately instead of having to finish the old one
Hooks:PreHook(CopLogicTravel, "exit", "sh_exit", function(data, new_logic_name)
	if new_logic_name == "travel" then
		CopLogicTravel.cancel_advance(data)
	end
end)

function CopLogicTravel.cancel_advance(data)
	if data.internal_data.advancing and not data.unit:movement():chk_action_forbidden("idle") then
		data.brain:action_request({
			body_part = 2,
			type = "idle",
		})
	end
end

-- Fix enemies sometimes disappearing when they are told to retire
-- Basically this function doesn't check if the retiring unit reached their actual retire spot
local _on_destination_reached_original = CopLogicTravel._on_destination_reached
function CopLogicTravel._on_destination_reached(data, ...)
	local objective = data.objective
	if objective.type == "flee" or objective.type == "defend_area" and objective.grp_objective and objective.grp_objective.type == "retire" then
		local nav_seg = data.unit:movement():nav_tracker():nav_segment()
		if objective.nav_seg == nav_seg or objective.area and objective.area.nav_segs[nav_seg] then
			data.unit:brain():set_active(false)
			data.unit:base():set_slot(data.unit, 0)
		else
			objective.in_place = true
			data.logic.on_new_objective(data)
		end
		return
	end

	return _on_destination_reached_original(data, ...)
end

-- Play generic radio report chatter during travel while unalerted
Hooks:PostHook(CopLogicTravel, "queued_update", "sh_queued_update", function(data)
	if data.cool and data.char_tweak.chatter and data.char_tweak.chatter.report then
		managers.groupai:state():chk_say_enemy_chatter(data.unit, data.m_pos, "report")
	end
end)

-- Make better use of pathing priority
function CopLogicTravel.get_pathing_prio(data)
	if data.team and (data.team.id == "criminal1" or data.team.friends.criminal1) then
		return 6
	elseif data.unit:base().has_tag and data.unit:base():has_tag("special") then
		return 4
	elseif data.important then
		return 2
	else
		return 0
	end
end

-- This should be removed once the nil team issue is figured out
function CopLogicTravel.enter(data, new_logic_name, enter_params)
	CopLogicBase.enter(data, new_logic_name, enter_params)
	data.unit:brain():cancel_all_pathing_searches()

	local old_internal_data = data.internal_data
	local my_data = {
		unit = data.unit,
	}
	local is_cool = data.unit:movement():cool()

	if is_cool then
		my_data.detection = data.char_tweak.detection.ntl
	else
		my_data.detection = data.char_tweak.detection.recon
	end

	if old_internal_data then
		my_data.turning = old_internal_data.turning
		my_data.firing = old_internal_data.firing
		my_data.shooting = old_internal_data.shooting
		my_data.attention_unit = old_internal_data.attention_unit

		if old_internal_data.nearest_cover then
			my_data.nearest_cover = old_internal_data.nearest_cover

			managers.navigation:reserve_cover(my_data.nearest_cover[1], data.pos_rsrv_id)
		end

		if old_internal_data.best_cover then
			my_data.best_cover = old_internal_data.best_cover

			managers.navigation:reserve_cover(my_data.best_cover[1], data.pos_rsrv_id)
		end
	end

	if data.char_tweak.announce_incomming then
		my_data.announce_t = data.t + 2
	end

	data.internal_data = my_data
	local key_str = tostring(data.key)
	my_data.upd_task_key = "CopLogicTravel.queued_update" .. key_str

	CopLogicTravel.queue_update(data, my_data)

	my_data.cover_update_task_key = "CopLogicTravel._update_cover" .. key_str

	if my_data.nearest_cover or my_data.best_cover then
		CopLogicBase.add_delayed_clbk(my_data, my_data.cover_update_task_key, callback(CopLogicTravel, CopLogicTravel, "_update_cover", data), data.t + 1)
	end

	my_data.advance_path_search_id = "CopLogicTravel_detailed" .. tostring(data.key)
	my_data.coarse_path_search_id = "CopLogicTravel_coarse" .. tostring(data.key)

	CopLogicIdle._chk_has_old_action(data, my_data)

	local objective = data.objective
	local path_data = objective.path_data

	if objective.path_style == "warp" then
		my_data.warp_pos = objective.pos
	elseif path_data then
		local path_style = objective.path_style

		if path_style == "precise" then
			local path = {
				mvector3.copy(data.m_pos),
			}

			for _, point in ipairs(path_data.points) do
				table.insert(path, mvector3.copy(point.position))
			end

			my_data.advance_path = path
			my_data.coarse_path_index = 1
			local start_seg = data.unit:movement():nav_tracker():nav_segment()
			local end_pos = mvector3.copy(path[#path])
			local end_seg = managers.navigation:get_nav_seg_from_pos(end_pos)
			my_data.coarse_path = {
				{
					start_seg,
				},
				{
					end_seg,
					end_pos,
				},
			}
			my_data.path_is_precise = true
		elseif path_style == "coarse" then
			local nav_manager = managers.navigation
			local f_get_nav_seg = nav_manager.get_nav_seg_from_pos
			local start_seg = data.unit:movement():nav_tracker():nav_segment()
			local path = {
				{
					start_seg,
				},
			}

			for _, point in ipairs(path_data.points) do
				local pos = mvector3.copy(point.position)
				local nav_seg = f_get_nav_seg(nav_manager, pos)

				table.insert(path, {
					nav_seg,
					pos,
				})
			end

			my_data.coarse_path = path
			my_data.coarse_path_index = CopLogicTravel.complete_coarse_path(data, my_data, path)
		elseif path_style == "coarse_complete" then
			my_data.coarse_path_index = 1
			my_data.coarse_path = deep_clone(objective.path_data)
			my_data.coarse_path_index = CopLogicTravel.complete_coarse_path(data, my_data, my_data.coarse_path)
		end
	end

	if objective.stance then
		local upper_body_action = data.unit:movement()._active_actions[3]

		if not upper_body_action or upper_body_action:type() ~= "shoot" then
			data.unit:movement():set_stance(objective.stance)
		end
	end

	if data.attention_obj and AIAttentionObject.REACT_AIM < data.attention_obj.reaction then
		data.unit:movement():set_cool(false, managers.groupai:state().analyse_giveaway(data.unit:base()._tweak_table, data.attention_obj.unit))
	end

	if is_cool then
		data.unit:brain():set_attention_settings({
			peaceful = true,
		})
	else
		data.unit:brain():set_attention_settings({
			cbt = true,
		})
	end

	my_data.attitude = data.objective.attitude or "avoid"
	my_data.weapon_range = data.char_tweak.weapon[data.unit:inventory():equipped_unit():base():weapon_tweak_data().usage].range
	if data.team then
		my_data.path_safely = data.team.foes[tweak_data.levels:get_default_team_ID("player")]
		my_data.path_ahead = data.objective.path_ahead or data.team.id == tweak_data.levels:get_default_team_ID("player")
	else
		local team_id = tweak_data.levels:get_default_team_ID("combatant")
		local foe_id = tweak_data.levels:get_default_team_ID("player")
		my_data.path_safely = tweak_data.levels:get_team_setup()[team_id].foes[foe_id]
		my_data.path_ahead = data.objective.path_ahead or team_id == foe_id

		Eclipse:log_chat("Somehow, a spawned unit has tried to set its objective without its team setup. This is a fallback protocol to set its pathing using default settings.")
	end

	data.unit:brain():set_update_enabled_state(false)
end
