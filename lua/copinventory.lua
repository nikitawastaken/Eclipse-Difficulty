Hooks:PostHook(CopInventory, "init", "eclipse_init", function(self)
	-- Add left hand align place for akimbo weapons
	self._align_places.left_hand = self._align_places.left_hand or {
		on_body = true,
		obj3d_name = Idstring("a_weapon_left_front"),
	}
end)
