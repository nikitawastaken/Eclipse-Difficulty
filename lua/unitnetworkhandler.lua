-- Force Cloakers to stand up before starting an attack on clients
Hooks:PreHook(UnitNetworkHandler, "action_spooc_start", "sh_action_spooc_start", function (self, unit)
	if not self._verify_character(unit) or not self._verify_gamestate(self._gamestate_filter.any_ingame) then
		return
	end

	unit:movement():action_request({
		body_part = 4,
		type = "stand"
	})

	unit:movement():action_request({
		body_part = 3,
		type = "idle"
	})
end)


-- Fix function ignoring the actual aim state parameter and always starting a shoot action (thanks to RedFlame)
function UnitNetworkHandler:action_aim_state(cop, start)
	if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not self._verify_character(cop) then
		return
	end

	if start then
		cop:movement():action_request({
			block_type = "action",
			body_part = 3,
			type = "shoot"
		})
	else
		cop:movement():sync_action_aim_end()
	end
end


-- Properly sync reload
function UnitNetworkHandler:reload_weapon_cop(cop, sender)
	if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not self._verify_character_and_sender(cop, sender) then
		return
	end

	if not alive(cop) then
		return
	end

	local current_action = cop:movement():get_action(3)
	if current_action and current_action:type() == "shoot" then
		-- If we are currently in shoot action, set the mag to empty
		cop:inventory():equipped_unit():base():ammo_base():set_ammo_remaining_in_clip(0)
	else
		-- Otherwise request an actual reload action
		cop:movement():action_request({
			body_part = 3,
			type = "reload"
		})
	end
end
