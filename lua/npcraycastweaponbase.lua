Hooks:PreHook(NPCRaycastWeaponBase, "_fire_raycast", "_eclipse_fire_raycast", function(self, shoot_player, ...)
    local __hostages = managers.groupai:state():all_hostages()
    local __enemies = managers.enemy:all_enemies()
    if shoot_player then
        for k,v_key in ipairs(__hostages) do
            table.insert(self._setup.ignore_units, __enemies[v_key].unit)
        end
    end
end)