-- Add left hand align place for akimbo weapons
Hooks:PostHook(CopInventory, "init", "sh_init", function (self)
	self._align_places.left_hand = self._align_places.left_hand or {
		on_body = true,
		obj3d_name = Idstring("a_weapon_left_front")
	}
end)

-- always glow cloakers by jarey
local _f_add_unit_by_name = CopInventory.add_unit_by_name
function CopInventory:add_unit_by_name(...)
	_f_add_unit_by_name(self, ...)
	if self._unit:base()._tweak_table == "spooc" and self._unit:damage() then
		if self._unit:damage():has_sequence("turn_on_spook_lights") then
			self._unit:damage():run_sequence_simple("turn_on_spook_lights")
		end
	end
end