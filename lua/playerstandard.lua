-- Friendly Fire
local original_init = PlayerStandard.init
function PlayerStandard:init(unit)
    original_init(self, unit)

    if Global.game_settings and Global.game_settings.one_down then
        self._slotmask_bullet_impact_targets = self._slotmask_bullet_impact_targets + 3
    else
        self._slotmask_bullet_impact_targets = managers.mutators:modify_value("PlayerStandard:init:melee_slot_mask", self._slotmask_bullet_impact_targets)
    end
end

-- No more sixth sense
Hooks:OverrideFunction(PlayerStandard, "_update_omniscience", "_eclipse_update_omniscience",
function(self, ...)
    return
end)

-- Don't update sixth sense anymore
Hooks:OverrideFunction(PlayerStandard, "update", "eclipse_update",
function(self, t, dt)
    PlayerMovementState.update(self, t, dt)
    self:_calculate_standard_variables(t, dt)
    self:_update_ground_ray()
    self:_update_fwd_ray()
    self:_update_check_actions(t, dt)

    if self._menu_closed_fire_cooldown > 0 then
        self._menu_closed_fire_cooldown = self._menu_closed_fire_cooldown - dt
    end

    self:_update_movement(t, dt)
    self:_upd_nav_data()
    managers.hud:_update_crosshair_offset(t, dt)
    self:_upd_stance_switch_delay(t, dt)
end)
