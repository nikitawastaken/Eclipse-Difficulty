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

-- Additional is_custody_trade argument and different hostage outlines for different types of trades
function CopLogicTrade.on_trade(data, pos, rotation, free_criminal, is_custody_trade)
	if not data.internal_data._trade_enabled then
		return
	end

	if free_criminal then
		managers.trade:on_hostage_traded(pos, rotation)
	end

	data.internal_data._trade_enabled = false

	data.unit:network():send("hostage_trade", false, true, false)
	CopLogicTrade.hostage_trade(data.unit, false, true)
	managers.groupai:state():on_hostage_state(false, data.key, managers.enemy:all_enemies()[data.key] and true or false)

	if data.is_converted then
		managers.groupai:state():remove_minion(data.key, nil)
	end

	local ignore_segments = {}
	local flee_pos = managers.groupai:state():flee_point(data.unit:movement():nav_tracker():nav_segment(), ignore_segments)

	if not flee_pos then
		data.unit:set_slot(0)

		return
	end

	local iterations = 1
	local coarse_path = nil
	local my_data = data.internal_data
	local search_params = {
		from_tracker = data.unit:movement():nav_tracker(),
		id = "CopLogicTrade._get_coarse_flee_path" .. tostring(data.key),
		access_pos = data.char_tweak.access
	}
	local max_attempts = 8

	while iterations < max_attempts do
		local nav_seg = managers.navigation:get_nav_seg_from_pos(flee_pos)
		search_params.to_seg = nav_seg
		coarse_path = managers.navigation:search_coarse(search_params)

		if not coarse_path then
			coarse_path = nil

			table.insert(ignore_segments, nav_seg)
		else
			break
		end

		iterations = iterations + 1

		if max_attempts > iterations then
			flee_pos = managers.groupai:state():flee_point(data.unit:movement():nav_tracker():nav_segment(), ignore_segments)

			if not flee_pos then
				break
			end
		end
	end

	if flee_pos then
		data.internal_data.fleeing = true
		data.internal_data.flee_pos = flee_pos

		if data.unit:anim_data().hands_tied or data.unit:anim_data().tied then
			local new_action = nil

			if data.unit:anim_data().stand and data.is_tied then
				new_action = {
					variant = "panic",
					body_part = 1,
					type = "act"
				}
				data.is_tied = nil

				data.unit:movement():set_stance("hos")
			else
				new_action = {
					variant = "stand",
					body_part = 1,
					type = "act"
				}
			end

			data.unit:brain():action_request(new_action)
		end

		-- Different hostage outlines for different types of trades
		-- Also add flashing, it looks cool
		if is_custody_trade then
			data.unit:contour():add("hostage_trade", true, nil)
			data.unit:contour():flash("hostage_trade", 0.5)
		else
			data.unit:contour():add("medic_heal", true, nil)
			data.unit:contour():flash("medic_heal", 0.5)
		end
	else
		data.unit:set_slot(0)
	end

	-- Remove contour from traded hostages and make them invulnerable (sh)
	if not data.internal_data.fleeing then
		return
	end

	data.unit:character_damage():set_invulnerable(true)
	data.unit:network():send("set_unit_invulnerable", true, data.unit:character_damage()._immortal)
	data.unit:contour():remove("hostage_trade", true)
	data.unit:contour():remove("medic_heal", true)
end

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
				managers.hint:show_hint("hud_trade_offered_resources")
			end
		end

		if Network:is_server() and managers.enemy:all_civilians()[unit:key()] and unit:anim_data().stand and unit:brain():is_tied() then
			unit:brain():on_hostage_move_interaction(nil, "stay")
		end

		if Network:is_server() then
			unit:interaction():set_tweak_data("hostage_trade")
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