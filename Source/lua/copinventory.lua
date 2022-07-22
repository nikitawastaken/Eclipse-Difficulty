-- Add left hand align place for akimbo weapons
Hooks:PostHook(CopInventory, "init", "sh_init", function (self)
	self._align_places.left_hand = self._align_places.left_hand or {
		on_body = true,
		obj3d_name = Idstring("a_weapon_left_front")
	}
end)
