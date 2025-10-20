Hooks:PostHook(ConcussionGrenade, "_setup_from_tweak_data", "eclipse_setup_from_tweak_data", function(self)
	self._custom_params.camera_shake_max_mul = 0.75 -- reduce screenshake
end)

function ConcussionGrenade:_flash_player()
	local detonate_pos = self._unit:position() + math.UP * 100
	local range = self._PLAYER_FLASH_RANGE
	local affected, line_of_sight, travel_dis, linear_dis = QuickFlashGrenade._chk_dazzle_local_player(self, detonate_pos, range)

	if affected then
		managers.environment_controller:set_flashbang(detonate_pos, line_of_sight, travel_dis, linear_dis, 0.8, nil, true)

		local sound_eff_mul = math.clamp(1 - (travel_dis or linear_dis) / range, 0.3, 1)

		managers.player:player_unit():character_damage():on_flashbanged(sound_eff_mul)
	end
end
