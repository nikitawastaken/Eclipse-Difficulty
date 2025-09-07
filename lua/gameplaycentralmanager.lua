local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
local tmp_vec3 = Vector3()
local tmp_vec4 = Vector3()
local mvec3_set = mvector3.set
local mvec3_mul = mvector3.multiply
local mvec3_add = mvector3.add
local mvec3_dist_sq = mvector3.distance_sq

function GamePlayCentralManager:do_shotgun_push(unit, hit_pos, dir, distance, attacker)
	if self:get_shotgun_push_range() < distance or not managers.player:has_category_upgrade("shotgun", "enemy_push") then
		return
	end

	if unit:id() > 0 then
		managers.network:session():send_to_peers("sync_shotgun_push", unit, hit_pos, dir, distance, attacker)
	end

	self:_do_shotgun_push(unit, hit_pos, dir, distance, attacker)
end

function GamePlayCentralManager:_do_shotgun_push(unit, hit_pos, dir, distance, attacker)
	local mov_ext = unit:movement()
	local full_body_action = mov_ext and mov_ext:get_action(1)

	if full_body_action and full_body_action:type() == "hurt" then
		full_body_action:force_ragdoll(true)
	end

	local scale = math.clamp(1 - distance / self:get_shotgun_push_range(attacker), 0.5, 1)
	local rot_time = 0.5
	local asm = unit:anim_state_machine()

	if asm and asm:get_global("tank") == 1 then
		scale = scale * 0.5
	end

	local push_vec = tmp_vec1

	mvector3.set_static(push_vec, dir.x, dir.y, dir.z + 0.25)
	mvec3_mul(push_vec, 600 * scale)

	local unit_pos = tmp_vec2

	unit:m_position(unit_pos)

	local height_sign = math.sign(mvec3_dist_sq(hit_pos, unit_pos) - 10000)
	local twist_dir = math.random(2) == 1 and 1 or -1
	local rot_acc = tmp_vec3

	mvec3_set(rot_acc, dir)
	mvector3.cross(rot_acc, rot_acc, math.UP)
	mvec3_set(tmp_vec4, math.UP)
	mvec3_mul(tmp_vec4, math.rand(0.1, 0.5) * twist_dir)
	mvec3_add(rot_acc, tmp_vec4)
	mvec3_mul(rot_acc, -1000 * height_sign)

	local u_body = nil
	local i_u_body = 0
	local get_body_f = unit.body
	local nr_u_bodies = unit:num_bodies()
	local world = World
	local play_physic_effect_f = world.play_physic_effect
	local idstr_shotgun_push_effect = Idstring("physic_effects/shotgun_hit")

	for i = 0, unit:num_bodies() - 1 do
		u_body = get_body_f(unit, i)

		if u_body and u_body:enabled() and u_body:dynamic() then
			play_physic_effect_f(world, idstr_shotgun_push_effect, u_body, push_vec, 4 * u_body:mass() / math.random(2), rot_acc, rot_time)
		end
	end

	managers.mutators:notify(Message.OnShotgunPush, unit, hit_pos, dir, distance, attacker)
end
