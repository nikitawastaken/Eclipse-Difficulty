-- Friendly Fire
function ProjectileBase:create_sweep_data()
    self._sweep_data = {
        slot_mask = self._slot_mask
    }

    if Global.game_settings and Global.game_settings.one_down then
        self._sweep_data.slot_mask = self._sweep_data.slot_mask + 3
    else
        self._sweep_data.slot_mask = managers.mutators:modify_value("ProjectileBase:create_sweep_data:slot_mask", self._sweep_data.slot_mask)
        self._sweep_data.slot_mask = managers.modifiers:modify_value("ProjectileBase:create_sweep_data:slot_mask", self._sweep_data.slot_mask)
    end

    self._sweep_data.current_pos = self._unit:position()
    self._sweep_data.last_pos = mvector3.copy(self._sweep_data.current_pos)
end