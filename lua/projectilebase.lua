-- Friendly Fire
local mvec1 = Vector3()
local mvec2 = Vector3()
local mrot1 = Rotation()

function ProjectileBase:update(unit, t, dt)
    if not self._simulated and not self._collided then
        self._unit:m_position(mvec1)
        mvector3.set(mvec2, self._velocity * dt)
        mvector3.add(mvec1, mvec2)
        self._unit:set_position(mvec1)

        if self._orient_to_vel then
            mrotation.set_look_at(mrot1, mvec2, math.UP)
            self._unit:set_rotation(mrot1)
        end

        self._velocity = Vector3(self._velocity.x, self._velocity.y, self._velocity.z - 980 * dt)
    end

    if self._sweep_data and not self._collided then
        self._unit:m_position(self._sweep_data.current_pos)

        local col_ray = nil
        local __ignore_units = {}

        -- Cannot shoot yourself
        if alive(self._thrower_unit) then
            table.insert(__ignore_units, self._thrower_unit)
        end

        -- Cannot shoot peers
        local _peers = _peers or managers.network:session():peers()
        for _, _peer in pairs(_peers) do
            if alive(_peer:unit()) then
                table.insert(__ignore_units, _peer:unit())
            end
        end

        if #__ignore_units > 0 then
            col_ray = World:raycast("ray", self._sweep_data.last_pos, self._sweep_data.current_pos, "slot_mask", self._sweep_data.slot_mask, "ignore_unit", __ignore_units)
        else
            col_ray = World:raycast("ray", self._sweep_data.last_pos, self._sweep_data.current_pos, "slot_mask", self._sweep_data.slot_mask)
        end

        if self._draw_debug_trail then
            Draw:brush(Color(1, 0, 0, 1), nil, 3):line(self._sweep_data.last_pos, self._sweep_data.current_pos)
        end

        if col_ray and col_ray.unit then
            mvector3.direction(mvec1, self._sweep_data.last_pos, self._sweep_data.current_pos)
            mvector3.add(mvec1, col_ray.position)
            self._unit:set_position(mvec1)
            self._unit:set_position(mvec1)

            if self._draw_debug_impact then
                Draw:brush(Color(0.5, 0, 0, 1), nil, 10):sphere(col_ray.position, 4)
                Draw:brush(Color(0.5, 1, 0, 0), nil, 10):sphere(self._unit:position(), 3)
            end

            col_ray.velocity = self._unit:velocity()
            self._collided = true

            self:_on_collision(col_ray)
        end

        self._unit:m_position(self._sweep_data.last_pos)
    end
end

function ProjectileBase:create_sweep_data()
    self._sweep_data = {
        slot_mask = self._slot_mask
    }

    if Global.game_settings and Global.game_settings.one_down then
        self._sweep_data.slot_mask = self._sweep_data.slot_mask + 3
    else
        self._sweep_data.slot_mask = managers.mutators:modify_value("ProjectileBase:create_sweep_data:slot_mask", self._sweep_data.slot_mask)
    end

    self._sweep_data.current_pos = self._unit:position()
    self._sweep_data.last_pos = mvector3.copy(self._sweep_data.current_pos)
end
