function CopLogicTrade.enter(data, new_logic_name, enter_params)
	CopLogicBase.enter(data, new_logic_name, enter_params)
	data.unit:brain():cancel_all_pathing_searches()

	local old_internal_data = data.internal_data
	local my_data = {
		unit = data.unit
	}
	data.internal_data = my_data

	data.unit:movement():set_allow_fire(false)
	CopLogicBase._reset_attention(data)

	local skip_hint = enter_params and enter_params.skip_hint or false
	local is_custody_trade = enter_params and enter_params.is_custody_trade or false
	my_data._trade_enabled = true

	data.unit:network():send("hostage_trade", true, false, skip_hint, is_custody_trade)
	CopLogicTrade.hostage_trade(data.unit, true, false, skip_hint, is_custody_trade)
	data.unit:brain():set_update_enabled_state(true)
	data.unit:brain():set_attention_settings({
		peaceful = true
	})
end

-- Remove contour from traded hostages and make them invulnerable
Hooks:PostHook(CopLogicTrade, "on_trade", "sh_on_trade", function(data)
	if not data.internal_data.fleeing then
		return
	end

	data.unit:character_damage():set_invulnerable(true)
	data.unit:network():send("set_unit_invulnerable", true, data.unit:character_damage()._immortal)
	data.unit:contour():remove("hostage_trade", true)
end)

function CopLogicTrade.hostage_trade(unit, enable, trade_success, skip_hint, is_custody_trade)
	local wp_id = "wp_hostage_trade" .. tostring(unit:key())

	if enable then
		local text = managers.localization:text("debug_trade_hostage")

		managers.hud:add_waypoint(wp_id, {
			icon = "wp_trade",
			text = text,
			position = unit:movement():m_pos(),
			distance = SystemInfo:platform() == Idstring("WIN32")
		})

		if managers.network:session() and not managers.trade:is_peer_in_custody(managers.network:session():local_peer():id()) and not skip_hint then
			-- If the trade is for resources then show a different message
			if is_custody_trade then
				managers.hint:show_hint("trade_offered")
			else
				managers.hud:show_hint( { text = managers.localization:text("hint_trade_offered_resources") } )
			end
		end

		if Network:is_server() and managers.enemy:all_civilians()[unit:key()] and unit:anim_data().stand and unit:brain():is_tied() then
			unit:brain():on_hostage_move_interaction(nil, "stay")
		end

		if Network:is_server() then
			if is_custody_trade then
				unit:interaction():set_tweak_data("hostage_trade")
				unit:contour():flash("hostage_trade_uncustody", 0.5)
			else
				unit:interaction():set_tweak_data("hostage_trade_resources")
				unit:contour():flash("hostage_trade_resources", 0.5)
			end
			unit:interaction():set_active(true, true)
		end

		if Network:is_server() and not unit:anim_data().hands_tied and not unit:anim_data().tied then
			local action_data = nil

			if managers.enemy:all_civilians()[unit:key()] then
				if not unit:brain():is_tied() then
					action_data = {
						clamp_to_graph = true,
						type = "act",
						body_part = 1,
						variant = "tied",
						blocks = {
							light_hurt = -1,
							hurt = -1,
							heavy_hurt = -1,
							walk = -1
						}
					}
				end
			else
				action_data = {
					clamp_to_graph = true,
					type = "act",
					body_part = 1,
					variant = "tied_all_in_one",
					blocks = {
						light_hurt = -1,
						hurt = -1,
						heavy_hurt = -1,
						walk = -1
					}
				}
			end

			if action_data then
				unit:brain():action_request(action_data)
			end
		end
	else
		managers.hud:remove_waypoint(wp_id)

		if trade_success then
			unit:interaction():set_active(false, false)
		else
			unit:interaction():set_active(false, false)

			if managers.enemy:all_civilians()[unit:key()] then
				unit:interaction():set_tweak_data("hostage_move")
			else
				unit:interaction():set_tweak_data("intimidate")
			end

			unit:interaction():set_active(false, false)
		end
	end
end