if weapon_id then
	managers.statistics:shot_fired({})
end

local mvec1 = Vector3()
function GrenadeBase:throw(params)
	self._owner = params.owner
	local velocity = params.dir
	local adjust_z = 50
	local launch_speed = 250
	local push_at_body_index = nil

	if params.projectile_entry and tweak_data.projectiles[params.projectile_entry] then
		adjust_z = tweak_data.projectiles[params.projectile_entry].adjust_z or adjust_z
		launch_speed = tweak_data.projectiles[params.projectile_entry].launch_speed or launch_speed
		push_at_body_index = tweak_data.projectiles[params.projectile_entry].push_at_body_index
	end

	-- Add player's velocity
	local is_player = self._thrower_unit:movement().current_state
	local thrower_state = is_player and self._thrower_unit:movement():current_state() or false
	local velocity_addend_xy = Vector3(0, 0, 0)
	local velocity_addend_z = Vector3(0, 0, 0)
	if alive(self._thrower_unit) and thrower_state and thrower_state._last_velocity_xy then
		-- Slightly nerf the velocity addends and make sure it doesn't work when you're falling from the jump
		velocity_addend_z = thrower_state._is_jumping and not thrower_state._is_jump_middle_passed and (thrower_state._last_sent_jump_vec * 0.15) or velocity_addend_z
		velocity_addend_xy = thrower_state._last_velocity_xy * 0.25
	end

	velocity = (velocity * launch_speed) + velocity_addend_xy + velocity_addend_z
	velocity = Vector3(velocity.x, velocity.y, velocity.z + adjust_z)
	local mass_look_up_modifier = self._mass_look_up_modifier or 2
	local mass = math.max(mass_look_up_modifier * (1 + math.min(0, params.dir.z)), 1)

	if self._simulated then
		if push_at_body_index then
			self._unit:push_at(mass, velocity, self._unit:body(push_at_body_index):center_of_mass())
		else
			self._unit:push_at(mass, velocity, self._unit:position())
		end
	else
		self._velocity = velocity
	end

	if params.projectile_entry and tweak_data.blackmarket.projectiles[params.projectile_entry] then
		local tweak_entry = tweak_data.blackmarket.projectiles[params.projectile_entry]
		local physic_effect = tweak_entry.physic_effect

		if physic_effect then
			World:play_physic_effect(physic_effect, self._unit)
		end

		if tweak_entry.add_trail_effect then
			self:add_trail_effect(tweak_entry.add_trail_effect)
		end

		local unit_name = tweak_entry.sprint_unit

		if unit_name then
			local new_dir = Vector3(params.dir.y * -1, params.dir.x, params.dir.z)
			local sprint = World:spawn_unit(Idstring(unit_name), self._unit:position() + new_dir * 50, self._unit:rotation())
			local rot = Rotation(params.dir, math.UP)

			mrotation.x(rot, mvec1)
			mvector3.multiply(mvec1, 0.15)
			mvector3.add(mvec1, new_dir)
			mvector3.add(mvec1, math.UP / 2)
			mvector3.multiply(mvec1, 100)
			sprint:push_at(mass, mvec1, sprint:position())
		end

		self:set_projectile_entry(params.projectile_entry)
	end
end
