Hooks:PostHook(WeaponFactoryTweakData, "init", "eclipse__init", function(self)
	self.parts.wpn_fps_lmg_o_empty = {
		a_obj = "a_body",
		type = "bonus",
		name_id = "bm_wp_lmg_o_empty",
		unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
		third_unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
		internal_part = true,
		stats = {
			value = 5,
		},
		forbids = {},
		stance_mod = {
			wpn_fps_lmg_rpk = {
				translation = Vector3(0.4, 0.2, -0.2),
				rotation = Rotation(0, 0, -1),
			},
			wpn_fps_lmg_hk21 = {
				translation = Vector3(0.5, 0.1, -0.3),
				rotation = Rotation(0, 0, -1),
			},
			wpn_fps_lmg_m249 = {
				translation = Vector3(0.5, 0.1, -0.3),
				rotation = Rotation(0, 0, -1),
			},
			wpn_fps_lmg_mg42 = {
				translation = Vector3(0.5, 0.3, -0.2),
				rotation = Rotation(0, 0, -1),
			},
			wpn_fps_lmg_par = {
				translation = Vector3(0.4, 0, -0.2),
				rotation = Rotation(0, 0, -1),
			},
			wpn_fps_lmg_m60 = {
				translation = Vector3(0.5, 0.2, -0.1),
				rotation = Rotation(0, 0, -1),
			},
		},
	}

	local stat_blacklist = {
		"foregrip",
		"extra",
		"grip",
		"stock",
		"lower_body",
		"body",
		"vertical_grip",
		"lower_reciever",
		"upper_reciever",
		"drag_handle",
		"bolt",
		"slide",
		"gadget",
	}

	for id, part in pairs(self.parts) do
		if table.contains(stat_blacklist, part.type) then
			part.stats = {}
			part.custom_stats = {}
		end

		if part.stats then
			local is_sight = part.type and part.type == "sight"
			local is_magazine = part.type and part.type == "magazine"
			local is_silencer = part.perks and table.contains(part.perks, "silencer")
			local is_scope = is_sight and part.perks and table.contains(part.perks, "scope")

			if is_silencer then
				part.stats.suppression = 10
				part.stats.alert_size = -12
			elseif part.stats.suppression then
				part.stats.suppression = 0
			end

			if part.stats.spread_moving then
				part.stats.spread_moving = 0
			end

			if is_scope then
				part.stats.concealment = -1
				part.stats.recoil = 1
				part.stats.spread = 0
			end

			if is_sight and id:match("_standard$") or id:match("_iron") then
				part.stats = {}
			end

			if is_magazine and id:match("_quick$") or id:match("_speed$") then
				part.stats = {}
				part.stats.reload = 2
				part.stats.concealment = -1
			end

			if id:match("_legendary$") and not is_silencer then
				part.stats = {}
				part.custom_stats = {}
			end
		end
	end

	local lmg_table = {
		"wpn_fps_lmg_rpk",
		"wpn_fps_lmg_hk21",
		"wpn_fps_lmg_m249",
		"wpn_fps_lmg_par",
		"wpn_fps_lmg_mg42",
		"wpn_fps_lmg_m60",
	}

	local sight_table = {
		"wpn_fps_upg_o_specter",
		"wpn_fps_upg_o_aimpoint",
		"wpn_fps_upg_o_aimpoint_2",
		"wpn_fps_upg_o_docter",
		"wpn_fps_upg_o_eotech",
		"wpn_fps_upg_o_t1micro",
		"wpn_fps_upg_o_cmore",
		"wpn_fps_upg_o_acog",
		"wpn_fps_upg_o_cs",
		"wpn_fps_upg_o_eotech_xps",
		"wpn_fps_upg_o_reflex",
		"wpn_fps_upg_o_rx01",
		"wpn_fps_upg_o_rx30",
		"wpn_fps_upg_o_spot",
		"wpn_fps_upg_o_xpsg33_magnifier",
		"wpn_fps_upg_o_bmg",
		"wpn_fps_upg_o_uh",
		"wpn_fps_upg_o_fc1",
		"wpn_fps_upg_o_poe",
		"wpn_fps_upg_o_hamr",
		"wpn_fps_upg_o_atibal",
	}

	local lmg_stance_mod_map = {
		["wpn_fps_lmg_rpk"] = { translation = Vector3(-0, -0, -3) },
		["wpn_fps_lmg_hk21"] = { translation = Vector3(0, -0, -3.2) },
		["wpn_fps_lmg_m249"] = { translation = Vector3(0, 0, -3.4) },
		["wpn_fps_lmg_par"] = { translation = Vector3(0, 8, -3.2) },
		["wpn_fps_lmg_mg42"] = { translation = Vector3(0, 8, -2.4) },
		["wpn_fps_lmg_m60"] = { translation = Vector3(0.1, 8, 0) },
	}

	local parent_upper = {
		"wpn_fps_lmg_rpk",
		"wpn_fps_lmg_m249",
		"wpn_fps_lmg_par",
		"wpn_fps_lmg_mg42",
		"wpn_fps_lmg_m60",
	}

	for index, weapon_id in ipairs(lmg_table) do
		if not self[weapon_id].adds then
			self[weapon_id].adds = {}
		end
		if not self[weapon_id].override then
			self[weapon_id].override = {}
		end
	end

	for index, weapon_id in ipairs(lmg_table) do
		for index, sight_id in ipairs(sight_table) do
			--Add sights to uses_parts
			table.insert(self[weapon_id].uses_parts, sight_id)

			--Set stance_mods
			self.parts[sight_id].stance_mod[weapon_id] = lmg_stance_mod_map[weapon_id]

			--Add a default part that forbids sights
			table.insert(self[weapon_id].uses_parts, "wpn_fps_lmg_o_empty")
			table.insert(self[weapon_id].default_blueprint, "wpn_fps_lmg_o_empty")
			table.insert(self.parts.wpn_fps_lmg_o_empty.forbids, sight_id)

			--Add sight mounts and rails
			self.wpn_fps_lmg_rpk.adds[sight_id] = { "wpn_fps_ak_extra_ris" }
			self.wpn_fps_lmg_hk21.adds[sight_id] = { "wpn_fps_ass_g3_body_rail" }
			self.wpn_fps_lmg_mg42.adds[sight_id] = { "wpn_fps_rpg7_sight_adapter" }
			self.wpn_fps_lmg_m60.adds[sight_id] = { "wpn_fps_ass_groza_o_adapter" }
			self.wpn_fps_lmg_m60.override[sight_id] = { forbids = { "wpn_fps_lmg_m60_sight_standard" } }
		end
	end

	for index, weapon_id in ipairs(parent_upper) do
		for index, sight_id in ipairs(sight_table) do
			self[weapon_id].override[sight_id] = { parent = "upper_reciever" }
		end
	end

	-- SHOTGUNS --
	local ammo_overrides = {
		wpn_fps_upg_a_custom = {
			very_heavy = { -- double barrels
				stats = { damage = 16, total_ammo_mod = -6, recoil = -2 },
				custom_stats = { rays = 6 },
			},
			heavy = { -- shotguns like gsps and the trench gun
				stats = { damage = 12, total_ammo_mod = -6, recoil = -2 },
				custom_stats = { rays = 6 },
			},
			medium = { -- raven, loco, reinfeld, etc
				stats = { damage = 11, total_ammo_mod = -6, recoil = -2 },
				custom_stats = { rays = 6 },
			},
			light = { -- semi autos
				stats = { damage = 9, total_ammo_mod = -6, recoil = -2 },
				custom_stats = { rays = 6 },
			},
			very_light = { -- full autos
				stats = { damage = 7, total_ammo_mod = -6, recoil = -2 },
				custom_stats = { rays = 6 },
			},
		},
		wpn_fps_upg_a_custom_free = {
			very_heavy = { -- double barrels
				stats = { damage = 16, total_ammo_mod = -6, recoil = -2 },
				custom_stats = { rays = 6 },
			},
			heavy = { -- shotguns like gsps and the trench gun
				stats = { damage = 12, total_ammo_mod = -6, recoil = -2 },
				custom_stats = { rays = 6 },
			},
			medium = { -- raven, loco, reinfeld, etc
				stats = { damage = 11, total_ammo_mod = -6, recoil = -2 },
				custom_stats = { rays = 6 },
			},
			light = { -- semi autos
				stats = { damage = 9, total_ammo_mod = -6, recoil = -2 },
				custom_stats = { rays = 6 },
			},
			very_light = { -- full autos
				stats = { damage = 7, total_ammo_mod = -6, recoil = -2 },
				custom_stats = { rays = 6 },
			},
		},
		wpn_fps_upg_a_explosive = {
			very_heavy = { -- double barrels
				stats = { damage = 200, total_ammo_mod = -8, recoil = -2, spread = 4 },
				custom_stats = { ignore_statistic = true, ammo_pickup_max_mul = 0.85, ammo_pickup_min_mul = 0.85, bullet_class = "InstantExplosiveBulletBase", rays = 1, damage_near_mul = 10 },
			},
			heavy = { -- shotguns like gsps and the trench gun
				stats = { damage = 150, total_ammo_mod = -8, recoil = -2, spread = 4 },
				custom_stats = { ignore_statistic = true, ammo_pickup_max_mul = 0.85, ammo_pickup_min_mul = 0.85, bullet_class = "InstantExplosiveBulletBase", rays = 1, damage_near_mul = 10 },
			},
			medium = { -- raven, loco, reinfeld, etc
				stats = { damage = 125, total_ammo_mod = -8, recoil = -2, spread = 4 },
				custom_stats = { ignore_statistic = true, ammo_pickup_max_mul = 0.85, ammo_pickup_min_mul = 0.85, bullet_class = "InstantExplosiveBulletBase", rays = 1, damage_near_mul = 10 },
			},
			light = { -- semi autos
				stats = { damage = 100, total_ammo_mod = -8, recoil = -2, spread = 4 },
				custom_stats = { ignore_statistic = true, ammo_pickup_max_mul = 0.85, ammo_pickup_min_mul = 0.85, bullet_class = "InstantExplosiveBulletBase", rays = 1, damage_near_mul = 10 },
			},
			very_light = { -- full autos
				stats = { damage = 75, total_ammo_mod = -8, recoil = -2, spread = 4 },
				custom_stats = { ignore_statistic = true, ammo_pickup_max_mul = 0.85, ammo_pickup_min_mul = 0.85, bullet_class = "InstantExplosiveBulletBase", rays = 1, damage_near_mul = 10 },
			},
		},
		wpn_fps_upg_a_slug = {
			very_heavy = { -- double barrels
				stats = { damage = 200, total_ammo_mod = -4, recoil = -2, spread = 6 },
			},
			heavy = { -- shotguns like gsps and the trench gun
				stats = { damage = 150, total_ammo_mod = -4, recoil = -2, spread = 6 },
			},
			medium = { -- raven, loco, reinfeld, etc
				stats = { damage = 125, total_ammo_mod = -4, recoil = -2, spread = 6 },
			},
			light = { -- semi autos
				stats = { damage = 100, total_ammo_mod = -4, recoil = -2, spread = 6 },
			},
			very_light = { -- full autos
				stats = { damage = 75, total_ammo_mod = -4, recoil = -2, spread = 6 },
			},
		},
		wpn_fps_upg_a_piercing = {
			very_heavy = { -- double barrels
				stats = { damage = -18, total_ammo_mod = -6, recoil = -3, spread = 2 },
				custom_stats = { rays = 12, armor_piercing_add = 1, can_shoot_through_enemy = true },
			},
			heavy = { -- shotguns like gsps and the trench gun
				stats = { damage = -14, total_ammo_mod = -6, recoil = -3, spread = 2 },
				custom_stats = { rays = 12, armor_piercing_add = 1, can_shoot_through_enemy = true },
			},
			medium = { -- raven, loco, reinfeld, etc
				stats = { damage = -12, total_ammo_mod = -6, recoil = -3, spread = 2 },
				custom_stats = { rays = 12, armor_piercing_add = 1, can_shoot_through_enemy = true },
			},
			light = { -- semi autos
				stats = { damage = -10, total_ammo_mod = -6, recoil = -3, spread = 2 },
				custom_stats = { rays = 12, armor_piercing_add = 1, can_shoot_through_enemy = true },
			},
			very_light = { -- full autos
				stats = { damage = -8, total_ammo_mod = -6, recoil = -3, spread = 2 },
				custom_stats = { rays = 12, armor_piercing_add = 1, can_shoot_through_enemy = true },
			},
		},
		wpn_fps_upg_a_dragons_breath = {
			very_heavy = { -- double barrels
				stats = { damage = -34, total_ammo_mod = -8 },
				custom_stats = {
					ammo_pickup_min_mul = 0.75,
					ammo_pickup_max_mul = 0.75,
					armor_piercing_add = 1,
					rays = 16,
					dot_data_name = "ammo_dragons_breath_vh",
					bullet_class = "FlameBulletBase",
					muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_dragons_breath",
				},
			},
			heavy = { -- shotguns like gsps and the trench gun
				stats = { damage = -26, total_ammo_mod = -8 },
				custom_stats = {
					ammo_pickup_min_mul = 0.75,
					ammo_pickup_max_mul = 0.75,
					armor_piercing_add = 1,
					rays = 16,
					dot_data_name = "ammo_dragons_breath_h",
					bullet_class = "FlameBulletBase",
					muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_dragons_breath",
				},
			},
			medium = { -- raven, loco, reinfeld, etc
				stats = { damage = -22, total_ammo_mod = -8 },
				custom_stats = {
					ammo_pickup_min_mul = 0.75,
					ammo_pickup_max_mul = 0.75,
					armor_piercing_add = 1,
					rays = 16,
					dot_data_name = "ammo_dragons_breath",
					bullet_class = "FlameBulletBase",
					muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_dragons_breath",
				},
			},
			light = { -- semi autos
				stats = { damage = -18, total_ammo_mod = -8 },
				custom_stats = {
					ammo_pickup_min_mul = 0.75,
					ammo_pickup_max_mul = 0.75,
					armor_piercing_add = 1,
					rays = 16,
					dot_data_name = "ammo_dragons_breath_l",
					bullet_class = "FlameBulletBase",
					muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_dragons_breath",
				},
			},
			very_light = { -- full autos
				stats = { damage = -14, total_ammo_mod = -8 },
				custom_stats = {
					ammo_pickup_min_mul = 0.75,
					ammo_pickup_max_mul = 0.75,
					armor_piercing_add = 1,
					rays = 16,
					dot_data_name = "ammo_dragons_breath_vl",
					bullet_class = "FlameBulletBase",
					muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_dragons_breath",
				},
			},
		},
	}

	local shotgun_table = {
		"wpn_fps_shot_saiga",
		"wpn_fps_sho_aa12",
		"wpn_fps_sho_basset",
		"wpn_fps_sho_sko12",
		"wpn_fps_sho_ben",
		"wpn_fps_sho_spas12",
		"wpn_fps_sho_striker",
		"wpn_fps_sho_rota",
		"wpn_fps_sho_ultima",
		"wpn_fps_shot_r870",
		"wpn_fps_shot_serbu",
		"wpn_fps_sho_ksg",
		"wpn_fps_pis_judge",
		"wpn_fps_sho_m590",
		"wpn_fps_sho_supernova",
		"wpn_fps_sho_boot",
		"wpn_fps_shot_m37",
		"wpn_fps_shot_m1897",
		"wpn_fps_shot_huntsman",
		"wpn_fps_shot_b682",
		"wpn_fps_sho_coach",
	}

	local ammo_table = {
		"wpn_fps_upg_a_custom",
		"wpn_fps_upg_a_custom_free",
		"wpn_fps_upg_a_explosive",
		"wpn_fps_upg_a_slug",
		"wpn_fps_upg_a_piercing",
		"wpn_fps_upg_a_dragons_breath",
		--"wpn_fps_upg_a_rip",
	}

	local ammo_override_map = {
		["wpn_fps_shot_saiga"] = "very_light",
		["wpn_fps_sho_aa12"] = "very_light",
		["wpn_fps_sho_basset"] = "very_light",
		["wpn_fps_sho_sko12"] = "very_light",
		["wpn_fps_sho_striker"] = "light",
		["wpn_fps_sho_spas12"] = "light",
		["wpn_fps_sho_rota"] = "light",
		["wpn_fps_sho_ultima"] = "light",
		["wpn_fps_shot_r870"] = "medium",
		["wpn_fps_shot_serbu"] = "medium",
		["wpn_fps_sho_ksg"] = "medium",
		["wpn_fps_pis_judge"] = "medium",
		["wpn_fps_sho_m590"] = "medium",
		["wpn_fps_sho_supernova"] = "medium",
		["wpn_fps_sho_boot"] = "heavy",
		["wpn_fps_shot_m37"] = "heavy",
		["wpn_fps_shot_m1897"] = "heavy",
		["wpn_fps_shot_huntsman"] = "very_heavy",
		["wpn_fps_shot_b682"] = "very_heavy",
		["wpn_fps_sho_coach"] = "very_heavy",
	}

	for index, weapon_id in ipairs(shotgun_table) do
		if not self[weapon_id].override then
			self[weapon_id].override = {}
		end
	end

	for index, weapon_id in ipairs(shotgun_table) do
		for index, ammo_id in ipairs(ammo_table) do
			local ammo_override = ammo_override_map[weapon_id]

			if ammo_override and ammo_overrides[ammo_id] and ammo_overrides[ammo_id][ammo_override] then
				self[weapon_id].override[ammo_id] = ammo_overrides[ammo_id][ammo_override]
			end
		end
	end

	--
	self.parts.wpn_fps_upg_o_mbus_pro.stats = {}

	--make all car weapons use the 30 rnd magazine by default
	self.parts.wpn_fps_upg_m4_m_straight_vanilla = deep_clone(self.parts.wpn_fps_m4_uupg_m_std)
	self.parts.wpn_fps_upg_m4_m_straight_vanilla.stats = nil
	self.parts.wpn_fps_upg_m4_m_straight_vanilla.pcs = nil

	self.parts.wpn_fps_m4_uupg_m_std = deep_clone(self.parts.wpn_fps_upg_m4_m_straight)
	self.parts.wpn_fps_m4_uupg_m_std.stats.extra_ammo = -5
	self.parts.wpn_fps_m4_uupg_m_std.stats.concealment = 1
	self.parts.wpn_fps_m4_uupg_m_std.stats.reload = 2

	self.parts.wpn_fps_ass_fal_fg_01.stats.spread = -4
	self.parts.wpn_fps_ass_fal_fg_01.stats.concealment = 4

	self.parts.wpn_fps_ass_fal_s_01.stats.recoil = -2
	self.parts.wpn_fps_ass_fal_s_01.stats.concealment = 2

	self.parts.wpn_fps_ass_m14_body_ruger.stats.spread = -6
	self.parts.wpn_fps_ass_m14_body_ruger.stats.recoil = -2
	self.parts.wpn_fps_ass_m14_body_ruger.stats.concealment = 8

	self.parts.wpn_fps_smg_mp5_m_straight.stats.total_ammo_mod = -5
	self.parts.wpn_fps_smg_mp5_m_straight.stats.damage = 10
	self.parts.wpn_fps_smg_mp5_m_straight.stats.concealment = 0
	self.parts.wpn_fps_smg_mp5_m_straight.custom_stats = { ammo_pickup_max_mul = 0.8333333333333333, ammo_pickup_min_mul = 0.8333333333333333 }

	self.parts.wpn_fps_smg_scorpion_m_extended.stats.extra_ammo = 0
	self.parts.wpn_fps_smg_scorpion_m_extended.stats.recoil = 1
	self.parts.wpn_fps_smg_scorpion_m_extended.stats.concealment = -2
	self.parts.wpn_fps_smg_scorpion_m_extended.stats.reload = 2

	self.parts.wpn_fps_smg_shepheard_mag_extended.unit = "units/pd2_dlc_joy/weapons/wpn_fps_smg_shepheard_pts/wpn_fps_smg_shepheard_mag_standard"
	self.parts.wpn_fps_smg_shepheard_mag_extended.bullet_objects = { amount = 20, prefix = "g_bullet_" }
	self.parts.wpn_fps_smg_shepheard_mag_extended.stats = { value = 1, extra_ammo = -5, concealment = 1, reload = 2 }

	self.parts.wpn_fps_smg_shepheard_mag_standard.unit = "units/pd2_dlc_joy/weapons/wpn_fps_smg_shepheard_pts/wpn_fps_smg_shepheard_mag_extended"
	self.parts.wpn_fps_smg_shepheard_mag_standard.bullet_objects = { amount = 30, prefix = "g_bullet_" }

	self.parts.wpn_fps_sho_saiga_b_short.stats.spread = -2
	self.parts.wpn_fps_sho_saiga_b_short.stats.concealment = 2

	self.parts.wpn_fps_sho_saiga_fg_holy.stats.recoil = -2
	self.parts.wpn_fps_sho_saiga_fg_holy.stats.concealment = 2

	self.parts.wpn_fps_sho_basset_m_extended.stats.extra_ammo = 0
	self.parts.wpn_fps_sho_basset_m_extended.stats.concealment = -2
	self.parts.wpn_fps_sho_basset_m_extended.stats.reload = -2
	self.parts.wpn_fps_sho_basset_m_extended.custom_stats = { ammo_offset = 3 }

	self.parts.wpn_fps_sho_aa12_mag_drum.stats.extra_ammo = 6
	self.parts.wpn_fps_sho_aa12_mag_drum.stats.concealment = -4
	self.parts.wpn_fps_sho_aa12_mag_drum.stats.reload = -4

	self.parts.wpn_fps_shot_r870_body_rack.stats.reload = 4
	self.parts.wpn_fps_shot_r870_body_rack.stats.concealment = -2

	self.parts.wpn_fps_shot_shorty_m_extended_short.stats.extra_ammo = 0
	self.parts.wpn_fps_shot_shorty_m_extended_short.stats.concealment = -1
	self.parts.wpn_fps_shot_shorty_m_extended_short.custom_stats = { ammo_offset = 1 }

	self.parts.wpn_fps_upg_o_dd_rear.stats = {}
	self.parts.wpn_fps_upg_o_mbus_rear.stats = {}

	self.parts.wpn_fps_sho_ksg_b_long.stats.extra_ammo = 1
	self.parts.wpn_fps_sho_ksg_b_long.stats.spread = 2
	self.parts.wpn_fps_sho_ksg_b_long.stats.recoil = 0
	self.parts.wpn_fps_sho_ksg_b_long.stats.concealment = -2

	self.parts.wpn_fps_sho_ksg_b_short.stats.extra_ammo = -1
	self.parts.wpn_fps_sho_ksg_b_short.stats.spread = -2
	self.parts.wpn_fps_sho_ksg_b_short.stats.recoil = 0
	self.parts.wpn_fps_sho_ksg_b_short.stats.concealment = 2

	self.parts.wpn_fps_shot_huntsman_b_short.stats.spread = -4
	self.parts.wpn_fps_shot_huntsman_b_short.stats.recoil = -2
	self.parts.wpn_fps_shot_huntsman_b_short.stats.concealment = 6

	self.parts.wpn_fps_shot_huntsman_s_short.stats.spread = -2
	self.parts.wpn_fps_shot_huntsman_s_short.stats.recoil = -6
	self.parts.wpn_fps_shot_huntsman_s_short.stats.concealment = 6

	self.parts.wpn_fps_shot_b682_b_short.stats.spread = -4
	self.parts.wpn_fps_shot_b682_b_short.stats.recoil = -2
	self.parts.wpn_fps_shot_b682_b_short.stats.concealment = 6

	self.parts.wpn_fps_shot_b682_s_short.stats.spread = -2
	self.parts.wpn_fps_shot_b682_s_short.stats.recoil = -4
	self.parts.wpn_fps_shot_b682_s_short.stats.concealment = 6

	self.parts.wpn_fps_sho_coach_b_short.stats.spread = -4
	self.parts.wpn_fps_sho_coach_b_short.stats.recoil = -2
	self.parts.wpn_fps_sho_coach_b_short.stats.concealment = 6

	self.parts.wpn_fps_sho_coach_s_short.stats.spread = -2
	self.parts.wpn_fps_sho_coach_s_short.stats.recoil = -4
	self.parts.wpn_fps_sho_coach_s_short.stats.concealment = 6

	self.parts.wpn_fps_snp_sbl_b_long.stats.extra_ammo = -1
	self.parts.wpn_fps_snp_sbl_b_long.stats.spread = 2
	self.parts.wpn_fps_snp_sbl_b_long.stats.recoil = 0
	self.parts.wpn_fps_snp_sbl_b_long.stats.concealment = -1

	self.parts.wpn_fps_snp_sbl_b_short.stats.extra_ammo = -1
	self.parts.wpn_fps_snp_sbl_b_short.stats.spread = 0
	self.parts.wpn_fps_snp_sbl_b_short.stats.recoil = 0
	self.parts.wpn_fps_snp_sbl_b_short.stats.concealment = -1

	-- DMRs (& Kits) --
	-- ak family
	self.parts.wpn_fps_upg_ass_ak_b_zastava.custom_stats = { can_shoot_through_enemy = true, armor_piercing_add = 1, ammo_pickup_min_mul = 0.5, ammo_pickup_max_mul = 0.375 }
	self.parts.wpn_fps_upg_ass_ak_b_zastava.stats.total_ammo_mod = -7
	self.parts.wpn_fps_upg_ass_ak_b_zastava.stats.concealment = -6
	self.parts.wpn_fps_upg_ass_ak_b_zastava.stats.recoil = -8
	self.parts.wpn_fps_upg_ass_ak_b_zastava.stats.damage = 80
	self.parts.wpn_fps_upg_ass_ak_b_zastava.has_description = true
	self.parts.wpn_fps_upg_ass_ak_b_zastava.desc_id = "bm_wp_dmr_kit_penetration_desc"
	self.wpn_fps_ass_74.override.wpn_fps_upg_ass_ak_b_zastava.custom_stats = { can_shoot_through_enemy = true, armor_piercing_add = 1, ammo_pickup_min_mul = 0.5, ammo_pickup_max_mul = 0.25 }
	self.wpn_fps_ass_74.override.wpn_fps_upg_ass_ak_b_zastava.stats.total_ammo_mod = -10
	self.wpn_fps_ass_74.override.wpn_fps_upg_ass_ak_b_zastava.stats.concealment = -7
	self.wpn_fps_ass_74.override.wpn_fps_upg_ass_ak_b_zastava.stats.recoil = -11
	self.wpn_fps_ass_74.override.wpn_fps_upg_ass_ak_b_zastava.stats.damage = 100
	-- car family
	self.parts.wpn_fps_upg_ass_m4_b_beowulf.custom_stats = { can_shoot_through_enemy = true, armor_piercing_add = 1, ammo_pickup_min_mul = 0.5, ammo_pickup_max_mul = 0.1875 }
	self.parts.wpn_fps_upg_ass_m4_b_beowulf.stats.total_ammo_mod = -12
	self.parts.wpn_fps_upg_ass_m4_b_beowulf.stats.concealment = -7
	self.parts.wpn_fps_upg_ass_m4_b_beowulf.stats.recoil = -11
	self.parts.wpn_fps_upg_ass_m4_b_beowulf.stats.damage = 100
	self.parts.wpn_fps_upg_ass_m4_b_beowulf.has_description = true
	self.parts.wpn_fps_upg_ass_m4_b_beowulf.desc_id = "bm_wp_dmr_kit_penetration_desc"
	self.wpn_fps_ass_m16.override.wpn_fps_upg_ass_m4_b_beowulf.custom_stats = { can_shoot_through_enemy = true, armor_piercing_add = 1, ammo_pickup_min_mul = 0.5, ammo_pickup_max_mul = 0.375 }
	self.wpn_fps_ass_m16.override.wpn_fps_upg_ass_m4_b_beowulf.stats.total_ammo_mod = -7
	self.wpn_fps_ass_m16.override.wpn_fps_upg_ass_m4_b_beowulf.stats.concealment = -6
	self.wpn_fps_ass_m16.override.wpn_fps_upg_ass_m4_b_beowulf.stats.recoil = -8
	self.wpn_fps_ass_m16.override.wpn_fps_upg_ass_m4_b_beowulf.stats.damage = 70

	-- gewehr
	self.parts.wpn_fps_ass_g3_b_sniper.custom_stats = { can_shoot_through_enemy = true, armor_piercing_add = 1, ammo_pickup_min_mul = 1.25, ammo_pickup_max_mul = 0.5 }
	self.parts.wpn_fps_ass_g3_b_sniper.stats.total_ammo_mod = -8
	self.parts.wpn_fps_ass_g3_b_sniper.stats.concealment = -5
	self.parts.wpn_fps_ass_g3_b_sniper.stats.recoil = -11
	self.parts.wpn_fps_ass_g3_b_sniper.stats.damage = 40
	self.parts.wpn_fps_ass_g3_b_short.stats.total_ammo_mod = 11
	self.parts.wpn_fps_ass_g3_b_short.custom_stats = { ammo_pickup_max_mul = 2 }
	self.parts.wpn_fps_ass_g3_b_short.has_description = true
	self.parts.wpn_fps_ass_g3_b_short.desc_id = "bm_wp_dmr_kit_penetration_desc"
	-- broomstick
	self.parts.wpn_fps_pis_c96_b_long.custom_stats = { can_shoot_through_enemy = true, armor_piercing_add = 1, ammo_pickup_min_mul = 0.33, ammo_pickup_max_mul = 0.5 }
	self.parts.wpn_fps_pis_c96_b_long.has_description = true
	self.parts.wpn_fps_pis_c96_b_long.desc_id = "bm_wp_dmr_kit_penetration_desc"
	-- ks12
	self.parts.wpn_fps_ass_shak12_body_vks.stats.damage = 40
	self.parts.wpn_fps_ass_shak12_body_vks.stats.concealment = -6
	self.parts.wpn_fps_ass_shak12_body_vks.stats.recoil = -8
	self.parts.wpn_fps_ass_shak12_body_vks.stats.total_ammo_mod = -10
	self.parts.wpn_fps_ass_shak12_body_vks.custom_stats = { can_shoot_through_enemy = true, armor_piercing_add = 1, ammo_pickup_min_mul = 0.5, ammo_pickup_max_mul = 1 / 3 }
	self.parts.wpn_fps_ass_shak12_body_vks.custom_stats.fire_rate_multiplier = 0.7
	self.parts.wpn_fps_ass_shak12_body_vks.has_description = true
	self.parts.wpn_fps_ass_shak12_body_vks.desc_id = "bm_wp_dmr_kit_penetration_desc"

	-- STILL NEED TO ORGANIZE EVERYTHING BELOW CAUSE HOLY IT IS BAD --

	-- Flamethrower Tanks
	-- MK1
	self.parts.wpn_fps_fla_mk2_mag_rare.stats.damage = -10
	self.parts.wpn_fps_fla_mk2_mag_rare.stats.concealment = 3
	self.parts.wpn_fps_fla_mk2_mag_rare.custom_stats = { ammo_pickup_max_mul = 1.65, ammo_pickup_min_mul = 1.25 }
	self.parts.wpn_fps_fla_mk2_mag_rare.desc_id = "bm_wp_upg_mk2_rare_desc"
	self.parts.wpn_fps_fla_mk2_mag_rare.has_description = true

	self.parts.wpn_fps_fla_mk2_mag_welldone.stats.damage = 10
	self.parts.wpn_fps_fla_mk2_mag_welldone.stats.concealment = -3
	self.parts.wpn_fps_fla_mk2_mag_welldone.custom_stats = { ammo_pickup_max_mul = 1, ammo_pickup_min_mul = 0.75 }
	self.parts.wpn_fps_fla_mk2_mag_welldone.desc_id = "bm_wp_upg_mk2_welldone_desc"
	self.parts.wpn_fps_fla_mk2_mag_welldone.has_description = true
	-- MA-17
	self.parts.wpn_fps_fla_system_m_high.stats.damage = 10
	self.parts.wpn_fps_fla_system_m_high.stats.concealment = -3
	self.parts.wpn_fps_fla_system_m_high.custom_stats = { ammo_pickup_max_mul = 1, ammo_pickup_min_mul = 0.75 }
	self.parts.wpn_fps_fla_system_m_high.desc_id = "bm_wp_upg_mk2_welldone_desc"
	self.parts.wpn_fps_fla_system_m_high.has_description = true

	self.parts.wpn_fps_fla_system_m_low.stats.damage = -10
	self.parts.wpn_fps_fla_system_m_low.stats.concealment = 3
	self.parts.wpn_fps_fla_system_m_low.custom_stats = { ammo_pickup_max_mul = 1.65, ammo_pickup_min_mul = 1.25 }
	self.parts.wpn_fps_fla_system_m_low.desc_id = "bm_wp_upg_mk2_rare_desc"
	self.parts.wpn_fps_fla_system_m_low.has_description = true

	-- Arrows
	self.parts.wpn_fps_bow_frankish_m_explosive.stats.damage = 0
	self.parts.wpn_fps_bow_frankish_m_poison.stats = { damage = -40 }
	self.parts.wpn_fps_upg_a_crossbow_explosion.stats.damage = 0
	self.parts.wpn_fps_upg_a_crossbow_poison.stats = { damage = -25 }
	self.parts.wpn_fps_bow_ecp_m_arrows_explosive.stats.damage = 0
	self.parts.wpn_fps_bow_ecp_m_arrows_poison.stats = { damage = -15 }
	self.parts.wpn_fps_upg_a_bow_explosion.stats.damage = 0
	self.parts.wpn_fps_upg_a_bow_poison.stats = { damage = -55 }
	self.parts.wpn_fps_bow_arblast_m_explosive.stats.damage = 0 -- apparently none of this matters cause of some vanilla bs
	self.parts.wpn_fps_bow_arblast_m_poison.stats = { damage = -20 } -- same thing

	-- misc
	table.delete(self.wpn_fps_sho_sko12.uses_parts, "wpn_fps_upg_i_singlefire")
	table.delete(self.wpn_fps_sho_sko12.uses_parts, "wpn_fps_upg_i_autofire")
	table.delete(self.wpn_fps_gre_ms3gl.uses_parts, "wpn_fps_gre_ms3gl_conversion")
	table.insert(self.parts.wpn_fps_smg_fmg9_conversion.forbids, "wpn_fps_lmg_hk51b_ns_jcomp")
end)

-- Gun Perks replace stat boosts
function WeaponFactoryTweakData:create_bonuses(tweak_data, weapon_skins)
	self.parts.wpn_fps_upg_perk_template = {
		custom = true,
		exclude_from_challenge = true,
		texture_bundle_folder = "gunperk",
		third_unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
		has_description = true,
		a_obj = "a_body",
		type = "bonus",
		name_id = nil,
		desc_id = nil,
		sub_type = "bonus_stats",
		internal_part = true,
		unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
		pcs = {
			10,
			20,
			30,
			40,
		},
		stats = {},
		custom_stats = {},
		perks = {
			"bonus",
		},
	}

	-- speedloader
	self.parts.wpn_fps_upg_perk_speedloader = deep_clone(self.parts.wpn_fps_upg_perk_template)
	self.parts.wpn_fps_upg_perk_speedloader.name_id = "bm_menu_perk_speedloader"
	self.parts.wpn_fps_upg_perk_speedloader.desc_id = "bm_menu_perk_speedloader_desc"
	self.parts.wpn_fps_upg_perk_speedloader.stats = { reload = 2, total_ammo_mod = -7 }

	-- haste
	self.parts.wpn_fps_upg_perk_haste = deep_clone(self.parts.wpn_fps_upg_perk_template)
	self.parts.wpn_fps_upg_perk_haste.name_id = "bm_menu_perk_haste"
	self.parts.wpn_fps_upg_perk_haste.desc_id = "bm_menu_perk_haste_desc"
	self.parts.wpn_fps_upg_perk_haste.stats = { total_ammo_mod = -3 }
	self.parts.wpn_fps_upg_perk_haste.custom_stats = { movement_speed = 1.1 }

	-- dead silence
	self.parts.wpn_fps_upg_perk_deadsilence = deep_clone(self.parts.wpn_fps_upg_perk_template)
	self.parts.wpn_fps_upg_perk_deadsilence.name_id = "bm_menu_perk_deadsilence"
	self.parts.wpn_fps_upg_perk_deadsilence.desc_id = "bm_menu_perk_deadsilence_desc"
	self.parts.wpn_fps_upg_perk_deadsilence.stats = { concealment = 3, total_ammo_mod = -3, recoil = -1, spread = -1 }

	-- jawbreaker
	self.parts.wpn_fps_upg_perk_jawbreaker = deep_clone(self.parts.wpn_fps_upg_perk_template)
	self.parts.wpn_fps_upg_perk_jawbreaker.name_id = "bm_menu_perk_jawbreaker"
	self.parts.wpn_fps_upg_perk_jawbreaker.desc_id = "bm_menu_perk_jawbreaker_desc"
	self.parts.wpn_fps_upg_perk_jawbreaker.stats = { damage = 15, fire_rate = 0.85 }
	self.parts.wpn_fps_upg_perk_jawbreaker.custom_stats = { ammo_pickup_max_mul = 0.625, fire_rate_multiplier = 0.85 }

	-- whirlwind
	self.parts.wpn_fps_upg_perk_whirlwind = deep_clone(self.parts.wpn_fps_upg_perk_template)
	self.parts.wpn_fps_upg_perk_whirlwind.name_id = "bm_menu_perk_whirlwind"
	self.parts.wpn_fps_upg_perk_whirlwind.desc_id = "bm_menu_perk_whirlwind_desc"
	self.parts.wpn_fps_upg_perk_whirlwind.stats = { recoil = -3, spread = -1, fire_rate = 1.15 }
	self.parts.wpn_fps_upg_perk_whirlwind.custom_stats = { fire_rate_multiplier = 1.15 }

	-- stockpile
	self.parts.wpn_fps_upg_perk_stockpile = deep_clone(self.parts.wpn_fps_upg_perk_template)
	self.parts.wpn_fps_upg_perk_stockpile.name_id = "bm_menu_perk_stockpile"
	self.parts.wpn_fps_upg_perk_stockpile.desc_id = "bm_menu_perk_stockpile_desc"
	self.parts.wpn_fps_upg_perk_stockpile.stats = { total_ammo_mod = 5, reload = -3 }

	-- gunner
	self.parts.wpn_fps_upg_perk_gunner = deep_clone(self.parts.wpn_fps_upg_perk_template)
	self.parts.wpn_fps_upg_perk_gunner.name_id = "bm_menu_perk_gunner"
	self.parts.wpn_fps_upg_perk_gunner.desc_id = "bm_menu_perk_gunner_desc"
	self.parts.wpn_fps_upg_perk_gunner.custom_stats = {
		stance_mul = {
			spread = {
				standing = {
					hipfire = 1.5,
					crouching = 0.75,
					steelsight = 0.75,
				},
				moving = {
					hipfire = 2.5,
					crouching = 0.75,
					steelsight = 1.5,
				},
			},
			recoil = {
				standing = {
					hipfire = 1.25,
					crouching = 0.75,
					steelsight = 0.75,
				},
				moving = {
					hipfire = 1.5,
					crouching = 0.75,
					steelsight = 1,
				},
			},
		},
	}
	self.parts.wpn_fps_upg_perk_gunner.forbids = { "wpn_fps_lmg_o_empty" }

	local uses_parts = {
		wpn_fps_upg_perk_speedloader = { category = { "assault_rifle", "smg", "snp", "shotgun", "crossbow", "flamethrower", "pistol", "minigun", "akimbo", "lmg", "bow" } },
		wpn_fps_upg_perk_haste = { category = { "assault_rifle", "smg", "snp", "shotgun", "flamethrower", "pistol", "minigun", "akimbo", "lmg", "bow" } },
		wpn_fps_upg_perk_deadsilence = { category = { "assault_rifle", "smg", "snp", "shotgun", "crossbow", "flamethrower", "pistol", "minigun", "akimbo", "lmg" } },
		wpn_fps_upg_perk_jawbreaker = { category = { "assault_rifle", "smg", "snp", "pistol", "minigun", "akimbo", "lmg" } },
		wpn_fps_upg_perk_whirlwind = { category = { "assault_rifle", "smg", "snp", "shotgun", "pistol", "minigun", "akimbo", "lmg" } },
		wpn_fps_upg_perk_stockpile = { category = { "assault_rifle", "smg", "snp", "shotgun", "crossbow", "flamethrower", "pistol", "minigun", "akimbo", "lmg", "bow" } },
		wpn_fps_upg_perk_gunner = { category = { "lmg" } },
	}
	local all_pass, weapon_pass, exclude_weapon_pass, category_pass, exclude_category_pass = nil

	for id, data in pairs(tweak_data.upgrades.definitions) do
		local weapon_tweak = tweak_data.weapon[data.weapon_id]
		local primary_category = weapon_tweak and weapon_tweak.categories and weapon_tweak.categories[1]

		if data.weapon_id and weapon_tweak and data.factory_id and self[data.factory_id] then
			for part_id, params in pairs(uses_parts) do
				weapon_pass = not params.weapon or table.contains(params.weapon, data.weapon_id)
				exclude_weapon_pass = not params.exclude_weapon or not table.contains(params.exclude_weapon, data.weapon_id)
				category_pass = not params.category or table.contains(params.category, primary_category)
				exclude_category_pass = not params.exclude_category or not table.contains(params.exclude_category, primary_category)
				all_pass = weapon_pass and exclude_weapon_pass and category_pass and exclude_category_pass

				if all_pass then
					table.insert(self[data.factory_id].uses_parts, part_id)
					table.insert(self[data.factory_id .. "_npc"].uses_parts, part_id)
				end
			end
		end
	end
end
