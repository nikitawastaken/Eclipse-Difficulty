-- Fix npc akimbo weapons to aktually fire both guns
function NPCAkimboWeaponBase:fire(...)
	if self._fire_second_gun_next then
		self._fire_second_gun_next = false
		if alive(self._second_gun) then
			return self._second_gun:base().super.fire(self._second_gun:base(), ...)
		end
	else
		self._fire_second_gun_next = true
		return self.super.fire(self, ...)
	end
end
