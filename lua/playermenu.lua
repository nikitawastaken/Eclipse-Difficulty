-- Increase player gravity to make movement less floaty
function PlayerMenu:_create_mover()
	if self._is_start_menu then
		self._mover_unit = World:spawn_unit(Idstring("units/pd2_dlc_vr/units/menu_mover"), Vector3(0, 0, 0), Rotation())

		self._mover_unit:camera():set_menu_player(self)
		self._mover_unit:mover():set_velocity(Vector3())
		self._mover_unit:mover():set_gravity(Vector3(0, 0, tweak_data.player.gravity))
		self._mover_unit:set_position(self._position)
	end
end
