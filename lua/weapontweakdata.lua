WeaponTweakData.WEAPON_TOTAL_DMG = 360
WeaponTweakData.WEAPON_PICKUP_DMG = 16

Hooks:PostHook(WeaponTweakData, "_init_stats", "eclipse_init_stats", function(self)
	self.stats.damage = {}
	for i = 0, 1200, 1 do
		table.insert(self.stats.damage, (math.lerp(0.1, 120.1, i / 1200)))
	end

	self.stats.recoil = {}
	for i = 0, 25, 1 do
		table.insert(self.stats.recoil, (math.lerp(3, 0.5, i / 25)))
	end

	self.stats.spread = {}
	for i = 0, 25, 1 do
		table.insert(self.stats.spread, (math.lerp(2, 0.2, i / 25)))
	end

	self.stats.spread_moving = {}
	for i = 0, 25, 1 do
		table.insert(self.stats.spread_moving, (math.lerp(2, 0.2, i / 25)))
	end

	self.stats.suppression = {}
	for i = 4.2, 0.199, -0.2 do
		table.insert(self.stats.suppression, i)
	end
end)

local steelsight_times = {
	default = 0.25,
	pistol = 0.15,
	pistol_heavy = 0.2,
	smg = 0.2,
	lmg_light = 0.3,
	dmr = 0.3,
	snp = 0.3,
	snp_heavy = 0.4,
	lmg = 0.4,
}

function WeaponTweakData:_init_weapons()
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
			local category_blacklist = {
				["car9"] = true,
				["ak5s"] = true,
				["scar16"] = true,
				["or12"] = true,
			}
			
			if based_on_id and is_unsupported_custom then
				if not category_blacklist[weap_id] then
					weap_data.categories = clone(based_on_data.categories)
				end
				
				if based_on_data.use_shotgun_reload then
					weap_data.use_shotgun_reload = true
				end
			end

			local cat_map = table.list_to_set(weap_data.categories)
			local dmg_mul = based_on_data and based_on_data.stats_modifiers and based_on_data.stats_modifiers.damage or weap_data.stats_modifiers and  weap_data.stats_modifiers.damage or 1
			
			local is_primary = weap_data.use_data and weap_data.use_data.selection_index == 2
			local is_secondary = weap_data.use_data and weap_data.use_data.selection_index == 1
			local is_underbarrel = not is_primary and not is_secondary
			local has_bipod = weap_data.timers and weap_data.timers.deploy_bipod

			-- Some weapon-specific checks, would rather handle them in this function
			local is_doublebarrel = cat_map.shotgun and weap_data.CLIP_AMMO_MAX == 2
			local is_browning_mg = based_on_id == "ranc_heavy_machine_gun" or weap_id == "ranc_heavy_machine_gun"
			local is_deagle = based_on_id == "deagle" or weap_id == "deagle"
			local is_judge = based_on_id == "judge" or weap_id == "judge"
			local is_thanatos = based_on_id == "m95" or weap_id == "m95"
			local is_hailstorm = based_on_id == "hailstorm" or weap_id == "hailstorm"
			local is_cavity = based_on_id == "sub2000" or weap_id == "sub2000"

			--catch-all stat setups
			if cat_map.assault_rifle and not is_browning_mg then
				weap_data.stats.suppression = cat_map.dmr and 6 or 11
				weap_data.stats.alert_size = cat_map.dmr and 6 or 7
				weap_data.steelsight_time = cat_map.dmr and steelsight_times.dmr or steelsight_times.default
				weap_data.pickup_mul = weap_data.pickup_mul or cat_map.dmr and 0.8 or 1
				weap_data.steelsight_move_speed_mul = 0.5
				weap_data.shake.fire_multiplier = cat_map.dmr and 1.2 or 1

				if cat_map.dmr then
					weap_data.FIRE_MODE = "single"
					weap_data.stance_multipliers = {
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
					weap_data.fire_mode_multipliers = {}
				else
					weap_data.stance_multipliers = {
						spread = {
							standing = {
								hipfire = 1.2,
								crouching = 0.8,
								steelsight = 0.6,
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
					weap_data.fire_mode_multipliers = {
						single = {
							recoil = 1.2,
							spread = 0.4,
						},
						burst = {
							recoil = 0.8,
							spread = 1,
						},
					}
				end
			elseif cat_map.pistol then
				weap_data.stats.suppression = is_deagle and 7 or 16
				weap_data.stats.alert_size = is_deagle and 7 or 9
				weap_data.steelsight_time = is_deagle and steelsight_times.pistol_heavy or steelsight_times.pistol
				weap_data.total_ammo_mul = weap_data.total_ammo_mul or not is_deagle and 1.5 or 1
				weap_data.steelsight_move_speed_mul = is_deagle and 0.6 or 0.7
				weap_data.shake.fire_multiplier = is_deagle and 1.3 or 0.8

				if is_deagle then
					weap_data.stance_multipliers = {
						spread = {
							standing = {
								hipfire = 1.5,
								crouching = 1,
								steelsight = 0.7,
							},
							moving = {
								hipfire = 2,
								crouching = 1,
								steelsight = 1.5,
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
				else
					weap_data.stance_multipliers = {
						spread = {
							standing = {
								hipfire = 1,
								crouching = 1,
								steelsight = 0.7,
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
								steelsight = 0.7,
							},
							moving = {
								hipfire = 1.2,
								crouching = 1,
								steelsight = 1,
							},
						},
					}
					
					if weap_data.fire_mode_data and not weap_data.CAN_TOGGLE_FIREMODE then
						weap_data.fire_mode_data.fire_rate = 60 / 675
					end
				end

			elseif cat_map.revolver then
				weap_data.stats.suppression = 7
				weap_data.stats.alert_size = 7
				weap_data.steelsight_time = steelsight_times.pistol_heavy
				weap_data.steelsight_move_speed_mul = 0.6
				weap_data.shake.fire_multiplier = 1.3

				if weap_data.fire_mode_data and not weap_data.auto then
					weap_data.fire_mode_data.fire_rate = 60 / 300
				end

				weap_data.stance_multipliers = {
					spread = {
						standing = {
							hipfire = 1.5,
							crouching = 0.8,
							steelsight = 0.6,
						},
						moving = {
							hipfire = 2,
							crouching = 1,
							steelsight = 1.5,
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

			elseif cat_map.smg then
				weap_data.stats.suppression = 16
				weap_data.stats.alert_size = 8
				weap_data.steelsight_time = steelsight_times.smg
				weap_data.total_ammo_mul = weap_data.total_ammo_mul or 1.25
				weap_data.steelsight_move_speed_mul = 0.6
				weap_data.shake.fire_multiplier = 0.7

				if is_cavity then
					weap_data.stance_multipliers = {
						spread = {
							standing = {
								hipfire = 1.2,
								crouching = 1,
								steelsight = 0.6,
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
				else
					weap_data.stance_multipliers = {
						spread = {
							standing = {
								hipfire = 1,
								crouching = 1,
								steelsight = 0.7,
							},
							moving = {
								hipfire = 1.2,
								crouching = 1,
								steelsight = 0.8,
							},
						},
						recoil = {
							standing = {
								hipfire = 1,
								crouching = 1,
								steelsight = 1
							},
							moving = {
								hipfire = 1,
								crouching = 1,
								steelsight = 1,
							},
						},
					}
				end
				
				if not is_cavity then
					weap_data.fire_mode_multipliers = {
						single = {
							recoil = 1.2,
							spread = 0.6,
						},
						burst = {
							recoil = 0.8,
							spread = 1,
						},
					}
				end
				
			elseif cat_map.shotgun then
				weap_data.stats.suppression = 5
				weap_data.stats.alert_size = 6
				weap_data.steelsight_time = weap_data.steelsight_time or is_judge and steelsight_times.pistol_heavy or steelsight_times.default
				weap_data.total_ammo_mul = weap_data.total_ammo_mul or (30 / 180)
				weap_data.pickup_mul = weap_data.pickup_mul or 1 / 6
				weap_data.steelsight_move_speed_mul = is_judge and 0.6 or 0.5
				weap_data.damage_near = is_judge and 1000 or is_doublebarrel and 2000 or 1500
				weap_data.damage_far = is_judge and 2000 or is_doublebarrel and 3000 or 2500
				weap_data.shake.fire_multiplier = (is_doublebarrel or is_judge) and 2 or 1.5
				weap_data.muzzleflash = weap_data.rays and "effects/particles/weapons/sho_default" or weap_data.muzzleflash
				weap_data.rays = weap_data.rays and 8 or nil

				weap_data.stance_multipliers = {
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

			elseif cat_map.lmg then
				weap_data.stats.suppression = 3
				weap_data.stats.alert_size = 6
				weap_data.steelsight_time = steelsight_times.lmg
				weap_data.total_ammo_mul = weap_data.total_ammo_mul or not has_bipod and (4 / 3) or (7 / 4)
				weap_data.steelsight_move_speed_mul = 0.4
				weap_data.bipod_camera_spin_limit = 40
				weap_data.bipod_camera_pitch_limit = 15
				weap_data.bipod_deploy_multiplier = 1
				weap_data.shake.fire_multiplier = 0.8
				
				-- Reduce unsupported custom LMG accuracy
				if is_unsupported_custom then
					weap_data.stats.spread = math.clamp(weap_data.stats.spread - 3, 0, #self.stats.spread)
				end
				
				if has_bipod then
					weap_data.stance_multipliers = {
						spread = {
							standing = {
								hipfire = 1,
								crouching = 0.8,
								steelsight = 0.8,
							},
							moving = {
								hipfire = 1.5,
								crouching = 1,
								steelsight = 1.3,
							},
							bipod = 0.5,
						},
						recoil = {
							standing = {
								hipfire = 1,
								crouching = 0.8,
								steelsight = 1,
							},
							moving = {
								hipfire = 1.5,
								crouching = 1,
								steelsight = 1.3,
							},
						},
					}
				else
					weap_data.stance_multipliers = {
						spread = {
							standing = {
								hipfire = 1.2,
								crouching = 0.8,
								steelsight = 0.7,
							},
							moving = {
								hipfire = 1.4,
								crouching = 1,
								steelsight = 1.2,
							},
						},
						recoil = {
							standing = {
								hipfire = 1.2,
								crouching = 0.8,
								steelsight = 0.8,
							},
							moving = {
								hipfire = 1.5,
								crouching = 1,
								steelsight = 1.3,
							},
						},
					}
				end
			elseif cat_map.minigun then
				weap_data.stats.suppression = is_hailstorm and 12 or 4
				weap_data.stats.alert_size = 6
				weap_data.steelsight_time = steelsight_times.lmg
				weap_data.total_ammo_mul = weap_data.total_ammo_mul or is_hailstorm and 3 or 2.25
				weap_data.pickup_mul = weap_data.pickup_mul or 0
				weap_data.steelsight_move_speed_mul = 0.4
				weap_data.shake.fire_multiplier = is_hailstorm and 1 or 1.5

				if not is_hailstorm then
					weap_data.stance_multipliers = {
						spread = {
							standing = {
								hipfire = 1,
								crouching = 1,
								steelsight = 0.8,
							},
							moving = {
								hipfire = 1.4,
								crouching = 1,
								steelsight = 1.2,
							},
						},
						recoil = {
							standing = {
								hipfire = 1,
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
				else
					weap_data.stance_multipliers = {
						spread = {
							standing = {
								hipfire = 1.2,
								crouching = 1,
								steelsight = 0.7,
							},
							moving = {
								hipfire = 1.5,
								crouching = 1,
								steelsight = 1.3,
							},
						},
						recoil = {
							standing = {
								hipfire = 1.2,
								crouching = 1,
								steelsight = 0.8,
							},
							moving = {
								hipfire = 1.5,
								crouching = 1,
								steelsight = 1.3,
							},
						},
					}
				end
			elseif cat_map.snp then
				weap_data.stats.suppression = 4
				weap_data.stats.alert_size = 4
				weap_data.steelsight_time = steelsight_times.snp
				weap_data.steelsight_move_speed_mul = 0.45
				weap_data.shake.fire_multiplier = is_thanatos and 2 or 1.6

				-- Increase Sniper Rifle ammo based on damage
				local snp_ammo_mul = math.clamp(math.max(dmg_mul - 2, 0), 0, 6)

				weap_data.total_ammo_mul = weap_data.total_ammo_mul or (0.7 + (snp_ammo_mul * 0.2))
				weap_data.pickup_mul = weap_data.pickup_mul or (1 + (snp_ammo_mul * 0.125))

				weap_data.stance_multipliers = {
					spread = {
						standing = {
							hipfire = 2,
							crouching = 0.8,
							steelsight = 0.2,
						},
						moving = {
							hipfire = 4,
							crouching = 1,
							steelsight = 2,
						},
					},
					recoil = {
						standing = {
							hipfire = 1.2,
							crouching = 1,
							steelsight = 0.8,
						},
						moving = {
							hipfire = 1.4,
							crouching = 1,
							steelsight = 1.2,
						},
					},
				}
			elseif cat_map.bow then
				weap_data.stats.suppression = 2
				weap_data.stats.alert_size = 7
				weap_data.armor_piercing_chance = 1
				weap_data.reload_speed_multiplier = 2
				weap_data.shake.fire_multiplier = 0.3

				local bow_ammo_mul = math.clamp(math.max(dmg_mul - 2, 0), 0, 4)

				weap_data.total_ammo_mul = weap_data.total_ammo_mul or (1 + (bow_ammo_mul * 0.25))

				weap_data.bow_reload_speed_multiplier = nil

				weap_data.spread_multiplier = nil
				weap_data.recoil_multiplier = nil

				if weap_data.charge_data and weap_data.charge_data.max_t then
					weap_data.charge_data.max_t = weap_data.charge_data.max_t * 0.5
				end
			elseif cat_map.crossbow then
				weap_data.stats.suppression = 14
				weap_data.stats.alert_size = 1
				weap_data.armor_piercing_chance = 1
				weap_data.shake.fire_multiplier = 0.3

				local crossbow_ammo_mul = math.clamp(math.max(dmg_mul - 2, 0), 0, 4)

				weap_data.total_ammo_mul = weap_data.total_ammo_mul or (1 + (crossbow_ammo_mul * 0.25))

				weap_data.spread_multiplier = nil
				weap_data.recoil_multiplier = nil
			elseif cat_map.grenade_launcher then
				weap_data.stats.suppression = 2
				weap_data.stats.alert_size = 6
				weap_data.total_ammo_mul = weap_data.total_ammo_mul or 2 / 3
				weap_data.pickup_mul = weap_data.pickup_mul or is_primary and 1 / 2.5 or 1 / 5
				weap_data.damage_near = 1000
				weap_data.damage_far = 2000
				weap_data.rays = 12
				weap_data.shake.fire_multiplier = 0.5

				weap_data.explosive_ammo = true

				weap_data.stance_multipliers = {
					spread = {
						standing = {
							hipfire = 5,
							crouching = 1,
							steelsight = 1,
						},
						moving = {
							hipfire = 10,
							crouching = 1,
							steelsight = 5,
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
			elseif cat_map.flamethrower then
				weap_data.stats.suppression = 2
				weap_data.stats.alert_size = 6
				weap_data.total_ammo_mul = weap_data.total_ammo_mul or 2.5
				weap_data.pickup_mul = weap_data.pickup_mul or 0
				weap_data.shake.fire_multiplier = 0.5

				weap_data.spread_multiplier = nil
				weap_data.recoil_multiplier = nil
			elseif cat_map.saw then
				weap_data.stats.suppression = 7
				weap_data.stats.alert_size = 9
				weap_data.total_ammo_mul = weap_data.total_ammo_mul or 2
				weap_data.shake.fire_multiplier = 1
				weap_data.armor_piercing_chance = 1
				weap_data.hit_alert_size_increase = 4

				weap_data.stance_multipliers = {
					spread = {
						standing = {
							hipfire = 1,
							crouching = 1,
							steelsight = 1,
						},
						moving = {
							hipfire = 1,
							crouching = 1,
							steelsight = 1,
						},
					},
					recoil = {
						standing = {
							hipfire = 1,
							crouching = 1,
							steelsight = 0.7,
						},
						moving = {
							hipfire = 1,
							crouching = 1,
							steelsight = 1,
						},
					},
				}
			elseif is_browning_mg then -- Yes, I had to bullshit it like this
				weap_data.stats.suppression = 3
				weap_data.stats.alert_size = 4
				weap_data.shake.fire_multiplier = 1

				weap_data.spread_multiplier = nil
				weap_data.recoil_multiplier = nil
			end

			local is_akimbo = cat_map.akimbo

			if is_akimbo then
				local single_weapon_data = self[akimbo_single_map[weap_id]] or self[weap_id:sub(3)]

				if single_weapon_data then
					local akimbo_reload = weap_data.timers.reload_empty
					local single_reload = single_weapon_data.timers.reload_empty

					weap_data.CLIP_AMMO_MAX = single_weapon_data.CLIP_AMMO_MAX * 2
					weap_data.stats = clone(single_weapon_data.stats)
					weap_data.stats.suppression = math.max(single_weapon_data.stats.suppression - 4, 0)
					weap_data.stats.concealment = weap_data.stats.concealment - 4
					weap_data.reload_speed_multiplier = (akimbo_reload / single_reload) * (2 / 3)

					weap_data.total_ammo_mul = 1.25
					weap_data.pickup_mul = nil

					weap_data.steelsight_time = steelsight_times.default
					weap_data.steelsight_move_speed_mul = 0.6
					weap_data.shake.fire_multiplier = (weap_data.shake.fire_multiplier or 1) * 1.25
	
					if not weap_data.rays then
						weap_data.stance_multipliers.spread = {
							standing = {
								hipfire = 1.2,
								crouching = 1,
								steelsight = 0.8,
							},
							moving = {
								hipfire = 1.4,
								crouching = 1,
								steelsight = 1.4,
							},
						}
					else
						weap_data.spread_multiplier = {
							standing = {
								hipfire = 1,
								crouching = 1,
								steelsight = 1,
							},
							moving = {
								hipfire = 1.2,
								crouching = 1,
								steelsight = 1.2,
							},
						}
					end

					weap_data.stance_multipliers.recoil = {
						standing = {
							hipfire = 1,
							crouching = 1,
							steelsight = 1,
						},
						moving = {
							hipfire = 1.3,
							crouching = 1,
							steelsight = 1.3,
						},
					}

					if weap_data.fire_mode_data then
						weap_data.fire_mode_data.fire_rate = weap_data.CAN_TOGGLE_FIREMODE and single_weapon_data.fire_mode_data.fire_rate or 60 / math.round((60 / single_weapon_data.fire_mode_data.fire_rate) * (2 / 3), 25)
					end
				end
			end

			-- Automatically adjust custom weapon damage
			if not is_akimbo then
				if weap_data.custom and not weap_data.no_damage_scaling then
					local damage_modifier = weap_data.stats_modifiers and weap_data.stats_modifiers.damage or 1
					local damage = math.min(weap_data.stats.damage, #self.stats.damage) * damage_modifier

					local is_shotgun = cat_map.shotgun

					if is_shotgun then
						damage = math.sqrt(damage) * 4
						damage = math.round(damage, 5)
					end

					damage = math.round(damage / 2.5, 2)
					damage = math.round(damage / damage_modifier)

					weap_data.stats.damage = damage
				end
			end

			weap_data.stats.alert_size = math.clamp(weap_data.stats.alert_size, 1, #self.stats.alert_size)
			weap_data.stats.zoom = 1
			weap_data.stats.reload = 11
			weap_data.panic_suppression_chance = 0.2
			weap_data.sprint_exit_time = weap_data.sprint_exit_time or 0.4
			weap_data.steelsight_time = weap_data.steelsight_time or steelsight_times.default
			weap_data.steelsight_move_speed_mul = weap_data.steelsight_move_speed_mul or 0.5
			weap_data.penetration_damage_mul = {
				surface = 0.5,
				enemy = 0.75,
				armor = 0.75,
			}
			weap_data.damage_falloff = nil
			weap_data.fire_mode_multipliers = weap_data.fire_mode_multipliers or {}

			if weap_data.damage_melee and weap_data.damage_melee_effect_mul then
				weap_data.damage_melee = 1
				weap_data.damage_melee_effect_mul = 1
			end

			if weap_data.kick then
				if is_browning_mg then
					weap_data.kick.standing =  { -0.1, 0.1, -0.1, 0.1 }

				elseif cat_map.lmg then
					weap_data.kick.standing = { -0.2, 0.8, -0.8, 1.4 }

				elseif is_hailstorm then
					weap_data.kick.standing = { 0.4, 0.6, -0.7, 0.7 }

				elseif cat_map.minigun then
					weap_data.kick.standing = { -0.1, 0.4, -0.3, 0.4 }

				elseif cat_map.smg then
					weap_data.kick.standing = { 0.6, 0.8, -1.2, 1.2 }

				elseif cat_map.assault_rifle then
					weap_data.kick.standing = { 0.8, 1, -1, 1 }

				elseif is_deagle or cat_map.revolver or cat_map.shotgun or cat_map.grenade_launcher then
					weap_data.kick.standing = { 2.8, 3, -0.5, 0.5 }

				elseif cat_map.snp then
					weap_data.kick.standing = { 3, 4, -0.1, 0.1 }

				elseif cat_map.saw then
					weap_data.kick.standing = { 1, -1, -1, 1 }

				elseif cat_map.bow or cat_map.crossbow then
					weap_data.kick.standing = { -0.2, 0.4, -1, 1 }

				elseif cat_map.flamethrower then
					weap_data.kick.standing = { 0, 0, 0, 0 }

				elseif cat_map.pistol and weap_data.auto then
					weap_data.kick.standing = { 0.5, 0.8, -0.6, 0.6 }

				elseif cat_map.pistol and not weap_data.auto then
					weap_data.kick.standing = { 1.2, 1.8, -0.5, 0.5 }

				end

				if is_akimbo then
					if weap_data.auto then
						weap_data.kick.standing = { 1.2, 0.9, -0.6, 0.6 }
					else
						weap_data.kick.standing = { 1.6, 1.4, -0.4, 0.4 }
					end
				end
					
				weap_data.kick.crouching = clone(weap_data.kick.standing)
				weap_data.kick.steelsight = clone(weap_data.kick.standing)
			end				
			
			local default_burst_cooldown = 0.25

			if weap_data.fire_mode_data then
				if weap_data.auto and  weap_data.fire_mode_data.fire_rate then
					weap_data.auto = { fire_rate = weap_data.fire_mode_data.fire_rate }
				end

				if weap_data.fire_mode_data.burst_cooldown then
					weap_data.fire_mode_data.burst_cooldown = default_burst_cooldown
				end
			end

			-- Set spread values
			if weap_data.spread then
				weap_data.spread.bipod = 69 -- Make sure bipod spread is defined

				for i, v in pairs(weap_data.spread) do
					weap_data.spread[i] = (cat_map.flamethrower or cat_map.saw) and 0 or 2.5
				end
			end

			-- Set total damage (translates to total ammo)
			weap_data.total_damage = self.WEAPON_TOTAL_DMG * (weap_data.total_ammo_mul or 1)
			
			-- Modify total damage based on weapon slot
			if is_primary then -- Primaries
				weap_data.total_damage = weap_data.total_damage
			elseif is_secondary then -- Secondaries
				weap_data.total_damage = weap_data.total_damage / 2
			else -- Underbarrels etc.
				weap_data.total_damage = weap_data.total_damage / 3
			end

			local burst_only = weap_data.FIRE_MODE == "burst" and not table.contains(weap_data.fire_mode_data.toggable, "auto")
			local burst_count = weap_data.BURST_COUNT or 3

			-- Higher total ammo for burst-only weapons
			if burst_only then
				local total_damage_mul = 1 + (burst_count * 0.125)
				weap_data.total_damage = weap_data.total_damage * total_damage_mul
			end

			-- AP weapons that aren't Sniper Rifles get reduced total ammo
			if weap_data.can_shoot_through_wall and not cat_map.snp then
				weap_data.total_damage = weap_data.total_damage / 2
			end

			-- Set pickup damage
			weap_data.pickup_damage = self.WEAPON_PICKUP_DMG * (weap_data.pickup_mul or 1)

			-- Higher pickup for burst-only weapons
			if burst_only then
				local total_damage_mul = 1 + (burst_count - 1) * 0.125
				weap_data.pickup_damage = weap_data.pickup_damage * total_damage_mul
			end

			-- AP weapons that aren't Sniper Rifles get reduced ammo pickup
			if weap_data.can_shoot_through_wall and not cat_map.snp then
				weap_data.pickup_damage = weap_data.pickup_damage / 2
			end

			local damage = self.stats.damage[math.min(weap_data.stats.damage, #self.stats.damage)] * (weap_data.stats_modifiers and weap_data.stats_modifiers.damage or 1)
			local clip_dmg = weap_data.CLIP_AMMO_MAX * damage

			if weap_data.AMMO_MAX then
				weap_data.NR_CLIPS_MAX = math.max(1, math.round(weap_data.total_damage / clip_dmg)) -- Round total ammo to magazine capacity

				if not cat_map.grenade_launcher then
					if weap_data.CLIP_AMMO_MAX <= 2 then
						weap_data.NR_CLIPS_MAX = math.round(weap_data.NR_CLIPS_MAX, 4)
					end
				end

				weap_data.AMMO_MAX = weap_data.CLIP_AMMO_MAX * weap_data.NR_CLIPS_MAX
			end

			if weap_data.AMMO_PICKUP and weap_data.AMMO_PICKUP[2] > 0 then
				local pickup_dmg_max = weap_data.pickup_damage
				local pickup_dmg_min = pickup_dmg_max / 2

				weap_data.AMMO_PICKUP = { math.round(math.floor(pickup_dmg_min / damage * 100) / 100, 0.05), math.round(math.floor(pickup_dmg_max / damage * 100) / 100, 0.05) }
			end
		end
	end
end

WeaponTweakData.akimbo_whitelist = {
	["jowi"] = true,
	["x_1911"] = true,
	["x_b92fs"] = true,
	["x_deagle"] = true,
	["x_g17"] = true,
	["x_g22c"] = true,
	["x_usp"] = true,
	["x_packrat"] = true,
	["x_chinchilla"] = true,
	["x_g18c"] = true,
	["x_judge"] = true,
	["x_sr2"] = true,
	["x_mp5"] = true,
	["x_mac10"] = true,
	["x_baka"] = true,
	["x_akmsu"] = true,
	["x_olympic"] = true,
	["x_model3"] = true,
}

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

	self.sentry_gun.DAMAGE = 1

	self.trip_mines.delay = 0.1

	-- Starbreeze didn't update the akimbo mappings for some of the Mcshay weapons, because of course they didn't.
	-- Update this table with any other weapons that might have the same issue
	local missing_akimbos = {
		sko12 = "x_sko12",
		korth = "x_korth",
	}

	self.akimbo_mappings = self:get_akimbo_mappings()

	for k, v in pairs(missing_akimbos) do
		self.akimbo_mappings[k] = v
	end

	-- spray pattern tables
	local spray_tables = {
		sg_auto = {
			pattern = {
				{ up = 3.5, down = 3.5, left = 0.5, right = 1 },
				{ up = 3.5, down = 3.5, left = -1, right = -0.5 },
				{ up = 2.5, down = 3, left = -1.8, right = -2 },
				{ up = 2.5, down = 2.5, left = -2.3, right = -2.5 },
				{ up = 1.75, down = 2, left = 1, right = 0.8 },
				{ up = 2, down = 2, left = 2, right = 2.5 },
				{ up = 1.5, down = 1.75, left = 2.5, right = 3 },
				{ up = 2, down = 2, left = 3, right = 3 },
			},
			persist_pattern = {
				{ up = 2, down = 3, left = -3, right = 1 },
			}
		},
		lmg_right = {
			pattern = {
				{ up = 0.3, down = 0.5, left = -0.8, right = 0.8 }
			},
			persist_pattern = {
				{ up = 0.1, down = 0.1, left = 0.6, right = 0.6 },
				{ up = 0.2, down = 0.3, left = 0.6, right = 0.6 },
				{ up = 0.3, down = 0.3, left = 0.4, right = 0.4 },
				{ up = 0.4, down = 0.4, left = 0.4, right = 0.4 },
				{ up = 0.4, down = 0.4, left = 0.4, right = 0.4 },
				{ up = 0.4, down = 0.5, left = 0.4, right = 0.4 },
				{ up = 0.5, down = 0.6, left = 0.3, right = 0.3 },
				{ up = 0.5, down = 0.6, left = 0.1, right = 0.2 },
				{ up = 0.3, down = 0.3, left = -0.1, right = -0.2 },
				{ up = 0.3, down = 0.3, left = -0.2, right = -0.6 },
				{ up = 0.4, down = 0.4, left = -0.6, right = -0.8 },
				{ up = 0.4, down = 0.5, left = -0.8, right = -0.8 },
				{ up = 0.4, down = 0.6, left = -0.6, right = -0.8 },
				{ up = 0.5, down = 0.6, left = -0.4, right = -0.6 },
				{ up = 0.4, down = 0.4, left = -0.2, right = -0.1 },
				{ up = 0.4, down = 0.5, left = 0.2, right = 0.3 },
				{ up = 0.1, down = 0.1, left = -0.6, right = -0.6 },
				{ up = 0.2, down = 0.3, left = -0.6, right = -0.6 },
				{ up = 0.3, down = 0.3, left = -0.4, right = -0.4 },
				{ up = 0.3, down = 0.4, left = -0.4, right = -0.4 },
				{ up = 0.4, down = 0.4, left = -0.4, right = -0.4 },
				{ up = 0.4, down = 0.5, left = -0.4, right = -0.4 },
				{ up = 0.5, down = 0.5, left = -0.3, right = -0.3 },
				{ up = 0.5, down = 0.6, left = 0.1, right = 0.2 },
				{ up = 0.3, down = 0.3, left = 0.1, right = 0.2 },
				{ up = 0.3, down = 0.3, left = 0.3, right = 0.6 },
				{ up = 0.4, down = 0.4, left = 0.6, right = 0.8 },
				{ up = 0.5, down = 0.5, left = 0.8, right = 0.8 },
				{ up = 0.4, down = 0.5, left = 0.6, right = 0.8 },
				{ up = 0.5, down = 0.5, left = 0.4, right = 0.4 },
				{ up = 0.4, down = 0.4, left = 0.2, right = 0.1 },
				{ up = 0.4, down = 0.5, left = -0.2, right = -0.3 },
			}
		},
		lmg_left = {
			pattern = {
				{ up = 0.3, down = 0.5, left = -0.8, right = 0.8 }
			},
			persist_pattern = {
				{ up = 0.1, down = 0.1, left = -0.6, right = -0.6 },
				{ up = 0.2, down = 0.3, left = -0.6, right = -0.6 },
				{ up = 0.3, down = 0.3, left = -0.4, right = -0.4 },
				{ up = 0.4, down = 0.4, left = -0.4, right = -0.4 },
				{ up = 0.4, down = 0.4, left = -0.4, right = -0.4 },
				{ up = 0.4, down = 0.5, left = -0.4, right = -0.4 },
				{ up = 0.5, down = 0.6, left = -0.3, right = -0.3 },
				{ up = 0.5, down = 0.6, left = 0.1, right = 0.2 },
				{ up = 0.3, down = 0.3, left = 0.1, right = 0.2 },
				{ up = 0.3, down = 0.3, left = 0.2, right = 0.6 },
				{ up = 0.4, down = 0.4, left = 0.6, right = 0.8 },
				{ up = 0.4, down = 0.5, left = 0.8, right = 0.8 },
				{ up = 0.4, down = 0.6, left = 0.6, right = 0.8 },
				{ up = 0.5, down = 0.6, left = 0.4, right = 0.6 },
				{ up = 0.4, down = 0.4, left = 0.2, right = 0.1 },
				{ up = 0.4, down = 0.5, left = -0.2, right = -0.3 },
				{ up = 0.1, down = 0.1, left = 0.6, right = 0.6 },
				{ up = 0.2, down = 0.3, left = 0.6, right = 0.6 },
				{ up = 0.3, down = 0.3, left = 0.4, right = 0.4 },
				{ up = 0.3, down = 0.4, left = 0.4, right = 0.4 },
				{ up = 0.4, down = 0.4, left = 0.4, right = 0.4 },
				{ up = 0.4, down = 0.5, left = 0.4, right = 0.4 },
				{ up = 0.5, down = 0.5, left = 0.3, right = 0.3 },
				{ up = 0.5, down = 0.6, left = -0.1, right = -0.2 },
				{ up = 0.3, down = 0.3, left = -0.1, right = -0.2 },
				{ up = 0.3, down = 0.3, left = -0.3, right = -0.6 },
				{ up = 0.4, down = 0.4, left = -0.6, right = -0.8 },
				{ up = 0.5, down = 0.5, left = -0.8, right = -0.8 },
				{ up = 0.4, down = 0.5, left = -0.6, right = -0.8 },
				{ up = 0.5, down = 0.5, left = -0.4, right = -0.4 },
				{ up = 0.4, down = 0.4, left = -0.2, right = -0.1 },
				{ up = 0.4, down = 0.5, left = 0.2, right = 0.3 },
			}
		},
		mini = {
			pattern = {
				{ up = 0.35, down = 0.45, left = -0.1, right = -0.3 },
				{ up = 0.35, down = 0.45, left = -0.1, right = -0.3 },
				{ up = 0.35, down = 0.45, left = -0.1, right = -0.3 },
				{ up = 0.35, down = 0.45, left = -0.1, right = -0.3 },
				{ up = 0.35, down = 0.45, left = -0.1, right = -0.3 },
				{ up = 0.35, down = 0.45, left = -0.1, right = -0.3 },
				{ up = 0.35, down = 0.45, left = -0.1, right = -0.3 },
				{ up = 0.35, down = 0.45, left = -0.1, right = -0.3 },
				{ up = 0.4, down = 0.5, left = 0.1, right = 0.3 },
				{ up = 0.4, down = 0.5, left = 0.1, right = 0.3 },
				{ up = 0.4, down = 0.5, left = 0.1, right = 0.3 },
				{ up = 0.4, down = 0.5, left = -0.15, right = 0.12 },
				{ up = 0.4, down = 0.5, left = -0.15, right = 0.12 },
				{ up = 0.4, down = 0.5, left = -0.15, right = 0.12 },
				{ up = 0.4, down = 0.5, left = -0.15, right = 0.12 },
				{ up = 0.4, down = 0.5, left = -0.15, right = 0.12 },
				{ up = 0.3, down = 0.35, left = -0.15, right = 0.12 },
				{ up = 0.3, down = 0.35, left = -0.15, right = 0.12 },
				{ up = 0.3, down = 0.35, left = -0.15, right = 0.12 },
				{ up = 0.3, down = 0.35, left = -0.15, right = 0.12 },
				{ up = 0.3, down = 0.35, left = -0.15, right = 0.12 },
				{ up = 0.3, down = 0.35, left = -0.15, right = 0.12 },
				{ up = 0.3, down = 0.35, left = -0.15, right = 0.12 },
				{ up = 0.3, down = 0.35, left = -0.15, right = 0.12 },
				{ up = 0.3, down = 0.35, left = -0.15, right = 0.12 },
				{ up = 0.25, down = 0.25, left = -0.15, right = 0.12 },
				{ up = 0.25, down = 0.25, left = -0.15, right = 0.12 },
				{ up = 0.25, down = 0.25, left = -0.15, right = 0.12 },
				{ up = 0.25, down = 0.25, left = -0.15, right = 0.12 },
				{ up = 0.25, down = 0.25, left = -0.15, right = 0.12 },
				{ up = 0.25, down = 0.25, left = -0.15, right = 0.12 },
				{ up = 0.25, down = 0.25, left = -0.15, right = 0.12 },
				{ up = 0.25, down = 0.25, left = -0.15, right = 0.12 },
				{ up = 0.25, down = 0.25, left = -0.15, right = 0.12 },
				{ up = 0.25, down = 0.25, left = -0.15, right = 0.12 },
				{ up = 0.25, down = 0.25, left = -0.15, right = 0.12 },
				{ up = 0.25, down = 0.25, left = -0.15, right = 0.12 },
				{ up = 0.25, down = 0.25, left = -0.15, right = 0.12 },
				{ up = 0.2, down = 0.25, left = -0.15, right = 0.12 },
				{ up = 0.2, down = 0.25, left = -0.15, right = 0.12 },
				{ up = 0.2, down = 0.25, left = -0.15, right = 0.12 },
				{ up = 0.2, down = 0.25, left = -0.15, right = 0.12 },
				{ up = 0.2, down = 0.25, left = -0.15, right = 0.12 },
				{ up = 0.2, down = 0.25, left = -0.15, right = 0.12 },
				{ up = 0.2, down = 0.25, left = -0.15, right = 0.12 },
				{ up = 0.2, down = 0.25, left = -0.15, right = 0.12 },
				{ up = 0.2, down = 0.25, left = -0.15, right = 0.12 },
				{ up = 0.15, down = 0.2, left = -0.15, right = 0.12 },
				{ up = 0.15, down = 0.2, left = -0.15, right = 0.12 },
				{ up = 0.15, down = 0.2, left = -0.15, right = 0.12 },
				{ up = 0.15, down = 0.2, left = -0.15, right = 0.12 },
				{ up = 0.15, down = 0.2, left = -0.15, right = 0.12 },
				{ up = 0.15, down = 0.2, left = -0.15, right = 0.12 },
				{ up = 0.15, down = 0.2, left = -0.15, right = 0.12 },
				{ up = 0.15, down = 0.2, left = -0.15, right = 0.12 },
				{ up = 0.15, down = 0.2, left = -0.15, right = 0.12 },
				{ up = 0.15, down = 0.2, left = -0.15, right = 0.12 },
				{ up = 0.1, down = 0.1, left = -0.15, right = 0.12 },
				{ up = 0.1, down = 0.1, left = -0.15, right = 0.12 },
				{ up = 0.1, down = 0.1, left = -0.15, right = 0.12 },
				{ up = 0.1, down = 0.1, left = -0.15, right = 0.12 },
				{ up = 0.1, down = 0.1, left = -0.15, right = 0.12 },
				{ up = 0.1, down = 0.1, left = -0.15, right = 0.12 },
				{ up = 0.1, down = 0.1, left = -0.15, right = 0.12 },
				{ up = 0.1, down = 0.1, left = -0.15, right = 0.12 },
				{ up = 0.05, down = 0.05, left = -0.15, right = 0.12 },
				{ up = 0.05, down = 0.05, left = -0.15, right = 0.12 },
				{ up = 0.05, down = 0.05, left = -0.15, right = 0.12 },
			},
			persist_pattern = {
				{ up = 0.1, down = 0.2, left = -0.3, right = 0.3 }
			}
		}
	}

	-- recoil recovery timer tables
	local recovery_tables = {
		low = 0.175,
		mid = 0.35,
		high = 0.5
	}

	-- Assault Rifles

	-- AMCAR
	self.amcar.CLIP_AMMO_MAX = 30
	self.amcar.stats.damage = 18
	self.amcar.stats.spread = 14
	self.amcar.stats.recoil = 18
	self.amcar.stats.concealment = 22
	self.amcar.fire_mode_data.fire_rate = 60 / 800

	-- Para
	self.olympic.categories = { "assault_rifle" }
	self.olympic.CLIP_AMMO_MAX = 30
	self.olympic.stats.damage = 18
	self.olympic.stats.spread = 12
	self.olympic.stats.recoil = 16
	self.olympic.stats.concealment = 24
	self.olympic.fire_mode_data.fire_rate = 60 / 900

	-- Akimbo Para
	self.x_olympic.sounds.reload = {
		wp_akmsu_x_take_new = "wp_m4_clip_take_new",
		wp_akmsu_x_clip_slide_out = "wp_m4_clip_grab_out",
		wp_akmsu_x_clip_slide_in = "wp_m4_clip_slide_in",
		wp_akmsu_x_clip_in_contact = "wp_m4_clip_in_contact",
		wp_akmsu_x_lever_pull = "wp_m4_lever_pull_in",
		wp_akmsu_x_lever_release = "wp_m4_lever_release"
	}

	-- Union
	self.corgi.CLIP_AMMO_MAX = 30
	self.corgi.stats.damage = 18
	self.corgi.stats.spread = 12
	self.corgi.stats.recoil = 18
	self.corgi.stats.concealment = 21
	self.corgi.fire_mode_data.fire_rate = 60 / 850

	-- Tempest
	self.komodo.use_data.selection_index = 1
	self.komodo.CLIP_AMMO_MAX = 30
	self.komodo.stats.damage = 18
	self.komodo.stats.spread = 14
	self.komodo.stats.recoil = 16
	self.komodo.stats.concealment = 24
	self.komodo.fire_mode_data.fire_rate = 60 / 850

	-- CAR-4
	self.new_m4.CLIP_AMMO_MAX = 30
	self.new_m4.stats.damage = 20
	self.new_m4.stats.spread = 14
	self.new_m4.stats.recoil = 17
	self.new_m4.stats.concealment = 20
	self.new_m4.fire_mode_data.fire_rate = 60 / 750

	-- Clarion
	self.famas.use_data.selection_index = 1
	self.famas.CLIP_AMMO_MAX = 25
	self.famas.stats.damage = 20
	self.famas.stats.spread = 12
	self.famas.stats.recoil = 18
	self.famas.stats.concealment = 23
	self.famas.fire_mode_data.fire_rate = 60 / 1000

	-- JP36
	self.g36.CLIP_AMMO_MAX = 30
	self.g36.stats.damage = 20
	self.g36.stats.spread = 13
	self.g36.stats.recoil = 17
	self.g36.stats.concealment = 22
	self.g36.fire_mode_data.fire_rate = 60 / 750
	self.g36.reload_speed_multiplier = 1.15
	
	-- AK5
	self.ak5.CLIP_AMMO_MAX = 30
	self.ak5.stats.damage = 20
	self.ak5.stats.spread = 16
	self.ak5.stats.recoil = 16
	self.ak5.stats.concealment = 19
	self.ak5.fire_mode_data.fire_rate = 60 / 700

	-- CR805
	self.hajk.use_data.selection_index = 2
	self.hajk.categories = { "assault_rifle" }
	self.hajk.CLIP_AMMO_MAX = 30
	self.hajk.stats.damage = 20
	self.hajk.stats.spread = 14
	self.hajk.stats.recoil = 18
	self.hajk.stats.concealment = 18
	self.hajk.fire_mode_data.fire_rate = 60 / 750

	-- AK Rifle
	self.ak74.CLIP_AMMO_MAX = 30
	self.ak74.stats.damage = 24
	self.ak74.stats.spread = 15
	self.ak74.stats.recoil = 16
	self.ak74.stats.concealment = 20
	self.ak74.fire_mode_data.fire_rate = 60 / 650

	-- Commando 553
	self.s552.CLIP_AMMO_MAX = 30
	self.s552.stats.damage = 24
	self.s552.stats.spread = 17
	self.s552.stats.recoil = 12
	self.s552.stats.concealment = 22
	self.s552.fire_mode_data.fire_rate = 60 / 750

	-- UAR
	self.aug.CLIP_AMMO_MAX = 30
	self.aug.stats.damage = 24
	self.aug.stats.spread = 16
	self.aug.stats.recoil = 13
	self.aug.stats.concealment = 24
	self.aug.fire_mode_data.fire_rate = 60 / 700

	-- Rodion
	self.tkb.CLIP_AMMO_MAX = 45
	self.tkb.stats.damage = 24
	self.tkb.stats.spread = 10
	self.tkb.stats.recoil = 14
	self.tkb.stats.concealment = 16
	self.tkb.fire_mode_data.fire_rate = 60 / 800
	self.tkb.reload_speed_multiplier = 0.7
	self.tkb.fire_mode_data.volley = {
		spread_mul = 1.25,
		damage_mul = 1,
		ammo_usage = 3,
		rays = 3,
		can_shoot_through_wall = false,
		can_shoot_through_shield = true,
		can_shoot_through_enemy = true,
		muzzleflash = "effects/payday2/particles/weapons/tkb_muzzle",
		muzzleflash_silenced = "effects/payday2/particles/weapons/tkb_suppressed"
	}

	-- AMR
	self.m16.CLIP_AMMO_MAX = 30
	self.m16.stats.damage = 28
	self.m16.stats.spread = 17
	self.m16.stats.recoil = 11
	self.m16.stats.concealment = 17
	self.m16.fire_mode_data.fire_rate = 60 / 700

	-- Queen's Wrath
	self.l85a2.CLIP_AMMO_MAX = 30
	self.l85a2.stats.damage = 28
	self.l85a2.stats.spread = 15
	self.l85a2.stats.recoil = 16
	self.l85a2.stats.concealment = 20
	self.l85a2.fire_mode_data.fire_rate = 60 / 700
	self.l85a2.reload_speed_multiplier = 1.3
	self.l85a2.timers.reload_not_empty = 3
	self.l85a2.timers.reload_empty = 4

	-- Lion's Roar
	self.vhs.CLIP_AMMO_MAX = 30
	self.vhs.stats.damage = 28
	self.vhs.stats.spread = 14
	self.vhs.stats.recoil = 14
	self.vhs.stats.concealment = 23
	self.vhs.fire_mode_data.fire_rate = 60 / 850

	-- Valkyria
	self.asval.CLIP_AMMO_MAX = 20
	self.asval.stats.damage = 32
	self.asval.stats.spread = 15
	self.asval.stats.recoil = 13
	self.asval.stats.concealment = 24
	self.asval.fire_mode_data.fire_rate = 60 / 900

	-- Ketchnov
	self.groza.CLIP_AMMO_MAX = 20
	self.groza.stats.damage = 32
	self.groza.stats.spread = 17
	self.groza.stats.recoil = 12
	self.groza.stats.concealment = 14
	self.groza.fire_mode_data.fire_rate = 60 / 750

	-- Ketchnov GL
	self.groza_underbarrel.CLIP_AMMO_MAX = 1
	self.groza_underbarrel.stats.damage = 72
	self.groza_underbarrel.stats.spread = 25
	self.groza_underbarrel.stats.recoil = 25
	self.groza_underbarrel.stats.concealment = 15
	self.groza_underbarrel.fire_mode_data.fire_rate = 60 / 60
	self.groza_underbarrel.stats_modifiers = { damage = 5 }
	self.groza_underbarrel.reload_speed_multiplier = 0.7

	-- AK 7.62
	self.akm.CLIP_AMMO_MAX = 30
	self.akm.stats.damage = 36
	self.akm.stats.spread = 16
	self.akm.stats.recoil = 12
	self.akm.stats.concealment = 19
	self.akm.fire_mode_data.fire_rate = 60 / 600
	self.akm.timers.reload_not_empty = 2.2

	-- Gold AK 7.62
	self.akm_gold.CLIP_AMMO_MAX = 30
	self.akm_gold.stats.damage = 36
	self.akm_gold.stats.spread = 16
	self.akm_gold.stats.recoil = 12
	self.akm_gold.stats.concealment = 19
	self.akm_gold.fire_mode_data.fire_rate = 60 / 600
	self.akm_gold.timers.reload_not_empty = 2.2

	-- Krinkov
	self.akmsu.categories = { "assault_rifle" }
	self.akmsu.CLIP_AMMO_MAX = 30
	self.akmsu.stats.damage = 36
	self.akmsu.stats.spread = 14
	self.akmsu.stats.recoil = 12
	self.akmsu.stats.concealment = 23
	self.akmsu.fire_mode_data.fire_rate = 60 / 750

	-- AK17
	self.flint.CLIP_AMMO_MAX = 30
	self.flint.stats.damage = 36
	self.flint.stats.spread = 14
	self.flint.stats.recoil = 14
	self.flint.stats.concealment = 18
	self.flint.fire_mode_data.fire_rate = 60 / 700

	-- Akimbo Krinkov
	self.x_akmsu.timers.reload_not_empty = 2.75
	self.x_akmsu.timers.reload_empty = 3.4

	-- Eagle Heavy
	self.scar.categories = {
		"dmr",
		"assault_rifle"
	}
	self.scar.CLIP_AMMO_MAX = 20
	self.scar.stats.damage = 48
	self.scar.stats.spread = 18
	self.scar.stats.recoil = 7
	self.scar.stats.concealment = 17
	self.scar.fire_mode_data.fire_rate = 60 / 550

	-- Gewehr
	self.g3.categories = {
		"dmr",
		"assault_rifle"
	}
	self.g3.CLIP_AMMO_MAX = 20
	self.g3.stats.damage = 48
	self.g3.stats.spread = 21
	self.g3.stats.recoil = 6
	self.g3.stats.concealment = 15
	self.g3.fire_mode_data.fire_rate = 60 / 600

	-- Gecko
	self.galil.categories = {
		"dmr",
		"assault_rifle"
	}
	self.galil.CLIP_AMMO_MAX = 25
	self.galil.stats.damage = 48
	self.galil.stats.spread = 15
	self.galil.stats.recoil = 12
	self.galil.stats.concealment = 13
	self.galil.fire_mode_data.fire_rate = 60 / 600

	-- Falcon
	self.fal.categories = {
		"dmr",
		"assault_rifle"
	}
	self.fal.CLIP_AMMO_MAX = 20
	self.fal.stats.damage = 48
	self.fal.stats.spread = 17
	self.fal.stats.recoil = 6
	self.fal.stats.concealment = 18
	self.fal.fire_mode_data.fire_rate = 60 / 650

	-- M308
	self.new_m14.categories = {
		"dmr",
		"assault_rifle"
	}
	self.new_m14.CLIP_AMMO_MAX = 20
	self.new_m14.stats.damage = 64
	self.new_m14.stats.spread = 22
	self.new_m14.stats.recoil = 4
	self.new_m14.stats.concealment = 15
	self.new_m14.fire_mode_data.fire_rate = 60 / 700

	-- Little Friend
	self.contraband.categories = {
		"dmr",
		"assault_rifle"
	}
	self.contraband.CLIP_AMMO_MAX = 20
	self.contraband.stats.damage = 64
	self.contraband.stats.spread = 19
	self.contraband.stats.recoil = 6
	self.contraband.stats.concealment = 10
	self.contraband.fire_mode_data.fire_rate = 60 / 600

	-- Little Friend GL
	self.contraband_m203.CLIP_AMMO_MAX = 1
	self.contraband_m203.stats.damage = 72
	self.contraband_m203.stats.spread = 25
	self.contraband_m203.stats.recoil = 25
	self.contraband_m203.stats.concealment = 10
	self.contraband_m203.fire_mode_data.fire_rate = 60 / 60
	self.contraband_m203.stats_modifiers = { damage = 5 }

	-- Galant
	self.ching.categories = {
		"dmr",
		"assault_rifle"
	}
	self.ching.CLIP_AMMO_MAX = 8
	self.ching.stats.damage = 64
	self.ching.stats.spread = 22
	self.ching.stats.recoil = 4
	self.ching.stats.concealment = 17
	self.ching.fire_mode_data.fire_rate = 60 / 600

	-- KS12
	self.shak12.categories = {
		"dmr",
		"assault_rifle"
	}
	self.shak12.CLIP_AMMO_MAX = 20
	self.shak12.stats.damage = 64
	self.shak12.stats.spread = 16
	self.shak12.stats.recoil = 8
	self.shak12.stats.concealment = 20
	self.shak12.fire_mode_data.fire_rate = 60 / 600
	self.shak12.reload_speed_multiplier = 0.7

	-- Pistols

	-- Stryk
	self.glock_18c.CLIP_AMMO_MAX = 19
	self.glock_18c.stats.damage = 14
	self.glock_18c.stats.spread = 14
	self.glock_18c.stats.recoil = 15
	self.glock_18c.stats.concealment = 29
	self.glock_18c.fire_mode_data.fire_rate = 60 / 1200

	-- Bernetti Auto
	self.beer.CLIP_AMMO_MAX = 15
	self.beer.stats.damage = 14
	self.beer.stats.spread = 13
	self.beer.stats.recoil = 17
	self.beer.stats.concealment = 28
	self.beer.fire_mode_data.fire_rate = 60 / 1100

	-- Czech
	self.czech.CLIP_AMMO_MAX = 19
	self.czech.stats.damage = 16
	self.czech.stats.spread = 15
	self.czech.stats.recoil = 14
	self.czech.stats.concealment = 28
	self.czech.fire_mode_data.fire_rate = 60 / 1000
	
	-- Chimano 88
	self.glock_17.CLIP_AMMO_MAX = 17
	self.glock_17.stats.damage = 20
	self.glock_17.stats.spread = 15
	self.glock_17.stats.recoil = 17
	self.glock_17.stats.concealment = 29
	self.glock_17.fire_mode_data.fire_rate = 60 / 600

	-- Bernetti 9
	self.b92fs.CLIP_AMMO_MAX = 15
	self.b92fs.stats.damage = 20
	self.b92fs.stats.spread = 16
	self.b92fs.stats.recoil = 17
	self.b92fs.stats.concealment = 29
	self.b92fs.fire_mode_data.fire_rate = 60 / 600

	-- Chimano Compact
	self.g26.CLIP_AMMO_MAX = 10
	self.g26.stats.damage = 20
	self.g26.stats.spread = 15
	self.g26.stats.recoil = 17
	self.g26.stats.concealment = 30
	self.g26.fire_mode_data.fire_rate = 60 / 600
	self.g26.reload_speed_multiplier = 1.15

	-- M13
	self.legacy.CLIP_AMMO_MAX = 13
	self.legacy.stats.damage = 20
	self.legacy.stats.spread = 17
	self.legacy.stats.recoil = 13
	self.legacy.stats.concealment = 30
	self.legacy.fire_mode_data.fire_rate = 60 / 600
	self.legacy.reload_speed_multiplier = 1.15

	-- Igor
	self.stech.CLIP_AMMO_MAX = 20
	self.stech.stats.damage = 20
	self.stech.stats.spread = 15
	self.stech.stats.recoil = 8
	self.stech.stats.concealment = 28
	self.stech.fire_mode_data.fire_rate = 60 / 750
	
	-- Holt
	self.holt.CLIP_AMMO_MAX = 15
	self.holt.stats.damage = 20
	self.holt.stats.spread = 14
	self.holt.stats.recoil = 18
	self.holt.stats.concealment = 30
	self.holt.fire_mode_data.fire_rate = 60 / 600

	-- Gecko M2
	self.maxim9.CLIP_AMMO_MAX = 17
	self.maxim9.stats.damage = 20
	self.maxim9.stats.spread = 17
	self.maxim9.stats.recoil = 12
	self.maxim9.stats.concealment = 28
	self.maxim9.fire_mode_data.fire_rate = 60 / 600
	self.maxim9.can_do_shotgun_push = false
	
	-- Signature
	self.p226.CLIP_AMMO_MAX = 12
	self.p226.stats.damage = 24
	self.p226.stats.spread = 18
	self.p226.stats.recoil = 12
	self.p226.stats.concealment = 29
	self.p226.fire_mode_data.fire_rate = 60 / 600

	-- Chimano Custom
	self.g22c.CLIP_AMMO_MAX = 15
	self.g22c.stats.damage = 24
	self.g22c.stats.spread = 16
	self.g22c.stats.recoil = 14
	self.g22c.stats.concealment = 29
	self.g22c.fire_mode_data.fire_rate = 60 / 600

	-- Broomstick
	self.c96.CLIP_AMMO_MAX = 10
	self.c96.stats.damage = 24
	self.c96.stats.spread = 14
	self.c96.stats.recoil = 9
	self.c96.stats.concealment = 28
	self.c96.fire_mode_data.fire_rate = 60 / 900
	self.c96.FIRE_MODE = "auto"
	self.c96.sounds.fire_single = self.c96.sounds.fire 
	self.c96.sounds.fire_auto = self.c96.sounds.fire 
	self.c96.auto = { 
		fire_rate = self.c96.fire_mode_data.fire_rate,
	}
	self.c96.CAN_TOGGLE_FIREMODE = true
	
	-- LEO
	self.hs2000.CLIP_AMMO_MAX = 19
	self.hs2000.stats.damage = 24
	self.hs2000.stats.spread = 15
	self.hs2000.stats.recoil = 15
	self.hs2000.stats.concealment = 29
	self.hs2000.fire_mode_data.fire_rate = 60 / 600
	
	-- Contractor
	self.packrat.CLIP_AMMO_MAX = 13
	self.packrat.stats.damage = 24
	self.packrat.stats.spread = 18
	self.packrat.stats.recoil = 12
	self.packrat.stats.concealment = 28
	self.packrat.fire_mode_data.fire_rate = 60 / 600

	-- Interceptor
	self.usp.CLIP_AMMO_MAX = 12
	self.usp.stats.damage = 32
	self.usp.stats.spread = 18
	self.usp.stats.recoil = 9
	self.usp.stats.concealment = 28
	self.usp.fire_mode_data.fire_rate = 60 / 600

	-- Baby Deagle
	self.sparrow.CLIP_AMMO_MAX = 12
	self.sparrow.stats.damage = 32
	self.sparrow.stats.spread = 18
	self.sparrow.stats.recoil = 9
	self.sparrow.stats.concealment = 29
	self.sparrow.fire_mode_data.fire_rate = 60 / 600

	-- White Streak
	self.pl14.CLIP_AMMO_MAX = 16
	self.pl14.stats.damage = 32
	self.pl14.stats.spread = 15
	self.pl14.stats.recoil = 10
	self.pl14.stats.concealment = 28
	self.pl14.fire_mode_data.fire_rate = 60 / 600
	
	-- Crosskill Guard
	self.shrew.CLIP_AMMO_MAX = 8
	self.shrew.stats.damage = 36
	self.shrew.stats.spread = 15
	self.shrew.stats.recoil = 10
	self.shrew.stats.concealment = 30
	self.shrew.fire_mode_data.fire_rate = 60 / 600
	
	-- Crosskill
	self.colt_1911.CLIP_AMMO_MAX = 8
	self.colt_1911.stats.damage = 40
	self.colt_1911.stats.spread = 18
	self.colt_1911.stats.recoil = 9
	self.colt_1911.stats.concealment = 28
	self.colt_1911.fire_mode_data.fire_rate = 60 / 600
	
	-- Crosskill Chunky Compact
	self.m1911.CLIP_AMMO_MAX = 8
	self.m1911.stats.damage = 40
	self.m1911.stats.spread = 18
	self.m1911.stats.recoil = 10
	self.m1911.stats.concealment = 29
	self.m1911.fire_mode_data.fire_rate = 60 / 600
	
	-- Kang Arms
	self.type54.CLIP_AMMO_MAX = 8
	self.type54.stats.damage = 40
	self.type54.stats.spread = 15
	self.type54.stats.recoil = 10
	self.type54.stats.concealment = 28
	self.type54.fire_mode_data.fire_rate = 60 / 600

	-- Kang Arms Shotgun
	self.type54_underbarrel.CLIP_AMMO_MAX = 1
	self.type54_underbarrel.stats.damage = 32
	self.type54_underbarrel.stats.spread = 11
	self.type54_underbarrel.stats.recoil = 5
	self.type54_underbarrel.stats.concealment = 28
	self.type54_underbarrel.fire_mode_data.fire_rate = 60 / 60
	self.type54_underbarrel.reload_speed_multiplier = 1.3
	self.type54_underbarrel.stats_modifiers = nil

	-- Gruber
	self.ppk.CLIP_AMMO_MAX = 7
	self.ppk.stats.damage = 48
	self.ppk.stats.spread = 16
	self.ppk.stats.recoil = 14
	self.ppk.stats.concealment = 30
	self.ppk.fire_mode_data.fire_rate = 60 / 600

	-- 5/7
	self.lemming.CLIP_AMMO_MAX = 20
	self.lemming.stats.damage = 48
	self.lemming.stats.spread = 13
	self.lemming.stats.recoil = 10
	self.lemming.stats.concealment = 28
	self.lemming.fire_mode_data.fire_rate = 60 / 600

	-- Parabellum
	self.breech.CLIP_AMMO_MAX = 8
	self.breech.stats.damage = 48
	self.breech.stats.spread = 17
	self.breech.stats.recoil = 10
	self.breech.stats.concealment = 30
	self.breech.fire_mode_data.fire_rate = 60 / 600

	-- Frenchman
	self.model3.categories = {
		"revolver"
	}
	self.model3.CLIP_AMMO_MAX = 6
	self.model3.stats.damage = 64
	self.model3.stats.spread = 22
	self.model3.stats.recoil = 7
	self.model3.stats.concealment = 27
	self.model3.fire_mode_data.fire_rate = 60 / 300

	-- Akimbo Frenchman
	self.x_model3.timers.reload_not_empty = 2.50
	self.x_model3.timers.reload_empty = self.x_model3.timers.reload_not_empty

	-- Matever
	self.mateba.categories = {
		"revolver"
	}
	self.mateba.CLIP_AMMO_MAX = 6
	self.mateba.stats.damage = 64
	self.mateba.stats.spread = 21
	self.mateba.stats.recoil = 9
	self.mateba.stats.concealment = 28
	self.mateba.fire_mode_data.fire_rate = 60 / 300
	self.mateba.reload_speed_multiplier = 1.3

	-- Kahn
	self.korth.categories = {
		"revolver"
	}
	self.korth.CLIP_AMMO_MAX = 8
	self.korth.stats.damage = 64
	self.korth.stats.spread = 19
	self.korth.stats.recoil = 7
	self.korth.stats.concealment = 28
	self.korth.fire_mode_data.fire_rate = 60 / 300

	-- Bronco
	self.new_raging_bull.categories = {
		"revolver"
	}
	self.new_raging_bull.CLIP_AMMO_MAX = 6
	self.new_raging_bull.stats.damage = 80
	self.new_raging_bull.stats.spread = 22
	self.new_raging_bull.stats.recoil = 4
	self.new_raging_bull.stats.concealment = 28
	self.new_raging_bull.fire_mode_data.fire_rate = 60 / 300

	-- Deagle
	self.deagle.CLIP_AMMO_MAX = 7
	self.deagle.stats.damage = 80
	self.deagle.stats.spread = 19
	self.deagle.stats.recoil = 3
	self.deagle.stats.concealment = 26
	self.deagle.fire_mode_data.fire_rate = 60 / 400

	--Peacemaker
	self.peacemaker.categories = {
		"revolver"
	}
	self.peacemaker.CLIP_AMMO_MAX = 6
	self.peacemaker.stats.damage = 80
	self.peacemaker.stats.spread = 22
	self.peacemaker.stats.recoil = 4
	self.peacemaker.stats.concealment = 27
	self.peacemaker.fire_mode_data.fire_rate = 60 / 300
	self.peacemaker.reload_speed_multiplier = 1.6
	self.peacemaker.armor_piercing_chance = 1
	self.peacemaker.stats_modifiers = nil
	self.peacemaker.can_shoot_through_enemy = true
	self.peacemaker.can_shoot_through_shield = true
	self.peacemaker.can_shoot_through_wall = true
	self.peacemaker.has_description = true
	self.peacemaker.desc_id = "bm_w_lemming_desc"

	-- Castigo
	self.chinchilla.categories = {
		"revolver"
	}
	self.chinchilla.CLIP_AMMO_MAX = 6
	self.chinchilla.stats.damage = 80
	self.chinchilla.stats.spread = 22
	self.chinchilla.stats.recoil = 6
	self.chinchilla.stats.concealment = 28
	self.chinchilla.fire_mode_data.fire_rate = 60 / 300
	self.chinchilla.reload_speed_multiplier = 1.15
	
	-- Angry Tiger
	self.rsh12.categories = {
		"revolver"
	}
	self.rsh12.CLIP_AMMO_MAX = 5
	self.rsh12.stats.damage = 96
	self.rsh12.stats.spread = 23
	self.rsh12.stats.recoil = 2
	self.rsh12.stats.concealment = 26
	self.rsh12.fire_mode_data.fire_rate = 60 / 300
	self.rsh12.reload_speed_multiplier = 0.7
	self.rsh12.stats_modifiers = nil

	-- SMGs

	-- CMP
	self.mp9.CLIP_AMMO_MAX = 15
	self.mp9.stats.damage = 16
	self.mp9.stats.spread = 10
	self.mp9.stats.recoil = 20
	self.mp9.stats.concealment = 27
	self.mp9.fire_mode_data.fire_rate = 60 / 900

	-- Cobra
	self.scorpion.CLIP_AMMO_MAX = 20
	self.scorpion.stats.damage = 16
	self.scorpion.stats.spread = 11
	self.scorpion.stats.recoil = 18
	self.scorpion.stats.concealment = 28
	self.scorpion.fire_mode_data.fire_rate = 60 / 900

	-- Micro Uzi
	self.baka.CLIP_AMMO_MAX = 32
	self.baka.stats.damage = 16
	self.baka.stats.spread = 8
	self.baka.stats.recoil = 20
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

	-- Wasp
	self.fmg9.CLIP_AMMO_MAX = 27
	self.fmg9.stats.damage = 16
	self.fmg9.stats.spread = 14
	self.fmg9.stats.recoil = 11
	self.fmg9.stats.concealment = 29
	self.fmg9.fire_mode_data.fire_rate = 60 / 1100
	self.fmg9.timers.unequip = 1.2

	-- Compact-5
	self.new_mp5.CLIP_AMMO_MAX = 30
	self.new_mp5.stats.damage = 18
	self.new_mp5.stats.spread = 14
	self.new_mp5.stats.recoil = 19
	self.new_mp5.stats.concealment = 24
	self.new_mp5.fire_mode_data.fire_rate = 60 / 800

	-- Akimbo Compact-5
	self.x_mp5.timers.reload_not_empty = 1.95
	self.x_mp5.timers.reload_empty = 2.6

	-- Kobus
	self.p90.use_data.selection_index = 2
	self.p90.CLIP_AMMO_MAX = 50
	self.p90.stats.damage = 18
	self.p90.stats.spread = 14
	self.p90.stats.recoil = 16
	self.p90.stats.concealment = 25
	self.p90.fire_mode_data.fire_rate = 60 / 900

	-- Heather
	self.sr2.CLIP_AMMO_MAX = 30
	self.sr2.stats.damage = 18
	self.sr2.stats.spread = 12
	self.sr2.stats.recoil = 18
	self.sr2.stats.concealment = 27
	self.sr2.fire_mode_data.fire_rate = 60 / 900

	-- Signature
	self.shepheard.use_data.selection_index = 2
	self.shepheard.CLIP_AMMO_MAX = 30
	self.shepheard.stats.damage = 18
	self.shepheard.stats.spread = 15
	self.shepheard.stats.recoil = 17
	self.shepheard.stats.concealment = 24
	self.shepheard.fire_mode_data.fire_rate = 60 / 850

	-- Miyaka
	self.pm9.use_data.selection_index = 2
	self.pm9.CLIP_AMMO_MAX = 25
	self.pm9.stats.damage = 18
	self.pm9.stats.spread = 11
	self.pm9.stats.recoil = 20
	self.pm9.stats.concealment = 26
	self.pm9.fire_mode_data.fire_rate = 60 / 1100

	-- Mark 10
	self.mac10.CLIP_AMMO_MAX = 16
	self.mac10.stats.damage = 20
	self.mac10.stats.spread = 9
	self.mac10.stats.recoil = 17
	self.mac10.stats.concealment = 27
	self.mac10.fire_mode_data.fire_rate = 60 / 1200

	-- Akimbo Mark 10
	self.x_mac10.sounds.reload = {
		wp_akmsu_x_clip_slide_out = "wp_mac10_clip_slide_out",
		wp_akmsu_x_clip_slide_in = "wp_mac10_clip_slide_in",
		wp_akmsu_x_clip_in_contact = "wp_mac10_clip_in_contact",
		wp_akmsu_x_lever_pull = "wp_mac10_lever_pull",
		wp_akmsu_x_lever_release = "wp_mac10_lever_release"
	}

	-- Blaster
	self.tec9.CLIP_AMMO_MAX = 32
	self.tec9.stats.damage = 20
	self.tec9.stats.spread = 8
	self.tec9.stats.recoil = 20
	self.tec9.stats.concealment = 27
	self.tec9.fire_mode_data.fire_rate = 60 / 1100

	-- Thompson
	self.m1928.CLIP_AMMO_MAX = 50
	self.m1928.stats.damage = 20
	self.m1928.stats.spread = 15
	self.m1928.stats.recoil = 16
	self.m1928.stats.concealment = 21
	self.m1928.fire_mode_data.fire_rate = 60 / 700
	self.m1928.reload_speed_multiplier = 1.3

	-- Jacket's Piece
	self.cobray.use_data.selection_index = 2
	self.cobray.CLIP_AMMO_MAX = 32
	self.cobray.stats.damage = 20
	self.cobray.stats.spread = 14
	self.cobray.stats.recoil = 18
	self.cobray.stats.concealment = 25
	self.cobray.fire_mode_data.fire_rate = 60 / 1200
	self.cobray.timers.reload_not_empty = 1.9
	self.cobray.timers.reload_empty = 4.35

	-- Tatonka
	self.coal.use_data.selection_index = 2
	self.coal.CLIP_AMMO_MAX = 64
	self.coal.stats.damage = 20
	self.coal.stats.spread = 14
	self.coal.stats.recoil = 16
	self.coal.stats.concealment = 23
	self.coal.fire_mode_data.fire_rate = 60 / 700
	
	-- Spec Ops
	self.mp7.CLIP_AMMO_MAX = 20
	self.mp7.stats.damage = 24
	self.mp7.stats.spread = 13
	self.mp7.stats.recoil = 18
	self.mp7.stats.concealment = 26
	self.mp7.fire_mode_data.fire_rate = 60 / 950

	-- Vertex
	self.polymer.use_data.selection_index = 2
	self.polymer.CLIP_AMMO_MAX = 25
	self.polymer.stats.damage = 24
	self.polymer.stats.spread = 9
	self.polymer.stats.recoil = 21
	self.polymer.stats.concealment = 22
	self.polymer.fire_mode_data.fire_rate = 60 / 1200

	-- AK GEN
	self.vityaz.use_data.selection_index = 2
	self.vityaz.CLIP_AMMO_MAX = 30
	self.vityaz.stats.damage = 24
	self.vityaz.stats.spread = 15
	self.vityaz.stats.recoil = 14
	self.vityaz.stats.concealment = 23
	self.vityaz.fire_mode_data.fire_rate = 60 / 750
	
	-- Swedish K
	self.m45.CLIP_AMMO_MAX = 36
	self.m45.stats.damage = 28
	self.m45.stats.spread = 18
	self.m45.stats.recoil = 12
	self.m45.stats.concealment = 24
	self.m45.fire_mode_data.fire_rate = 60 / 600

	-- Uzi
	self.uzi.CLIP_AMMO_MAX = 32
	self.uzi.stats.damage = 28
	self.uzi.stats.spread = 12
	self.uzi.stats.recoil = 18
	self.uzi.stats.concealment = 25
	self.uzi.fire_mode_data.fire_rate = 60 / 600
	self.uzi.timers.reload_not_empty = 2

	-- MP40
	self.erma.use_data.selection_index = 2
	self.erma.CLIP_AMMO_MAX = 32
	self.erma.stats.damage = 28
	self.erma.stats.spread = 18
	self.erma.stats.recoil = 12
	self.erma.stats.concealment = 24
	self.erma.fire_mode_data.fire_rate = 60 / 550
	self.erma.reload_speed_multiplier = 1.15
	
	-- Pattchet
	self.sterling.use_data.selection_index = 2
	self.sterling.CLIP_AMMO_MAX = 20
	self.sterling.stats.damage = 32
	self.sterling.stats.spread = 14
	self.sterling.stats.recoil = 20
	self.sterling.stats.concealment = 23
	self.sterling.fire_mode_data.fire_rate = 60 / 550

	-- Jackal
	self.schakal.use_data.selection_index = 2
	self.schakal.CLIP_AMMO_MAX = 25
	self.schakal.stats.damage = 32
	self.schakal.stats.spread = 16
	self.schakal.stats.recoil = 14
	self.schakal.stats.concealment = 24
	self.schakal.fire_mode_data.fire_rate = 60 / 650
	
	-- Cavity
	self.sub2000.categories = { "smg" }
	self.sub2000.CLIP_AMMO_MAX = 33
	self.sub2000.stats.damage = 40
	self.sub2000.stats.spread = 19
	self.sub2000.stats.recoil = 9
	self.sub2000.stats.concealment = 27
	self.sub2000.fire_mode_data.fire_rate = 60 / 700
	
	-- Shotguns

	-- Izhma
	self.saiga.CLIP_AMMO_MAX = 5
	self.saiga.stats.damage = 10
	self.saiga.stats.spread = 11
	self.saiga.stats.recoil = 12
	self.saiga.stats.concealment = 17
	self.saiga.fire_mode_data.fire_rate = 60 / 400

	-- Street Sweeper
	self.striker.CLIP_AMMO_MAX = 12
	self.striker.stats.damage = 10
	self.striker.stats.spread = 11
	self.striker.stats.recoil = 12
	self.striker.stats.concealment = 23
	self.striker.fire_mode_data.fire_rate = 60 / 450
	self.striker.reload_speed_multiplier = 1.3

	-- Steakout
	self.aa12.CLIP_AMMO_MAX = 8
	self.aa12.stats.damage = 10
	self.aa12.stats.spread = 10
	self.aa12.stats.recoil = 14
	self.aa12.stats.concealment = 15
	self.aa12.fire_mode_data.fire_rate = 60 / 300

	-- Grimm
	self.basset.CLIP_AMMO_MAX = 5
	self.basset.stats.damage = 10
	self.basset.stats.spread = 9
	self.basset.stats.recoil = 13
	self.basset.stats.concealment = 24
	self.basset.fire_mode_data.fire_rate = 60 / 400

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
	self.rota.upgrade_blocks = { -- No mag size increases
		weapon = {
			"clip_ammo_increase",
		},
	}
	self.rota.CLIP_AMMO_MAX = 6
	self.rota.stats.damage = 12
	self.rota.stats.spread = 15
	self.rota.stats.recoil = 12
	self.rota.stats.concealment = 22
	self.rota.fire_mode_data.fire_rate = 60 / 300

	-- Argos
	self.ultima.use_data.selection_index = 2
	self.ultima.CLIP_AMMO_MAX = 7
	self.ultima.stats.damage = 12
	self.ultima.stats.spread = 14
	self.ultima.stats.recoil = 9
	self.ultima.stats.concealment = 21
	self.ultima.fire_mode_data.fire_rate = 60 / 300
	self.ultima.reload_speed_multiplier = 0.7

	-- VD-12
	self.sko12.CLIP_AMMO_MAX = 25
	self.sko12.stats.damage = 12
	self.sko12.stats.spread = 11
	self.sko12.stats.recoil = 10
	self.sko12.stats.concealment = 12
	self.sko12.fire_mode_data.fire_rate = 60 / 400
	self.sko12.reload_speed_multiplier = 0.7
	self.sko12.FIRE_MODE = "single"
	self.sko12.CAN_TOGGLE_FIREMODE = false

	-- Reinfeld 880
	self.r870.CLIP_AMMO_MAX = 8
	self.r870.stats.damage = 16
	self.r870.stats.spread = 15
	self.r870.stats.recoil = 10
	self.r870.stats.concealment = 17
	self.r870.fire_mode_data.fire_rate = 60 / 120

	-- Loco
	self.serbu.CLIP_AMMO_MAX = 4
	self.serbu.stats.damage = 16
	self.serbu.stats.spread = 13
	self.serbu.stats.recoil = 9
	self.serbu.stats.concealment = 23
	self.serbu.fire_mode_data.fire_rate = 60 / 120
	self.serbu.fire_rate_multiplier = 150 / 120

	-- Raven
	self.ksg.CLIP_AMMO_MAX = 14
	self.ksg.stats.damage = 16
	self.ksg.stats.spread = 12
	self.ksg.stats.recoil = 12
	self.ksg.stats.concealment = 22
	self.ksg.fire_mode_data.fire_rate = 60 / 120
	self.ksg.fire_rate_multiplier = 90 / 120

	-- Judge
	self.judge.CLIP_AMMO_MAX = 5
	self.judge.stats.damage = 16
	self.judge.stats.spread = 10
	self.judge.stats.recoil = 8
	self.judge.stats.concealment = 28
	self.judge.fire_mode_data.fire_rate = 60 / 300

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

	-- Mosconi Tactical
	self.m590.CLIP_AMMO_MAX = 7
	self.m590.stats.damage = 16
	self.m590.stats.spread = 14
	self.m590.stats.recoil = 9
	self.m590.stats.concealment = 19
	self.m590.fire_mode_data.fire_rate = 60 / 120
	self.m590.fire_rate_multiplier = 135 / 120

	-- GSPS
	self.m37.CLIP_AMMO_MAX = 5
	self.m37.stats.damage = 20
	self.m37.stats.spread = 14
	self.m37.stats.recoil = 10
	self.m37.stats.concealment = 19
	self.m37.fire_mode_data.fire_rate = 60 / 100
	self.m37.fire_rate_multiplier = 105 / 100

	-- Reinfeld 88
	self.m1897.CLIP_AMMO_MAX = 5
	self.m1897.stats.damage = 20
	self.m1897.stats.spread = 14
	self.m1897.stats.recoil = 10
	self.m1897.stats.concealment = 18
	self.m1897.fire_mode_data.fire_rate = 60 / 100
	self.m1897.fire_rate_multiplier = 120 / 100

	-- Nova
	self.supernova.CLIP_AMMO_MAX = 5
	self.supernova.stats.damage = 20
	self.supernova.stats.spread = 15
	self.supernova.stats.recoil = 9
	self.supernova.stats.concealment = 17
	self.supernova.fire_mode_data.fire_rate = 60 / 90
	self.supernova.fire_rate_multiplier = 105 / 90
	self.supernova.alt_fire_data = nil

	-- Mosconi
	self.huntsman.CLIP_AMMO_MAX = 2
	self.huntsman.stats.damage = 24
	self.huntsman.stats.spread = 16
	self.huntsman.stats.recoil = 6
	self.huntsman.stats.concealment = 15
	self.huntsman.fire_mode_data.fire_rate = 60 / 500

	-- Joceline
	self.b682.CLIP_AMMO_MAX = 2
	self.b682.stats.damage = 24
	self.b682.stats.spread = 17
	self.b682.stats.recoil = 4
	self.b682.stats.concealment = 15
	self.b682.fire_mode_data.fire_rate = 60 / 500

	-- Breaker
	self.boot.CLIP_AMMO_MAX = 5
	self.boot.stats.damage = 24
	self.boot.stats.spread = 13
	self.boot.stats.recoil = 8
	self.boot.stats.concealment = 20
	self.boot.fire_mode_data.fire_rate = 60 / 60

	-- Claire
	self.coach.CLIP_AMMO_MAX = 2
	self.coach.stats.damage = 24
	self.coach.stats.spread = 15
	self.coach.stats.recoil = 8
	self.coach.stats.concealment = 16
	self.coach.fire_mode_data.fire_rate = 60 / 500
	self.coach.reload_speed_multiplier = 0.85
	self.coach.timers.reload_not_empty = 1.60		
	self.coach.timers.reload_empty = self.coach.timers.reload_not_empty
	
	-- LMGs and Miniguns

	-- Bootleg
	self.tecci.categories = { "lmg" }
	self.tecci.CLIP_AMMO_MAX = 100
	self.tecci.stats.damage = 18
	self.tecci.stats.spread = 9
	self.tecci.stats.recoil = 14
	self.tecci.stats.concealment = 19
	self.tecci.fire_mode_data.fire_rate = 60 / 800
	self.tecci.CAN_TOGGLE_FIREMODE = false
	--self.tecci.spray = spray_tables.lmg_right
	--self.tecci.recoil_recovery_timer = recovery_tables.mid

	-- Campbell
	self.kacchainsaw.CLIP_AMMO_MAX = 200
	self.kacchainsaw.stats.damage = 18
	self.kacchainsaw.stats.spread = 10
	self.kacchainsaw.stats.recoil = 7
	self.kacchainsaw.stats.concealment = 14
	self.kacchainsaw.fire_mode_data.fire_rate = 60 / 550
	--self.kacchainsaw.spray = spray_tables.lmg_left
	--self.kacchainsaw.recoil_recovery_timer = recovery_tables.high

	-- MA-17
	self.kacchainsaw_flamethrower.CLIP_AMMO_MAX = 75
	self.kacchainsaw_flamethrower.stats.damage = 24
	self.kacchainsaw_flamethrower.stats.spread = 0
	self.kacchainsaw_flamethrower.stats.recoil = 0
	self.kacchainsaw_flamethrower.stats.concealment = 20
	self.kacchainsaw_flamethrower.fire_mode_data.fire_rate = 60 / 2000
	self.kacchainsaw_flamethrower.flame_max_range = 1000
	self.kacchainsaw_flamethrower.dot_data_name = "weapon_kacchainsaw_flamethrower"

	-- KSP
	self.m249.CLIP_AMMO_MAX = 200
	self.m249.stats.damage = 20
	self.m249.stats.spread = 10
	self.m249.stats.recoil = 8
	self.m249.stats.concealment = 10
	self.m249.fire_mode_data.fire_rate = 60 / 900
	self.m249.reload_speed_multiplier = 0.85

	-- Buzzsaw
	self.mg42.CLIP_AMMO_MAX = 50
	self.mg42.stats.damage = 20
	self.mg42.stats.spread = 10
	self.mg42.stats.recoil = 8
	self.mg42.stats.concealment = 10
	self.mg42.fire_mode_data.fire_rate = 60 / 1200

	-- RPK
	self.rpk.CLIP_AMMO_MAX = 75
	self.rpk.stats.damage = 24
	self.rpk.stats.spread = 12
	self.rpk.stats.recoil = 7
	self.rpk.stats.concealment = 13
	self.rpk.fire_mode_data.fire_rate = 60 / 650

	-- Versteckt
	self.hk51b.CLIP_AMMO_MAX = 30
	self.hk51b.stats.damage = 24
	self.hk51b.stats.spread = 9
	self.hk51b.stats.recoil = 2
	self.hk51b.stats.concealment = 20
	self.hk51b.fire_mode_data.fire_rate = 60 / 900
	self.hk51b.timers.deploy_bipod = nil

	-- Brenner
	self.hk21.CLIP_AMMO_MAX = 100
	self.hk21.stats.damage = 28
	self.hk21.stats.spread = 12
	self.hk21.stats.recoil = 5
	self.hk21.stats.concealment = 10
	self.hk21.fire_mode_data.fire_rate = 60 / 800

	-- KSP 58
	self.par.CLIP_AMMO_MAX = 75
	self.par.stats.damage = 28
	self.par.stats.spread = 14
	self.par.stats.recoil = 5
	self.par.stats.concealment = 10
	self.par.fire_mode_data.fire_rate = 60 / 750
	
	-- M60
	self.m60.CLIP_AMMO_MAX = 100
	self.m60.stats.damage = 32
	self.m60.stats.spread = 13
	self.m60.stats.recoil = 6
	self.m60.stats.concealment = 10
	self.m60.fire_mode_data.fire_rate = 60 / 550

	-- Akron
	self.hcar.CLIP_AMMO_MAX = 20
	self.hcar.stats.damage = 36
	self.hcar.stats.spread = 16
	self.hcar.stats.recoil = 2
	self.hcar.stats.concealment = 14
	self.hcar.fire_mode_data.fire_rate = 60 / 600
	self.hcar.CAN_TOGGLE_FIREMODE = false

	-- Hailstorm
	self.hailstorm.CLIP_AMMO_MAX = 120
	self.hailstorm.stats.damage = 16
	self.hailstorm.stats.spread = 13
	self.hailstorm.stats.recoil = 14
	self.hailstorm.stats.concealment = 12
	self.hailstorm.fire_mode_data.fire_rate = 60 / 2000
	self.hailstorm.fire_mode_data.volley.damage_mul = 1
	self.hailstorm.fire_mode_data.volley.ammo_usage = 30
	self.hailstorm.fire_mode_data.volley.rays = 15
	self.hailstorm.fire_mode_data.volley.spread_mul = nil
	self.hailstorm.fire_mode_data.volley.can_shoot_through_wall = true
	self.hailstorm.kick.volley.standing = { 3.8, 4, -0.3, 0.3 }
	self.hailstorm.has_description = true
	self.hailstorm.desc_id = "bm_w_ray_desc"
	
	-- Microgun
	self.shuno.CLIP_AMMO_MAX = 750
	self.shuno.stats.damage = 20
	self.shuno.stats.spread = 7
	self.shuno.stats.recoil = 9
	self.shuno.stats.concealment = 6
	self.shuno.fire_mode_data.fire_rate = 60 / 3000
	self.shuno.has_description = true
	self.shuno.desc_id = "bm_w_ray_desc"
	
	-- Minigun
	self.m134.CLIP_AMMO_MAX = 600
	self.m134.stats.damage = 24
	self.m134.stats.spread = 9
	self.m134.stats.recoil = 7
	self.m134.stats.concealment = 6
	self.m134.fire_mode_data.fire_rate = 60 / 3000
	self.m134.sprint_exit_time = 0.8
	self.m134.exit_run_speed_multiplier = 2
	--self.m134.spray = spray_tables.mini
	--self.m134.recoil_recovery_timer = recovery_tables.high
	self.m134.has_description = true
	self.m134.desc_id = "bm_w_ray_desc"
	
	-- Snipers

	-- Contractor
	self.tti.CLIP_AMMO_MAX = 20
	self.tti.stats.damage = 32
	self.tti.stats.spread = 20
	self.tti.stats.recoil = 6
	self.tti.stats.concealment = 16
	self.tti.fire_mode_data.fire_rate = 60 / 150
	self.tti.reload_speed_multiplier = 0.85
	self.tti.stats_modifiers = { damage =  2 }

	-- Grom
	self.siltstone.CLIP_AMMO_MAX = 10
	self.siltstone.stats.damage = 32
	self.siltstone.stats.spread = 23
	self.siltstone.stats.recoil = 6
	self.siltstone.stats.concealment = 16
	self.siltstone.fire_mode_data.fire_rate = 60 / 150
	self.siltstone.stats_modifiers = { damage =  2 }

	-- Kang Arms
	self.qbu88.CLIP_AMMO_MAX = 10
	self.qbu88.stats.damage = 32
	self.qbu88.stats.spread = 21
	self.qbu88.stats.recoil = 13
	self.qbu88.stats.concealment = 19
	self.qbu88.fire_mode_data.fire_rate = 60 / 250
	self.qbu88.fire_rate_multiplier = 200 / 250
	self.qbu88.stats_modifiers = { damage =  2 }
	
	-- North Star
	self.victor.CLIP_AMMO_MAX = 10
	self.victor.stats.damage = 32
	self.victor.stats.spread = 18
	self.victor.stats.recoil = 7
	self.victor.stats.concealment = 16
	self.victor.fire_mode_data.fire_rate = 60 / 150
	self.victor.stats_modifiers = { damage =  2 }

	-- Lebensauger
	self.wa2000.CLIP_AMMO_MAX = 5
	self.wa2000.stats.damage = 40
	self.wa2000.stats.spread = 21
	self.wa2000.stats.recoil = 6
	self.wa2000.stats.concealment = 18
	self.wa2000.fire_mode_data.fire_rate = 60 / 120
	self.wa2000.stats_modifiers = { damage =  2 }

	-- Rangehitter
	self.sbl.use_data.selection_index = 1
	self.sbl.CLIP_AMMO_MAX = 6
	self.sbl.stats.damage = 40
	self.sbl.stats.spread = 22
	self.sbl.stats.recoil = 6
	self.sbl.stats.concealment = 20
	self.sbl.fire_mode_data.fire_rate = 60 / 70
	self.sbl.fire_rate_multiplier = 90 / 70
	self.sbl.stats_modifiers = { damage = 2 }

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
	self.r700.CLIP_AMMO_MAX = 5
	self.r700.stats.damage = 24
	self.r700.stats.spread = 24
	self.r700.stats.recoil = 8
	self.r700.stats.concealment = 16
	self.r700.fire_mode_data.fire_rate = 60 / 60
	self.r700.fire_rate_multiplier = 75 / 60
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
	self.r93.stats.concealment = 12
	self.r93.fire_mode_data.fire_rate = 60 / 50
	self.r93.stats_modifiers = { damage = 10 }

	-- Nagant
	self.mosin.CLIP_AMMO_MAX = 5
	self.mosin.stats.damage = 24
	self.mosin.stats.spread = 24
	self.mosin.stats.recoil = 4
	self.mosin.stats.concealment = 15
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

	-- Amaroq
	self.awp.CLIP_AMMO_MAX = 5
	self.awp.stats.damage = 36
	self.awp.stats.spread = 23
	self.awp.stats.recoil = 4
	self.awp.stats.concealment = 12
	self.awp.fire_mode_data.fire_rate = 60 / 45
	self.awp.stats_modifiers = { damage = 10 }
	
	-- Aran
	self.contender.CLIP_AMMO_MAX = 1
	self.contender.stats.damage = 36
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

	-- Thanatos
	self.m95.CLIP_AMMO_MAX = 5
	self.m95.stats.damage = 48
	self.m95.stats.spread = 24
	self.m95.stats.recoil = 2
	self.m95.stats.concealment = 8
	self.m95.fire_mode_data.fire_rate = 60 / 40
	self.m95.fire_rate_multiplier = 45 / 40
	self.m95.stats_modifiers = { damage = 10 }

	-- Musket
	self.bessy.CLIP_AMMO_MAX = 1
	self.bessy.stats.damage = 60
	self.bessy.stats.spread = 24
	self.bessy.stats.recoil = 1
	self.bessy.stats.concealment = 6
	self.bessy.fire_mode_data.fire_rate = 60 / 30
	self.bessy.stats_modifiers = { damage = 20 }
	self.bessy.total_ammo_mul = 10 / 3
	self.bessy.pickup_mul = self.bessy.total_ammo_mul

	-- Specials

	-- Airbow
	self.ecp.CLIP_AMMO_MAX = 6
	self.ecp.stats.damage = 60
	self.ecp.stats.spread = 20
	self.ecp.stats.recoil = 22
	self.ecp.stats.concealment = 20
	self.ecp.fire_mode_data.fire_rate = 60 / 120
	self.ecp.stats_modifiers = { damage = 2 }

	-- Pistol Crossbow
	self.hunter.CLIP_AMMO_MAX = 1
	self.hunter.stats.damage = 40
	self.hunter.stats.spread = 25
	self.hunter.stats.recoil = 25
	self.hunter.stats.concealment = 28
	self.hunter.fire_mode_data.fire_rate = 60 / 60
	self.hunter.stats_modifiers = { damage = 2 }

	-- Light Crossbow
	self.frankish.CLIP_AMMO_MAX = 1
	self.frankish.stats.damage = 60
	self.frankish.stats.spread = 25
	self.frankish.stats.recoil = 25
	self.frankish.stats.concealment = 25
	self.frankish.fire_mode_data.fire_rate = 60 / 45
	self.frankish.stats_modifiers = { damage = 2 }

	-- Heavy Crossbow
	self.arblast.CLIP_AMMO_MAX = 1
	self.arblast.stats.damage = 60
	self.arblast.stats.spread = 25
	self.arblast.stats.recoil = 25
	self.arblast.stats.concealment = 20
	self.arblast.fire_mode_data.fire_rate = 60 / 30
	self.arblast.stats_modifiers = { damage = 5 }
	self.arblast.reload_speed_multiplier = 1.3

	-- Plainsrider
	self.plainsrider.CLIP_AMMO_MAX = 1
	self.plainsrider.stats.damage = 60
	self.plainsrider.stats.spread = 25
	self.plainsrider.stats.recoil = 25
	self.plainsrider.stats.concealment = 24
	self.plainsrider.fire_mode_data.fire_rate = 60 / 300
	self.plainsrider.stats_modifiers = { damage = 2 }

	self.long.CLIP_AMMO_MAX = 1
	self.long.stats.damage = 60
	self.long.stats.spread = 25
	self.long.stats.recoil = 25
	self.long.stats.concealment = 22
	self.long.fire_mode_data.fire_rate = 60 / 300
	self.long.stats_modifiers = { damage = 5 }

	self.elastic.CLIP_AMMO_MAX = 1
	self.elastic.stats.damage = 60
	self.elastic.stats.spread = 25
	self.elastic.stats.recoil = 25
	self.elastic.stats.concealment = 22
	self.elastic.fire_mode_data.fire_rate = 60 / 300
	self.elastic.stats_modifiers = { damage = 5 }

	-- Basilisk
	self.ms3gl.projectile_types = {
		launcher_incendiary = "launcher_incendiary_ms3gl",
		launcher_electric = "launcher_electric_ms3gl",
		launcher_poison = "launcher_poison_ms3gl",
	}
	self.ms3gl.CLIP_AMMO_MAX = 3
	self.ms3gl.stats.damage = 40
	self.ms3gl.stats.spread = 16
	self.ms3gl.stats.recoil = 20
	self.ms3gl.stats.concealment = 24
	self.ms3gl.fire_mode_data.fire_rate = 60 / 90
	self.ms3gl.timers.equip = 0.75
	self.ms3gl.stats_modifiers = { damage = 6 }
	self.ms3gl.FIRE_MODE = "single"
	self.ms3gl.CAN_TOGGLE_FIREMODE = false

	-- Piglet
	self.m32.projectile_types = {
		launcher_incendiary = "launcher_incendiary_m32",
		launcher_electric = "launcher_electric_m32",
		launcher_poison = "launcher_poison_m32",
	}
	self.m32.CLIP_AMMO_MAX = 6
	self.m32.stats.damage = 40
	self.m32.stats.spread = 20
	self.m32.stats.recoil = 22
	self.m32.stats.concealment = 16
	self.m32.fire_mode_data.fire_rate = 60 / 100
	self.m32.fire_rate_multiplier = 120 / 100
	self.m32.reload_speed_multiplier = 1.45
	self.m32.stats_modifiers = { damage = 6 }

	-- Arbiter
	self.arbiter.projectile_types = {
		launcher_incendiary = "launcher_incendiary_arbiter",
		launcher_electric = "launcher_electric_arbiter",
		launcher_poison = "launcher_poison_arbiter",
	}
	self.arbiter.use_data.selection_index = 2
	self.arbiter.CLIP_AMMO_MAX = 5
	self.arbiter.stats.damage = 40
	self.arbiter.stats.spread = 24
	self.arbiter.stats.recoil = 10
	self.arbiter.stats.concealment = 20
	self.arbiter.fire_mode_data.fire_rate = 60 / 80
	self.arbiter.fire_rate_multiplier = 75 / 80
	self.arbiter.stats_modifiers = { damage = 6 }
	
	-- GL40
	self.gre_m79.projectile_types = {
		launcher_incendiary = "launcher_incendiary_m79",
		launcher_electric = "launcher_electric_m79",
		launcher_poison = "launcher_poison_m79",
	}
	self.gre_m79.use_data.selection_index = 1
	self.gre_m79.CLIP_AMMO_MAX = 1
	self.gre_m79.stats.damage = 60
	self.gre_m79.stats.spread = 24
	self.gre_m79.stats.recoil = 20
	self.gre_m79.stats.concealment = 22
	self.gre_m79.fire_mode_data.fire_rate = 60 / 60
	self.gre_m79.stats_modifiers = { damage = 6 }

	-- China Puff
	self.china.projectile_types = {
		launcher_incendiary = "launcher_incendiary_china",
		launcher_electric = "launcher_electric_china",
		launcher_poison = "launcher_poison_china",
	}
	self.china.use_data.selection_index = 2
	self.china.CLIP_AMMO_MAX = 3
	self.china.stats.damage = 60
	self.china.stats.spread = 22
	self.china.stats.recoil = 20
	self.china.stats.concealment = 15
	self.china.fire_mode_data.fire_rate = 60 / 50
	self.china.fire_rate_multiplier = 45 / 50
	self.china.stats_modifiers = { damage = 6 }
	
	-- Compact 40
	self.slap.projectile_types = {
		launcher_incendiary = "launcher_incendiary_slap",
		launcher_electric = "launcher_electric_slap",
		launcher_poison = "launcher_poison_slap",
	}
	self.slap.CLIP_AMMO_MAX = 1
	self.slap.stats.damage = 60
	self.slap.stats.spread = 22
	self.slap.stats.recoil = 22
	self.slap.stats.concealment = 24
	self.slap.fire_mode_data.fire_rate = 60 / 60
	self.slap.reload_speed_multiplier = 1.15
	self.slap.timers.reload_not_empty = 3.1
	self.slap.timers.reload_empty = self.slap.timers.reload_not_empty
	self.slap.stats_modifiers = { damage = 6 }

	-- Commando 101
	self.ray.use_data.selection_index = 2
	table.insert(self.ray.categories, "heavy")
	self.ray.CLIP_AMMO_MAX = 4
	self.ray.stats.damage = 72
	self.ray.stats.spread = 24
	self.ray.stats.recoil = 24
	self.ray.stats.concealment = 4
	self.ray.fire_mode_data.fire_rate = 60 / 60
	self.ray.stats_modifiers = { damage = 10 }
	self.ray.total_ammo_mul = 2
	self.ray.pickup_mul = 0

	-- RPG
	table.insert(self.rpg7.categories, "heavy")
	self.rpg7.CLIP_AMMO_MAX = 1
	self.rpg7.stats.damage = 96
	self.rpg7.stats.spread = 24
	self.rpg7.stats.recoil = 24
	self.rpg7.stats.concealment = 4
	self.rpg7.fire_mode_data.fire_rate = 60 / 30
	self.rpg7.stats_modifiers = { damage = 50 }
	self.rpg7.total_ammo_mul = 5
	self.rpg7.pickup_mul = 0

	-- Flamethrowers

	-- MK2
	self.flamethrower_mk2.CLIP_AMMO_MAX = 300
	self.flamethrower_mk2.stats.damage = 18
	self.flamethrower_mk2.stats.spread = 0
	self.flamethrower_mk2.stats.recoil = 0
	self.flamethrower_mk2.stats.concealment = 16
	self.flamethrower_mk2.fire_mode_data.fire_rate = 60 / 2000
	self.flamethrower_mk2.flame_max_range = 1000
	self.flamethrower_mk2.dot_data_name = "weapon_flamethrower_mk2"
	self.flamethrower_mk2.has_description = true
	self.flamethrower_mk2.desc_id = "bm_w_ray_desc"
	
	-- MA-17
	self.system.CLIP_AMMO_MAX = 150
	self.system.stats.damage = 18
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
	self.money.CLIP_AMMO_MAX = 150
	self.money.stats.damage = 24
	self.money.stats.spread = 0
	self.money.stats.recoil = 0
	self.money.stats.concealment = 20
	self.money.fire_mode_data.fire_rate = 60 / 1200
	self.money.flame_max_range = 1300
	self.money.dot_data_name = "weapon_money"
	self.money.has_description = true
	self.money.desc_id = "bm_w_ray_desc"
	
	-- OVE9000 Saw
	self.saw.CLIP_AMMO_MAX = 150
	self.saw.stats.damage = 24
	self.saw.stats.spread = 3
	self.saw.stats.recoil = 7
	self.saw.stats.concealment = 16
	self.saw.fire_mode_data.fire_rate = 60 / 400

	self.saw_secondary = deep_clone(self.saw)
	self.saw_secondary.parent_weapon_id = "saw"
	self.saw_secondary.use_data.selection_index = 1
	self.saw_secondary.animations.reload_name_id = "saw"
	self.saw_secondary.use_stance = "saw"
	self.saw_secondary.texture_name = "saw"
	self.saw_secondary.weapon_hold = "saw"

	-- Midland Ranch Turret
	self.ranc_heavy_machine_gun.CLIP_AMMO_MAX = 200
	self.ranc_heavy_machine_gun.stats.damage = 60
	self.ranc_heavy_machine_gun.stats.spread = 19
	self.ranc_heavy_machine_gun.stats.recoil = 21
	self.ranc_heavy_machine_gun.stats.concealment = 20
	self.ranc_heavy_machine_gun.fire_mode_data.fire_rate = 60 / 400
	self.ranc_heavy_machine_gun.stats_modifiers = { damage = 2 }

	self:_init_weapons()
	self:_wipe_akimbo()
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

	self.deagle_npc.CLIP_AMMO_MAX = 7
	self.deagle_npc.usage = "is_revolver"
	self.deagle_npc.anim_usage = "is_pistol"

	self.ump_npc.sounds.prefix = self.schakal_crew.sounds.prefix

	self.akmsu_smg_npc = copy_data(self.akmsu_smg_npc, self.mp5_npc, self.akmsu_crew)

	self.asval_smg_npc.sounds.prefix = "val_npc"
	self.asval_smg_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"

	self.shepheard_npc = copy_data(self.shepheard_npc, self.mp5_npc, self.shepheard_crew)

	self.mac11_npc.sounds.prefix = self.mac10_crew.sounds.prefix

	self.sr2_smg_npc.sounds.prefix = self.sr2_crew.sounds.prefix

	self.r870_yellow_npc = deep_clone(self.r870_npc)

	self.benelli_npc = copy_data(self.benelli_npc, self.r870_npc, self.ben_crew)

	self.mossberg_npc.usage = "is_double_barrel"
	self.mossberg_npc.reload = "looped"
	self.mossberg_npc.looped_reload_single = true

	self.saiga_npc.CLIP_AMMO_MAX = 20

	self.aa12_npc = copy_data(self.aa12_npc, self.saiga_npc, self.aa12_crew)

	self.sko12_conc_npc = copy_data(self.sko12_conc_npc, self.saiga_npc, self.sko12_crew)
	self.sko12_conc_npc.bullet_class = nil
	self.sko12_conc_npc.concussion_data = nil

	self.rpk_lmg_npc = copy_data(self.rpk_lmg_npc, self.m249_npc, self.rpk_crew)

	self.m14_npc.sounds.prefix = self.heavy_snp_npc.sounds.prefix
	self.m14_npc.usage = "is_sniper"
	self.m14_npc.trail = "effects/particles/weapons/sniper_trail"
	self.m14_npc.CLIP_AMMO_MAX = 10
	--self.m14_npc.armor_piercing = true

	self.dmr_npc.sounds.prefix = self.heavy_snp_npc.sounds.prefix
	self.dmr_npc.usage = "is_sniper"
	self.dmr_npc.trail = "effects/particles/weapons/sniper_trail"
	self.dmr_npc.CLIP_AMMO_MAX = 10
	--self.dmr_npc.armor_piercing = true

	self.heavy_snp_npc.usage = "is_sniper"
	self.heavy_snp_npc.trail = "effects/particles/weapons/sniper_trail"
	self.heavy_snp_npc.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
	self.heavy_snp_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_sniper"
	
	self.m14_sniper_npc.usage = "is_sniper"
	self.m14_sniper_npc.trail = "effects/particles/weapons/sniper_trail"
	self.m14_sniper_npc.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
	self.m14_sniper_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_sniper"

	self.svd_snp_npc.usage = "is_sniper"
	self.svd_snp_npc.trail = "effects/particles/weapons/sniper_trail"
	self.svd_snp_npc.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
	self.svd_snp_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_sniper"

	self.svdsil_snp_npc.usage = "is_sniper"
	self.svdsil_snp_npc.trail = "effects/particles/weapons/sniper_trail"
	self.svdsil_snp_npc.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
	self.svdsil_snp_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_sniper"

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

local diff_i = Eclipse.utils.difficulty_index()
local diff_i_no_easy = Eclipse.utils.difficulty_index_no_easy()

local turret_damage_mul = {
	{ 0, 2 },
	{ 1500, 1 },
	{ 3000, 0.5 },
	{ 10000, 0 },
}
local suppression = {
	is_sniper = 2,
	is_shotgun_pump = 2,
	is_shotgun_mag = 2,
	is_double_barrel = 2,
	is_lmg = 1.5,
	mini = 1.5,
	is_flamethrower = 0.5,
}
local alert_sizes = {
	is_sniper = 10000,
	is_lmg = 6000,
	mini = 6000,
	is_smg = 3500,
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
			v.HEALTH_INIT = 200 + (50 * diff_i_no_easy)
			v.SHIELD_HEALTH_INIT = 40  + (10 * diff_i_no_easy)
			v.CLIP_SIZE = 300
			v.BAG_DMG_MUL = 20
			v.SHIELD_DMG_MUL = 1
			v.FIRE_DMG_MUL = 1
			v.EXPLOSION_DMG_MUL = 5
			v.SHIELD_DAMAGE_CLAMP = nil
			v.BODY_DAMAGE_CLAMP = nil
		elseif k:match("_npc$") then
			v.DAMAGE = 1
			v.spread = v.rays and v.rays > 1 and 6 or 0
			v.suppression = (suppression[v.usage] or 1) * (v.armor_piercing and 1.5 or 1) * (v.has_suppressor and 0.2 or 1)
			v.alert_size = (alert_sizes[v.usage] or 5000) * (v.has_suppressor and 0.2 or 1)
			v.muzzleflash = v.rays and v.rays > 1 and "effects/payday2/particles/weapons/shotgun/sho_muzzleflash" or v.muzzleflash
			
			local is_uzi = v.reload == "uzi"

			if v.usage == "is_shotgun_mag" then
				v.auto = { fire_rate = 60 / 300 }
			elseif v.usage == "is_smg" and not is_uzi then
				v.auto = { fire_rate = 60 / 500 }
			elseif v.usage == "is_smg" and is_uzi then
				v.auto = { fire_rate = 60 / 600 }
			elseif v.usage == "is_lmg" then
				v.auto = { fire_rate = 60 / 750 }
			elseif v.usage == "is_flamethrower" then
				v.auto = { fire_rate = 60 / 1200 }
			elseif v.usage == "mini" then
				v.auto = { fire_rate = 60 / 3000 }
			else
				v.auto = { fire_rate = 60 / 400 }
			end
		elseif k:match("_crew$") then
			local player_id = k:gsub("_crew$", ""):gsub("_secondary$", ""):gsub("_primary$", "")
			local player_weapon = crew_weapon_mapping[player_id] and self[crew_weapon_mapping[player_id]] or self[player_id]
			if player_weapon then
				v.use_data.selection_index = player_weapon.use_data and player_weapon.use_data.selection_index or v.use_data.selection_index
				v.CLIP_AMMO_MAX = player_weapon.CLIP_AMMO_MAX
				v.muzzleflash = player_weapon.muzzleflash
				v.shell_ejection = player_weapon.shell_ejection
				v.alert_size = self.stats.alert_size[player_weapon.stats.alert_size] or v.alert_size
				v.suppression = 1

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

				v.DAMAGE = (((mag / burst) * (burst - 1) * rate + (mag / burst - 1) * recoil + 2) / mag)
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