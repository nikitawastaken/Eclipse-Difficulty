Hooks:PostHook(WeaponFactoryTweakData, "init", "eclipse_init_mods", function(self)
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

	local secondary_sights = {
		"wpn_fps_upg_o_xpsg33_magnifier",
		"wpn_fps_upg_o_45rds",
		"wpn_fps_upg_o_45rds_v2",
		"wpn_fps_upg_o_sig",
		"wpn_fps_upg_o_45steel",
	}

	for id, part in pairs(self.parts) do
		local is_second_sight = table.contains(secondary_sights, id)

		if not part.custom_stats then
			part.custom_stats = {}
		end

		if table.contains(stat_blacklist, part.type) and not is_second_sight then
			part.stats = {}
			part.custom_stats = {}
		end

		if part.custom_stats then
			if part.sub_type == "ammo_explosive" then
				part.custom_stats.explosive_ammo = true
			end
		end

		if part.stats then
			local is_sight = part.type and part.type == "sight"
			local is_magazine = part.type and part.type == "magazine"
			local is_optic = is_sight and part.perks and table.contains(part.perks, "scope")
			local zoom_level = part.stats.zoom
			local is_scope = is_optic and zoom_level and zoom_level > 3
			local is_silencer = part.perks and table.contains(part.perks, "silencer")

			if part.stats.suppression then
				part.stats.suppression = 0
			end

			if part.stats.spread_moving then
				part.stats.spread_moving = 0
			end

			if part.stats.damage then
				part.stats.damage = math.round(part.stats.damage / 2.5)
			end

			local default_sights = {
				wpn_fps_upg_o_shortdot = true,
				wpn_fps_upg_o_shortdot_vanilla = true,
				wpn_fps_hailstorm_o_claymore = true,
			}

			if is_optic and not default_sights[id] then
				part.stats.concealment = -1
				part.stats.recoil = 1
				part.stats.spread = 0

				if is_scope then
					local zoom_to_spread
					local zoom_to_concealment
					if zoom_level then
						zoom_to_spread = math.clamp((zoom_level - 3) * 1, 1, 4)
						zoom_to_concealment = -math.clamp((zoom_level - 3) * 1, 1, 4)
					end

					part.stats.recoil = 0
					part.stats.spread = zoom_to_spread or 1
					part.stats.concealment = zoom_to_concealment or -2
				end

				local zoom_to_steelsight_speed = math.clamp(1 - (zoom_level and (zoom_level * 0.1) or 0), 0.25, 1)
				part.custom_stats.steelsight_speed_multiplier = zoom_to_steelsight_speed or 1
			end

			if is_second_sight then
				part.stats.spread = 0
				part.stats.recoil = 0
				part.stats.concealment = -1
			end

			if is_sight and id:match("_standard$") or id:match("_iron") then
				part.stats.concealment = 0
				part.stats.recoil = 0
				part.stats.zoom = 0
			end

			if is_magazine and id:match("_quick$") or id:match("_speed$") or id:match("_strap$") then
				part.stats = {}
				part.stats.concealment = -1
				part.custom_stats = { reload_speed_multiplier = 1.1 }
			end

			if id:match("_legend") and not is_silencer then
				part.stats = {}
				part.custom_stats = {}
			end
		end
	end

	-- Create a list of available barrel extensions
	local rifle_barrel_exts = {}
	for _, part_id in ipairs(self.wpn_fps_ass_m4.uses_parts) do
		local part = self.parts and self.parts[part_id]
		local is_barrel_ext = part and part.type == "barrel_ext"
		local default_part = table.contains(self.wpn_fps_ass_m4.default_blueprint, part_id)

		if is_barrel_ext and not default_part then
			rifle_barrel_exts[part_id] = true
		end
	end

	local function generate_fast_mag(part_id)
		local part = self.parts[part_id]

		if part then
			part.stats = {}
			part.stats.value = 1
			part.stats.concealment = -1
			part.custom_stats.reload_speed_multiplier = 1.1
		end
	end

	local function assign_barrel_exts(factory_id, barrel_ext_list, exclude_silencer, blacklist)
		local barrel_exts = clone(barrel_ext_list)
		for part_id, add in pairs(barrel_exts) do
			if add then
				local part = self.parts[part_id]
				local is_barrel_ext = part and part.type == "barrel_ext"
				local is_silencer = is_barrel_ext and part.sub_type == "silencer"

				if not blacklist and blacklist[part_id] then
					if not exclude_silencer and is_silencer then
						table.insert(self[factory_id].uses_parts, part_id)
					end
				end
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
		end
	end

	for index, sight_id in ipairs(sight_table) do
		--Add sight mounts and rails
		self.wpn_fps_lmg_rpk.adds[sight_id] = { "wpn_fps_ak_extra_ris" }
		--self.wpn_fps_lmg_m249.override[sight_id] = { parent = "upper_reciever" }
		self.wpn_fps_lmg_hk21.adds[sight_id] = { "wpn_fps_ass_g3_body_rail" }
		self.wpn_fps_lmg_mg42.adds[sight_id] = { "wpn_fps_rpg7_sight_adapter" }
		--self.wpn_fps_lmg_mg42.override[sight_id] = { parent = "upper_reciever" }
		--self.wpn_fps_lmg_par.override[sight_id] = { parent = "upper_reciever" }
		self.wpn_fps_lmg_m60.adds[sight_id] = { "wpn_fps_ass_groza_o_adapter" }
		self.wpn_fps_lmg_m60.override[sight_id] = { forbids = { "wpn_fps_lmg_m60_sight_standard" } }
		--self.wpn_fps_lmg_m60.override[sight_id] = { forbids = { "wpn_fps_lmg_m60_sight_standard" }, parent = "upper_reciever" }

		--Add suport for the AK scope mount
		table.insert(self.wpn_fps_lmg_rpk.uses_parts, "wpn_fps_upg_o_ak_scopemount")
		self.wpn_fps_lmg_rpk.override.wpn_fps_upg_o_ak_scopemount = {}
		self.wpn_fps_lmg_rpk.override.wpn_fps_upg_o_ak_scopemount.override = {}
		self.wpn_fps_lmg_rpk.override.wpn_fps_upg_o_ak_scopemount.override[sight_id] = { a_obj = "a_o_sm", stance_mod = { wpn_fps_lmg_rpk = { translation = Vector3(0, 0, -4.6) } } }
	end

	local piggyback_stats = { value = 1, gadget_zoom = 1 }

	self.parts.wpn_fps_upg_o_specter_piggyback.stats = clone(piggyback_stats)
	self.parts.wpn_fps_upg_o_cs_piggyback.stats = clone(piggyback_stats)
	self.parts.wpn_fps_upg_o_atibal_reddot.stats = clone(piggyback_stats)
	self.parts.wpn_fps_upg_o_hamr_reddot.stats = clone(piggyback_stats)
	self.parts.wpn_fps_upg_o_northtac_reddot.stats = clone(piggyback_stats)
	self.parts.wpn_fps_upg_o_schmidt_magnified.stats = clone(piggyback_stats)
	self.parts.wpn_fps_upg_o_schmidt_magnified.stats.gadget_zoom = 7

	self.parts.wpn_fps_upg_o_mbus_pro.stats.zoom = 0
	self.parts.wpn_fps_upg_o_mbus_pro.stats.recoil = 0
	self.parts.wpn_fps_upg_o_mbus_pro.stats.concealment = 0

	--make all car weapons use the 30 rnd magazine by default

	-- Assault Rifle Mods
	self.parts.wpn_fps_upg_m4_m_straight_vanilla = deep_clone(self.parts.wpn_fps_m4_uupg_m_std)
	self.parts.wpn_fps_upg_m4_m_straight_vanilla.stats = nil
	self.parts.wpn_fps_upg_m4_m_straight_vanilla.pcs = nil

	self.parts.wpn_fps_m4_uupg_m_std = deep_clone(self.parts.wpn_fps_upg_m4_m_straight)

	self.parts.wpn_fps_upg_m4_m_straight.stats.extra_ammo = -5

	self.parts.wpn_fps_m4_uupg_b_short.stats.spread = -2

	self.parts.wpn_fps_m4_uupg_b_long.stats.damage = 0
	self.parts.wpn_fps_m4_uupg_b_long.stats.spread = 2

	self.parts.wpn_fps_m4_uupg_s_fold.stats.recoil = -2
	self.parts.wpn_fps_m4_uupg_s_fold.stats.concealment = 2

	self.parts.wpn_fps_upg_ak_b_draco.stats.damage = 0
	self.parts.wpn_fps_upg_ak_b_draco.stats.concealment = 2

	self.parts.wpn_fps_upg_ak_b_ak105.stats.damage = 0
	self.parts.wpn_fps_upg_ak_b_ak105.stats.spread = -1

	self.parts.wpn_upg_ak_s_folding.stats.recoil = -2

	self.parts.wpn_upg_ak_s_skfoldable.stats.recoil = -2

	self.parts.wpn_upg_ak_s_psl.stats.spread = 3
	self.parts.wpn_upg_ak_s_psl.stats.concealment = -3

	self.parts.wpn_fps_upg_ak_m_uspalm.stats.extra_ammo = 0
	self.parts.wpn_fps_upg_ak_m_uspalm.custom_stats.ammo_offset = 5

	self.parts.wpn_fps_aug_b_short.stats.spread = -2
	self.parts.wpn_fps_aug_b_short.stats.recoil = 0

	self.parts.wpn_fps_aug_b_long.stats.recoil = 0
	self.parts.wpn_fps_aug_b_long.stats.concealment = -1

	self.parts.wpn_fps_ass_ak5_b_short.stats.damage = 0
	self.parts.wpn_fps_ass_ak5_b_short.stats.spread = -2

	self.parts.wpn_fps_ass_g36_fg_c.stats.spread = -1
	self.parts.wpn_fps_ass_g36_fg_c.stats.concealment = 1

	self.parts.wpn_fps_upg_g36_fg_long.stats.spread = 2
	self.parts.wpn_fps_upg_g36_fg_long.stats.recoil = 0
	self.parts.wpn_fps_upg_g36_fg_long.stats.concealment = -2

	self.parts.wpn_fps_ass_s552_b_long.stats.concealment = -1

	self.parts.wpn_fps_ass_famas_b_short.stats.damage = 0

	self.parts.wpn_fps_ass_famas_b_sniper.stats.spread = 3

	self.parts.wpn_fps_ass_famas_b_suppressed.stats.concealment = -2

	self.parts.wpn_fps_ass_l85a2_b_long.stats.spread = 2
	self.parts.wpn_fps_ass_l85a2_b_long.stats.concealment = -2

	self.parts.wpn_fps_ass_l85a2_b_short.stats.spread = -2
	self.parts.wpn_fps_ass_l85a2_b_short.stats.concealment = 2

	self.parts.wpn_fps_ass_vhs_b_short.stats.spread = -2
	self.parts.wpn_fps_ass_vhs_b_short.stats.recoil = 0
	self.parts.wpn_fps_ass_vhs_b_short.stats.concealment = 2

	self.parts.wpn_fps_ass_vhs_b_silenced.stats.damage = -2

	self.parts.wpn_fps_ass_vhs_m.stats.recoil = 0

	self.parts.wpn_fps_ass_asval_b_proto.stats.spread = -2

	self.parts.wpn_fps_ass_asval_s_solid.stats.spread = 1
	self.parts.wpn_fps_ass_asval_s_solid.stats.recoil = 2
	self.parts.wpn_fps_ass_asval_s_solid.stats.concealment = -3

	self.parts.wpn_fps_smg_hajk_b_medium.stats.spread = -1
	self.parts.wpn_fps_smg_hajk_b_medium.stats.concealment = 1

	self.parts.wpn_fps_smg_hajk_b_short.stats.spread = 2
	self.parts.wpn_fps_smg_hajk_b_short.stats.concealment = -2

	self.parts.wpn_fps_ass_corgi_b_short.stats.concealment = 2

	-- DMR Mods
	self.parts.wpn_fps_ass_m14_body_ruger.stats.spread = -6
	self.parts.wpn_fps_ass_m14_body_ruger.stats.recoil = -2
	self.parts.wpn_fps_ass_m14_body_ruger.stats.concealment = 8

	self.parts.wpn_fps_ass_scar_b_short.stats.spread = -2
	self.parts.wpn_fps_ass_scar_b_short.stats.concealment = 2

	self.parts.wpn_fps_ass_scar_b_long.stats.concealment = -2

	self.parts.wpn_fps_ass_sub2000_fg_suppressed.spread = -2
	self.parts.wpn_fps_ass_sub2000_fg_suppressed.concealment = 1

	self.parts.wpn_fps_ass_g3_fg_retro.stats.spread = -2
	self.parts.wpn_fps_ass_g3_fg_retro.stats.concealment = 2

	self.parts.wpn_fps_ass_g3_fg_retro_plastic.stats.recoil = -2
	self.parts.wpn_fps_ass_g3_fg_retro_plastic.stats.concealment = 2

	self.parts.wpn_fps_ass_fal_fg_03.stats.recoil = 0
	self.parts.wpn_fps_ass_fal_fg_03.stats.concealment = 0

	self.parts.wpn_fps_ass_fal_fg_01.stats.spread = -4
	self.parts.wpn_fps_ass_fal_fg_01.stats.concealment = 4

	self.parts.wpn_fps_ass_fal_s_01.stats.recoil = -2
	self.parts.wpn_fps_ass_fal_s_01.stats.concealment = 2

	self.parts.wpn_fps_ass_ching_b_short.stats.spread = -3
	self.parts.wpn_fps_ass_ching_b_short.stats.concealment = 3

	self.parts.wpn_fps_ass_ching_s_pouch.stats.total_ammo_mod = 3
	self.parts.wpn_fps_ass_ching_s_pouch.stats.concealment = -2

	-- Pistol mods
	self.parts.wpn_fps_pis_g18c_m_mag_33rnd.stats.extra_ammo = 8

	self.parts.wpn_fps_pis_beretta_m_extended.stats.extra_ammo = 5

	self.parts.wpn_fps_pis_1911_b_long.stats.spread = 2
	self.parts.wpn_fps_pis_1911_b_long.stats.recoil = -2

	self.parts.wpn_fps_pis_1911_m_extended.stats.extra_ammo = 3

	self.parts.wpn_fps_pis_1911_m_big.stats.extra_ammo = 5
	self.parts.wpn_fps_pis_1911_m_big.stats.recoil = 0

	self.parts.wpn_fps_pis_rage_b_comp1.stats.spread = 1
	self.parts.wpn_fps_pis_rage_b_comp1.stats.concealment = -1

	self.parts.wpn_fps_pis_rage_b_comp2.stats.recoil = 1
	self.parts.wpn_fps_pis_rage_b_comp2.stats.concealment = -1

	self.parts.wpn_fps_pis_rage_b_long.stats.spread = 2
	self.parts.wpn_fps_pis_rage_b_long.stats.concealment = -2

	self.parts.wpn_fps_pis_rage_b_short.stats.spread = -2
	self.parts.wpn_fps_pis_rage_b_short.stats.concealment = 2

	self.parts.wpn_fps_pis_deagle_m_extended.stats.extra_ammo = 0
	self.parts.wpn_fps_pis_deagle_m_extended.custom_stats = { ammo_offset = 3 }

	self.parts.wpn_fps_pis_usp_b_expert.stats.spread = 1
	self.parts.wpn_fps_pis_usp_b_expert.stats.concealment = -1

	self.parts.wpn_fps_pis_usp_b_match.stats.recoil = 3
	self.parts.wpn_fps_pis_usp_b_match.stats.concealment = -3

	self.parts.wpn_fps_pis_usp_m_extended.stats.extra_ammo = 3

	self.parts.wpn_fps_pis_usp_m_big.stats.extra_ammo = 6
	self.parts.wpn_fps_pis_usp_m_big.stats.recoil = 0

	self.parts.wpn_fps_pis_ppk_b_long.stats.spread = 1
	self.parts.wpn_fps_pis_ppk_b_long.stats.concealment = -1

	self.parts.wpn_fps_pis_p226_b_long.stats.spread = 2
	self.parts.wpn_fps_pis_p226_b_long.stats.concealment = -2

	self.parts.wpn_fps_pis_p226_m_extended.stats.extra_ammo = 3

	self.parts.wpn_fps_pis_g22c_b_long.stats.spread = 1
	self.parts.wpn_fps_pis_g22c_b_long.stats.recoil = -1

	self.parts.wpn_fps_pis_c96_s_solid.stats.recoil = 3
	self.parts.wpn_fps_pis_c96_s_solid.stats.concealment = -3

	self.parts.wpn_fps_pis_c96_m_extended.stats.extra_ammo = 5

	self.parts.wpn_fps_pis_g26_m_mag_33rnd = deep_clone(self.parts.wpn_fps_pis_g18c_m_mag_33rnd)
	self.parts.wpn_fps_pis_g26_m_mag_33rnd.stats.extra_ammo = 0
	self.parts.wpn_fps_pis_g26_m_mag_33rnd.custom_stats = { ammo_offset = 23 }

	self.parts.wpn_fps_pis_g26_m_contour.stats.recoil = 0

	self.parts.wpn_fps_pis_hs2000_sl_custom.stats.spread = -1
	self.parts.wpn_fps_pis_hs2000_sl_custom.stats.concealment = 1

	self.parts.wpn_fps_pis_hs2000_m_extended.stats.extra_ammo = 4

	self.parts.wpn_fps_pis_2006m_b_long.stats.spread = 1
	self.parts.wpn_fps_pis_2006m_b_long.stats.recoil = 0
	self.parts.wpn_fps_pis_2006m_b_long.stats.concealment = -1

	self.parts.wpn_fps_pis_2006m_b_medium.stats.spread = -1
	self.parts.wpn_fps_pis_2006m_b_medium.stats.recoil = 0
	self.parts.wpn_fps_pis_2006m_b_medium.stats.concealment = 1

	self.parts.wpn_fps_pis_2006m_b_short.stats.spread = -2
	self.parts.wpn_fps_pis_2006m_b_short.stats.recoil = 0
	self.parts.wpn_fps_pis_2006m_b_short.stats.concealment = 2

	self.parts.wpn_fps_pis_peacemaker_b_long.stats.spread = 2
	self.parts.wpn_fps_pis_peacemaker_b_long.stats.concealment = -2

	self.parts.wpn_fps_pis_peacemaker_b_short.stats.spread = -1
	self.parts.wpn_fps_pis_peacemaker_b_short.stats.concealment = 1

	self.parts.wpn_fps_pis_peacemaker_s_skeletal.stats.recoil = 2
	self.parts.wpn_fps_pis_peacemaker_s_skeletal.stats.concealment = -2

	self.parts.wpn_fps_pis_sparrow_b_comp.stats.spread = 1
	self.parts.wpn_fps_pis_sparrow_b_comp.stats.recoil = 1
	self.parts.wpn_fps_pis_sparrow_b_comp.stats.concealment = -2

	self.parts.wpn_fps_pis_sparrow_b_threaded.stats.spread = 1
	self.parts.wpn_fps_pis_sparrow_b_threaded.stats.recoil = 0
	self.parts.wpn_fps_pis_sparrow_b_threaded.stats.concealment = -1

	self.parts.wpn_fps_pis_pl14_m_extended.stats.extra_ammo = 2

	self.parts.wpn_fps_pis_packrat_m_extended.stats.extra_ammo = 5

	self.parts.wpn_fps_pis_breech_b_reinforced.stats.spread = 0
	self.parts.wpn_fps_pis_breech_b_reinforced.stats.recoil = 1
	self.parts.wpn_fps_pis_breech_b_reinforced.stats.concealment = -1

	self.parts.wpn_fps_pis_breech_b_short.stats.spread = -1
	self.parts.wpn_fps_pis_breech_b_short.stats.concealment = 1

	self.parts.wpn_fps_pis_chinchilla_b_satan.stats.spread = 1
	self.parts.wpn_fps_pis_chinchilla_b_satan.stats.recoil = 1
	self.parts.wpn_fps_pis_chinchilla_b_satan.stats.concealment = -2

	self.parts.wpn_fps_pis_lemming_m_ext.stats.extra_ammo = 5

	self.parts.wpn_fps_pis_shrew_m_extended.stats.extra_ammo = 3

	self.parts.wpn_fps_pis_holt_m_extended.stats.extra_ammo = 5

	self.parts.wpn_fps_pis_beer_b_robo.stats.spread = 4
	self.parts.wpn_fps_pis_beer_b_robo.stats.recoil = -1
	self.parts.wpn_fps_pis_beer_b_robo.stats.concealment = -3

	self.parts.wpn_fps_pis_beer_s_std.stats.recoil = 2
	self.parts.wpn_fps_pis_beer_s_std.stats.concealment = -2

	self.parts.wpn_fps_pis_beer_m_extended.stats.extra_ammo = 0
	self.parts.wpn_fps_pis_beer_m_extended.custom_stats = { ammo_offset = 9 }

	self.parts.wpn_fps_pis_czech_b_long.spread = 2
	self.parts.wpn_fps_pis_czech_b_long.stats.concealment = -2

	self.parts.wpn_fps_pis_czech_s_standard.stats.recoil = 2
	self.parts.wpn_fps_pis_czech_s_standard.stats.concealment = -2

	self.parts.wpn_fps_pis_czech_m_extended.stats.extra_ammo = 6

	self.parts.wpn_fps_pis_stech_b_long.stats.spread = 2
	self.parts.wpn_fps_pis_stech_b_long.stats.concealment = -2

	self.parts.wpn_fps_pis_stech_s_standard.stats.recoil = 3
	self.parts.wpn_fps_pis_stech_s_standard.stats.concealment = -3

	self.parts.wpn_fps_pis_stech_m_extended.stats.extra_ammo = 5

	self.parts.wpn_fps_pis_model3_b_long.stats.spread = 1
	self.parts.wpn_fps_pis_model3_b_long.stats.recoil = 1
	self.parts.wpn_fps_pis_model3_b_long.stats.concealment = -2

	self.parts.wpn_fps_pis_model3_b_short.stats.spread = -1
	self.parts.wpn_fps_pis_model3_b_short.stats.concealment = 1

	self.parts.wpn_fps_pis_m1911_m_extended.stats.extra_ammo = 1

	self.parts.wpn_fps_pis_type54_b_long.stats.spread = 2
	self.parts.wpn_fps_pis_type54_b_long.stats.recoil = 0
	self.parts.wpn_fps_pis_type54_b_long.stats.concealment = -2

	self.parts.wpn_fps_pis_type54_m_ext.stats.extra_ammo = 3

	self.parts.wpn_fps_pis_rsh12_b_short.stats.damage = 0
	self.parts.wpn_fps_pis_rsh12_b_short.stats.spread = 2
	self.parts.wpn_fps_pis_rsh12_b_short.stats.recoil = 1
	self.parts.wpn_fps_pis_rsh12_b_short.stats.concealment = -3

	self.parts.wpn_fps_pis_rsh12_b_short.stats.spread = -2
	self.parts.wpn_fps_pis_rsh12_b_short.stats.recoil = 0
	self.parts.wpn_fps_pis_rsh12_b_short.stats.concealment = 2

	self.parts.wpn_fps_pis_maxim9_b_marksman.stats.spread = 0
	self.parts.wpn_fps_pis_maxim9_b_marksman.stats.recoil = 2
	self.parts.wpn_fps_pis_maxim9_b_marksman.stats.concealment = -2

	self.parts.wpn_fps_pis_maxim9_b_long.stats.spread = 2
	self.parts.wpn_fps_pis_maxim9_b_long.stats.recoil = 1
	self.parts.wpn_fps_pis_maxim9_b_long.stats.concealment = -3

	self.parts.wpn_fps_pis_maxim9_m_ext.stats.extra_ammo = 0
	self.parts.wpn_fps_pis_maxim9_m_ext.custom_stats = { ammo_offset = 9 }

	self.parts.wpn_fps_pis_korth_b_railed.stats.damage = 0
	self.parts.wpn_fps_pis_korth_b_railed.stats.spread = 0
	self.parts.wpn_fps_pis_korth_b_railed.stats.recoil = 0
	self.parts.wpn_fps_pis_korth_b_railed.stats.concealment = 0

	self.parts.wpn_fps_pis_korth_m_6.stats.extra_ammo = -1
	self.parts.wpn_fps_pis_korth_m_6.stats.total_ammo_mod = -5
	self.parts.wpn_fps_pis_korth_m_6.stats.damage = 16
	self.parts.wpn_fps_pis_korth_m_6.stats.spread = 2
	self.parts.wpn_fps_pis_korth_m_6.stats.recoil = -3
	self.parts.wpn_fps_pis_korth_m_6.stats.concealment = 0
	self.parts.wpn_fps_pis_korth_m_6.custom_stats = { ammo_pickup_max_mul = 0.8, ammo_pickup_min_mul = 0.8 }

	-- SMG Mods
	self.parts.wpn_fps_smg_mp9_s_skel.stats.spread = 1
	self.parts.wpn_fps_smg_mp9_s_skel.stats.recoil = 2
	self.parts.wpn_fps_smg_mp9_s_skel.stats.concealment = -3

	self.parts.wpn_fps_smg_mp5_fg_m5k.stats.spread = -2
	self.parts.wpn_fps_smg_mp5_fg_m5k.stats.concealment = 2

	self.parts.wpn_fps_smg_mp5_fg_mp5sd.stats.damage = -2
	self.parts.wpn_fps_smg_mp5_fg_mp5sd.stats.concealment = 1

	self.parts.wpn_fps_smg_mp5_s_adjust.stats.recoil = -1
	self.parts.wpn_fps_smg_mp5_s_adjust.stats.concealment = 1

	self.parts.wpn_fps_smg_mp5_s_ring.stats.recoil = -2
	self.parts.wpn_fps_smg_mp5_s_ring.stats.concealment = 2

	self.parts.wpn_fps_smg_mp5_m_straight.stats.total_ammo_mod = -5
	self.parts.wpn_fps_smg_mp5_m_straight.stats.damage = 6
	self.parts.wpn_fps_smg_mp5_m_straight.stats.concealment = 0
	self.parts.wpn_fps_smg_mp5_m_straight.custom_stats = { ammo_pickup_max_mul = 0.75, ammo_pickup_min_mul = 0.75 }

	self.parts.wpn_fps_smg_p90_b_long.stats.damage = 0
	self.parts.wpn_fps_smg_p90_b_long.stats.spread = 2
	self.parts.wpn_fps_smg_p90_b_long.stats.recoil = 0

	self.parts.wpn_fps_smg_p90_b_civilian.stats.concealment = -3

	self.parts.wpn_fps_smg_p90_b_ninja.stats.concealment = -4

	self.parts.wpn_fps_smg_m45_b_small.stats.concealment = 2

	self.parts.wpn_fps_smg_m45_s_folded.stats.recoil = -3
	self.parts.wpn_fps_smg_m45_s_folded.stats.concealment = 3

	self.parts.wpn_fps_smg_mp7_s_long.stats.recoil = 2
	self.parts.wpn_fps_smg_mp7_s_long.stats.concealment = -2

	self.parts.wpn_fps_smg_scorpion_m_extended.stats = { value = 1, concealment = -2 }
	self.parts.wpn_fps_smg_scorpion_m_extended.custom_stats = { reload_speed_multiplier = 1.2 }

	self.parts.wpn_fps_smg_scorpion_s_nostock.stats.recoil = -1
	self.parts.wpn_fps_smg_scorpion_s_nostock.stats.concealment = 1

	self.parts.wpn_fps_smg_scorpion_s_unfolded.stats.spread = 1
	self.parts.wpn_fps_smg_scorpion_s_unfolded.stats.recoil = 2
	self.parts.wpn_fps_smg_scorpion_s_unfolded.stats.concealment = -3

	self.parts.wpn_fps_smg_thompson_barrel_short.stats.spread = -2
	self.parts.wpn_fps_smg_thompson_barrel_short.stats.concealment = 2

	self.parts.wpn_fps_smg_thompson_barrel_long.stats.damage = 0
	self.parts.wpn_fps_smg_thompson_barrel_long.stats.concealment = -2

	self.parts.wpn_fps_smg_thompson_stock_nostock.stats.recoil = -3
	self.parts.wpn_fps_smg_thompson_stock_nostock.stats.concealment = 3

	self.parts.wpn_fps_smg_baka_s_standard.stats.recoil = -1
	self.parts.wpn_fps_smg_baka_s_standard.stats.concealment = 1

	self.parts.wpn_fps_smg_baka_s_unfolded.stats.spread = 1
	self.parts.wpn_fps_smg_baka_s_unfolded.stats.recoil = 2
	self.parts.wpn_fps_smg_baka_s_unfolded.stats.concealment = -3

	self.parts.wpn_fps_smg_shepheard_body_short.stats.spread = -2
	self.parts.wpn_fps_smg_shepheard_body_short.stats.concealment = 2

	self.parts.wpn_fps_smg_shepheard_mag_extended.unit = "units/pd2_dlc_joy/weapons/wpn_fps_smg_shepheard_pts/wpn_fps_smg_shepheard_mag_standard"
	self.parts.wpn_fps_smg_shepheard_mag_extended.bullet_objects = { amount = 20, prefix = "g_bullet_" }
	self.parts.wpn_fps_smg_shepheard_mag_extended.stats = { value = 1, extra_ammo = -5, concealment = 1, reload = 2 }

	self.parts.wpn_fps_smg_shepheard_mag_standard.unit = "units/pd2_dlc_joy/weapons/wpn_fps_smg_shepheard_pts/wpn_fps_smg_shepheard_mag_extended"
	self.parts.wpn_fps_smg_shepheard_mag_standard.bullet_objects = { amount = 30, prefix = "g_bullet_" }

	self.parts.wpn_fps_smg_shepheard_s_no.stats.recoil = -2
	self.parts.wpn_fps_smg_shepheard_s_no.stats.concealment = 2

	self.parts.wpn_fps_smg_schakal_b_civil.stats.damage = 0
	self.parts.wpn_fps_smg_schakal_b_civil.stats.spread = 2
	self.parts.wpn_fps_smg_schakal_b_civil.stats.concealment = -2

	self.parts.wpn_fps_smg_erma_s_folded.stats.recoil = -2
	self.parts.wpn_fps_smg_erma_s_folded.stats.concealment = 2

	self.parts.wpn_fps_smg_pm9_b_short.stats.spread = -2
	self.parts.wpn_fps_smg_pm9_b_short.stats.recoil = 0

	self.parts.wpn_fps_smg_pm9_s_tactical.stats.recoil = 2
	self.parts.wpn_fps_smg_pm9_s_tactical.stats.concealment = -2

	assign_barrel_exts(wpn_fps_smg_pm9, rifle_barrel_exts, false, {})

	-- Shotgun Mods
	self.parts.wpn_fps_sho_saiga_b_short.stats.spread = -2
	self.parts.wpn_fps_sho_saiga_b_short.stats.concealment = 2

	self.parts.wpn_fps_sho_saiga_fg_holy.stats.recoil = -2
	self.parts.wpn_fps_sho_saiga_fg_holy.stats.concealment = 2

	self.parts.wpn_fps_sho_basset_m_extended.stats.extra_ammo = 0
	self.parts.wpn_fps_sho_basset_m_extended.custom_stats = { ammo_offset = 3 }

	self.parts.wpn_fps_sho_aa12_mag_drum.stats.extra_ammo = 6

	self.parts.wpn_fps_shot_r870_body_rack.stats.concealment = -2
	self.parts.wpn_fps_shot_r870_body_rack.custom_stats.reload_speed_multiplier = 1.2

	self.parts.wpn_fps_shot_shorty_m_extended_short.stats.extra_ammo = 0
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

	-- Sniper Rifle Mods
	self.parts.wpn_fps_snp_sbl_b_long.stats.extra_ammo = -1
	self.parts.wpn_fps_snp_sbl_b_long.stats.spread = 3
	self.parts.wpn_fps_snp_sbl_b_long.stats.recoil = 0
	self.parts.wpn_fps_snp_sbl_b_long.stats.concealment = -1

	self.parts.wpn_fps_snp_sbl_b_short.stats.extra_ammo = -1
	self.parts.wpn_fps_snp_sbl_b_short.stats.spread = -1
	self.parts.wpn_fps_snp_sbl_b_short.stats.recoil = 0

	self.parts.wpn_fps_snp_mosin_ns_bayonet.stats.min_damage = 9
	self.parts.wpn_fps_snp_mosin_ns_bayonet.stats.max_damage = self.parts.wpn_fps_snp_mosin_ns_bayonet.stats.min_damage
	self.parts.wpn_fps_snp_mosin_ns_bayonet.stats.min_damage_effect = 1.5
	self.parts.wpn_fps_snp_mosin_ns_bayonet.stats.max_damage_effect = self.parts.wpn_fps_snp_mosin_ns_bayonet.stats.min_damage_effect

	-- LMG Mods
	self.parts.wpn_fps_upg_bp_lmg_lionbipod.stats.concealment = -1

	self.parts.wpn_fps_lmg_m249_b_long.stats.damage = 0
	self.parts.wpn_fps_lmg_m249_b_long.stats.spread = 1
	self.parts.wpn_fps_lmg_m249_b_long.stats.recoil = 1
	self.parts.wpn_fps_lmg_m249_b_long.stats.concealment = -2

	self.parts.wpn_fps_lmg_hk21_b_long.stats.damage = 0
	self.parts.wpn_fps_lmg_hk21_b_long.stats.spread = 2
	self.parts.wpn_fps_lmg_hk21_b_long.stats.recoil = 0
	self.parts.wpn_fps_lmg_hk21_b_long.stats.concealment = -2

	self.parts.wpn_fps_lmg_hk21_fg_short.stats.spread = -2
	self.parts.wpn_fps_lmg_hk21_fg_short.stats.recoil = -1
	self.parts.wpn_fps_lmg_hk21_fg_short.stats.concealment = 3

	self.parts.wpn_fps_lmg_mg42_b_mg34.stats.damage = 0
	self.parts.wpn_fps_lmg_mg42_b_mg34.stats.spread = 1
	self.parts.wpn_fps_lmg_mg42_b_mg34.stats.recoil = 1
	self.parts.wpn_fps_lmg_mg42_b_mg34.custom_stats = { fire_rate_multiplier = 900 / 1200 }

	self.parts.wpn_fps_lmg_par_m_standard.bullet_objects = {
		amount = 5,
		prefix = "g_bullet_",
	}

	self.parts.wpn_fps_lmg_par_b_short.stats.spread = -2
	self.parts.wpn_fps_lmg_par_b_short.stats.concealment = 2

	self.parts.wpn_fps_ass_tecci_b_long.stats.damage = 0
	self.parts.wpn_fps_ass_tecci_b_long.stats.spread = 2
	self.parts.wpn_fps_ass_tecci_b_long.stats.recoil = 0
	self.parts.wpn_fps_ass_tecci_b_long.stats.concealment = -2

	self.parts.wpn_fps_lmg_m60_b_short.stats.spread = -2
	self.parts.wpn_fps_lmg_m60_b_short.stats.recoil = 0
	self.parts.wpn_fps_lmg_m60_b_short.stats.concealment = 2

	self.parts.wpn_fps_lmg_hk51b_b_fluted.stats.damage = 0
	self.parts.wpn_fps_lmg_hk51b_b_fluted.stats.spread = 2
	self.parts.wpn_fps_lmg_hk51b_b_fluted.stats.recoil = 0
	self.parts.wpn_fps_lmg_hk51b_b_fluted.stats.concealment = -2

	self.parts.wpn_fps_lmg_hk51b_s_extended.stats.recoil = 2
	self.parts.wpn_fps_lmg_hk51b_s_extended.stats.concealment = -2

	self.parts.wpn_fps_lmg_hcar_barrel_short.stats.spread = -2
	self.parts.wpn_fps_lmg_hcar_barrel_short.stats.recoil = 0
	self.parts.wpn_fps_lmg_hcar_barrel_short.stats.concealment = 2

	self.parts.wpn_fps_lmg_hcar_barrel_dmr.stats.extra_ammo = 0
	self.parts.wpn_fps_lmg_hcar_barrel_dmr.stats.total_ammo_mod = 0
	self.parts.wpn_fps_lmg_hcar_barrel_dmr.stats.damage = 0
	self.parts.wpn_fps_lmg_hcar_barrel_dmr.stats.spread = 2
	self.parts.wpn_fps_lmg_hcar_barrel_dmr.stats.concealment = -2

	self.parts.wpn_fps_lmg_hcar_m_stick.stats.extra_ammo = 5

	self.parts.wpn_fps_lmg_hcar_m_drum.stats.extra_ammo = 15
	self.parts.wpn_fps_lmg_hcar_m_drum.stats.spread = 0

	self.parts.wpn_fps_lmg_hcar_body_conversionkit.stats.extra_ammo = 15
	self.parts.wpn_fps_lmg_hcar_body_conversionkit.stats.total_ammo_mod = 13
	self.parts.wpn_fps_lmg_hcar_body_conversionkit.stats.damage = -20
	self.parts.wpn_fps_lmg_hcar_body_conversionkit.stats.spread = -4
	self.parts.wpn_fps_lmg_hcar_body_conversionkit.stats.recoil = 6
	self.parts.wpn_fps_lmg_hcar_body_conversionkit.stats.concealment = 0
	self.parts.wpn_fps_lmg_hcar_body_conversionkit.custom_stats = { fire_rate_multiplier = 1.5, ammo_pickup_min_mul = 2, ammo_pickup_max_mul = 2 }

	self.parts.wpn_fps_lmg_kacchainsaw_b_long.stats.damage = 0
	self.parts.wpn_fps_lmg_kacchainsaw_b_long.stats.spread = 2
	self.parts.wpn_fps_lmg_kacchainsaw_b_long.stats.recoil = 0
	self.parts.wpn_fps_lmg_kacchainsaw_b_long.stats.concealment = -2

	self.parts.wpn_fps_lmg_kacchainsaw_mag_b.stats.extra_ammo = -25
	self.parts.wpn_fps_lmg_kacchainsaw_mag_b.stats.recoil = 0

	self.parts.wpn_fps_lmg_kacchainsaw_flamethrower.stats.total_ammo_mod = -10
	self.parts.wpn_fps_lmg_kacchainsaw_flamethrower.stats.spread = 0
	self.parts.wpn_fps_lmg_kacchainsaw_flamethrower.stats.recoil = 0
	self.parts.wpn_fps_lmg_kacchainsaw_flamethrower.stats.concealment = -4

	self.parts.wpn_fps_lmg_kacchainsaw_conversionkit.stats.extra_ammo = 0
	self.parts.wpn_fps_lmg_kacchainsaw_conversionkit.stats.total_ammo_mod = 10
	self.parts.wpn_fps_lmg_kacchainsaw_conversionkit.stats.damage = -4
	self.parts.wpn_fps_lmg_kacchainsaw_conversionkit.stats.spread = -3
	self.parts.wpn_fps_lmg_kacchainsaw_conversionkit.stats.recoil = 0
	self.parts.wpn_fps_lmg_kacchainsaw_conversionkit.stats.concealment = 0
	self.parts.wpn_fps_lmg_kacchainsaw_conversionkit.custom_stats = { fire_rate_multiplier = 1400 / 1100, ammo_pickup_min_mul = 0.7, ammo_pickup_max_mul = 0.7 }

	--Minigun Mods
	self.parts.wpn_fps_lmg_m134_barrel_extreme.stats.spread = 3
	self.parts.wpn_fps_lmg_m134_barrel_extreme.stats.recoil = -1
	self.parts.wpn_fps_lmg_m134_barrel_extreme.stats.concealment = -2

	self.parts.wpn_fps_lmg_m134_barrel_short.stats.spread = -3
	self.parts.wpn_fps_lmg_m134_barrel_short.stats.recoil = -1
	self.parts.wpn_fps_lmg_m134_barrel_short.stats.concealment = 4

	self.parts.wpn_fps_lmg_m134_body_upper_light.stats.total_ammo_mod = -10
	self.parts.wpn_fps_lmg_m134_body_upper_light.stats.spread = 0
	self.parts.wpn_fps_lmg_m134_body_upper_light.stats.recoil = 2
	self.parts.wpn_fps_lmg_m134_body_upper_light.stats.concealment = 2

	self.parts.wpn_fps_lmg_shuno_b_heat_long.stats.spread = 0
	self.parts.wpn_fps_lmg_shuno_b_heat_long.stats.recoil = 1
	self.parts.wpn_fps_lmg_shuno_b_heat_long.stats.concealment = -1

	self.parts.wpn_fps_lmg_shuno_b_heat_short.stats.spread = -1
	self.parts.wpn_fps_lmg_shuno_b_heat_short.stats.recoil = 0
	self.parts.wpn_fps_lmg_shuno_b_heat_short.stats.concealment = 1

	self.parts.wpn_fps_lmg_shuno_b_short.stats.spread = -2
	self.parts.wpn_fps_lmg_shuno_b_short.stats.recoil = 0
	self.parts.wpn_fps_lmg_shuno_b_short.stats.concealment = 2

	self.parts.wpn_fps_hailstorm_b_extended.stats.damage = 0
	self.parts.wpn_fps_hailstorm_b_extended.stats.spread = 1
	self.parts.wpn_fps_hailstorm_b_extended.stats.recoil = 1
	self.parts.wpn_fps_hailstorm_b_extended.stats.concealment = -2

	self.parts.wpn_fps_hailstorm_b_suppressed.stats.damage = -2
	self.parts.wpn_fps_hailstorm_b_suppressed.stats.spread = 0
	self.parts.wpn_fps_hailstorm_b_suppressed.stats.recoil = 0
	self.parts.wpn_fps_hailstorm_b_suppressed.stats.concealment = -2

	self.parts.wpn_fps_hailstorm_b_ext_suppressed.stats.damage = -1
	self.parts.wpn_fps_hailstorm_b_ext_suppressed.stats.spread = 1
	self.parts.wpn_fps_hailstorm_b_ext_suppressed.stats.recoil = 1
	self.parts.wpn_fps_hailstorm_b_ext_suppressed.stats.concealment = -3

	self.parts.wpn_fps_hailstorm_conversion.stats.total_ammo_mod = 0
	self.parts.wpn_fps_hailstorm_conversion.stats.spread = 2
	self.parts.wpn_fps_hailstorm_conversion.stats.recoil = 2
	self.parts.wpn_fps_hailstorm_conversion.stats.concealment = 0
	self.parts.wpn_fps_hailstorm_conversion.custom_stats = { fire_rate_multiplier = 1500 / 2000 }

	-- Conversion kits and various barrels, family based modifications --

	local dmr_stance_muls = {
		spread = {
			standing = {
				hipfire = 1.5,
				crouching = 0.8,
				steelsight = 0.4,
			},
			moving = {
				hipfire = 2,
				crouching = 1,
				steelsight = 1.5,
			},
		},
		recoil = {
			standing = {
				hipfire = 1.3,
				crouching = 1,
				steelsight = 1,
			},
			moving = {
				hipfire = 1.5,
				crouching = 1,
				steelsight = 1.3,
			},
		},
	}
	local dmr_fire_mode_muls = {
		auto = {},
	}

	local conversion_kit_stats = {
		low_dmr_to_high_dmr = {
			custom_stats = { ammo_pickup_min_mul = 0.75, ammo_pickup_max_mul = 0.75 },
			stats = { value = 1, total_ammo_mod = -5, concealment = -3, spread = 2, recoil = -4, damage = 16 },
		},
		high_dmg = {
			custom_stats = {
				steelsight_speed_mul = 0.75,
				steelsight_move_speed_mul = 0.5,
				ammo_pickup_min_mul = 0.4,
				ammo_pickup_max_mul = 0.4,
				stance_mul = dmr_stance_muls,
				fire_mode_mul = dmr_fire_mode_muls,
			},
			stats = { value = 1, total_ammo_mod = -10, concealment = -6, spread = 4, recoil = -8, damage = 36, suppression = -10, alert_size = 1 },
		},
		low_dmg = {
			custom_stats = {
				steelsight_speed_mul = 0.75,
				steelsight_move_speed_mul = 0.5,
				ammo_pickup_min_mul = 0.4,
				ammo_pickup_max_mul = 0.4,
				stance_mul = dmr_stance_muls,
				fire_mode_mul = dmr_fire_mode_muls,
			},
			stats = { value = 1, total_ammo_mod = -12, concealment = -6, spread = 4, recoil = -11, damage = 24, suppression = -10, alert_size = 1 },
		},
	}

	-- ak family
	self.parts.wpn_fps_upg_ass_ak_b_zastava.custom_stats = conversion_kit_stats.high_dmg.custom_stats
	self.parts.wpn_fps_upg_ass_ak_b_zastava.stats = conversion_kit_stats.high_dmg.stats
	self.parts.wpn_fps_upg_ass_ak_b_zastava.has_description = true
	self.parts.wpn_fps_upg_ass_ak_b_zastava.desc_id = "bm_wp_dmr_kit_penetration_desc"

	self.wpn_fps_ass_74.override.wpn_fps_upg_ass_ak_b_zastava.custom_stats = conversion_kit_stats.low_dmg.custom_stats
	self.wpn_fps_ass_74.override.wpn_fps_upg_ass_ak_b_zastava.stats = conversion_kit_stats.low_dmg.stats

	-- car family
	self.parts.wpn_fps_upg_ass_m4_b_beowulf.custom_stats = conversion_kit_stats.low_dmg.custom_stats
	self.parts.wpn_fps_upg_ass_m4_b_beowulf.stats = conversion_kit_stats.low_dmg.stats
	self.parts.wpn_fps_upg_ass_m4_b_beowulf.has_description = true
	self.parts.wpn_fps_upg_ass_m4_b_beowulf.desc_id = "bm_wp_dmr_kit_penetration_desc"

	self.wpn_fps_ass_m16.override.wpn_fps_upg_ass_m4_b_beowulf.custom_stats = conversion_kit_stats.high_dmg.custom_stats
	self.wpn_fps_ass_m16.override.wpn_fps_upg_ass_m4_b_beowulf.stats = conversion_kit_stats.high_dmg.stats

	-- gewehr
	self.parts.wpn_fps_ass_g3_b_sniper.custom_stats = conversion_kit_stats.low_dmr_to_high_dmr.custom_stats
	self.parts.wpn_fps_ass_g3_b_sniper.stats = conversion_kit_stats.low_dmr_to_high_dmr.stats
	self.parts.wpn_fps_ass_g3_b_sniper.has_description = true
	self.parts.wpn_fps_ass_g3_b_sniper.desc_id = "bm_wp_dmr_kit_penetration_desc"
	self.parts.wpn_fps_ass_g3_b_sniper.adds = {} -- wtf is this, why do you need a separate dummy mod for ammo pickup specifically

	self.parts.wpn_fps_ass_g3_b_short.custom_stats = {}
	self.parts.wpn_fps_ass_g3_b_short.stats = { spread = -2, concealment = 2 }

	-- falcon
	self.parts.wpn_fps_ass_fal_fg_04.custom_stats = conversion_kit_stats.low_dmr_to_high_dmr.custom_stats
	self.parts.wpn_fps_ass_fal_fg_04.stats = conversion_kit_stats.low_dmr_to_high_dmr.stats
	self.parts.wpn_fps_ass_fal_fg_04.has_description = true
	self.parts.wpn_fps_ass_fal_fg_04.desc_id = "bm_wp_dmr_kit_penetration_desc"

	-- ks12
	self.parts.wpn_fps_ass_shak12_body_vks.custom_stats = conversion_kit_stats.low_dmr_to_high_dmr.custom_stats
	self.parts.wpn_fps_ass_shak12_body_vks.stats = conversion_kit_stats.low_dmr_to_high_dmr.stats
	self.parts.wpn_fps_ass_shak12_body_vks.has_description = true
	self.parts.wpn_fps_ass_shak12_body_vks.desc_id = "bm_wp_dmr_kit_penetration_desc"

	-- broomstick
	self.parts.wpn_fps_pis_c96_b_long.custom_stats = conversion_kit_stats.high_dmg.custom_stats
	self.parts.wpn_fps_pis_c96_b_long.stats = { value = 1, total_ammo_mod = -5, concealment = -6, spread = 2, recoil = -3, damage = 18, suppression = -5, alert_size = 4 }
	self.parts.wpn_fps_pis_c96_b_long.has_description = true
	self.parts.wpn_fps_pis_c96_b_long.desc_id = "bm_wp_dmr_kit_penetration_desc"

	-- Firemodes
	self.parts.wpn_fps_upg_i_singlefire.stats = { spread = 1, recoil = -1, value = 1 }
	self.parts.wpn_fps_upg_i_autofire.stats = { spread = -1, recoil = 1, value = 1 }

	-- Saw mods

	self.parts.wpn_fps_saw_body_silent.stats.suppression = 10
	self.parts.wpn_fps_saw_body_silent.stats.alert_size = -9

	self.parts.wpn_fps_saw_body_speed.stats.damage = 0
	self.parts.wpn_fps_saw_body_speed.stats.concealment = -2
	self.parts.wpn_fps_saw_body_speed.custom_stats = { fire_rate_multiplier = 1.5 }

	-- Flamethrower Tanks
	self.parts.wpn_fps_fla_mk2_a_rare = {
		type = "ammo",
		a_obj = "a_body",
		internal_part = true,
		unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
		third_unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
		name_id = "bm_wp_fla_mk2_a_rare",
		pcs = {},
		stats = {
			value = 0,
		},
		custom_stats = {
			bullet_class = "FlameBulletBase",
			dot_data_name = "ammo_flamethrower_mk2_rare",
		},
	}

	self.parts.wpn_fps_fla_mk2_a_welldone = {
		type = "ammo",
		a_obj = "a_body",
		internal_part = true,
		unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
		third_unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
		name_id = "bm_wp_fla_mk2_a_welldone",
		pcs = {},
		stats = {
			value = 0,
		},
		custom_stats = {
			bullet_class = "FlameBulletBase",
			dot_data_name = "ammo_flamethrower_mk2_welldone",
		},
	}

	self.parts.wpn_fps_fla_mk2_mag_rare.stats = { value = 1, damage = -4, extra_ammo = 50, total_ammo_mod = 5 }
	self.parts.wpn_fps_fla_mk2_mag_rare.adds = { "wpn_fps_fla_mk2_a_rare" }
	self.parts.wpn_fps_fla_mk2_mag_rare.custom_stats = {}
	self.parts.wpn_fps_fla_mk2_mag_rare.has_description = true
	self.parts.wpn_fps_fla_mk2_mag_rare.desc_id = "bm_wp_fla_mk2_mag_rare_desc"

	self.parts.wpn_fps_fla_mk2_mag_welldone.stats = { value = 1, damage = 4, extra_ammo = -50, total_ammo_mod = -5 }
	self.parts.wpn_fps_fla_mk2_mag_welldone.adds = { "wpn_fps_fla_mk2_a_welldone" }
	self.parts.wpn_fps_fla_mk2_mag_welldone.custom_stats = {}
	self.parts.wpn_fps_fla_mk2_mag_welldone.has_description = true
	self.parts.wpn_fps_fla_mk2_mag_welldone.desc_id = "bm_wp_fla_mk2_mag_welldone_desc"

	self.parts.wpn_fps_fla_system_b_wtf.stats.total_ammo_mod = 0
	self.parts.wpn_fps_fla_system_b_wtf.stats.concealment = 0

	self.parts.wpn_fps_fla_system_a_low = {
		type = "ammo",
		a_obj = "a_body",
		internal_part = true,
		unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
		third_unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
		name_id = "bm_wp_system_a_low",
		pcs = {},
		stats = {
			value = 0,
		},
		custom_stats = {
			bullet_class = "FlameBulletBase",
			dot_data_name = "ammo_system_low",
		},
	}

	self.parts.wpn_fps_fla_system_a_high = {
		type = "ammo",
		a_obj = "a_body",
		internal_part = true,
		unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
		third_unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
		name_id = "bm_wp_system_a_high",
		pcs = {},
		stats = {
			value = 0,
		},
		custom_stats = {
			bullet_class = "FlameBulletBase",
			dot_data_name = "ammo_system_high",
		},
	}

	self.parts.wpn_fps_fla_system_m_low.stats = { value = 1, damage = -4, extra_ammo = 25, total_ammo_mod = 5 }
	self.parts.wpn_fps_fla_system_m_low.adds = { "wpn_fps_fla_system_a_low" }
	self.parts.wpn_fps_fla_system_m_low.custom_stats = {}
	self.parts.wpn_fps_fla_system_m_low.has_description = true
	self.parts.wpn_fps_fla_system_m_low.desc_id = "bm_wp_fla_mk2_mag_rare_desc"

	self.parts.wpn_fps_fla_system_m_high.stats = { value = 1, damage = 4, extra_ammo = -25, total_ammo_mod = -5 }
	self.parts.wpn_fps_fla_system_m_high.adds = { "wpn_fps_fla_system_a_high" }
	self.parts.wpn_fps_fla_system_m_high.custom_stats = {}
	self.parts.wpn_fps_fla_system_m_high.has_description = true
	self.parts.wpn_fps_fla_system_m_high.desc_id = "bm_wp_fla_mk2_mag_welldone_desc"

	-- Barrel Extensions, Silencers --

	-- Generic Extensions and Silencers
	local barrel_ext_stats = {
		balanced = { value = 1, recoil = 1, spread = 1, concealment = -2 },
		spread_favored = { value = 1, spread = 2, concealment = -2 },
		recoil_favored = { value = 1, recoil = 2, concealment = -2 },
		spread_heavily_favored = { value = 1, recoil = -1, spread = 3, concealment = -2 },
		recoil_heavily_favored = { value = 1, recoil = 3, spread = -1, concealment = -2 },
		small_silencer = { value = 1, damage = -3, concealment = -1 },
		medium_silencer = { value = 1, damage = -2, spread = 1, concealment = -2 },
		big_silencer = { value = 1, damage = -1, recoil = 1, spread = 1, concealment = -3 },
		massive_silencer = { value = 1, recoil = 2, spread = 1, concealment = -5 },
	}

	-- Stubby
	self.parts.wpn_fps_upg_ns_ass_smg_stubby.stats = barrel_ext_stats.recoil_favored
	-- Tank
	self.parts.wpn_fps_upg_ns_ass_smg_tank.stats = barrel_ext_stats.spread_favored
	-- Fire Breather
	self.parts.wpn_fps_upg_ns_ass_smg_firepig.stats = barrel_ext_stats.balanced
	-- Competitor's
	self.parts.wpn_fps_upg_ass_ns_jprifles.stats = barrel_ext_stats.recoil_heavily_favored
	-- Bootleg
	self.parts.wpn_fps_ass_tecci_ns_special.stats = barrel_ext_stats.recoil_heavily_favored
	-- Tactical
	self.parts.wpn_fps_upg_ass_ns_surefire.stats = barrel_ext_stats.spread_heavily_favored
	-- Funnel of Fun
	self.parts.wpn_fps_upg_ass_ns_linear.stats = barrel_ext_stats.recoil_favored
	-- Ported
	self.parts.wpn_fps_upg_ass_ns_battle.stats = barrel_ext_stats.spread_favored
	-- Marmon
	self.parts.wpn_fps_upg_ns_ass_smg_v6.stats = barrel_ext_stats.balanced
	-- Verdunkeln
	self.parts.wpn_fps_lmg_hk51b_ns_jcomp.stats = barrel_ext_stats.balanced
	--Taktika
	self.parts.wpn_fps_upg_ak_ns_zenitco.stats = barrel_ext_stats.spread_favored
	--Fyodor
	self.parts.wpn_fps_upg_ak_ns_jmac.stats = barrel_ext_stats.recoil_favored
	-- KS-12 A-Burst
	self.parts.wpn_fps_ass_shak12_ns_muzzle.stats = barrel_ext_stats.recoil_heavily_favored
	-- Dourif
	self.parts.wpn_fps_lmg_kacchainsaw_ns_muzzle.stats = barrel_ext_stats.spread_heavily_favored
	-- Low Profile
	self.parts.wpn_fps_upg_ns_ass_smg_small.stats = barrel_ext_stats.small_silencer
	-- Medium
	self.parts.wpn_fps_upg_ns_ass_smg_medium.stats = barrel_ext_stats.medium_silencer
	-- The Bigger The Better
	self.parts.wpn_fps_upg_ns_ass_smg_large.stats = barrel_ext_stats.big_silencer
	-- PBS
	self.parts.wpn_fps_upg_ns_ass_pbs1.stats = barrel_ext_stats.big_silencer
	-- Rami
	self.parts.wpn_fps_lmg_kacchainsaw_ns_suppressor.stats = barrel_ext_stats.medium_silencer
	-- KS-12 Suppressor (to be restricted from all but ks12)
	self.parts.wpn_fps_ass_shak12_ns_suppressor.stats = barrel_ext_stats.massive_silencer
	-- Federation
	self.parts.wpn_fps_upg_ak_ns_tgp.stats = barrel_ext_stats.medium_silencer

	-- Weapon exclusive suppressors
	-- Spec Ops
	self.parts.wpn_fps_smg_mp7_b_suppressed.stats = barrel_ext_stats.big_silencer

	-- Generic Shotgun Extensions and Silencers
	local shotgun_barrel_ext_stats = {
		medium_loud = { spread = 2, concealment = -2 },
		big_loud = { spread = 3, concealment = -3 },
		horizontal_loud = { spread = -2, recoil = 1, spread_multi = { 1.5, 0.5 }, concealment = -3 },
		medium_silencer = { value = 1, damage = -2, spread = 1, concealment = -2 },
		big_silencer = { value = 1, damage = -1, recoil = 1, spread = 1, concealment = -3 },
	}

	-- Shark Teeth
	self.parts.wpn_fps_upg_ns_shot_shark.stats = shotgun_barrel_ext_stats.medium_loud
	-- King's Crown
	self.parts.wpn_fps_upg_shot_ns_king.stats = shotgun_barrel_ext_stats.big_loud
	-- Donald's Horizontal
	self.parts.wpn_fps_upg_ns_duck.stats = shotgun_barrel_ext_stats.horizontal_loud
	-- Silent Killer
	self.parts.wpn_fps_upg_ns_shot_thick.stats = shotgun_barrel_ext_stats.medium_silencer
	-- Shh
	self.parts.wpn_fps_upg_ns_sho_salvo_large.stats = shotgun_barrel_ext_stats.big_silencer

	-- Generic Pistol Extensions and Silencers
	local pistol_barrel_ext_stats = {
		balanced = { value = 1, recoil = 1, spread = 1, concealment = -2 },
		spread_favored = { value = 1, spread = 2, concealment = -2 },
		recoil_favored = { value = 1, recoil = 2, concealment = -2 },
		spread_heavily_favored = { value = 1, recoil = -1, spread = 3, concealment = -2 },
		recoil_heavily_favored = { value = 1, recoil = 3, spread = -1, concealment = -2 },
		small_silencer = { value = 1, damage = -3, concealment = -1 },
		medium_silencer = { value = 1, damage = -2, spread = 1, concealment = -2 },
		big_silencer = { value = 1, damage = -1, recoil = 1, spread = 1, concealment = -3 },
		massive_silencer = { value = 1, recoil = 3, spread = 1, concealment = -4 },
	}

	-- Flash Hider
	self.parts.wpn_fps_upg_pis_ns_flash.stats = pistol_barrel_ext_stats.balanced
	-- IPSC
	self.parts.wpn_fps_upg_ns_pis_ipsccomp.stats = pistol_barrel_ext_stats.spread_favored
	-- Facepunch
	self.parts.wpn_fps_upg_ns_pis_meatgrinder.stats = pistol_barrel_ext_stats.recoil_favored
	-- Hurricane
	self.parts.wpn_fps_upg_ns_pis_typhoon.stats = pistol_barrel_ext_stats.balanced
	-- Standard Issue
	self.parts.wpn_fps_upg_ns_pis_medium.stats = pistol_barrel_ext_stats.medium_silencer
	-- Medved R4
	self.parts.wpn_fps_upg_ns_pis_putnik.stats = pistol_barrel_ext_stats.medium_silencer
	-- Size Doesn't Matter
	self.parts.wpn_fps_upg_ns_pis_small.stats = pistol_barrel_ext_stats.small_silencer
	-- Monolith
	self.parts.wpn_fps_upg_ns_pis_large.stats = pistol_barrel_ext_stats.big_silencer
	-- Asepsis
	self.parts.wpn_fps_upg_ns_pis_medium_slim.stats = pistol_barrel_ext_stats.medium_silencer
	-- Budget
	self.parts.wpn_fps_upg_ns_ass_filter.stats = { value = 1, recoil = -1, spread = -2, concealment = -2, damage = -3 }
	-- Jungle Ninja
	self.parts.wpn_fps_upg_ns_pis_jungle.stats = pistol_barrel_ext_stats.massive_silencer
	-- Roctec
	self.parts.wpn_fps_upg_ns_pis_medium_gem.stats = pistol_barrel_ext_stats.medium_silencer

	-- Weapon-specific extensions
	self.parts.wpn_fps_pis_g18c_co_1.stats = pistol_barrel_ext_stats.recoil_heavily_favored
	self.parts.wpn_fps_pis_g18c_co_comp_2.stats = pistol_barrel_ext_stats.spread_heavily_favored

	self.parts.wpn_fps_pis_1911_co_1.stats = pistol_barrel_ext_stats.recoil_heavily_favored
	self.parts.wpn_fps_pis_1911_co_2.stats = pistol_barrel_ext_stats.spread_heavily_favored

	self.parts.wpn_fps_pis_p226_co_comp_1.stats = pistol_barrel_ext_stats.recoil_heavily_favored
	self.parts.wpn_fps_pis_p226_co_comp_2.stats = pistol_barrel_ext_stats.spread_heavily_favored

	-- set suppression and alert size for all suppressors
	for id, part in pairs(self.parts) do
		local is_silencer = part.perks and table.contains(part.perks, "silencer")

		if part.stats and is_silencer then
			part.stats.suppression = 10
			part.stats.alert_size = -12
		end
	end
	-- misc

	-- let the Amcar use more CAR family mods
	table.insert(self.wpn_fps_ass_amcar.uses_parts, "wpn_fps_upg_ass_m4_upper_reciever_ballos")
	table.insert(self.wpn_fps_ass_amcar.uses_parts, "wpn_fps_upg_ass_m4_upper_reciever_core")
	table.insert(self.wpn_fps_ass_amcar.uses_parts, "wpn_fps_m4_upper_reciever_edge")
	--table.insert(self.wpn_fps_ass_amcar.uses_parts, "wpn_fps_upg_ass_m4_b_beowulf")
	table.insert(self.wpn_fps_ass_amcar.uses_parts, "wpn_fps_m4_uupg_b_long")
	table.insert(self.wpn_fps_ass_amcar.uses_parts, "wpn_fps_upg_m4_s_pts")
	table.insert(self.wpn_fps_ass_amcar.uses_parts, "wpn_fps_upg_ass_m4_lower_reciever_core")
	--table.insert(self.wpn_fps_ass_amcar.uses_parts, "wpn_fps_smg_olympic_s_short")

	self.parts.wpn_fps_m4_uupg_upper_radian.override.wpn_fps_amcar_uupg_body_upperreciever = {
		unit = "units/payday2/weapons/wpn_fps_ass_m16_pts/wpn_fps_ass_m16_o_handle_sight",
		third_unit = "units/payday2/weapons/wpn_third_ass_m16_pts/wpn_third_ass_m16_o_handle_sight",
		a_obj = "a_o",
	}
	self.parts.wpn_fps_upg_ass_m4_upper_reciever_ballos.override.wpn_fps_amcar_uupg_body_upperreciever = {
		adds = { "wpn_fps_m4_uupg_draghandle_ballos", "wpn_fps_ass_m16_os_frontsight" },
		unit = "units/payday2/weapons/wpn_fps_ass_m16_pts/wpn_fps_ass_m16_o_handle_sight",
		third_unit = "units/payday2/weapons/wpn_third_ass_m16_pts/wpn_third_ass_m16_o_handle_sight",
		a_obj = "a_o",
	}
	self.parts.wpn_fps_upg_ass_m4_upper_reciever_core.override.wpn_fps_amcar_uupg_body_upperreciever = {
		adds = { "wpn_fps_m4_uupg_draghandle_core", "wpn_fps_ass_m16_os_frontsight" },
		unit = "units/payday2/weapons/wpn_fps_ass_m16_pts/wpn_fps_ass_m16_o_handle_sight",
		third_unit = "units/payday2/weapons/wpn_third_ass_m16_pts/wpn_third_ass_m16_o_handle_sight",
		a_obj = "a_o",
	}
	self.parts.wpn_fps_m4_upper_reciever_edge.override.wpn_fps_amcar_uupg_body_upperreciever = {
		adds = { "wpn_fps_m4_uupg_draghandle", "wpn_fps_ass_m16_os_frontsight" },
		unit = "units/payday2/weapons/wpn_fps_ass_m16_pts/wpn_fps_ass_m16_o_handle_sight",
		third_unit = "units/payday2/weapons/wpn_third_ass_m16_pts/wpn_third_ass_m16_o_handle_sight",
		a_obj = "a_o",
	}

	table.delete(self.wpn_fps_pis_g26.uses_parts, "wpn_fps_pis_g18c_m_mag_33rnd")
	table.delete(self.wpn_fps_jowi.uses_parts, "wpn_fps_pis_g18c_m_mag_33rnd")
	table.insert(self.wpn_fps_pis_g26.uses_parts, "wpn_fps_pis_g26_m_mag_33rnd")
	table.insert(self.wpn_fps_jowi.uses_parts, "wpn_fps_pis_g26_m_mag_33rnd")

	table.delete(self.wpn_fps_ass_contraband.uses_parts, "wpn_fps_sho_sko12_body_grip")
	table.delete(self.wpn_fps_ass_m16.uses_parts, "wpn_fps_uupg_fg_radian")

	table.delete(self.wpn_fps_sho_sko12.uses_parts, "wpn_fps_upg_i_singlefire")
	table.delete(self.wpn_fps_sho_sko12.uses_parts, "wpn_fps_upg_i_autofire")

	table.delete(self.wpn_fps_gre_ms3gl.uses_parts, "wpn_fps_gre_ms3gl_conversion")
	table.insert(self.parts.wpn_fps_smg_fmg9_conversion.forbids, "wpn_fps_lmg_hk51b_ns_jcomp")
end)

-- Automatically balance Shotgun ammo types
function WeaponFactoryTweakData:_balance_shotgun_ammo(tweak_data)
	local slug_stance_muls = {
		spread = {
			standing = {
				hipfire = 1.2,
				crouching = 1,
				steelsight = 0.6,
			},
			moving = {
				hipfire = 1.6,
				crouching = 1,
				steelsight = 1,
			},
		},
		recoil = {
			standing = {
				hipfire = 1.2,
				crouching = 1,
				steelsight = 1,
			},
			moving = {
				hipfire = 1.6,
				crouching = 1,
				steelsight = 1.2,
			},
		},
	}

	local shotgun_ammo_overrides = {
		wpn_fps_upg_a_custom = {
			very_heavy = { -- double barrels
				stats = { damage = 10, total_ammo_mod = -4, recoil = -3 },
				custom_stats = { rays = 6, ammo_pickup_max_mul = 0.8, ammo_pickup_min_mul = 0.8 },
			},
			heavy = { -- shotguns like gsps and the trench gun
				stats = { damage = 9, total_ammo_mod = -4, recoil = -3 },
				custom_stats = { rays = 6, ammo_pickup_max_mul = 0.8, ammo_pickup_min_mul = 0.8 },
			},
			medium = { -- raven, loco, reinfeld, etc
				stats = { damage = 8, total_ammo_mod = -4, recoil = -3 },
				custom_stats = { rays = 6, ammo_pickup_max_mul = 0.8, ammo_pickup_min_mul = 0.8 },
			},
			light = { -- semi autos
				stats = { damage = 6, total_ammo_mod = -4, recoil = -3 },
				custom_stats = { rays = 6, ammo_pickup_max_mul = 0.8, ammo_pickup_min_mul = 0.8 },
			},
			very_light = { -- full autos
				stats = { damage = 6, total_ammo_mod = -4, recoil = -3 },
				custom_stats = { rays = 6, ammo_pickup_max_mul = 0.8, ammo_pickup_min_mul = 0.8 },
			},
		},
		wpn_fps_upg_a_custom_free = {
			very_heavy = { -- double barrels
				stats = { damage = 10, total_ammo_mod = -4, recoil = -3 },
				custom_stats = { rays = 6, ammo_pickup_max_mul = 0.8, ammo_pickup_min_mul = 0.8 },
			},
			heavy = { -- shotguns like gsps and the trench gun
				stats = { damage = 9, total_ammo_mod = -4, recoil = -3 },
				custom_stats = { rays = 6, ammo_pickup_max_mul = 0.8, ammo_pickup_min_mul = 0.8 },
			},
			medium = { -- raven, loco, reinfeld, etc
				stats = { damage = 8, total_ammo_mod = -4, recoil = -3 },
				custom_stats = { rays = 6, ammo_pickup_max_mul = 0.8, ammo_pickup_min_mul = 0.8 },
			},
			light = { -- semi autos
				stats = { damage = 6, total_ammo_mod = -4, recoil = -3 },
				custom_stats = { rays = 6, ammo_pickup_max_mul = 0.8, ammo_pickup_min_mul = 0.8 },
			},
			very_light = { -- full autos
				stats = { damage = 6, total_ammo_mod = -4, recoil = -3 },
				custom_stats = { rays = 6, ammo_pickup_max_mul = 0.8, ammo_pickup_min_mul = 0.8 },
			},
		},
		wpn_fps_upg_a_explosive = {
			very_heavy = { -- double barrels
				stats = { damage = 180, total_ammo_mod = -9, spread = 2, spread_multi = { 2 / 3, 2 / 3 } },
				custom_stats = {
					ignore_statistic = true,
					explosive_ammo = true,
					ammo_pickup_max_mul = 0.4,
					ammo_pickup_min_mul = 0.4,
					stance_mul = slug_stance_muls,
					bullet_class = "InstantExplosiveBulletBase",
					damage_near_mul = 3,
					damage_far_mul = 2,
					rays = 1,
				},
			},
			heavy = { -- shotguns like gsps and the trench gun
				stats = { damage = 162, total_ammo_mod = -9, spread = 2, spread_multi = { 2 / 3, 2 / 3 } },
				custom_stats = {
					ignore_statistic = true,
					explosive_ammo = true,
					ammo_pickup_max_mul = 0.4,
					ammo_pickup_min_mul = 0.4,
					stance_mul = slug_stance_muls,
					bullet_class = "InstantExplosiveBulletBase",
					damage_near_mul = 3,
					damage_far_mul = 2,
					rays = 1,
				},
			},
			medium = { -- raven, loco, reinfeld, etc
				stats = { damage = 144, total_ammo_mod = -9, spread = 2, spread_multi = { 2 / 3, 2 / 3 } },
				custom_stats = {
					ignore_statistic = true,
					explosive_ammo = true,
					ammo_pickup_max_mul = 0.4,
					ammo_pickup_min_mul = 0.4,
					stance_mul = slug_stance_muls,
					bullet_class = "InstantExplosiveBulletBase",
					damage_near_mul = 3,
					damage_far_mul = 2,
					rays = 1,
				},
			},
			light = { -- semi autos
				stats = { damage = 108, total_ammo_mod = -9, spread = 2, spread_multi = { 2 / 3, 2 / 3 } },
				custom_stats = {
					ignore_statistic = true,
					explosive_ammo = true,
					ammo_pickup_max_mul = 0.4,
					ammo_pickup_min_mul = 0.4,
					stance_mul = slug_stance_muls,
					bullet_class = "InstantExplosiveBulletBase",
					damage_near_mul = 3,
					damage_far_mul = 2,
					rays = 1,
				},
			},
			very_light = { -- full autos
				stats = { damage = 90, total_ammo_mod = -9, spread = 1, spread_multi = { 2 / 3, 2 / 3 } },
				custom_stats = {
					ignore_statistic = true,
					explosive_ammo = true,
					ammo_pickup_max_mul = 0.4,
					ammo_pickup_min_mul = 0.4,
					stance_mul = slug_stance_muls,
					bullet_class = "InstantExplosiveBulletBase",
					damage_near_mul = 3,
					damage_far_mul = 2,
					rays = 1,
				},
			},
		},
		wpn_fps_upg_a_slug = {
			very_heavy = { -- double barrels
				stats = { damage = 88, total_ammo_mod = -4, recoil = -2, spread = 3, spread_multi = { 2 / 3, 2 / 3 } },
				custom_stats = {
					armor_piercing_add = 1,
					can_shoot_through_shield = true,
					can_shoot_through_wall = true,
					can_shoot_through_enemy = true,
					stance_mul = slug_stance_muls,
					damage_near_mul = 3,
					damage_far_mul = 2,
					rays = 1,
					check_additional_achievements = true,
				},
			},
			heavy = { -- shotguns like gsps and the trench gun
				stats = { damage = 78, total_ammo_mod = -4, recoil = -2, spread = 3, spread_multi = { 2 / 3, 2 / 3 } },
				custom_stats = {
					armor_piercing_add = 1,
					can_shoot_through_shield = true,
					can_shoot_through_wall = true,
					can_shoot_through_enemy = true,
					stance_mul = slug_stance_muls,
					damage_near_mul = 3,
					damage_far_mul = 2,
					rays = 1,
					check_additional_achievements = true,
				},
			},
			medium = { -- raven, loco, reinfeld, etc
				stats = { damage = 64, total_ammo_mod = -4, recoil = -2, spread = 3, spread_multi = { 2 / 3, 2 / 3 } },
				custom_stats = {
					armor_piercing_add = 1,
					can_shoot_through_shield = true,
					can_shoot_through_wall = true,
					can_shoot_through_enemy = true,
					stance_mul = slug_stance_muls,
					damage_near_mul = 3,
					damage_far_mul = 2,
					rays = 1,
					check_additional_achievements = true,
				},
			},
			light = { -- semi autos
				stats = { damage = 52, total_ammo_mod = -4, recoil = -2, spread = 3, spread_multi = { 2 / 3, 2 / 3 } },
				custom_stats = {
					armor_piercing_add = 1,
					can_shoot_through_shield = true,
					can_shoot_through_wall = true,
					can_shoot_through_enemy = true,
					stance_mul = slug_stance_muls,
					damage_near_mul = 3,
					damage_far_mul = 2,
					rays = 1,
					check_additional_achievements = true,
				},
			},
			very_light = { -- full autos
				stats = { damage = 38, total_ammo_mod = -4, recoil = -2, spread = 3, spread_multi = { 2 / 3, 2 / 3 } },
				custom_stats = {
					armor_piercing_add = 1,
					can_shoot_through_shield = true,
					can_shoot_through_wall = true,
					can_shoot_through_enemy = true,
					stance_mul = slug_stance_muls,
					damage_near_mul = 3,
					damage_far_mul = 2,
					rays = 1,
					check_additional_achievements = true,
				},
			},
		},
		wpn_fps_upg_a_piercing = {
			very_heavy = { -- double barrels
				stats = { damage = -9, total_ammo_mod = -2, spread = 2 },
				custom_stats = {
					rays = 12,
					armor_piercing_add = 1,
					can_shoot_through_enemy = true,
				},
			},
			heavy = { -- shotguns like gsps and the trench gun
				stats = { damage = -8, total_ammo_mod = -2, spread = 2 },
				custom_stats = {
					rays = 12,
					armor_piercing_add = 1,
					can_shoot_through_enemy = true,
				},
			},
			medium = { -- raven, loco, reinfeld, etc
				stats = { damage = -7, total_ammo_mod = -2, spread = 2 },
				custom_stats = {
					rays = 12,
					armor_piercing_add = 1,
					can_shoot_through_enemy = true,
				},
			},
			light = { -- semi autos
				stats = { damage = -5, total_ammo_mod = -2, spread = 2 },
				custom_stats = {
					rays = 12,
					armor_piercing_add = 1,
					can_shoot_through_enemy = true,
				},
			},
			very_light = { -- full autos
				stats = { damage = -4, total_ammo_mod = -2, spread = 2 },
				custom_stats = {
					rays = 12,
					armor_piercing_add = 1,
					can_shoot_through_enemy = true,
				},
			},
		},
		wpn_fps_upg_a_dragons_breath = {
			very_heavy = { -- double barrels
				stats = { damage = -10, total_ammo_mod = -7, spread = -2 },
				custom_stats = {
					ammo_pickup_min_mul = 0.6,
					ammo_pickup_max_mul = 0.6,
					armor_piercing_add = 1,
					rays = 12,
					dot_data_name = "ammo_dragons_breath_heavy",
					bullet_class = "FlameBulletBase",
					muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_dragons_breath",
				},
			},
			heavy = { -- shotguns like gsps and the trench gun
				stats = { damage = -9, total_ammo_mod = -7, spread = -2 },
				custom_stats = {
					ammo_pickup_min_mul = 0.6,
					ammo_pickup_max_mul = 0.6,
					armor_piercing_add = 1,
					rays = 12,
					dot_data_name = "ammo_dragons_breath_heavy",
					bullet_class = "FlameBulletBase",
					muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_dragons_breath",
				},
			},
			medium = { -- raven, loco, reinfeld, etc
				stats = { damage = -8, total_ammo_mod = -7, spread = -2 },
				custom_stats = {
					ammo_pickup_min_mul = 0.6,
					ammo_pickup_max_mul = 0.6,
					armor_piercing_add = 1,
					rays = 12,
					dot_data_name = "ammo_dragons_breath_medium",
					bullet_class = "FlameBulletBase",
					muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_dragons_breath",
				},
			},
			light = { -- semi autos
				stats = { damage = -6, total_ammo_mod = -7, spread = -2 },
				custom_stats = {
					ammo_pickup_min_mul = 0.6,
					ammo_pickup_max_mul = 0.6,
					armor_piercing_add = 1,
					rays = 12,
					dot_data_name = "ammo_dragons_breath_light",
					bullet_class = "FlameBulletBase",
					muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_dragons_breath",
				},
			},
			very_light = { -- full autos
				stats = { damage = -5, total_ammo_mod = -7, spread = -2 },
				custom_stats = {
					ammo_pickup_min_mul = 0.6,
					ammo_pickup_max_mul = 0.6,
					armor_piercing_add = 1,
					rays = 12,
					dot_data_name = "ammo_dragons_breath_light",
					bullet_class = "FlameBulletBase",
					muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_dragons_breath",
				},
			},
		},
		wpn_fps_upg_a_rip = {
			very_heavy = { -- double barrels
				stats = { damage = 60, total_ammo_mod = -9, spread = 1, spread_multi = { 2 / 3, 2 / 3 } },
				custom_stats = {
					ammo_pickup_min_mul = 0.4,
					ammo_pickup_max_mul = 0.4,
					armor_piercing_add = 1,
					muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_rip",
					dot_data_name = "ammo_rip_heavy",
					stance_mul = slug_stance_muls,
					damage_near_mul = 3,
					damage_far_mul = 2,
					rays = 1,
					bullet_class = "PoisonBulletBase",
				},
			},
			heavy = { -- shotguns like gsps and the trench gun
				stats = { damage = 54, total_ammo_mod = -9, spread = 1, spread_multi = { 2 / 3, 2 / 3 } },
				custom_stats = {
					ammo_pickup_min_mul = 0.4,
					ammo_pickup_max_mul = 0.4,
					armor_piercing_add = 1,
					muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_rip",
					dot_data_name = "ammo_rip_heavy",
					stance_mul = slug_stance_muls,
					damage_near_mul = 3,
					damage_far_mul = 2,
					rays = 1,
					bullet_class = "PoisonBulletBase",
				},
			},
			medium = { -- raven, loco, reinfeld, etc
				stats = { damage = 48, total_ammo_mod = -9, spread = 1, spread_multi = { 2 / 3, 2 / 3 } },
				custom_stats = {
					ammo_pickup_min_mul = 0.4,
					ammo_pickup_max_mul = 0.4,
					armor_piercing_add = 1,
					muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_rip",
					dot_data_name = "ammo_rip_medium",
					stance_mul = slug_stance_muls,
					damage_near_mul = 3,
					damage_far_mul = 2,
					rays = 1,
					bullet_class = "PoisonBulletBase",
				},
			},
			light = { -- semi autos
				stats = { damage = 36, total_ammo_mod = -9, spread = 1, spread_multi = { 2 / 3, 2 / 3 } },
				custom_stats = {
					ammo_pickup_min_mul = 0.4,
					ammo_pickup_max_mul = 0.4,
					armor_piercing_add = 1,
					muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_rip",
					dot_data_name = "ammo_rip_light",
					stance_mul = slug_stance_muls,
					damage_near_mul = 3,
					damage_far_mul = 2,
					rays = 1,
					bullet_class = "PoisonBulletBase",
				},
			},
			very_light = { -- full autos
				stats = { damage = 30, total_ammo_mod = -9, spread = 1, spread_multi = { 2 / 3, 2 / 3 } },
				custom_stats = {
					ammo_pickup_min_mul = 0.4,
					ammo_pickup_max_mul = 0.4,
					armor_piercing_add = 1,
					muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_rip",
					dot_data_name = "ammo_rip_light",
					stance_mul = slug_stance_muls,
					damage_near_mul = 3,
					damage_far_mul = 2,
					rays = 1,
					bullet_class = "PoisonBulletBase",
				},
			},
		},
	}

	local shotgun_ammo_override_map = {
		["wpn_fps_shot_saiga"] = "very_light",
		["wpn_fps_sho_aa12"] = "very_light",
		["wpn_fps_sho_basset"] = "very_light",
		["wpn_fps_sho_sko12"] = "very_light",
		["wpn_fps_sho_ben"] = "light",
		["wpn_fps_sho_striker"] = "light",
		["wpn_fps_sho_spas12"] = "light",
		["wpn_fps_sho_rota"] = "light",
		["wpn_fps_sho_ultima"] = "light",
		["wpn_fps_shot_r870"] = "medium",
		["wpn_fps_shot_serbu"] = "medium",
		["wpn_fps_sho_ksg"] = "medium",
		["wpn_fps_sho_m590"] = "medium",
		["wpn_fps_sho_supernova"] = "medium",
		["wpn_fps_pis_judge"] = "heavy",
		["wpn_fps_sho_boot"] = "heavy",
		["wpn_fps_shot_m37"] = "heavy",
		["wpn_fps_shot_m1897"] = "heavy",
		["wpn_fps_shot_huntsman"] = "very_heavy",
		["wpn_fps_shot_b682"] = "very_heavy",
		["wpn_fps_sho_coach"] = "very_heavy",
	}

	for id, data in pairs(tweak_data.upgrades.definitions) do
		local weapon_id = data.weapon_id
		local factory_id = data.factory_id

		local weapon_tweak = tweak_data.weapon and tweak_data.weapon[weapon_id]

		local based_on
		local based_on_weapon_id
		local based_on_factory_id
		if weapon_tweak and weapon_tweak.custom then
			based_on = weapon_tweak.based_on

			if based_on then
				based_on_weapon_id = tweak_data.upgrades.definitions[based_on].weapon_id
				based_on_factory_id = tweak_data.upgrades.definitions[based_on].factory_id
			end
		end

		for part_id, part in pairs(self.parts) do
			local ammo_override = shotgun_ammo_override_map[based_on_factory_id or factory_id] or "medium"

			if self[factory_id] then
				if not self[factory_id].override then
					self[factory_id].override = {}
				end

				if shotgun_ammo_overrides[part_id] and shotgun_ammo_overrides[part_id][ammo_override] then
					self[factory_id].override[part_id] = shotgun_ammo_overrides[part_id][ammo_override]
				end
			end
		end
	end
end

-- Automatically balance Grenade Launcher ammo types
function WeaponFactoryTweakData:_balance_launcher_ammo(tweak_data)
	local grenade_launcher_ammo_overrides = {
		wpn_fps_upg_a_grenade_launcher_incendiary = {
			heavy = {
				stats = { damage = 0 },
				custom_stats = { ammo_pickup_max_mul = 0.6, ammo_pickup_min_mul = 0.6, launcher_grenade = "launcher_incendiary" },
			},
			medium = {
				stats = { damage = 0 },
				custom_stats = { ammo_pickup_max_mul = 0.6, ammo_pickup_min_mul = 0.6, launcher_grenade = "launcher_incendiary" },
			},
			light = {
				stats = { damage = 0 },
				custom_stats = { ammo_pickup_max_mul = 0.6, ammo_pickup_min_mul = 0.6, launcher_grenade = "launcher_incendiary" },
			},
			default = {
				stats = { damage = 0 },
				custom_stats = { ammo_pickup_max_mul = 0.6, ammo_pickup_min_mul = 0.6, launcher_grenade = "launcher_incendiary" },
			},
		},
		wpn_fps_upg_a_grenade_launcher_electric = {
			heavy = {
				stats = { damage = 0 },
				custom_stats = { ammo_pickup_max_mul = 0.8, ammo_pickup_min_mul = 0.8, launcher_grenade = "launcher_electric" },
			},
			medium = {
				stats = { damage = 0 },
				custom_stats = { ammo_pickup_max_mul = 0.8, ammo_pickup_min_mul = 0.8, launcher_grenade = "launcher_electric" },
			},
			light = {
				stats = { damage = 0 },
				custom_stats = { ammo_pickup_max_mul = 0.8, ammo_pickup_min_mul = 0.8, launcher_grenade = "launcher_electric" },
			},
			default = {
				stats = { damage = 0 },
				custom_stats = { ammo_pickup_max_mul = 0.8, ammo_pickup_min_mul = 0.8, launcher_grenade = "launcher_electric" },
			},
		},
		wpn_fps_upg_a_grenade_launcher_poison = {
			heavy = {
				stats = { damage = 0 },
				custom_stats = { ammo_pickup_max_mul = 0.4, ammo_pickup_min_mul = 0.4, launcher_grenade = "launcher_poison" },
			},
			medium = {
				stats = { damage = 0 },
				custom_stats = { ammo_pickup_max_mul = 0.4, ammo_pickup_min_mul = 0.4, launcher_grenade = "launcher_poison" },
			},
			light = {
				stats = { damage = 0 },
				custom_stats = { ammo_pickup_max_mul = 0.4, ammo_pickup_min_mul = 0.4, launcher_grenade = "launcher_poison" },
			},
			default = {
				stats = { damage = 0 },
				custom_stats = { ammo_pickup_max_mul = 0.4, ammo_pickup_min_mul = 0.4, launcher_grenade = "launcher_poison" },
			},
		},
	}

	local grenade_launcher_ammo_override_map = {
		["wpn_fps_gre_arbiter"] = "light",
		["wpn_fps_gre_ms3gl"] = "light",
		["wpn_fps_gre_m32"] = "medium",
		["wpn_fps_gre_china"] = "medium",
		["wpn_fps_gre_m79"] = "heavy",
		["wpn_fps_gre_slap"] = "heavy",
		["wpn_fps_ass_contraband"] = "heavy",
		["wpn_fps_ass_groza"] = "heavy",
	}

	for id, data in pairs(tweak_data.upgrades.definitions) do
		local weapon_id = data.weapon_id
		local factory_id = data.factory_id

		local weapon_tweak = tweak_data.weapon and tweak_data.weapon[weapon_id]

		local based_on
		local based_on_weapon_id
		local based_on_factory_id
		if weapon_tweak and weapon_tweak.custom then
			based_on = weapon_tweak.based_on

			if based_on then
				based_on_weapon_id = tweak_data.upgrades.definitions[based_on].weapon_id
				based_on_factory_id = tweak_data.upgrades.definitions[based_on].factory_id
			end
		end

		for part_id, part in pairs(self.parts) do
			local ammo_override = grenade_launcher_ammo_override_map[based_on_factory_id or factory_id] or "medium"

			if self[factory_id] then
				if not self[factory_id].override then
					self[factory_id].override = {}
				end

				--[[
				if grenade_launcher_ammo_overrides[part_id] and grenade_launcher_ammo_overrides[part_id][ammo_override] then
					self[factory_id].override[part_id] = grenade_launcher_ammo_overrides[part_id][ammo_override]

					local grenade_type = self[factory_id].override[part_id].custom_stats and self[factory_id].override[part_id].custom_stats.launcher_grenade
					if grenade_type and type(grenade_type) == "string" then
						self[factory_id].override[part_id].custom_stats.launcher_grenade = grenade_type .. (based_on_weapon_id or weapon_id)
					end
				end
			]]
			end
		end
	end
end

-- Automatically balance magazine mods based on capacity
function WeaponFactoryTweakData:_balance_magazines(tweak_data)
	for id, data in pairs(tweak_data.upgrades.definitions) do
		local weapon_id = data.weapon_id
		local factory_id = data.factory_id

		local akimbo_mappings = tweak_data.weapon:get_akimbo_mappings()

		local weapon_tweak = tweak_data.weapon and tweak_data.weapon[weapon_id]
		local is_akimbo = weapon_tweak and table.contains(weapon_tweak.categories, "akimbo")

		local shotgun_reload = weapon_tweak and weapon_tweak.use_shotgun_reload or weapon_tweak and weapon_tweak.timers and weapon_tweak.timers.shotgun_reload_shell or nil
		local mag_capacity = weapon_tweak and weapon_tweak.CLIP_AMMO_MAX / (is_akimbo and 2 or 1)

		for part_id, part in pairs(self.parts) do
			if self[factory_id] and table.contains(self[factory_id].uses_parts, part_id) then
				if part.stats then
					local extra_ammo_stat = part.stats.extra_ammo
					local ammo_offset_stat = part.custom_stats and part.custom_stats.ammo_offset
					if extra_ammo_stat or ammo_offset_stat then
						if mag_capacity and not shotgun_reload then
							local reload_speed_stat
							local concealment_stat
							local mod_mag_capacity = (2 * (extra_ammo_stat or 0)) + (ammo_offset_stat or 0)
							local capacity_increase = (mod_mag_capacity / mag_capacity) * 100
							reload_speed_stat = 1 - math.clamp(math.round((capacity_increase / 10) * 0.05, 0.01), -0.25, 0.25)
							concealment_stat = -math.clamp(math.round(capacity_increase / 20), -5, 5)

							part.stats.reload = 0
							part.stats.spread = 0
							part.stats.recoil = 0
							part.stats.concealment = concealment_stat
							part.custom_stats.reload_speed_multiplier = shotgun_reload and 1 or reload_speed_stat
						end
					end
				end
			end
		end
	end
end

-- Kind of hacky, but it works
Hooks:PostHook(WeaponFactoryTweakData, "_add_charms_to_all_weapons", "eclipse_add_charms_to_all_weapons", function(self, tweak_data)
	self:_balance_shotgun_ammo(tweak_data)
	self:_balance_launcher_ammo(tweak_data)
	self:_balance_magazines(tweak_data)
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
	self.parts.wpn_fps_upg_perk_jawbreaker.stats = { damage = 6, fire_rate = 0.85 }
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
					hipfire = 1,
					crouching = 0.5,
					steelsight = 1,
				},
				moving = {
					hipfire = 1.5,
					crouching = 1,
					steelsight = 1,
				},
			},
			recoil = {
				standing = {
					hipfire = 1,
					crouching = 0.75,
					steelsight = 1,
				},
				moving = {
					hipfire = 1.25,
					crouching = 1,
					steelsight = 1,
				},
			},
		},
	}
	self.parts.wpn_fps_upg_perk_gunner.stance_mod = {
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
	}

	local uses_parts = {
		-- wpn_fps_upg_perk_speedloader = { category = { "assault_rifle", "smg", "snp", "shotgun", "crossbow", "flamethrower", "pistol", "minigun", "akimbo", "lmg", "bow" } },
		-- wpn_fps_upg_perk_haste = { category = { "assault_rifle", "smg", "snp", "shotgun", "flamethrower", "pistol", "minigun", "akimbo", "lmg", "bow" } },
		-- wpn_fps_upg_perk_deadsilence = { category = { "assault_rifle", "smg", "snp", "shotgun", "crossbow", "flamethrower", "pistol", "minigun", "akimbo", "lmg" } },
		-- wpn_fps_upg_perk_jawbreaker = { category = { "assault_rifle", "smg", "snp", "pistol", "minigun", "akimbo", "lmg" } },
		-- wpn_fps_upg_perk_whirlwind = { category = { "assault_rifle", "smg", "snp", "shotgun", "pistol", "minigun", "akimbo", "lmg" } },
		-- wpn_fps_upg_perk_stockpile = { category = { "assault_rifle", "smg", "snp", "shotgun", "crossbow", "flamethrower", "pistol", "minigun", "akimbo", "lmg", "bow" } },
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

-- Amazing implementation of the Sting Grenade ammunition type by Starbreeze
function WeaponFactoryTweakData:_init_hornet_grenade()
	local hornet_unit_folder = "units/pd2_dlc_pxp3/weapons/wpn_fps_grenade_launcher_hornet/"
	self.parts.wpn_fps_upg_a_grenade_launcher_hornet = {
		is_a_unlockable = true,
		texture_bundle_folder = "pxp3",
		type = "ammo",
		a_obj = "a_body",
		third_unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
		internal_part = true,
		muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_hornet",
		sub_type = "ammo_hornet",
		name_id = "bm_wp_upg_a_grenade_launcher_hornet",
		unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
		pcs = {},
		stats = {
			value = 4,
		},
		custom_stats = {
			muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_hornet",
		},
		override = {
			wpn_fps_gre_m32_mag = {
				unit = "units/pd2_dlc_pxp3/weapons/wpn_fps_grenade_launcher_hornet/wpn_fps_gre_m32_mag_hornet",
				material_config = Idstring("units/pd2_dlc_pxp3/weapons/wpn_fps_grenade_launcher_hornet/wpn_fps_gre_m32_mag_hornet"),
			},
			wpn_fps_gre_m79_grenade = {
				unit = "units/pd2_dlc_pxp3/weapons/wpn_fps_grenade_launcher_hornet/wpn_fps_gre_hornet",
				material_config = Idstring("units/pd2_dlc_pxp3/weapons/wpn_fps_grenade_launcher_hornet/wpn_fps_gre_hornet"),
			},
			wpn_fps_gre_m79_grenade_whole = {
				unit = "units/pd2_dlc_pxp3/weapons/wpn_fps_grenade_launcher_hornet/wpn_fps_gre_hornet",
				material_config = Idstring("units/pd2_dlc_pxp3/weapons/wpn_fps_grenade_launcher_hornet/wpn_fps_gre_hornet"),
			},
			wpn_fps_gre_ms3gl_grenade = {
				unit = "units/pd2_dlc_pxp3/weapons/wpn_fps_grenade_launcher_hornet/wpn_fps_gre_hornet",
				material_config = Idstring("units/pd2_dlc_pxp3/weapons/wpn_fps_grenade_launcher_hornet/wpn_fps_gre_hornet"),
			},
		},
	}
	self.parts.wpn_fps_upg_a_underbarrel_hornet = {
		is_a_unlockable = true,
		texture_bundle_folder = "pxp3",
		third_unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
		a_obj = "a_body",
		type = "underbarrel_ammo",
		internal_part = true,
		muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_hornet",
		sub_type = "ammo_hornet",
		name_id = "bm_wp_upg_a_grenade_launcher_hornet",
		unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
		pcs = {},
		stats = {
			value = 2,
		},
		custom_stats = {
			muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_hornet",
		},
		override = {
			wpn_fps_ass_groza_gl_gp25 = {
				muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_hornet",
				model = Idstring("units/pd2_dlc_pxp3/weapons/wpn_fps_grenade_launcher_hornet/wpn_fps_ass_groza_gl_gp25_hornet"),
				unit = hornet_unit_folder .. "wpn_fps_ass_groza_gl_gp25_hornet",
			},
			wpn_fps_ass_contraband_gl_m203 = {
				muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_hornet",
				unit = hornet_unit_folder .. "wpn_fps_ass_contraband_gl_m203_hornet",
			},
		},
	}

	local sting_stats = {
		light = {
			damage = -36,
			spread = -6,
		},
		medium = {
			damage = -46,
			spread = -6,
		},
		heavy = {
			damage = -55,
			spread = -6,
		},
	}

	local shotgun_stance_muls = {
		spread = {
			standing = {
				hipfire = 1,
				crouching = 1,
				steelsight = 0.8,
			},
			moving = {
				hipfire = 1.2,
				crouching = 1,
				steelsight = 1,
			},
		},
		recoil = {
			standing = {
				hipfire = 1.2,
				crouching = 1,
				steelsight = 1,
			},
			moving = {
				hipfire = 1.4,
				crouching = 1,
				steelsight = 1.2,
			},
		},
	}

	local grenade_launchers = {
		wpn_fps_gre_arbiter = {
			muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_hornet",
			stats = sting_stats.light,
			custom_stats = {
				muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_hornet",
				armor_piercing_add = 1,
				is_explosive = false,
				can_shoot_through_shield = true,
				can_shoot_through_enemy = true,
				ignore_damage_upgrades = false,
				stance_mul = shotgun_stance_muls,
				sounds = {
					fire_single = "hornet_fire",
				},
			},
		},
		wpn_fps_gre_ms3gl = {
			muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_hornet",
			stats = sting_stats.light,
			custom_stats = {
				muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_hornet",
				armor_piercing_add = 1,
				is_explosive = false,
				can_shoot_through_shield = true,
				can_shoot_through_enemy = true,
				ignore_damage_upgrades = false,
				stance_mul = shotgun_stance_muls,
				sounds = {
					fire_single = "hornet_fire",
				},
			},
		},
		wpn_fps_gre_m32 = {
			muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_hornet",
			stats = sting_stats.medium,
			custom_stats = {
				muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_hornet",
				armor_piercing_add = 1,
				is_explosive = false,
				can_shoot_through_shield = true,
				can_shoot_through_enemy = true,
				ignore_damage_upgrades = false,
				stance_mul = shotgun_stance_muls,
				sounds = {
					fire_single = "hornet_fire",
				},
			},
		},
		wpn_fps_gre_china = {
			muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_hornet",
			stats = sting_stats.medium,
			custom_stats = {
				muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_hornet",
				armor_piercing_add = 1,
				is_explosive = false,
				can_shoot_through_shield = true,
				can_shoot_through_enemy = true,
				ignore_damage_upgrades = false,
				stance_mul = shotgun_stance_muls,
				sounds = {
					fire_single = "hornet_fire",
				},
			},
		},
		wpn_fps_gre_m79 = {
			muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_hornet",
			stats = sting_stats.heavy,
			custom_stats = {
				muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_hornet",
				armor_piercing_add = 1,
				is_explosive = false,
				can_shoot_through_shield = true,
				can_shoot_through_enemy = true,
				ignore_damage_upgrades = false,
				stance_mul = shotgun_stance_muls,
				sounds = {
					fire_single = "hornet_fire",
				},
			},
		},
		wpn_fps_gre_slap = {
			muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_hornet",
			stats = sting_stats.heavy,
			custom_stats = {
				muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_hornet",
				armor_piercing_add = 1,
				is_explosive = false,
				can_shoot_through_shield = true,
				can_shoot_through_enemy = true,
				ignore_damage_upgrades = false,
				stance_mul = shotgun_stance_muls,
				sounds = {
					fire_single = "hornet_fire",
				},
			},
		},
	}
	local grenade_underbarrels = {
		wpn_fps_ass_groza = {
			muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_hornet",
			stats = sting_stats.heavy,
			custom_stats = {
				muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_hornet",
				armor_piercing_add = 1,
				is_explosive = false,
				can_shoot_through_shield = true,
				can_shoot_through_enemy = true,
				ignore_damage_upgrades = false,
				stance_mul = shotgun_stance_muls,
				sounds = {
					fire_single = "hornet_fire",
				},
			},
		},
		wpn_fps_ass_contraband = {
			muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_hornet",
			stats = sting_stats.heavy,
			custom_stats = {
				muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_hornet",
				armor_piercing_add = 1,
				is_explosive = false,
				can_shoot_through_shield = true,
				can_shoot_through_enemy = true,
				ignore_damage_upgrades = false,
				stance_mul = shotgun_stance_muls,
				sounds = {
					fire_single = "hornet_fire",
				},
			},
		},
	}
	local launcher_value = self.parts.wpn_fps_upg_a_grenade_launcher_hornet.stats.value
	local launcher_pickup_min = 1.5
	local launcher_pickup_max = launcher_pickup_min
	local fps_data, npc_data, hornet_override = nil

	for factory_id, override in pairs(grenade_launchers) do
		fps_data = self[factory_id]
		npc_data = self[factory_id .. "_npc"]

		if fps_data and npc_data and fps_data.uses_parts and npc_data.uses_parts then
			table.insert(fps_data.uses_parts, "wpn_fps_upg_a_grenade_launcher_hornet")
			table.insert(npc_data.uses_parts, "wpn_fps_upg_a_grenade_launcher_hornet")

			hornet_override = override
			hornet_override.stats.value = launcher_value
			hornet_override.custom_stats.weapon_unit = hornet_unit_folder .. factory_id
			hornet_override.custom_stats.ammo_pickup_min_mul = launcher_pickup_min
			hornet_override.custom_stats.ammo_pickup_max_mul = launcher_pickup_max
			fps_data.override = fps_data.override or {}
			fps_data.override.wpn_fps_upg_a_grenade_launcher_hornet = hornet_override
			npc_data.override = npc_data.override or {}
			npc_data.override.wpn_fps_upg_a_grenade_launcher_hornet = hornet_override
		end
	end

	local underbarrel_launcher_pickup_min = self.parts.wpn_fps_upg_a_underbarrel_hornet.custom_stats.ammo_pickup_min_mul
	local underbarrel_launcher_pickup_max = self.parts.wpn_fps_upg_a_underbarrel_hornet.custom_stats.ammo_pickup_max_mul

	for factory_id, override in pairs(grenade_underbarrels) do
		fps_data = self[factory_id]
		npc_data = self[factory_id .. "_npc"]

		if fps_data and npc_data and fps_data.uses_parts and npc_data.uses_parts then
			table.insert(fps_data.uses_parts, "wpn_fps_upg_a_underbarrel_hornet")
			table.insert(npc_data.uses_parts, "wpn_fps_upg_a_underbarrel_hornet")

			hornet_override = override
			hornet_override.custom_stats.base_stats_modifiers = hornet_override.stats
			hornet_override.custom_stats.ammo_pickup_min_mul = underbarrel_launcher_pickup_min
			hornet_override.custom_stats.ammo_pickup_max_mul = underbarrel_launcher_pickup_max
			hornet_override.stats = nil
			fps_data.override = fps_data.override or {}
			fps_data.override.wpn_fps_upg_a_underbarrel_hornet = hornet_override
			npc_data.override = npc_data.override or {}
			npc_data.override.wpn_fps_upg_a_underbarrel_hornet = hornet_override
		end
	end
end
