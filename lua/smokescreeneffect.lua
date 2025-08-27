function SmokeScreenEffect:init(position, normal, time, has_armor_bonus, has_dodge_bonus, linger_bonus, grenade_unit)
	self._timer = time
	self._position = position
	self._radius = 400
	self._unit_list = {}
	self._armor_bonus = has_armor_bonus -- breathe deep
	self._new_dodge_bonus = has_dodge_bonus -- smog layer
	self._dodge_bonus = 0 -- used for old smoke bomb buff so i'd rather hardcode this to 0 than overwrite the entire skill_dodge_chance() function in PlayerManager just to get rid of old functionality
	self._sound_source = SoundDevice:create_source("ExplosionManager")

	self._sound_source:set_position(position)
	self._sound_source:post_event("lung_explode")

	self._effect = World:effect_manager():spawn({
		effect = Idstring("effects/particles/explosions/smoke_screen"),
		position = position,
		normal = normal,
	})
	self._variant = grenade_unit and grenade_unit:base() and grenade_unit:base()._projectile_entry
	self._mine = grenade_unit and grenade_unit:base():thrower_unit() == managers.player:player_unit()
	self._linger_time = linger_bonus -- lingering shadows
	self._smoke_history = {}
end

function SmokeScreenEffect:armor_bonus()
	return self._armor_bonus
end

function SmokeScreenEffect:new_dodge_bonus()
	return self._new_dodge_bonus
end

function SmokeScreenEffect:update(_, dt)
	if self._timer then
		self._timer = self._timer - dt

		if self._timer <= 2 then
			World:effect_manager():fade_kill(self._effect)

			if not self._sound_killed then
				self._sound_source:post_event("lung_loop_end")
				managers.enemy:add_delayed_clbk(
					"SmokeScreenEffect",
					callback(ProjectileBase, ProjectileBase, "_dispose_of_sound", {
						sound_source = self._sound_source,
					}),
					TimerManager:game():time() + 4
				)

				self._sound_killed = true
			end
		end

		if self._timer <= 0 then
			self._timer = nil
		end
	end

	self._unit_list = {}
	local nearby_units = World:find_units_quick("sphere", self._position, self._radius, managers.slot:get_mask("persons"))
	local now = TimerManager:game():time()

	for _, unit in ipairs(nearby_units) do
		self._unit_list[unit:key()] = true
		self._smoke_history[unit:key()] = now
	end

	for key, last_time in pairs(self._smoke_history) do
		if now - last_time > self._linger_time then
			self._smoke_history[key] = nil
		end
	end
end

function SmokeScreenEffect:is_in_smoke(unit)
	local now = TimerManager:game():time()
	local last = self._smoke_history[unit:key()]

	local in_smoke = self._unit_list[unit:key()] or (last and now - last <= self._linger_time)

	return in_smoke, self._variant
end
