function PlayerTased:enter(state_data, enter_data)
	PlayerTased.super.enter(self, state_data, enter_data)
	self:_start_action_tased(managers.player:player_timer():time(), state_data.non_lethal_electrocution)

	if state_data.non_lethal_electrocution then
		state_data.non_lethal_electrocution = nil
		local recover_time = Application:time()
			+ tweak_data.player.damage.TASED_TIME * managers.player:upgrade_value("player", "electrocution_resistance_multiplier", 1) * (state_data.electrocution_duration_multiplier or 1)
		state_data.electrocution_duration_multiplier = nil
		self._recover_delayed_clbk = "PlayerTased_recover_delayed_clbk"

		managers.enemy:add_delayed_clbk(self._recover_delayed_clbk, callback(self, self, "clbk_exit_to_std"), recover_time)
	else
		self._fatal_delayed_clbk = "PlayerTased_fatal_delayed_clbk"
		local tased_time = tweak_data.player.damage.TASED_TIME
		tased_time = managers.modifiers:modify_value("PlayerTased:TasedTime", tased_time)

		managers.enemy:add_delayed_clbk(self._fatal_delayed_clbk, callback(self, self, "clbk_exit_to_fatal"), TimerManager:game():time() + tased_time)

		if Network:is_server() then
			self:_register_revive_SO()
		end
	end

	self._next_shock = 0.5
	self._taser_value = 1
	self._num_shocks = 0

	managers.groupai:state():on_criminal_disabled(self._unit, "electrified")
	--remove the on_reload call to get rid of autoreloading when you get tased

	local projectile_entry = managers.blackmarket:equipped_projectile()

	if tweak_data.blackmarket.projectiles[projectile_entry].is_a_grenade then
		self:_interupt_action_throw_grenade()
	else
		self:_interupt_action_throw_projectile()
	end

	self:_interupt_action_reload()
	self:_interupt_action_steelsight()
	self:_interupt_action_melee(managers.player:player_timer():time())
	self:_interupt_action_ladder(managers.player:player_timer():time())
	self:_interupt_action_charging_weapon(managers.player:player_timer():time())

	self._rumble_electrified = managers.rumble:play("electrified")
	self.tased = true
	self._state_data = state_data

	CopDamage.register_listener("on_criminal_tased", {
		"on_criminal_tased",
	}, callback(self, self, "_on_tased_event"))
	
	self._saved_default_color_grading = managers.environment_controller:default_color_grading()
	managers.environment_controller:set_default_color_grading("color_bhd_classic", true)
	managers.environment_controller:set_downed_value(40)
	managers.environment_controller:refresh_render_settings()
end

Hooks:PostHook(PlayerTased, "exit", "eclipse_exit", function(self)
	-- Remove camera limits upon exiting the tased state
	if self._camera_limit then
		self._unit:camera():camera_unit():base():remove_limits()
		self._camera_limit = nil
	end
	
	managers.hud:effect_screen(1, {0, 0.1, 0.3}, "screen_vignette")
	managers.hud:effect_screen(1, {0.2, 0.1, 0.1}, "screen_vignette_reversed")
	
	managers.environment_controller:set_default_color_grading(self._saved_default_color_grading)
	managers.environment_controller:set_downed_value(0)
	managers.environment_controller:refresh_render_settings()
end)

local _check_action_shock_original = PlayerTased._check_action_shock
function PlayerTased:_check_action_shock(t, input, ...)
	local do_shock = self._next_shock and self._next_shock < t

	_check_action_shock_original(self, t, input, ...)

	local tase_strength = tweak_data.character.tase_strength or { 5, 90 }
	local tase_strength_mul = tweak_data.character.tase_strength_multiplier or { 1, 1 }
	local last_man_standing_mul = managers.groupai:state():num_alive_criminals() == 1 and 0.5 or 1 -- weaker random pitch when last man standing / true solo
	local weaker_tase = managers.player:upgrade_value("player", "weaker_tase_effect", 0)

	local shock_strength_h = tase_strength[1] * tase_strength_mul[1] * last_man_standing_mul * (1 - weaker_tase)
	local shock_strength_v = tase_strength[2] * tase_strength_mul[2] * last_man_standing_mul * (1 - weaker_tase)

	if do_shock then
		if tweak_data.character.tased_camera_limit_shocks and self._num_shocks > tweak_data.character.tased_camera_limit_shocks and not self._camera_limit then
			self._unit:camera():camera_unit():base():set_limits(tweak_data.character.tased_camera_limit[1], tweak_data.character.tased_camera_limit[2])

			self._camera_limit = true
		end
		
		managers.hud:effect_screen(1, {0, 0.2, 0.4}, "screen_vignette")
		managers.hud:effect_screen(1, {0.24, 0, 0}, "screen_vignette_reversed")

		self._cam_start_pitch = self._unit:camera():camera_unit():base()._camera_properties.pitch
		self._cam_target_pitch = math.clamp(self._cam_start_pitch + math.rand(-shock_strength_h, shock_strength_h), -shock_strength_v, shock_strength_v)
		self._cam_start_pitch_t = t
		self._cam_target_pitch_t = t + 0.2
	end

	if self._cam_start_pitch then
		if t > self._cam_target_pitch_t then
			self._cam_start_pitch = nil
		else
			local pitch = math.map_range(t, self._cam_start_pitch_t, self._cam_target_pitch_t, self._cam_start_pitch, self._cam_target_pitch)
			self._unit:camera():camera_unit():base():set_pitch(pitch)

			-- Full suppression
			self._ext_damage:build_suppression(tweak_data.player.suppression.max_value)
		end
	end

	local tased_full_stun = managers.mutators:modify_value("PlayerTased:TaserFullStun", false)
	if tased_full_stun then
		if tweak_data.character.tased_full_stun_shocks and self._num_shocks >= tweak_data.character.tased_full_stun_shocks then
			self._ext_camera:play_redirect(self:get_animation("tased_exit"))
			self:_start_action_unequip_weapon(managers.player:player_timer():time(), {
				selection_wanted = 1,
			})
			self:_play_unequip_animation()
		end
	end
end
