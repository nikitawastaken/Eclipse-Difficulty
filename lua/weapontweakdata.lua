WeaponTweakData.WEAPON_TOTAL_DMG = 360
WeaponTweakData.WEAPON_PICKUP_DMG = 16
WeaponTweakData.SECONDARY_TOTAL_DMG_MUL = 1 / 2
WeaponTweakData.SECONDARY_PICKUP_DMG_MUL = 3 / 4
WeaponTweakData.UNDERBARREL_TOTAL_DMG_MUL = 1 / 3
WeaponTweakData.UNDERBARREL_PICKUP_DMG_MUL = 1 / 2
WeaponTweakData.AP_TOTAL_DMG_MUL = 1 / 2
WeaponTweakData.AP_PICKUP_DMG_MUL = 1 / 4
WeaponTweakData.SILENCED_MUZZLEFLASH_MAP = {
	["effects/payday2/particles/weapons/hailstorm_effect"] = "effects/payday2/particles/weapons/hailstorm_suppressed",
	["effects/payday2/particles/weapons/45cal_pistol_fps"] = "effects/payday2/particles/weapons/45cal_silenced",
	["effects/payday2/particles/weapons/45cal_smg_fps"] = "effects/payday2/particles/weapons/45cal_silenced",
	["effects/payday2/particles/weapons/45cal_deagle_fps"] = "effects/payday2/particles/weapons/45cal_silenced",
	["effects/payday2/particles/weapons/357_revolver_fps"] = "effects/payday2/particles/weapons/45cal_silenced",
	["effects/payday2/particles/weapons/556_auto_fps"] = "effects/payday2/particles/weapons/556_silenced",
	["effects/particles/weapons/sho_default"] = "effects/payday2/particles/weapons/556_silenced",
	["effects/payday2/particles/weapons/50cal_auto_fps"] = "effects/payday2/particles/weapons/762_silenced",
	["effects/payday2/particles/weapons/762_auto_fps"] = "effects/payday2/particles/weapons/762_silenced",
	["effects/payday2/particles/weapons/big_762_auto_fps"] = "effects/payday2/particles/weapons/762_silenced",
	["effects/payday2/particles/weapons/9mm_pistol_fps"] = "effects/payday2/particles/weapons/9mm_silenced",
	["effects/payday2/particles/weapons/9mm_smg_fps"] = "effects/payday2/particles/weapons/9mm_silenced",
}
WeaponTweakData.WEAPON_MUZZLEFLASHES = {
	ranc_heavy_machine_gun = "effects/payday2/particles/weapons/50cal_browning_turret",
	hailstorm = "effects/payday2/particles/weapons/hailstorm_effect",
	bessy = "effects/payday2/particles/weapons/bessy_muzzle",
	m95 = "effects/payday2/particles/weapons/50cal_auto_fps",
	shak12 =  "effects/payday2/particles/weapons/50cal_auto",
	deagle = "effects/payday2/particles/weapons/45cal_deagle_fps",
	p226 = "effects/payday2/particles/weapons/45cal_pistol_fps",
	g22c = "effects/payday2/particles/weapons/45cal_pistol_fps",
	hs2000 = "effects/payday2/particles/weapons/45cal_pistol_fps",
	sparrow = "effects/payday2/particles/weapons/45cal_pistol_fps",
	m1911 = "effects/payday2/particles/weapons/45cal_pistol_fps",
	usp = "effects/payday2/particles/weapons/45cal_pistol_fps",
	shrew = "effects/payday2/particles/weapons/45cal_pistol_fps",
	colt_1911 = "effects/payday2/particles/weapons/45cal_pistol_fps",
	type54 = "effects/payday2/particles/weapons/45cal_pistol_fps",
	sub2000 = "effects/payday2/particles/weapons/45cal_smg_fps",
	mac10 = "effects/payday2/particles/weapons/45cal_smg_fps",
	m1928 = "effects/payday2/particles/weapons/45cal_smg_fps",
	polymer = "effects/payday2/particles/weapons/45cal_smg_fps",
	cobray = "effects/payday2/particles/weapons/45cal_smg_fps",
	schakal = "effects/payday2/particles/weapons/45cal_smg_fps",
	-- NPC weapons
	deagle_npc = "effects/payday2/particles/weapons/45cal_deagle_fps",
}
WeaponTweakData.CATEGORY_MUZZLEFLASHES = {
	dmr = "effects/payday2/particles/weapons/762_auto_fps",
	assault_rifle = "effects/payday2/particles/weapons/556_auto_fps",
	pistol = "effects/payday2/particles/weapons/9mm_pistol_fps",
	revolver = "effects/payday2/particles/weapons/357_revolver_fps",
	smg = "effects/payday2/particles/weapons/9mm_smg_fps",
	shotgun = "effects/particles/weapons/sho_default",
	lmg = "effects/payday2/particles/weapons/762_auto_fps",
	minigun = "effects/payday2/particles/weapons/762_auto_fps",
	snp = "effects/payday2/particles/weapons/big_762_auto_fps",
}
WeaponTweakData.WEAPON_TRAIL_EFFECTS = {
	ranc_heavy_machine_gun = "effects/payday2/particles/weapons/turret_streak",
	hailstorm = "effects/payday2/particles/weapons/hailstorm_streak",
	deagle = "effects/payday2/particles/weapons/streaks/traveling_streak",
	-- NPC weapons
}
WeaponTweakData.CATEGORY_TRAIL_EFFECTS = {
	dmr = "effects/particles/weapons/weapon_trail_dmr",
	revolver = "effects/particles/weapons/weapon_trail_dmr",
	shotgun = "effects/particles/weapons/shotgun_streak",
	lmg = "effects/particles/weapons/weapon_trail_green_lmg",
	snp = "effects/payday2/particles/weapons/streaks/big_light_streak",
}

-- Remake stat tables so that they use linear scaling.
Hooks:PostHook(WeaponTweakData, "_init_stats", "eclipse__init_stats", function(self)
	self.stats.damage = {}
	for i = 0, 1200, 1 do
		table.insert(self.stats.damage, (math.lerp(0.1, 120.1, i / 1200)))
	end

	self.stats.recoil = {}
	for i = 0, 25, 1 do
		table.insert(self.stats.recoil, math.lerp(3, 0.5, i / 25))
	end

	self.stats.spread = {}
	for i = 0, 25, 1 do
		table.insert(self.stats.spread, math.lerp(2, 0.2, i / 25))
	end

	self.stats.spread_moving = {}
	for i = 0, 25, 1 do
		table.insert(self.stats.spread_moving, math.lerp(2, 0.2, i / 25))
	end

	self.stats.swap_speed = {}
	for i = 0, 20, 1 do
		table.insert(self.stats.swap_speed, math.lerp(0.5, 1.75, i / 20))
	end

	self.stats.exit_run_speed = {}
	for i = 0, 20, 1 do
		table.insert(self.stats.exit_run_speed, math.lerp(0.75, 1.25, i / 20))
	end

	self.stats.suppression = {}
	for i = 4.2, 0.199, -0.2 do
		table.insert(self.stats.suppression, i)
	end
end)

function WeaponTweakData:_get_primary_category(weap_id)
	local categories_clean = self[weap_id] and self[weap_id].categories and clone(self[weap_id].categories)
	if categories_clean then
		table.delete(categories_clean, "akimbo")

		return categories_clean[1]
	end
end

function WeaponTweakData:_add_stat(weap_id, stat, addend)
	return math.clamp(self[weap_id].stats[stat] + addend, 1, #self.stats[stat])
end

-- Additional total ammo/ammo pickup multipliers given to Sniper Rifles (but not only) to offset their very high damage stats.
function WeaponTweakData:_calculate_snp_ammo_mul(damage, total_ammo_scale, pickup_scale)
	local total_ammo_mul = 1
	if total_ammo_scale then
		total_ammo_mul = total_ammo_mul * math.min(1 + math.round(math.max(damage - total_ammo_scale[1], 0) / total_ammo_scale[2]) * total_ammo_scale[3], total_ammo_scale[4])
	end

	local pickup_mul = 1
	if pickup_scale then
		pickup_mul = pickup_mul * math.min(1 + math.round(math.max(damage - pickup_scale[1], 0) / pickup_scale[2]) * pickup_scale[3], pickup_scale[4])
	end

	return total_ammo_mul, pickup_mul
end

-- Set muzzleflashes based on weapon ID or category.
function WeaponTweakData:_set_muzzleflashes()
	for weap_id, weap_data in pairs(self) do
		local new_muzzleflash = self.WEAPON_MUZZLEFLASHES[weap_id] or self.CATEGORY_MUZZLEFLASHES[self:_get_primary_category(weap_id)] or nil
		if new_muzzleflash then
			weap_data.muzzleflash = new_muzzleflash
			weap_data.muzzleflash_silenced = self.SILENCED_MUZZLEFLASH_MAP[weap_data.muzzleflash] or weap_data.muzzleflash_silenced or nil
			weap_data.muzzleflash_incendiary = "effects/payday2/particles/weapons/incendiary_muzzleflash"
		end
	end
end

-- Set trail effects based on weapon ID or category.
function WeaponTweakData:_set_trail_effects()
	for weap_id, weap_data in pairs(self) do
		local new_trail_effect = self.WEAPON_TRAIL_EFFECTS[weap_id] or self.CATEGORY_TRAIL_EFFECTS[self:_get_primary_category(weap_id)] or nil
		if new_trail_effect then
			weap_data.trail_effect = new_trail_effect
			weap_data.trail_effect_incendiary = "effects/payday2/particles/weapons/streaks/traveling_streak_incendiary"
		end
	end
end

function WeaponTweakData:_init_weapons(overrides)
	local akimbo_single_map = {}

	for k, v in pairs(self.akimbo_mappings) do
		akimbo_single_map[v] = k
	end

	for weap_id, weap_data in pairs(self) do
		local is_unsupported_custom = weap_data.custom and not weap_data.is_supported
		local based_on_id = weap_data.custom and weap_data.based_on or nil
		local based_on_data = based_on_id and self[based_on_id]

		if type(weap_data) == "table" and weap_data.stats then
			-- Automatically assign new weapon (sub)categories to custom weapons to avoid stat discrepancies

			-- These are needed just in case
			local category_blacklist = table.list_to_set({
				"car9", -- Assault Rifle based_on, should be an SMG
				"ak5s", -- Assault Rifle based_on, should be an SMG
				"scar16", -- Marksman Rifle based_on, should be an Assault Rifle
				"or12", -- LMG based_on, should be a Shotgun
			})

			if based_on_id and is_unsupported_custom then
				if not category_blacklist[weap_id] then
					weap_data.categories = clone(based_on_data.categories)
				end

				if based_on_data.use_shotgun_reload then
					weap_data.use_shotgun_reload = true
				end
			end

			-- Make sure akimbo weapons inherit their single counterparts' categories.
			local single_weapon_id = akimbo_single_map[weap_id] or weap_id:sub(3)
			local single_weapon_data = self[single_weapon_id]
			local is_akimbo = table.contains(weap_data.categories, "akimbo")

			if not single_weapon_data then
				-- TODO: add a log here
			elseif is_akimbo then
				local akimbo_cat_tbl = { "akimbo" }
				local single_cat_tbl = clone(single_weapon_data.categories)

				for _, category in pairs(single_cat_tbl) do
					table.insert(akimbo_cat_tbl, category)
				end

				weap_data.categories = clone(akimbo_cat_tbl)
			end
				
			-- Set weapon slot flags.
			local is_primary = weap_data.use_data and weap_data.use_data.selection_index == 2
			local is_secondary = weap_data.use_data and weap_data.use_data.selection_index == 1
			local is_underbarrel = not is_primary and not is_secondary

			-- Set damage flags for calculations that come later.
			local damage_index = math.min(weap_data.stats.damage, #self.stats.damage)
			local damage_modifier = weap_data.stats_modifiers and weap_data.stats_modifiers.damage or 1
			local real_damage = self.stats.damage[damage_index] * damage_modifier

			-- Map the weapon's categories.
			local cat_map = table.list_to_set(weap_data.categories)
		
			-- Category balancing start.
			if based_on_id == "ranc_heavy_machine_gun" or weap_id == "ranc_heavy_machine_gun" then -- .50 Cal Machine Gun found on Midland Ranch and Lost in Transit
				weap_data.stats.alert_size = 4
				weap_data.stats.suppression = 2
				
				weap_data.spread = {
					standing = 2.5,
					crouching = 2.5,
					steelsight = 1,
					moving_standing = 2.5,
					moving_crouching = 2.5,
					moving_steelsight = 1,
				}	
				
				weap_data.kick = {
					standing = { -0.1, 0.1, -0.05, 0.05 },
					crouching = { -0.1, 0.1, -0.05, 0.05 },
					steelsight = { -0.1, 0.1, -0.05, 0.05 },
					moving_standing = { -0.1, 0.1, -0.05, 0.05 },
					moving_crouching = { -0.1, 0.1, -0.05, 0.05 },
					moving_steelsight = { -0.1, 0.1, -0.05, 0.05 },
				}				
			elseif cat_map.dmr then
				weap_data.steelsight_enter_time = 0.35
				
				weap_data.stats.alert_size = 6
				weap_data.stats.suppression = 4
				
				weap_data.spread = {
					standing = 5,
					crouching = 4,
					steelsight = 1.7,
					moving_standing = 7.5,
					moving_crouching = 6,
					moving_steelsight = 1.7,
				}
				weap_data.spread_bloom = {
					add = 1.5,
					add_steelsight = 1,
					max = 3,
					recovery = 1.5,
					recovery_wait_multiplier = 2.25,
				}
				weap_data.spread_bloom.auto = {
					add = 2,
					add_steelsight = 1.75,
				}
				
				weap_data.kick = {
					standing = { 1.2, 1.4, -0.3, 0.9 },
					crouching = { 1, 1.2, -0.3, 0.9 },
					steelsight = { 0.8, 1, -0.3, 0.5 },
					moving_standing = { 1.6, 1.8, -0.3, 0.9 },
					moving_crouching = { 1.4, 1.6, -0.3, 0.9 },
					moving_steelsight = { 1.2, 1.4, -0.3, 0.9 },
				}
				
				weap_data._pickup_mul = 0.6
				
				-- Set the default fire mode to 'single'.
				weap_data.FIRE_MODE = "single"
				
				-- Enable enemy piercing with a pierce cap.
				weap_data.can_shoot_through_enemy = true
				weap_data.max_nr_enemy_penetrations = 1
			elseif cat_map.assault_rifle then
				weap_data.stats.alert_size = 7
				weap_data.stats.suppression = 9 
				
				weap_data.spread = {
					standing = 3,
					crouching = 2.5,
					steelsight = 1.5,
					moving_standing = 4,
					moving_crouching = 3,
					moving_steelsight = 1.5,
				}	
				weap_data.spread_bloom = {
					add = 0.75,
					add_steelsight = 0.5,
					max = 2,
					recovery = 4,
					recovery_wait_multiplier = 2,
				}
				weap_data.spread_bloom.auto = {
					add = 0,
					add_steelsight = 0,
				}
				
				weap_data.kick = {
					standing = { 0.8, 1, -0.6, 0.6 },
					crouching = { 0.7, 0.9, -0.6, 0.6 },
					steelsight = { 0.6, 0.8, -0.45, 0.45 },
					moving_standing = { 1, 1.2, -0.75, 0.75 },
					moving_crouching = { 1, 1.2, -0.75, 0.75 },
					moving_steelsight = { 0.8, 1, -0.6, 0.6 },
				}
				weap_data.kick.single = deep_clone(weap_data.kick)
				weap_data.kick.single.standing = { 1, 1.2, -0.4, 0.4 }
				weap_data.kick.single.crouching = weap_data.kick.single.standing
				weap_data.kick.single.steelsight = { 0.7, 0.9, -0.3, 0.3 }		
				weap_data.fire_mode_data.single = { spread_mul = 0.75 }
			elseif cat_map.pistol then
				weap_data.steelsight_enter_time = 0.2
	
				weap_data.stats.alert_size = 9
				weap_data.stats.suppression = 16
				
				weap_data.spread = {
					standing = 2.5,
					crouching = 2,
					steelsight = 1.3,
					moving_standing = 3,
					moving_crouching = 3,
					moving_steelsight = 1.3,
				}	
				weap_data.spread_bloom = {
					add = 0.5,
					add_steelsight = 0.25,
					max = 1.5,
					recovery = 4,
					recovery_wait_multiplier = 1.5,
				}
				weap_data.spread_bloom.auto = {
					add = 0,
					add_steelsight = 0,
				}
				
				weap_data.kick = {
					standing = { 1.2, 1.4, -0.5, 0.5 },
					crouching = { 1.2, 1.4, -0.5, 0.5 },
					steelsight = { 0.8, 1, -0.3, 0.3 },
					moving_standing = { 1.2, 1.4, -0.5, 0.5 },
					moving_crouching = { 1.2, 1.4, -0.5, 0.5 },
					moving_steelsight = { 1, 1.2, -0.5, 0.5 },
				}
				
				weap_data._pickup_mul = 1.33
				weap_data._total_ammo_mul = weap_data.auto and 1 or 1.25
				
				if not weap_data.non_standard_fire_rate and weap_data.fire_mode_data and not weap_data.CAN_TOGGLE_FIREMODE then
					weap_data.fire_mode_data.fire_rate = 60 / 600
				end
			elseif cat_map.revolver then
				weap_data.steelsight_enter_time = 0.25
	
				weap_data.stats.alert_size = 7
				weap_data.stats.suppression = 7
				
				weap_data.spread = {
					standing = 4.5,
					crouching = 3,
					steelsight = 1.5,
					moving_standing = 6,
					moving_crouching = 6,
					moving_steelsight = 1.5,
				}	
				weap_data.spread_bloom = {
					add = 2,
					add_steelsight = 1.5,
					max = 3,
					recovery = 1.25,
					recovery_wait_multiplier = 1.75,
				}
				
				weap_data.kick = {
					standing = { 1.8, 2.4, 0.6, -0.2 },
					crouching = { 1.8, 2.4, 0.6, -0.2 },
					steelsight = { 1.6, 2, 0.4, -0.2 },
					moving_standing = { 2.4, 3, 0.6, -0.2 },
					moving_crouching = { 2.4, 3, 0.6, -0.2 },
					moving_steelsight = { 1.8, 2.4, 0.6, -0.2 },
				}
				
				weap_data._pickup_mul = 0.66
			
				if weap_data.fire_mode_data and not weap_data.auto then
					weap_data.fire_mode_data.fire_rate = 60 / 300
				end
			elseif cat_map.smg then
				weap_data.steelsight_enter_time = 0.25
	
				weap_data.stats.alert_size = 8
				weap_data.stats.suppression = 14
				
				weap_data.spread = {
					standing = 2,
					crouching = 1.75,
					steelsight = 1.3,
					moving_standing = 2.5,
					moving_crouching = 2.5,
					moving_steelsight = 1.3,
				}	
				weap_data.spread_bloom = {
					add = 0.75,
					add_steelsight = 0.5,
					max = 2,
					recovery = 4,
					recovery_wait_multiplier = 2,
				}
				weap_data.spread_bloom.auto = {
					add = 0,
					add_steelsight = 0,
				}
				
				weap_data.kick = {
					standing = { 0.5, 0.7, -1, 1 },
					crouching = { 0.5, 0.7, -0.8, 0.8 },
					steelsight = { 0.4, 0.6, -0.6, 0.6 },
					moving_standing = { 0.6, 0.8, -1, 1 },
					moving_crouching = { 0.6, 0.8, -1, 1 },
					moving_steelsight = { 0.5, 0.7, -0.8, 0.8 },
				}
				weap_data.kick.single = deep_clone(weap_data.kick)
				weap_data.kick.single.standing = { 0.7, 0.8, -0.6, 0.6 }
				weap_data.kick.single.crouching = weap_data.kick.single.standing
				weap_data.kick.single.steelsight = { 0.5, 0.6, -0.4, 0.4 }
				weap_data.fire_mode_data.single = { spread_mul = 0.75 }
				
				weap_data._total_ammo_mul = 1.2
			elseif cat_map.shotgun then
				weap_data.stats.alert_size = 6
				weap_data.stats.suppression = 5
				
				weap_data.spread = {
					standing = 3.5,
					crouching = 3.5,
					steelsight = 1.5,
					moving_standing = 3.5,
					moving_crouching = 3.5,
					moving_steelsight = 1.5,
				}	
				
				weap_data.kick = {
					standing = { 2, 2.4, -0.5, 0.5 },
					crouching = { 1.8, 2, -0.4, 0.4 },
					steelsight = { 1.6, 1.8, -0.3, 0.3 },
					moving_standing = { 2.4, 3, -0.5, 0.5 },
					moving_crouching = { 2.4, 3, -0.5, 0.5 },
					moving_steelsight = { 2, 2.4, -0.5, 0.5 },
				}

				weap_data.double_barrel = weap_data.CLIP_AMMO_MAX == 2
				
				weap_data.damage_near = 2000
				weap_data.damage_far = 3000

				if weap_data.rays then
					weap_data.rays = 8	
				end
				
				weap_data._total_ammo_mul = (1 / weap_data.rays) * 1.25
				weap_data._pickup_mul = (1 / weap_data.rays) * 1.33
			elseif cat_map.lmg then
				weap_data.steelsight_enter_time = 0.45
	
				weap_data.stats.alert_size = 6
				weap_data.stats.suppression = 4
				
				weap_data.spread = {
					standing = 3.5,
					crouching = 2.5,
					steelsight = 1.5,
					moving_standing = 4.5,
					moving_crouching = 3.5,
					moving_steelsight = 1.5,
					bipod = 2,
				}	
				
				weap_data.kick = {
					standing = { 0.3, 0.6, -0.8, 1 },
					crouching = { 0.25, 0.5, -0.6, 0.8 },
					steelsight = { 0.2, 0.4, -0.6, 0.6 },
					moving_standing = { 0.6, 0.9, -0.8, 1 },
					moving_crouching = { 0.6, 0.9, -0.8, 1 },
					moving_steelsight = { 0.3, 0.6, -0.8, 1 },
				}
				
				weap_data._total_ammo_mul = 1.5
				weap_data._pickup_mul = 1.2
				
				weap_data.ammo_bag_consumption_mul = 1.5	
				
				-- Standardise bipod handling
				weap_data.bipod_camera_spin_limit = 40
				weap_data.bipod_camera_pitch_limit = 15
				weap_data.bipod_deploy_multiplier = 1				
			elseif cat_map.minigun then
				weap_data.steelsight_enter_time = 0.45
	
				weap_data.stats.alert_size = 6
				weap_data.stats.suppression = 4
				
				weap_data.spread = {
					standing = 4,
					crouching = 4,
					steelsight = 1.5,
					moving_standing = 6,
					moving_crouching = 6,
					moving_steelsight = 1.5,
				}	
				
				weap_data.kick = {
					standing = { 0.1, 0.2, -0.3, 0.4 },
					crouching = { 0.1, 0.2, -0.3, 0.4 },
					steelsight = { 0.1, 0.15, -0.2, 0.3 },
					moving_standing = { 0.15, 0.25, -0.3, 0.5 },
					moving_crouching = { 0.15, 0.25, -0.3, 0.5 },
					moving_steelsight = { 0.1, 0.2, -0.3, 0.4 },
				}
				
				weap_data._total_ammo_mul = 2
				weap_data._pickup_mul = 0
			elseif cat_map.snp then
				weap_data.steelsight_enter_time = 0.4
	
				weap_data.stats.alert_size = 4
				weap_data.stats.suppression = 3
				
				weap_data.spread = {
					standing = 10,
					crouching = 5,
					steelsight = 1.9,
					moving_standing = 15,
					moving_crouching = 10,
					moving_steelsight = 1.9,
				}	
				
				weap_data.kick = {
					standing = { 2.5, 3, -0.4, 0.4 },
					crouching = { 2.5, 3, -0.4, 0.4 },
					steelsight = { 2, 2.5, -0.4, 0.4 },
					moving_standing = { 3, 4, -0.4, 0.4 },
					moving_crouching = { 3, 4, -0.4, 0.4 },
					moving_steelsight = { 2.5, 3, -0.4, 0.4 },
				}
				
				weap_data._total_ammo_mul = 0.5
				weap_data._pickup_mul = 0.6
				weap_data._total_ammo_scale = { 2, 4, 0.5, 4 }
				weap_data._pickup_scale = { 8, 6, 0.5, 4 }
			elseif cat_map.bow then
				weap_data.stats.alert_size = 7
				weap_data.stats.suppression = 3
				weap_data.spread = {
					standing = 2.5,
					crouching = 2.5,
					steelsight = 1.5,
					moving_standing = 2.5,
					moving_crouching = 2.5,
					moving_steelsight = 1.5,
				}	
				
				weap_data.kick = {
					standing = { 2.9, 3, -0.5, 0.5 },
					crouching = { 2.9, 3, -0.5, 0.5 },
					steelsight = { 2.9, 3, -0.5, 0.5 },
					moving_standing = { 2.9, 3, -0.5, 0.5 },
					moving_crouching = { 2.9, 3, -0.5, 0.5 },
					moving_steelsight = { 2.9, 3, -0.5, 0.5 },
				}
				
				weap_data._total_ammo_scale = { 12, 6, 0.25, 2 }
				
				weap_data.armor_piercing_chance = 1
			
				weap_data._clips_max_round = 4
				
				-- Remove this reload speed flag and replace it with a proper multiplier.
				weap_data.bow_reload_speed_multiplier = nil
				weap_data.reload_speed_multiplier = 2
				
				-- Increase bow charging speed.
				if weap_data.charge_data and weap_data.charge_data.max_t then
					weap_data.charge_data.max_t = weap_data.charge_data.max_t * 0.5
				end
			elseif cat_map.crossbow or cat_map.dartgun then
				weap_data.stats.alert_size = 7
				weap_data.stats.suppression = 3
				weap_data.spread = {
					standing = 2.5,
					crouching = 2.5,
					steelsight = 1.5,
					moving_standing = 2.5,
					moving_crouching = 2.5,
					moving_steelsight = 1.5,
				}	
				
				weap_data.kick = {
					standing = { -0.2, 0.4, -1, 1 },
					crouching = { -0.2, 0.4, -1, 1 },
					steelsight = { -0.2, 0.4, -1, 1 },
					moving_standing = { -0.2, 0.4, -1, 1 },
					moving_crouching = { -0.2, 0.4, -1, 1 },
					moving_steelsight = { -0.2, 0.4, -1, 1 },
				}	
				
				weap_data._total_ammo_mul = 0.75
				weap_data._total_ammo_scale = { 12, 6, 0.25, 2 }

				weap_data.armor_piercing_chance = 1
			
				weap_data._clips_max_round = 2
			elseif cat_map.grenade_launcher then
				weap_data.stats.alert_size = 6
				weap_data.stats.suppression = 5
				
				weap_data.spread = {
					standing = 3.5,
					crouching = 3.5,
					steelsight = 1.5,
					moving_standing = 3.5,
					moving_crouching = 3.5,
					moving_steelsight = 1.5,
				}	
				
				weap_data.kick = {
					standing = { 2.9, 3, -0.5, 0.5 },
					crouching = { -0.2, 0.4, -1, 1 },
					steelsight = { -0.2, 0.4, -1, 1 },
					moving_standing = { 2.9, 3, -0.5, 0.5 },
					moving_crouching = { 2.9, 3, -0.5, 0.5 },
					moving_steelsight = { 2.9, 3, -0.5, 0.5 },
				}
				
				weap_data._total_ammo_mul = weap_data._total_ammo_mul or (20 / 30)
				weap_data._pickup_mul = weap_data._pickup_mul or (10 / 40)

				weap_data.ammo_bag_consumption_mul = 1.5

				weap_data.explosive_ammo = true

				weap_data.damage_near = 2000
				weap_data.damage_far = 3000

				if weap_data.rays then
					weap_data.rays = 8	
				end
			elseif cat_map.flamethrower then
				weap_data.stats.alert_size = 6
				weap_data.stats.suppression = 13
				
				weap_data.spread = {
					standing = 0,
					crouching = 0,
					steelsight = 1,
					moving_standing = 0,
					moving_crouching = 0,
					moving_steelsight = 1,
				}	
				
				weap_data.kick = {
					standing = { 0, 0, 0, 0 },
					crouching = { 0, 0, 0, 0 },
					steelsight = { 0, 0, 0, 0 },
					moving_standing = { 0, 0, 0, 0 },
					moving_crouching = { 0, 0, 0, 0 },
					moving_steelsight = { 0, 0, 0, 0 },
				}
				
				weap_data._total_ammo_mul = weap_data._total_ammo_mul or 0.5
				weap_data._pickup_mul = weap_data._pickup_mul or 0
			elseif cat_map.saw then
				weap_data.stats.alert_size = 7
				weap_data.stats.suppression = 7
				
				weap_data.spread = {
					standing = 0,
					crouching = 0,
					steelsight = 1,
					moving_standing = 0,
					moving_crouching = 0,
					moving_steelsight = 1,
				}
				
				weap_data.kick = {
					standing = { 0.2, -0.2, -0.1, 0.1 },
					crouching = { 0.2, -0.2, -0.1, 0.1 },
					steelsight = { 0.2, -0.2, -0.1, 0.1 },
					moving_standing = { 0.2, -0.2, -0.1, 0.1 },
					moving_crouching = { 0.2, -0.2, -0.1, 0.1 },
					moving_steelsight = { 0.2, -0.2, -0.1, 0.1 },
					on_hit = { 1.4, -0.5, -0.4, 0.4 }
				}
				
				weap_data._total_ammo_mul = weap_data._total_ammo_mul or is_primary and 1.5 or 3
				weap_data._pickup_mul = weap_data._pickup_mul or 0

				weap_data.hit_alert_size_increase = 2
				
				weap_data.armor_piercing_chance = 1

				weap_data.tank_damage_multiplier = 1.5
				weap_data.lock_damage_multiplier = 3				
			end
			-- Category balancing end.

			-- Automatically scale custom weapon damage to make sure they are not horribly unbalanced.		
			if not is_akimbo then -- This prevents damage being scaled twice for weapons with akimbo variants. 
				if weap_data.custom and not weap_data.no_damage_scaling then
					local custom_damage = damage_index * damage_modifier

					-- Additional scaling for Shotguns to account for damage being divided by the number of pellets.
					if cat_map.shotgun then
						custom_damage = math.sqrt(custom_damage) * 4
						custom_damage = math.round(custom_damage, 5)
					end

					custom_damage = math.round(custom_damage / 2.5, 2)
					custom_damage = math.round(custom_damage / damage_modifier)

					weap_data.stats.damage = custom_damage

					damage_index = math.min(weap_data.stats.damage, #self.stats.damage)
					real_damage = self.stats.damage[damage_index] * damage_modifier
				end
			end

			-- Set weapon handling timers.
			weap_data.steelsight_enter_time = weap_data.steelsight_enter_time or 0.3 -- The time it takes to aim a weapon.
			weap_data.steelsight_move_speed_mul = weap_data.steelsight_move_speed_mul or 0.5 -- The speed penalty when aiming a weapon.
			weap_data.exit_run_time = weap_data.exit_run_time or 0.4 -- The time it takes for your character to raise their weapon after running.

			-- Set penetration properties. 
			weap_data.penetration = {
				enemy = { damage_mul = 0.75 },
				wall = { damage_mul = 0.5 },
				shield = { damage_mul = 0.5 },
			}

			-- Standardise panic suppression chance used by some perk deck upgrades.
			weap_data.panic_suppression_chance = 0.2
			
			-- Standarise the 'reload' stat used in vanilla to adjust individual weapon reload times.
			weap_data.stats.reload = 11

			-- Set new index stats for weapons that may not have them
			if not weap_data.stats.swap_speed then
				weap_data.stats.swap_speed = 9 -- equal to x1.0 swap speed
			end

			if not weap_data.stats.exit_run_speed then
				weap_data.stats.exit_run_speed = 11 -- equal to x1.0 sprint exit speed
			end
			
			-- Remove damage falloff. We do not like it in this house.
			weap_data.damage_falloff = nil
			
			-- Set cosmetic firing camera shake multipliers.
			if cat_map.snp or cat_map.shotgun then
				weap_data.shake.fire_multiplier = 1.5
			elseif cat_map.dmr or cat_map.revolver then
				weap_data.shake.fire_multiplier = 1.3
			elseif cat_map.smg then
				weap_data.shake.fire_multiplier = 0.8
			elseif cat_map.pistol then
				weap_data.shake.fire_multiplier = 0.7
			elseif cat_map.flamethrower or cat_map.crossbow or cat_map.bow then
				weap_data.shake.fire_multiplier = 0.2
			elseif cat_map.saw then
				weap_data.shake.fire_multiplier = 0.1
				weap_data.shake.on_hit_multiplier = 1
			else
				weap_data.shake.fire_multiplier = 1
			end
			
--[[
					weap_data.kick_pattern = {
						["auto"] = {
							standing = {
								{
									{ -0.1, 0.4, 0, 0.6 },
									10,
								},
								{
									{ 0.1, 0.5, -0.6, 0 },
									 16,
								},
								{
									{ 0.3, 0.6, -0.4, 0.6 },
									 24,
								},
								{
									{ 0.4, 0.8, -0.8, 1 },
									persist = true,
								},
							},
							steelsight = {
								{
									{ -0.1, 0.4, 0, 0.6 },
									10,
								},
								{
									{ 0.1, 0.5, -0.6, 0 },
									 16,
								},
								{
									{ 0.3, 0.6, -0.4, 0.6 },
									 24,
								},
								{
									{ 0.4, 0.8, -0.8, 1 },
									persist = true,
								},
							},
						},
					}
					weap_data.kick_pattern_reset_t = 2
]]

			-- Run overrides for specific weapons before calculating ammo.
			-- These are useful if you need to set a flag that is normally tied to a category.
			local function override_caller(callback)
				callback()
			end

			if overrides and overrides[weap_id] then
				override_caller(overrides[weap_id])
			end

			-- Set 'fire_mode_data'.
			if weap_data.fire_mode_data then
				-- Make the 'auto' fire rate match the primary one.
				if weap_data.auto and weap_data.fire_mode_data.fire_rate then
					weap_data.auto.fire_rate = weap_data.fire_mode_data.fire_rate
				end

				-- Set burst fire delays and add an additional recoil increase at the end of a burst.
				weap_data.fire_mode_data.burst_cooldown = weap_data.fire_mode_data.fire_rate and weap_data.fire_mode_data.fire_rate * 2 or weap_data.fire_mode_data.burst_cooldown or nil
				weap_data.fire_mode_data.burst_recoil_final_mul = 1.5
			end

			-- Balance akimbo weapons.
			if is_akimbo then
				if single_weapon_data then
					-- Double the single counterpart's magazine capacity
					weap_data.CLIP_AMMO_MAX = single_weapon_data.CLIP_AMMO_MAX * 2
					
					weap_data.stats = deep_clone(single_weapon_data.stats) -- Clone the single counterpart's stats.
					
					-- Reduce/increase index stats
					weap_data.stats.spread = self:_add_stat(single_weapon_id, "spread", -1)
					weap_data.stats.recoil = self:_add_stat(single_weapon_id, "recoil", -3)
					weap_data.stats.concealment = self:_add_stat(single_weapon_id, "concealment", -4)
					weap_data.stats.suppression = self:_add_stat(single_weapon_id, "suppression", -2)

					-- Significantly increase ammo bag consumption
					weap_data.ammo_bag_consumption_mul = 1.75
					
					-- Make sure the akimbo weapon's reload time is not shorter than the single counterpart's 
					weap_data.reload_speed_multiplier = (weap_data.timers.reload_empty / single_weapon_data.timers.reload_empty) * 0.75

					-- Make sure the akimbo weapon's rate of fire matches the single counterpart
					if weap_data.fire_mode_data and single_weapon_data.fire_mode_data then
						weap_data.fire_mode_data.fire_rate = single_weapon_data.fire_mode_data.fire_rate

						-- Apply a fire rate reduction to single fire akimbo weapons
						if not weap_data.CAN_TOGGLE_FIREMODE then
							weap_data.fire_mode_data.fire_rate = single_weapon_data.fire_mode_data.fire_rate * 1.25
						end
					end
					
					-- Cap akimbo weapons' total ammo/ammo pickup multipliers at 1.
					if weap_data._total_ammo_mul and weap_data._total_ammo_mul > 1 then
						weap_data._total_ammo_mul = math.min(weap_data._total_ammo_mul, 1)
					end
					
					if weap_data._pickup_mul and weap_data._pickup_mul > 1 then
						weap_data._pickup_mul = math.min(weap_data._pickup_mul, 1)
					end
										
					-- Increase spread and set a standard 'steelsight' spread multiplier
					for k, v in pairs(weap_data.spread) do
						weap_data.spread[k] = v + 1
					end
					
					weap_data.spread.steelsight = 1.5
					weap_data.spread.moving_steelsight = weap_data.spread.steelsight
	
					-- Cosmetic flags
					weap_data.shell_ejection = single_weapon_data.shell_ejection
					weap_data.trail_effect = single_weapon_data.trail_effect
					
					weap_data.shake.fire_multiplier = math.clamp(single_weapon_data.shake.fire_multiplier + 0.4, 1, 2)
				end
			end
			
			-- Additional total ammo/ammo pickup multipliers given to Sniper Rifles (but not only) to offset their very high damage stats.
			local snp_total_ammo_mul, snp_pickup_mul = self:_calculate_snp_ammo_mul(real_damage, weap_data._total_ammo_scale, weap_data._pickup_scale)

			-- Set total ammo and pickup
			weap_data.TOTAL_DAMAGE = self.WEAPON_TOTAL_DMG * (weap_data._total_ammo_mul or 1) * snp_total_ammo_mul
			weap_data.PICKUP_DAMAGE = self.WEAPON_PICKUP_DMG * (weap_data._pickup_mul or 1) * snp_pickup_mul

			-- Reduce total ammo/ammo pickup based on the weapon's slot.
			if is_secondary then -- Secondaries
				weap_data.TOTAL_DAMAGE = weap_data.TOTAL_DAMAGE * self.SECONDARY_TOTAL_DMG_MUL
				weap_data.PICKUP_DAMAGE = weap_data.PICKUP_DAMAGE * self.SECONDARY_PICKUP_DMG_MUL
			elseif is_underbarrel then -- Underbarrels
				weap_data.TOTAL_DAMAGE = weap_data.TOTAL_DAMAGE * self.UNDERBARREL_TOTAL_DMG_MUL
				weap_data.PICKUP_DAMAGE = weap_data.PICKUP_DAMAGE * self.UNDERBARREL_PICKUP_DMG_MUL
			end
			
			-- Penalties applied to non-Sniper Rifle category weapons with innate armour piercing.
			if weap_data.can_shoot_through_wall and not cat_map.snp then
				-- Reduce total ammo and ammo pickup.
				weap_data.TOTAL_DAMAGE = weap_data.TOTAL_DAMAGE * self.AP_TOTAL_DMG_MUL
				weap_data.PICKUP_DAMAGE = weap_data.PICKUP_DAMAGE * self.AP_PICKUP_DMG_MUL
				-- Increase Ammo Bag ammo consumption
				weap_data.ammo_bag_consumption_mul = (weap_data.ammo_bag_consumption_mul or 1) * 1.25
			end
			
			-- Penalties applied to weapons with no ammo pickup.
			if weap_data._pickup_mul == 0 then
				-- Disable the 'start_out_ammo_multiplier' upgrade.
				weap_data.forbid_start_out_ammo = true
				-- Increase Ammo Bag ammo consumption
				weap_data.ammo_bag_consumption_mul = math.max(weap_data.ammo_bag_consumption_mul or 1, 2)
			end

			damage_index = math.min(weap_data.stats.damage, #self.stats.damage)
			real_damage = self.stats.damage[damage_index] * damage_modifier
			
			-- Set total ammo based on damage and magazine capacity.
			local damage_per_clip = weap_data.CLIP_AMMO_MAX * real_damage
			if weap_data.AMMO_MAX then
				-- Round total ammo to a weapon's magazine capacity.
				weap_data.NR_CLIPS_MAX = math.round(weap_data.TOTAL_DAMAGE / damage_per_clip)
				weap_data.NR_CLIPS_MAX = math.max(weap_data.NR_CLIPS_MAX, 1)
				
				-- '_min_clips_max' sets the minimum number of magazines a weapon has by default regardless of damage.
				if weap_data._min_clips_max then
					weap_data.NR_CLIPS_MAX = math.max(weap_data.NR_CLIPS_MAX, weap_data._min_clips_max)
				end
				
				-- '_clips_max_round' rounds the total number of magazines to a given value.
				if weap_data._clips_max_round then
					weap_data.NR_CLIPS_MAX = math.round(weap_data.NR_CLIPS_MAX, weap_data._clips_max_round)
				end
				
				weap_data.AMMO_MAX = weap_data.CLIP_AMMO_MAX * weap_data.NR_CLIPS_MAX
			end

			if weap_data.AMMO_PICKUP and weap_data.AMMO_PICKUP[2] > 0 then
				local ammo_pickup_ratio = weap_data.ammo_pickup_ratio or { 0.5, 1 }
				local pickup_dmg_min = weap_data.PICKUP_DAMAGE * ammo_pickup_ratio[1]
				local pickup_dmg_max = weap_data.PICKUP_DAMAGE * ammo_pickup_ratio[2]
				
				weap_data.AMMO_PICKUP = { 
					math.round(math.floor(pickup_dmg_min / real_damage * 100) / 100, 0.05),
					math.round(math.floor(pickup_dmg_max / real_damage * 100) / 100, 0.05),
				}
			end
		end
	end
end

-- Disable most akimbo weapons including custom ones.
WeaponTweakData.akimbo_whitelist = table.list_to_set({
	"jowi",
	"x_1911",
	"x_b92fs",
	"x_g17",
	"x_g22c",
	"x_usp",
	"x_packrat",
	"x_chinchilla",
	"x_g18c",
	"x_judge",
	"x_sr2",
	"x_mp5",
	"x_mac10",
	"x_baka",
	"x_akmsu",
	"x_olympic",
	"x_model3",
})

function WeaponTweakData:_wipe_akimbo()
	local function has_category(data, category)
		return data and data.categories and table.contains(data.categories, category)
	end

	for weap_id, weap_data in pairs(self) do
		if type(weap_data) == "table" then
			local is_npc_weapon = weap_id:match("_npc$")

			if has_category(weap_data, "akimbo") and not self.akimbo_whitelist[weap_id] and not is_npc_weapon then
				if weap_data.use_data then
					weap_data.use_data.selection_index = 4
				end
			end
		end
	end
end

Hooks:PostHook(WeaponTweakData, "init", "eclipse_init", function(self, tweak_data)
	self.tweak_data = tweak_data
	
	self._init_stat_overrides = {}

	-- Starbreeze didn't update the akimbo mappings for some of the Mcshay weapons, because of course they didn't.
	-- Update this table with any other weapons that might have the same issue
	local missing_akimbo_map = {
		sko12 = "x_sko12",
		korth = "x_korth",
	}

	self.akimbo_mappings = self:get_akimbo_mappings()

	for k, v in pairs(missing_akimbo_map) do
		self.akimbo_mappings[k] = v
	end

	-- Reduce Sentry Gun damage to scale better with Eclipse's enemy health pools.
	self.sentry_gun.DAMAGE = 1
	
	-- Increase Trip Mine self damage.
	self.trip_mines.player_damage = self.trip_mines.damage / 4
	
	-- Assault Rifles

	-- AMCAR
	self.amcar.CLIP_AMMO_MAX = 30
	self.amcar.stats.damage = 20
	self.amcar.stats.spread = 14
	self.amcar.stats.recoil = 18
	self.amcar.stats.concealment = 23
	self.amcar.fire_mode_data.fire_rate = 60 / 800

	-- JP36
	self.g36.CLIP_AMMO_MAX = 30
	self.g36.stats.damage = 20
	self.g36.stats.spread = 15
	self.g36.stats.recoil = 17
	self.g36.stats.concealment = 24
	self.g36.fire_mode_data.fire_rate = 60 / 750
	self.g36.reload_speed_multiplier = 1.15

	-- Para
	self.olympic.categories = { "assault_rifle" }
	self.olympic.CLIP_AMMO_MAX = 30
	self.olympic.stats.damage = 20
	self.olympic.stats.spread = 13
	self.olympic.stats.recoil = 16
	self.olympic.stats.concealment = 25
	self.olympic.fire_mode_data.fire_rate = 60 / 800

	-- Akimbo Para
	self.x_olympic.sounds.reload = {
		wp_akmsu_x_take_new = "wp_m4_clip_take_new",
		wp_akmsu_x_clip_slide_out = "wp_m4_clip_grab_out",
		wp_akmsu_x_clip_slide_in = "wp_m4_clip_slide_in",
		wp_akmsu_x_clip_in_contact = "wp_m4_clip_in_contact",
		wp_akmsu_x_lever_pull = "wp_m4_lever_pull_in",
		wp_akmsu_x_lever_release = "wp_m4_lever_release"
	}

	-- Commando 553
	self.s552.CLIP_AMMO_MAX = 30
	self.s552.stats.damage = 20
	self.s552.stats.spread = 15
	self.s552.stats.recoil = 17
	self.s552.stats.concealment = 24
	self.s552.fire_mode_data.fire_rate = 60 / 700

	-- Clarion
	self.famas.use_data.selection_index = 1
	self.famas.CLIP_AMMO_MAX = 25
	self.famas.stats.damage = 20
	self.famas.stats.spread = 14
	self.famas.stats.recoil = 18
	self.famas.stats.concealment = 25
	self.famas.fire_mode_data.fire_rate = 60 / 1000

	-- Union 5.56
	self.corgi.CLIP_AMMO_MAX = 30
	self.corgi.stats.damage = 20
	self.corgi.stats.spread = 14
	self.corgi.stats.recoil = 18
	self.corgi.stats.concealment = 23
	self.corgi.fire_mode_data.fire_rate = 60 / 900

	-- CAR-4
	self.new_m4.CLIP_AMMO_MAX = 30
	self.new_m4.stats.damage = 24
	self.new_m4.stats.spread = 15
	self.new_m4.stats.recoil = 17
	self.new_m4.stats.concealment = 22
	self.new_m4.fire_mode_data.fire_rate = 60 / 725

	-- AK5
	self.ak5.CLIP_AMMO_MAX = 30
	self.ak5.stats.damage = 24
	self.ak5.stats.spread = 17
	self.ak5.stats.recoil = 16
	self.ak5.stats.concealment = 22
	self.ak5.fire_mode_data.fire_rate = 60 / 700

	-- AK Rifle
	self.ak74.CLIP_AMMO_MAX = 30
	self.ak74.stats.damage = 24
	self.ak74.stats.spread = 15
	self.ak74.stats.recoil = 17
	self.ak74.stats.concealment = 22
	self.ak74.fire_mode_data.fire_rate = 60 / 650
	self.ak74.reload_speed_multiplier = 1.15

	-- UAR
	self.aug.CLIP_AMMO_MAX = 30
	self.aug.stats.damage = 24
	self.aug.stats.spread = 16
	self.aug.stats.recoil = 15
	self.aug.stats.concealment = 25
	self.aug.fire_mode_data.fire_rate = 60 / 750

	-- Lion's Roar
	self.vhs.CLIP_AMMO_MAX = 30
	self.vhs.stats.damage = 24
	self.vhs.stats.spread = 15
	self.vhs.stats.recoil = 16
	self.vhs.stats.concealment = 25
	self.vhs.fire_mode_data.fire_rate = 60 / 850

	-- CR805B
	self.hajk.use_data.selection_index = 2
	self.hajk.categories = { "assault_rifle" }
	self.hajk.CLIP_AMMO_MAX = 30
	self.hajk.stats.damage = 24
	self.hajk.stats.spread = 14
	self.hajk.stats.recoil = 18
	self.hajk.stats.concealment = 19
	self.hajk.fire_mode_data.fire_rate = 60 / 750

	-- Tempest-21
	self.komodo.use_data.selection_index = 1
	self.komodo.CLIP_AMMO_MAX = 30
	self.komodo.stats.damage = 24
	self.komodo.stats.spread = 15
	self.komodo.stats.recoil = 13
	self.komodo.stats.concealment = 26
	self.komodo.fire_mode_data.fire_rate = 60 / 800

	-- Rodion 3b
	self.tkb.CLIP_AMMO_MAX = 45
	self.tkb.stats.damage = 24
	self.tkb.stats.spread = 11
	self.tkb.stats.recoil = 16
	self.tkb.stats.concealment = 16
	self.tkb.fire_mode_data.fire_rate = 60 / 800
	self.tkb.fire_mode_data.toggable = nil
	self.tkb.reload_speed_multiplier = 0.7

	-- AMR-16
	self.m16.CLIP_AMMO_MAX = 30
	self.m16.stats.damage = 30
	self.m16.stats.spread = 17
	self.m16.stats.recoil = 14
	self.m16.stats.concealment = 19
	self.m16.fire_mode_data.fire_rate = 60 / 850

	-- Queen's Wrath
	self.l85a2.CLIP_AMMO_MAX = 30
	self.l85a2.stats.damage = 30
	self.l85a2.stats.spread = 16
	self.l85a2.stats.recoil = 15
	self.l85a2.stats.concealment = 22
	self.l85a2.fire_mode_data.fire_rate = 60 / 725
	self.l85a2.timers.reload_not_empty = 3
	self.l85a2.timers.reload_empty = 4

	-- Ketchnov Byk-1
	self.groza.CLIP_AMMO_MAX = 20
	self.groza.stats.damage = 30
	self.groza.stats.spread = 15
	self.groza.stats.recoil = 16
	self.groza.stats.concealment = 16
	self.groza.fire_mode_data.fire_rate = 60 / 700

	-- Ketchnov Byk-1 Underbarrel Grendae Launcher
	self.groza_underbarrel.CLIP_AMMO_MAX = 1
	self.groza_underbarrel.stats.damage = 72
	self.groza_underbarrel.stats.spread = 24
	self.groza_underbarrel.stats.recoil = 20
	self.groza_underbarrel.stats.concealment = 16
	self.groza_underbarrel.fire_mode_data.fire_rate = 60 / 60
	self.groza_underbarrel.stats_modifiers = { damage = 5 }
	self.groza_underbarrel.reload_speed_multiplier = 0.7

	-- AK 7.62
	self.akm.CLIP_AMMO_MAX = 30
	self.akm.stats.damage = 36
	self.akm.stats.spread = 17
	self.akm.stats.recoil = 12
	self.akm.stats.concealment = 21
	self.akm.fire_mode_data.fire_rate = 60 / 600
	self.akm.timers.reload_not_empty = 2.2

	-- Gold AK 7.62
	self.akm_gold.CLIP_AMMO_MAX = 30
	self.akm_gold.stats.damage = 36
	self.akm_gold.stats.spread = 17
	self.akm_gold.stats.recoil = 12
	self.akm_gold.stats.concealment = 21
	self.akm_gold.fire_mode_data.fire_rate = 60 / 600
	self.akm_gold.timers.reload_not_empty = 2.2

	-- Krinkov
	self.akmsu.categories = { "assault_rifle" }
	self.akmsu.CLIP_AMMO_MAX = 30
	self.akmsu.stats.damage = 36
	self.akmsu.stats.spread = 16
	self.akmsu.stats.recoil = 10
	self.akmsu.stats.concealment = 25
	self.akmsu.fire_mode_data.fire_rate = 60 / 825

	-- AK17
	self.flint.CLIP_AMMO_MAX = 30
	self.flint.stats.damage = 36
	self.flint.stats.spread = 15
	self.flint.stats.recoil = 14
	self.flint.stats.concealment = 21
	self.flint.fire_mode_data.fire_rate = 60 / 650

	-- Akimbo Krinkov
	self.x_akmsu.timers.reload_not_empty = 2.75
	self.x_akmsu.timers.reload_empty = 3.4

	local dmr_category = {
		"dmr",
		"assault_rifle",
	}

	-- Cavity 9mm
	self.sub2000.categories = dmr_category
	self.sub2000.CLIP_AMMO_MAX = 33
	self.sub2000.stats.damage = 40
	self.sub2000.stats.spread = 18
	self.sub2000.stats.recoil = 10
	self.sub2000.stats.concealment = 28
	self.sub2000.fire_mode_data.fire_rate = 60 / 500

	self._init_stat_overrides.sub2000 = function()
		self.sub2000.stats.suppression = 14
		self.sub2000.stats.alert_size = 8
		self.sub2000.shake.fire_multiplier = 0.8
	end

	-- Eagle Heavy
	self.scar.categories = dmr_category
	self.scar.CLIP_AMMO_MAX = 20
	self.scar.stats.damage = 48
	self.scar.stats.spread = 19
	self.scar.stats.recoil = 8
	self.scar.stats.concealment = 19
	self.scar.fire_mode_data.fire_rate = 60 / 550

	-- Gewehr 3
	self.g3.categories = dmr_category
	self.g3.CLIP_AMMO_MAX = 20
	self.g3.stats.damage = 48
	self.g3.stats.spread = 20
	self.g3.stats.recoil = 7
	self.g3.stats.concealment = 18
	self.g3.fire_mode_data.fire_rate = 60 / 600

	-- Gecko 7.62
	self.galil.categories = dmr_category
	self.galil.CLIP_AMMO_MAX = 25
	self.galil.stats.damage = 48
	self.galil.stats.spread = 18
	self.galil.stats.recoil = 9
	self.galil.stats.concealment = 18
	self.galil.fire_mode_data.fire_rate = 60 / 600

	-- Falcon
	self.fal.categories = dmr_category
	self.fal.CLIP_AMMO_MAX = 20
	self.fal.stats.damage = 48
	self.fal.stats.spread = 18
	self.fal.stats.recoil = 9
	self.fal.stats.concealment = 20
	self.fal.fire_mode_data.fire_rate = 60 / 700

	-- Valkyria
	self.asval.categories = dmr_category
	self.asval.CLIP_AMMO_MAX = 20
	self.asval.stats.damage = 48
	self.asval.stats.spread = 16
	self.asval.stats.recoil = 11
	self.asval.stats.concealment = 24
	self.asval.fire_mode_data.fire_rate = 60 / 900

	-- M308
	self.new_m14.categories = dmr_category
	self.new_m14.CLIP_AMMO_MAX = 15
	self.new_m14.stats.damage = 64
	self.new_m14.stats.spread = 22
	self.new_m14.stats.recoil = 5
	self.new_m14.stats.concealment = 18
	self.new_m14.fire_mode_data.fire_rate = 60 / 700

	-- Little Friend 7.62
	self.contraband.categories = dmr_category
	self.contraband.CLIP_AMMO_MAX = 20
	self.contraband.stats.damage = 64
	self.contraband.stats.spread = 19
	self.contraband.stats.recoil = 8
	self.contraband.stats.concealment = 12
	self.contraband.fire_mode_data.fire_rate = 60 / 600

	-- Little Friend 7.62 Underbarrel Grenade Launcher
	self.contraband_m203.CLIP_AMMO_MAX = 1
	self.contraband_m203.stats.damage = 72
	self.contraband_m203.stats.spread = 24
	self.contraband_m203.stats.recoil = 20
	self.contraband_m203.stats.concealment = 12
	self.contraband_m203.fire_mode_data.fire_rate = 60 / 60
	self.contraband_m203.stats_modifiers = { damage = 5 }

	-- KS12 Urban
	self.shak12.categories = dmr_category
	self.shak12.CLIP_AMMO_MAX = 20
	self.shak12.stats.damage = 64
	self.shak12.stats.spread = 18
	self.shak12.stats.recoil = 9
	self.shak12.stats.concealment = 23
	self.shak12.fire_mode_data.fire_rate = 60 / 600
	self.shak12.reload_speed_multiplier = 0.7

	-- Akron HC
	self.hcar.categories = dmr_category
	self.hcar.CLIP_AMMO_MAX = 20
	self.hcar.stats.damage = 64
	self.hcar.stats.spread = 20
	self.hcar.stats.recoil = 7
	self.hcar.stats.concealment = 18
	self.hcar.fire_mode_data.fire_rate = 60 / 450

	-- Galant
	self.ching.categories = dmr_category
	self.ching.CLIP_AMMO_MAX = 8
	self.ching.stats.damage = 72
	self.ching.stats.spread = 22
	self.ching.stats.recoil = 5
	self.ching.stats.concealment = 18
	self.ching.fire_mode_data.fire_rate = 60 / 500

	-- Pistols

	-- STRYK 18c
	self.glock_18c.CLIP_AMMO_MAX = 19
	self.glock_18c.stats.damage = 16
	self.glock_18c.stats.spread = 13
	self.glock_18c.stats.recoil = 15
	self.glock_18c.stats.concealment = 29
	self.glock_18c.fire_mode_data.fire_rate = 60 / 1200

	-- Czech 92
	self.czech.CLIP_AMMO_MAX = 18
	self.czech.stats.damage = 16
	self.czech.stats.spread = 15
	self.czech.stats.recoil = 13
	self.czech.stats.concealment = 28
	self.czech.fire_mode_data.fire_rate = 60 / 1000

	-- Bernetti Auto
	self.beer.CLIP_AMMO_MAX = 15
	self.beer.stats.damage = 16
	self.beer.stats.spread = 14
	self.beer.stats.recoil = 14
	self.beer.stats.concealment = 28
	self.beer.fire_mode_data.fire_rate = 60 / 1100

	-- Igor Automatik
	self.stech.CLIP_AMMO_MAX = 20
	self.stech.stats.damage = 18
	self.stech.stats.spread = 14
	self.stech.stats.recoil = 8
	self.stech.stats.concealment = 29
	self.stech.fire_mode_data.fire_rate = 60 / 750

	-- Chimano 88
	self.glock_17.CLIP_AMMO_MAX = 17
	self.glock_17.stats.damage = 20
	self.glock_17.stats.spread = 14
	self.glock_17.stats.recoil = 16
	self.glock_17.stats.concealment = 29
	self.glock_17.fire_mode_data.fire_rate = 60 / 600

	-- Bernetti 9
	self.b92fs.CLIP_AMMO_MAX = 15
	self.b92fs.stats.damage = 20
	self.b92fs.stats.spread = 16
	self.b92fs.stats.recoil = 15
	self.b92fs.stats.concealment = 29
	self.b92fs.fire_mode_data.fire_rate = 60 / 600

	-- Chimano Compact
	self.g26.CLIP_AMMO_MAX = 10
	self.g26.stats.damage = 20
	self.g26.stats.spread = 13
	self.g26.stats.recoil = 17
	self.g26.stats.concealment = 30
	self.g26.fire_mode_data.fire_rate = 60 / 600
	self.g26.reload_speed_multiplier = 1.15

	-- White Streak
	self.pl14.CLIP_AMMO_MAX = 16
	self.pl14.stats.damage = 20
	self.pl14.stats.spread = 16
	self.pl14.stats.recoil = 14
	self.pl14.stats.concealment = 29
	self.pl14.fire_mode_data.fire_rate = 60 / 600

	-- Contractor
	self.packrat.CLIP_AMMO_MAX = 15
	self.packrat.stats.damage = 20
	self.packrat.stats.spread = 16
	self.packrat.stats.recoil = 15
	self.packrat.stats.concealment = 29
	self.packrat.fire_mode_data.fire_rate = 60 / 600

	-- Holt
	self.holt.CLIP_AMMO_MAX = 15
	self.holt.stats.damage = 20
	self.holt.stats.spread = 13
	self.holt.stats.recoil = 17
	self.holt.stats.concealment = 30
	self.holt.fire_mode_data.fire_rate = 60 / 600

	-- Broomstick
	self.c96.CLIP_AMMO_MAX = 10
	self.c96.stats.damage = 20
	self.c96.stats.spread = 14
	self.c96.stats.recoil = 8
	self.c96.stats.concealment = 28
	self.c96.fire_mode_data.fire_rate = 60 / 900
	self.c96.FIRE_MODE = "auto"
	self.c96.sounds.fire_single = self.c96.sounds.fire
	self.c96.sounds.fire_auto = self.c96.sounds.fire
	self.c96.auto = {
		fire_rate = self.c96.fire_mode_data.fire_rate,
	}
	self.c96.CAN_TOGGLE_FIREMODE = true

	-- M13
	self.legacy.CLIP_AMMO_MAX = 13
	self.legacy.stats.damage = 24
	self.legacy.stats.spread = 15
	self.legacy.stats.recoil = 15
	self.legacy.stats.concealment = 30
	self.legacy.fire_mode_data.fire_rate = 60 / 600

	-- Gecko M2
	self.maxim9.CLIP_AMMO_MAX = 17
	self.maxim9.stats.damage = 24
	self.maxim9.stats.spread = 16
	self.maxim9.stats.recoil = 14
	self.maxim9.stats.concealment = 29
	self.maxim9.fire_mode_data.fire_rate = 60 / 600
	self.maxim9.can_do_shotgun_push = false

	-- Signature .40
	self.p226.CLIP_AMMO_MAX = 12
	self.p226.stats.damage = 30
	self.p226.stats.spread = 18
	self.p226.stats.recoil = 10
	self.p226.stats.concealment = 29
	self.p226.fire_mode_data.fire_rate = 60 / 600

	-- Chimano Custom
	self.g22c.CLIP_AMMO_MAX = 16
	self.g22c.stats.damage = 30
	self.g22c.stats.spread = 14
	self.g22c.stats.recoil = 12
	self.g22c.stats.concealment = 29
	self.g22c.fire_mode_data.fire_rate = 60 / 600

	-- LEO
	self.hs2000.CLIP_AMMO_MAX = 16
	self.hs2000.stats.damage = 30
	self.hs2000.stats.spread = 14
	self.hs2000.stats.recoil = 12
	self.hs2000.stats.concealment = 29
	self.hs2000.fire_mode_data.fire_rate = 60 / 600

	-- Baby Deagle
	self.sparrow.CLIP_AMMO_MAX = 12
	self.sparrow.stats.damage = 30
	self.sparrow.stats.spread = 18
	self.sparrow.stats.recoil = 10
	self.sparrow.stats.concealment = 29
	self.sparrow.fire_mode_data.fire_rate = 60 / 600

	-- Interceptor
	self.usp.CLIP_AMMO_MAX = 12
	self.usp.stats.damage = 36
	self.usp.stats.spread = 18
	self.usp.stats.recoil = 8
	self.usp.stats.concealment = 29
	self.usp.fire_mode_data.fire_rate = 60 / 600

	-- Gruber Kurz
	self.ppk.CLIP_AMMO_MAX = 7
	self.ppk.stats.damage = 36
	self.ppk.stats.spread = 16
	self.ppk.stats.recoil = 10
	self.ppk.stats.concealment = 30
	self.ppk.fire_mode_data.fire_rate = 60 / 600

	-- Strix
	self.pmm.CLIP_AMMO_MAX = 8
	self.pmm.stats.damage = 36
	self.pmm.stats.spread = 14
	self.pmm.stats.recoil = 12
	self.pmm.stats.concealment = 30
	self.pmm.fire_mode_data.fire_rate = 60 / 600
	self.pmm.weapon_hold = "glock"
	self.pmm.animations.reload_name_id = "ppk"

	-- 5/7 AP
	self.lemming.CLIP_AMMO_MAX = 15
	self.lemming.stats.damage = 36
	self.lemming.stats.spread = 13
	self.lemming.stats.recoil = 10
	self.lemming.stats.concealment = 28
	self.lemming.fire_mode_data.fire_rate = 60 / 600

	-- Crosskill Guard
	self.shrew.CLIP_AMMO_MAX = 8
	self.shrew.stats.damage = 36
	self.shrew.stats.spread = 16
	self.shrew.stats.recoil = 10
	self.shrew.stats.concealment = 31
	self.shrew.fire_mode_data.fire_rate = 60 / 600

	-- Crosskill
	self.colt_1911.CLIP_AMMO_MAX = 8
	self.colt_1911.stats.damage = 40
	self.colt_1911.stats.spread = 18
	self.colt_1911.stats.recoil = 8
	self.colt_1911.stats.concealment = 29
	self.colt_1911.fire_mode_data.fire_rate = 60 / 600

	-- Crosskill Chunky Compact
	self.m1911.CLIP_AMMO_MAX = 8
	self.m1911.stats.damage = 40
	self.m1911.stats.spread = 18
	self.m1911.stats.recoil = 8
	self.m1911.stats.concealment = 29
	self.m1911.fire_mode_data.fire_rate = 60 / 600

	-- Kang Arms Model 54
	self.type54.CLIP_AMMO_MAX = 8
	self.type54.stats.damage = 40
	self.type54.stats.spread = 16
	self.type54.stats.recoil = 10
	self.type54.stats.concealment = 29
	self.type54.fire_mode_data.fire_rate = 60 / 600

	-- Kang Arms Model 54 Underbarrel Shotgun
	self.type54_underbarrel.CLIP_AMMO_MAX = 1
	self.type54_underbarrel.stats.damage = 30
	self.type54_underbarrel.stats.spread = 10
	self.type54_underbarrel.stats.recoil = 4
	self.type54_underbarrel.stats.concealment = 29
	self.type54_underbarrel.fire_mode_data.fire_rate = 60 / 60
	self.type54_underbarrel.reload_speed_multiplier = 1.3
	self.type54_underbarrel.stats_modifiers = nil

	-- Parabellum
	self.breech.CLIP_AMMO_MAX = 8
	self.breech.stats.damage = 48
	self.breech.stats.spread = 20
	self.breech.stats.recoil = 7
	self.breech.stats.concealment = 30
	self.breech.fire_mode_data.fire_rate = 60 / 600

	-- Deagle
	self.deagle.CLIP_AMMO_MAX = 7
	self.deagle.stats.damage = 80
	self.deagle.stats.spread = 18
	self.deagle.stats.recoil = 4
	self.deagle.stats.concealment = 28
	self.deagle.fire_mode_data.fire_rate = 60 / 400
	self.deagle.non_standard_fire_rate = true

	self._init_stat_overrides.deagle = function()
		self.deagle.stats.alert_size = 7
		self.deagle.stats.suppression = 7
		self.deagle.spread = {
			standing = 4.5,
			crouching = 3,
			steelsight = 1.5,
			moving_standing = 6,
			moving_crouching = 6,
			moving_steelsight = 1.5,
		}	
		self.deagle.spread_bloom = {
			add = 2,
			add_steelsight = 1.5,
			max = 3,
			recovery = 1.25,
			recovery_wait_multiplier = 1.75,
		}
		self.deagle.kick = {
			standing = { 1.8, 2.4, 0.6, -0.2 },
			crouching = { 1.8, 2.4, 0.6, -0.2 },
			steelsight = { 1.6, 2, 0.4, -0.2 },
			moving_standing = { 2.4, 3, 0.6, -0.2 },
			moving_crouching = { 2.4, 3, 0.6, -0.2 },
			moving_steelsight = { 1.8, 2.4, 0.6, -0.2 },
		}
		self.deagle._total_ammo_mul = 1
		self.deagle._pickup_mul = 0.66
		self.deagle.shake.fire_multiplier = 1.3
	end

	-- Pipette Mk.2
	self.welrod.CLIP_AMMO_MAX = 5
	self.welrod.stats.damage = 96
	self.welrod.stats.spread = 18
	self.welrod.stats.recoil = 4
	self.welrod.stats.concealment = 27
	self.welrod.fire_mode_data.fire_rate = 60 / 27
	self.welrod.fire_rate_multiplier = 45 / 27
	self.welrod.special_damage_multiplier = 1.5
	self.welrod.timers.reload_not_empty = 3
	self.welrod.timers.reload_empty = self.welrod.timers.reload_not_empty
	self.welrod.stats_modifiers = nil
	self.welrod.non_standard_fire_rate = true -- No automatic pistol fire rate override
	self.welrod.can_shoot_through_enemy = true
	self.welrod.can_shoot_through_shield = true -- Was it really that hard, STG?
	self.welrod.can_shoot_through_wall = true
	self.welrod.has_description = true
	self.welrod.desc_id = "bm_w_lemming_desc"

	local revolver_category = {
		"revolver"
	}

	-- Matever .357
	self.mateba.categories = revolver_category
	self.mateba.CLIP_AMMO_MAX = 6
	self.mateba.stats.damage = 64
	self.mateba.stats.spread = 22
	self.mateba.stats.recoil = 6
	self.mateba.stats.concealment = 28
	self.mateba.fire_mode_data.fire_rate = 60 / 300
	self.mateba.reload_speed_multiplier = 1.3

	-- Kahn .357
	self.korth.categories = revolver_category
	self.korth.CLIP_AMMO_MAX = 8
	self.korth.stats.damage = 64
	self.korth.stats.spread = 20
	self.korth.stats.recoil = 8
	self.korth.stats.concealment = 28
	self.korth.fire_mode_data.fire_rate = 60 / 300

	-- Bronco .44
	self.new_raging_bull.categories = revolver_category
	self.new_raging_bull.CLIP_AMMO_MAX = 6
	self.new_raging_bull.stats.damage = 80
	self.new_raging_bull.stats.spread = 22
	self.new_raging_bull.stats.recoil = 4
	self.new_raging_bull.stats.concealment = 28
	self.new_raging_bull.fire_mode_data.fire_rate = 60 / 300

	--Peacemaker .45
	self.peacemaker.categories = revolver_category
	self.peacemaker.CLIP_AMMO_MAX = 6
	self.peacemaker.stats.damage = 80
	self.peacemaker.stats.spread = 22
	self.peacemaker.stats.recoil = 4
	self.peacemaker.stats.concealment = 28
	self.peacemaker.fire_mode_data.fire_rate = 60 / 300
	self.peacemaker.reload_speed_multiplier = 1.6
	self.peacemaker.armor_piercing_chance = 1
	self.peacemaker.stats_modifiers = nil
	self.peacemaker.can_shoot_through_enemy = true
	self.peacemaker.can_shoot_through_shield = true
	self.peacemaker.can_shoot_through_wall = true
	self.peacemaker.has_description = true
	self.peacemaker.desc_id = "bm_w_lemming_desc"

	-- Castigo .44
	self.chinchilla.categories = revolver_category
	self.chinchilla.CLIP_AMMO_MAX = 6
	self.chinchilla.stats.damage = 80
	self.chinchilla.stats.spread = 22
	self.chinchilla.stats.recoil = 4
	self.chinchilla.stats.concealment = 29
	self.chinchilla.fire_mode_data.fire_rate = 60 / 300
	self.chinchilla.reload_speed_multiplier = 1.15

	-- Frenchman Model 87
	self.model3.categories = revolver_category
	self.model3.CLIP_AMMO_MAX = 6
	self.model3.stats.damage = 80
	self.model3.stats.spread = 20
	self.model3.stats.recoil = 6
	self.model3.stats.concealment = 28
	self.model3.fire_mode_data.fire_rate = 60 / 300

	-- Akimbo Frenchman Model 87
	self.x_model3.timers.reload_not_empty = 2.50
	self.x_model3.timers.reload_empty = self.x_model3.timers.reload_not_empty

	-- RUS-12 Angry Tiger
	self.rsh12.categories = revolver_category
	self.rsh12.CLIP_AMMO_MAX = 5
	self.rsh12.stats.damage = 96
	self.rsh12.stats.spread = 22
	self.rsh12.stats.recoil = 2
	self.rsh12.stats.concealment = 27
	self.rsh12.fire_mode_data.fire_rate = 60 / 300
	self.rsh12.reload_speed_multiplier = 0.7
	self.rsh12.stats_modifiers = nil

	-- SMGs

	-- CMP
	self.mp9.CLIP_AMMO_MAX = 20
	self.mp9.stats.damage = 16
	self.mp9.stats.spread = 11
	self.mp9.stats.recoil = 20
	self.mp9.stats.concealment = 27
	self.mp9.fire_mode_data.fire_rate = 60 / 900

	-- Cobra
	self.scorpion.CLIP_AMMO_MAX = 20
	self.scorpion.stats.damage = 16
	self.scorpion.stats.spread = 11
	self.scorpion.stats.recoil = 18
	self.scorpion.stats.concealment = 28
	self.scorpion.fire_mode_data.fire_rate = 60 / 1000
	self.scorpion.reload_speed_multiplier = 1.15

	-- Blaster 9mm
	self.tec9.CLIP_AMMO_MAX = 32
	self.tec9.stats.damage = 16
	self.tec9.stats.spread = 10
	self.tec9.stats.recoil = 20
	self.tec9.stats.concealment = 28
	self.tec9.fire_mode_data.fire_rate = 60 / 1100

	-- Micro Uzi
	self.baka.CLIP_AMMO_MAX = 32
	self.baka.stats.damage = 16
	self.baka.stats.spread = 10
	self.baka.stats.recoil = 18
	self.baka.stats.concealment = 28
	self.baka.fire_mode_data.fire_rate = 60 / 1200

	-- Akimbo Micro Uzi
	self.x_baka.sounds.reload = {
		wp_akmsu_x_take_new = "wp_baka_take_new",
		wp_akmsu_x_clip_slide_out = "wp_baka_mag_slide_out",
		wp_akmsu_x_clip_slide_in = "wp_baka_mag_slide_in",
		wp_akmsu_x_clip_in_contact = "",
		wp_akmsu_x_lever_pull = "wp_baka_lever_pull",
		wp_akmsu_x_lever_release = "wp_baka_lever_release"
	}

	-- Miyaka 10
	self.pm9.use_data.selection_index = 2
	self.pm9.CLIP_AMMO_MAX = 25
	self.pm9.stats.damage = 16
	self.pm9.stats.spread = 11
	self.pm9.stats.recoil = 20
	self.pm9.stats.concealment = 27
	self.pm9.fire_mode_data.fire_rate = 60 / 1100

	-- Wasp
	self.fmg9.CLIP_AMMO_MAX = 27
	self.fmg9.stats.damage = 16
	self.fmg9.stats.spread = 12
	self.fmg9.stats.recoil = 16
	self.fmg9.stats.concealment = 29
	self.fmg9.fire_mode_data.fire_rate = 60 / 1000
	self.fmg9.timers.unequip = 1.2

	-- Compact-5
	self.new_mp5.CLIP_AMMO_MAX = 30
	self.new_mp5.stats.damage = 18
	self.new_mp5.stats.spread = 14
	self.new_mp5.stats.recoil = 19
	self.new_mp5.stats.concealment = 25
	self.new_mp5.fire_mode_data.fire_rate = 60 / 800

	-- Akimbo Compact-5
	self.x_mp5.timers.reload_not_empty = 1.95
	self.x_mp5.timers.reload_empty = 2.6

	-- Tatonka
	self.coal.use_data.selection_index = 2
	self.coal.CLIP_AMMO_MAX = 64
	self.coal.stats.damage = 18
	self.coal.stats.spread = 14
	self.coal.stats.recoil = 16
	self.coal.stats.concealment = 24
	self.coal.fire_mode_data.fire_rate = 60 / 700

	-- Signature
	self.shepheard.use_data.selection_index = 2
	self.shepheard.CLIP_AMMO_MAX = 30
	self.shepheard.stats.damage = 18
	self.shepheard.stats.spread = 14
	self.shepheard.stats.recoil = 19
	self.shepheard.stats.concealment = 25
	self.shepheard.fire_mode_data.fire_rate = 60 / 800

	-- SpecOps
	self.mp7.CLIP_AMMO_MAX = 20
	self.mp7.stats.damage = 20
	self.mp7.stats.spread = 14
	self.mp7.stats.recoil = 16
	self.mp7.stats.concealment = 27
	self.mp7.fire_mode_data.fire_rate = 60 / 950

	-- Akimbo Mark 10
	self.x_mac10.sounds.reload = {
		wp_akmsu_x_clip_slide_out = "wp_mac10_clip_slide_out",
		wp_akmsu_x_clip_slide_in = "wp_mac10_clip_slide_in",
		wp_akmsu_x_clip_in_contact = "wp_mac10_clip_in_contact",
		wp_akmsu_x_lever_pull = "wp_mac10_lever_pull",
		wp_akmsu_x_lever_release = "wp_mac10_lever_release"
	}

	-- Kobus 90
	self.p90.use_data.selection_index = 2
	self.p90.CLIP_AMMO_MAX = 50
	self.p90.stats.damage = 20
	self.p90.stats.spread = 14
	self.p90.stats.recoil = 16
	self.p90.stats.concealment = 26
	self.p90.fire_mode_data.fire_rate = 60 / 900

	-- Chicago Typewriter
	self.m1928.CLIP_AMMO_MAX = 50
	self.m1928.stats.damage = 20
	self.m1928.stats.spread = 14
	self.m1928.stats.recoil = 16
	self.m1928.stats.concealment = 23
	self.m1928.fire_mode_data.fire_rate = 60 / 700

	-- Jacket's Piece
	self.cobray.use_data.selection_index = 2
	self.cobray.CLIP_AMMO_MAX = 32
	self.cobray.stats.damage = 20
	self.cobray.stats.spread = 11
	self.cobray.stats.recoil = 18
	self.cobray.stats.concealment = 26
	self.cobray.fire_mode_data.fire_rate = 60 / 1200
	self.cobray.timers.reload_not_empty = 1.9
	self.cobray.timers.reload_empty = 4.35
	self.cobray.reload_empty_speed_multiplier = 1.45

	-- Heather
	self.sr2.CLIP_AMMO_MAX = 30
	self.sr2.stats.damage = 20
	self.sr2.stats.spread = 11
	self.sr2.stats.recoil = 18
	self.sr2.stats.concealment = 28
	self.sr2.fire_mode_data.fire_rate = 60 / 900

	-- Mark 10
	self.mac10.CLIP_AMMO_MAX = 20
	self.mac10.stats.damage = 24
	self.mac10.stats.spread = 10
	self.mac10.stats.recoil = 17
	self.mac10.stats.concealment = 27
	self.mac10.fire_mode_data.fire_rate = 60 / 1000

	-- Uzi
	self.uzi.CLIP_AMMO_MAX = 32
	self.uzi.stats.damage = 24
	self.uzi.stats.spread = 14
	self.uzi.stats.recoil = 16
	self.uzi.stats.concealment = 26
	self.uzi.fire_mode_data.fire_rate = 60 / 600
	self.uzi.timers.reload_not_empty = 2

	-- Kross Vertex
	self.polymer.use_data.selection_index = 2
	self.polymer.CLIP_AMMO_MAX = 25
	self.polymer.stats.damage = 24
	self.polymer.stats.spread = 10
	self.polymer.stats.recoil = 21
	self.polymer.stats.concealment = 24
	self.polymer.fire_mode_data.fire_rate = 60 / 1200

	-- AK Gen 21 Tactical
	self.vityaz.use_data.selection_index = 2
	self.vityaz.CLIP_AMMO_MAX = 30
	self.vityaz.stats.damage = 24
	self.vityaz.stats.spread = 15
	self.vityaz.stats.recoil = 15
	self.vityaz.stats.concealment = 25
	self.vityaz.fire_mode_data.fire_rate = 60 / 750

	-- Swedish K
	self.m45.CLIP_AMMO_MAX = 36
	self.m45.stats.damage = 30
	self.m45.stats.spread = 16
	self.m45.stats.recoil = 14
	self.m45.stats.concealment = 25
	self.m45.fire_mode_data.fire_rate = 60 / 600

	-- MP40
	self.erma.use_data.selection_index = 2
	self.erma.CLIP_AMMO_MAX = 32
	self.erma.stats.damage = 30
	self.erma.stats.spread = 16
	self.erma.stats.recoil = 14
	self.erma.stats.concealment = 25
	self.erma.fire_mode_data.fire_rate = 60 / 550
	self.erma.reload_speed_multiplier = 1.15

	-- Pattchet L2A1
	self.sterling.use_data.selection_index = 2
	self.sterling.CLIP_AMMO_MAX = 20
	self.sterling.stats.damage = 30
	self.sterling.stats.spread = 14
	self.sterling.stats.recoil = 16
	self.sterling.stats.concealment = 24
	self.sterling.fire_mode_data.fire_rate = 60 / 550

	-- Jackal
	self.schakal.use_data.selection_index = 2
	self.schakal.CLIP_AMMO_MAX = 25
	self.schakal.stats.damage = 30
	self.schakal.stats.spread = 15
	self.schakal.stats.recoil = 14
	self.schakal.stats.concealment = 25
	self.schakal.fire_mode_data.fire_rate = 60 / 650

	-- Ballerina
	self.speen.CLIP_AMMO_MAX = 15
	self.speen.stats.damage = 36
	self.speen.stats.spread = 16
	self.speen.stats.recoil = 14
	self.speen.stats.concealment = 25
	self.speen.fire_mode_data.fire_rate = 60 / 500

	-- Shotguns

	-- Izhma
	self.saiga.CLIP_AMMO_MAX = 7
	self.saiga.stats.damage = 10
	self.saiga.stats.spread = 12
	self.saiga.stats.recoil = 12
	self.saiga.stats.concealment = 18
	self.saiga.fire_mode_data.fire_rate = 60 / 350

	-- Street Sweeper
	self.striker.CLIP_AMMO_MAX = 12
	self.striker.stats.damage = 10
	self.striker.stats.spread = 12
	self.striker.stats.recoil = 12
	self.striker.stats.concealment = 23
	self.striker.fire_mode_data.fire_rate = 60 / 450
	self.striker.reload_speed_multiplier = 1.3

	-- Steakout
	self.aa12.CLIP_AMMO_MAX = 8
	self.aa12.stats.damage = 10
	self.aa12.stats.spread = 11
	self.aa12.stats.recoil = 13
	self.aa12.stats.concealment = 16
	self.aa12.fire_mode_data.fire_rate = 60 / 300

	-- Grimm
	self.basset.CLIP_AMMO_MAX = 7
	self.basset.stats.damage = 10
	self.basset.stats.spread = 11
	self.basset.stats.recoil = 13
	self.basset.stats.concealment = 24
	self.basset.fire_mode_data.fire_rate = 60 / 350

	-- VD-12
	self.sko12.CLIP_AMMO_MAX = 25
	self.sko12.stats.damage = 10
	self.sko12.stats.spread = 12
	self.sko12.stats.recoil = 12
	self.sko12.stats.concealment = 12
	self.sko12.fire_mode_data.fire_rate = 60 / 300
	self.sko12.shell_ejection = self.r870.shell_ejection
	self.sko12.reload_speed_multiplier = 0.7
	self.sko12.FIRE_MODE = "single"
	self.sko12.CAN_TOGGLE_FIREMODE = false
	
	-- M1014
	self.benelli.CLIP_AMMO_MAX = 6
	self.benelli.stats.damage = 12
	self.benelli.stats.spread = 13
	self.benelli.stats.recoil = 10
	self.benelli.stats.concealment = 18
	self.benelli.fire_mode_data.fire_rate = 60 / 300

	-- Predator
	self.spas12.CLIP_AMMO_MAX = 8
	self.spas12.stats.damage = 12
	self.spas12.stats.spread = 13
	self.spas12.stats.recoil = 10
	self.spas12.stats.concealment = 18
	self.spas12.fire_mode_data.fire_rate = 60 / 300

	-- Goliath
	self.rota.upgrade_blocks = { -- Disable magazine size increase upgrades.
		weapon = { "clip_ammo_increase" },
	}
	self.rota.CLIP_AMMO_MAX = 6
	self.rota.stats.damage = 12
	self.rota.stats.spread = 12
	self.rota.stats.recoil = 12
	self.rota.stats.concealment = 22
	self.rota.fire_mode_data.fire_rate = 60 / 300

	-- Argos III
	self.ultima.use_data.selection_index = 2
	self.ultima.CLIP_AMMO_MAX = 7
	self.ultima.stats.damage = 12
	self.ultima.stats.spread = 13
	self.ultima.stats.recoil = 10
	self.ultima.stats.concealment = 21
	self.ultima.fire_mode_data.fire_rate = 60 / 300
	self.ultima.reload_speed_multiplier = 0.7

	-- Reinfeld 880
	self.r870.CLIP_AMMO_MAX = 8
	self.r870.stats.damage = 16
	self.r870.stats.spread = 14
	self.r870.stats.recoil = 8
	self.r870.stats.concealment = 18
	self.r870.fire_mode_data.fire_rate = 60 / 120

	-- Locomotive
	self.serbu.CLIP_AMMO_MAX = 4
	self.serbu.stats.damage = 16
	self.serbu.stats.spread = 12
	self.serbu.stats.recoil = 9
	self.serbu.stats.concealment = 24
	self.serbu.fire_mode_data.fire_rate = 60 / 120
	self.serbu.fire_rate_multiplier = 150 / 120

	-- Raven
	self.ksg.CLIP_AMMO_MAX = 14
	self.ksg.stats.damage = 16
	self.ksg.stats.spread = 14
	self.ksg.stats.recoil = 8
	self.ksg.stats.concealment = 22
	self.ksg.fire_mode_data.fire_rate = 60 / 120
	self.ksg.fire_rate_multiplier = 90 / 120

	-- Judge
	self.judge.CLIP_AMMO_MAX = 5
	self.judge.stats.damage = 16
	self.judge.stats.spread = 14
	self.judge.stats.recoil = 8
	self.judge.stats.concealment = 28
	self.judge.fire_mode_data.fire_rate = 60 / 300

	self._init_stat_overrides.judge = function()
		self.judge.kick = {
			standing = { 2.9, 3, -0.5, 0.5 },
			crouching = self.judge.kick.standing,
			steelsight = self.judge.kick.standing,
			moving_standing = { 2.9, 3, -0.5, 0.5 },
			moving_crouching = self.judge.kick.moving_standing,
			moving_steelsight = self.judge.kick.moving_standing,
		}
		self.judge._pickup_mul = (1 / self.judge.rays) * 0.85
		self.judge.damage_near = 1000
		self.judge.damage_far = 2000
	end

    self.x_judge.weapon_hold = "x_chinchilla"
    self.x_judge.animations.reload_name_id = "x_chinchilla"
	self.x_judge.animations.second_gun_versions = self.x_judge.animations.second_gun_versions or {}
    self.x_judge.animations.second_gun_versions.reload = "reload"
	self.x_judge.sounds.reload = {
		wp_chinchilla_cylinder_out = "wp_rbull_drum_open",
		wp_chinchilla_eject_shells = "wp_rbull_shells_out",
		wp_chinchilla_insert = "wp_rbull_shells_in",
		wp_chinchilla_cylinder_in = "wp_rbull_drum_close"
	}

	self._init_stat_overrides.x_judge = function()
		self.x_judge.kick = {
			standing = { 2.9, 3, -0.5, 0.5 },
			crouching = self.x_judge.kick.standing,
			steelsight = self.x_judge.kick.standing,
			moving_standing = { 2.9, 3, -0.5, 0.5 },
			moving_crouching = self.x_judge.kick.moving_standing,
			moving_steelsight = self.x_judge.kick.moving_standing,
		}
		self.x_judge._pickup_mul = (1 / self.x_judge.rays) * 0.85
		self.x_judge.damage_near = 1000
		self.x_judge.damage_far = 2000
	end

	-- Mosconi Tactical
	self.m590.CLIP_AMMO_MAX = 6
	self.m590.stats.damage = 16
	self.m590.stats.spread = 14
	self.m590.stats.recoil = 8
	self.m590.stats.concealment = 19
	self.m590.fire_mode_data.fire_rate = 60 / 120

	-- GSPS
	self.m37.CLIP_AMMO_MAX = 4
	self.m37.stats.damage = 20
	self.m37.stats.spread = 14
	self.m37.stats.recoil = 8
	self.m37.stats.concealment = 19
	self.m37.fire_mode_data.fire_rate = 60 / 100
	self.m37.fire_rate_multiplier = 90 / 100

	-- Breaker
	self.boot.CLIP_AMMO_MAX = 5
	self.boot.stats.damage = 24
	self.boot.stats.spread = 15
	self.boot.stats.recoil = 7
	self.boot.stats.concealment = 22
	self.boot.fire_mode_data.fire_rate = 60 / 80
	self.boot.fire_rate_multiplier = 75 / 80

	-- Reinfeld 88
	self.m1897.CLIP_AMMO_MAX = 5
	self.m1897.stats.damage = 20
	self.m1897.stats.spread = 15
	self.m1897.stats.recoil = 7
	self.m1897.stats.concealment = 18
	self.m1897.fire_mode_data.fire_rate = 60 / 100
	self.m1897.fire_rate_multiplier = 90 / 100

	-- Deimos
	self.supernova.CLIP_AMMO_MAX = 5
	self.supernova.stats.damage = 20
	self.supernova.stats.spread = 15
	self.supernova.stats.recoil = 7
	self.supernova.stats.concealment = 18
	self.supernova.fire_mode_data.fire_rate = 60 / 90
	self.supernova.alt_fire_data = nil

	-- Mosconi
	self.huntsman.CLIP_AMMO_MAX = 2
	self.huntsman.stats.damage = 24
	self.huntsman.stats.spread = 16
	self.huntsman.stats.recoil = 5
	self.huntsman.stats.concealment = 17
	self.huntsman.fire_mode_data.fire_rate = 60 / 500

	-- Joceline O/U
	self.b682.CLIP_AMMO_MAX = 2
	self.b682.stats.damage = 24
	self.b682.stats.spread = 16
	self.b682.stats.recoil = 5
	self.b682.stats.concealment = 17
	self.b682.fire_mode_data.fire_rate = 60 / 500

	-- Claire
	self.coach.CLIP_AMMO_MAX = 2
	self.coach.stats.damage = 24
	self.coach.stats.spread = 15
	self.coach.stats.recoil = 7
	self.coach.stats.concealment = 19
	self.coach.fire_mode_data.fire_rate = 60 / 500
	self.coach.timers.reload_not_empty = 1.60
	self.coach.timers.reload_empty = self.coach.timers.reload_not_empty
	self.coach.reload_speed_multiplier = 0.85
	
	-- LMGs 
	
	-- KSP
	self.m249.CLIP_AMMO_MAX = 200
	self.m249.stats.damage = 18
	self.m249.stats.spread = 13
	self.m249.stats.recoil = 8
	self.m249.stats.concealment = 10
	self.m249.fire_mode_data.fire_rate = 60 / 900
	self.m249.reload_speed_multiplier = 0.85

	-- Buzzsaw 42
	self.mg42.CLIP_AMMO_MAX = 150
	self.mg42.stats.damage = 18
	self.mg42.stats.spread = 13
	self.mg42.stats.recoil = 8
	self.mg42.stats.concealment = 10
	self.mg42.fire_mode_data.fire_rate = 60 / 1200

	-- Bootleg
	self.tecci.categories = { "lmg" }
	self.tecci.CLIP_AMMO_MAX = 100
	self.tecci.stats.damage = 18
	self.tecci.stats.spread = 11
	self.tecci.stats.recoil = 10
	self.tecci.stats.concealment = 18
	self.tecci.fire_mode_data.fire_rate = 60 / 800
	self.tecci.CAN_TOGGLE_FIREMODE = false

	-- Campbell 74
	self.kacchainsaw.CLIP_AMMO_MAX = 200
	self.kacchainsaw.stats.damage = 18
	self.kacchainsaw.stats.spread = 13
	self.kacchainsaw.stats.recoil = 8
	self.kacchainsaw.stats.concealment = 14
	self.kacchainsaw.fire_mode_data.fire_rate = 60 / 800
	self.kacchainsaw.timers.deploy_bipod = nil

	-- MA-17
	self.kacchainsaw_flamethrower.CLIP_AMMO_MAX = 50
	self.kacchainsaw_flamethrower.stats.damage = 8
	self.kacchainsaw_flamethrower.stats.spread = 0
	self.kacchainsaw_flamethrower.stats.recoil = 0
	self.kacchainsaw_flamethrower.stats.concealment = 20
	self.kacchainsaw_flamethrower.fire_mode_data.fire_rate = 60 / 2000
	self.kacchainsaw_flamethrower.flame_max_range = 1000
	self.kacchainsaw_flamethrower.dot_data_name = "weapon_kacchainsaw_flamethrower"

	-- RPK
	self.rpk.CLIP_AMMO_MAX = 75
	self.rpk.stats.damage = 24
	self.rpk.stats.spread = 14
	self.rpk.stats.recoil = 6
	self.rpk.stats.concealment = 14
	self.rpk.fire_mode_data.fire_rate = 60 / 650

	-- Versteckt 51b
	self.hk51b.CLIP_AMMO_MAX = 60
	self.hk51b.stats.damage = 24
	self.hk51b.stats.spread = 11
	self.hk51b.stats.recoil = 3
	self.hk51b.stats.concealment = 21
	self.hk51b.fire_mode_data.fire_rate = 60 / 700
	self.hk51b.reload_speed_multiplier = 0.85
	self.hk51b.timers.deploy_bipod = nil

	-- Brenner-21
	self.hk21.CLIP_AMMO_MAX = 100
	self.hk21.stats.damage = 30
	self.hk21.stats.spread = 14
	self.hk21.stats.recoil = 6
	self.hk21.stats.concealment = 10
	self.hk21.fire_mode_data.fire_rate = 60 / 750

	-- KSP 58
	self.par.CLIP_AMMO_MAX = 100
	self.par.stats.damage = 30
	self.par.stats.spread = 16
	self.par.stats.recoil = 5
	self.par.stats.concealment = 10
	self.par.fire_mode_data.fire_rate = 60 / 700

	-- M60
	self.m60.CLIP_AMMO_MAX = 100
	self.m60.stats.damage = 30
	self.m60.stats.spread = 13
	self.m60.stats.recoil = 8
	self.m60.stats.concealment = 10
	self.m60.fire_mode_data.fire_rate = 60 / 550

	-- Sniper Rifles

	-- Contractor
	self.tti.CLIP_AMMO_MAX = 20
	self.tti.stats.damage = 64
	self.tti.stats.spread = 20
	self.tti.stats.recoil = 8
	self.tti.stats.concealment = 16
	self.tti.fire_mode_data.fire_rate = 60 / 180
	self.tti.reload_speed_multiplier = 0.85
	self.tti.stats_modifiers = nil

	-- Grom
	self.siltstone.CLIP_AMMO_MAX = 10
	self.siltstone.stats.damage = 64
	self.siltstone.stats.spread = 22
	self.siltstone.stats.recoil = 8
	self.siltstone.stats.concealment = 16
	self.siltstone.fire_mode_data.fire_rate = 60 / 180
	self.siltstone.stats_modifiers = nil

	-- Kang Arms
	self.qbu88.use_data.selection_index = 1
	self.qbu88.CLIP_AMMO_MAX = 10
	self.qbu88.stats.damage = 64
	self.qbu88.stats.spread = 19
	self.qbu88.stats.recoil = 11
	self.qbu88.stats.concealment = 19
	self.qbu88.fire_mode_data.fire_rate = 60 / 250
	self.qbu88.fire_rate_multiplier = 180 / 250
	self.qbu88.stats_modifiers = nil

	-- North Star
	self.victor.CLIP_AMMO_MAX = 10
	self.victor.stats.damage = 64
	self.victor.stats.spread = 20
	self.victor.stats.recoil = 8
	self.victor.stats.concealment = 16
	self.victor.fire_mode_data.fire_rate = 60 / 180
	self.victor.stats_modifiers = nil

	-- Lebensauger
	self.wa2000.CLIP_AMMO_MAX = 5
	self.wa2000.stats.damage = 80
	self.wa2000.stats.spread = 22
	self.wa2000.stats.recoil = 6
	self.wa2000.stats.concealment = 18
	self.wa2000.fire_mode_data.fire_rate = 60 / 120
	self.wa2000.stats_modifiers = nil

	-- Rangehitter
--	self.sbl.use_data.selection_index = 1
	self.sbl.CLIP_AMMO_MAX = 6
	self.sbl.stats.damage = 80
	self.sbl.stats.spread = 22
	self.sbl.stats.recoil = 6
	self.sbl.stats.concealment = 20
	self.sbl.fire_mode_data.fire_rate = 60 / 70
	self.sbl.fire_rate_multiplier = 90 / 70
	self.sbl.stats_modifiers = nil

	-- Rattlesnake
	self.msr.CLIP_AMMO_MAX = 10
	self.msr.stats.damage = 24
	self.msr.stats.spread = 23
	self.msr.stats.recoil = 8
	self.msr.stats.concealment = 14
	self.msr.fire_mode_data.fire_rate = 60 / 55
	self.msr.fire_rate_multiplier = 60 / 55
	self.msr.stats_modifiers = { damage = 5 }

	-- Repeater
	self.winchester1874.CLIP_AMMO_MAX = 10
	self.winchester1874.stats.damage = 24
	self.winchester1874.stats.spread = 24
	self.winchester1874.stats.recoil = 6
	self.winchester1874.stats.concealment = 12
	self.winchester1874.fire_mode_data.fire_rate = 60 / 70
	self.winchester1874.fire_rate_multiplier = 75 / 70
	self.winchester1874.stats_modifiers = { damage = 5 }

	-- R700
	self.r700.CLIP_AMMO_MAX = 10
	self.r700.stats.damage = 24
	self.r700.stats.spread = 24
	self.r700.stats.recoil = 8
	self.r700.stats.concealment = 16
	self.r700.fire_mode_data.fire_rate = 60 / 60
	self.r700.reload_speed_multiplier = 1.3
	self.r700.stats_modifiers = { damage = 5 }

	-- Pronghorn
	self.scout.CLIP_AMMO_MAX = 5
	self.scout.stats.damage = 24
	self.scout.stats.spread = 22
	self.scout.stats.recoil = 4
	self.scout.stats.concealment = 18
	self.scout.fire_mode_data.fire_rate = 60 / 60
	self.scout.stats_modifiers = { damage = 5 }

	-- R93
	self.r93.CLIP_AMMO_MAX = 6
	self.r93.stats.damage = 24
	self.r93.stats.spread = 24
	self.r93.stats.recoil = 4
	self.r93.stats.concealment = 14
	self.r93.fire_mode_data.fire_rate = 60 / 50
	self.r93.stats_modifiers = { damage = 10 }

	-- Nagant
	self.mosin.CLIP_AMMO_MAX = 5
	self.mosin.stats.damage = 24
	self.mosin.stats.spread = 24
	self.mosin.stats.recoil = 4
	self.mosin.stats.concealment = 14
	self.mosin.fire_mode_data.fire_rate = 60 / 50
	self.mosin.fire_rate_multiplier = 60 / 50
	self.mosin.stats_modifiers = { damage =  10 }

	-- Platypus
	self.model70.CLIP_AMMO_MAX = 5
	self.model70.stats.damage = 24
	self.model70.stats.spread = 24
	self.model70.stats.recoil = 4
	self.model70.stats.concealment = 14
	self.model70.fire_mode_data.fire_rate = 60 / 60
	self.model70.reload_speed_multiplier = 1.3
	self.model70.stats_modifiers = { damage = 10 }

	-- Desert Fox
	self.desertfox.CLIP_AMMO_MAX = 5
	self.desertfox.stats.damage = 24
	self.desertfox.stats.spread = 20
	self.desertfox.stats.recoil = 4
	self.desertfox.stats.concealment = 21
	self.desertfox.fire_mode_data.fire_rate = 60 / 45
	self.desertfox.stats_modifiers = { damage = 10 }

	-- Aran
	self.contender.CLIP_AMMO_MAX = 1
	self.contender.stats.damage = 24
	self.contender.stats.spread = 17
	self.contender.stats.recoil = 2
	self.contender.stats.concealment = 24
	self.contender.fire_mode_data.fire_rate = 60 / 90
	self.contender.timers.reload_empty = 1.7
	self.contender.timers.reload_not_empty = self.contender.timers.reload_empty
	self.contender.timers.reload_steelsight = self.contender.timers.reload_empty
	self.contender.timers.reload_steelsight_not_empty = self.contender.timers.reload_empty
	self.contender.stats_modifiers = { damage = 10 }
	self.contender.ignore_damage_upgrades = nil
	self.contender.rays = nil

	self._init_stat_overrides.contender = function()
		self.contender._clips_max_round = 4
	end

	-- Amaroq
	self.awp.CLIP_AMMO_MAX = 5
	self.awp.stats.damage = 24
	self.awp.stats.spread = 24
	self.awp.stats.recoil = 4
	self.awp.stats.concealment = 14
	self.awp.fire_mode_data.fire_rate = 60 / 45
	self.awp.fire_rate_multiplier = 60 / 45
	self.awp.stats_modifiers = { damage = 10 }

	-- Thanatos
	self.m95.CLIP_AMMO_MAX = 5
	self.m95.stats.damage = 96
	self.m95.stats.spread = 24
	self.m95.stats.recoil = 2
	self.m95.stats.concealment = 8
	self.m95.fire_mode_data.fire_rate = 60 / 40
	self.m95.stats_modifiers = { damage = 10 }

	self._init_stat_overrides.m95 = function()
		self.m95._pickup_mul = self.m95._pickup_mul * 1.66
		self.m95._total_ammo_mul = self.m95._total_ammo_mul * 1.66
	end

	-- Musket
	self.bessy.CLIP_AMMO_MAX = 1
	self.bessy.stats.damage = 120
	self.bessy.stats.spread = 24
	self.bessy.stats.recoil = 1
	self.bessy.stats.concealment = 6
	self.bessy.fire_mode_data.fire_rate = 60 / 30
	self.bessy.stats_modifiers = { damage = 20 }

	-- Special Weapons

	-- Crossbows
	
	-- Airbow
	self.ecp.CLIP_AMMO_MAX = 6
	self.ecp.stats.damage = 80
	self.ecp.stats.spread = 20
	self.ecp.stats.recoil = 22
	self.ecp.stats.concealment = 20
	self.ecp.fire_mode_data.fire_rate = 60 / 120
	self.ecp.stats_modifiers = nil

	-- Pistol Crossbow
	self.hunter.CLIP_AMMO_MAX = 1
	self.hunter.stats.damage = 80
	self.hunter.stats.spread = 24
	self.hunter.stats.recoil = 24
	self.hunter.stats.concealment = 28
	self.hunter.fire_mode_data.fire_rate = 60 / 60
	self.hunter.stats_modifiers = nil

	-- Dart Projector
	self.dart.CLIP_AMMO_MAX = 1
	self.dart.stats.damage = 60
	self.dart.stats.spread = 24
	self.dart.stats.recoil = 18
	self.dart.stats.concealment = 27
	self.dart.fire_mode_data.fire_rate = 3.6
	self.dart.charge_data = { max_t = 1 }
	self.dart.stats_modifiers = { damage = 2 }
	self.dart.projectile_type = "dart_arrow" -- default dart type

	-- Light Crossbow
	self.frankish.CLIP_AMMO_MAX = 1
	self.frankish.stats.damage = 60
	self.frankish.stats.spread = 24
	self.frankish.stats.recoil = 24
	self.frankish.stats.concealment = 24
	self.frankish.fire_mode_data.fire_rate = 60 / 45
	self.frankish.stats_modifiers = { damage = 2 }

	-- Heavy Crossbow
	self.arblast.CLIP_AMMO_MAX = 1
	self.arblast.stats.damage = 60
	self.arblast.stats.spread = 24
	self.arblast.stats.recoil = 24
	self.arblast.stats.concealment = 20
	self.arblast.fire_mode_data.fire_rate = 60 / 30
	self.arblast.stats_modifiers = { damage = 4 }
	self.arblast.reload_speed_multiplier = 1.3

	-- Bows
	
	-- Plainsrider
	self.plainsrider.CLIP_AMMO_MAX = 1
	self.plainsrider.stats.damage = 60
	self.plainsrider.stats.spread = 24
	self.plainsrider.stats.recoil = 24
	self.plainsrider.stats.concealment = 24
	self.plainsrider.fire_mode_data.fire_rate = 60 / 300
	self.plainsrider.stats_modifiers = { damage = 2 }

	-- English Longbow
	self.long.CLIP_AMMO_MAX = 1
	self.long.stats.damage = 60
	self.long.stats.spread = 25
	self.long.stats.recoil = 25
	self.long.stats.concealment = 22
	self.long.fire_mode_data.fire_rate = 60 / 300
	self.long.stats_modifiers = { damage = 4 }

	-- DECA Technologies Compound Bow
	self.elastic.CLIP_AMMO_MAX = 1
	self.elastic.stats.damage = 60
	self.elastic.stats.spread = 24
	self.elastic.stats.recoil = 24
	self.elastic.stats.concealment = 22
	self.elastic.fire_mode_data.fire_rate = 60 / 300
	self.elastic.stats_modifiers = { damage = 4 }

	-- Grenade Launchers
	
	-- Basilisk
	self.ms3gl.CLIP_AMMO_MAX = 3
	self.ms3gl.stats.damage = 24
	self.ms3gl.stats.spread = 16
	self.ms3gl.stats.recoil = 20
	self.ms3gl.stats.concealment = 24
	self.ms3gl.fire_mode_data.fire_rate = 60 / 90
	self.ms3gl.timers.equip = 0.75
	self.ms3gl.stats_modifiers = { damage = 10 }
	self.ms3gl.FIRE_MODE = "single"
	self.ms3gl.CAN_TOGGLE_FIREMODE = false

	-- Piglet
	self.m32.CLIP_AMMO_MAX = 6
	self.m32.stats.damage = 24
	self.m32.stats.spread = 20
	self.m32.stats.recoil = 22
	self.m32.stats.concealment = 16
	self.m32.fire_mode_data.fire_rate = 60 / 100
	self.m32.fire_rate_multiplier = 120 / 100
	self.m32.reload_speed_multiplier = 1.6
	self.m32.stats_modifiers = { damage = 10 }

	-- Arbiter
	self.arbiter.use_data.selection_index = 2
	self.arbiter.CLIP_AMMO_MAX = 5
	self.arbiter.stats.damage = 24
	self.arbiter.stats.spread = 24
	self.arbiter.stats.recoil = 10
	self.arbiter.stats.concealment = 20
	self.arbiter.fire_mode_data.fire_rate = 60 / 80
	self.arbiter.fire_rate_multiplier = 90 / 80
	self.arbiter.stats_modifiers = { damage = 10 }

	-- China Puff
	self.china.use_data.selection_index = 2
	self.china.CLIP_AMMO_MAX = 3
	self.china.stats.damage = 30
	self.china.stats.spread = 22
	self.china.stats.recoil = 20
	self.china.stats.concealment = 15
	self.china.fire_mode_data.fire_rate = 60 / 50
	self.china.stats_modifiers = { damage = 10 }

	-- GL40
	self.gre_m79.use_data.selection_index = 1
	self.gre_m79.CLIP_AMMO_MAX = 1
	self.gre_m79.stats.damage = 36
	self.gre_m79.stats.spread = 24
	self.gre_m79.stats.recoil = 20
	self.gre_m79.stats.concealment = 22
	self.gre_m79.fire_mode_data.fire_rate = 60 / 60
	self.gre_m79.stats_modifiers = { damage = 10 }
	
	-- Compact 40
	self.slap.CLIP_AMMO_MAX = 1
	self.slap.stats.damage = 36
	self.slap.stats.spread = 22
	self.slap.stats.recoil = 22
	self.slap.stats.concealment = 24
	self.slap.fire_mode_data.fire_rate = 60 / 60
	self.slap.stats_modifiers = { damage = 10 }
	self.slap.timers.reload_not_empty = 3.1
	self.slap.timers.reload_empty = self.slap.timers.reload_not_empty
	self.slap.reload_speed_multiplier = 1.15
	
	-- Rocket Launchers
	local rocket_launcher_category = {
		"heavy",
		"grenade_launcher",
	}
	
	-- Commando 101
	self.ray.use_data.selection_index = 2
	self.ray.categories = rocket_launcher_category
	self.ray.CLIP_AMMO_MAX = 4
	self.ray.stats.damage = 48
	self.ray.stats.spread = 24
	self.ray.stats.recoil = 24
	self.ray.stats.concealment = 4
	self.ray.fire_mode_data.fire_rate = 60 / 60
	self.ray.stats_modifiers = { damage = 50 }

	self._init_stat_overrides.ray = function()
		self.ray._pickup_mul = 0
		self.ray._min_clips_max = 1
	end

	-- RPG
	self.rpg7.categories = rocket_launcher_category
	self.rpg7.CLIP_AMMO_MAX = 1
	self.rpg7.stats.damage = 96
	self.rpg7.stats.spread = 24
	self.rpg7.stats.recoil = 24
	self.rpg7.stats.concealment = 4
	self.rpg7.fire_mode_data.fire_rate = 60 / 30
	self.rpg7.stats_modifiers = { damage = 50 }

	self._init_stat_overrides.rpg7 = function()
		self.rpg7._pickup_mul = 0
		self.rpg7._min_clips_max = 2
	end

	self.flun.CLIP_AMMO_MAX = 1
	self.flun.stats.damage = 24
	self.flun.stats.spread = 14
	self.flun.stats.recoil = 18
	self.flun.stats.concealment = 27
	self.flun.fire_mode_data.fire_rate = 60 / 22

	self._init_stat_overrides.flun = function()
		self.flun._total_ammo_mul = (1 / self.flun.rays) * 1.25
		self.flun._pickup_mul = (1 / self.flun.rays) * 1.33
		self.flun._clips_max_round = 2
	end

	-- Flamethrowers

	-- MK2
	self.flamethrower_mk2.CLIP_AMMO_MAX = 150
	self.flamethrower_mk2.stats.damage = 6
	self.flamethrower_mk2.stats.spread = 0
	self.flamethrower_mk2.stats.recoil = 0
	self.flamethrower_mk2.stats.concealment = 16
	self.flamethrower_mk2.fire_mode_data.fire_rate = 60 / 2000
	self.flamethrower_mk2.flame_max_range = 1000
	self.flamethrower_mk2.dot_data_name = "weapon_flamethrower_mk2"
	self.flamethrower_mk2.has_description = true
	self.flamethrower_mk2.desc_id = "bm_w_ray_desc"

	-- MA-17
	self.system.CLIP_AMMO_MAX = 100
	self.system.stats.damage = 6
	self.system.stats.spread = 0
	self.system.stats.recoil = 0
	self.system.stats.concealment = 20
	self.system.fire_mode_data.fire_rate = 60 / 2000
	self.system.flame_max_range = 1000
	self.system.dot_data_name = "weapon_system"
	self.system.has_description = true
	self.system.desc_id = "bm_w_ray_desc"

	-- Cashblaster
	self.money.use_data.selection_index = 2
	self.money.CLIP_AMMO_MAX = 100
	self.money.stats.damage = 8
	self.money.stats.spread = 0
	self.money.stats.recoil = 0
	self.money.stats.concealment = 20
	self.money.fire_mode_data.fire_rate = 60 / 1200
	self.money.flame_max_range = 1300
	self.money.dot_data_name = "weapon_money"
	self.money.has_description = true
	self.money.desc_id = "bm_w_ray_desc"

	-- OVE9000 Saw
	self.saw.CLIP_AMMO_MAX = 100
	self.saw.stats.damage = 30
	self.saw.stats.spread = 3
	self.saw.stats.recoil = 7
	self.saw.stats.concealment = 20
	self.saw.fire_mode_data.fire_rate = 60 / 400

	self.saw_secondary = deep_clone(self.saw)
	self.saw_secondary.use_data.selection_index = 1
	self.saw_secondary.parent_weapon_id = "saw"
	self.saw_secondary.animations.reload_name_id = "saw"
	self.saw_secondary.use_stance = "saw"
	self.saw_secondary.texture_name = "saw"
	self.saw_secondary.weapon_hold = "saw"

	-- Miniguns
	
	-- Hailstorm
	self.hailstorm.CLIP_AMMO_MAX = 120
	self.hailstorm.stats.damage = 16
	self.hailstorm.stats.spread = 14
	self.hailstorm.stats.recoil = 11
	self.hailstorm.stats.concealment = 12
	self.hailstorm.fire_mode_data.fire_rate = 60 / 2000
	self.hailstorm.fire_mode_data.volley.damage_mul = 1
	self.hailstorm.fire_mode_data.volley.ammo_usage = 30
	self.hailstorm.fire_mode_data.volley.rays = 15
	self.hailstorm.fire_mode_data.volley.spread_mul = nil
	self.hailstorm.fire_mode_data.volley.can_shoot_through_wall = true
	self.hailstorm.kick.volley.standing = { 3.9, 4, -0.5, 0.5 }
	self.hailstorm.has_description = true
	self.hailstorm.desc_id = "bm_w_ray_desc"

	self._init_stat_overrides.hailstorm = function()
		self.hailstorm.steelsight_enter_time = 0.3
		self.hailstorm.stats.alert_size = 6
		self.hailstorm.stats.suppression = 12
		self.hailstorm.spread = {
			standing = 4,
			crouching = 3,
			steelsight = 1.5,
			moving_standing = 5,
			moving_crouching = 4,
			moving_steelsight = 1.5,
		}
		self.hailstorm.kick = {
			standing = { 0.4, 0.5, -0.7, 0.7 },
			crouching = { 0.3, 0.4, -0.6, 0.6 },
			steelsight = { 0.2, 0.3, -0.5, 0.5 },
			moving_standing = { 0.5, 0.7, -0.8, 0.8 },
			moving_crouching = { 0.5, 0.7, -0.8, 0.8 },
			moving_steelsight = { 0.4, 0.5, -0.6, 0.6 },
		}
		self.hailstorm._total_ammo_mul = 1
		self.hailstorm.shake.fire_multiplier = 0.8
	end

	-- Microgun
	self.shuno.CLIP_AMMO_MAX = 750
	self.shuno.stats.damage = 12
	self.shuno.stats.spread = 7
	self.shuno.stats.recoil = 9
	self.shuno.stats.concealment = 6
	self.shuno.fire_mode_data.fire_rate = 60 / 3000
	self.shuno.has_description = true
	self.shuno.desc_id = "bm_w_ray_desc"

	-- Minigun
	self.m134.CLIP_AMMO_MAX = 500
	self.m134.stats.damage = 18
	self.m134.stats.spread = 9
	self.m134.stats.recoil = 7
	self.m134.stats.concealment = 6
	self.m134.fire_mode_data.fire_rate = 60 / 2000
	self.m134.exit_run_time = 0.8
	self.m134.exit_run_speed_multiplier = 2
	self.m134.has_description = true
	self.m134.desc_id = "bm_w_ray_desc"
	
	-- Midland Ranch Turret
	self.ranc_heavy_machine_gun.CLIP_AMMO_MAX = 200
	self.ranc_heavy_machine_gun.stats.damage = 96
	self.ranc_heavy_machine_gun.stats.spread = 22
	self.ranc_heavy_machine_gun.stats.recoil = 22
	self.ranc_heavy_machine_gun.stats.concealment = 20
	self.ranc_heavy_machine_gun.fire_mode_data.fire_rate = 60 / 400
	self.ranc_heavy_machine_gun.stats_modifiers = nil

	self.weapon_settings = {}
	self.weapon_settings.no_autoreload = true

	-- Set up all the wepaon overrides before executing the _init_stats function

	-- FOR CUSTOM WEAPON SUPPORT: Make sure to always run your function at the end of the hook to recalculate ammo values and apply overrides to specific weapons!
	self:_init_weapons(self._init_stat_overrides)
	self:_wipe_akimbo()
	self:_set_muzzleflashes()
	self:_set_trail_effects()
end)


local function copy_data(weapon, stats, cosmetics)
	weapon = weapon or {}
	for k, v in pairs(stats) do
		weapon[k] = type(v) == "table" and deep_clone(v) or v
	end
	weapon.categories = clone(cosmetics.categories)
	weapon.sounds.prefix = cosmetics.sounds.prefix
	weapon.muzzleflash = cosmetics.muzzleflash
	weapon.muzzleflash_silenced = cosmetics.muzzleflash_silenced
	weapon.shell_ejection = cosmetics.shell_ejection
	weapon.hold = cosmetics.hold
	weapon.reload = cosmetics.reload
	weapon.anim_usage = cosmetics.anim_usage or cosmetics.usage
	return weapon
end

Hooks:PostHook(WeaponTweakData, "init", "eclipse_init_npcweapons", function(self)
	self.g36_npc = copy_data(self.g36_npc, self.m4_npc, self.g36_crew)

	self.scar_npc = copy_data(self.scar_npc, self.m4_npc, self.scar_crew)

	self.ak47_ass_npc = copy_data(self.ak47_ass_npc, self.m4_npc, self.ak47_crew)

	self.beretta92_npc.has_suppressor = "suppressed_b"

	self.uspsil_npc = copy_data(self.uspsil_npc, self.c45_npc, self.usp_crew)
	self.uspsil_npc.has_suppressor = "suppressed_b"

	self.pmm_npc = copy_data(self.pmm_npc, self.c45_npc, self.pmm_crew)

	self.pmmsil_npc = copy_data(self.pmmsil_npc, self.c45_npc, self.pmm_crew)
	self.pmmsil_npc.has_suppressor = "suppressed_b"

	self.deagle_npc.CLIP_AMMO_MAX = 7
	self.deagle_npc.usage = "is_revolver"
	self.deagle_npc.anim_usage = "is_pistol"

	self.ump_npc = copy_data(self.ump_npc, self.mp5_npc, self.schakal_crew)
	self.shepheard_npc = copy_data(self.shepheard_npc, self.mp5_npc, self.shepheard_crew)
	self.vityaz_npc = copy_data(self.vityaz_npc, self.mp5_npc, self.vityaz_crew)
	self.akmsu_smg_npc = copy_data(self.akmsu_smg_npc, self.mp5_npc, self.akmsu_crew)
	self.akmsu_smg_npc.has_suppressor = nil

	self.asval_smg_npc = copy_data(self.asval_smg_npc, self.mp5_tactical_npc, self.asval_crew)
	self.asval_smg_npc.has_suppressor = "suppressed_a"

	self.mac11_npc.sounds.prefix = self.mac10_crew.sounds.prefix

	self.sr2_smg_npc.sounds.prefix = self.sr2_crew.sounds.prefix

	self.r870_yellow_npc = deep_clone(self.r870_npc)

	self.benelli_npc = copy_data(self.benelli_npc, self.r870_npc, self.ben_crew)

	self.mossberg_npc.usage = "is_double_barrel"
	self.mossberg_npc.reload = "looped"
	self.mossberg_npc.looped_reload_single = true

	self.aa12_npc = copy_data(self.aa12_npc, self.saiga_npc, self.aa12_crew)

	self.sko12_conc_npc = copy_data(self.sko12_conc_npc, self.saiga_npc, self.sko12_crew)
	self.sko12_conc_npc.bullet_class = nil
	self.sko12_conc_npc.concussion_data = nil

	self.rpk_lmg_npc = copy_data(self.rpk_lmg_npc, self.m249_npc, self.rpk_crew)

	self.m14_npc.sounds.prefix = self.heavy_snp_npc.sounds.prefix
	self.m14_npc.usage = "is_sniper"
	self.m14_npc.trail = "effects/particles/weapons/sniper_trail"
	self.m14_npc.CLIP_AMMO_MAX = 10

	self.dmr_npc.sounds.prefix = self.heavy_snp_npc.sounds.prefix
	self.dmr_npc.usage = "is_sniper"
	self.dmr_npc.trail = "effects/particles/weapons/sniper_trail"
	self.dmr_npc.CLIP_AMMO_MAX = 10

	self.heavy_snp_npc.usage = "is_sniper"
	self.heavy_snp_npc.trail = "effects/particles/weapons/sniper_trail"
	self.heavy_snp_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_sniper"

	self.m14_sniper_npc.usage = "is_sniper"
	self.m14_sniper_npc.trail = "effects/particles/weapons/sniper_trail"
	self.m14_sniper_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_sniper"

	self.svd_snp_npc.usage = "is_sniper"
	self.svd_snp_npc.trail = "effects/particles/weapons/sniper_trail"
	self.svd_snp_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_sniper"

	self.svdsil_snp_npc.usage = "is_sniper"
	self.svdsil_snp_npc.trail = "effects/particles/weapons/sniper_trail"
	self.svdsil_snp_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_sniper"

	self.famas_crew.hold = "rifle"
	self.famas_crew.reload = "bullpup"
	self.vhs_crew.hold = "rifle"
	self.vhs_crew.reload = "bullpup"
	self.komodo_crew.hold = "rifle"
	self.komodo_crew.reload = "bullpup"
	self.contender_crew.reload = "looped"
	self.hailstorm_crew.looped_reload_single = true
	self.hailstorm_crew.reload = "looped"
	self.p90_crew.looped_reload_single = true
	self.sterling_crew.looped_reload_single = true
	self.sterling_crew.reload = "looped"
	self.tkb_crew.reload = "bullpup"
end)

Hooks:PostHook(WeaponTweakData, "_init_data_npc_melee", "eclipse_init_data_npc_melee", function(self)
	self.npc_melee.hw_sword = deep_clone(self.npc_melee.helloween)
	self.npc_melee.hw_sword.unit_name = Idstring("units/pd2_halloween/weapons/wpn_mel_titan_sword/wpn_mel_titan_sword")
	self.npc_melee.hw_sword.animation_param = "melee_great"
end)

local get_difficulty_specific_value = Eclipse.utils.get_difficulty_specific_value

local turret_suppression_mul= 0.2
local turret_damage_mul = {
	{ 0, 2 },
	{ 1500, 1.5 },
	{ 3000, 1 },
	{ 10000, 0 },
}
local alert_sizes = {
	is_sniper = 10000,
	is_lmg = 6000,
	mini = 6000,
	is_smg = 3000,
	is_pistol = 2500,
}
local crew_weapon_mapping = {
	ak47 = "ak74",
	ak47_ass = "ak74",
	ben = "benelli",
	beretta92 = "b92fs",
	c45 = "glock_17",
	g17 = "glock_17",
	glock_18 = "glock_18c",
	m14 = "new_m14",
	m4 = "new_m4",
	mossberg = "huntsman",
	mp5 = "new_mp5",
	raging_bull = "new_raging_bull",
	x_c45 = "x_g17",
}

function WeaponTweakData:_set_presets()
	local crew_presets = self.tweak_data.character.presets.weapon.gang_member
	for k, v in pairs(self) do
		if k:match("_turret_module") then
			v.DAMAGE = 1
			v.DAMAGE_MUL_RANGE = turret_damage_mul
			v.SUPPRESSION = turret_suppression_mul -- 2 suppression values?
			v.suppression = turret_suppression_mul
			v.HEALTH_INIT = get_difficulty_specific_value({
				200,
				200,
				300,
				400,
				500,
			})
			v.SHIELD_HEALTH_INIT = get_difficulty_specific_value({
				40,
				40,
				50,
				60,
				80,
			})
			v.CLIP_SIZE = get_difficulty_specific_value({
				300,
				300,
				300,
				400,
				500,
			})
			v.BAG_DMG_MUL = 20
			v.SHIELD_DMG_MUL = 1
			v.FIRE_DMG_MUL = 1
			v.EXPLOSION_DMG_MUL = 5
			v.SHIELD_DAMAGE_CLAMP = nil
			v.BODY_DAMAGE_CLAMP = nil
		elseif k:match("_npc$") then
			v.DAMAGE = 1
			v.suppression = (v.armor_piercing and 5 or v.is_shotgun and 3 or 1) * (v.has_suppressor and 0.3 or 1)
			v.stamina_strip_mul = (v.armor_piercing and 2 or v.is_shotgun and 1.5 or 1) * (v.has_suppressor and 0.5 or 1)
			v.spread = v.rays and v.rays > 1 and 6 or 0
			v.alert_size = (alert_sizes[v.usage] or 5000) * (v.has_suppressor and 0.2 or 1)

			if v.muzzleflash then
				v.muzzleflash = self.WEAPON_MUZZLEFLASHES[k] or self.CATEGORY_MUZZLEFLASHES[self:_get_primary_category(k)] or v.muzzleflash
				v.muzzleflash_silenced = v.muzzleflash and self.SILENCED_MUZZLEFLASH_MAP[v.muzzleflash]
			end

			if v.usage == "is_smg" and not v.reload == "uzi" then
				v.auto = { fire_rate = 60 / 500 }
			elseif v.usage == "is_smg" and v.reload == "uzi" then
				v.auto = { fire_rate = 60 / 600 }
			elseif v.usage == "is_lmg" then
				v.auto = { fire_rate = 60 / 750 }
			elseif v.usage == "is_flamethrower" then
				v.auto = { fire_rate = 60 / 1200 }
			elseif v.usage == "mini" then
				v.auto = { fire_rate = 60 / 2000 }
			else
				v.auto = { fire_rate = 60 / 400 }
			end
		elseif k:match("_crew$") then
			local player_id = k:gsub("_crew$", ""):gsub("_secondary$", ""):gsub("_primary$", "")
			local player_weapon = crew_weapon_mapping[player_id] and self[crew_weapon_mapping[player_id]] or self[player_id]
			if player_weapon then
				v.use_data.selection_index = player_weapon.use_data and player_weapon.use_data.selection_index or v.use_data.selection_index
				v.suppression = 1
				v.CLIP_AMMO_MAX = player_weapon.CLIP_AMMO_MAX
				v.alert_size = self.stats.alert_size[player_weapon.stats.alert_size] or v.alert_size
				v.muzzleflash = player_weapon.muzzleflash
				v.shell_ejection = player_weapon.shell_ejection

				if player_weapon.trail_effect then
					v.trail_effect = player_weapon.trail_effect
				end

				if v.auto then
					v.auto = player_weapon.auto
				end

				local cat_map = table.list_to_set(player_weapon.categories)

				if player_weapon.auto then
					if cat_map.flamethrower then
						v.usage = "is_flamethrower"
					elseif cat_map.shotgun then
						v.usage = "is_shotgun_mag"
					elseif cat_map.pistol or cat_map.smg then
						v.usage = "is_smg"
					elseif cat_map.lmg then
						v.usage = "is_lmg"
					elseif cat_map.minigun then
						v.usage = "mini"
					elseif cat_map.dmr then
						v.usage = "is_dmr"
					else
						v.usage = "is_rifle"
					end
				else
					if cat_map.shotgun then
						if v.CLIP_AMMO_MAX == 2 then
							v.usage = "is_double_barrel"
						else
							v.usage = "is_shotgun_pump"
						end
					elseif cat_map.revolver then
						v.usage = "is_revolver"
					elseif cat_map.snp then
						v.usage = "is_sniper"
					else
						v.usage = "is_pistol"
					end
				end
			end

			if v.usage == "is_lmg" then
				v.anim_usage = v.anim_usage or "is_rifle"
			end

			if not v.old_usage and crew_presets[v.usage] then
				local usage = crew_presets[v.usage]
				local is_automatic = v.auto and usage.autofire_rounds
				local mag = v.CLIP_AMMO_MAX
				local burst = is_automatic and math.min(usage.autofire_rounds[2], mag) or 1
				local rate = is_automatic and v.auto.fire_rate or 0
				local recoil = (usage.FALLOFF[1].recoil[1] + usage.FALLOFF[1].recoil[2]) * 0.5

				v.DAMAGE = ((mag / burst) * (burst - 1) * rate + (mag / burst - 1) * recoil + 2) / mag
				v.FIRE_MODE = is_automatic and "auto" or "single"
			end
		end
	end
end

WeaponTweakData._set_easy = WeaponTweakData._set_presets
WeaponTweakData._set_normal = WeaponTweakData._set_presets
WeaponTweakData._set_hard = WeaponTweakData._set_presets
WeaponTweakData._set_overkill = WeaponTweakData._set_presets
WeaponTweakData._set_overkill_145 = WeaponTweakData._set_presets
WeaponTweakData._set_easy_wish = WeaponTweakData._set_presets
WeaponTweakData._set_overkill_290 = WeaponTweakData._set_presets
WeaponTweakData._set_sm_wish = WeaponTweakData._set_presets