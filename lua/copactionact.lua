-- Add interaction animations to make sure they appear properly for clients
table.insert(CopActionAct._act_redirects.script, "interact_enter")
table.insert(CopActionAct._act_redirects.script, "interact_exit")

if not Network:is_server() then
	return
end

local sabotage_actions = {
	untie = true,
	sabotage_device_low = true,
	sabotage_device_mid = true,
	sabotage_device_high = true,
	e_so_disarm_bomb = true,
	e_so_push_button_low = true,
	e_so_low_kicks = true,
	e_so_stomp = true,
	e_so_tube_interact = true,
	e_so_balloon = true,
	e_so_plant_c4_low = true,
	e_so_plant_c4_hi = true,
	e_so_interact_mid = true,
	e_so_plant_c4_floor = true,
	e_so_pull_lever = true,
	e_so_pull_lever_var2 = true,
	e_so_press_button_mid = true,
	e_so_ntl_lever_press = true,
	e_so_release_hostage_back = true,
	e_so_release_hostage_left = true,
	e_so_release_hostage_right = true
}

-- Make bots aware of sabotaging enemies
Hooks:PostHook(CopActionAct, "init", "eclipse_init", function (self)
	if sabotage_actions[self._action_desc.variant] then
		self._is_sabotaging_action = true	
		Eclipse.utils.team_ai_force_attention(self._unit)
	end
end)
