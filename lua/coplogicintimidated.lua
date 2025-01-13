local tmp_vec = Vector3()

-- Tweak hostage rescue conditions
function CopLogicIntimidated.rescue_SO_verification(ignore_this, data, unit, ...)
	if unit:movement():cool() then
		return false
	end

	if not unit:base():char_tweak().rescue_hostages then
		return false
	end

	if data.team.foes[unit:movement():team().id] then
		return false
	end

	local objective = unit:brain():objective()
	if not objective or objective.type == "free" or not objective.area then
		return true
	end

	local nav_seg = unit:movement():nav_tracker():nav_segment()
	local hostage_nav_seg = data.unit:movement():nav_tracker():nav_segment()
	if objective.area.nav_segs[hostage_nav_seg] or hostage_nav_seg == nav_seg then
		return objective.area.nav_segs[nav_seg] or managers.groupai:state()._rescue_allowed
	end
end

-- Fix and improve enemies breaking out of intimidated state
-- Don't immediately break out of surrender when the conditions are met
Hooks:PostHook(CopLogicIntimidated, "enter", "sh_enter", function(data)
	data.internal_data.surrender_break_delay_t = TimerManager:game():time() + 2
end)

Hooks:PostHook(CopLogicIntimidated, "on_intimidated", "sh_on_intimidated", function(data)
	data.internal_data.surrender_break_delay_t = data.t + 2
end)

function CopLogicIntimidated._update_enemy_detection(data, my_data)
	data.t = TimerManager:game():time()

	if my_data.tied then
		return
	end

	if my_data.surrender_break_delay_t and data.t < my_data.surrender_break_delay_t then
		return
	end

	if not my_data.surrender_break_t or data.t < my_data.surrender_break_t then
		local max_intimidation_range = tweak_data.player.long_dis_interaction.intimidate_range_enemies
			* tweak_data.upgrades.values.player.intimidate_range_mul[1]
			* tweak_data.upgrades.values.player.passive_intimidate_range_mul[1]
			* 1.05

		for u_key, u_data in pairs(managers.groupai:state():all_char_criminals()) do
			if not u_data.status and mvector3.direction(tmp_vec, data.m_pos, u_data.m_pos) < max_intimidation_range then
				if mvector3.dot(u_data.unit:movement():detect_look_dir(), tmp_vec) < -0.5 then
					if not World:raycast("ray", data.unit:movement():m_head_pos(), u_data.m_det_pos, "slot_mask", data.visibility_slotmask, "ray_type", "ai_vision", "report") then
						-- There's a criminal looking at us, do not break out of surrender for at least 1.5 seconds
						my_data.surrender_break_check_t = data.t + 1.5
						return
					end
				end
			end
		end

		if my_data.surrender_break_check_t and data.t < my_data.surrender_break_check_t then
			return
		end
	end

	my_data.surrender_clbk_registered = nil

	data.brain:set_objective(nil)
	CopLogicBase._exit(data.unit, "attack")
end
