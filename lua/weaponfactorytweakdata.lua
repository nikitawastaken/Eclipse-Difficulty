WeaponFactoryTweakData.part_type_stat_blacklist = {
	foregrip = true,
	extra = true,
	grip = true,
	stock = true,
	lower_body = true,
	body = true,
	vertical_grip = true,
	lower_reciever = true,
	upper_reciever = true,
	drag_handle = true,
	bolt = true,
	slide = true,
	gadget = true,
}
WeaponFactoryTweakData.parts_to_all = {
	"wpn_fps_upg_bonus_team_exp",
	"wpn_fps_upg_bonus_team_money",
}
WeaponFactoryTweakData.parts_from_template = {
	["wpn_fps_upg_m4_m_drum"] = "wpn_fps_upg_m4_m_pmag",
	["wpn_upg_ak_m_drum"] = "wpn_fps_upg_ak_m_uspalm",
	["wpn_fps_smg_mp5_m_drum"] = "wpn_fps_smg_mp5_m_straight",
	["wpn_upg_saiga_m_20rnd"] = "wpn_fps_sho_basset_m_extended",
	["wpn_fps_upg_charm_eclipse"] = "wpn_fps_upg_charm_cloaker",
}

function WeaponFactoryTweakData:_add_parts_to_all(tweak_data)
	local upgrade_definitions = tweak_data.upgrades.definitions

	for weap_id, weap_data in pairs(upgrade_definitions) do
		local factory_id = weap_data.factory_id

		for _, part_id in pairs(self.parts_to_all) do
			if self[factory_id] and self[factory_id].uses_parts then
				table.insert(self[factory_id].uses_parts, part_id)
				table.insert(self[factory_id .. "_npc"].uses_parts, part_id)
			end
		end
	end
end

function WeaponFactoryTweakData:_add_parts_from_list(factory_id, part_list)
	for _, part_id in pairs(part_list) do
		if not table.contains(self[factory_id].default_blueprint, part_id) then
			if not table.contains(self[factory_id].uses_parts, part_id) then
				table.insert(self[factory_id].uses_parts, part_id)
				table.insert(self[factory_id .. "_npc"].uses_parts, part_id)
			end
		end
	end
end

function WeaponFactoryTweakData:_add_parts_from_template(tweak_data)
	local upgrade_definitions = tweak_data.upgrades.definitions

	for weap_id, weap_data in pairs(upgrade_definitions) do
		local factory_id = weap_data.factory_id
		local weapon_tweak = tweak_data.weapon and tweak_data.weapon[weap_id]

		for part_id, template_id in pairs(self.parts_from_template) do
			if self[factory_id] and self[factory_id].uses_parts and table.contains(self[factory_id].uses_parts, template_id) then
				table.insert(self[factory_id].uses_parts, part_id)
				table.insert(self[factory_id .. "_npc"].uses_parts, part_id)
			end
		end
	end
end

Hooks:PostHook(WeaponFactoryTweakData, "init", "eclipse_init", function(self)
	for part_id, part_data in pairs(self.parts) do
		if not part_data.stats then
			part_data.stats = {}
		end

		if not part_data.custom_stats then
			part_data.custom_stats = {}
		end

		local zoom_level = part_data.stats.zoom
		local is_sight = part_data.type and part_data.type == "sight"
		local is_second_sight = part_data.perks and table.contains(part_data.perks, "second_sight")
		local is_piggyback = is_second_sight and part_data.type == "extra"
		local is_magnifier = is_second_sight and not is_piggyback
		local is_optic = is_sight and part_data.perks and table.contains(part_data.perks, "scope")
		local is_scope = is_optic and zoom_level and zoom_level > 3
		local is_magazine = part_data.type and part_data.type == "magazine"
		local is_silencer = part_data.perks and table.contains(part_data.perks, "silencer")

		if self.part_type_stat_blacklist[part_data.type] and not is_second_sight then
			part_data.stats = {}
			part_data.custom_stats = {}
		end

		if part_data.sub_type == "ammo_explosive" then
			part_data.custom_stats.explosive_ammo = true
		end

		if part_data.stats.suppression then
			part_data.stats.suppression = 0
		end

		if part_data.stats.spread_moving then
			part_data.stats.spread_moving = 0
		end

		if part_data.stats.damage and not part_data.no_damage_scaling then
			part_data.stats.damage = math.round(part_data.stats.damage / 2.5)
		end

		local default_sights = {
			wpn_fps_upg_o_shortdot = true,
			wpn_fps_upg_o_shortdot_vanilla = true,
			wpn_fps_hailstorm_o_claymore = true,
		}

		if not default_sights[part_id] and is_optic then
			part_data.stats.recoil = 1
			part_data.stats.spread = 0
			part_data.stats.concealment = -1
		end

		if is_magnifier then
			part_data.stats.recoil = 0
			part_data.stats.spread = 0
			part_data.stats.concealment = -1
		end

		local is_mbus_pro = part_id == "wpn_fps_upg_o_mbus_pro"

		if is_sight and (is_mbus_pro or part_id:match("_standard$") or part_id:match("_iron")) then
			part_data.stats.zoom = 0
			part_data.stats.recoil = -1
			part_data.stats.concealment = 1
		end

		if is_magazine and (part_id:match("_quick$") or part_id:match("_speed$") or part_id:match("_strap$")) then
			part_data.stats = {}
			part_data.stats.value = 1
			part_data.stats.reload = 1
			part_data.stats.concealment = -1
		end

		if part_id:match("_legend") then
			part_data.stats = {}
			part_data.custom_stats = {}
		end
	end

	local function create_part_list(list, factory_id, part_type)
		if self[factory_id] and self[factory_id].uses_parts then
			for _, part_id in pairs(self[factory_id].uses_parts) do
				local part_data = self.parts and self.parts[part_id]
				local is_barrel_ext = part_data and part_data.type == part_type
				local default_part = table.contains(self[factory_id].default_blueprint, part_id)

				if is_barrel_ext and not default_part then
					table.insert(list, part_id)
				end
			end
		end
	end

	-- Create lists of available barrel extensions for different weapon types
	local rifle_barrel_exts = {}
	create_part_list(rifle_barrel_exts, "wpn_fps_ass_m4", "barrel_ext")

	local pistol_barrel_exts = {}
	create_part_list(pistol_barrel_exts, "wpn_fps_pis_g17", "barrel_ext")

	local shotgun_barrel_exts = {}
	create_part_list(shotgun_barrel_exts, "wpn_fps_shot_r870", "barrel_ext")

	local rifle_sights = {}
	create_part_list(rifle_sights, "wpn_fps_ass_m4", "sight")

	local pistol_sights = {}
	create_part_list(pistol_sights, "wpn_fps_pis_g17", "sight")

	local snp_sights = {}
	create_part_list(snp_sights, "wpn_fps_snp_msr", "sight")

	-- Add/remove parts
	table.delete(self.wpn_fps_ass_contraband.uses_parts, "wpn_fps_sho_sko12_body_grip")
	table.delete(self.wpn_fps_ass_m16.uses_parts, "wpn_fps_uupg_fg_radian")

	table.delete(self.wpn_fps_sho_sko12.uses_parts, "wpn_fps_upg_i_singlefire")
	table.delete(self.wpn_fps_sho_sko12.uses_parts, "wpn_fps_upg_i_autofire")

	table.delete(self.wpn_fps_ass_tecci.uses_parts, "wpn_fps_upg_i_singlefire")
	table.delete(self.wpn_fps_ass_tecci.uses_parts, "wpn_fps_upg_i_autofire")

	table.insert(self.wpn_fps_ass_ak5.uses_parts, "wpn_fps_upg_ak_ns_zenitco")
	table.insert(self.wpn_fps_shot_saiga.uses_parts, "wpn_fps_upg_ak_ns_zenitco")

	-- Akimbo SMG default blueprints
	table.delete(self.wpn_fps_smg_x_mac10.default_blueprint, "wpn_fps_smg_mac10_s_fold")
	table.delete(self.wpn_fps_smg_x_mac10.uses_parts, "wpn_fps_smg_mac10_s_fold")
	table.delete(self.wpn_fps_smg_x_mac10.uses_parts, "wpn_fps_smg_mac10_s_skel")

	table.delete(self.wpn_fps_smg_x_sr2.uses_parts, "wpn_fps_smg_sr2_s_unfolded")

	-- Assault Rifle Mods

	-- let the AMCAR use more CAR family mods
	table.insert(self.wpn_fps_ass_amcar.uses_parts, "wpn_fps_upg_ass_m4_upper_reciever_ballos")
	table.insert(self.wpn_fps_ass_amcar.uses_parts, "wpn_fps_upg_ass_m4_upper_reciever_core")
	table.insert(self.wpn_fps_ass_amcar.uses_parts, "wpn_fps_m4_upper_reciever_edge")
	table.insert(self.wpn_fps_ass_amcar.uses_parts, "wpn_fps_m4_uupg_b_long")
	table.insert(self.wpn_fps_ass_amcar.uses_parts, "wpn_fps_upg_m4_s_pts")
	table.insert(self.wpn_fps_ass_amcar.uses_parts, "wpn_fps_upg_ass_m4_lower_reciever_core")
	table.insert(self.wpn_fps_ass_amcar.uses_parts, "wpn_fps_smg_olympic_s_short")

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

	self.parts.wpn_fps_m4_uupg_b_long.stats.damage = 0
	self.parts.wpn_fps_m4_uupg_b_long.stats.spread = 2

	self.parts.wpn_fps_m4_uupg_b_short.stats.spread = -2

	self.parts.wpn_fps_m4_uupg_s_fold.stats.spread = -1
	self.parts.wpn_fps_m4_uupg_s_fold.stats.concealment = 1

	-- Make all CAR family weapons use the 30 round magazine by default
	self.parts.wpn_fps_upg_m4_m_straight_vanilla = deep_clone(self.parts.wpn_fps_m4_uupg_m_std_vanilla)

	self.parts.wpn_fps_upg_m4_m_straight.stats.extra_ammo = -5

	self.parts.wpn_fps_m4_uupg_m_std = deep_clone(self.parts.wpn_fps_upg_m4_m_straight)

	self.parts.wpn_fps_upg_m4_m_pmag.stats.extra_ammo = 0
	self.parts.wpn_fps_upg_m4_m_pmag.custom_stats.ammo_offset = 5

	self.parts.wpn_fps_ass_l85a2_m_emag.stats.extra_ammo = 0
	self.parts.wpn_fps_ass_l85a2_m_emag.custom_stats.ammo_offset = 5

	self.parts.wpn_fps_upg_m4_m_l5.stats.extra_ammo = 0
	self.parts.wpn_fps_upg_m4_m_l5.custom_stats.ammo_offset = 5

	self.parts.wpn_fps_m4_upg_fg_mk12.stats.total_ammo_mod = -9
	self.parts.wpn_fps_m4_upg_fg_mk12.stats.damage = 16
	self.parts.wpn_fps_m4_upg_fg_mk12.stats.spread = 3
	self.parts.wpn_fps_m4_upg_fg_mk12.stats.recoil = -5
	self.parts.wpn_fps_m4_upg_fg_mk12.stats.concealment = -4
	self.parts.wpn_fps_m4_upg_fg_mk12.custom_stats = { fire_rate_multiplier = 600 / 750, ammo_pickup_min_mul = 1 / 1.8, ammo_pickup_min_mul = 1 / 1.8 }

	self.parts.wpn_fps_upg_ak_b_draco.stats.damage = 0
	self.parts.wpn_fps_upg_ak_b_draco.stats.concealment = 2

	self.parts.wpn_fps_upg_ak_b_ak105.stats.damage = 0
	self.parts.wpn_fps_upg_ak_b_ak105.stats.spread = -1

	self.parts.wpn_upg_ak_s_folding.stats.spread = -1
	self.parts.wpn_upg_ak_s_folding.stats.concealment = 1

	self.parts.wpn_upg_ak_s_skfoldable.stats.spread = -1
	self.parts.wpn_upg_ak_s_skfoldable.stats.concealment = 1

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

	self.parts.wpn_fps_smg_hajk_b_short.stats.spread = -2
	self.parts.wpn_fps_smg_hajk_b_short.stats.concealment = 2

	self.parts.wpn_fps_ass_corgi_b_short.stats.concealment = 2

	-- DMR Mods
	self.parts.wpn_fps_ass_m14_body_ruger.stats.spread = -6
	self.parts.wpn_fps_ass_m14_body_ruger.stats.recoil = -2
	self.parts.wpn_fps_ass_m14_body_ruger.stats.concealment = 8

	self.parts.wpn_fps_ass_scar_b_short.stats.spread = -2
	self.parts.wpn_fps_ass_scar_b_short.stats.concealment = 2

	self.parts.wpn_fps_ass_scar_b_long.stats.concealment = -2

	self.parts.wpn_fps_ass_sub2000_fg_suppressed.stats.spread = -2
	self.parts.wpn_fps_ass_sub2000_fg_suppressed.stats.concealment = 1

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

	self.parts.wpn_fps_ass_contraband_o_standard.stats.recoil = 0
	self.parts.wpn_fps_ass_contraband_o_standard.stats.concealment = 0

	self.parts.wpn_fps_ass_ching_b_short.stats.spread = -3
	self.parts.wpn_fps_ass_ching_b_short.stats.concealment = 3

	self.parts.wpn_fps_ass_ching_s_pouch.stats.total_ammo_mod = 3
	self.parts.wpn_fps_ass_ching_s_pouch.stats.concealment = -2

	-- Pistol mods
	self.parts.wpn_fps_pis_g17_ck.stats.spread = 0
	self.parts.wpn_fps_pis_g17_ck.stats.recoil = 0

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

	self.parts.wpn_fps_pis_deagle_ck.stats.total_ammo_mod = 5
	self.parts.wpn_fps_pis_deagle_ck.stats.damage = -16
	self.parts.wpn_fps_pis_deagle_ck.stats.spread = 0
	self.parts.wpn_fps_pis_deagle_ck.stats.recoil = 2
	self.parts.wpn_fps_pis_deagle_ck.stats.concealment = -2
	self.parts.wpn_fps_pis_deagle_ck.custom_stats.ammo_pickup_min_mul = 5 / 4
	self.parts.wpn_fps_pis_deagle_ck.custom_stats.ammo_pickup_max_mul = self.parts.wpn_fps_pis_deagle_ck.custom_stats.ammo_pickup_min_mul

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

	self.parts.wpn_fps_pis_beer_m_extended.stats.extra_ammo = 5

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
	self.parts.wpn_fps_pis_korth_m_6.stats.total_ammo_mod = -4
	self.parts.wpn_fps_pis_korth_m_6.stats.damage = 16
	self.parts.wpn_fps_pis_korth_m_6.stats.spread = 2
	self.parts.wpn_fps_pis_korth_m_6.stats.recoil = -3
	self.parts.wpn_fps_pis_korth_m_6.stats.concealment = 0
	self.parts.wpn_fps_pis_korth_m_6.custom_stats = { ammo_pickup_max_mul = 4 / 5, ammo_pickup_min_mul = 4 / 5 }

	self.parts.wpn_fps_pis_korth_conversionkit.stats.total_ammo_mod = 5
	self.parts.wpn_fps_pis_korth_conversionkit.stats.damage = -16
	self.parts.wpn_fps_pis_korth_conversionkit.stats.spread = 0
	self.parts.wpn_fps_pis_korth_conversionkit.stats.recoil = 0
	self.parts.wpn_fps_pis_korth_conversionkit.stats.concealment = 0
	self.parts.wpn_fps_pis_korth_conversionkit.custom_stats = { ammo_pickup_max_mul = 4 / 3, ammo_pickup_min_mul = 4 / 3 }

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
	self.parts.wpn_fps_smg_mp5_m_straight.custom_stats = { ammo_pickup_max_mul = 3 / 4, ammo_pickup_min_mul = 3 / 4 }

	self.parts.wpn_fps_smg_p90_b_long.stats.damage = 0
	self.parts.wpn_fps_smg_p90_b_long.stats.spread = 2
	self.parts.wpn_fps_smg_p90_b_long.stats.recoil = 0

	self.parts.wpn_fps_smg_p90_b_civilian.stats.concealment = -3

	self.parts.wpn_fps_smg_p90_b_ninja.stats.concealment = -4

	self.parts.wpn_fps_smg_m45_b_small.stats.concealment = 2

	self.parts.wpn_fps_smg_m45_s_folded.stats.spread = -2
	self.parts.wpn_fps_smg_m45_s_folded.stats.concealment = 2

	self.parts.wpn_fps_smg_mp7_s_long.stats.recoil = 2
	self.parts.wpn_fps_smg_mp7_s_long.stats.concealment = -2

	self.parts.wpn_fps_smg_scorpion_m_extended.stats = { value = 1, reload = 1, recoil = 1, concealment = -2 }

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

	self.parts.wpn_fps_smg_shepheard_mag_standard.unit = "units/pd2_dlc_joy/weapons/wpn_fps_smg_shepheard_pts/wpn_fps_smg_shepheard_mag_extended"
	self.parts.wpn_fps_smg_shepheard_mag_standard.third_unit = "units/pd2_dlc_joy/weapons/wpn_fps_smg_shepheard_pts/wpn_third_smg_shepheard_mag_extended"
	self.parts.wpn_fps_smg_shepheard_mag_standard.bullet_objects = { amount = 30, prefix = "g_bullet_" }

	self.parts.wpn_fps_smg_shepheard_mag_extended.unit = "units/pd2_dlc_joy/weapons/wpn_fps_smg_shepheard_pts/wpn_fps_smg_shepheard_mag_standard"
	self.parts.wpn_fps_smg_shepheard_mag_extended.third_unit = "units/pd2_dlc_joy/weapons/wpn_fps_smg_shepheard_pts/wpn_third_smg_shepheard_mag_standard"
	self.parts.wpn_fps_smg_shepheard_mag_extended.bullet_objects = { amount = 20, prefix = "g_bullet_" }
	self.parts.wpn_fps_smg_shepheard_mag_extended.stats.extra_ammo = -5

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

	local rifle_barrel_exts_no_shak12 = clone(rifle_barrel_exts)

	table.delete(rifle_barrel_exts_no_shak12, "wpn_fps_ass_shak12_ns_muzzle")
	table.delete(rifle_barrel_exts_no_shak12, "wpn_fps_ass_shak12_ns_suppressor")

	self:_add_parts_from_list("wpn_fps_smg_pm9", rifle_barrel_exts_no_shak12)

	self.parts.wpn_fps_smg_pm9_b_standard.forbids = {}

	for _, part_id in pairs(rifle_barrel_exts_no_shak12) do
		table.insert(self.parts.wpn_fps_smg_pm9_b_standard.forbids, part_id)
	end

	self.parts.wpn_fps_smg_fmg9_conversion.stats.damage = 0
	self.parts.wpn_fps_smg_fmg9_conversion.stats.spread = 1
	self.parts.wpn_fps_smg_fmg9_conversion.stats.recoil = 1

	for _, part_id in pairs(rifle_barrel_exts) do
		table.insert(self.parts.wpn_fps_smg_fmg9_conversion.forbids, part_id)
	end

	-- Shotgun Mods
	self.parts.wpn_fps_sho_saiga_b_short.stats.spread = -2
	self.parts.wpn_fps_sho_saiga_b_short.stats.recoil = 0
	self.parts.wpn_fps_sho_saiga_b_short.stats.concealment = 2

	self.parts.wpn_fps_sho_basset_m_extended.stats.extra_ammo = 0
	self.parts.wpn_fps_sho_basset_m_extended.custom_stats = { ammo_offset = 3 }

	self.parts.wpn_fps_sho_aa12_mag_drum.stats.extra_ammo = 6

	self.parts.wpn_fps_shot_r870_body_rack.stats.reload = 2
	self.parts.wpn_fps_shot_r870_body_rack.stats.concealment = -2

	self.parts.wpn_fps_shot_shorty_m_extended_short.stats.extra_ammo = 0
	self.parts.wpn_fps_shot_shorty_m_extended_short.stats.concealment = -1
	self.parts.wpn_fps_shot_shorty_m_extended_short.custom_stats = { ammo_offset = 1 }

	self.parts.wpn_fps_shot_huntsman_b_short.stats.spread = -3
	self.parts.wpn_fps_shot_huntsman_b_short.stats.recoil = -2
	self.parts.wpn_fps_shot_huntsman_b_short.stats.concealment = 5

	self.parts.wpn_fps_shot_huntsman_s_short.stats.spread = -2
	self.parts.wpn_fps_shot_huntsman_s_short.stats.recoil = -3
	self.parts.wpn_fps_shot_huntsman_s_short.stats.concealment = 5

	self.parts.wpn_fps_sho_ben_b_long.stats.spread = 1
	self.parts.wpn_fps_sho_ben_b_long.stats.recoil = 0

	self.parts.wpn_fps_sho_ben_b_short.stats.damage = 0
	self.parts.wpn_fps_sho_ben_b_short.stats.recoil = 0
	self.parts.wpn_fps_sho_ben_b_short.stats.concealment = 3

	self.parts.wpn_fps_sho_ben_s_collapsed.stats.recoil = -3
	self.parts.wpn_fps_sho_ben_s_collapsed.stats.concealment = 3

	self.parts.wpn_fps_sho_ksg_b_long.stats.extra_ammo = 1
	self.parts.wpn_fps_sho_ksg_b_long.stats.spread = 1
	self.parts.wpn_fps_sho_ksg_b_long.stats.recoil = 0
	self.parts.wpn_fps_sho_ksg_b_long.stats.concealment = -2

	self.parts.wpn_fps_sho_ksg_b_short.stats.extra_ammo = -1
	self.parts.wpn_fps_sho_ksg_b_short.stats.spread = -1
	self.parts.wpn_fps_sho_ksg_b_short.stats.recoil = 0
	self.parts.wpn_fps_sho_ksg_b_short.stats.concealment = 2

	self.parts.wpn_fps_sho_striker_b_long.recoil = 0

	self.parts.wpn_fps_sho_b_spas12_long.stats.extra_ammo = 1
	self.parts.wpn_fps_sho_b_spas12_long.stats.recoil = 0

	self.parts.wpn_fps_sho_s_spas12_folded.stats.recoil = -1
	self.parts.wpn_fps_sho_s_spas12_folded.stats.concealment = 1

	self.parts.wpn_fps_sho_s_spas12_nostock.stats.recoil = -2
	self.parts.wpn_fps_sho_s_spas12_nostock.stats.concealment = 2

	self.parts.wpn_fps_sho_s_spas12_solid.stats.recoil = 1
	self.parts.wpn_fps_sho_s_spas12_solid.stats.concealment = -1

	self.parts.wpn_fps_shot_b682_b_short.stats.spread = -3
	self.parts.wpn_fps_shot_b682_b_short.stats.recoil = -1
	self.parts.wpn_fps_shot_b682_b_short.stats.concealment = 4

	self.parts.wpn_fps_shot_b682_s_short.stats.spread = -1
	self.parts.wpn_fps_shot_b682_s_short.stats.recoil = -3
	self.parts.wpn_fps_shot_b682_s_short.stats.concealment = 4

	self.parts.wpn_fps_shot_b682_s_ammopouch.stats.reload = 1
	self.parts.wpn_fps_shot_b682_s_ammopouch.stats.concealment = -1

	self.parts.wpn_fps_shot_m37_s_short.stats.recoil = -2
	self.parts.wpn_fps_shot_m37_s_short.stats.concealment = 2

	self.parts.wpn_fps_sho_boot_b_long.stats.extra_ammo = 1
	self.parts.wpn_fps_sho_boot_b_long.stats.recoil = 0

	self.parts.wpn_fps_sho_boot_b_short.stats.extra_ammo = -1
	self.parts.wpn_fps_sho_boot_b_short.stats.recoil = 0

	self.parts.wpn_fps_sho_boot_s_long.stats.recoil = 2
	self.parts.wpn_fps_sho_boot_s_long.stats.concealment = -2

	self.parts.wpn_fps_sho_rota_b_short.stats.concealment = 2

	self.parts.wpn_fps_sho_basset_fg_short.stats.recoil = -2
	self.parts.wpn_fps_sho_basset_fg_short.stats.concealment = 2

	self.parts.wpn_fps_sho_coach_b_short.stats.spread = -3
	self.parts.wpn_fps_sho_coach_b_short.stats.recoil = -2
	self.parts.wpn_fps_sho_coach_b_short.stats.concealment = 5

	self.parts.wpn_fps_sho_coach_s_short.stats.spread = -2
	self.parts.wpn_fps_sho_coach_s_short.stats.recoil = -3
	self.parts.wpn_fps_sho_coach_s_short.stats.concealment = 5

	self.parts.wpn_fps_shot_m1897_b_long.stats.recoil = 0

	self.parts.wpn_fps_shot_m1897_s_short.stats.recoil = -2
	self.parts.wpn_fps_shot_m1897_s_short.stats.concealment = 2

	self.parts.wpn_fps_sho_ultima_body_rack.stats.reload = 2
	self.parts.wpn_fps_sho_ultima_body_rack.stats.concealment = -2

	self.parts.wpn_fps_sho_ultima_s_light.stats.recoil = 1
	self.parts.wpn_fps_sho_ultima_s_light.stats.concealment = -1

	self.parts.wpn_fps_sho_m590_b_long.stats.extra_ammo = 0
	self.parts.wpn_fps_sho_m590_b_long.stats.spread = 1
	self.parts.wpn_fps_sho_m590_b_long.stats.concealment = -2
	self.parts.wpn_fps_sho_m590_b_long.custom_stats.ammo_offset = 3

	self.parts.wpn_fps_sho_sko12_b_long.stats.damage = 0
	self.parts.wpn_fps_sho_sko12_b_long.stats.recoil = 0

	self.parts.wpn_fps_sho_sko12_b_short.stats.spread = -2
	self.parts.wpn_fps_sho_sko12_b_short.stats.recoil = 0

	self.parts.wpn_fps_sho_sko12_conversion.stats.total_ammo_mod = 0
	self.parts.wpn_fps_sho_sko12_conversion.stats.damage = 0
	self.parts.wpn_fps_sho_sko12_conversion.stats.recoil = 4

	self.parts.wpn_fps_sho_supernova_b_long.stats.recoil = 0

	self.parts.wpn_fps_sho_supernova_g_stakeout.stats.recoil = -2
	self.parts.wpn_fps_sho_supernova_g_stakeout.stats.concealment = 2

	self.parts.wpn_fps_sho_supernova_shell_rack.stats.reload = 2
	self.parts.wpn_fps_sho_supernova_shell_rack.stats.concealment = -2

	self.parts.wpn_fps_sho_supernova_s_collapsed.stats.recoil = -1
	self.parts.wpn_fps_sho_supernova_s_collapsed.stats.concealment = 1

	self.parts.wpn_fps_sho_supernova_s_raven.stats.recoil = -1
	self.parts.wpn_fps_sho_supernova_s_raven.stats.concealment = 1

	self.parts.wpn_fps_sho_supernova_conversion.stats.extra_ammo = 0
	self.parts.wpn_fps_sho_supernova_conversion.stats.spread = 0
	self.parts.wpn_fps_sho_supernova_conversion.stats.recoil = -2
	self.parts.wpn_fps_sho_supernova_conversion.custom_stats = { ammo_pickup_max_mul = 5 / 4, ammo_pickup_min_mul = 5 / 4 }

	-- Sniper Rifle Mods
	self.parts.wpn_fps_snp_msr_b_long.stats.concealment = -1

	self.parts.wpn_fps_snp_r93_b_short.stats.recoil = 0
	self.parts.wpn_fps_snp_r93_b_short.stats.concealment = 2

	self.parts.wpn_fps_snp_m95_barrel_long.stats.spread = 1

	self.parts.wpn_fps_snp_mosin_b_short.stats.spread = -2
	self.parts.wpn_fps_snp_mosin_b_short.stats.concealment = 2

	self.parts.wpn_fps_snp_mosin_b_standard.stats.spread = 1
	self.parts.wpn_fps_snp_mosin_b_standard.stats.recoil = 0
	self.parts.wpn_fps_snp_mosin_b_standard.stats.concealment = -1

	self.parts.wpn_fps_snp_mosin_ns_bayonet.stats.min_damage = 6
	self.parts.wpn_fps_snp_mosin_ns_bayonet.stats.max_damage = self.parts.wpn_fps_snp_mosin_ns_bayonet.stats.min_damage
	self.parts.wpn_fps_snp_mosin_ns_bayonet.stats.min_damage_effect = 1.5
	self.parts.wpn_fps_snp_mosin_ns_bayonet.stats.max_damage_effect = self.parts.wpn_fps_snp_mosin_ns_bayonet.stats.min_damage_effect

	self.parts.wpn_fps_snp_winchester_b_long.stats.extra_ammo = 2

	self.parts.wpn_fps_snp_wa2000_b_long.stats.concealment = -1

	self.parts.wpn_fps_snp_siltstone_ns_variation_b.stats.spread = -2
	self.parts.wpn_fps_snp_siltstone_ns_variation_b.stats.recoil = 2

	self.parts.wpn_fps_snp_r700_b_short.stats.spread = -2
	self.parts.wpn_fps_snp_r700_b_short.stats.recoil = 0
	self.parts.wpn_fps_snp_r700_b_short.stats.concealment = 2

	-- Make sure all sights get a mounting rail when used on the R700
	for _, part_id in pairs(snp_sights) do
		self.wpn_fps_snp_r700.adds[part_id] = {
			"wpn_fps_snp_r700_o_rail",
		}
	end

	self.parts.wpn_fps_snp_sbl_b_long.stats.extra_ammo = -1
	self.parts.wpn_fps_snp_sbl_b_long.stats.spread = 3
	self.parts.wpn_fps_snp_sbl_b_long.stats.recoil = 0
	self.parts.wpn_fps_snp_sbl_b_long.stats.concealment = -2

	self.parts.wpn_fps_snp_sbl_b_short.stats.extra_ammo = -1
	self.parts.wpn_fps_snp_sbl_b_short.stats.concealment = 0

	self.parts.wpn_fps_snp_sbl_s_saddle.stats.reload = 1
	self.parts.wpn_fps_snp_sbl_s_saddle.stats.concealment = -1

	self.parts.wpn_fps_snp_qbu88_b_long.stats.recoil = 0

	self.parts.wpn_fps_snp_scout_conversion.stats.spread = 0
	self.parts.wpn_fps_snp_scout_conversion.stats.recoil = 0
	self.parts.wpn_fps_snp_scout_conversion.stats.reload = 2

	self.parts.wpn_fps_snp_victor_sbr_kit.stats.damage = 0
	self.parts.wpn_fps_snp_victor_sbr_kit.stats.spread = -2
	self.parts.wpn_fps_snp_victor_sbr_kit.stats.recoil = 2
	self.parts.wpn_fps_snp_victor_sbr_kit.stats.concealment = 2

	self.parts.wpn_fps_snp_contender_barrel_long.stats.damage = 0
	self.parts.wpn_fps_snp_contender_barrel_long.stats.spread = 1
	self.parts.wpn_fps_snp_contender_barrel_long.stats.recoil = 0
	self.parts.wpn_fps_snp_contender_barrel_long.stats.concealment = -1

	self.parts.wpn_fps_snp_contender_barrel_short.stats.recoil = 0

	self.parts.wpn_fps_upg_m4_g_contender.stats.recoil = 2
	self.parts.wpn_fps_upg_m4_g_contender.stats.concealment = -2

	self.parts.wpn_fps_snp_contender_conversion.stats.total_ammo_mod = 0
	self.parts.wpn_fps_snp_contender_conversion.stats.damage = 0
	self.parts.wpn_fps_snp_contender_conversion.stats.spread = 0
	self.parts.wpn_fps_snp_contender_conversion.stats.reload = 2
	self.parts.wpn_fps_snp_contender_conversion.stats.concealment = -2

	self.parts.wpn_fps_snp_awp_conversion_wildlands.stats = {}
	self.parts.wpn_fps_snp_awp_conversion_wildlands.stats.value = 1
	self.parts.wpn_fps_snp_awp_conversion_wildlands.custom_stats = {}

	self.parts.wpn_fps_snp_awp_conversion_dragonlore.stats = {}
	self.parts.wpn_fps_snp_awp_conversion_dragonlore.stats.value = 1
	self.parts.wpn_fps_snp_awp_conversion_dragonlore.custom_stats = {}

	-- LMG Mods
	self.parts.wpn_fps_upg_bp_lmg_lionbipod.stats.concealment = -1

	self.parts.wpn_fps_lmg_m249_b_long.stats.damage = 0
	self.parts.wpn_fps_lmg_m249_b_long.stats.spread = 2
	self.parts.wpn_fps_lmg_m249_b_long.stats.concealment = -2

	self.parts.wpn_fps_lmg_hk21_b_long.stats.damage = 0
	self.parts.wpn_fps_lmg_hk21_b_long.stats.spread = 2
	self.parts.wpn_fps_lmg_hk21_b_long.stats.recoil = 0
	self.parts.wpn_fps_lmg_hk21_b_long.stats.concealment = -2

	self.parts.wpn_fps_lmg_hk21_fg_short.stats.spread = -2
	self.parts.wpn_fps_lmg_hk21_fg_short.stats.recoil = -1
	self.parts.wpn_fps_lmg_hk21_fg_short.stats.concealment = 3

	local akm_handguards = {
		"wpn_upg_ak_fg_combo3",
		"wpn_fps_upg_ak_fg_tapco",
		"wpn_fps_upg_fg_midwest",
		"wpn_fps_upg_ak_fg_krebs",
		"wpn_fps_upg_ak_fg_trax",
		--	"wpn_fps_upg_ak_fg_zenitco",
	}

	self:_add_parts_from_list("wpn_fps_lmg_rpk", akm_handguards)

	for _, part_id in pairs(akm_handguards) do
		if not self.wpn_fps_lmg_rpk.adds then
			self.wpn_fps_lmg_rpk.adds = {}
		end

		self.wpn_fps_lmg_rpk.adds[part_id] = {
			"wpn_fps_upg_vg_ass_smg_verticalgrip",
		}
	end

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

	self.parts.wpn_fps_lmg_hcar_body_conversionkit.stats.extra_ammo = 15
	self.parts.wpn_fps_lmg_hcar_body_conversionkit.stats.total_ammo_mod = 13
	self.parts.wpn_fps_lmg_hcar_body_conversionkit.stats.damage = -18
	self.parts.wpn_fps_lmg_hcar_body_conversionkit.stats.spread = -4
	self.parts.wpn_fps_lmg_hcar_body_conversionkit.stats.recoil = 6
	self.parts.wpn_fps_lmg_hcar_body_conversionkit.stats.concealment = 0
	self.parts.wpn_fps_lmg_hcar_body_conversionkit.custom_stats = { fire_rate_multiplier = 1.6, ammo_pickup_min_mul = 2, ammo_pickup_max_mul = 2 }

	self.parts.wpn_fps_lmg_kacchainsaw_b_long.stats.damage = 0
	self.parts.wpn_fps_lmg_kacchainsaw_b_long.stats.spread = 2
	self.parts.wpn_fps_lmg_kacchainsaw_b_long.stats.recoil = 0
	self.parts.wpn_fps_lmg_kacchainsaw_b_long.stats.concealment = -2

	self.parts.wpn_fps_lmg_kacchainsaw_mag_b.stats.extra_ammo = -25
	self.parts.wpn_fps_lmg_kacchainsaw_mag_b.stats.recoil = 0

	self.parts.wpn_fps_lmg_kacchainsaw_flamethrower.stats.spread = 0
	self.parts.wpn_fps_lmg_kacchainsaw_flamethrower.stats.recoil = 0
	self.parts.wpn_fps_lmg_kacchainsaw_flamethrower.stats.concealment = -4

	self.parts.wpn_fps_lmg_kacchainsaw_conversionkit.stats.extra_ammo = 0
	self.parts.wpn_fps_lmg_kacchainsaw_conversionkit.stats.total_ammo_mod = 10
	self.parts.wpn_fps_lmg_kacchainsaw_conversionkit.stats.damage = -6
	self.parts.wpn_fps_lmg_kacchainsaw_conversionkit.stats.spread = 0
	self.parts.wpn_fps_lmg_kacchainsaw_conversionkit.stats.recoil = 0
	self.parts.wpn_fps_lmg_kacchainsaw_conversionkit.stats.concealment = 2
	self.parts.wpn_fps_lmg_kacchainsaw_conversionkit.custom_stats = { fire_rate_multiplier = 1800 / 1100, ammo_pickup_min_mul = 2 / 3, ammo_pickup_max_mul = 2 / 3 }

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
	self.parts.wpn_fps_hailstorm_b_extended.stats.spread = 2
	self.parts.wpn_fps_hailstorm_b_extended.stats.recoil = 0
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
	self.parts.wpn_fps_hailstorm_conversion.custom_stats.fire_rate_multiplier = 1500 / 2000

	self.parts.wpn_fps_gre_m79_barrel_short.stats.spread = -3
	self.parts.wpn_fps_gre_m79_barrel_short.stats.concealment = 3

	self.parts.wpn_fps_gre_m79_stock_short.stats.spread = -2
	self.parts.wpn_fps_gre_m79_stock_short.stats.recoil = -1
	self.parts.wpn_fps_gre_m79_stock_short.stats.concealment = 3

	self.parts.wpn_fps_gre_ms3gl_b_long.stats.spread = 3
	self.parts.wpn_fps_gre_ms3gl_b_long.stats.recoil = 0
	self.parts.wpn_fps_gre_ms3gl_b_long.stats.concealment = -4
	self.parts.wpn_fps_gre_ms3gl_b_long.custom_stats = { ammo_offset = 1 }

	self.parts.wpn_fps_gre_ms3gl_conversion.stats.total_ammo_mod = 0
	self.parts.wpn_fps_gre_ms3gl_conversion.stats.damage = 0
	self.parts.wpn_fps_gre_ms3gl_conversion.stats.spread = 0
	self.parts.wpn_fps_gre_ms3gl_conversion.custom_stats.fire_rate_multiplier = 4 / 3
	self.parts.wpn_fps_gre_ms3gl_conversion.adds = {}

	-- Re-add drum mags	and unused RPK mag
	self.parts.wpn_fps_upg_m4_m_drum = {
		a_obj = "a_m",
		type = "magazine",
		name_id = "bm_wp_m4_m_drum",
		unit = "units/payday2/weapons/wpn_fps_upg_m4_reusable/wpn_fps_upg_m4_m_drum",
		third_unit = "units/payday2/weapons/wpn_third_upg_m4_reusable/wpn_third_upg_m4_m_drum",
		pcs = {
			10,
			20,
			30,
			40,
		},
		bullet_objects = {
			amount = 1,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
		custom_stats = {
			ammo_offset = 45,
		},
		animations = {
			reload_not_empty = "reload_not_empty",
			reload = "reload",
		},
		no_akimbo = true,
	}

	self.parts.wpn_upg_ak_m_drum = {
		a_obj = "a_m",
		type = "magazine",
		name_id = "bm_wp_ak_m_drum",
		unit = "units/payday2/weapons/wpn_fps_upg_ak_reusable/wpn_upg_ak_m_drum",
		third_unit = "units/payday2/weapons/wpn_third_upg_ak_reusable/wpn_third_upg_ak_m_drum",
		pcs = {
			10,
			20,
			30,
			40,
		},
		bullet_objects = {
			amount = 1,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
		custom_stats = {
			ammo_offset = 45,
		},
		animations = {
			reload_not_empty = "reload_not_empty",
			reload = "reload",
		},
		no_akimbo = true,
	}

	self.parts.wpn_fps_smg_mp5_m_drum = {
		a_obj = "a_m",
		type = "magazine",
		name_id = "bm_wp_mp5_m_drum",
		unit = "units/payday2/weapons/wpn_fps_smg_mp5_pts/wpn_fps_smg_mp5_m_drum",
		third_unit = "units/payday2/weapons/wpn_third_smg_mp5_pts/wpn_third_smg_mp5_m_drum",
		pcs = {
			10,
			20,
			30,
			40,
		},
		bullet_objects = {
			amount = 1,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
		custom_stats = {
			ammo_offset = 45,
		},
		animations = {
			reload_not_empty = "reload_not_empty",
			reload = "reload",
		},
		no_akimbo = true,
	}

	self.parts.wpn_upg_saiga_m_20rnd = {
		a_obj = "a_m",
		type = "magazine",
		name_id = "bm_wp_saiga_m_20rnd",
		unit = "units/payday2/weapons/wpn_fps_shot_saiga_pts/wpn_upg_saiga_m_20rnd",
		third_unit = "units/payday2/weapons/wpn_third_shot_saiga_pts/wpn_third_saiga_m_20rnd",
		pcs = {
			10,
			20,
			30,
			40,
		},
		bullet_objects = {
			amount = 1,
			prefix = "g_bullet_",
		},
		stats = {
			value = 1,
		},
		custom_stats = {
			ammo_offset = 13,
		},
		animations = {
			reload_not_empty = "reload_not_empty",
			reload = "reload",
		},
		no_akimbo = true,
	}

	-- Add Eclipse logo charm
	self.parts.wpn_fps_upg_charm_eclipse = {
		is_a_unlockable = true,
		texture_bundle_folder = "eclipse",
		a_obj = "a_charm",
		type = "charm",
		name_id = "bm_wp_upg_charm_eclipse",
		unit = "units/pd2_mod_eclipse/weapons/wpn_fps_upg_charms/wpn_fps_upg_charm_eclipse",
		third_unit = "units/pd2_mod_eclipse/weapons/wpn_fps_upg_charms/wpn_third_upg_charm_eclipse",
		pcs = {},
		stats = {
			value = 1,
		},
	}

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
				hipfire = 1.4,
				crouching = 1,
				steelsight = 1,
			},
			moving = {
				hipfire = 1.6,
				crouching = 1,
				steelsight = 1.4,
			},
		},
	}
	local dmr_fire_mode_muls = {
		auto = {},
	}

	local conversion_kit_stats = {
		ar_dmr_kit = {
			custom_stats = {
				steelsight_speed_multiplier = 0.75,
				stance_mul = dmr_stance_muls,
				fire_mode_mul = dmr_fire_mode_muls,
			},
			stats = {
				value = 1,
				damage = 28,
				spread = 4,
				recoil = -8,
				concealment = -4,
				suppression = -5,
				alert_size = 1,
			},
		},
	}

	-- ak family
	self.parts.wpn_fps_upg_ass_ak_b_zastava.custom_stats = conversion_kit_stats.ar_dmr_kit.custom_stats
	self.parts.wpn_fps_upg_ass_ak_b_zastava.stats = conversion_kit_stats.ar_dmr_kit.stats

	self.wpn_fps_ass_74.override.wpn_fps_upg_ass_ak_b_zastava.custom_stats = conversion_kit_stats.ar_dmr_kit.custom_stats
	self.wpn_fps_ass_74.override.wpn_fps_upg_ass_ak_b_zastava.stats = conversion_kit_stats.ar_dmr_kit.stats

	-- car family
	self.parts.wpn_fps_upg_ass_m4_b_beowulf.custom_stats = conversion_kit_stats.ar_dmr_kit.custom_stats
	self.parts.wpn_fps_upg_ass_m4_b_beowulf.stats = conversion_kit_stats.ar_dmr_kit.stats

	self.wpn_fps_ass_m4.override.wpn_fps_upg_ass_m4_b_beowulf.custom_stats = conversion_kit_stats.ar_dmr_kit.custom_stats
	self.wpn_fps_ass_m4.override.wpn_fps_upg_ass_m4_b_beowulf.stats = conversion_kit_stats.ar_dmr_kit.stats

	self.wpn_fps_ass_m16.override.wpn_fps_upg_ass_m4_b_beowulf.custom_stats = conversion_kit_stats.ar_dmr_kit.custom_stats
	self.wpn_fps_ass_m16.override.wpn_fps_upg_ass_m4_b_beowulf.stats = conversion_kit_stats.ar_dmr_kit.stats

	-- gewehr
	--self.parts.wpn_fps_ass_g3_b_sniper.custom_stats = conversion_kit_stats.low_dmr_to_high_dmr.custom_stats
	--self.parts.wpn_fps_ass_g3_b_sniper.stats = conversion_kit_stats.low_dmr_to_high_dmr.stats
	self.parts.wpn_fps_ass_g3_b_sniper.adds = {} -- wtf is this, why do you need a separate dummy mod for ammo pickup specifically

	self.parts.wpn_fps_ass_g3_b_short.stats.total_ammo_mod = 0
	self.parts.wpn_fps_ass_g3_b_short.stats.damage = 0
	self.parts.wpn_fps_ass_g3_b_short.stats.spread = -2
	self.parts.wpn_fps_ass_g3_b_short.stats.recoil = 0
	self.parts.wpn_fps_ass_g3_b_short.stats.concealment = 2
	self.parts.wpn_fps_ass_g3_b_short.custom_stats = {}

	-- falcon
	--self.parts.wpn_fps_ass_fal_fg_04.custom_stats = conversion_kit_stats.low_dmr_to_high_dmr.custom_stats
	--self.parts.wpn_fps_ass_fal_fg_04.stats = conversion_kit_stats.low_dmr_to_high_dmr.stats

	-- ks12
	--self.parts.wpn_fps_ass_shak12_body_vks.custom_stats = conversion_kit_stats.low_dmr_to_high_dmr.custom_stats
	--self.parts.wpn_fps_ass_shak12_body_vks.stats = conversion_kit_stats.low_dmr_to_high_dmr.stats

	-- broomstick
	--self.parts.wpn_fps_pis_c96_b_long.custom_stats = conversion_kit_stats.high_dmg.custom_stats
	--self.parts.wpn_fps_pis_c96_b_long.stats = { value = 1, total_ammo_mod = -5, concealment = -6, spread = 2, recoil = -3, damage = 18, suppression = -5, alert_size = 4 }

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
		small_silencer = { value = 1, concealment = -1 },
		medium_silencer = { value = 1, spread = 1, concealment = -2 },
		big_silencer = { value = 1, recoil = 1, spread = 1, concealment = -3 },
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

	local underbarrel_shotgun_ammo_types = {
		underbarrel_slug = {
			name_id = "bm_wp_type54_underbarrel_slug",
			ammo_id = "wpn_fps_upg_a_slug",
		},
		underbarrel_piercing = {
			name_id = "bm_wp_type54_underbarrel_piercing",
			ammo_id = "wpn_fps_upg_a_piercing",
		},
		underbarrel_dragons_breath = {
			name_id = "bm_wp_type54_underbarrel_dragons_breath",
			ammo_id = "wpn_fps_upg_a_dragons_breath",
		},
		underbarrel_rip = {
			name_id = "bm_wp_type54_underbarrel_rip",
			ammo_id = "wpn_fps_upg_a_rip",
		},
	}
	local underbarrel_shotgun_weapons = {
		wpn_fps_pis_x_type54 = "wpn_fps_pis_x_type54_underbarrel",
		wpn_fps_pis_type54 = "wpn_fps_pis_type54_underbarrel",
	}
	local underbarrel_ammo_part, underbarrel_ammo_part_id, underbarrel_part, underbarrel_part_id = nil

	for id, ammo_data in pairs(underbarrel_shotgun_ammo_types) do
		underbarrel_ammo_part = deep_clone(self.parts[ammo_data.ammo_id])
		underbarrel_ammo_part.name_id = ammo_data.name_id
		underbarrel_ammo_part.type = "underbarrel_ammo"
		underbarrel_ammo_part_id = ammo_data.ammo_id .. "_underbarrel"
		self.parts[underbarrel_ammo_part_id] = underbarrel_ammo_part

		for factory_id, template_id in pairs(underbarrel_shotgun_weapons) do
			underbarrel_part = deep_clone(self.parts[template_id])
			underbarrel_part.name_id = underbarrel_ammo_part.name_id
			underbarrel_part.dlc = underbarrel_ammo_part.dlc
			underbarrel_part.sub_type = underbarrel_ammo_part.sub_type
			underbarrel_part.adds = underbarrel_part.adds or {}

			table.insert(underbarrel_part.adds, underbarrel_ammo_part_id)

			underbarrel_part_id = factory_id .. "_" .. id
			self.parts[underbarrel_part_id] = underbarrel_part

			table.insert(self[factory_id].uses_parts, underbarrel_part_id)
			table.insert(self[factory_id .. "_npc"].uses_parts, underbarrel_part_id)
		end
	end

	-- Split the team boost into two bonuses
	self.parts.wpn_fps_upg_bonus_team_exp = {
		exclude_from_challenge = true,
		texture_bundle_folder = "boost_in_lootdrop",
		internal_part = true,
		a_obj = "a_body",
		third_unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
		desc_id = "bm_wp_upg_bonus_team_exp_desc",
		type = "bonus",
		sub_type = "bonus_team",
		name_id = "bm_wp_upg_bonus_team_exp",
		unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
		has_description = true,
		pcs = {
			10,
			20,
			30,
			40,
		},
		stats = {
			value = 1,
		},
		custom_stats = {
			money_multiplier = 1,
			exp_multiplier = 1.05,
		},
		perks = {
			"bonus",
		},
	}

	self.parts.wpn_fps_upg_bonus_team_money = {
		exclude_from_challenge = true,
		texture_bundle_folder = "boost_in_lootdrop",
		internal_part = true,
		a_obj = "a_body",
		third_unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
		desc_id = "bm_wp_upg_bonus_team_money_desc",
		type = "bonus",
		sub_type = "bonus_team",
		name_id = "bm_wp_upg_bonus_team_money",
		unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
		has_description = true,
		pcs = {
			10,
			20,
			30,
			40,
		},
		stats = {
			value = 1,
		},
		custom_stats = {
			money_multiplier = 1.05,
			exp_multiplier = 1,
		},
		perks = {
			"bonus",
		},
	}
end)

WeaponFactoryTweakData.shotgun_ammo_override_map = {
	["wpn_fps_shot_saiga"] = "very_light",
	["wpn_fps_sho_aa12"] = "very_light",
	["wpn_fps_sho_basset"] = "very_light",
	["wpn_fps_sho_striker"] = "very_light",
	["wpn_fps_sho_ben"] = "light",
	["wpn_fps_sho_spas12"] = "light",
	["wpn_fps_sho_rota"] = "light",
	["wpn_fps_sho_ultima"] = "light",
	["wpn_fps_sho_sko12"] = "light",
	["wpn_fps_shot_r870"] = "medium",
	["wpn_fps_shot_serbu"] = "medium",
	["wpn_fps_sho_ksg"] = "medium",
	["wpn_fps_sho_m590"] = "medium",
	["wpn_fps_pis_judge"] = "heavy",
	["wpn_fps_shot_m37"] = "heavy",
	["wpn_fps_shot_m1897"] = "heavy",
	["wpn_fps_sho_supernova"] = "heavy",
	["wpn_fps_shot_huntsman"] = "very_heavy",
	["wpn_fps_shot_b682"] = "very_heavy",
	["wpn_fps_sho_boot"] = "very_heavy",
	["wpn_fps_sho_coach"] = "very_heavy",
}

-- Automatically balance Shotgun ammo types
function WeaponFactoryTweakData:_balance_shotgun_ammo(tweak_data)
	local slug_stance_muls = {
		spread = {
			standing = {
				hipfire = 1.2,
				crouching = 1,
				steelsight = 0.5,
			},
			moving = {
				hipfire = 1.4,
				crouching = 1,
				steelsight = 1,
			},
		},
		recoil = {
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
	}

	local shotgun_ammo_overrides = {
		wpn_fps_upg_a_custom = {
			very_heavy = { -- double barrels
				stats = { damage = 12, total_ammo_mod = -3, recoil = -3 },
				custom_stats = { rays = 6, ammo_pickup_max_mul = 0.85, ammo_pickup_min_mul = 0.85 },
			},
			heavy = { -- shotguns like gsps and the trench gun
				stats = { damage = 10, total_ammo_mod = -3, recoil = -3 },
				custom_stats = { rays = 6, ammo_pickup_max_mul = 0.85, ammo_pickup_min_mul = 0.85 },
			},
			medium = { -- raven, loco, reinfeld, etc
				stats = { damage = 8, total_ammo_mod = -3, recoil = -3 },
				custom_stats = { rays = 6, ammo_pickup_max_mul = 0.85, ammo_pickup_min_mul = 0.85 },
			},
			light = { -- semi autos
				stats = { damage = 6, total_ammo_mod = -3, recoil = -3 },
				custom_stats = { rays = 6, ammo_pickup_max_mul = 0.85, ammo_pickup_min_mul = 0.85 },
			},
			very_light = { -- full autos
				stats = { damage = 6, total_ammo_mod = -3, recoil = -3 },
				custom_stats = { rays = 6, ammo_pickup_max_mul = 0.85, ammo_pickup_min_mul = 0.85 },
			},
		},
		wpn_fps_upg_a_custom_free = {
			very_heavy = { -- double barrels
				stats = { damage = 12, total_ammo_mod = -2, recoil = -3 },
				custom_stats = { rays = 6, ammo_pickup_max_mul = 0.8, ammo_pickup_min_mul = 0.8 },
			},
			heavy = { -- shotguns like gsps and the trench gun
				stats = { damage = 10, total_ammo_mod = -2, recoil = -3 },
				custom_stats = { rays = 6, ammo_pickup_max_mul = 0.8, ammo_pickup_min_mul = 0.8 },
			},
			medium = { -- raven, loco, reinfeld, etc
				stats = { damage = 8, total_ammo_mod = -2, recoil = -3 },
				custom_stats = { rays = 6, ammo_pickup_max_mul = 0.8, ammo_pickup_min_mul = 0.8 },
			},
			light = { -- semi autos
				stats = { damage = 6, total_ammo_mod = -2, recoil = -3 },
				custom_stats = { rays = 6, ammo_pickup_max_mul = 0.8, ammo_pickup_min_mul = 0.8 },
			},
			very_light = { -- full autos
				stats = { damage = 6, total_ammo_mod = -2, recoil = -3 },
				custom_stats = { rays = 6, ammo_pickup_max_mul = 0.8, ammo_pickup_min_mul = 0.8 },
			},
		},
		wpn_fps_upg_a_explosive = {
			very_heavy = { -- double barrels
				stats = { damage = 216, total_ammo_mod = -8, spread = 2 },
				custom_stats = {
					ignore_statistic = true,
					explosive_ammo = true,
					ammo_pickup_max_mul = 0.4,
					ammo_pickup_min_mul = 0.4,
					stance_mul = slug_stance_muls,
					bullet_class = "InstantExplosiveBulletBase",
					damage_near_mul = 10,
					rays = 1,
				},
			},
			heavy = { -- shotguns like gsps and the trench gun
				stats = { damage = 180, total_ammo_mod = -8, spread = 2 },
				custom_stats = {
					ignore_statistic = true,
					explosive_ammo = true,
					ammo_pickup_max_mul = 0.4,
					ammo_pickup_min_mul = 0.4,
					stance_mul = slug_stance_muls,
					bullet_class = "InstantExplosiveBulletBase",
					damage_near_mul = 10,
					rays = 1,
				},
			},
			medium = { -- raven, loco, reinfeld, etc
				stats = { damage = 144, total_ammo_mod = -8, spread = 2 },
				custom_stats = {
					ignore_statistic = true,
					explosive_ammo = true,
					ammo_pickup_max_mul = 0.4,
					ammo_pickup_min_mul = 0.4,
					stance_mul = slug_stance_muls,
					bullet_class = "InstantExplosiveBulletBase",
					damage_near_mul = 10,
					rays = 1,
				},
			},
			light = { -- semi autos
				stats = { damage = 108, total_ammo_mod = -8, spread = 2 },
				custom_stats = {
					ignore_statistic = true,
					explosive_ammo = true,
					ammo_pickup_max_mul = 0.4,
					ammo_pickup_min_mul = 0.4,
					stance_mul = slug_stance_muls,
					bullet_class = "InstantExplosiveBulletBase",
					damage_near_mul = 10,
					rays = 1,
				},
			},
			very_light = { -- full autos
				stats = { damage = 86, total_ammo_mod = -8, spread = 2 },
				custom_stats = {
					ignore_statistic = true,
					explosive_ammo = true,
					ammo_pickup_max_mul = 0.4,
					ammo_pickup_min_mul = 0.4,
					stance_mul = slug_stance_muls,
					bullet_class = "InstantExplosiveBulletBase",
					damage_near_mul = 10,
					rays = 1,
				},
			},
		},
		wpn_fps_upg_a_slug = {
			very_heavy = { -- double barrels
				stats = { damage = 104, total_ammo_mod = -5, recoil = -2, spread = 4 },
				custom_stats = {
					armor_piercing_add = 1,
					can_shoot_through_shield = true,
					can_shoot_through_wall = true,
					can_shoot_through_enemy = true,
					stance_mul = slug_stance_muls,
					damage_near_mul = 10,
					rays = 1,
					check_additional_achievements = true,
				},
			},
			heavy = { -- shotguns like gsps and the trench gun
				stats = { damage = 76, total_ammo_mod = -5, recoil = -2, spread = 4 },
				custom_stats = {
					armor_piercing_add = 1,
					can_shoot_through_shield = true,
					can_shoot_through_wall = true,
					can_shoot_through_enemy = true,
					stance_mul = slug_stance_muls,
					damage_near_mul = 10,
					rays = 1,
					check_additional_achievements = true,
				},
			},
			medium = { -- raven, loco, reinfeld, etc
				stats = { damage = 64, total_ammo_mod = -5, recoil = -2, spread = 4 },
				custom_stats = {
					armor_piercing_add = 1,
					can_shoot_through_shield = true,
					can_shoot_through_wall = true,
					can_shoot_through_enemy = true,
					stance_mul = slug_stance_muls,
					damage_near_mul = 10,
					rays = 1,
					check_additional_achievements = true,
				},
			},
			light = { -- semi autos
				stats = { damage = 52, total_ammo_mod = -5, recoil = -2, spread = 4 },
				custom_stats = {
					armor_piercing_add = 1,
					can_shoot_through_shield = true,
					can_shoot_through_wall = true,
					can_shoot_through_enemy = true,
					stance_mul = slug_stance_muls,
					damage_near_mul = 10,
					rays = 1,
					check_additional_achievements = true,
				},
			},
			very_light = { -- full autos
				stats = { damage = 38, total_ammo_mod = -5, recoil = -2, spread = 4 },
				custom_stats = {
					armor_piercing_add = 1,
					can_shoot_through_shield = true,
					can_shoot_through_wall = true,
					can_shoot_through_enemy = true,
					stance_mul = slug_stance_muls,
					damage_near_mul = 10,
					rays = 1,
					check_additional_achievements = true,
				},
			},
		},
		wpn_fps_upg_a_piercing = {
			very_heavy = { -- double barrels
				stats = { damage = -12, spread = 2 },
				custom_stats = {
					rays = 12,
					armor_piercing_add = 1,
					can_shoot_through_enemy = true,
				},
			},
			heavy = { -- shotguns like gsps and the trench gun
				stats = { damage = -10, spread = 2 },
				custom_stats = {
					rays = 12,
					armor_piercing_add = 1,
					can_shoot_through_enemy = true,
				},
			},
			medium = { -- raven, loco, reinfeld, etc
				stats = { damage = -8, spread = 2 },
				custom_stats = {
					rays = 12,
					armor_piercing_add = 1,
					can_shoot_through_enemy = true,
				},
			},
			light = { -- semi autos
				stats = { damage = -6, spread = 2 },
				custom_stats = {
					rays = 12,
					armor_piercing_add = 1,
					can_shoot_through_enemy = true,
				},
			},
			very_light = { -- full autos
				stats = { damage = -5, spread = 2 },
				custom_stats = {
					rays = 12,
					armor_piercing_add = 1,
					can_shoot_through_enemy = true,
				},
			},
		},
		wpn_fps_upg_a_dragons_breath = {
			very_heavy = { -- double barrels
				stats = { damage = -14, total_ammo_mod = -6, spread = -2 },
				custom_stats = {
					ammo_pickup_min_mul = 0.8,
					ammo_pickup_max_mul = 0.8,
					armor_piercing_add = 1,
					rays = 12,
					dot_data_name = "ammo_dragons_breath_heavy",
					bullet_class = "FlameBulletBase",
					muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_dragons_breath",
				},
			},
			heavy = { -- shotguns like gsps and the trench gun
				stats = { damage = -12, total_ammo_mod = -6, spread = -2 },
				custom_stats = {
					ammo_pickup_min_mul = 0.8,
					ammo_pickup_max_mul = 0.8,
					armor_piercing_add = 1,
					rays = 12,
					dot_data_name = "ammo_dragons_breath_heavy",
					bullet_class = "FlameBulletBase",
					muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_dragons_breath",
				},
			},
			medium = { -- raven, loco, reinfeld, etc
				stats = { damage = -10, total_ammo_mod = -6, spread = -2 },
				custom_stats = {
					ammo_pickup_min_mul = 0.8,
					ammo_pickup_max_mul = 0.8,
					armor_piercing_add = 1,
					rays = 12,
					dot_data_name = "ammo_dragons_breath_medium",
					bullet_class = "FlameBulletBase",
					muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_dragons_breath",
				},
			},
			light = { -- semi autos
				stats = { damage = -7, total_ammo_mod = -6, spread = -2 },
				custom_stats = {
					ammo_pickup_min_mul = 0.8,
					ammo_pickup_max_mul = 0.8,
					armor_piercing_add = 1,
					rays = 12,
					dot_data_name = "ammo_dragons_breath_light",
					bullet_class = "FlameBulletBase",
					muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_dragons_breath",
				},
			},
			very_light = { -- full autos
				stats = { damage = -6, total_ammo_mod = -6, spread = -2 },
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
				stats = { damage = 72, total_ammo_mod = -8, spread = 2 },
				custom_stats = {
					ammo_pickup_min_mul = 0.6,
					ammo_pickup_max_mul = 0.6,
					armor_piercing_add = 1,
					muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_rip",
					dot_data_name = "ammo_rip_heavy",
					stance_mul = slug_stance_muls,
					damage_near_mul = 10,
					rays = 1,
					bullet_class = "PoisonBulletBase",
				},
			},
			heavy = { -- shotguns like gsps and the trench gun
				stats = { damage = 60, total_ammo_mod = -8, spread = 2 },
				custom_stats = {
					ammo_pickup_min_mul = 0.6,
					ammo_pickup_max_mul = 0.6,
					armor_piercing_add = 1,
					muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_rip",
					dot_data_name = "ammo_rip_heavy",
					stance_mul = slug_stance_muls,
					damage_near_mul = 10,
					rays = 1,
					bullet_class = "PoisonBulletBase",
				},
			},
			medium = { -- raven, loco, reinfeld, etc
				stats = { damage = 48, total_ammo_mod = -8, spread = 2 },
				custom_stats = {
					ammo_pickup_min_mul = 0.6,
					ammo_pickup_max_mul = 0.6,
					armor_piercing_add = 1,
					muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_rip",
					dot_data_name = "ammo_rip_medium",
					stance_mul = slug_stance_muls,
					damage_near_mul = 10,
					rays = 1,
					bullet_class = "PoisonBulletBase",
				},
			},
			light = { -- semi autos
				stats = { damage = 36, total_ammo_mod = -8, spread = 2 },
				custom_stats = {
					ammo_pickup_min_mul = 0.6,
					ammo_pickup_max_mul = 0.6,
					armor_piercing_add = 1,
					muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_rip",
					dot_data_name = "ammo_rip_light",
					stance_mul = slug_stance_muls,
					damage_near_mul = 10,
					rays = 1,
					bullet_class = "PoisonBulletBase",
				},
			},
			very_light = { -- full autos
				stats = { damage = 26, total_ammo_mod = -8, spread = 2 },
				custom_stats = {
					ammo_pickup_min_mul = 0.6,
					ammo_pickup_max_mul = 0.6,
					armor_piercing_add = 1,
					muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_rip",
					dot_data_name = "ammo_rip_light",
					stance_mul = slug_stance_muls,
					damage_near_mul = 10,
					rays = 1,
					bullet_class = "PoisonBulletBase",
				},
			},
		},
	}

	local upgrade_definitions = tweak_data.upgrades.definitions
	for weap_id, weap_data in pairs(upgrade_definitions) do
		local factory_id = weap_data.factory_id

		local weapon_tweak = tweak_data.weapon and tweak_data.weapon[weap_id]

		local based_on
		local based_on_weapon_id
		local based_on_factory_id
		if weapon_tweak and weapon_tweak.custom then
			based_on = weapon_tweak.based_on

			if based_on then
				based_on_weapon_id = tweak_data.upgrades.definitions[based_on].weap_id
				based_on_factory_id = tweak_data.upgrades.definitions[based_on].factory_id
			end
		end

		for part_id, part_data in pairs(self.parts) do
			local ammo_override = self.shotgun_ammo_override_map[based_on_factory_id or factory_id] or "medium"

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

WeaponFactoryTweakData.grenade_launcher_ammo_override_map = {
	["wpn_fps_gre_arbiter"] = "light",
	["wpn_fps_gre_ms3gl"] = "light",
	["wpn_fps_gre_m32"] = "medium",
	["wpn_fps_gre_china"] = "medium",
	["wpn_fps_gre_m79"] = "heavy",
	["wpn_fps_gre_slap"] = "heavy",
	["wpn_fps_ass_contraband"] = "heavy",
	["wpn_fps_ass_groza"] = "heavy",
}

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

	local upgrade_definitions = tweak_data.upgrades.definitions
	for weap_id, weap_data in pairs(upgrade_definitions) do
		local factory_id = weap_data.factory_id

		local weapon_tweak = tweak_data.weapon and tweak_data.weapon[weap_id]

		local based_on
		local based_on_weapon_id
		local based_on_factory_id
		if weapon_tweak and weapon_tweak.custom then
			based_on = weapon_tweak.based_on

			if based_on then
				based_on_weapon_id = tweak_data.upgrades.definitions[based_on].weap_id
				based_on_factory_id = tweak_data.upgrades.definitions[based_on].factory_id
			end
		end

		for part_id, part_data in pairs(self.parts) do
			local ammo_override = self.grenade_launcher_ammo_override_map[based_on_factory_id or factory_id] or "medium"

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
	local upgrade_definitions = tweak_data.upgrades.definitions

	for weap_id, weap_data in pairs(upgrade_definitions) do
		local factory_id = weap_data.factory_id

		local weapon_tweak = tweak_data.weapon and tweak_data.weapon[weap_id]
		local is_akimbo = weapon_tweak and table.contains(weapon_tweak.categories, "akimbo")

		local shotgun_reload = weapon_tweak and weapon_tweak.use_shotgun_reload or weapon_tweak and weapon_tweak.timers and weapon_tweak.timers.shotgun_reload_shell or nil
		local mag_capacity = weapon_tweak and weapon_tweak.CLIP_AMMO_MAX

		if not is_akimbo then
			for part_id, part_data in pairs(self.parts) do
				if part_data and not part_data.no_magazine_balancing then
					if self[factory_id] and table.contains(self[factory_id].uses_parts, part_id) then
						local extra_ammo_stat = part_data.stats and part_data.stats.extra_ammo
						local ammo_offset_stat = part_data.custom_stats and part_data.custom_stats.ammo_offset
						if extra_ammo_stat or ammo_offset_stat then
							-- Wipe overrides of weapon parts just in case.
							-- Use the "no_override_wipe" flag for any edge cases
							if not part_data.no_override_wipe and self[factory_id].override and self[factory_id].override[part_id] then
								self[factory_id].override[part_id].stats = self.parts[part_id].stats or {}
								self[factory_id].override[part_id].custom_stats = self.parts[part_id].custom_stats or {}
							end

							if part_data.stats and not part_data.is_supported then
								if mag_capacity and not shotgun_reload then
									local mod_mag_capacity = (2 * (extra_ammo_stat or 0)) + (ammo_offset_stat or 0)
									local capacity_increase = (mod_mag_capacity / mag_capacity) * 100

									local reload_speed_stat = -math.clamp(math.floor(capacity_increase / 30), -10, 10)
									local concealment_stat = -math.clamp(math.ceil(capacity_increase / 30), -6, 6)
									local spread_stat = capacity_increase >= 100 and -math.clamp(math.floor(capacity_increase / 60), 0, 5) or 0

									part_data.stats.reload = 0
									part_data.stats.recoil = 0
									part_data.stats.spread = spread_stat
									part_data.stats.reload = shotgun_reload and 0 or reload_speed_stat
									part_data.stats.concealment = concealment_stat
									part_data.is_supported = true
								end
							end
						end
					end
				end
			end
		end
	end
end

-- Automatically create magazine stat overrides for akimbo weapons
function WeaponFactoryTweakData:_balance_akimbo(tweak_data)
	local upgrade_definitions = tweak_data.upgrades.definitions

	for weap_id, weap_data in pairs(upgrade_definitions) do
		local factory_id = weap_data.factory_id

		local akimbo_single_map = {}
		for k, v in pairs(tweak_data.weapon:get_akimbo_mappings()) do
			akimbo_single_map[v] = k
		end

		local weapon_tweak = tweak_data.weapon and tweak_data.weapon[weap_id]
		local is_akimbo = weapon_tweak and table.contains(weapon_tweak.categories, "akimbo")

		if is_akimbo then
			if self[factory_id] then
				local akimbo_uses_parts = self[factory_id].uses_parts
				local single_id = akimbo_single_map[weap_id]
				local single_factory_id = single_id and upgrade_definitions[single_id] and upgrade_definitions[single_id].factory_id
				local single_uses_parts = single_factory_id and self[single_factory_id].uses_parts

				if not self[factory_id].override then
					self[factory_id].override = {}
				end

				for part_id, part_data in pairs(self.parts) do
					if akimbo_uses_parts and table.contains(akimbo_uses_parts, part_id) and single_uses_parts and table.contains(single_uses_parts, part_id) then
						local is_default_part = table.contains(self[factory_id].default_blueprint, part_id)

						if part_data.type == "magazine" and not is_default_part then
							if not self[factory_id].override[part_id] then
								self[factory_id].override[part_id] = {}
							end

							if part_data.stats then
								self[factory_id].override[part_id].stats = deep_clone(part_data.stats)

								if part_data.stats.extra_ammo then
									self[factory_id].override[part_id].stats.extra_ammo = part_data.stats.extra_ammo * 2
								end
							end

							if part_data.custom_stats then
								self[factory_id].override[part_id].custom_stats = deep_clone(part_data.custom_stats)

								if part_data.custom_stats.ammo_offset then
									self[factory_id].override[part_id].custom_stats.ammo_offset = part_data.custom_stats.ammo_offset * 2
								end
							end
						end
					end
				end
			end
		end
	end
end

WeaponFactoryTweakData.conversion_parts = {
	wpn_fps_upg_ass_m4_b_beowulf = true,
	wpn_fps_upg_ass_ak_b_zastava = true,
	wpn_fps_smg_mp5_m_straight = true,
	wpn_fps_pis_korth_m_6 = true,
}
WeaponFactoryTweakData.conversion_balancing_whitelist = {
	exclusive_set = true,
}

-- Automatically balance conversion kits based on damage
function WeaponFactoryTweakData:_balance_conversions(tweak_data)
	local upgrade_definitions = tweak_data.upgrades.definitions

	local function calculate_real_damage(value, modifier)
		return value and modifier * tweak_data.weapon.stats.damage[math.min(value, #tweak_data.weapon.stats.damage)] or 0
	end

	local function calculate_total_ammo_stat(value)
		return value and math.ceil(math.min(value / 0.05, #tweak_data.weapon.stats.total_ammo_mod)) or 0
	end

	for weap_id, weap_data in pairs(upgrade_definitions) do
		local factory_id = weap_data.factory_id
		local weapon_tweak = tweak_data.weapon and tweak_data.weapon[weap_id]

		if weapon_tweak then
			local dmg_modifier = weapon_tweak.stats_modifiers and weapon_tweak.stats_modifiers.damage or 1
			local weap_dmg_stat = weapon_tweak.stats and weapon_tweak.stats.damage or 1

			for part_id, part_data in pairs(self.parts) do
				if part_data and not part_data.no_conversion_balancing then
					if self[factory_id] and table.contains(self[factory_id].uses_parts, part_id) then
						local part_type = part_data.type
						if self.conversion_parts[part_id] or self.conversion_balancing_whitelist[part_type] then
							local part_dmg_stat = part_data.stats and part_data.stats.damage or 0
							local weap_real_dmg = math.min(weap_dmg_stat, #tweak_data.weapon.stats.damage) * dmg_modifier
							local part_real_dmg = math.min(weap_dmg_stat + part_dmg_stat * dmg_modifier, #tweak_data.weapon.stats.damage) * dmg_modifier
							local damage_ratio = weap_real_dmg / part_real_dmg

							local pickup_stat = damage_ratio
							local total_ammo_stat = -calculate_total_ammo_stat(1 - damage_ratio)

							local part_override = self[factory_id].override and self[factory_id].override[part_id]
							if part_override then
								if not part_override.stats then
									part_override.stats = {}
								end

								part_override.stats.total_ammo_mod = total_ammo_stat

								if not part_override.custom_stats then
									part_override.custom_stats = {}
								end

								part_override.custom_stats.ammo_pickup_max_mul = pickup_stat
								part_override.custom_stats.ammo_pickup_min_mul = part_override.custom_stats.ammo_pickup_max_mul
							else
								part_data.stats.total_ammo_mod = total_ammo_stat
								part_data.custom_stats.ammo_pickup_max_mul = pickup_stat
								part_data.custom_stats.ammo_pickup_min_mul = part_data.custom_stats.ammo_pickup_max_mul
							end
						end
					end
				end
			end
		end
	end
end

-- Automatically balance underbarrel weapon stats based on concealment
function WeaponFactoryTweakData:_balance_underbarrels(tweak_data)
	local upgrade_definitions = tweak_data.upgrades.definitions

	local function calculate_total_ammo_stat(value)
		return value and math.floor(math.ceil(value / 0.05, #tweak_data.weapon.stats.total_ammo_mod)) or 0
	end

	for weap_id, weap_data in pairs(upgrade_definitions) do
		local factory_id = weap_data.factory_id
		local weapon_tweak = tweak_data.weapon and tweak_data.weapon[weap_id]

		if weapon_tweak and self[factory_id] then
			if not self[factory_id].override then
				self[factory_id].override = {}
			end

			for part_id, part_data in pairs(self.parts) do
				if part_data and not part_data.no_underbarrel_balanacing then
					local is_underbarrel = part_data.perks and table.contains(part_data.perks, "underbarrel")

					if is_underbarrel then
						local weap_total_ammo = weapon_tweak.AMMO_MAX
						local underbarrel_total_ammo = math.round(weap_total_ammo / 2, weapon_tweak.CLIP_AMMO_MAX)
						local total_ammo_mod_stat = -calculate_total_ammo_stat(1 - underbarrel_total_ammo / weap_total_ammo)

						if not self[factory_id].override[part_id] then
							self[factory_id].override[part_id] = {}
						end

						self[factory_id].override[part_id].stats = deep_clone(part_data.stats)
						self[factory_id].override[part_id].stats.total_ammo_mod = total_ammo_mod_stat
					end
				end
			end
		end
	end
end

-- Automatically balance suppressor stats based on concealment
function WeaponFactoryTweakData:_balance_silencers()
	for part_id, part_data in pairs(self.parts) do
		if part_data and not part_data.no_silencer_balancing then
			local is_barrel_ext = part_data.type and part_data.type == "barrel_ext"
			local is_silencer = part_data.perks and table.contains(part_data.perks, "silencer")

			if is_silencer and part_data.stats then
				part_data.stats.suppression = 12
				part_data.stats.alert_size = 10

				if part_data.stats.concealment and is_barrel_ext then
					part_data.stats.damage = -math.max(4 + part_data.stats.concealment, 0)
				end
			end
		end
	end
end

-- Kind of hacky, but it works
Hooks:PostHook(WeaponFactoryTweakData, "_add_charms_to_all_weapons", "eclipse_add_charms_to_all_weapons", function(self, tweak_data)
	self:_add_parts_to_all(tweak_data)
	self:_add_parts_from_template(tweak_data)
	self:_balance_shotgun_ammo(tweak_data)
	self:_balance_launcher_ammo(tweak_data)
	self:_balance_magazines(tweak_data)
	self:_balance_akimbo(tweak_data)
	self:_balance_conversions(tweak_data)
	self:_balance_underbarrels(tweak_data)
	self:_balance_silencers()
end)

-- Remove weapon boosts
function WeaponFactoryTweakData:create_bonuses() end

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
