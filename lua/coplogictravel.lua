local math_random = math.random
local mvec3_add = mvector3.add
local mvec3_cross = mvector3.cross
local mvec3_dir = mvector3.direction
local mvec3_dis = mvector3.distance
local mvec3_dis_sq = mvector3.distance_sq
local mvec3_lerp = mvector3.lerp
local mvec3_mul = mvector3.multiply
local mvec3_neg = mvector3.negate
local mvec3_normalize = mvector3.normalize
local mvec3_set = mvector3.set
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
local tmp_vec3 = Vector3()


-- Reuse function of idle logic to make enemies in an area aware of a player entering the area
CopLogicTravel.on_area_safety = CopLogicIdle.on_area_safety


-- Update pathing immediately when receiving travel logic or pathing results
Hooks:PostHook(CopLogicTravel, "enter", "sh_enter", CopLogicTravel.upd_advance)

function CopLogicTravel.on_pathing_results(data)
	CopLogicTravel.upd_advance(data)
end


-- Fix need for another queued task to update pathing or leaving cover on expired cover time
-- Basically just does the needed checks before calling the original function to save on a queued update
Hooks:PreHook(CopLogicTravel, "upd_advance", "sh_upd_advance", function (data)
	local unit = data.unit
	local my_data = data.internal_data
	local t = TimerManager:game():time()
	if my_data.processing_advance_path or my_data.processing_coarse_path then
		CopLogicTravel._upd_pathing(data, my_data)
	elseif my_data.cover_leave_t then
		if my_data.coarse_path and my_data.coarse_path_index == #my_data.coarse_path or my_data.cover_leave_t < t and not unit:movement():chk_action_forbidden("walk") and not data.unit:anim_data().reload then
			my_data.cover_leave_t = nil
		end
	end
end)


-- Make groups move together (remove close to criminal check to avoid splitting groups)
function CopLogicTravel.chk_group_ready_to_move(data, my_data)
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

	if alive(data.objective.shield_cover_unit) then
		if my_data.moving_to_cover then
			nav_manager:release_cover(my_data.moving_to_cover[1])
			my_data.moving_to_cover = nil
		end

		local pos = CopLogicTravel._get_pos_behind_unit(data, data.objective.shield_cover_unit, 50, 300)
		return pos or _get_exact_move_pos_original(data, nav_index, ...)
	end

	local coarse_path = my_data.coarse_path
	if nav_index >= #coarse_path or data.objective.follow_unit then
		return _get_exact_move_pos_original(data, nav_index, ...)
	end

	if my_data.moving_to_cover then
		nav_manager:release_cover(my_data.moving_to_cover[1])
		my_data.moving_to_cover = nil
	end

	local nav_seg_id = coarse_path[nav_index][1]
	local next_nav_seg_id = coarse_path[nav_index + 1][1]
	local to_pos = nav_manager._nav_segments[nav_seg_id].pos

	-- Pick cover positions that are close to nav segment doors
	local doors = nav_manager:find_segment_doors(nav_seg_id, function (seg_id) return seg_id == next_nav_seg_id end)
	local door = table.random(doors)
	if door then
		-- First step from the door we want to go to to the nav segment center
		-- Then from there step towards the door we entered from
		-- The resulting position is the desired cover position before entering through the next door
		mvector3.step(tmp_vec1, door.center, to_pos, 150)
		if coarse_path[nav_index][2] then -- Iter sometimes makes coarse paths without positions for some reason
			mvector3.step(tmp_vec1, tmp_vec1, coarse_path[nav_index][2], 150)
		end
		to_pos = tmp_vec1
	end

	local cover = nav_manager:find_cover_in_nav_seg_2(nav_seg_id, to_pos)
	if cover then
		nav_manager:reserve_cover(cover, data.pos_rsrv_id)
		my_data.moving_to_cover = {
			cover
		}
		to_pos = cover[1]
	else
		to_pos = CopLogicTravel._get_pos_on_wall(to_pos, 500)
	end

	return to_pos
end

local _determine_destination_occupation_original = CopLogicTravel._determine_destination_occupation
function CopLogicTravel._determine_destination_occupation(data, objective, ...)
	if objective.type ~= "defend_area" or objective.cover or objective.pos or data.kpr_keep_position then
		return _determine_destination_occupation_original(data, objective, ...)
	end

	local near_pos = objective.follow_unit and objective.follow_unit:movement():nav_tracker():field_position()
	local cover = CopLogicTravel._find_cover(data, objective.nav_seg, near_pos)
	if cover then
		return {
			type = "defend",
			seg = objective.nav_seg,
			cover = {
				cover
			},
			radius = objective.radius
		}
	else
		near_pos = CopLogicTravel._get_pos_on_wall(managers.navigation:find_random_position_in_segment(objective.nav_seg), 500)
		return {
			type = "defend",
			seg = objective.nav_seg,
			pos = near_pos,
			radius = objective.radius
		}
	end
end

function CopLogicTravel._get_pos_behind_unit(data, unit, min_dis, max_dis)
	local advancing = unit:brain() and unit:brain():is_advancing()
	local unit_movement = unit:movement()
	local unit_pos = advancing or unit_movement:m_pos()
	-- If target unit is advancing, add an offset so we don't run in front of it during advance
	local offset = advancing and mvec3_dis(advancing, unit_movement:m_pos()) * 0.5 or 0

	-- Get the threat direction
	if data.attention_obj and data.attention_obj.reaction >= AIAttentionObject.REACT_AIM then
		mvec3_dir(tmp_vec1, data.attention_obj.m_pos, unit_pos)
	else
		mvec3_set(tmp_vec1, unit_movement.m_fwd and unit_movement:m_fwd() or unit_movement:m_head_rot():y())
		mvec3_neg(tmp_vec1)
	end

	-- Threat direction side
	mvec3_cross(tmp_vec2, tmp_vec1, math.UP)

	local fallback_pos
	local rays = 7
	local min_dis_sq = min_dis ^ 2
	local nav_manager = managers.navigation
	local ray_params = {
		allow_entry = false,
		trace = true,
		pos_from = unit_pos
	}
	local rsrv_desc = {
		false,
		40
	}

	repeat
		if math_random() < 0.5 then
			mvec3_neg(tmp_vec2)
		end

		-- Get a random vector between main threat direction and side threat direction
		mvec3_lerp(tmp_vec3, tmp_vec1, tmp_vec2, math_random() * 0.5)
		mvec3_normalize(tmp_vec3)
		mvec3_mul(tmp_vec3, offset + math_random(min_dis, max_dis))
		mvec3_add(tmp_vec3, unit_pos)

		ray_params.pos_to = tmp_vec3
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