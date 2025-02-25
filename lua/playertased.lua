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
end

local _check_action_shock_original = PlayerTased._check_action_shock
function PlayerTased:_check_action_shock(t, input, ...)
	local do_shock = self._next_shock and self._next_shock < t

	_check_action_shock_original(self, t, input, ...)

	local weaker_tase = managers.player:upgrade_value("player", "weaker_tase_effect", 0)
	local is_last_man_standing = ((managers.groupai:state():num_alive_criminals() == 1 and 0.5) or 1) -- weaker random pitch when last man standing / true solo
	local shock_strength = (tweak_data.character.tase_shock_strength or 4) * (1 - weaker_tase) * is_last_man_standing

	if do_shock then
		self._cam_start_pitch = self._unit:camera():camera_unit():base()._camera_properties.pitch
		self._cam_target_pitch = math.clamp(self._cam_start_pitch + math.rand(-shock_strength, shock_strength), -90, 90)
		self._cam_start_pitch_t = t
		self._cam_target_pitch_t = t + 0.2
	end

	if self._cam_start_pitch then
		if t > self._cam_target_pitch_t then
			self._cam_start_pitch = nil
		else
			local pitch = math.map_range(t, self._cam_start_pitch_t, self._cam_target_pitch_t, self._cam_start_pitch, self._cam_target_pitch)
			self._unit:camera():camera_unit():base():set_pitch(pitch)
		end
	end
end
