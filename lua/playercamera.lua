-- aimpunch
local play_shaker_original = PlayerCamera.play_shaker
function PlayerCamera:play_shaker(effect, amplitude, ...)
	return play_shaker_original(
		self,
		effect,
		effect == "player_bullet_damage" and self._damage_bullet_shake_multiplier or effect == "player_bullet_damage_knock_out" and self._damage_bullet_shake_multiplier or amplitude,
		...
	)
end
