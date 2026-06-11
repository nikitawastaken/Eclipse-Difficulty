WeaponFactoryTweakData.category_templates = {
	assault_rifle = "amcar",
	dmr = "new_m14",
	pistol = "glock_17",
	revolver = "new_raging_bull",
	smg = "new_mp5",
	shotgun = "r870",
	lmg = "m249",
	minigun = "m134",
	snp = "msr",
}
WeaponFactoryTweakData.part_type_stat_blacklist = {
	body = true,
	bolt = true,
	drag_handle = true,
	exclusive_set = true,
	extra = true,
	foregrip = true,
	gadget = true,
	grip = true,
	lower_body = true,
	lower_reciever = true,
	slide = true,
	stock = true,
	upper_reciever = true,
	vertical_grip = true,
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

function WeaponFactoryTweakData:_get_table_from_category_template(tweak_data, category, tbl)
	local cat_template_id = self.category_templates[category]

	return cat_template_id and tweak_data.weapon and tweak_data.weapon[cat_template_id] and tweak_data.weapon[cat_template_id][tbl] or {}
end

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

function WeaponFactoryTweakData:_add_parts_from_list(weap_list, part_list)
	for _, weap_id in pairs(weap_list) do
		for _, part_id in pairs(part_list) do
			if not table.contains(self[weap_id].default_blueprint, part_id) then
				if not table.contains(self[weap_id].uses_parts, part_id) then
					table.insert(self[weap_id].uses_parts, part_id)
					table.insert(self[weap_id .. "_npc"].uses_parts, part_id)
				end
			end
		end
	end
end

function WeaponFactoryTweakData:_add_forbids_from_list(part_id, part_list)
	if not self.parts[part_id].forbids then
		self.parts[part_id].forbids = {}
	end

	for _, forbid_id in pairs(part_list) do
		if not table.contains(self.parts[part_id].forbids, forbid_id) then
			table.insert(self.parts[part_id].forbids, forbid_id)
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

function WeaponFactoryTweakData:_create_part_type_list(list, factory_id, part_type)
	if self[factory_id] and self[factory_id].uses_parts then
		for _, part_id in pairs(self[factory_id].uses_parts) do
			local part_data = self.parts and self.parts[part_id]
			local default_part = table.contains(self[factory_id].default_blueprint, part_id)
			local is_type = part_data and part_data.type and part_data.type == part_type

			if is_type and not default_part then
				table.insert(list, part_id)
			end
		end
	end
end

function WeaponFactoryTweakData:_wipe_stats(part_list)
	local dummy_part_tbl = { value = 1 }
	if type(part_list) == "table" then
		for _, part_id in pairs(part_list) do
			if self.parts[part_id] then
				self.parts[part_id].stats = deep_clone(dummy_part_tbl)
				self.parts[part_id].custom_stats = {}
			end
		end
	end
end

Hooks:PostHook(WeaponFactoryTweakData, "init", "eclipse_init", function(self)
	for k, v in pairs(self.parts) do
		if not v.stats then
			v.stats = {}
		end

		if not v.custom_stats then
			v.custom_stats = {}
		end

		local is_default_part = not v.pcs
		local zoom_level = v.stats.zoom
		local is_sight = v.type and v.type == "sight"
		local is_second_sight = v.perks and table.contains(v.perks, "second_sight")
		local is_piggyback = is_second_sight and v.type == "extra"
		local is_magnifier = is_second_sight and not is_piggyback
		local is_optic = is_sight and v.perks and table.contains(v.perks, "scope")
		local is_magazine = v.type and v.type == "magazine"
		local is_silencer = v.perks and table.contains(v.perks, "silencer")

		if self.part_type_stat_blacklist[v.type] and not is_second_sight then
			v.stats = {}
			v.custom_stats = {}
		end

		if v.sub_type == "ammo_explosive" then
			v.custom_stats.explosive_ammo = true
		end

		if v.stats.suppression then
			v.stats.suppression = 0
		end

		if v.stats.spread_moving then
			v.stats.spread_moving = 0
		end

		if v.stats.damage and not v.no_damage_scaling then
			v.stats.damage = math.round(v.stats.damage / 2.5)
		end

		if is_optic and not is_default_part then
			v.stats.recoil = 1
			v.stats.spread = 0
			v.stats.concealment = -1
		end

		if is_magnifier then
			v.stats.recoil = 0
			v.stats.spread = 0
			v.stats.concealment = 0
		end

		if is_magazine and (k:match("_quick$") or k:match("_speed$") or k:match("_strap$")) then
			v.stats = {}
			v.stats.value = 1
			v.stats.reload = 1
			v.stats.concealment = -1
		end

		if k:match("_legend") then
			v.stats = {}
			v.custom_stats = {}
		end
	end

	-- Create lists of available barrel extensions for different weapon types
	local rifle_barrel_exts = {}
	self:_create_part_type_list(rifle_barrel_exts, "wpn_fps_ass_m4", "barrel_ext")

	local pistol_barrel_exts = {}
	self:_create_part_type_list(pistol_barrel_exts, "wpn_fps_pis_g17", "barrel_ext")

	local shotgun_barrel_exts = {}
	self:_create_part_type_list(shotgun_barrel_exts, "wpn_fps_shot_r870", "barrel_ext")

	local rifle_sights = {}
	self:_create_part_type_list(rifle_sights, "wpn_fps_ass_m4", "sight")

	local rifle_second_sights = {}
	self:_create_part_type_list(rifle_second_sights, "wpn_fps_ass_m4", "second_sight")

	local pistol_sights = {}
	self:_create_part_type_list(pistol_sights, "wpn_fps_pis_g17", "sight")

	local snp_sights = {}
	self:_create_part_type_list(snp_sights, "wpn_fps_snp_msr", "sight")

	-- Add/remove parts
	table.delete(self.wpn_fps_ass_contraband.uses_parts, "wpn_fps_sho_sko12_body_grip")
	table.delete(self.wpn_fps_ass_m16.uses_parts, "wpn_fps_uupg_fg_radian")

	table.delete(self.wpn_fps_sho_sko12.uses_parts, "wpn_fps_upg_i_singlefire")
	table.delete(self.wpn_fps_sho_sko12.uses_parts, "wpn_fps_upg_i_autofire")

	table.delete(self.wpn_fps_ass_tecci.uses_parts, "wpn_fps_upg_i_singlefire")
	table.delete(self.wpn_fps_ass_tecci.uses_parts, "wpn_fps_upg_i_autofire")

	table.insert(self.wpn_fps_ass_shak12.uses_parts, "wpn_fps_upg_i_singlefire")
	table.insert(self.wpn_fps_ass_shak12.uses_parts, "wpn_fps_upg_i_autofire")

	table.insert(self.wpn_fps_ass_ak5.uses_parts, "wpn_fps_upg_ak_ns_zenitco")
	table.insert(self.wpn_fps_shot_saiga.uses_parts, "wpn_fps_upg_ak_ns_zenitco")

	-- Akimbo SMG default blueprints
	table.delete(self.wpn_fps_smg_x_mac10.default_blueprint, "wpn_fps_smg_mac10_s_fold")
	table.insert(self.wpn_fps_smg_x_mac10.default_blueprint, "wpn_fps_smg_mac10_s_fold2")
	table.delete(self.wpn_fps_smg_x_mac10.uses_parts, "wpn_fps_smg_mac10_s_fold")
	table.delete(self.wpn_fps_smg_x_mac10.uses_parts, "wpn_fps_smg_mac10_s_skel")

	table.delete(self.wpn_fps_smg_x_sr2.uses_parts, "wpn_fps_smg_sr2_s_unfolded")

	table.insert(self.wpn_fps_lmg_rpk.uses_parts, "wpn_fps_upg_o_ak_scopemount")

	-- LMG STEELSIGHTS START

	-- Separate the rear sight from the M60's body part
	self.parts.wpn_fps_lmg_m60_o_standard = {
		a_obj = "a_body",
		type = "sight",
		name_id = "bm_wp_m4_lower_reciever",
		unit = "units/pd2_dlc_atw/weapons/wpn_fps_lmg_m60_pts/wpn_fps_lmg_m60_body_standard",
		stats = {
			value = 1,
		},
		forbids = {
			"wpn_fps_upg_o_xpsg33_magnifier",
			"wpn_fps_upg_o_45rds",
			"wpn_fps_upg_o_45rds_v2",
			"wpn_fps_upg_o_sig",
			"wpn_fps_upg_o_45steel",
		},
		visibility = {
			{
				objects = {
					g_grip = false,
					g_lower = false,
					g_stock = false,
				},
			},
		},
	}
	self.parts.wpn_fps_lmg_m60_body_standard.visibility = {
		{
			objects = {
				g_sight = false,
			},
		},
	}
	table.insert(self.wpn_fps_lmg_m60.default_blueprint, "wpn_fps_lmg_m60_o_standard")
	table.insert(self.wpn_fps_lmg_m60.uses_parts, "wpn_fps_lmg_m60_o_standard")

	local lmg_sights = clone(rifle_sights)

	for _, part_id in pairs(rifle_second_sights) do
		table.insert(lmg_sights, part_id)
	end

	local sightless_lmgs = {
		"wpn_fps_lmg_rpk",
		"wpn_fps_lmg_hk21",
		"wpn_fps_lmg_m249",
		--	"wpn_fps_lmg_mg42",
		"wpn_fps_lmg_par",
		"wpn_fps_lmg_m60",
	}
	for _, factory_id in pairs(sightless_lmgs) do
		if not self[factory_id].adds then
			self[factory_id].adds = {}
		end

		if not self[factory_id].override then
			self[factory_id].override = {}
		end
	end

	-- Add LMG sights and sight gadgets
	self:_add_parts_from_list(sightless_lmgs, lmg_sights)

	for _, part_id in pairs(lmg_sights) do
		local part_data = self.parts[part_id]

		if not part_data then
			break
		end

		-- Make sure each sight in the auto-generated table has a stance_mod table
		if not self.parts[part_id].stance_mod then
			self.parts[part_id].stance_mod = {}
		end

		local is_second_sight = part_data.type == "second_sight"
		local is_magnifier = is_second_sight and part_data.a_obj == "a_magnifier"
		local is_canted_sight = is_second_sight and not is_magnifier

		-- Set stances for each sight
		if is_magnifier then
			part_data.stance_mod.wpn_fps_lmg_rpk = {
				translation = Vector3(0, 6, -3),
			}
			part_data.stance_mod.wpn_fps_lmg_hk21 = {
				translation = Vector3(0, 6, -3.2),
			}
			part_data.stance_mod.wpn_fps_lmg_m249 = {
				translation = Vector3(0, 6, -3.4),
			}
			part_data.stance_mod.wpn_fps_lmg_par = {
				translation = Vector3(0, 6, -3.2),
			}
			part_data.stance_mod.wpn_fps_lmg_mg42 = {
				translation = Vector3(0, 6, -1.75),
			}
			part_data.stance_mod.wpn_fps_lmg_m60 = {
				translation = Vector3(0.1, 6, 0), --
			}
		elseif is_canted_sight then
			part_data.stance_mod.wpn_fps_lmg_rpk = {
				translation = Vector3(0, 0, -11.15),
				rotation = Rotation(0, 0, -45),
			}
			part_data.stance_mod.wpn_fps_lmg_hk21 = {
				translation = Vector3(-2.75, 0, -11.15),
				rotation = Rotation(0, 0, -45),
			}
			part_data.stance_mod.wpn_fps_lmg_m249 = {
				translation = Vector3(0.300, -1, -12.7),
				rotation = Rotation(0, 0, -45),
			}
			part_data.stance_mod.wpn_fps_lmg_par = {
				translation = Vector3(-2.45, -4, -13.15),
				rotation = Rotation(0, 0, -45),
			}
			part_data.stance_mod.wpn_fps_lmg_mg42 = {
				translation = Vector3(0.85, 0, -11.9),
				rotation = Rotation(0, 0, -45),
			}
			part_data.stance_mod.wpn_fps_lmg_m60 = {
				translation = Vector3(-2.75, 0, -11.15),
				rotation = Rotation(0, 0, -45),
			}
		else
			part_data.stance_mod.wpn_fps_lmg_rpk = {
				translation = Vector3(0, 0, -3),
			}
			part_data.stance_mod.wpn_fps_lmg_hk21 = {
				translation = Vector3(0, -0, -3.2),
			}
			part_data.stance_mod.wpn_fps_lmg_m249 = {
				translation = Vector3(0, -1, -3.4),
			}
			part_data.stance_mod.wpn_fps_lmg_par = {
				translation = Vector3(0, 8, -3.2),
			}
			part_data.stance_mod.wpn_fps_lmg_mg42 = {
				translation = Vector3(0, 12, -1.75),
			}
			part_data.stance_mod.wpn_fps_lmg_m60 = {
				translation = Vector3(0.1, 8, -1.25),
			}
		end

		-- Remove any magnifier gadgets from the RPK specifically to avoid very nasty clipping
		if is_magnifier and table.contains(self.wpn_fps_lmg_rpk.uses_parts, part_id) then
			table.delete(self.wpn_fps_lmg_rpk.uses_parts, part_id)
		end

		-- Add rails and mounts
		self.wpn_fps_lmg_rpk.adds[part_id] = { "wpn_fps_ak_extra_ris" }
		self.wpn_fps_lmg_hk21.adds[part_id] = { "wpn_fps_ass_g3_body_rail" }
		self.wpn_fps_lmg_mg42.adds[part_id] = { "wpn_fps_snp_scout_o_rail" }
		self.wpn_fps_lmg_m60.adds[part_id] = { "wpn_fps_snp_scout_o_rail" }

		-- Create dummy parts to properly parent sights
		self.parts.wpn_fps_upg_o_ak_scopemount_rpk_dummy = {
			type = "jerome_o_sm",
			name_id = "none",
			unit = "units/payday2/weapons/wpn_fps_ass_74/wpn_fps_ass_74",
			stats = {
				value = 1,
			},
		}
		self.parts.wpn_fps_lmg_m249_sight_dummy = {
			a_obj = "a_upper",
			type = "jerome_upper_reciever",
			name_id = "none",
			unit = "units/pd2_dlc_gage_lmg/weapons/wpn_fps_lmg_m249_pts/wpn_fps_lmg_m249_sight_dummy",
			stats = {
				value = 1,
			},
			animations = {
				reload_not_empty = "reload_not_empty",
				reload = "reload",
			},
		}
		self.parts.wpn_fps_lmg_mg42_sight_dummy = {
			a_obj = "a_body",
			type = "jerome_lower_reciever",
			name_id = "none",
			unit = "units/pd2_dlc_gage_historical/weapons/wpn_fps_lmg_mg42_pts/wpn_fps_lmg_mg42_sight_dummy",
			stats = {
				value = 1,
			},
			animations = {
				reload_not_empty = "reload_not_empty",
				reload = "reload",
			},
		}
		self.parts.wpn_fps_lmg_par_sight_dummy = {
			a_obj = "a_upper",
			type = "jerome_upper_reciever",
			name_id = "none",
			unit = "units/pd2_dlc_par/weapons/wpn_fps_lmg_par_pts/wpn_fps_lmg_par_sight_dummy",
			stats = {
				value = 1,
			},
			animations = {
				reload_not_empty = "reload_not_empty",
				reload = "reload",
			},
		}
		self.parts.wpn_fps_lmg_m60_sight_dummy = {
			a_obj = "a_lid",
			type = "jerome_upper_reciever",
			name_id = "none",
			unit = "units/pd2_dlc_atw/weapons/wpn_fps_lmg_m60_pts/wpn_fps_lmg_m60_sight_dummy",
			stats = {
				value = 1,
			},
			animations = {
				reload_not_empty = "reload_not_empty",
				reload = "reload",
			},
		}

		-- Additional weapon-specific overrides

		--		self.wpn_fps_lmg_mg42.override.wpn_fps_snp_scout_o_rail = { a_obj = "a_o_parented", parent = "jerome_lower_reciever" }
		self.wpn_fps_lmg_m60.override.wpn_fps_snp_scout_o_rail = { a_obj = "a_o_parented", parent = "jerome_upper_reciever" }

		-- RPK
		if not self.wpn_fps_lmg_rpk.override.wpn_fps_upg_o_ak_scopemount then
			self.wpn_fps_lmg_rpk.override.wpn_fps_upg_o_ak_scopemount = {}
			self.wpn_fps_lmg_rpk.override.wpn_fps_upg_o_ak_scopemount.override = {}
			self.wpn_fps_lmg_rpk.override.wpn_fps_upg_o_ak_scopemount.adds = { "wpn_fps_upg_o_ak_scopemount_rpk_dummy" }
		end

		if not is_magnifier then
			self.wpn_fps_lmg_rpk.override.wpn_fps_upg_o_ak_scopemount.override[part_id] = {
				a_obj = "a_o_sm",
				parent = "jerome_o_sm",
				stance_mod = {
					wpn_fps_lmg_rpk = { translation = Vector3(0, 10, -4.6) },
				},
			}

			-- KSP
			self.wpn_fps_lmg_m249.override[part_id] = self.wpn_fps_lmg_m249.override[part_id] or {}
			self.wpn_fps_lmg_m249.override[part_id].a_obj = "a_o_parented"
			self.wpn_fps_lmg_m249.override[part_id].parent = "jerome_upper_reciever"
			self.wpn_fps_lmg_m249.override[part_id].adds = self.parts[part_id].adds and deep_clone(self.parts[part_id].adds) or {}
			table.insert(self.wpn_fps_lmg_m249.override[part_id].adds, "wpn_fps_lmg_m249_sight_dummy")

			--[[Buzzsaw
			self.wpn_fps_lmg_mg42.override[part_id] = self.wpn_fps_lmg_mg42.override[part_id] or {}
			self.wpn_fps_lmg_mg42.override[part_id].a_obj = "a_o_parented"
			self.wpn_fps_lmg_mg42.override[part_id].parent = "jerome_lower_reciever"
			self.wpn_fps_lmg_mg42.override[part_id].adds = self.parts[part_id].adds and deep_clone(self.parts[part_id].adds) or {}
			table.insert(self.wpn_fps_lmg_mg42.override[part_id].adds, "wpn_fps_lmg_mg42_sight_dummy")
			]]

			-- KSP 58
			self.wpn_fps_lmg_par.override[part_id] = self.wpn_fps_lmg_par.override[part_id] or {}
			self.wpn_fps_lmg_par.override[part_id].a_obj = "a_o_parented"
			self.wpn_fps_lmg_par.override[part_id].parent = "jerome_upper_reciever"
			self.wpn_fps_lmg_par.override[part_id].adds = self.parts[part_id].adds and deep_clone(self.parts[part_id].adds) or {}
			table.insert(self.wpn_fps_lmg_par.override[part_id].adds, "wpn_fps_lmg_par_sight_dummy")

			-- M60
			self.wpn_fps_lmg_m60.override[part_id] = self.wpn_fps_lmg_m60.override[part_id] or {}
			self.wpn_fps_lmg_m60.override[part_id].a_obj = "a_o_parented"
			self.wpn_fps_lmg_m60.override[part_id].parent = "jerome_upper_reciever"
			self.wpn_fps_lmg_m60.override[part_id].forbids = self.parts[part_id].forbids and deep_clone(self.parts[part_id].forbids) or {}
			table.insert(self.wpn_fps_lmg_m60.override[part_id].forbids, "wpn_fps_lmg_m60_o_standard")
			self.wpn_fps_lmg_m60.override[part_id].adds = self.parts[part_id].adds and deep_clone(self.parts[part_id].adds) or {}
			table.insert(self.wpn_fps_lmg_m60.override[part_id].adds, "wpn_fps_lmg_m60_sight_dummy")
		end
	end

	-- LMG Steelsights END

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

	self.parts.wpn_fps_upg_ak_b_draco.stats.damage = 0
	self.parts.wpn_fps_upg_ak_b_draco.stats.concealment = 2

	self.parts.wpn_fps_upg_ak_b_ak105.stats.damage = 0
	self.parts.wpn_fps_upg_ak_b_ak105.stats.spread = -1

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

	self.parts.wpn_fps_smg_hajk_b_medium.stats.spread = -1
	self.parts.wpn_fps_smg_hajk_b_medium.stats.concealment = 1

	self.parts.wpn_fps_smg_hajk_b_short.stats.spread = -2
	self.parts.wpn_fps_smg_hajk_b_short.stats.concealment = 2

	self.parts.wpn_fps_ass_corgi_b_short.stats.concealment = 2

	self:_add_parts_from_list({ "wpn_fps_ass_asval" }, rifle_barrel_exts)

	self.parts.wpn_fps_ass_asval_b_proto_switch = deep_clone(self.parts.wpn_fps_snp_awp_conversion_dragonlore_switch)
	self.parts.wpn_fps_ass_asval_b_proto_switch.custom_stats = {
		sounds = {
			stop_fire = "akm_stop",
			fire = "akm_fire_single",
			fire_single = "akm_fire_single",
			fire_auto = "akm_fire",
		},
	}

	self.parts.wpn_fps_ass_asval_b_proto.perks = nil
	self.parts.wpn_fps_ass_asval_b_proto.sub_type = nil
	self.parts.wpn_fps_ass_asval_b_proto.sound_switch = nil
	self.parts.wpn_fps_ass_asval_b_proto.stats.alert_size = 0
	self.parts.wpn_fps_ass_asval_b_proto.stats.suppression = 0
	self.parts.wpn_fps_ass_asval_b_proto.adds = {
		"wpn_fps_ass_asval_b_proto_switch",
	}

	self.parts.wpn_fps_ass_asval_b_standard_dummy = deep_clone(self.parts.wpn_fps_smg_mp9_b_dummy) -- I hate that this is how I had to do it
	self.parts.wpn_fps_ass_asval_b_standard.adds = { "wpn_fps_ass_asval_b_standard_dummy" }

	self:_add_forbids_from_list("wpn_fps_ass_asval_b_standard_dummy", rifle_barrel_exts)

	-- DMR Mods
	self:_wipe_stats({
		"wpn_fps_ass_galil_fg_fab",
		"wpn_fps_ass_galil_fg_mar",
		"wpn_fps_ass_galil_fg_sar",
		--		"wpn_fps_ass_galil_fg_sniper",
	})

	self.parts.wpn_fps_ass_scar_b_short.stats.spread = -2
	self.parts.wpn_fps_ass_scar_b_short.stats.concealment = 2

	self.parts.wpn_fps_ass_scar_b_long.stats.concealment = -2

	self.parts.wpn_fps_ass_sub2000_fg_suppressed.stats.spread = -2
	self.parts.wpn_fps_ass_sub2000_fg_suppressed.stats.concealment = 1

	self:_wipe_stats({
		"wpn_fps_ass_fal_fg_03",
		"wpn_fps_ass_fal_fg_04",
		"wpn_fps_ass_fal_fg_wood",
		--		"wpn_fps_ass_fal_fg_01",
	})

	self.parts.wpn_fps_ass_fal_fg_01.stats.spread = -3
	self.parts.wpn_fps_ass_fal_fg_01.stats.concealment = 3

	self.parts.wpn_fps_ass_contraband_o_standard.stats.recoil = 0
	self.parts.wpn_fps_ass_contraband_o_standard.stats.concealment = 0

	self.parts.wpn_fps_ass_ching_b_short.stats.spread = -3
	self.parts.wpn_fps_ass_ching_b_short.stats.concealment = 3

	-- Pistol mods

	-- Wipe iron sight stats
	self:_wipe_stats({
		"wpn_upg_o_marksmansight_rear",
		"wpn_fps_pis_packrat_o_expert",
	})

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

	self.parts.wpn_fps_pis_sparrow_b_comp.stats.spread = 1
	self.parts.wpn_fps_pis_sparrow_b_comp.stats.recoil = 1
	self.parts.wpn_fps_pis_sparrow_b_comp.stats.concealment = -2

	self.parts.wpn_fps_pis_sparrow_b_threaded.stats.spread = 1
	self.parts.wpn_fps_pis_sparrow_b_threaded.stats.recoil = 0
	self.parts.wpn_fps_pis_sparrow_b_threaded.stats.concealment = -1

	self.parts.wpn_fps_pis_pl14_m_extended.stats.extra_ammo = 2

	self.parts.wpn_fps_pis_packrat_m_extended.stats.extra_ammo = 5

	self:_wipe_stats({ "wpn_fps_pis_lemming_b_nitride" })

	self.parts.wpn_fps_pis_breech_b_reinforced.stats.spread = 0
	self.parts.wpn_fps_pis_breech_b_reinforced.stats.recoil = 1
	self.parts.wpn_fps_pis_breech_b_reinforced.stats.concealment = -1

	self.parts.wpn_fps_pis_breech_b_short.stats.spread = -1
	self.parts.wpn_fps_pis_breech_b_short.stats.concealment = 1

	self.parts.wpn_fps_pis_chinchilla_b_satan.stats.spread = 1
	self.parts.wpn_fps_pis_chinchilla_b_satan.stats.recoil = 1
	self.parts.wpn_fps_pis_chinchilla_b_satan.stats.concealment = -2

	self.parts.wpn_fps_pis_lemming_m_ext.stats.extra_ammo = 0
	self.parts.wpn_fps_pis_lemming_m_ext.custom_stats.ammo_offset = 5

	self.parts.wpn_fps_pis_shrew_m_extended.stats.extra_ammo = 3

	self.parts.wpn_fps_pis_holt_m_extended.stats.extra_ammo = 5

	self.parts.wpn_fps_pis_beer_b_robo.stats.spread = 4
	self.parts.wpn_fps_pis_beer_b_robo.stats.recoil = -1
	self.parts.wpn_fps_pis_beer_b_robo.stats.concealment = -3

	self.parts.wpn_fps_pis_beer_m_extended.stats.extra_ammo = 5

	self.parts.wpn_fps_pis_czech_b_long.spread = 2
	self.parts.wpn_fps_pis_czech_b_long.stats.concealment = -2

	self.parts.wpn_fps_pis_czech_m_extended.stats.extra_ammo = 6

	self.parts.wpn_fps_pis_stech_b_long.stats.spread = 2
	self.parts.wpn_fps_pis_stech_b_long.stats.concealment = -2

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

	self.parts.wpn_fps_pis_rsh12_b_comp.stats.damage = 0
	self.parts.wpn_fps_pis_rsh12_b_comp.stats.spread = 2
	self.parts.wpn_fps_pis_rsh12_b_comp.stats.recoil = 1
	self.parts.wpn_fps_pis_rsh12_b_comp.stats.concealment = -3

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

	-- SMG Mods
	self.parts.wpn_fps_smg_mp5_fg_m5k.stats.spread = -2
	self.parts.wpn_fps_smg_mp5_fg_m5k.stats.concealment = 2

	self.parts.wpn_fps_smg_mp5_fg_mp5sd.stats.damage = -2
	self.parts.wpn_fps_smg_mp5_fg_mp5sd.stats.concealment = 1

	self.parts.wpn_fps_smg_mac10_m_extended.stats.extra_ammo = 6

	self.parts.wpn_fps_smg_p90_b_long.stats.damage = 0
	self.parts.wpn_fps_smg_p90_b_long.stats.spread = 2
	self.parts.wpn_fps_smg_p90_b_long.stats.recoil = 0

	self.parts.wpn_fps_smg_p90_b_civilian.stats.concealment = -3

	self.parts.wpn_fps_smg_p90_b_ninja.stats.concealment = -4

	self.parts.wpn_fps_smg_m45_b_small.stats.concealment = 2

	self.parts.wpn_fps_smg_scorpion_m_extended.stats = { value = 1, reload = 1, recoil = 1, concealment = -2 }

	self.parts.wpn_fps_smg_tec9_b_standard.stats.spread = -1
	self.parts.wpn_fps_smg_tec9_b_standard.stats.recoil = 0
	self.parts.wpn_fps_smg_tec9_b_standard.stats.concealment = 1

	self.parts.wpn_fps_smg_tec9_ns_ext.stats.damage = 0
	self.parts.wpn_fps_smg_tec9_ns_ext.stats.spread = 2
	self.parts.wpn_fps_smg_tec9_ns_ext.stats.recoil = 0
	self.parts.wpn_fps_smg_tec9_ns_ext.stats.concealment = -2

	self.parts.wpn_fps_smg_thompson_barrel_short.stats.spread = -2
	self.parts.wpn_fps_smg_thompson_barrel_short.stats.concealment = 2

	self.parts.wpn_fps_smg_thompson_barrel_long.stats.damage = 0
	self.parts.wpn_fps_smg_thompson_barrel_long.stats.concealment = -2

	self.wpn_fps_smg_coal.stock_adapter = "wpn_upg_ak_s_adapter"
	self.wpn_fps_smg_coal_npc.stock_adapter = "wpn_upg_ak_s_adapter"

	self.parts.wpn_fps_smg_shepheard_body_short.stats.spread = -2
	self.parts.wpn_fps_smg_shepheard_body_short.stats.concealment = 2

	self.parts.wpn_fps_smg_shepheard_mag_standard.unit = "units/pd2_dlc_joy/weapons/wpn_fps_smg_shepheard_pts/wpn_fps_smg_shepheard_mag_extended"
	self.parts.wpn_fps_smg_shepheard_mag_standard.third_unit = "units/pd2_dlc_joy/weapons/wpn_fps_smg_shepheard_pts/wpn_third_smg_shepheard_mag_extended"
	self.parts.wpn_fps_smg_shepheard_mag_standard.bullet_objects = { amount = 30, prefix = "g_bullet_" }

	self.parts.wpn_fps_smg_shepheard_mag_extended.unit = "units/pd2_dlc_joy/weapons/wpn_fps_smg_shepheard_pts/wpn_fps_smg_shepheard_mag_standard"
	self.parts.wpn_fps_smg_shepheard_mag_extended.third_unit = "units/pd2_dlc_joy/weapons/wpn_fps_smg_shepheard_pts/wpn_third_smg_shepheard_mag_standard"
	self.parts.wpn_fps_smg_shepheard_mag_extended.bullet_objects = { amount = 20, prefix = "g_bullet_" }
	self.parts.wpn_fps_smg_shepheard_mag_extended.stats.extra_ammo = -5

	self.parts.wpn_fps_smg_schakal_b_civil.stats.damage = 0
	self.parts.wpn_fps_smg_schakal_b_civil.stats.spread = 2
	self.parts.wpn_fps_smg_schakal_b_civil.stats.concealment = -2

	self.parts.wpn_fps_smg_pm9_b_short.stats.spread = -2
	self.parts.wpn_fps_smg_pm9_b_short.stats.recoil = 0

	local rifle_barrel_exts_no_shak12 = clone(rifle_barrel_exts)

	table.delete(rifle_barrel_exts_no_shak12, "wpn_fps_ass_shak12_ns_muzzle")
	table.delete(rifle_barrel_exts_no_shak12, "wpn_fps_ass_shak12_ns_suppressor")

	self:_add_parts_from_list({ "wpn_fps_smg_pm9" }, rifle_barrel_exts_no_shak12)

	self:_add_forbids_from_list("wpn_fps_smg_pm9_b_standard", rifle_barrel_exts_no_shak12)

	self:_add_forbids_from_list("wpn_fps_smg_fmg9_conversion", rifle_barrel_exts)

	self.parts.wpn_fps_smg_speen_barrel_dmr.stats.damage = 0
	self.parts.wpn_fps_smg_speen_barrel_dmr.stats.spread = 1
	self.parts.wpn_fps_smg_speen_barrel_dmr.stats.recoil = 0
	self.parts.wpn_fps_smg_speen_barrel_dmr.stats.concealment = -1

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

	self.parts.wpn_fps_sho_ben_b_long.stats.extra_ammo = 1
	self.parts.wpn_fps_sho_ben_b_long.stats.spread = 1
	self.parts.wpn_fps_sho_ben_b_long.stats.recoil = 0

	self.parts.wpn_fps_sho_ben_b_short.stats.extra_ammo = -1
	self.parts.wpn_fps_sho_ben_b_short.stats.damage = 0
	self.parts.wpn_fps_sho_ben_b_short.stats.recoil = 0
	self.parts.wpn_fps_sho_ben_b_short.stats.concealment = 3

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

	self.parts.wpn_fps_shot_b682_b_short.stats.spread = -3
	self.parts.wpn_fps_shot_b682_b_short.stats.recoil = -1
	self.parts.wpn_fps_shot_b682_b_short.stats.concealment = 4

	self.parts.wpn_fps_sho_boot_b_long.stats.extra_ammo = 1
	self.parts.wpn_fps_sho_boot_b_long.stats.recoil = 0

	self.parts.wpn_fps_sho_boot_b_short.stats.extra_ammo = -1
	self.parts.wpn_fps_sho_boot_b_short.stats.recoil = 0

	self.parts.wpn_fps_sho_rota_b_short.stats.concealment = 2

	self.parts.wpn_fps_sho_basset_fg_short.stats.recoil = -2
	self.parts.wpn_fps_sho_basset_fg_short.stats.concealment = 2

	self.parts.wpn_fps_sho_coach_b_short.stats.spread = -3
	self.parts.wpn_fps_sho_coach_b_short.stats.recoil = -2
	self.parts.wpn_fps_sho_coach_b_short.stats.concealment = 5

	self.parts.wpn_fps_shot_m1897_b_long.stats.recoil = 0

	self.parts.wpn_fps_sho_ultima_body_rack.stats.reload = 2
	self.parts.wpn_fps_sho_ultima_body_rack.stats.concealment = -2

	self.parts.wpn_fps_sho_m590_b_long.stats.extra_ammo = 1
	self.parts.wpn_fps_sho_m590_b_long.stats.spread = 1
	self.parts.wpn_fps_sho_m590_b_long.stats.concealment = -2

	self.parts.wpn_fps_sho_sko12_b_long.stats.damage = 0
	self.parts.wpn_fps_sho_sko12_b_long.stats.recoil = 0

	self.parts.wpn_fps_sho_sko12_b_short.stats.spread = -2
	self.parts.wpn_fps_sho_sko12_b_short.stats.recoil = 0

	self.parts.wpn_fps_sho_supernova_b_long.stats.recoil = 0

	self.parts.wpn_fps_sho_supernova_g_stakeout.stats.recoil = -2
	self.parts.wpn_fps_sho_supernova_g_stakeout.stats.concealment = 2

	self.parts.wpn_fps_sho_supernova_shell_rack.stats.reload = 2
	self.parts.wpn_fps_sho_supernova_shell_rack.stats.concealment = -2

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

	self.parts.wpn_fps_snp_mosin_ns_bayonet.stats.min_damage = 2
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

	self.parts.wpn_fps_snp_sbl_b_long.stats.extra_ammo = -1
	self.parts.wpn_fps_snp_sbl_b_long.stats.spread = 3
	self.parts.wpn_fps_snp_sbl_b_long.stats.recoil = 0
	self.parts.wpn_fps_snp_sbl_b_long.stats.concealment = -2

	self.parts.wpn_fps_snp_sbl_b_short.stats.extra_ammo = -1
	self.parts.wpn_fps_snp_sbl_b_short.stats.concealment = 0

	self.parts.wpn_fps_snp_qbu88_b_long.stats.recoil = 0

	self.parts.wpn_fps_snp_contender_barrel_long.stats.damage = 0
	self.parts.wpn_fps_snp_contender_barrel_long.stats.spread = 1
	self.parts.wpn_fps_snp_contender_barrel_long.stats.recoil = 0
	self.parts.wpn_fps_snp_contender_barrel_long.stats.concealment = -1

	self.parts.wpn_fps_snp_contender_barrel_short.stats.recoil = 0

	self.parts.wpn_fps_upg_m4_g_contender.stats.recoil = 2
	self.parts.wpn_fps_upg_m4_g_contender.stats.concealment = -2

	self.parts.wpn_fps_snp_awp_conversion_wildlands.stats = {}
	self.parts.wpn_fps_snp_awp_conversion_wildlands.stats.value = 1
	self.parts.wpn_fps_snp_awp_conversion_wildlands.custom_stats = {}

	self.parts.wpn_fps_snp_awp_conversion_dragonlore.stats = {}
	self.parts.wpn_fps_snp_awp_conversion_dragonlore.stats.value = 1
	self.parts.wpn_fps_snp_awp_conversion_dragonlore.custom_stats = {}

	-- LMG Mods
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
	self.parts.wpn_fps_lmg_m60_b_short.stats.recoil = -1
	self.parts.wpn_fps_lmg_m60_b_short.stats.concealment = 3

	self.parts.wpn_fps_lmg_hk51b_b_fluted.stats.damage = 0
	self.parts.wpn_fps_lmg_hk51b_b_fluted.stats.spread = 2
	self.parts.wpn_fps_lmg_hk51b_b_fluted.stats.recoil = 0
	self.parts.wpn_fps_lmg_hk51b_b_fluted.stats.concealment = -2

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

	self.parts.wpn_fps_lmg_kacchainsaw_b_long.stats.damage = 0
	self.parts.wpn_fps_lmg_kacchainsaw_b_long.stats.spread = 2
	self.parts.wpn_fps_lmg_kacchainsaw_b_long.stats.recoil = 0
	self.parts.wpn_fps_lmg_kacchainsaw_b_long.stats.concealment = -2

	self.parts.wpn_fps_lmg_kacchainsaw_mag_b.stats.extra_ammo = -50
	self.parts.wpn_fps_lmg_kacchainsaw_mag_b.stats.recoil = 0

	self.parts.wpn_fps_lmg_kacchainsaw_flamethrower.stats.spread = 0
	self.parts.wpn_fps_lmg_kacchainsaw_flamethrower.stats.recoil = 0
	self.parts.wpn_fps_lmg_kacchainsaw_flamethrower.stats.concealment = -4

	--Minigun Mods
	--	self.parts.wpn_fps_lmg_m134_barrel_extreme.stats.spread = 1
	--	self.parts.wpn_fps_lmg_m134_barrel_extreme.stats.recoil = -3
	--	self.parts.wpn_fps_lmg_m134_barrel_extreme.stats.concealment = -2

	self.parts.wpn_fps_lmg_m134_barrel_short.stats.spread = -2
	self.parts.wpn_fps_lmg_m134_barrel_short.stats.recoil = -1
	self.parts.wpn_fps_lmg_m134_barrel_short.stats.concealment = 3

	self.parts.wpn_fps_lmg_m134_body_upper_light.stats.total_ammo_mod = 0
	self.parts.wpn_fps_lmg_m134_body_upper_light.stats.spread = 0
	self.parts.wpn_fps_lmg_m134_body_upper_light.stats.recoil = 0
	self.parts.wpn_fps_lmg_m134_body_upper_light.stats.concealment = 0
	self.parts.wpn_fps_lmg_m134_body_upper_light.custom_stats = {
		total_ammo_mul = 1 / 2,
		movement_speed = 1.15,
	}

	self.parts.wpn_fps_lmg_shuno_b_heat_long.stats.spread = 1
	self.parts.wpn_fps_lmg_shuno_b_heat_long.stats.recoil = -3
	self.parts.wpn_fps_lmg_shuno_b_heat_long.stats.concealment = -3

	self.parts.wpn_fps_lmg_shuno_b_heat_short.stats.spread = -1
	self.parts.wpn_fps_lmg_shuno_b_heat_short.stats.recoil = -2
	self.parts.wpn_fps_lmg_shuno_b_heat_short.stats.concealment = 3

	self.parts.wpn_fps_lmg_shuno_b_short.stats.spread = -2
	self.parts.wpn_fps_lmg_shuno_b_short.stats.recoil = -1
	self.parts.wpn_fps_lmg_shuno_b_short.stats.concealment = 3

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

	self.parts.wpn_fps_gre_m79_barrel_short.stats.spread = -3
	self.parts.wpn_fps_gre_m79_barrel_short.stats.concealment = 3

	self.parts.wpn_fps_gre_m79_stock_short.stats.spread = -2
	self.parts.wpn_fps_gre_m79_stock_short.stats.recoil = -1
	self.parts.wpn_fps_gre_m79_stock_short.stats.concealment = 3

	self.parts.wpn_fps_gre_ms3gl_b_long.stats.spread = 3
	self.parts.wpn_fps_gre_ms3gl_b_long.stats.recoil = 0
	self.parts.wpn_fps_gre_ms3gl_b_long.stats.concealment = -4
	self.parts.wpn_fps_gre_ms3gl_b_long.custom_stats = { ammo_offset = 1 }

	-- Re-add drum mags	and unused RPK mag
	local drum_anims = {
		reload_not_empty = "reload_not_empty",
		reload = "reload",
	}

	-- CAR drum magazine
	self.parts.wpn_fps_upg_m4_m_drum = deep_clone(self.parts.wpn_fps_upg_m4_m_straight)
	self.parts.wpn_fps_upg_m4_m_drum.name_id = "bm_wp_m4_m_drum"
	self.parts.wpn_fps_upg_m4_m_drum.unit = "units/payday2/weapons/wpn_fps_upg_m4_reusable/wpn_fps_upg_m4_m_drum"
	self.parts.wpn_fps_upg_m4_m_drum.third_unit = "units/payday2/weapons/wpn_third_upg_m4_reusable/wpn_third_upg_m4_m_drum"
	self.parts.wpn_fps_upg_m4_m_drum.stats = deep_clone(self.parts.wpn_fps_upg_m4_m_quad.stats)
	self.parts.wpn_fps_upg_m4_m_drum.stats.extra_ammo = 0
	self.parts.wpn_fps_upg_m4_m_drum.custom_stats = { ammo_offset = 45 }
	self.parts.wpn_fps_upg_m4_m_drum.animations = drum_anims

	-- AK drum magazine
	self.parts.wpn_upg_ak_m_drum = deep_clone(self.parts.wpn_fps_upg_ak_m_uspalm)
	self.parts.wpn_upg_ak_m_drum.is_a_unlockable = nil
	self.parts.wpn_upg_ak_m_drum.texture_bundle_folder = nil
	self.parts.wpn_upg_ak_m_drum.dlc = nil
	self.parts.wpn_upg_ak_m_drum.name_id = "bm_wp_ak_m_drum"
	self.parts.wpn_upg_ak_m_drum.unit = "units/payday2/weapons/wpn_fps_upg_ak_reusable/wpn_upg_ak_m_drum"
	self.parts.wpn_upg_ak_m_drum.third_unit = "units/payday2/weapons/wpn_third_upg_ak_reusable/wpn_third_upg_ak_m_drum"
	self.parts.wpn_upg_ak_m_drum.pcs = { 10, 20, 30, 40 }
	self.parts.wpn_upg_ak_m_drum.stats = deep_clone(self.parts.wpn_fps_upg_m4_m_quad.stats)
	self.parts.wpn_upg_ak_m_drum.stats.extra_ammo = 0
	self.parts.wpn_upg_ak_m_drum.custom_stats = { ammo_offset = 45 }
	self.parts.wpn_upg_ak_m_drum.animations = drum_anims

	-- Compact-5 drum magazine
	self.parts.wpn_fps_smg_mp5_m_drum = deep_clone(self.parts.wpn_fps_smg_mp5_m_straight)
	self.parts.wpn_fps_smg_mp5_m_drum.texture_bundle_folder = nil
	self.parts.wpn_fps_smg_mp5_m_drum.dlc = nil
	self.parts.wpn_fps_smg_mp5_m_drum.name_id = "bm_wp_ak_m_drum"
	self.parts.wpn_fps_smg_mp5_m_drum.unit = "units/payday2/weapons/wpn_fps_smg_mp5_pts/wpn_fps_smg_mp5_m_drum"
	self.parts.wpn_fps_smg_mp5_m_drum.third_unit = "units/payday2/weapons/wpn_third_smg_mp5_pts/wpn_third_smg_mp5_m_drum"
	self.parts.wpn_fps_smg_mp5_m_drum.bullet_objects.amount = 1
	self.parts.wpn_fps_smg_mp5_m_drum.stats = deep_clone(self.parts.wpn_fps_upg_m4_m_quad.stats)
	self.parts.wpn_fps_smg_mp5_m_drum.stats.extra_ammo = 0
	self.parts.wpn_fps_smg_mp5_m_drum.custom_stats = { ammo_offset = 45 }
	self.parts.wpn_fps_smg_mp5_m_drum.animations = drum_anims

	-- Izhma drum magazine
	self.parts.wpn_upg_saiga_m_20rnd = deep_clone(self.parts.wpn_fps_sho_basset_m_extended)
	self.parts.wpn_upg_saiga_m_20rnd.texture_bundle_folder = nil
	self.parts.wpn_upg_saiga_m_20rnd.name_id = "bm_wp_saiga_m_20rnd"
	self.parts.wpn_upg_saiga_m_20rnd.unit = "units/payday2/weapons/wpn_fps_shot_saiga_pts/wpn_upg_saiga_m_20rnd"
	self.parts.wpn_upg_saiga_m_20rnd.third_unit = "units/payday2/weapons/wpn_third_shot_saiga_pts/wpn_third_saiga_m_20rnd"
	self.parts.wpn_upg_saiga_m_20rnd.stats.extra_ammo = 4
	self.parts.wpn_upg_saiga_m_20rnd.custom_stats = {}
	self.parts.wpn_upg_saiga_m_20rnd.animations = drum_anims

	self.parts.wpn_fps_ass_g3_b_short.stats.total_ammo_mod = 0
	self.parts.wpn_fps_ass_g3_b_short.stats.damage = 0
	self.parts.wpn_fps_ass_g3_b_short.stats.spread = -2
	self.parts.wpn_fps_ass_g3_b_short.stats.recoil = 0
	self.parts.wpn_fps_ass_g3_b_short.stats.concealment = 2
	self.parts.wpn_fps_ass_g3_b_short.custom_stats = {}

	-- Firemodes
	self.parts.wpn_fps_upg_i_singlefire.stats = { spread = 1, recoil = -1, value = 1 }
	self.parts.wpn_fps_upg_i_autofire.stats = { spread = -1, recoil = 1, value = 1 }
	self.parts.wpn_fps_upg_i_burstfire.stats = { spread = 1, recoil = -3, value = 1 }

	-- Saw mods
	self.parts.wpn_fps_saw_m_blade_durable.stats.damage = -10
	self.parts.wpn_fps_saw_m_blade_durable.stats.extra_ammo = 0
	self.parts.wpn_fps_saw_m_blade_durable.stats.total_ammo_mod = 0
	self.parts.wpn_fps_saw_m_blade_durable.custom_stats = {
		ammo_offset = 50,
		ammo_max_mul = 3 / 2,
	}
	self.parts.wpn_fps_saw_m_blade_durable.no_magazine_balancing = true

	self.parts.wpn_fps_saw_m_blade_sharp.stats.damage = 6
	self.parts.wpn_fps_saw_m_blade_sharp.stats.extra_ammo = 0
	self.parts.wpn_fps_saw_m_blade_sharp.custom_stats = {
		ammo_offset = -25,
		ammo_max_mul = 3 / 4,
	}
	self.parts.wpn_fps_saw_m_blade_sharp.no_magazine_balancing = true

	self.parts.wpn_fps_saw_body_silent.stats.suppression = 9
	self.parts.wpn_fps_saw_body_silent.stats.alert_size = 9

	self.parts.wpn_fps_saw_body_speed.stats.concealment = -2
	self.parts.wpn_fps_saw_body_speed.custom_stats.fire_rate_multiplier = 2

	-- Dart Pistol parts

	-- Replace the default ammo type with a standard non-poison tipped dart
	self.parts.wpn_fps_upg_a_dart_standard = deep_clone(self.parts.wpn_fps_upg_a_dart_poison)
	self.parts.wpn_fps_upg_a_dart_standard.sub_type = nil
	self.parts.wpn_fps_upg_a_dart_standard.custom_stats = nil

	table.delete(self.wpn_fps_spe_dart.default_blueprint, "wpn_fps_upg_a_dart_poison")
	table.insert(self.wpn_fps_spe_dart.default_blueprint, "wpn_fps_upg_a_dart_standard")

	-- Remove the Revive Dart.
	-- It does not belong in the game.
	table.delete(self.wpn_fps_spe_dart.uses_parts, "wpn_fps_upg_a_dart_revive")

	self.parts.wpn_fps_spe_dart_magazine_high_pressure.stats.spread = 1
	self.parts.wpn_fps_spe_dart_magazine_high_pressure.stats.recoil = -2
	self.parts.wpn_fps_spe_dart_magazine_high_pressure.stats.concealment = -1
	self.parts.wpn_fps_spe_dart_magazine_high_pressure.custom_stats.launch_speed_mul = 1.25
	self.parts.wpn_fps_spe_dart_magazine_high_pressure.custom_stats.charge_speed_mul = 1.15

	self.parts.wpn_fps_spe_dart_magazine_high_capacity.stats.spread = -1
	self.parts.wpn_fps_spe_dart_magazine_high_capacity.stats.recoil = 2
	self.parts.wpn_fps_spe_dart_magazine_high_capacity.stats.concealment = -1
	self.parts.wpn_fps_spe_dart_magazine_high_capacity.custom_stats.launch_speed_mul = 0.85
	self.parts.wpn_fps_spe_dart_magazine_high_capacity.custom_stats.charge_speed_mul = 0.5

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

	self.parts.wpn_fps_fla_mk2_mag_rare.stats = {
		value = 1,
		damage = -2,
	}
	self.parts.wpn_fps_fla_mk2_mag_rare.custom_stats = {
		ammo_offset = 25,
		total_ammo_mul = 3 / 2,
	}
	self.parts.wpn_fps_fla_mk2_mag_rare.adds = { "wpn_fps_fla_mk2_a_rare" }
	self.parts.wpn_fps_fla_mk2_mag_rare.custom_stats = {}
	self.parts.wpn_fps_fla_mk2_mag_rare.has_description = true
	self.parts.wpn_fps_fla_mk2_mag_rare.desc_id = "bm_wp_fla_mk2_mag_rare_desc"

	self.parts.wpn_fps_fla_mk2_mag_welldone.stats = {
		value = 1,
		damage = 2,
	}
	self.parts.wpn_fps_fla_mk2_mag_welldone.custom_stats = {
		ammo_offset = -25,
		total_ammo_mul = 2 / 3,
	}
	self.parts.wpn_fps_fla_mk2_mag_welldone.adds = { "wpn_fps_fla_mk2_a_welldone" }
	self.parts.wpn_fps_fla_mk2_mag_welldone.custom_stats = {}
	self.parts.wpn_fps_fla_mk2_mag_welldone.has_description = true
	self.parts.wpn_fps_fla_mk2_mag_welldone.desc_id = "bm_wp_fla_mk2_mag_welldone_desc"

	self.parts.wpn_fps_fla_system_b_wtf.stats.total_ammo_mod = 0
	self.parts.wpn_fps_fla_system_b_wtf.stats.concealment = 0

	self.parts.wpn_fps_fla_system_a_low = deep_clone(self.parts.wpn_fps_fla_mk2_a_rare)
	self.parts.wpn_fps_fla_system_a_low.name_id = "bm_wp_system_a_low"
	self.parts.wpn_fps_fla_system_a_low.custom_stats.dot_data_name = "ammo_system_low"

	self.parts.wpn_fps_fla_system_a_high = deep_clone(self.parts.wpn_fps_fla_mk2_a_welldone)
	self.parts.wpn_fps_fla_system_a_high.name_id = "bm_wp_system_a_high"
	self.parts.wpn_fps_fla_system_a_high.custom_stats.dot_data_name = "ammo_system_high"

	self.parts.wpn_fps_fla_system_m_low.stats = {
		value = 1,
		damage = -2,
	}
	self.parts.wpn_fps_fla_system_m_low.custom_stats = {
		ammo_offset = 25,
		total_ammo_mul = 5 / 4,
	}
	self.parts.wpn_fps_fla_system_m_low.adds = { "wpn_fps_fla_system_a_low" }
	self.parts.wpn_fps_fla_system_m_low.custom_stats = {}
	self.parts.wpn_fps_fla_system_m_low.has_description = true
	self.parts.wpn_fps_fla_system_m_low.desc_id = "bm_wp_fla_mk2_mag_rare_desc"

	self.parts.wpn_fps_fla_system_m_high.stats = {
		value = 1,
		damage = 2,
		extra_ammo = -25,
		total_ammo_mod = -5,
	}
	self.parts.wpn_fps_fla_system_m_low.custom_stats = {
		ammo_offset = -25,
		total_ammo_mul = 3 / 4,
	}
	self.parts.wpn_fps_fla_system_m_high.adds = { "wpn_fps_fla_system_a_high" }
	self.parts.wpn_fps_fla_system_m_high.custom_stats = {}
	self.parts.wpn_fps_fla_system_m_high.has_description = true
	self.parts.wpn_fps_fla_system_m_high.desc_id = "bm_wp_fla_mk2_mag_welldone_desc"

	-- Barrel Extensions, Silencers --

	-- Delete KS-12 barrel extensions from most weapons
	for k, v in pairs(self) do
		if v.uses_parts and table.contains(v.uses_parts, "wpn_fps_ass_shak12_ns_muzzle") then
			table.delete(v.uses_parts, "wpn_fps_ass_shak12_ns_muzzle")
		end

		if v.uses_parts and table.contains(v.uses_parts, "wpn_fps_ass_shak12_ns_suppressor") then
			table.delete(v.uses_parts, "wpn_fps_ass_shak12_ns_suppressor")
		end
	end

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
		huge_silencer = { value = 1, recoil = 1, spread = 2, concealment = -4 },
		massive_silencer = { value = 1, recoil = 2, spread = 1, concealment = -4 },
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
	self.parts.wpn_fps_ass_shak12_ns_suppressor.stats = barrel_ext_stats.huge_silencer
	-- Federation
	self.parts.wpn_fps_upg_ak_ns_tgp.stats = barrel_ext_stats.medium_silencer

	-- Weapon exclusive barrel extensions
	self.parts.wpn_fps_smg_cobray_ns_barrelextension.stats = barrel_ext_stats.spread_heavily_favored
	self.parts.wpn_fps_smg_baka_b_longsupp.stats = barrel_ext_stats.huge_silencer
	self.parts.wpn_fps_smg_mp9_b_suppressed.stats = barrel_ext_stats.huge_silencer
	self.parts.wpn_fps_smg_mp7_b_suppressed.stats = barrel_ext_stats.big_silencer
	self.parts.wpn_fps_smg_sr2_ns_silencer.stats = barrel_ext_stats.big_silencer
	self.parts.wpn_fps_smg_polymer_ns_silencer.stats = barrel_ext_stats.big_silencer
	self.parts.wpn_fps_smg_uzi_b_suppressed.stats = barrel_ext_stats.big_silencer
	self.parts.wpn_fps_smg_cobray_ns_silencer.stats = barrel_ext_stats.big_silencer
	self.parts.wpn_fps_smg_baka_b_midsupp.stats = barrel_ext_stats.medium_silencer
	self.parts.wpn_fps_smg_schakal_ns_silencer.stats = barrel_ext_stats.medium_silencer
	self.parts.wpn_fps_smg_scorpion_b_suppressed.stats = barrel_ext_stats.medium_silencer
	self.parts.wpn_fps_smg_baka_b_smallsupp.stats = barrel_ext_stats.small_silencer

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
		medium_silencer_var1 = { value = 1, damage = -2, spread = 1, concealment = -2 },
		medium_silencer_var2 = { value = 1, damage = -2, recoil = 1, concealment = -2 },
		big_silencer_var1 = { value = 1, spread = 2, concealment = -3 },
		big_silencer_var2 = { value = 1, recoil = 2, concealment = -3 },
		big_silencer_var3 = { value = 1, recoil = 1, spread = 1, concealment = -3 },
		massive_silencer = { value = 1, recoil = 2, spread = 1, concealment = -4 },
	}

	-- Flash Hider
	self.parts.wpn_fps_upg_pis_ns_flash.stats = pistol_barrel_ext_stats.balanced
	-- IPSC
	self.parts.wpn_fps_upg_ns_pis_ipsccomp.stats = pistol_barrel_ext_stats.spread_favored
	-- Facepunch
	self.parts.wpn_fps_upg_ns_pis_meatgrinder.stats = pistol_barrel_ext_stats.recoil_favored
	-- Hurricane
	self.parts.wpn_fps_upg_ns_pis_typhoon.stats = pistol_barrel_ext_stats.balanced
	-- Budget
	self.parts.wpn_fps_upg_ns_ass_filter.stats = { value = 1, recoil = -1, spread = -2, concealment = -2 }
	-- Size Doesn't Matter
	self.parts.wpn_fps_upg_ns_pis_small.stats = pistol_barrel_ext_stats.small_silencer
	-- Standard Issue
	self.parts.wpn_fps_upg_ns_pis_medium.stats = pistol_barrel_ext_stats.medium_silencer_var2
	-- Roctec
	self.parts.wpn_fps_upg_ns_pis_medium_gem.stats = pistol_barrel_ext_stats.medium_silencer_var1
	-- Asepsis
	self.parts.wpn_fps_upg_ns_pis_medium_slim.stats = pistol_barrel_ext_stats.medium_silencer_var1
	-- Medved R4
	self.parts.wpn_fps_upg_ns_pis_putnik.stats = pistol_barrel_ext_stats.medium_silencer_var2
	-- Champion
	self.parts.wpn_fps_upg_ns_pis_large_kac.stats = pistol_barrel_ext_stats.big_silencer_var1
	-- Monolith
	self.parts.wpn_fps_upg_ns_pis_large.stats = pistol_barrel_ext_stats.big_silencer_var2
	-- Jungle Ninja
	self.parts.wpn_fps_upg_ns_pis_jungle.stats = pistol_barrel_ext_stats.massive_silencer

	-- Weapon-specific extensions
	self.parts.wpn_fps_pis_g18c_co_1.stats = pistol_barrel_ext_stats.recoil_heavily_favored
	self.parts.wpn_fps_pis_g18c_co_comp_2.stats = pistol_barrel_ext_stats.spread_heavily_favored

	self.parts.wpn_fps_pis_beretta_co_co1.stats = pistol_barrel_ext_stats.recoil_heavily_favored
	self.parts.wpn_fps_pis_beretta_co_co2.stats = pistol_barrel_ext_stats.spread_heavily_favored

	self.parts.wpn_fps_pis_1911_co_1.stats = pistol_barrel_ext_stats.recoil_heavily_favored
	self.parts.wpn_fps_pis_1911_co_2.stats = pistol_barrel_ext_stats.spread_heavily_favored

	self.parts.wpn_fps_pis_p226_co_comp_1.stats = pistol_barrel_ext_stats.recoil_heavily_favored
	self.parts.wpn_fps_pis_p226_co_comp_2.stats = pistol_barrel_ext_stats.spread_heavily_favored

	self.parts.wpn_fps_pis_usp_co_comp_1.stats = pistol_barrel_ext_stats.recoil_heavily_favored
	self.parts.wpn_fps_pis_usp_co_comp_2.stats = pistol_barrel_ext_stats.spread_heavily_favored

	self.parts.wpn_fps_pis_pmm_ns_suppressor.stats = pistol_barrel_ext_stats.medium_silencer_var1

	local function smallify_barrel_exts(factory_id, part_list)
		if not self[factory_id].override then
			self[factory_id].override = {}
		end

		for _, part_id in pairs(part_list) do
			if not self[factory_id].override[part_id] then
				self[factory_id].override[part_id] = {}
			end

			if not self[factory_id].override[part_id].stats then
				self[factory_id].override[part_id].stats = {}
			end

			local part_data = self.parts[part_id]
			local part_stats = part_data and part_data.stats or {}

			self[factory_id].override[part_id].stats = deep_clone(part_stats)
			self[factory_id].override[part_id].stats.spread = (part_stats.spread or 0) - 1
			self[factory_id].override[part_id].stats.recoil = (part_stats.recoil or 0) - 1
			self[factory_id].override[part_id].stats.concealment = (part_stats.concealment or 0) + 2
		end
	end

	smallify_barrel_exts("wpn_fps_pis_welrod", pistol_barrel_exts)

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

-- Create dummied out weapon stat boosts to prevent potential crashes with custom weapons
function WeaponFactoryTweakData:create_bonuses(tweak_data, weapon_skins)
	local bonus_ids = {
		"wpn_fps_upg_bonus_concealment_p1",
		"wpn_fps_upg_bonus_concealment_p2",
		"wpn_fps_upg_bonus_concealment_p3",
		"wpn_fps_upg_bonus_spread_p1",
		"wpn_fps_upg_bonus_spread_n1",
		"wpn_fps_upg_bonus_recoil_p1",
		"wpn_fps_upg_bonus_recoil_p2",
		"wpn_fps_upg_bonus_damage_p1",
		"wpn_fps_upg_bonus_damage_p2",
		"wpn_fps_upg_bonus_total_ammo_p1",
		"wpn_fps_upg_bonus_total_ammo_p3",
		"wpn_fps_upg_bonus_team_exp_money_p3",
	}
	local dummy_bonus = {
		exclude_from_challenge = true,
		texture_bundle_folder = "boost_in_lootdrop",
		third_unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
		a_obj = "a_body",
		type = "bonus",
		name_id = "bm_menu_bonus_total_ammo",
		sub_type = "bonus_stats",
		internal_part = true,
		unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
		stats = {
			value = 1,
		},
		perks = {
			"bonus",
		},
	}

	for _, bonus_id in pairs(bonus_ids) do
		self.parts[bonus_id] = deep_clone(dummy_bonus)
	end

	if weapon_skins then
		local uses_parts = {
			wpn_fps_upg_bonus_team_exp_money_p3 = {},
			wpn_fps_upg_bonus_concealment_p1 = {},
			wpn_fps_upg_bonus_recoil_p1 = {},
			wpn_fps_upg_bonus_spread_p1 = {},
			wpn_fps_upg_bonus_spread_n1 = {
				category = {
					"shotgun",
				},
			},
			wpn_fps_upg_bonus_damage_p1 = {
				weapon = {
					"flamethrower_mk2",
					"system",
				},
			},
			wpn_fps_upg_bonus_total_ammo_p1 = {
				category = {
					"saw",
					"minigun",
					"flamethrower",
					"bow",
					"crossbow",
					"snp",
				},
				weapon = {
					"saiga",
				},
			},
			wpn_fps_upg_bonus_concealment_p2 = {
				weapon = {
					"p90",
				},
			},
			wpn_fps_upg_bonus_concealment_p3 = {
				weapon = {
					"b92fs",
					"famas",
					"g26",
					"jowi",
					"new_raging_bull",
					"ppk",
				},
			},
			wpn_fps_upg_bonus_recoil_p2 = {
				weapon = {
					"deagle",
					"komodo",
					"m16",
					"scar",
				},
			},
			wpn_fps_upg_bonus_damage_p2 = {
				weapon = {
					"famas",
				},
			},
			wpn_fps_upg_bonus_total_ammo_p3 = {
				weapon = {
					"plainsrider",
				},
			},
		}
		local all_pass, weapon_pass, exclude_weapon_pass, category_pass, exclude_category_pass = nil

		for id, data in pairs(tweak_data.upgrades.definitions) do
			local weapon_tweak = tweak_data.weapon[data.weapon_id]
			local primary_category = weapon_tweak and weapon_tweak.categories and weapon_tweak.categories[1]

			if data.weapon_id and weapon_tweak and data.factory_id and self[data.factory_id] then
				local either_weapon_or_category = nil

				for part_id, params in pairs(uses_parts) do
					weapon_pass = not params.weapon or table.contains(params.weapon, data.weapon_id)
					exclude_weapon_pass = not params.exclude_weapon or not table.contains(params.exclude_weapon, data.weapon_id)
					category_pass = not params.category or table.contains(params.category, primary_category)
					exclude_category_pass = not params.exclude_category or not table.contains(params.exclude_category, primary_category)
					either_weapon_or_category = params.weapon and params.category and true or false
					all_pass = (either_weapon_or_category and (weapon_pass or category_pass) or weapon_pass and category_pass) and exclude_weapon_pass and exclude_category_pass

					if all_pass then
						table.insert(self[data.factory_id].uses_parts, part_id)
						table.insert(self[data.factory_id .. "_npc"].uses_parts, part_id)
					end
				end
			end
		end
	end
end

-- Re-apply "smallified" stats to specific Sniper sights
function WeaponFactoryTweakData:factory_part_post_process()
	local smallify_scopes = self:_get_smallify_scopes()

	for k, v in pairs(self) do
		if v.default_blueprint then
			local is_weapon, weapon_id = managers.weapon_factory:is_factory_id_real_weapon_id(k)

			if is_weapon and tweak_data.weapon[weapon_id] and tweak_data.weapon[weapon_id].categories and table.contains(tweak_data.weapon[weapon_id].categories, "snp") then
				for _, part_id in ipairs(smallify_scopes) do
					local original_stats = self.parts[part_id].stats and deep_clone(self.parts[part_id].stats) or {}
					v.override = v.override or {}
					v.override[part_id] = v.override[part_id] or {}
					v.override[part_id].stats = v.override[part_id].stats or original_stats

					if v.override[part_id].stats.concealment then
						v.override[part_id].stats.concealment = (original_stats.concealment or 0) + 2
					end

					if v.override[part_id].stats.recoil then
						v.override[part_id].stats.recoil = (original_stats.recoil or 0) - 2
					end
				end
			end
		end
	end
end

-- Create a fresh list of Sniper sights that need to be "smallified"
function WeaponFactoryTweakData:_get_smallify_scopes()
	local rifle_sights = {}
	self:_create_part_type_list(rifle_sights, "wpn_fps_ass_m4", "sight")

	return rifle_sights
end

WeaponFactoryTweakData.shotgun_ammo_override_map = {
	["wpn_fps_shot_saiga"] = "very_light",
	["wpn_fps_sho_aa12"] = "very_light",
	["wpn_fps_sho_basset"] = "very_light",
	["wpn_fps_sho_striker"] = "very_light",
	["wpn_fps_sho_sko12"] = "very_light",
	["wpn_fps_sho_ben"] = "light",
	["wpn_fps_sho_spas12"] = "light",
	["wpn_fps_sho_rota"] = "light",
	["wpn_fps_sho_ultima"] = "light",
	["wpn_fps_shot_r870"] = "medium",
	["wpn_fps_shot_serbu"] = "medium",
	["wpn_fps_sho_ksg"] = "medium",
	["wpn_fps_pis_judge"] = "medium",
	["wpn_fps_sho_m590"] = "medium",
	["wpn_fps_shot_m37"] = "heavy",
	["wpn_fps_sho_boot"] = "heavy",
	["wpn_fps_shot_m1897"] = "heavy",
	["wpn_fps_sho_supernova"] = "heavy",
	["wpn_fps_shot_huntsman"] = "very_heavy",
	["wpn_fps_shot_b682"] = "very_heavy",
	["wpn_fps_sho_coach"] = "very_heavy",
}

-- Automatically balance Shotgun ammo types
function WeaponFactoryTweakData:_balance_shotgun_ammo(tweak_data)
	local slug_spread_mul = {
		2.5 / 3.5,
		2.5 / 3.5,
	}
	local slug_stance_muls = deep_clone(self._stance_multiplier_presets.shotgun_slug)
	local slug_fire_mode_bloom = deep_clone(self._fire_mode_bloom_presets.shotgun_slug)
	local slug_spread_bloom = deep_clone(self._spread_bloom_presets.shotgun_slug)

	self.parts.wpn_fps_upg_a_custom.stats = {
		damage = 8,
		recoil = -3,
	}
	self.parts.wpn_fps_upg_a_custom.custom_stats = {
		rays = 6,
		damage_near_mul = 0.5,
		muzzleflash = "effects/particles/weapons/sho_buckshot",
		trail_effect = "effects/particles/weapons/shotgun_streak_buck",
	}

	self.parts.wpn_fps_upg_a_custom_free.stats = {
		damage = 8,
		recoil = -3,
	}
	self.parts.wpn_fps_upg_a_custom_free.custom_stats = {
		rays = 6,
		damage_near_mul = 0.5,
		muzzleflash = "effects/particles/weapons/sho_buckshot",
		trail_effect = "effects/particles/weapons/shotgun_streak_buck",
	}

	self.parts.wpn_fps_upg_a_explosive.stats = {
		damage = 144,
		total_ammo_mod = -8,
		recoil = -1,
		spread = 2,
		spread_multi = slug_spread_mul,
	}
	self.parts.wpn_fps_upg_a_explosive.custom_stats = {
		rays = 1,
		ammo_pickup_max_mul = 0.4,
		ammo_pickup_min_mul = 0.4,
		damage_near_mul = 10,
		ammo_bag_consumption_mul = 1.5,
		stance_mul = slug_stance_muls,
		fire_mode_spread_bloom = slug_fire_mode_bloom,
		spread_bloom = slug_spread_bloom,
		ignore_statistic = true,
		explosive_ammo = true,
		ignore_crit_damage = true,
		bullet_class = "InstantExplosiveBulletBase",
		muzzleflash = "effects/payday2/particles/weapons/big_762_auto_fps",
		trail_effect = "effects/payday2/particles/weapons/streaks/traveling_streak",
	}

	self.parts.wpn_fps_upg_a_slug.stats = {
		damage = 64,
		total_ammo_mod = -6,
		recoil = -2,
		spread = 3,
		spread_multi = slug_spread_mul,
	}
	self.parts.wpn_fps_upg_a_slug.custom_stats = {
		rays = 1,
		armor_piercing_add = 1,
		max_nr_enemy_penetrations = 1,
		damage_near_mul = 10,
		stance_mul = slug_stance_muls,
		fire_mode_spread_bloom = slug_fire_mode_bloom,
		spread_bloom = slug_spread_bloom,
		check_additional_achievements = true,
		can_shoot_through_shield = true,
		can_shoot_through_wall = true,
		can_shoot_through_enemy = true,
		muzzleflash = "effects/payday2/particles/weapons/big_762_auto_fps",
		trail_effect = "effects/payday2/particles/weapons/streaks/traveling_streak",
	}

	self.parts.wpn_fps_upg_a_piercing.stats = {
		damage = -8,
		spread = 1,
	}
	self.parts.wpn_fps_upg_a_piercing.custom_stats = {
		rays = 12,
		armor_piercing_add = 1,
		max_nr_enemy_penetrations = 1,
		can_shoot_through_enemy = true,
		muzzleflash = "effects/particles/weapons/sho_flechette",
		trail_effect = "effects/particles/weapons/shotgun_streak_flech",
	}

	self.parts.wpn_fps_upg_a_dragons_breath.stats = {
		damage = -8,
		total_ammo_mod = -6,
		spread = -2,
	}
	self.parts.wpn_fps_upg_a_dragons_breath.custom_stats = {
		rays = 12,
		armor_piercing_add = 1,
		ammo_pickup_min_mul = 0.7,
		ammo_pickup_max_mul = 0.7,
		dot_data_name = "ammo_dragons_breath",
		bullet_class = "FlameBulletBase",
		muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_dragons_breath",
		trail_effect = "effects/particles/weapons/shotgun_streak_db",
	}
	self.parts.wpn_fps_upg_a_rip.stats = {
		damage = 48,
		total_ammo_mod = -8,
		spread = 1,
		spread_multi = slug_spread_mul,
	}
	self.parts.wpn_fps_upg_a_rip.custom_stats = {
		rays = 1,
		ammo_pickup_min_mul = 0.6,
		ammo_pickup_max_mul = 0.6,
		damage_near_mul = 10,
		stance_mul = slug_stance_muls,
		fire_mode_spread_bloom = slug_fire_mode_bloom,
		spread_bloom = slug_spread_bloom,
		dot_data_name = "ammo_rip",
		bullet_class = "PoisonBulletBase",
		muzzleflash = "effects/particles/weapons/sho_tomb",
		trail_effect = "effects/payday2/particles/weapons/streaks/traveling_streak_green",
	}

	local shotgun_ammo_stat_overrides = {
		wpn_fps_upg_a_custom = {
			very_heavy = {
				stats = { damage = 12 },
			},
			heavy = {
				stats = { damage = 10 },
			},
			medium = {
				stats = { damage = 8 },
			},
			light = {
				stats = { damage = 6 },
			},
			very_light = {
				stats = { damage = 6 },
			},
		},
		wpn_fps_upg_a_custom_free = {
			very_heavy = {
				stats = { damage = 12 },
			},
			heavy = {
				stats = { damage = 10 },
			},
			medium = {
				stats = { damage = 8 },
			},
			light = {
				stats = { damage = 6 },
			},
			very_light = {
				stats = { damage = 6 },
			},
		},
		wpn_fps_upg_a_explosive = {
			very_heavy = {
				stats = { damage = 216 },
			},
			heavy = {
				stats = { damage = 180 },
			},
			medium = {
				stats = { damage = 144 },
			},
			light = {
				stats = { damage = 108 },
			},
			very_light = {
				stats = { damage = 86 },
			},
		},
		wpn_fps_upg_a_slug = {
			very_heavy = {
				stats = { damage = 104 },
			},
			heavy = {
				stats = { damage = 76 },
			},
			medium = {
				stats = { damage = 64 },
			},
			light = {
				stats = { damage = 52 },
			},
			very_light = {
				stats = { damage = 38 },
			},
		},
		wpn_fps_upg_a_piercing = {
			very_heavy = {
				stats = { damage = -12 },
			},
			heavy = {
				stats = { damage = -10 },
			},
			medium = {
				stats = { damage = -8 },
			},
			light = {
				stats = { damage = -6 },
			},
			very_light = {
				stats = { damage = -5 },
			},
		},
		wpn_fps_upg_a_dragons_breath = {
			very_heavy = {
				stats = { damage = -12 },
			},
			heavy = {
				stats = { damage = -10 },
			},
			medium = {
				stats = { damage = -8 },
			},
			light = {
				stats = { damage = -6 },
			},
			very_light = {
				stats = { damage = -5 },
			},
		},
		wpn_fps_upg_a_rip = {
			very_heavy = {
				stats = { damage = 72 },
			},
			heavy = {
				stats = { damage = 60 },
			},
			medium = {
				stats = { damage = 48 },
			},
			light = {
				stats = { damage = 36 },
			},
			very_light = {
				stats = { damage = 26 },
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
			local ammo_tier = self.shotgun_ammo_override_map[based_on_factory_id or factory_id] or "medium"

			if self[factory_id] then
				if not self[factory_id].override then
					self[factory_id].override = {}
				end

				if shotgun_ammo_stat_overrides[part_id] and shotgun_ammo_stat_overrides[part_id][ammo_tier] then
					local part_override = shotgun_ammo_stat_overrides[part_id][ammo_tier]

					for stats_tbl_type, stats_tbl in pairs(part_override) do
						self[factory_id].override[part_id] = {}
						self[factory_id].override[part_id][stats_tbl_type] = deep_clone(self.parts[part_id][stats_tbl_type])

						for stat, stat_value in pairs(stats_tbl) do
							self[factory_id].override[part_id][stats_tbl_type][stat] = stat_value
						end
					end
				end
			end
		end
	end
end

WeaponFactoryTweakData.grenade_launcher_ammo_override_map = {
	["wpn_fps_gre_arbiter"] = "light",
	["wpn_fps_gre_ms3gl"] = "light",
	["wpn_fps_gre_m32"] = "light",
	["wpn_fps_gre_china"] = "heavy",
	["wpn_fps_gre_m79"] = "heavy",
	["wpn_fps_gre_slap"] = "heavy",
	["wpn_fps_ass_contraband"] = "heavy",
	["wpn_fps_ass_groza"] = "heavy",
}

-- Automatically balance Grenade Launcher ammo types
function WeaponFactoryTweakData:_balance_launcher_ammo(tweak_data)
	local custom_stats_tbl = {
		wpn_fps_upg_a_grenade_launcher_incendiary = {
			ammo_pickup_max_mul = 0.6,
			ammo_pickup_min_mul = 0.6,
			launcher_grenade = "launcher_incendiary",
		},
		wpn_fps_upg_a_grenade_launcher_electric = {
			ammo_pickup_max_mul = 0.8,
			ammo_pickup_min_mul = 0.8,
			launcher_grenade = "launcher_electric",
		},
		wpn_fps_upg_a_grenade_launcher_poison = {
			ammo_pickup_max_mul = 0.4,
			ammo_pickup_min_mul = 0.4,
			launcher_grenade = "launcher_poison",
		},
	}
	local grenade_launcher_ammo_overrides = {
		wpn_fps_upg_a_grenade_launcher_incendiary = {
			heavy = {
				stats = { damage = 0 },
				custom_stats = deep_clone(custom_stats_tbl.wpn_fps_upg_a_grenade_launcher_incendiary),
			},
			medium = {
				stats = { damage = 0 },
				custom_stats = deep_clone(custom_stats_tbl.wpn_fps_upg_a_grenade_launcher_incendiary),
			},
			light = {
				stats = { damage = 0 },
				custom_stats = deep_clone(custom_stats_tbl.wpn_fps_upg_a_grenade_launcher_incendiary),
			},
			default = {
				stats = { damage = 0 },
				custom_stats = deep_clone(custom_stats_tbl.wpn_fps_upg_a_grenade_launcher_incendiary),
			},
		},
		wpn_fps_upg_a_grenade_launcher_electric = {
			heavy = {
				stats = { damage = 0 },
				custom_stats = deep_clone(custom_stats_tbl.wpn_fps_upg_a_grenade_launcher_electric),
			},
			medium = {
				stats = { damage = 0 },
				custom_stats = deep_clone(custom_stats_tbl.wpn_fps_upg_a_grenade_launcher_electric),
			},
			light = {
				stats = { damage = 0 },
				custom_stats = deep_clone(custom_stats_tbl.wpn_fps_upg_a_grenade_launcher_electric),
			},
			default = {
				stats = { damage = 0 },
				custom_stats = deep_clone(custom_stats_tbl.wpn_fps_upg_a_grenade_launcher_electric),
			},
		},
		wpn_fps_upg_a_grenade_launcher_poison = {
			heavy = {
				stats = { damage = 0 },
				custom_stats = deep_clone(custom_stats_tbl.wpn_fps_upg_a_grenade_launcher_poison),
			},
			medium = {
				stats = { damage = 0 },
				custom_stats = deep_clone(custom_stats_tbl.wpn_fps_upg_a_grenade_launcher_poison),
			},
			light = {
				stats = { damage = 0 },
				custom_stats = deep_clone(custom_stats_tbl.wpn_fps_upg_a_grenade_launcher_poison),
			},
			default = {
				stats = { damage = 0 },
				custom_stats = deep_clone(custom_stats_tbl.wpn_fps_upg_a_grenade_launcher_poison),
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

-- Automatically balance magazine mods based on capacity
function WeaponFactoryTweakData:_balance_magazine(tweak_data, part_id, no_stat_wipe)
	local upgrade_definitions = tweak_data.upgrades.definitions

	for weap_id, weap_data in pairs(upgrade_definitions) do
		local factory_id = weap_data.factory_id

		local weapon_tweak = tweak_data.weapon and tweak_data.weapon[weap_id]
		local is_akimbo = weapon_tweak and table.contains(weapon_tweak.categories, "akimbo")

		local shotgun_reload = weapon_tweak and weapon_tweak.use_shotgun_reload or weapon_tweak and weapon_tweak.timers and weapon_tweak.timers.shotgun_reload_shell or nil
		local mag_capacity = weapon_tweak and weapon_tweak.CLIP_AMMO_MAX

		local part_data = self.parts[part_id]
		if part_data and not is_akimbo then
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

							local reload_stat = -math.clamp(math.floor(capacity_increase / 20), -5, 5)
							local concealment_stat = -math.clamp(math.round(capacity_increase / 30), -10, 10)
							local spread_stat = (capacity_increase >= 100 and -math.clamp(math.floor(capacity_increase / 75), 0, 5) or 0)
							local recoil_stat = (capacity_increase >= 100 and math.clamp(math.floor(capacity_increase / 100), 0, 5) or 0)

							part_data.stats.recoil = (no_stat_wipe and (part_data.stats.recoil or 0) or 0) + recoil_stat
							part_data.stats.spread = (no_stat_wipe and (part_data.stats.spread or 0) or 0) + spread_stat
							part_data.stats.concealment = (no_stat_wipe and (part_data.stats.concealment or 0) or 0) + concealment_stat
							part_data.stats.reload = (no_stat_wipe and (part_data.stats.reload or 0) or 0) + reload_stat
							part_data.is_supported = true
						end
					end
				end
			end
		end
	end
end

-- Automatically balance underbarrel weapon stats
function WeaponFactoryTweakData:_balance_underbarrel(tweak_data, part_id)
	local upgrade_definitions = tweak_data.upgrades.definitions

	for weap_id, weap_data in pairs(upgrade_definitions) do
		local factory_id = weap_data.factory_id
		local weapon_tweak = tweak_data.weapon and tweak_data.weapon[weap_id]

		if weapon_tweak and self[factory_id] then
			if not self[factory_id].override then
				self[factory_id].override = {}
			end

			local part_data = self.parts[part_id]
			if part_data then
				if not self[factory_id].override[part_id] then
					self[factory_id].override[part_id] = {}
				end

				if not self[factory_id].override[part_id].custom_stats then
					self[factory_id].override[part_id].custom_stats = {}
				end

				local weap_total_ammo = weapon_tweak.AMMO_MAX
				local damage_ratio_round = math.round(weap_total_ammo * 0.5, weapon_tweak.CLIP_AMMO_MAX) / weap_total_ammo

				self[factory_id].override[part_id].custom_stats.ammo_max_mul = damage_ratio_round
				self[factory_id].override[part_id].custom_stats.ammo_pickup_min_mul = 0.75
				self[factory_id].override[part_id].custom_stats.ammo_pickup_max_mul = self[factory_id].override[part_id].custom_stats.ammo_pickup_min_mul
			end
		end
	end
end

-- Delete the burst fire mod from specific weapon categories
function WeaponFactoryTweakData:_wipe_burst_fire_mode(tweak_data)
	local burst_fire_whitelist = {
		"assault_rifle",
		"smg",
		"pistol",
	}

	local upgrade_definitions = tweak_data.upgrades.definitions

	for weap_id, weap_data in pairs(upgrade_definitions) do
		local factory_id = weap_data.factory_id
		local weap_data = tweak_data.weapon and tweak_data.weapon[weap_id]
		local weap_category = weap_data and weap_data.categories

		if weap_category then
			local is_akimbo = table.contains(weap_category, "akimbo")

			if is_akimbo or not table.contains(burst_fire_whitelist, weap_category[1]) then
				local uses_parts = self[factory_id] and self[factory_id].uses_parts
				if uses_parts then
					table.delete(uses_parts, "wpn_fps_upg_i_burstfire")
				end
			end
		end
	end
end

-- Automatically balance suppressor stats based on concealment
function WeaponFactoryTweakData:_balance_silencer(part_id, is_barrel_ext)
	local part_data = self.parts[part_id]
	if part_data then
		if part_data.stats then
			part_data.stats.suppression = math.min((part_data.stats.suppression or 0) + 9, 12)
			part_data.stats.alert_size = math.min((part_data.stats.alert_size or 0) + 9, 12)

			if part_data.stats.concealment and is_barrel_ext then
				part_data.stats.damage = -math.max(4 + part_data.stats.concealment, 0)
			end
		end
	end
end

-- Automatically balance conversion kits based on damage
function WeaponFactoryTweakData:_balance_conversion_kit(tweak_data, weap_id, part_id, damage, category, round_total_ammo)
	local upgrade_definitions = tweak_data.upgrades.definitions

	local function category_swap_stats_table(category_old, category_new)
		local reference_old_weap_id = self.category_templates[category_old]
		local reference_new_weap_id = self.category_templates[category_new]
		local reference_old_tweak = tweak_data.weapon and tweak_data.weapon[reference_old_weap_id]
		local reference_new_tweak = tweak_data.weapon and tweak_data.weapon[reference_new_weap_id]

		local stats_tbl = {}
		local custom_stats_tbl = {}
		if reference_new_tweak and reference_old_tweak then
			custom_stats_tbl.ammo_max_mul = reference_new_tweak.total_ammo_mul or 1
			custom_stats_tbl.ammo_pickup_max_mul = reference_new_tweak.pickup_mul or 1
			custom_stats_tbl.ammo_pickup_min_mul = reference_new_tweak.pickup_mul or 1
			custom_stats_tbl.steelsight_move_speed_mul = reference_new_tweak.steelsight_move_speed_mul or reference_old_tweak.steelsight_move_speed_mul
			custom_stats_tbl.max_nr_enemy_penetrations = reference_new_tweak.max_nr_enemy_penetrations or reference_old_tweak.max_nr_enemy_penetrations
			custom_stats_tbl.can_shoot_through_enemy = reference_new_tweak.max_nr_enemy_penetrations or reference_old_tweak.max_nr_enemy_penetrations
			custom_stats_tbl.steelsight_time_mul = reference_new_tweak.steelsight_time
					and reference_old_tweak.steelsight_time
					and (reference_new_tweak.steelsight_time / reference_old_tweak.steelsight_time)
				or 1
			custom_stats_tbl.stance_mul = deep_clone(reference_new_tweak.stance_multipliers or reference_old_tweak.stance_multipliers)
			custom_stats_tbl.fire_mode_mul = deep_clone(reference_new_tweak.fire_mode_multipliers or reference_old_tweak.fire_mode_multipliers)
			custom_stats_tbl.fire_mode_spread_bloom = deep_clone(reference_new_tweak.fire_mode_spread_bloom or reference_old_tweak.fire_mode_spread_bloom)
			custom_stats_tbl.spread_bloom = deep_clone(reference_new_tweak.spread_bloom or reference_old_tweak.spread_bloom)

			if reference_new_tweak.stats then
				stats_tbl.alert_size = reference_new_tweak.stats.alert_size - reference_old_tweak.stats.alert_size
				stats_tbl.suppression = reference_new_tweak.stats.suppression - reference_old_tweak.stats.suppression
			end
		end

		return stats_tbl, custom_stats_tbl
	end

	local factory_id = upgrade_definitions[weap_id] and upgrade_definitions[weap_id].factory_id
	local weap_data = tweak_data.weapon and tweak_data.weapon[weap_id]

	if factory_id and weap_data then
		local weap_damage, part_damage, damage_ratio
		local dmg_modifier = weap_data.stats_modifiers and weap_data.stats_modifiers.damage or 1

		if damage then
			weap_damage = math.min(weap_data.stats.damage, #tweak_data.weapon.stats.damage) * dmg_modifier
			part_damage = math.round((damage - weap_damage) / dmg_modifier)
			damage_ratio = weap_damage / damage
		end

		if self[factory_id] then
			if not self[factory_id].override then
				self[factory_id].override = {}
			end

			if not self[factory_id].override[part_id] then
				self[factory_id].override[part_id] = {}
			end

			self[factory_id].override[part_id].stats = deep_clone(self.parts[part_id].stats) or {}
			self[factory_id].override[part_id].custom_stats = deep_clone(self.parts[part_id].custom_stats) or {}

			local weap_category = weap_data.categories and weap_data.categories[1]
			if category and weap_category then
				local cat_swap_stats, cat_swap_custom_stats = category_swap_stats_table(weap_category, category)

				for k, v in pairs(cat_swap_custom_stats) do
					self[factory_id].override[part_id].custom_stats[k] = v
				end

				for k, v in pairs(cat_swap_stats) do
					self[factory_id].override[part_id].stats[k] = v
				end
			end

			local snp_total_ammo_mul, snp_pickup_mul = tweak_data.weapon:_calculate_snp_ammo_mul(damage, weap_data.total_ammo_scale, weap_data.pickup_scale)

			self[factory_id].override[part_id].stats.damage = (self[factory_id].override[part_id].stats.damage or 0) + (part_damage or 0)
			self[factory_id].override[part_id].custom_stats.ammo_max_mul = (self[factory_id].override[part_id].custom_stats.ammo_max_mul or 1) * (damage_ratio or 1) * (snp_total_ammo_mul or 1)
			self[factory_id].override[part_id].custom_stats.ammo_pickup_max_mul = (self[factory_id].override[part_id].custom_stats.ammo_pickup_max_mul or 1)
				* (damage_ratio or 1)
				* (snp_pickup_mul or 1)
			self[factory_id].override[part_id].custom_stats.ammo_pickup_min_mul = (self[factory_id].override[part_id].custom_stats.ammo_pickup_min_mul or 1)
				* (damage_ratio or 1)
				* (snp_pickup_mul or 1)

			if round_total_ammo then
				local weap_total_ammo = weap_data.AMMO_MAX
				local part_total_ammo = weap_total_ammo * self[factory_id].override[part_id].custom_stats.ammo_max_mul
				local part_mag_capacity = weap_data.CLIP_AMMO_MAX + (self[factory_id].override[part_id].stats.extra_ammo or 0)
				local damage_ratio_round = math.round(part_total_ammo, part_mag_capacity) / weap_total_ammo

				self[factory_id].override[part_id].custom_stats.ammo_max_mul = damage_ratio_round
			end
		end
	end
end

-- Delete the burst fire mod from specific weapon categories
function WeaponFactoryTweakData:_wipe_burst_fire_mode(tweak_data)
	local burst_fire_whitelist = {
		"assault_rifle",
		"smg",
		"pistol",
	}

	local upgrade_definitions = tweak_data.upgrades.definitions

	for weap_id, weap_data in pairs(upgrade_definitions) do
		local factory_id = weap_data.factory_id
		local weap_data = tweak_data.weapon and tweak_data.weapon[weap_id]
		local weap_category = weap_data and weap_data.categories

		if weap_category then
			local is_akimbo = table.contains(weap_category, "akimbo")

			if is_akimbo or not table.contains(burst_fire_whitelist, weap_category[1]) then
				local uses_parts = self[factory_id] and self[factory_id].uses_parts
				if uses_parts then
					table.delete(uses_parts, "wpn_fps_upg_i_burstfire")
				end
			end
		end
	end
end

-- Automatically balance underbarrel weapon stats based on concealment
function WeaponFactoryTweakData:_convert_concealment_to_mobility(tweak_data)
	for part_id, part_data in pairs(self.parts) do
		if part_data.stats and part_data.stats.concealment then
			part_data.stats.mobility = part_data.stats.concealment
		end
	end
end

-- Balance Flare Gun ammunition types
function WeaponFactoryTweakData:_balance_flun_ammo(tweak_data)
	self.parts.wpn_fps_upg_a_flun_shell.stats.spread = nil
	self.parts.wpn_fps_upg_a_flun_shell.stats.total_ammo_mod = nil
	self.parts.wpn_fps_upg_a_flun_shell.custom_stats.rays = 8
	self.parts.wpn_fps_upg_a_flun_shell.custom_stats.ammo_pickup_min_mul = nil
	self.parts.wpn_fps_upg_a_flun_shell.custom_stats.ammo_pickup_max_mul = nil
	self.parts.wpn_fps_upg_a_flun_shell.custom_stats.stance_mul = deep_clone(self._stance_multiplier_presets.shotgun)
	self.parts.wpn_fps_upg_a_flun_shell.custom_stats.muzzleflash = "effects/particles/weapons/sho_default"
	self.parts.wpn_fps_upg_a_flun_shell.custom_stats.trail_effect = "effects/particles/weapons/shotgun_streak"

	local base_pickup_mul = tweak_data.weapon and tweak_data.weapon.flun and tweak_data.weapon.flun.pickup_mul or 1
	local sec_gl_pickup_mul = tweak_data.weapon and tweak_data.weapon.gre_m79 and tweak_data.weapon.gre_m79.pickup_mul or 1

	self.parts.wpn_fps_upg_a_flun_flare.stats.spread = 6
	self.parts.wpn_fps_upg_a_flun_flare.stats.total_ammo_mod = -10
	self.parts.wpn_fps_upg_a_flun_flare.custom_stats.ammo_pickup_min_mul = base_pickup_mul / sec_gl_pickup_mul
	self.parts.wpn_fps_upg_a_flun_flare.custom_stats.ammo_pickup_max_mul = self.parts.wpn_fps_upg_a_flun_flare.custom_stats.ammo_pickup_min_mul

	local flun_shotgun_ammos = {
		"wpn_fps_upg_a_explosive",
		"wpn_fps_upg_a_slug",
		"wpn_fps_upg_a_piercing",
		"wpn_fps_upg_a_dragons_breath",
		"wpn_fps_upg_a_rip",
	}
	local flun_ammo_stat_overrides = {
		wpn_fps_upg_a_explosive = {
			stats = { damage = 216 },
		},
		wpn_fps_upg_a_slug = {
			stats = { damage = 104 },
		},
		wpn_fps_upg_a_piercing = {
			stats = { damage = -12 },
		},
		wpn_fps_upg_a_dragons_breath = {
			stats = { damage = -12 },
		},
		wpn_fps_upg_a_rip = {
			stats = { damage = 72 },
		},
	}

	for _, ammo_id in ipairs(flun_shotgun_ammos) do
		local ammo_override = self.wpn_fps_spe_flun.override[ammo_id] or {}
		ammo_override.parent = "lower_body"
		ammo_override.a_obj = "a_shell"
		ammo_override.unit = "units/pd2_dlc_unk/weapons/wpn_fps_spe_flun_pts/ammos/wpn_fps_upg_a_flun_shot"
		ammo_override.bullet_objects = {
			amount = 1,
			prefix = "g_bullet_",
		}
		ammo_override.sound_switch = {
			suppressed = "regular_b",
		}
		ammo_override.stats = deep_clone(self.parts[ammo_id].stats)
		ammo_override.custom_stats = deep_clone(self.parts[ammo_id].custom_stats)
		ammo_override.custom_stats.stance_mul = deep_clone(self._stance_multiplier_presets.shotgun)
		ammo_override.custom_stats.weapon_unit = "units/pd2_dlc_unk/weapons/wpn_fps_spe_flun/wpn_fps_sho_flun"

		self.wpn_fps_spe_flun.override[ammo_id] = ammo_override

		local part_override = flun_ammo_stat_overrides[ammo_id]
		for stats_tbl_type, stats_tbl in pairs(part_override) do
			for stat, stat_value in pairs(stats_tbl) do
				ammo_override[stats_tbl_type][stat] = stat_value
			end
		end

		table.insert(self.wpn_fps_spe_flun.uses_parts, ammo_id)
	end
end

-- Kind of hacky, but it works
Hooks:PostHook(WeaponFactoryTweakData, "_add_charms_to_all_weapons", "eclipse_add_charms_to_all_weapons", function(self, tweak_data)
	self._stance_multiplier_presets = {
		dmr = self:_get_table_from_category_template(tweak_data, "dmr", "stance_multipliers"),
		shotgun = self:_get_table_from_category_template(tweak_data, "shotgun", "stance_multipliers"),
		shotgun_slug = {
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
		},
	}
	self._fire_mode_bloom_presets = {
		shotgun_slug = {
			["single"] = {
				per_shot = 1.5,
				per_shot_steelsight = 1,
			},
			["auto"] = {
				per_shot = 1.5,
				per_shot_steelsight = 1,
			},
		},
	}
	self._spread_bloom_presets = {
		shotgun_slug = {
			max = 2.5,
			recovery = 1.2,
			recovery_wait_multiplier = 1.4,
		},
	}

	self.parts.wpn_fps_upg_charm_eclipse = deep_clone(self.parts.wpn_fps_upg_charm_cloaker)
	self.parts.wpn_fps_upg_charm_eclipse.texture_bundle_folder = "eclipse"
	self.parts.wpn_fps_upg_charm_eclipse.name_id = "bm_wp_upg_charm_eclipse"
	self.parts.wpn_fps_upg_charm_eclipse.unit = "units/pd2_mod_eclipse/weapons/wpn_fps_upg_charms/wpn_fps_upg_charm_eclipse"
	self.parts.wpn_fps_upg_charm_eclipse.third_unit = "units/pd2_mod_eclipse/weapons/wpn_fps_upg_charms/wpn_third_upg_charm_eclipse"

	local fire_mode_locks = {
		"wpn_fps_upg_i_singlefire",
		"wpn_fps_upg_i_autofire",
		"wpn_fps_upg_i_burstfire",
	}

	self.parts.wpn_fps_lmg_hcar_body_conversionkit.stats.extra_ammo = 15
	self.parts.wpn_fps_lmg_hcar_body_conversionkit.stats.total_ammo_mod = 0
	self.parts.wpn_fps_lmg_hcar_body_conversionkit.stats.damage = 0
	self.parts.wpn_fps_lmg_hcar_body_conversionkit.stats.spread = -2
	self.parts.wpn_fps_lmg_hcar_body_conversionkit.stats.recoil = 4
	self.parts.wpn_fps_lmg_hcar_body_conversionkit.stats.concealment = 0
	self.parts.wpn_fps_lmg_hcar_body_conversionkit.custom_stats = {}
	self.parts.wpn_fps_lmg_hcar_body_conversionkit.custom_stats.fire_rate_multiplier = 750 / 450
	self.parts.wpn_fps_lmg_hcar_body_conversionkit.custom_stats.muzzleflash = "effects/payday2/particles/weapons/556_auto_fps"
	self.parts.wpn_fps_lmg_hcar_body_conversionkit.custom_stats.trail_effect = "effects/particles/weapons/weapon_trail"
	self:_balance_conversion_kit(tweak_data, "hcar", "wpn_fps_lmg_hcar_body_conversionkit", 36, "assault_rifle", true)
	self:_balance_magazine(tweak_data, "wpn_fps_lmg_hcar_body_conversionkit", true)

	self.parts.wpn_fps_lmg_kacchainsaw_conversionkit.stats.extra_ammo = 0
	self.parts.wpn_fps_lmg_kacchainsaw_conversionkit.stats.total_ammo_mod = 0
	self.parts.wpn_fps_lmg_kacchainsaw_conversionkit.stats.damage = 0
	self.parts.wpn_fps_lmg_kacchainsaw_conversionkit.stats.spread = 0
	self.parts.wpn_fps_lmg_kacchainsaw_conversionkit.stats.recoil = 2
	self.parts.wpn_fps_lmg_kacchainsaw_conversionkit.custom_stats = { fire_rate_multiplier = 1800 / 1100 }
	self:_balance_conversion_kit(tweak_data, "kacchainsaw", "wpn_fps_lmg_kacchainsaw_conversionkit", 12, nil, true)

	self.parts.wpn_fps_pis_deagle_ck.stats.damage = 0
	self.parts.wpn_fps_pis_deagle_ck.stats.spread = 0
	self.parts.wpn_fps_pis_deagle_ck.stats.recoil = 2
	self.parts.wpn_fps_pis_deagle_ck.stats.concealment = -1
	self.parts.wpn_fps_pis_deagle_ck.custom_stats = { ammo_offset = 3 }
	self:_balance_conversion_kit(tweak_data, "deagle", "wpn_fps_pis_deagle_ck", 64, nil, true)

	self.parts.wpn_fps_smg_mp5_m_straight.stats.damage = 0
	self.parts.wpn_fps_smg_mp5_m_straight.stats.recoil = -3
	self.parts.wpn_fps_smg_mp5_m_straight.stats.concealment = 0
	self.parts.wpn_fps_smg_mp5_m_straight.stats.custom_stats.muzzleflash = "effects/payday2/particles/weapons/45cal_smg_fps"
	self:_balance_conversion_kit(tweak_data, "new_mp5", "wpn_fps_smg_mp5_m_straight", 24, nil, true)

	self.parts.wpn_fps_pis_korth_m_6.stats.extra_ammo = -1
	self.parts.wpn_fps_pis_korth_m_6.stats.damage = 0
	self.parts.wpn_fps_pis_korth_m_6.stats.spread = 2
	self.parts.wpn_fps_pis_korth_m_6.stats.recoil = -4
	self.parts.wpn_fps_pis_korth_m_6.stats.concealment = 0
	self.parts.wpn_fps_pis_korth_m_6.no_magazine_balancing = true
	self.parts.wpn_fps_pis_korth_m_6.custom_stats = {}
	self:_balance_conversion_kit(tweak_data, "korth", "wpn_fps_pis_korth_m_6", 80, nil, true)

	self.parts.wpn_fps_m4_upg_fg_mk12.stats.damage = 0
	self.parts.wpn_fps_m4_upg_fg_mk12.stats.spread = 3
	self.parts.wpn_fps_m4_upg_fg_mk12.stats.recoil = -2
	self.parts.wpn_fps_m4_upg_fg_mk12.custom_stats = { fire_rate_multiplier = 600 / 750 }
	table.delete(self.parts.wpn_fps_m4_upg_fg_mk12.perks, "fire_mode_auto")
	self:_balance_conversion_kit(tweak_data, "new_m4", "wpn_fps_m4_upg_fg_mk12", 36, nil, true)

	self:_balance_conversion_kit(tweak_data, "galil", "wpn_fps_ass_galil_fg_sniper", 64, nil, true)

	self.parts.wpn_fps_ass_g3_b_sniper.stats.total_ammo_mod = 0
	self.parts.wpn_fps_ass_g3_b_sniper.stats.damage = 0
	self.parts.wpn_fps_ass_g3_b_sniper.custom_stats = {}
	self.parts.wpn_fps_ass_g3_b_sniper.perks = { "fire_mode_single" }
	self.parts.wpn_fps_ass_g3_b_sniper.adds = nil -- wtf is this, why do you need a separate dummy part for ammo pickup specifically
	self:_balance_conversion_kit(tweak_data, "g3", "wpn_fps_ass_g3_b_sniper", 64, nil, true)
	self:_add_forbids_from_list("wpn_fps_ass_g3_b_sniper", fire_mode_locks)

	self.parts.wpn_fps_ass_fal_fg_04.stats.damage = 0
	self.parts.wpn_fps_ass_fal_fg_04.perks = { "fire_mode_single" }
	self:_balance_conversion_kit(tweak_data, "fal", "wpn_fps_ass_fal_fg_04", 64, nil, true)
	self:_add_forbids_from_list("wpn_fps_ass_fal_fg_04", fire_mode_locks)

	self.parts.wpn_fps_ass_shak12_body_vks.stats.total_ammo_mod = 0
	self.parts.wpn_fps_ass_shak12_body_vks.stats.extra_ammo = -5
	self.parts.wpn_fps_ass_shak12_body_vks.stats.spread = 2
	self.parts.wpn_fps_ass_shak12_body_vks.stats.recoil = -6
	self.parts.wpn_fps_ass_shak12_body_vks.stats.concealment = -2
	self.parts.wpn_fps_ass_shak12_body_vks.custom_stats = {}
	self:_balance_conversion_kit(tweak_data, "shak12", "wpn_fps_ass_shak12_body_vks", 72, nil, true)
	self:_add_forbids_from_list("wpn_fps_ass_shak12_body_vks", fire_mode_locks)

	self.parts.wpn_fps_upg_ass_m4_b_beowulf.stats.total_ammo_mod = 0
	self.parts.wpn_fps_upg_ass_m4_b_beowulf.stats.damage = 0
	self.parts.wpn_fps_upg_ass_m4_b_beowulf.stats.recoil = -5
	self.parts.wpn_fps_upg_ass_m4_b_beowulf.custom_stats = {}
	self.parts.wpn_fps_upg_ass_m4_b_beowulf.custom_stats.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.parts.wpn_fps_upg_ass_m4_b_beowulf.custom_stats.trail_effect = "effects/payday2/particles/weapons/streaks/traveling_streak"
	self.parts.wpn_fps_upg_ass_m4_b_beowulf.perks = { "fire_mode_single" }
	self:_balance_conversion_kit(tweak_data, "new_m4", "wpn_fps_upg_ass_m4_b_beowulf", 48, "dmr", true)
	self:_balance_conversion_kit(tweak_data, "m16", "wpn_fps_upg_ass_m4_b_beowulf", 64, "dmr", true)
	self:_add_forbids_from_list("wpn_fps_upg_ass_m4_b_beowulf", fire_mode_locks)

	self.parts.wpn_fps_upg_ass_ak_b_zastava.stats.total_ammo_mod = 0
	self.parts.wpn_fps_upg_ass_ak_b_zastava.stats.damage = 0
	self.parts.wpn_fps_upg_ass_ak_b_zastava.stats.recoil = -5
	self.parts.wpn_fps_upg_ass_ak_b_zastava.custom_stats = {}
	self.parts.wpn_fps_upg_ass_ak_b_zastava.custom_stats.muzzleflash = "effects/payday2/particles/weapons/762_auto_fps"
	self.parts.wpn_fps_upg_ass_ak_b_zastava.custom_stats.trail_effect = "effects/payday2/particles/weapons/streaks/traveling_streak"
	self.parts.wpn_fps_upg_ass_ak_b_zastava.perks = { "fire_mode_single" }
	self:_balance_conversion_kit(tweak_data, "ak74", "wpn_fps_upg_ass_ak_b_zastava", 48, "dmr", true)
	self:_balance_conversion_kit(tweak_data, "akm", "wpn_fps_upg_ass_ak_b_zastava", 64, "dmr", true)
	self:_balance_conversion_kit(tweak_data, "akm_gold", "wpn_fps_upg_ass_ak_b_zastava", 64, "dmr", true)
	self:_add_forbids_from_list("wpn_fps_upg_ass_ak_b_zastava", fire_mode_locks)

	for part_id, part_data in pairs(self.parts) do
		local is_barrel_ext = part_data.type and part_data.type == "barrel_ext"
		local is_silencer = part_data.perks and table.contains(part_data.perks, "silencer")
		if is_silencer and not part_data.no_silencer_balancing then
			self:_balance_silencer(part_id, is_barrel_ext)
		end

		local is_underbarrel = part_data.perks and table.contains(part_data.perks, "underbarrel")
		if is_underbarrel and not part_data.no_underbarrel_balancing then
			self:_balance_underbarrel(tweak_data, part_id)
		end

		local is_magazine = part_data.type and part_data.type == "magazine"
		if is_magazine and not part_data.no_magazine_balancing then
			self:_balance_magazine(tweak_data, part_id, false)
		end
	end

	self:_add_parts_to_all(tweak_data)
	self:_add_parts_from_template(tweak_data)
	self:_balance_shotgun_ammo(tweak_data)
	self:_balance_launcher_ammo(tweak_data)
	self:_balance_akimbo(tweak_data)
	self:_balance_flun_ammo(tweak_data)
	self:_wipe_burst_fire_mode(tweak_data)
	self:_convert_concealment_to_mobility()
end)

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

	local shotgun_stance_muls = {
		spread = {
			standing = {
				hipfire = 0.9,
				crouching = 1,
				steelsight = 0.7,
			},
			moving = {
				hipfire = 0.9,
				crouching = 1,
				steelsight = 0.9,
			},
		},
		recoil = {
			standing = {
				hipfire = 1.1,
				crouching = 1,
				steelsight = 0.9,
			},
			moving = {
				hipfire = 1.3,
				crouching = 1,
				steelsight = 1.2,
			},
		},
	}
	local sting_stats = {
		light = {
			damage = -37,
			spread = -6,
		},
		medium = {
			damage = -37,
			spread = -6,
		},
		heavy = {
			damage = -56,
			spread = -6,
		},
	}
	local sting_custom_stats = {
		muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_hornet",
		armor_piercing_add = 1,
		max_nr_enemy_penetrations = 1,
		ammo_bag_consumption_mul = 1,
		is_explosive = false,
		can_shoot_through_shield = true,
		can_shoot_through_enemy = true,
		ignore_damage_upgrades = false,
		stance_mul = shotgun_stance_muls,
		sounds = {
			fire_single = "hornet_fire",
		},
	}
	local grenade_launchers = {
		wpn_fps_gre_arbiter = {
			stats = sting_stats.light,
			custom_stats = deep_clone(sting_custom_stats),
		},
		wpn_fps_gre_ms3gl = {
			stats = sting_stats.light,
			custom_stats = deep_clone(sting_custom_stats),
		},
		wpn_fps_gre_m32 = {
			stats = sting_stats.medium,
			custom_stats = deep_clone(sting_custom_stats),
		},
		wpn_fps_gre_china = {
			stats = sting_stats.medium,
			custom_stats = deep_clone(sting_custom_stats),
		},
		wpn_fps_gre_m79 = {
			stats = sting_stats.heavy,
			custom_stats = deep_clone(sting_custom_stats),
		},
		wpn_fps_gre_slap = {
			stats = sting_stats.heavy,
			custom_stats = deep_clone(sting_custom_stats),
		},
	}
	local grenade_underbarrels = {
		wpn_fps_ass_groza = {
			stats = sting_stats.heavy,
			custom_stats = deep_clone(sting_custom_stats),
		},
		wpn_fps_ass_contraband = {
			stats = sting_stats.heavy,
			custom_stats = deep_clone(sting_custom_stats),
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
