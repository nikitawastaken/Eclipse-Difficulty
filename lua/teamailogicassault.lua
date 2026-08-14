-- Prevent changing back to hostile stance if bot entered with combat stance
local enter_original = TeamAILogicAssault.enter
function TeamAILogicAssault.enter(data, ...)
	local movement = data.unit:movement()
	local set_stance = rawget(movement, "set_stance")

	if movement:stance_code() ~= 1 then
		movement.set_stance = function() end
	end

	enter_original(data, ...)

	movement.set_stance = set_stance
end

-- Don't carry over "firing" variable, it has a chance to stop bots from shooting
Hooks:PostHook(TeamAILogicAssault, "enter", "eclipse_enter", function(data)
	data.internal_data.firing = nil
end)

TeamAILogicAssault._mark_special_chk_t = math.huge -- hacky way to stop the vanilla special mark code

function TeamAILogicAssault.mark_enemy(data, criminal, to_mark)
	if to_mark:base().char_tweak then
		criminal:sound():say(to_mark:base():char_tweak().priority_shout .. "x_any", true)
	end
	managers.network:session():send_to_peers_synched("play_distance_interact_redirect", data.unit, "cmd_point")
	data.unit:movement():play_redirect("cmd_point")
	to_mark:contour():add("mark_enemy", true)
end

-- This function is disabled in vanilla but is not part of TeamAILogicAssault so it might crash in other logics when called with data.logic._upd_sneak_spotting
function TeamAILogicAssault._upd_sneak_spotting() end

-- Fix attention unit reset
Hooks:PostHook(TeamAILogicAssault, "action_complete_clbk", "action_complete_clbk_ub", function(data, action)
	local my_data = data.internal_data
	if action:type() == "shoot" then
		if my_data.attention_unit then
			CopLogicBase._reset_attention(data)
			my_data.attention_unit = nil
		end

		if not data.unit:movement():chk_action_forbidden("action") then
			local mag_total, mag_remaining = data.unit:inventory():equipped_unit():base():ammo_info()
			if mag_remaining < mag_total ^ 0.75 then
				data.brain:action_request({
					body_part = 3,
					type = "reload",
				})
			end
		end
	end

	if not Keepers then
		TeamAILogicIdle._check_objective_pos(data)
	end
end)
