NPCRaycastWeaponBase.flashlight_blacklist = {
	[Idstring("units/payday2/weapons/wpn_npc_sawnoff_shotgun/wpn_npc_sawnoff_shotgun"):key()] = true,
	[Idstring("units/payday2/weapons/wpn_npc_mp5_tactical/wpn_npc_mp5_tactical"):key()] = true,
	[Idstring("units/payday2/weapons/wpn_npc_beretta92/wpn_npc_beretta92"):key()] = true,
	[Idstring("units/payday2/weapons/wpn_npc_sniper/wpn_npc_sniper"):key()] = true,
	[Idstring("units/payday2/weapons/wpn_npc_m14/wpn_npc_m14"):key()] = true,
	[Idstring("units/pd2_dlc_mad/weapons/wpn_npc_svd/wpn_npc_svd"):key()] = true,
	[Idstring("units/pd2_dlc_mad/weapons/wpn_npc_asval/wpn_npc_asval"):key()] = true,
	[Idstring("units/pd2_dlc_spa/weapons/wpn_npc_svd_silenced/wpn_npc_svd_silenced"):key()] = true,
	[Idstring("units/pd2_dlc_drm/weapons/wpn_npc_heavy_zeal_sniper/wpn_npc_heavy_zeal_sniper"):key()] = true,
	[Idstring("units/pd2_dlc_uno/weapons/wpn_npc_smoke/wpn_npc_smoke"):key()] = true,
	[Idstring("units/pd2_dlc_usm1/weapons/wpn_npc_dmr/wpn_npc_dmr"):key()] = true,
	[Idstring("units/pd2_dlc_usm2/weapons/wpn_npc_deagle/wpn_npc_deagle"):key()] = true,
	[Idstring("units/payday2/weapons/wpn_npc_mp5_bulldozer/wpn_npc_mp5_bulldozer"):key()] = true,
	[Idstring("units/payday2/weapons/wpn_npc_r870_bulldozer/wpn_npc_r870_bulldozer"):key()] = true,
	[Idstring("units/payday2/weapons/wpn_npc_aa12_bulldozer/wpn_npc_aa12_bulldozer"):key()] = true,
	[Idstring("units/payday2/weapons/wpn_npc_m249_bulldozer/wpn_npc_m249_bulldozer"):key()] = true,
	[Idstring("units/payday2/weapons/wpn_npc_benelli_bulldozer/wpn_npc_benelli_bulldozer"):key()] = true,
	[Idstring("units/pd2_dlc_pent/weapons/wpn_npc_flamethrower_bulldozer/wpn_npc_flamethrower_bulldozer"):key()] = true,
	[Idstring("units/pd2_dlc_cg22/weapons/wpn_npc_snowthrower_bulldozer/wpn_npc_snowthrower_bulldozer"):key()] = true,
}

Hooks:PostHook(NPCRaycastWeaponBase, "init", "eclipse_init", function(self)
	if self.flashlight_blacklist[self._unit:name():key()] then
		if self._flashlight_data and alive(self._flashlight_data.light) then
			World:delete_light(self._flashlight_data.light)
		end
		self._flashlight_data = nil
		return
	end

	if self._flashlight_data then
		return
	end

	local light_object = self._unit:get_object(Idstring("a_effect_flashlight"))
	if not light_object then
		return
	end

	local effect = self._unit:effect_spawner(Idstring("flashlight"))
	if not effect then
		return
	end

	local light = World:create_light("spot|specular")

	self._flashlight_data = {
		light = light,
		effect = effect,
	}

	light:link(light_object)
	light:set_far_range(400)
	light:set_spot_angle_end(25)
	light:set_multiplier(2)

	local obj_rot = light_object:rotation()
	light:set_rotation(Rotation(obj_rot:z(), -obj_rot:x(), -obj_rot:y()))
	light:set_enable(false)

	self._unit:set_moving()
end)

Hooks:PreHook(NPCRaycastWeaponBase, "_fire_raycast", "_eclipse_fire_raycast", function(self, shoot_player, ...)
	local __hostages = managers.groupai:state():all_hostages()
	local __enemies = managers.enemy:all_enemies()
	if shoot_player then
		for k, v_key in ipairs(__hostages) do
			if __enemies[v_key] then
				table.insert(self._setup.ignore_units, __enemies[v_key].unit)
			end
		end
	end
end)

-- whole ass function override just to comment out one line, explanation below
function NPCRaycastWeaponBase:fire(from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, target_unit)
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
	local consume_ammo = not managers.player:has_active_temporary_property("bullet_storm")
			and (not managers.player:has_activate_temporary_upgrade("temporary", "berserker_damage_multiplier") or not managers.player:has_category_upgrade("player", "berserker_no_ammo_cost"))
		or not is_player
	local ammo_usage = self:ammo_usage()

	if consume_ammo and (is_player or Network:is_server()) then
		local base = self:ammo_base()

		if base:get_ammo_remaining_in_clip() == 0 then
			return
		end

		if is_player then
			for _, category in ipairs(self:weapon_tweak_data().categories) do
				if managers.player:has_category_upgrade(category, "consume_no_ammo_chance") then
					local roll = math.rand(1)
					local chance = managers.player:upgrade_value(category, "consume_no_ammo_chance", 0)

					if roll < chance then
						ammo_usage = 0

						print("NO AMMO COST")
					end
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
	-- managers.player:send_message(Message.OnWeaponFired, nil, self._unit, ray_res)
	-- has to be removed because it causes issue with skills that rely on this message (ammo efficiency / headshot fury / deadeye / etc)

	return ray_res
end
