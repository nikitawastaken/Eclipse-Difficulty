function PoisonGasEffect:init(position, normal, projectile_tweak, grenade_unit)
	self._position = position
	self._normal = normal
	grenade_unit = alive(grenade_unit) and grenade_unit or nil

	if grenade_unit then
		self._grenade_unit = grenade_unit
	end

	self._tweak_data = projectile_tweak
	self._user_unit = grenade_unit and grenade_unit:base():thrower_unit()
	self._is_local_player = grenade_unit and grenade_unit:base():thrower_unit() == managers.player:player_unit()
	self._grenade_id = grenade_unit and grenade_unit:base():projectile_entry()
	self._range = projectile_tweak.poison_gas_range or 1500
	self._timer = projectile_tweak.poison_gas_duration or 25
	self._damage_tick_timer = projectile_tweak.poison_gas_tick_time or 0.1
	self._fade_time = projectile_tweak.poison_gas_fade_time or 2
	self._dot_data = projectile_tweak.poison_gas_dot_data_name and tweak_data.dot:get_dot_data(projectile_tweak.poison_gas_dot_data_name) or tweak_data.dot:get_dot_data("weapon_dotbulletbase")
	self._sound_source = SoundDevice:create_source("ExplosionManager")
	-- New attributes
	self._player_damage = projectile_tweak.gas_player_damage or 0.05 -- Player FF damage
	self._has_played_VO = false -- Tear gas VO check
	self._last_damage_tick = 0 -- Time when player got viper gas FF
	self._damage_tick_period = projectile_tweak.damage_tick_period or 0.25 -- Viper gas grace period
	self._radius_blurzone_multiplier = projectile_tweak.radius_blurzone_multiplier or 1.3 -- Blurzone modifier

	self._sound_source:set_position(position)

	self._unit_list = {}
	self._effect = World:effect_manager():spawn({
		effect = self._tweak_data.poison_gas_effect and Idstring(self._tweak_data.poison_gas_effect) or Idstring("effects/particles/explosions/poison_gas"),
		position = position,
		normal = normal,
	})
	--Blurzone setup
	local blurzone_radius = self._range * self._radius_blurzone_multiplier
	managers.environment_controller:set_blurzone(self._grenade_unit:key(), 1, self._grenade_unit:position(), blurzone_radius, 0, true)
end

function PoisonGasEffect:update(t, dt)
	if self._timer then
		self._timer = self._timer - dt

		local nearby_players = World:find_units_quick("sphere", self._position, self._range, managers.slot:get_mask("players"))
		for _, unit in ipairs(nearby_players) do
			self:_do_damage(t)
		end
		if not self._started_fading and self._timer <= self._fade_time then
			World:effect_manager():fade_kill(self._effect)
			managers.environment_controller:set_blurzone(self._grenade_unit:key(), 0)

			self._started_fading = true
		end

		if self._timer <= 0 then
			self._timer = nil

			if alive(self._grenade_unit) and (Network:is_server() or self._grenade_unit:id() == -1) then
				managers.enemy:add_delayed_clbk(
					"PoisonGasEffect" .. tostring(self._grenade_unit:key()),
					callback(PoisonGasEffect, PoisonGasEffect, "remove_grenade_unit"),
					TimerManager:game():time() + self._dot_data.dot_length + 1
				)
			end
		end

		if self._is_local_player then
			self._damage_tick_timer = self._damage_tick_timer - dt

			if self._damage_tick_timer <= 0 then
				self._damage_tick_timer = self._tweak_data.poison_gas_tick_time or 0.1
				local nearby_units = World:find_units_quick("sphere", self._position, self._range, managers.slot:get_mask("enemies"))

				for _, unit in ipairs(nearby_units) do
					if not self._unit_list[unit:key()] then
						self._unit_list[unit:key()] = true
						local data = {
							unit = unit,
							dot_data = self._dot_data,
							hurt_animation = not self._dot_data.hurt_animation_chance or math.rand(1) < self._dot_data.hurt_animation_chance,
							weapon_id = self._grenade_id,
							weapon_unit = alive(self._grenade_unit) and self._grenade_unit or nil,
							attacker_unit = alive(self._user_unit) and self._user_unit or nil,
						}

						managers.dot:add_doted_enemy(data)
					end
				end
			end
		end
	end
end

-- Nuke forced effect kill (why it exist when fade_kill effect already trigger in update function)
function PoisonGasEffect:destroy()
	self._timer = nil
end

function PoisonGasEffect:_do_damage(t)
	local player_unit = managers.player:player_unit()
	if not alive(player_unit) or t < self._last_damage_tick + self._damage_tick_period then
		return
	end

	if player_unit and mvector3.distance_sq(self._position, player_unit:position()) < self._range ^ 2 then
		self._last_damage_tick = t
		player_unit:character_damage():damage_killzone({
			variant = "teargas",
			damage = self._player_damage,
			col_ray = {
				ray = math.UP,
			},
		})

		if not self._has_played_VO then
			PlayerStandard.say_line(player_unit:sound(), "g42x_any")
			self._has_played_VO = true
		end
	end
end
