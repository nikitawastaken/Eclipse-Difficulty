local mvec_to = Vector3()
local mvec_spread = Vector3()

function NPCRaycastWeaponBase:_fire_raycast(user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, target_unit)
    local result = {}
    local hit_unit = nil
    local miss, extra_spread = self:_check_smoke_shot(user_unit, target_unit)

    if miss then
        result.guaranteed_miss = miss

        mvector3.spread(direction, math.rand(unpack(extra_spread)))
    end

    mvector3.set(mvec_to, direction)
    mvector3.multiply(mvec_to, 20000)
    mvector3.add(mvec_to, from_pos)

    local __hostages = managers.groupai:state():all_hostages()
    local __enemies = managers.enemy:all_enemies()
    if shoot_player then
        for k,v_key in ipairs(__hostages) do
            table.insert(self._setup.ignore_units, __enemies[v_key].unit)
        end
    end

    local damage = self._damage * (dmg_mul or 1)
    local col_ray = World:raycast("ray", from_pos, mvec_to, "slot_mask", self._bullet_slotmask, "ignore_unit", self._setup.ignore_units)
    local player_hit, player_ray_data = nil

    if shoot_player and self._hit_player then
        player_hit, player_ray_data = self:damage_player(col_ray, from_pos, direction, result)

        if player_hit then
            InstantBulletBase:on_hit_player(col_ray or player_ray_data, self._unit, user_unit, damage)
        end
    end

    local char_hit = nil

    if not player_hit and col_ray then
        char_hit = InstantBulletBase:on_collision(col_ray, self._unit, user_unit, damage)
    end

    if (not col_ray or col_ray.unit ~= target_unit) and target_unit and target_unit:character_damage() and target_unit:character_damage().build_suppression then
        target_unit:character_damage():build_suppression(tweak_data.weapon[self._name_id].suppression)
    end

    if not col_ray or col_ray.distance > 600 or result.guaranteed_miss then
        local num_rays = (tweak_data.weapon[self._name_id] or {}).rays or 1

        for i = 1, num_rays do
            mvector3.set(mvec_spread, direction)

            if i > 1 then
                mvector3.spread(mvec_spread, self:_get_spread(user_unit))
            end

            self:_spawn_trail_effect(mvec_spread, col_ray)
        end
    end

    result.hit_enemy = char_hit

    if self._alert_events then
        result.rays = {
            col_ray
        }
    end

    self:_cleanup_smoke_shot()

    return result
end 
