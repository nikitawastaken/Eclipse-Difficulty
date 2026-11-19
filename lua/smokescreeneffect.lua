local mvec3_dist_sq = mvector3.distance_sq

function SmokeScreenEffect:init(position, normal, timer_override, has_dodge_bonus, grenade_unit, linger_bonus, has_armor_bonus)
	self._position = position
	self._radius = self.DEFAULT_RADIUS
	self._radius_sq = self._radius * self._radius
	self._armor_bonus = has_armor_bonus -- breathe deep
	self._new_dodge_bonus = has_dodge_bonus -- smog layer
	self._dodge_bonus = 0 -- used for old smoke bomb buff so i'd rather hardcode this to 0 than overwrite the entire skill_dodge_chance() function in PlayerManager just to get rid of old functionality
	self._linger_time = linger_bonus or 0 -- lingering shadows

	if self.SOUND_EVENT_NAME then
		self._sound_source = SoundDevice:create_source("SmokeScreenEffect")

		self._sound_source:set_position(position)
		self._sound_source:post_event(self.SOUND_EVENT_NAME)
	end

	if self.EFFECT_IDS then
		self._effect = World:effect_manager():spawn({
			effect = self.EFFECT_IDS,
			position = position,
			normal = normal
		})
	end

	if alive(grenade_unit) then
		self._grenade_unit = grenade_unit

		local base_ext = grenade_unit:base()

		if base_ext then
			self._variant = base_ext._projectile_entry
			self._tweak_entry = tweak_data.projectiles[self._variant]
			self._mine = base_ext:thrower_unit() == managers.player:player_unit()
		end
	end

	self._timer = timer_override or self._tweak_entry and self._tweak_entry.duration or tweak_data.projectiles.smoke_screen_grenade.duration
end

function SmokeScreenEffect:armor_bonus()
	return self._armor_bonus
end

function SmokeScreenEffect:new_dodge_bonus()
	return self._new_dodge_bonus
end

function SmokeScreenEffect:is_in_smoke(m_pos)
	local in_smoke = mvec3_dist_sq(m_pos, self._position) <= self._radius_sq

	if in_smoke then
		managers.player:set_lingering_shadow_timer(self._linger_time)
	end

	return in_smoke, self._variant, self._tweak_entry
end
