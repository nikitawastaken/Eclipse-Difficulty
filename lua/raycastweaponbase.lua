RaycastWeaponBase.autofire_fix_blacklist = {
	["saw"] = true,
	["saw_secondary"] = true,
	["flamethrower_mk2"] = true,
	["money"] = true,
	["system"] = true,
}

local is_pro_job = Eclipse.utils.is_pro_job()

local init_original = RaycastWeaponBase.init
function RaycastWeaponBase:init(...)
	init_original(self, ...)

	-- Friendly Fire
	if is_pro_job then
		self._bullet_slotmask = self._bullet_slotmask + 3
	else
		self._bullet_slotmask = managers.mutators:modify_value("RaycastWeaponBase:setup:weapon_slot_mask", self._bullet_slotmask)
	end
end

-- No aim assist (shc)
Hooks:PostHook(RaycastWeaponBase, "init", "eclipse_init", function(self)
	if self._autohit_data then
		self._autohit_current = 0
		self._autohit_data.INIT_RATIO = 0
		self._autohit_data.MIN_RATIO = 0
		self._autohit_data.MAX_RATIO = 0
	end
end)

function RaycastWeaponBase:exit_run_speed_multiplier()
	local weapon_tweak = tweak_data.weapon[self._name_id]
	local multiplier = 0.4 / (weapon_tweak.sprint_exit_time or 0.4)

	multiplier = multiplier * (weapon_tweak.exit_run_speed_multiplier or 1)

	for _, category in ipairs(self:weapon_tweak_data().categories) do
		multiplier = multiplier * managers.player:upgrade_value(category, "exit_run_speed_multiplier", 1)
	end

	multiplier = multiplier * managers.player:upgrade_value(self._name_id, "exit_run_speed_multiplier", 1)

	return multiplier
end

function RaycastWeaponBase:is_explosive()
	return self._ammo_data and self._ammo_data.explosive_ammo or self:is_category("grenade_launcher") or false
end

local mvec_to = Vector3()
local mvec_right_ax = Vector3()
local mvec_up_ay = Vector3()
local mvec_spread_direction = Vector3()
local mvec3_set = mvector3.set
local mvec3_add = mvector3.add
local mvec3_mul = mvector3.multiply
local mvec3_norm = mvector3.normalize
local math_clamp = math.clamp

function RaycastWeaponBase:_fire_raycast(user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul)
	if self:gadget_overrides_weapon_functions() then
		return self:gadget_function_override("_fire_raycast", self, user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul)
	end

	local result = {}
	local ray_distance = self:weapon_range()
	local spread_x, spread_y = self:_get_spread(user_unit)
	spread_y = spread_y or spread_x
	spread_mul = spread_mul or 1

	mvector3.cross(mvec_right_ax, direction, math.UP)
	mvec3_norm(mvec_right_ax)
	mvector3.cross(mvec_up_ay, direction, mvec_right_ax)
	mvec3_norm(mvec_up_ay)
	mvec3_set(mvec_spread_direction, direction)

	local theta = math.random() * 360

	mvec3_mul(mvec_right_ax, math.rad(math.sin(theta) * math.random() * spread_x * spread_mul))
	mvec3_mul(mvec_up_ay, math.rad(math.cos(theta) * math.random() * spread_y * spread_mul))
	mvec3_add(mvec_spread_direction, mvec_right_ax)
	mvec3_add(mvec_spread_direction, mvec_up_ay)
	mvec3_set(mvec_to, mvec_spread_direction)
	mvec3_mul(mvec_to, ray_distance)
	mvec3_add(mvec_to, from_pos)

	local ray_hits, hit_enemy, enemies_hit = self:_collect_hits(from_pos, mvec_to)

	if self._autoaim and self._autohit_data then
		local weight = 0.1

		if hit_enemy then
			self._autohit_current = (self._autohit_current + weight) / (1 + weight)
		else
			local auto_hit_candidate, enemies_to_suppress = self:check_autoaim(from_pos, direction, nil, nil, nil, true)
			result.enemies_in_cone = enemies_to_suppress or false

			if auto_hit_candidate then
				local autohit_chance = self:get_current_autohit_chance_for_roll()

				if autohit_mul then
					autohit_chance = autohit_chance * autohit_mul
				end

				if math.random() < autohit_chance then
					self._autohit_current = (self._autohit_current + weight) / (1 + weight)

					mvec3_set(mvec_spread_direction, auto_hit_candidate.ray)
					mvec3_set(mvec_to, mvec_spread_direction)
					mvec3_mul(mvec_to, ray_distance)
					mvec3_add(mvec_to, from_pos)

					ray_hits, hit_enemy, enemies_hit = self:_collect_hits(from_pos, mvec_to)
				end
			end

			if hit_enemy then
				self._autohit_current = (self._autohit_current + weight) / (1 + weight)
			elseif auto_hit_candidate then
				self._autohit_current = self._autohit_current / (1 + weight)
			end
		end
	end

	local hit_count = 0
	local hit_anyone = false
	local cop_kill_count = 0
	local hit_through_wall = false
	local hit_through_shield = false
	local is_civ_f = CopDamage.is_civilian
	local damage = self:_get_current_damage(dmg_mul)

	for _, hit in ipairs(ray_hits) do
		local dmg = self:get_damage_falloff(damage, hit, user_unit)

		if dmg > 0 then
			local hit_result = self:bullet_class():on_collision(hit, self._unit, user_unit, dmg)
			hit_through_wall = hit_through_wall or hit.unit:in_slot(self.wall_mask)
			hit_through_shield = hit_through_shield or hit.unit:in_slot(self.shield_mask) and alive(hit.unit:parent())

			if hit_result then
				hit.damage_result = hit_result
				hit_anyone = true
				hit_count = hit_count + 1

				if hit_result.type == "death" then
					local unit_base = hit.unit:base()
					local unit_type = unit_base and unit_base._tweak_table
					local is_civilian = unit_type and is_civ_f(unit_type)

					if not is_civilian then
						cop_kill_count = cop_kill_count + 1
					end

					self:_check_kill_achievements(cop_kill_count, unit_base, unit_type, is_civilian, hit_through_wall, hit_through_shield)
				end
			end
		end
	end

	self:_check_tango_achievements(cop_kill_count)

	result.hit_enemy = hit_anyone

	if self._autoaim then
		self._shot_fired_stats_table.hit = hit_anyone
		self._shot_fired_stats_table.hit_count = hit_count

		if not self._ammo_data or not self._ammo_data.ignore_statistic then
			managers.statistics:shot_fired(self._shot_fired_stats_table)
		end
	end

	local furthest_hit = ray_hits[#ray_hits]

	if alive(self._obj_fire) then
		-- charged shot effect
		if managers.player:has_category_upgrade("snp", "charged_shot") and managers.player:is_charged_shot_allowed() then
			local sniper_trail_effect = Idstring("effects/particles/weapons/sniper_trail")
			local idstr_trail = Idstring("trail")
			local idstr_simulator_length = Idstring("simulator_length")
			local idstr_size = Idstring("size")

			local sniper_trail_effect_table = deep_clone(self._trail_effect_table)
			sniper_trail_effect_table.effect = sniper_trail_effect

			self._trail_length = World:effect_manager():get_initial_simulator_var_vector2(sniper_trail_effect_table.effect, idstr_trail, idstr_simulator_length, idstr_size)
			self._obj_fire:m_position(sniper_trail_effect_table.position)
			mvec3_set(sniper_trail_effect_table.normal, mvec_spread_direction)

			local trail = World:effect_manager():spawn(sniper_trail_effect_table)

			if furthest_hit then
				mvector3.set_y(self._trail_length, furthest_hit.distance)
				World:effect_manager():set_simulator_var_vector2(trail, idstr_trail, idstr_simulator_length, idstr_size, self._trail_length)
			end
		elseif not furthest_hit or furthest_hit.distance > 600 then
			self._obj_fire:m_position(self._trail_effect_table.position)
			mvec3_set(self._trail_effect_table.normal, mvec_spread_direction)

			local trail = World:effect_manager():spawn(self._trail_effect_table)

			if furthest_hit then
				World:effect_manager():set_remaining_lifetime(trail, math_clamp((furthest_hit.distance - 600) / 10000, 0, furthest_hit.distance))
			end
		end
	end

	if result.enemies_in_cone == nil then
		result.enemies_in_cone = self._suppression and self:check_suppression(from_pos, direction, enemies_hit) or nil
	elseif enemies_hit and self._suppression then
		result.enemies_in_cone = result.enemies_in_cone or {}
		local all_enemies = managers.enemy:all_enemies()

		for u_key, enemy in pairs(enemies_hit) do
			if all_enemies[u_key] then
				result.enemies_in_cone[u_key] = {
					error_mul = 1,
					unit = enemy,
				}
			end
		end
	end

	if self._alert_events then
		result.rays = ray_hits
	end

	return result
end

-- Make explsoive weaposn not benefit from infinite ammo upgrades / add no ammo consumption chance upgrade
function RaycastWeaponBase:fire(from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, target_unit)
	if managers.player:has_activate_temporary_upgrade("temporary", "no_ammo_cost_buff") then
		managers.player:deactivate_temporary_upgrade("temporary", "no_ammo_cost_buff")

		if managers.player:has_category_upgrade("temporary", "no_ammo_cost") then
			managers.player:activate_temporary_upgrade("temporary", "no_ammo_cost")
		end
	end

	if self._autoaim and self._active_modify_mutator then
		self._active_modify_mutator:check_modify_weapon(self)
	end

	if self._bullets_fired then
		if self._bullets_fired == 1 and self:weapon_tweak_data().sounds.fire_single then
			self:play_tweak_data_sound("stop_fire")
			self:play_tweak_data_sound("fire_auto", "fire")
		end

		self._bullets_fired = self._bullets_fired + 1
	end

	local is_player = self._setup.user_unit == managers.player:player_unit()
	local is_explosive = self:is_explosive()
	local consume_ammo = is_explosive
		or not managers.player:has_active_temporary_property("bullet_storm") and (not managers.player:has_activate_temporary_upgrade("temporary", "berserker_damage_multiplier") or not managers.player:has_category_upgrade(
			"player",
			"berserker_no_ammo_cost"
		))
		or not is_player
	local ammo_usage = self:ammo_usage()

	if consume_ammo and (is_player or Network:is_server()) then
		local base = self:ammo_base()

		if base:get_ammo_remaining_in_clip() == 0 then
			return
		end

		if is_player and not is_explosive then
			if managers.player:has_category_upgrade("weapon", "consume_no_ammo_chance") then
				local roll = math.rand(1)
				local chance = managers.player:upgrade_value("weapon", "consume_no_ammo_chance", 0)

				if roll < chance then
					ammo_usage = 0

					print("NO AMMO COST")
				end
			end
		end

		local mutator = nil

		if managers.mutators:is_mutator_active(MutatorPiggyRevenge) then
			mutator = managers.mutators:get_mutator(MutatorPiggyRevenge)
		end

		if mutator and mutator.get_free_ammo_chance and mutator:get_free_ammo_chance() then
			ammo_usage = 0
		end

		local ammo_in_clip = base:get_ammo_remaining_in_clip()
		local remaining_ammo = ammo_in_clip - ammo_usage

		if remaining_ammo < 0 then
			ammo_usage = ammo_usage + remaining_ammo
			remaining_ammo = 0
		end

		if ammo_in_clip > 0 and remaining_ammo <= (self.AKIMBO and 1 or 0) then
			local w_td = self:weapon_tweak_data()

			if w_td.animations and w_td.animations.magazine_empty then
				self:tweak_data_anim_play("magazine_empty")
			end

			if w_td.sounds and w_td.sounds.magazine_empty then
				self:play_tweak_data_sound("magazine_empty")
			end

			if w_td.effects and w_td.effects.magazine_empty then
				self:_spawn_tweak_data_effect("magazine_empty")
			end

			self:set_magazine_empty(true)
		end

		base:set_ammo_remaining_in_clip(ammo_in_clip - ammo_usage)
		self:use_ammo(base, ammo_usage)
	end

	local user_unit = self._setup.user_unit

	self:_check_ammo_total(user_unit)

	if alive(self._obj_fire) then
		self:_spawn_muzzle_effect(from_pos, direction)
	end

	self:_spawn_shell_eject_effect()

	local ray_res = self:_fire_raycast(user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, target_unit, ammo_usage)

	if self._alert_events and ray_res.rays then
		self:_check_alert(ray_res.rays, from_pos, direction, user_unit)
	end

	self:_build_suppression(ray_res.enemies_in_cone, suppr_mul)
	managers.player:send_message(Message.OnWeaponFired, nil, self._unit, ray_res)

	--Autofire soundfix integration.
	if self:_soundfix_should_play_normal() then
		if self._bullets_fired then
			if self._bullets_fired == 1 and self:weapon_tweak_data().sounds.fire_single then
				self:play_tweak_data_sound("stop_fire")
				if self:_get_sound_event("stop_fire2") then
					self:play_tweak_data_sound("stop_fire2")
				end
				if self:_get_sound_event("stop_fire3") then
					self:play_tweak_data_sound("stop_fire3")
				end
				self:play_tweak_data_sound("fire_auto", "fire")
				if self:_get_sound_event("fire_auto2", "fire2") then
					self:play_tweak_data_sound("fire_auto2", "fire2")
				end
				if self:_get_sound_event("fire_auto3", "fire3") then
					self:play_tweak_data_sound("fire_auto3", "fire3")
				end
			end
			self._bullets_fired = self._bullets_fired + 1
		end
		return ray_res
	end

	local name_id = self:get_name_id() or "xX69dank420blazermachineXx"
	if ray_res and self._setup.user_unit == managers.player:player_unit() and not tweak_data.weapon[name_id].sounds.no_fix then
		self:play_tweak_data_sound("fire_single", "fire")
		if self:_get_sound_event("fire_single2", "fire2") then
			self:play_tweak_data_sound("fire_single2", "fire2")
		end
		if self:_get_sound_event("fire_single3", "fire3") then
			self:play_tweak_data_sound("fire_single3", "fire3")
		end
		self:play_tweak_data_sound("stop_fire")
		if self:_get_sound_event("stop_fire2") then
			self:play_tweak_data_sound("stop_fire2")
		end
		if self:_get_sound_event("stop_fire3") then
			self:play_tweak_data_sound("stop_fire3")
		end
	end

	return ray_res
end

-- Elite Shields cannot be penetrated
function RaycastWeaponBase.collect_hits(from, to, setup_data)
	setup_data = setup_data or {}
	local ray_hits = nil
	local hit_enemy = false
	local ignore_unit = setup_data.ignore_units or {}
	local enemy_mask = setup_data.enemy_mask
	local bullet_slotmask = setup_data.bullet_slotmask or managers.slot:get_mask("bullet_impact_targets")

	if setup_data.stop_on_impact then
		ray_hits = {}
		local hit = World:raycast("ray", from, to, "slot_mask", bullet_slotmask, "ignore_unit", ignore_unit)

		if hit then
			table.insert(ray_hits, hit)

			hit_enemy = hit.unit:in_slot(enemy_mask)
		end

		return ray_hits, hit_enemy, hit_enemy and {
			[hit.unit:key()] = hit.unit,
		} or nil
	end

	local can_shoot_through_wall = setup_data.can_shoot_through_wall
	local can_shoot_through_shield = setup_data.can_shoot_through_shield
	local can_shoot_through_enemy = setup_data.can_shoot_through_enemy
	local wall_mask = setup_data.wall_mask
	local shield_mask = setup_data.shield_mask
	local ai_vision_ids = Idstring("ai_vision")
	local bulletproof_ids = Idstring("bulletproof")

	if can_shoot_through_wall then
		ray_hits = World:raycast_wall("ray", from, to, "slot_mask", bullet_slotmask, "ignore_unit", ignore_unit, "thickness", 40, "thickness_mask", wall_mask)
	else
		ray_hits = World:raycast_all("ray", from, to, "slot_mask", bullet_slotmask, "ignore_unit", ignore_unit)
	end

	local unique_hits = {}
	local enemies_hit = {}
	local unit, u_key, is_enemy = nil
	local units_hit = {}
	local in_slot_func = Unit.in_slot
	local has_ray_type_func = Body.has_ray_type

	for i, hit in ipairs(ray_hits) do
		unit = hit.unit
		u_key = unit:key()

		if not units_hit[u_key] then
			units_hit[u_key] = true
			unique_hits[#unique_hits + 1] = hit
			hit.hit_position = hit.position
			is_enemy = in_slot_func(unit, enemy_mask)

			if is_enemy then
				enemies_hit[u_key] = unit
				hit_enemy = true
			end

			local parent_unit_tweak = hit.unit:parent() and hit.unit:parent():base() and hit.unit:parent():base()._tweak_table
			local no_penetration = parent_unit_tweak and tweak_data.character[parent_unit_tweak] and tweak_data.character[parent_unit_tweak].no_shield_penetration

			if not can_shoot_through_enemy and is_enemy then
				break
			elseif not can_shoot_through_shield and in_slot_func(unit, shield_mask) then
				break
			elseif not can_shoot_through_wall and in_slot_func(unit, wall_mask) and (has_ray_type_func(hit.body, ai_vision_ids) or has_ray_type_func(hit.body, bulletproof_ids)) then
				break
			elseif hit.unit:in_slot(shield_mask) and no_penetration then -- hi thanks resmod if you're reading this :)
				break
			end
		end
	end

	return unique_hits, hit_enemy, hit_enemy and enemies_hit or nil
end

-- dragon's breath doesn't own shields anymore
function FlameBulletBase:bullet_slotmask()
	return managers.slot:get_mask("bullet_impact_targets")
end

-- Change the conditions for the "ammo low" voice line
local said_ammo_t = 0
function RaycastWeaponBase:_check_ammo_total(unit)
	if not unit:base().is_local_player or self:get_ammo_remaining_in_clip() > 0 then
		return
	end

	local ratio = 0
	for _, weapon in pairs(unit:inventory():available_selections()) do
		ratio = ratio + weapon.unit:base():get_ammo_ratio() * 0.5
	end

	local t = self._unit:timer():time()
	if ratio < 0.25 and t > said_ammo_t + 10 then
		PlayerStandard.say_line(unit:sound(), "g81x_plu")
		said_ammo_t = t
	end
end

function RaycastWeaponBase:_soundfix_should_play_normal()
	local name_id = self:get_name_id() or "xX69dank420blazermachineXx"
	if not self._setup.user_unit == managers.player:player_unit() then
		return true
	elseif self.autofire_fix_blacklist[name_id] or tweak_data.weapon[name_id].sounds.no_fix then
		return true
	elseif not tweak_data.weapon[name_id].sounds.fire_single then
		return true
	end
end

local orig_fire_sound = RaycastWeaponBase._fire_sound
function RaycastWeaponBase:_fire_sound(...)
	if self:_soundfix_should_play_normal() then
		orig_fire_sound(self, ...)

		local auto_fire = self:fire_mode() == "auto"

		if self:_get_sound_event(auto_fire and not self:weapon_tweak_data().sounds.fire_single2 and "fire_auto2" or "fire_single2", "fire2") then
			self:play_tweak_data_sound(auto_fire and not self:weapon_tweak_data().sounds.fire_single2 and "fire_auto2" or "fire_single2", "fire2")
		end
		if self:_get_sound_event(auto_fire and not self:weapon_tweak_data().sounds.fire_single3 and "fire_auto3" or "fire_single3", "fire3") then
			self:play_tweak_data_sound(auto_fire and not self:weapon_tweak_data().sounds.fire_single3 and "fire_auto3" or "fire_single3", "fire3")
		end
	end
end

local orig_stop_shooting = RaycastWeaponBase.stop_shooting
function RaycastWeaponBase:stop_shooting(...)
	if self._shots_without_releasing_trigger then
		self._shots_without_releasing_trigger = 0
	end
	if self:_get_sound_event("stop_fire2") then
		--self._sound_fire:stop()
		self:play_tweak_data_sound("stop_fire2")
	end
	if self:_get_sound_event("stop_fire3") then
		--self._sound_fire:stop()
		self:play_tweak_data_sound("stop_fire3")
	end
	if self:_soundfix_should_play_normal() then
		orig_stop_shooting(self, ...)
	end
end

-- Extra startout ammo upgrade
function RaycastWeaponBase:ammo_full()
	local function is_full(ammo_base)
		return ammo_base:get_ammo_total() >= ammo_base:get_ammo_max()
	end

	if not is_full(self) then
		return false
	end

	for _, gadget in ipairs(self:get_all_override_weapon_gadgets()) do
		if gadget and gadget.ammo_base and not is_full(gadget:ammo_base()) then
			return false
		end
	end

	return true
end

function RaycastWeaponBase:add_ammo_from_bag(available)
	local function process_ammo(ammo_base, amount_available)
		if ammo_base:get_ammo_max() <= ammo_base:get_ammo_total() then
			return 0
		end

		local ammo_max = ammo_base:get_ammo_max()
		local ammo_total = ammo_base:get_ammo_total()
		local wanted = 1 - ammo_total / ammo_max
		local can_have = math.min(wanted, amount_available)

		ammo_base:set_ammo_total(math.min(ammo_max, ammo_total + math.ceil(can_have * ammo_max)))
		print(wanted, can_have, math.ceil(can_have * ammo_max), ammo_base:get_ammo_total())

		return can_have
	end

	local can_have = process_ammo(self, available)
	available = available - can_have

	for _, gadget in ipairs(self:get_all_override_weapon_gadgets()) do
		if gadget and gadget.ammo_base then
			local ammo = process_ammo(gadget:ammo_base(), available)
			can_have = can_have + ammo
			available = available - ammo

			gadget:on_add_ammo_from_bag()
		end
	end

	return can_have
end

function RaycastWeaponBase:add_ammo(ratio, add_amount_override)
	local mul_1 = managers.player:upgrade_value("player", "pick_up_ammo_multiplier", 1) - 1
	local mul_2 = managers.player:upgrade_value("player", "pick_up_ammo_multiplier_2", 1) - 1
	local crew_mul = managers.player:crew_ability_upgrade_value("crew_scavenge", 0)
	local pickup_mul = 1 + mul_1 + mul_2 + crew_mul

	local function _add_ammo(ammo_base, ratio, add_amount_override)
		if ammo_base:get_ammo_max() <= ammo_base:get_ammo_total() then
			return false, 0
		end

		local picked_up = true
		local stored_pickup_ammo = nil
		local add_amount = add_amount_override

		if not add_amount then
			local min_pickup = ammo_base._ammo_pickup[1]
			local max_pickup = ammo_base._ammo_pickup[2]

			if ammo_base._ammo_data and (ammo_base._ammo_data.ammo_pickup_min_mul or ammo_base._ammo_data.ammo_pickup_max_mul) then
				min_pickup = min_pickup * (ammo_base._ammo_data.ammo_pickup_min_mul or 1)
				max_pickup = max_pickup * (ammo_base._ammo_data.ammo_pickup_max_mul or 1)
			end

			add_amount = math.lerp(min_pickup * pickup_mul, max_pickup * pickup_mul, math.random())
			picked_up = add_amount > 0
			add_amount = add_amount * (ratio or 1)
			stored_pickup_ammo = ammo_base:get_stored_pickup_ammo()

			if stored_pickup_ammo then
				add_amount = add_amount + stored_pickup_ammo

				ammo_base:remove_pickup_ammo()
			end
		end

		local rounded_amount = math.floor(add_amount)
		local new_ammo = ammo_base:get_ammo_total() + rounded_amount
		local max_allowed_ammo = ammo_base:get_ammo_max()

		if not add_amount_override and new_ammo < max_allowed_ammo then
			local leftover_ammo = add_amount - rounded_amount

			if leftover_ammo > 0 then
				ammo_base:store_pickup_ammo(leftover_ammo)
			end
		end

		ammo_base:set_ammo_total(math.clamp(new_ammo, 0, max_allowed_ammo))

		if stored_pickup_ammo then
			add_amount = math.floor(add_amount - stored_pickup_ammo)
		else
			add_amount = rounded_amount
		end

		return picked_up, add_amount
	end

	local picked_up, add_amount = nil
	picked_up, add_amount = _add_ammo(self, ratio, add_amount_override)

	if self.AKIMBO then
		local akimbo_rounding = self:get_ammo_total() % 2 + #self._fire_callbacks

		if akimbo_rounding > 0 then
			_add_ammo(self, nil, akimbo_rounding)
		end
	end

	for _, gadget in ipairs(self:get_all_override_weapon_gadgets()) do
		if gadget and gadget.ammo_base then
			local p, a = _add_ammo(gadget:ammo_base(), ratio, add_amount_override)
			picked_up = p or picked_up
			add_amount = add_amount + a

			if self.AKIMBO then
				local akimbo_rounding = gadget:ammo_base():get_ammo_total() % 2 + #self._fire_callbacks

				if akimbo_rounding > 0 then
					_add_ammo(gadget:ammo_base(), nil, akimbo_rounding)
				end
			end
		end
	end

	return picked_up, add_amount
end

function RaycastWeaponBase:add_ammo_ratio(ammo_ratio_increase)
	local function _add_ammo(ammo_base, ammo_ratio_increase)
		if ammo_base:get_ammo_max() <= ammo_base:get_ammo_total() then
			return
		end

		local ammo_max = ammo_base:get_ammo_max()
		local ammo_total = ammo_base:get_ammo_total()
		ammo_total = math.ceil(ammo_total * ammo_ratio_increase)
		ammo_total = math.clamp(ammo_total, 0, ammo_max)

		ammo_base:set_ammo_total(ammo_total)
	end

	_add_ammo(self, ammo_ratio_increase)

	for _, gadget in ipairs(self:get_all_override_weapon_gadgets()) do
		if gadget and gadget.ammo_base then
			_add_ammo(gadget:ammo_base(), ammo_ratio_increase)
		end
	end
end

function RaycastWeaponBase:add_ammo_to_pool(ammo, index)
	local max_ammo = self:get_ammo_max()
	local current_ammo = self:get_ammo_total()
	local new_ammo = current_ammo + ammo

	if max_ammo > current_ammo then
		if max_ammo < new_ammo then
			new_ammo = max_ammo
		end
	else
		new_ammo = current_ammo
	end

	self:set_ammo_total(new_ammo)
	managers.hud:set_ammo_amount(index, self:ammo_info())
end

function RaycastWeaponBase:add_ammo_to_mag(ammo, index)
	local max_ammo = self:ammo_base():get_ammo_max_per_clip()
	local current_ammo = self:ammo_base():get_ammo_remaining_in_clip()
	local new_ammo = current_ammo + ammo

	if max_ammo < new_ammo then
		new_ammo = current_ammo
	end

	self:ammo_base():set_ammo_remaining_in_clip(new_ammo)
	managers.hud:set_ammo_amount(index, self:ammo_info())
end
