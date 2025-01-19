Hooks:PostHook(WeaponTweakData, "_init_stats", "hits_init_stats", function(self) 
	self.stats.damage = {}
	for i = 0, 1200, 1 do
		table.insert(self.stats.damage, (math.lerp(0.1, 120.1, i / 1200)))
	end 

	self.stats.recoil = {}
	for i = 0, 25, 1 do
		table.insert(self.stats.recoil, (math.lerp(2.5, 0.5, i / 25)))
	end 

	self.stats.spread = {}
	for i = 0, 25, 1 do
		table.insert(self.stats.spread, (math.lerp(1, 0.05, i / 25)))
	end 

	self.stats.spread_moving = {}
	for i = 0, 25, 1 do
		table.insert(self.stats.spread_moving, (math.lerp(1, 0.05, i / 25)))
	end 

	self.stats.suppression = {}
	for i = 4.2, 0.199, -0.2 do
		table.insert(self.stats.suppression, i)
	end

	self.stats.alert_size = { --for some reason alert sizes are halved now lol
		0, --1
		500, --2
		750, --3
		1000, --4
		1250, --5
		1500, --6
		1750, --7
		2000, --8
		2250, --9
		2500, --10
		5000, --11
		5500, --12
		6000, --13
		7000, --14
		8000, --15
		9000, --16
		10000, --17
		12000, --18
		16000, --19
		20000 --20
	}
end)

function WeaponTweakData:_init_weapons()
	local akimbo_mappings = {}
			
	for k, v in pairs(self:get_akimbo_mappings()) do
		akimbo_mappings[v] = k
	end

	for weap_id, weap_data in pairs(self) do

		local ROF = 60 / (weap_data.fire_mode_data and weap_data.fire_mode_data.fire_rate or 0.1)
	
		local no_falloff = {
			optimal_distance = 0, 
			optimal_range = 0, 
			near_falloff = 0, 
			far_falloff = 0, 
			near_multiplier = 1, 
			far_multiplier = 1
		}	
		local no_stance_mults = {
			standing = {
				hipfire = 1,
				crouching = 1,
				steelsight = 1
			},
			moving = {
				hipfire = 1,
				crouching = 1,
				steelsight = 1
			}
		}	
		local base_fire_mode_mul = {
			auto = {
				recoil = 1,
				spread = 1
			},
			single = {
				recoil = 1.2,
				spread = 0.4,
				falloff_range = 1.5,
				fire_rate = math.min(500 / ROF, 1)
			},
			burst = {
				recoil = 0.8,
				spread = 0.6,
				falloff_range = 1
			},
			volley = {}
		}
		
		local base_penetration_damage_mul = {
			shield = 0.5,
			wall = 0.5,
			armor = 0.75,
			enemy = 0.75
		}
	
		if type(weap_data) == "table" and weap_data.stats then

			local cat_map = table.list_to_set(weap_data.categories)

			--catch-all stat setups
			if cat_map.assault_rifle then
				weap_data.stats.suppression = cat_map.dmr and 1 or 11 
				weap_data.stats.alert_size = cat_map.dmr and 19 or 15
				weap_data.steelsight_time = 0.3			
				weap_data.steelsight_move_speed_mul = 0.6
				
				if cat_map.dmr then	
					weap_data.FIRE_MODE = "single"
					weap_data.armor_piercing_chance = 1
					weap_data.can_shoot_through_enemy = true
					weap_data.has_description = true
					weap_data.desc_id = "bm_w_dmr_penetration_desc"				
				end
				
				weap_data.spread_multiplier = {
					standing = {
						hipfire = 1,
						crouching = 0.8,
						steelsight = 0.5
					},
					moving = {
						hipfire = 1.5,
						crouching = 1,
						steelsight = 0.8
					}
				}
				weap_data.recoil_multiplier = {
					standing = {
						hipfire = 1,
						crouching = 1,
						steelsight = 0.8
					},
					moving = {
						hipfire = 1.2,
						crouching = 1,
						steelsight = 1
					}
				}
				
				weap_data.fire_mode_mul = base_fire_mode_mul
				
				weap_data.damage_falloff = {
					optimal_distance = 0, 
					optimal_range = 2500, 
					near_falloff = 0, 
					far_falloff = 1500, 
					near_multiplier = 1, 
					far_multiplier = 0.7
				}	

			elseif cat_map.pistol then
				weap_data.stats.suppression = (cat_map.revolver or cat_map.handcannon) and 9 or 16
				weap_data.stats.alert_size = (cat_map.revolver or cat_map.handcannon) and 15 or 11
				weap_data.steelsight_time = 0.2
				weap_data.total_ammo_mul = weap_data.total_ammo_mul or 1.5
				weap_data.swap_speed_multiplier = weap_data.swap_speed_multiplier or 1.5
				weap_data.steelsight_move_speed_mul = 0.8

				if cat_map.revolver or cat_map.handcannon then
					weap_data.spread_multiplier = {
						standing = {
							hipfire = 2,
							crouching = 0.8,
							steelsight = 0.5
						},
						moving = {
							hipfire = 4,
							crouching = 1,
							steelsight = 2
						}
					}
					weap_data.recoil_multiplier = {
						standing = {
							hipfire = 1.3,
							crouching = 1,
							steelsight = 1
						},
						moving = {
							hipfire = 1.5,
							crouching = 1,
							steelsight = 1
						}
					}
				else				
					weap_data.spread_multiplier = {
						standing = {
							hipfire = 1,
							crouching = 0.8,
							steelsight = 0.6
						},
						moving = {
							hipfire = 1.5,
							crouching = 1,
							steelsight = 0.8
						}
					}
					weap_data.recoil_multiplier = {
						standing = {
							hipfire = 1,
							crouching = 1,
							steelsight = 0.8
						},
						moving = {
							hipfire = 1.2,
							crouching = 1,
							steelsight = 1
						}
					}
				end
	
				weap_data.fire_mode_mul = {
					single = {},
					auto = {
						spread = 1.5,
						falloff_range = 0.75
					},
					burst = {
						recoil = 0.8,
						spread = 1,
						falloff_range = 1
					},
					volley = {}
				}	

				if cat_map.revolver then 
					weap_data.damage_falloff = {
						optimal_distance = 0, 
						optimal_range = 3000, 
						near_falloff = 0, 
						far_falloff = 1000, 
						near_multiplier = 1, 
						far_multiplier = 0.8
					}
				else
					weap_data.damage_falloff = {
						optimal_distance = 0, 
						optimal_range = 2000, 
						near_falloff = 0, 
						far_falloff = 1000, 
						near_multiplier = 1, 
						far_multiplier = 0.7
					}	
				end
					
			elseif cat_map.smg then
				weap_data.stats.suppression = 16
				weap_data.stats.alert_size = 13
				weap_data.steelsight_time = 0.25
				weap_data.total_ammo_mul = weap_data.total_ammo_mul or 1.25
				weap_data.pickup_mul = weap_data.pickup_mul or 1.5
				weap_data.steelsight_move_speed_mul = 0.8
				
				weap_data.spread_multiplier = {
					standing = {
						hipfire = 1,
						crouching = 1,
						steelsight = 0.6
					},
					moving = {
						hipfire = 1.2,
						crouching = 1,
						steelsight = 0.8
					}
				}
				weap_data.recoil_multiplier = {
					standing = {
						hipfire = 1,
						crouching = 1,
						steelsight = 0.8
					},
					moving = {
						hipfire = 1,
						crouching = 1,
						steelsight = 1
					}
				}
				
				weap_data.fire_mode_mul = base_fire_mode_mul

				weap_data.damage_falloff = {
					optimal_distance = 0, 
					optimal_range = 1500, 
					near_falloff = 0, 
					far_falloff = 1000, 
					near_multiplier = 1, 
					far_multiplier = 0.6
				}	
				
			elseif cat_map.shotgun then
				weap_data.stats.suppression = 1
				weap_data.stats.alert_size = 17
				weap_data.steelsight_time = 0.3	
				weap_data.total_ammo_mul = weap_data.total_ammo_mul or 1.5
				weap_data.pickup_mul = weap_data.pickup_mul or 2.5
				weap_data.steelsight_move_speed_mul = 0.6
				weap_data.rays = 8				
		
				weap_data.spread_multiplier = {
					standing = {
						hipfire = 1,
						crouching = 1,
						steelsight = 0.6
					},
					moving = {
						hipfire = 1.5,
						crouching = 1,
						steelsight = 1
					}
				}
				weap_data.recoil_multiplier = {
					standing = {
						hipfire = 1,
						crouching = 1,
						steelsight = 0.8
					},
					moving = {
						hipfire = 1.2,
						crouching = 1,
						steelsight = 1
					}
				}
				
				if not weap_data.auto then
					weap_data.fire_mode_mul = nil
				else
					weap_data.fire_mode_mul = {
						single = {
							fire_rate = math.min(500 / ROF, 1)
						},
						auto = {},
						burst = {
							recoil = 0.8,
							spread = 0.6
						},
						volley = {}
					}						
				end

				weap_data.damage_falloff = {
					optimal_distance = 0, 
					optimal_range = 2500, 
					near_falloff = 0, 
					far_falloff = 500, 
					near_multiplier = 1, 
					far_multiplier = 0.5
				}	
				
			elseif cat_map.lmg then
				weap_data.stats.suppression = 3
				weap_data.stats.alert_size = 18
				weap_data.steelsight_time = 0.4
				weap_data.bipod_deploy_multiplier = 1
				weap_data.bipod_camera_spin_limit = 40
				weap_data.bipod_camera_pitch_limit = 15		
				weap_data.total_ammo_mul = weap_data.total_ammo_mul or 2
				weap_data.pickup_mul = weap_data.pickup_mul or 1.5
				weap_data.steelsight_move_speed_mul = 0.4
		
				if weap_data.no_steelsight then
					weap_data.spread_multiplier = {
						standing = {
							hipfire = 1,
							crouching = 0.6,
							steelsight = 1
						},
						moving = {
							hipfire = 2,
							crouching = 0.6,
							steelsight = 1
						}
					}
					weap_data.recoil_multiplier = {
						standing = {
							hipfire = 1,
							crouching = 0.7,
							steelsight = 1
						},
						moving = {
							hipfire = 1.2,
							crouching = 0.7,
							steelsight = 1
						}
					}
				else
					weap_data.spread_multiplier = {
						standing = {
							hipfire = 2,
							crouching = 0.7,
							steelsight = 0.6
						},
						moving = {
							hipfire = 4,
							crouching = 0.7,
							steelsight = 2
						}
					}
					weap_data.recoil_multiplier = {
						standing = {
							hipfire = 1.2,
							crouching = 0.8,
							steelsight = 0.8
						},
						moving = {
							hipfire = 1.5,
							crouching = 0.8,
							steelsight = 1
						}
					}
				end	
				
				weap_data.stance_range_mul = {
					steelsight = weap_data.no_steelsight and 1 or 1.5,
					bipod = 2
				}
				
				weap_data.fire_mode_mul = nil		
			
				weap_data.damage_falloff = {
					optimal_distance = 0, 
					optimal_range = 1000, 
					near_falloff = 0, 
					far_falloff = 1000, 
					near_multiplier = 1, 
					far_multiplier = 0.6
				}	

			elseif cat_map.minigun then
				weap_data.stats.suppression = 6
				weap_data.stats.alert_size = 18
				weap_data.steelsight_time = 0.4
				weap_data.total_ammo_mul = weap_data.total_ammo_mul or 2.25
				weap_data.pickup_mul = weap_data.pickup_mul or 1.5
				weap_data.steelsight_move_speed_mul = 0.4
				
				if weap_data.no_steelsight then
					weap_data.spread_multiplier = {
						standing = {
							hipfire = 1,
							crouching = 0.6,
							steelsight = 1
						},
						moving = {
							hipfire = 2,
							crouching = 0.6,
							steelsight = 1
						}
					}
					weap_data.recoil_multiplier = {
						standing = {
							hipfire = 1,
							crouching = 0.7,
							steelsight = 1
						},
						moving = {
							hipfire = 1.2,
							crouching = 0.7,
							steelsight = 1
						}
					}
				else
					weap_data.spread_multiplier = {
						standing = {
							hipfire = 2,
							crouching = 0.7,
							steelsight = 0.6
						},
						moving = {
							hipfire = 4,
							crouching = 0.7,
							steelsight = 2
						}
					}
					weap_data.recoil_multiplier = {
						standing = {
							hipfire = 1.2,
							crouching = 0.8,
							steelsight = 0.8
						},
						moving = {
							hipfire = 1.5,
							crouching = 0.8,
							steelsight = 1
						}
					}
				end			

				weap_data.fire_mode_mul = nil

				weap_data.stance_range_mul = {
					steelsight = weap_data.no_steelsight and 1 or 1.5,
					bipod = 2
				}
				
				weap_data.damage_falloff = {
					optimal_distance = 0, 
					optimal_range = 1000, 
					near_falloff = 0, 
					far_falloff = 1000, 
					near_multiplier = 1, 
					far_multiplier = 0.6
				}	
							
			elseif cat_map.snp then
				weap_data.stats.suppression = 1
				weap_data.stats.alert_size = 20
				weap_data.steelsight_time = 0.35
				weap_data.steelsight_move_speed_mul = 0.5
				
				weap_data.spread_multiplier = {
					standing = {
						hipfire = 3,
						crouching = 0.8,
						steelsight = 0.4
					},
					moving = {
						hipfire = 6,
						crouching = 1,
						steelsight = 3
					}
				}
				weap_data.recoil_multiplier = {
					standing = {
						hipfire = 1.4,
						crouching = 0.8,
						steelsight = 1
					},
					moving = {
						hipfire = 1.6,
						crouching = 1,
						steelsight = 1
					}
				}
				
				if weap_data.fire_mode_data and weap_data.fire_mode_data.fire_rate > 1 then
					weap_data.fire_rate_multiplier = weap_data.fire_mode_data.fire_rate 
				end	
				
				weap_data.fire_mode_mul = nil
				
				weap_data.damage_falloff = no_falloff

			elseif cat_map.bow then
				weap_data.stats.suppression = 1
				weap_data.stats.alert_size = 1
				weap_data.steelsight_time = 0.3	
				weap_data.bow_reload_speed_multiplier = nil
				weap_data.stats.reload = 200
				weap_data.armor_piercing_chance = 1			

				weap_data.spread_multiplier = no_stance_mults
				weap_data.recoil_multiplier = no_stance_mults
		
				if weap_data.charge_data and weap_data.charge_data.max_t then
					weap_data.charge_data.max_t = weap_data.charge_data.max_t * 0.5
				end

				weap_data.fire_mode_mul = nil
			
				weap_data.damage_falloff = no_falloff	
				
			elseif cat_map.crossbow then
				weap_data.stats.suppression = 1
				weap_data.stats.alert_size = 1
				weap_data.steelsight_time = 0.3			
				weap_data.armor_piercing_chance = 1
				weap_data.steelsight_move_speed_mul = 0.6
			
				weap_data.spread_multiplier = no_stance_mults
				weap_data.recoil_multiplier = no_stance_mults

				weap_data.fire_mode_mul = nil
				
				weap_data.damage_falloff = no_falloff
								
			elseif cat_map.grenade_launcher or cat_map.rocket_launcher then
				weap_data.stats.suppression = 1
				weap_data.stats.alert_size = 17
				weap_data.steelsight_time = 0.3		
				weap_data.pickup_mul = weap_data.pickup_mul or cat_map.rocket_launcher and 1 or 0.25
				weap_data.steelsight_move_speed_mul = 0.6
				weap_data.rays = 8

				weap_data.spread_multiplier = {
					standing = {
						hipfire = 1,
						crouching = 1,
						steelsight = 0.6
					},
					moving = {
						hipfire = 1.5,
						crouching = 1,
						steelsight = 1
					}
				}
				weap_data.recoil_multiplier = {
					standing = {
						hipfire = 1,
						crouching = 1,
						steelsight = 0.8
					},
					moving = {
						hipfire = 1.2,
						crouching = 1,
						steelsight = 1
					}
				}

				weap_data.fire_mode_mul = nil
				
				weap_data.damage_falloff = no_falloff
				
			elseif cat_map.flamethrower then
				weap_data.stats.suppression = 1
				weap_data.stats.alert_size = 11
				weap_data.steelsight_time = 0.35
				weap_data.total_ammo_mul = weap_data.total_ammo_mul or 1.5
				weap_data.pickup_mul = weap_data.pickup_mul or 0.25
				weap_data.steelsight_move_speed_mul = 0.6

				weap_data.spread_multiplier = no_stance_mults
				weap_data.recoil_multiplier = no_stance_mults
		
				weap_data.fire_mode_mul = nil
			
				weap_data.damage_falloff = no_falloff
			
			elseif cat_map.saw then
				weap_data.stats.suppression = 1
				weap_data.stats.alert_size = 6
				weap_data.steelsight_time = 0.3
				weap_data.armor_piercing_chance = 1
				weap_data.hit_alert_size_increase = -9
				weap_data.saw_ammo_usage = 5
				weap_data.steelsight_move_speed_mul = 1
				weap_data.enemy_damage_mul = 2

				weap_data.spread_multiplier = no_stance_mults
				weap_data.recoil_multiplier = no_stance_mults

				weap_data.fire_mode_mul = nil
				
				weap_data.damage_falloff = no_falloff
				
			end
	
			if cat_map.akimbo then
				local single_weapon_data = self[akimbo_mappings[weap_id]] or self[weap_id:sub(3)]
				local akimbo_multiplier = 1.5
				if single_weapon_data then
					local akimbo_reload = weap_data.timers.reload_empty
					local single_reload = single_weapon_data.timers.reload_empty
					single_reload = single_reload * akimbo_multiplier
					
					local akimbo_reload_speed = akimbo_reload / single_reload
					weap_data.reload_speed_multiplier = akimbo_reload_speed
					
					weap_data.stats = single_weapon_data.stats
					weap_data.stats.concealment = weap_data.stats.concealment - 4
					
					weap_data.no_steelsight = true
					
					if cat_map.pistol then
						weap_data.spread_multiplier = {
							standing = {
								hipfire = 1,
								crouching = 1,
								steelsight = 1
							},
							moving = {
								hipfire = 1.3,
								crouching = 1,
								steelsight = 1
							}
						}
						weap_data.recoil_multiplier = {
							standing = {
								hipfire = 1,
								crouching = 1,
								steelsight = 1
							},
							moving = {
								hipfire = 1.2,
								crouching = 1,
								steelsight = 1
							}
						}
					elseif cat_map.handcannon or cat_map.revolver then 
						weap_data.spread_multiplier = {
							standing = {
								hipfire = 1,
								crouching = 1,
								steelsight = 1
							},
							moving = {
								hipfire = 1.5,
								crouching = 1,
								steelsight = 1
							}
						}
						weap_data.recoil_multiplier = {
							standing = {
								hipfire = 1,
								crouching = 1,
								steelsight = 1
							},
							moving = {
								hipfire = 1.4,
								crouching = 1,
								steelsight = 1
							}
						}
					elseif cat_map.smg then 
						weap_data.spread_multiplier = {
							standing = {
								hipfire = 1,
								crouching = 1,
								steelsight = 1
							},
							moving = {
								hipfire = 1.3,
								crouching = 1,
								steelsight = 1
							}
						}
						weap_data.recoil_multiplier = {
							standing = {
								hipfire = 1,
								crouching = 1,
								steelsight = 1
							},
							moving = {
								hipfire = 1.2,
								crouching = 1,
								steelsight = 1
							}
						}
					elseif cat_map.shotgun then
						weap_data.spread_multiplier = {
							standing = {
								hipfire = 1,
								crouching = 1,
								steelsight = 1
							},
							moving = {
								hipfire = 2,
								crouching = 1,
								steelsight = 1
							}
						}
						weap_data.recoil_multiplier = {
							standing = {
								hipfire = 1,
								crouching = 1,
								steelsight = 1
							},
							moving = {
								hipfire = 1.4,
								crouching = 1,
								steelsight = 1
							}
						}
					end
						
					
					if weap_data.damage_falloff then
						weap_data.damage_falloff.optimal_range = weap_data.damage_falloff.optimal_range * 0.8
						weap_data.damage_falloff.far_falloff = weap_data.damage_falloff.far_falloff * 0.8
					end
					
					if weap_data.rays then		
						weap_data.rays = weap_data.rays / 2
					end
					
				end
			end
	
			--round weapon damage to be divisible by 5	
			local damage_modifier = weap_data.stats_modifiers and weap_data.stats_modifiers.damage or 1
			local damage_rounded = (math.floor((weap_data.stats.damage * damage_modifier) / 5) * 5) 
			damage_rounded = math.floor(damage_rounded / damage_modifier)
			
			weap_data.stats.damage = damage_rounded
			weap_data.stats.alert_size = math.clamp(weap_data.stats.alert_size, 1, #self.stats.alert_size)
			weap_data.stats.zoom = 1
			weap_data.panic_suppression_chance = 0.2
			weap_data.sprint_exit_time = weap_data.sprint_exit_time or 0.4		
			weap_data.penetration_damage_mul = weap_data.penetration_damage_mul or base_penetration_damage_mul
			
			if weap_data.damage_melee and weap_data.damage_melee_effect_mul then
				weap_data.damage_melee = 1
				weap_data.damage_melee_effect_mul = 1
			end
		
			if weap_data.kick then				
				if cat_map.assault_rifle then
					weap_data.kick.standing = { 0.8, 1, -0.4, 0.4 }
					weap_data.kick.single = {}
					weap_data.kick.single.standing = { 1, 1.5, -0.2, 0.1 }		
					
				elseif cat_map.smg then
					weap_data.kick.standing = { 0.6, 0.8, -0.6, 0.6 }	
					weap_data.kick.single = {}
					weap_data.kick.single.standing = { 0.8, 1, -0.2, 0.1 }	
				
				elseif cat_map.lmg then
					weap_data.kick.standing = { 0.4, 0.6, -0.8, 0.8 }	
					weap_data.kick.single = {}
					weap_data.kick.single.standing = { 0.6, 0.8, -0.2, 0.1 }	
					
				elseif cat_map.minigun then
					weap_data.kick.standing = { 0.2, 0.4, -0.4, 0.4 }	
					
				elseif cat_map.pistol  then
					weap_data.kick.standing =  { 1, 1.5, -0.2, 0.1 }
					weap_data.kick.auto = {}
					weap_data.kick.auto.standing = { 0.6, 0.8, -0.6, 0.6 }		
											
				elseif cat_map.revolver or cat_map.handcannon then
					weap_data.kick.standing = { 1.5, 2, -0.4, 0.3 }		
					
				elseif cat_map.shotgun or cat_map.grenade_launcher or cat_map.snp then
					weap_data.kick.standing = { 2, 3, -0.5, 0.4 }				
					weap_data.kick.auto = {}
					weap_data.kick.auto.standing = { 1.5, 2, -0.5, 0.5 }	
					
				else	
					weap_data.kick.standing = { 0, 0, 0, 0 }	
				end					

				weap_data.kick.crouching = weap_data.kick.standing
				weap_data.kick.steelsight = weap_data.kick.standing
				
				if weap_data.kick.single and weap_data.kick.single.standing then
					weap_data.kick.single.crouching = weap_data.kick.single.standing
					weap_data.kick.single.steelsight = weap_data.kick.single.standing
				end

				if weap_data.kick.auto and weap_data.kick.auto.standing then
					weap_data.kick.auto.crouching = weap_data.kick.auto.standing
					weap_data.kick.auto.steelsight = weap_data.kick.auto.standing
				end
			end

			local default_burst_cooldown = 0.2
			
			if weap_data.fire_mode_data then
				if weap_data.auto and  weap_data.fire_mode_data.fire_rate then
					weap_data.auto = { fire_rate = weap_data.fire_mode_data.fire_rate }
				end
				
				if weap_data.fire_mode_data.burst_cooldown then	
					weap_data.fire_mode_data.burst_cooldown = default_burst_cooldown
				end
			end
			
			local base_spread = cat_map.rays and 6 or 3
			
			--set spread values
			if weap_data.spread then		
				if cat_map.flamethrower or cat_map.saw then
					weap_data.spread = {
						standing = 0, 
						crouching = 0, 
						steelsight = 0, 
						
						moving_standing = 0, 
						moving_crouching = 0,
						moving_steelsight = 0,
						
						bipod = 0
					}
				else
					weap_data.spread = {
						standing = base_spread,
						crouching = base_spread, 
						steelsight = 1,
						
						moving_standing = base_spread, 
						moving_crouching = base_spread, 
						moving_steelsight = 1,
						
						bipod = weap_data.spread.standing * 0.25
					}
				end		
			end
			
			--set total damage
			weap_data.total_damage = 900 * (weap_data.total_ammo_mul or 1)
			
			if cat_map.akimbo then
				weap_data.total_damage = weap_data.total_damage * 1.5
			end
			
			--set pickup damage	
			weap_data.pickup_damage = 30 * (weap_data.pickup_mul or 1)
			
			--modify total damage based on weapon slot 
			if weap_data.use_data and weap_data.use_data.selection_index == 2 then --primaries
				weap_data.total_damage = weap_data.total_damage
 				
			elseif weap_data.use_data and weap_data.use_data.selection_index == 1 then --secondaries
				weap_data.total_damage = weap_data.total_damage / 2
				
			else --underbarrels etc.
				weap_data.total_damage = weap_data.total_damage / 3
			end	
			
			local burst_only = weap_data.FIRE_MODE == "burst" and not table.contains(weap_data.fire_mode_data.toggable, "auto") 
			local burst_count = weap_data.BURST_COUNT or 1
			
			if burst_only then 
				local total_damage_mul = 0.75 + (burst_count * 0.25)
				weap_data.total_damage = weap_data.total_damage * total_damage_mul
			end
			
			if weap_data.can_shoot_through_enemy and not (cat_map.snp or cat_map.dmr) then
				weap_data.total_damage = weap_data.total_damage / 2
			end	

			if weap_data.has_underbarrel then
				weap_data.total_damage = weap_data.total_damage / 2
			end		

			if weap_data.can_shoot_through_enemy and not (cat_map.snp or cat_map.dmr) then
				weap_data.pickup_damage = weap_data.pickup_damage / 2
			end	

			if weap_data.has_underbarrel then
				weap_data.pickup_damage = weap_data.pickup_damage / 2
			end		
			
			if burst_only then 
				local total_damage_mul = 1 + (burst_count - 1) * 0.25
				weap_data.pickup_damage = weap_data.pickup_damage * total_damage_mul
			end
	
			local weap_dmg = self.stats.damage[math.min(weap_data.stats.damage, #self.stats.damage)] * (weap_data.stats_modifiers and weap_data.stats_modifiers.damage or 1)		
			local clip_dmg = weap_data.CLIP_AMMO_MAX * weap_dmg
		
			if weap_data.AMMO_MAX then
				weap_data.NR_CLIPS_MAX = math.max(1, math.round(weap_data.total_damage / clip_dmg))
				weap_data.AMMO_MAX = weap_data.CLIP_AMMO_MAX * weap_data.NR_CLIPS_MAX
			end
		
			if weap_data.AMMO_PICKUP and weap_data.AMMO_PICKUP[2] > 0 then
				local pickup_dmg_max = weap_data.pickup_damage
				local pickup_dmg_min = pickup_dmg_max / 2

				weap_data.AMMO_PICKUP = { pickup_dmg_min / weap_dmg, pickup_dmg_max / weap_dmg }
			end
		end
	end
end

Hooks:PostHook(WeaponTweakData, "init", "eclipse_init", function(self, tweak_data)
	self.tweak_data = tweak_data

	self.trip_mines = {
		delay = 0.1,
		damage = 200,
		player_damage = 6,
		damage_size = 300,
		alert_radius = 5000
	}

	-- Clarion
	self.famas.CLIP_AMMO_MAX = 30
	self.famas.stats.damage = 40
	self.famas.stats.spread = 13
	self.famas.stats.recoil = 18
	self.famas.stats.reload = 11
	self.famas.stats.concealment = 24
	self.famas.fire_mode_data.fire_rate = 60 / 1000

	-- Valkyria
	self.asval.CLIP_AMMO_MAX = 30
	self.asval.stats.damage = 40
	self.asval.stats.spread = 15
	self.asval.stats.recoil = 17
	self.asval.stats.reload = 11
	self.asval.stats.concealment = 26
	self.asval.fire_mode_data.fire_rate = 60 / 900

	-- Tempest
	self.komodo.CLIP_AMMO_MAX = 30
	self.komodo.stats.damage = 40
	self.komodo.stats.spread = 15
	self.komodo.stats.recoil = 16
	self.komodo.stats.reload = 11
	self.komodo.stats.concealment = 26
	self.komodo.fire_mode_data.fire_rate = 60 / 800
	
	-- AMCAR
	self.amcar.CLIP_AMMO_MAX = 20
	self.amcar.stats.damage = 50
	self.amcar.stats.spread = 14
	self.amcar.stats.recoil = 16
	self.amcar.stats.reload = 11
	self.amcar.stats.concealment = 21
	self.amcar.fire_mode_data.fire_rate = 60 / 750

	-- JP36
	self.g36.CLIP_AMMO_MAX = 30
	self.g36.stats.damage = 50
	self.g36.stats.spread = 14
	self.g36.stats.recoil = 16
	self.g36.stats.reload = 12
	self.g36.stats.concealment = 20
	self.g36.fire_mode_data.fire_rate = 60 / 700
	
	-- Commando 553
	self.s552.CLIP_AMMO_MAX = 30
	self.s552.stats.damage = 50
	self.s552.stats.spread = 14
	self.s552.stats.recoil = 15
	self.s552.stats.reload = 11
	self.s552.stats.concealment = 22
	self.s552.fire_mode_data.fire_rate = 60 / 700

	-- Union
	self.corgi.CLIP_AMMO_MAX = 30
	self.corgi.stats.damage = 50
	self.corgi.stats.spread = 18
	self.corgi.stats.recoil = 18
	self.corgi.stats.reload = 11
	self.corgi.stats.concealment = 20
	self.corgi.fire_mode_data.fire_rate = 60 / 900
	
	-- CAR-4
	self.new_m4.CLIP_AMMO_MAX = 30
	self.new_m4.stats.damage = 60
	self.new_m4.stats.spread = 12
	self.new_m4.stats.recoil = 16
	self.new_m4.stats.reload = 11
	self.new_m4.stats.concealment = 20
	self.new_m4.fire_mode_data.fire_rate = 60 / 775

	-- UAR
	self.aug.CLIP_AMMO_MAX = 30
	self.aug.stats.damage = 60
	self.aug.stats.spread = 17
	self.aug.stats.recoil = 11
	self.aug.stats.reload = 11
	self.aug.stats.concealment = 20
	self.aug.fire_mode_data.fire_rate = 60 / 750
	
	-- Rodion
	self.tkb.CLIP_AMMO_MAX = 60
	self.tkb.stats.damage = 60
	self.tkb.stats.spread = 16
	self.tkb.stats.recoil = 10
	self.tkb.stats.reload = 9
	self.tkb.stats.concealment = 15
	self.tkb.fire_mode_data.fire_rate = 60 / 800
	self.tkb.fire_mode_data.volley = {
		spread_mul = 1,
		damage_mul = 1,
		ammo_usage = 3,
		rays = 3,
		can_shoot_through_wall = false,
		can_shoot_through_shield = true,
		can_shoot_through_enemy = true,
		muzzleflash = "effects/payday2/particles/weapons/tkb_muzzle",
		muzzleflash_silenced = "effects/payday2/particles/weapons/tkb_suppressed"
	}
	
	-- AK5
	self.ak5.CLIP_AMMO_MAX = 30
	self.ak5.stats.damage = 60
	self.ak5.stats.spread = 16
	self.ak5.stats.recoil = 16
	self.ak5.stats.reload = 11
	self.ak5.stats.concealment = 18
	self.ak5.fire_mode_data.fire_rate = 60 / 700
	
	-- Queen's Wrath
	self.l85a2.CLIP_AMMO_MAX = 30
	self.l85a2.stats.damage = 60
	self.l85a2.stats.spread = 17
	self.l85a2.stats.recoil = 16
	self.l85a2.stats.reload = 13
	self.l85a2.stats.concealment = 16
	self.l85a2.fire_mode_data.fire_rate = 60 / 725

	-- Lion's Roar
	self.vhs.CLIP_AMMO_MAX = 30
	self.vhs.stats.damage = 70
	self.vhs.stats.spread = 16
	self.vhs.stats.recoil = 16
	self.vhs.stats.reload = 11
	self.vhs.stats.concealment = 17
	self.vhs.fire_mode_data.fire_rate = 60 / 850

	-- Bootleg
	self.tecci.CLIP_AMMO_MAX = 100
	self.tecci.stats.damage = 70
	self.tecci.stats.spread = 11
	self.tecci.stats.recoil = 14
	self.tecci.stats.reload = 11
	self.tecci.stats.concealment = 12
	self.tecci.fire_mode_data.fire_rate = 60 / 675
	
	-- AK Rifle
	self.ak74.CLIP_AMMO_MAX = 30
	self.ak74.stats.damage = 70
	self.ak74.stats.spread = 13
	self.ak74.stats.recoil = 16
	self.ak74.stats.reload = 11
	self.ak74.stats.concealment = 19
	self.ak74.fire_mode_data.fire_rate = 60 / 650
	
	-- Gecko
	self.galil.CLIP_AMMO_MAX = 35
	self.galil.stats.damage = 70
	self.galil.stats.spread = 13
	self.galil.stats.recoil = 18
	self.galil.stats.reload = 11
	self.galil.stats.concealment = 15
	self.galil.fire_mode_data.fire_rate = 60 / 850
	
	-- CR805
	self.hajk.use_data.selection_index = 2
	self.hajk.categories = { "assault_rifle" }
	self.hajk.CLIP_AMMO_MAX = 30
	self.hajk.stats.damage = 80
	self.hajk.stats.spread = 19
	self.hajk.stats.recoil = 18
	self.hajk.stats.reload = 11
	self.hajk.stats.concealment = 18
	self.hajk.fire_mode_data.fire_rate = 60 / 750

	-- Groza
	self.groza.CLIP_AMMO_MAX = 20
	self.groza.stats.damage = 80
	self.groza.stats.spread = 16
	self.groza.stats.recoil = 14
	self.groza.stats.reload = 11
	self.groza.stats.concealment = 8
	self.groza.fire_mode_data.fire_rate = 60 / 675
	
	-- AMR
	self.m16.CLIP_AMMO_MAX = 30
	self.m16.stats.damage = 90
	self.m16.stats.spread = 16
	self.m16.stats.recoil = 15
	self.m16.stats.reload = 11
	self.m16.stats.concealment = 8
	self.m16.fire_mode_data.fire_rate = 60 / 850
	
	-- AK 7.62
	self.akm.CLIP_AMMO_MAX = 30
	self.akm.stats.damage = 90
	self.akm.stats.spread = 16
	self.akm.stats.recoil = 11
	self.akm.stats.reload = 11
	self.akm.stats.concealment = 10
	self.akm.fire_mode_data.fire_rate = 60 / 600

	-- Gold AK 7.62
	self.akm_gold.CLIP_AMMO_MAX = 30
	self.akm_gold.stats.damage = 90
	self.akm_gold.stats.spread = 16
	self.akm_gold.stats.recoil = 11
	self.akm_gold.stats.reload = 11
	self.akm_gold.stats.concealment = 10
	self.akm_gold.fire_mode_data.fire_rate = 60 / 600

	-- Eagle Heavy
	self.scar.CLIP_AMMO_MAX = 30
	self.scar.stats.damage = 90
	self.scar.stats.spread = 19
	self.scar.stats.recoil = 12
	self.scar.stats.reload = 13
	self.scar.stats.concealment = 10
	self.scar.fire_mode_data.fire_rate = 60 / 625

	-- Gewehr
	self.g3.CLIP_AMMO_MAX = 30
	self.g3.stats.damage = 90
	self.g3.stats.spread = 18
	self.g3.stats.recoil = 13
	self.g3.stats.reload = 11
	self.g3.stats.concealment = 9
	self.g3.fire_mode_data.fire_rate = 60 / 650

	-- Falcon
	self.fal.CLIP_AMMO_MAX = 20
	self.fal.stats.damage = 90
	self.fal.stats.spread = 18
	self.fal.stats.recoil = 12
	self.fal.stats.reload = 11
	self.fal.stats.concealment = 10
	self.fal.fire_mode_data.fire_rate = 60 / 700
	
	-- AK17
	self.flint.CLIP_AMMO_MAX = 30
	self.flint.stats.damage = 90
	self.flint.stats.spread = 16
	self.flint.stats.recoil = 16
	self.flint.stats.reload = 11
	self.flint.stats.concealment = 8
	self.flint.fire_mode_data.fire_rate = 60 / 650
	
	-- KS12
	self.shak12.CLIP_AMMO_MAX = 30
	self.shak12.stats.damage = 120
	self.shak12.stats.spread = 16
	self.shak12.stats.recoil = 8
	self.shak12.stats.reload = 11
	self.shak12.stats.concealment = 16
	self.shak12.fire_mode_data.fire_rate = 60 / 500

	-- M308
	table.insert(self.new_m14.categories, "dmr")
	self.new_m14.CLIP_AMMO_MAX = 10
	self.new_m14.stats.damage = 180
	self.new_m14.stats.spread = 22
	self.new_m14.stats.recoil = 10
	self.new_m14.stats.reload = 11
	self.new_m14.stats.concealment = 5
	self.new_m14.fire_mode_data.fire_rate = 60 / 700

	-- Cavity
	table.insert(self.sub2000.categories, "dmr")
	self.sub2000.CLIP_AMMO_MAX = 20
	self.sub2000.stats.damage = 180
	self.sub2000.stats.spread = 19
	self.sub2000.stats.recoil = 9
	self.sub2000.stats.reload = 11
	self.sub2000.stats.concealment = 18
	self.sub2000.fire_mode_data.fire_rate = 60 / 700
	
	-- Little Friend
	table.insert(self.contraband.categories, "dmr")
	self.contraband.CLIP_AMMO_MAX = 20
	self.contraband.stats.damage = 180
	self.contraband.stats.spread = 19
	self.contraband.stats.recoil = 12
	self.contraband.stats.reload = 11
	self.contraband.stats.concealment = 8
	self.contraband.fire_mode_data.fire_rate = 60 / 600
	
	-- Galant
	table.insert(self.ching.categories, "dmr")
	self.ching.CLIP_AMMO_MAX = 8
	self.ching.stats.damage = 180
	self.ching.stats.spread = 22
	self.ching.stats.recoil = 10
	self.ching.stats.reload = 11
	self.ching.stats.concealment = 10
	self.ching.fire_mode_data.fire_rate = 60 / 600

	-- Pistols

	-- Bernetti Auto
	self.beer.CLIP_AMMO_MAX = 15
	self.beer.stats.damage = 40
	self.beer.stats.spread = 11
	self.beer.stats.recoil = 17
	self.beer.stats.reload = 11
	self.beer.stats.concealment = 28
	self.beer.fire_mode_data.fire_rate = 60 / 1100
	
	-- Stryk
	self.glock_18c.CLIP_AMMO_MAX = 20
	self.glock_18c.stats.damage = 40
	self.glock_18c.stats.spread = 14
	self.glock_18c.stats.recoil = 15
	self.glock_18c.stats.reload = 11
	self.glock_18c.stats.concealment = 29
	self.glock_18c.fire_mode_data.fire_rate = 60 / 900

	-- Czech
	self.czech.CLIP_AMMO_MAX = 15
	self.czech.stats.damage = 40
	self.czech.stats.spread = 16
	self.czech.stats.recoil = 16
	self.czech.stats.reload = 11
	self.czech.stats.concealment = 28
	self.czech.fire_mode_data.fire_rate = 60 / 1000

	-- Igor
	self.stech.CLIP_AMMO_MAX = 20
	self.stech.stats.damage = 70
	self.stech.stats.spread = 15
	self.stech.stats.recoil = 8
	self.stech.stats.reload = 11
	self.stech.stats.concealment = 27
	self.stech.fire_mode_data.fire_rate = 60 / 750
	
	-- Chimano 88
	self.glock_17.CLIP_AMMO_MAX = 17
	self.glock_17.stats.damage = 60
	self.glock_17.stats.spread = 14
	self.glock_17.stats.recoil = 16
	self.glock_17.stats.reload = 11
	self.glock_17.stats.concealment = 30
	self.glock_17.fire_mode_data.fire_rate = 60 / 600
	
	-- Bernetti 9
	self.b92fs.CLIP_AMMO_MAX = 14
	self.b92fs.stats.damage = 60
	self.b92fs.stats.spread = 15
	self.b92fs.stats.recoil = 16
	self.b92fs.stats.reload = 11
	self.b92fs.stats.concealment = 30
	self.b92fs.fire_mode_data.fire_rate = 60 / 600
	
	-- Gruber
	self.ppk.CLIP_AMMO_MAX = 14
	self.ppk.stats.damage = 60
	self.ppk.stats.spread = 13
	self.ppk.stats.recoil = 16
	self.ppk.stats.reload = 11
	self.ppk.stats.concealment = 30
	self.ppk.fire_mode_data.fire_rate = 60 / 600
	
	-- Chimano Compact
	self.g26.CLIP_AMMO_MAX = 10
	self.g26.stats.damage = 60
	self.g26.stats.spread = 14
	self.g26.stats.recoil = 16
	self.g26.stats.reload = 11
	self.g26.stats.concealment = 30
	self.g26.fire_mode_data.fire_rate = 60 / 600
	
	-- Crosskill Guard
	self.shrew.CLIP_AMMO_MAX = 17
	self.shrew.stats.damage = 60
	self.shrew.stats.spread = 17
	self.shrew.stats.recoil = 16
	self.shrew.stats.reload = 11
	self.shrew.stats.concealment = 29
	self.shrew.fire_mode_data.fire_rate = 60 / 600
	self.shrew.can_shoot_through_enemy = true
	self.shrew.can_shoot_through_shield = true
	self.shrew.can_shoot_through_wall = true
	self.shrew.armor_piercing_chance = 1
	self.shrew.has_description = true
	self.shrew.desc_id = "bm_w_lemming_desc"
	
	-- M13
	self.legacy.CLIP_AMMO_MAX = 13
	self.legacy.stats.damage = 60
	self.legacy.stats.spread = 14
	self.legacy.stats.recoil = 16
	self.legacy.stats.reload = 11
	self.legacy.stats.concealment = 30
	self.legacy.fire_mode_data.fire_rate = 60 / 600
	
	-- Crosskill
	self.colt_1911.CLIP_AMMO_MAX = 10
	self.colt_1911.stats.damage = 80
	self.colt_1911.stats.spread = 18
	self.colt_1911.stats.recoil = 14
	self.colt_1911.stats.reload = 11
	self.colt_1911.stats.concealment = 29
	self.colt_1911.fire_mode_data.fire_rate = 60 / 500
	
	-- Interceptor
	self.usp.CLIP_AMMO_MAX = 12
	self.usp.stats.damage = 80
	self.usp.stats.spread = 17
	self.usp.stats.recoil = 14
	self.usp.stats.reload = 11
	self.usp.stats.concealment = 29
	self.usp.fire_mode_data.fire_rate = 60 / 500
	
	-- Signature
	self.p226.CLIP_AMMO_MAX = 12
	self.p226.stats.damage = 80
	self.p226.stats.spread = 18
	self.p226.stats.recoil = 14
	self.p226.stats.reload = 11
	self.p226.stats.concealment = 29
	self.p226.fire_mode_data.fire_rate = 60 / 500
	
	-- Chimano Custom
	self.g22c.CLIP_AMMO_MAX = 16
	self.g22c.stats.damage = 80
	self.g22c.stats.spread = 18
	self.g22c.stats.recoil = 14
	self.g22c.stats.reload = 11
	self.g22c.stats.concealment = 29
	self.g22c.fire_mode_data.fire_rate = 60 / 500
	
	-- LEO
	self.hs2000.CLIP_AMMO_MAX = 19
	self.hs2000.stats.damage = 80
	self.hs2000.stats.spread = 16
	self.hs2000.stats.recoil = 14
	self.hs2000.stats.reload = 11
	self.hs2000.stats.concealment = 29
	self.hs2000.fire_mode_data.fire_rate = 60 / 500

	-- Broomstick
	self.c96.CLIP_AMMO_MAX = 10
	self.c96.stats.damage = 80
	self.c96.stats.spread = 21
	self.c96.stats.recoil = 16
	self.c96.stats.reload = 13
	self.c96.stats.concealment = 28
	self.c96.fire_mode_data.fire_rate = 60 / 500
	self.c96.can_shoot_through_enemy = true
	self.c96.can_shoot_through_shield = true
	self.c96.can_shoot_through_wall = true
	self.c96.armor_piercing_chance = 1
	self.c96.has_description = true
	self.c96.desc_id = "bm_w_lemming_desc"
	
	-- Contractor
	self.packrat.CLIP_AMMO_MAX = 15
	self.packrat.stats.damage = 80
	self.packrat.stats.spread = 18
	self.packrat.stats.recoil = 16
	self.packrat.stats.reload = 11
	self.packrat.stats.concealment = 29
	self.packrat.fire_mode_data.fire_rate = 60 / 500
	
	-- Holt
	self.holt.CLIP_AMMO_MAX = 15
	self.holt.stats.damage = 80
	self.holt.stats.spread = 16
	self.holt.stats.recoil = 18
	self.holt.stats.reload = 11
	self.holt.stats.concealment = 29
	self.holt.fire_mode_data.fire_rate = 60 / 500
	
	-- Kang Arms
	self.type54.CLIP_AMMO_MAX = 10
	self.type54.stats.damage = 80
	self.type54.stats.spread = 17
	self.type54.stats.recoil = 10
	self.type54.stats.reload = 11
	self.type54.stats.concealment = 28
	self.type54.fire_mode_data.fire_rate = 60 / 500

	-- 5/7
	self.lemming.CLIP_AMMO_MAX = 15
	self.lemming.stats.damage = 120
	self.lemming.stats.spread = 13
	self.lemming.stats.recoil = 10
	self.lemming.stats.reload = 11
	self.lemming.stats.concealment = 29
	self.lemming.fire_mode_data.fire_rate = 60 / 600
	
	-- Deagle
	table.insert(self.deagle.categories, "handcannon")
	self.deagle.CLIP_AMMO_MAX = 10
	self.deagle.stats.damage = 140
	self.deagle.stats.spread = 20
	self.deagle.stats.recoil = 8
	self.deagle.stats.reload = 11
	self.deagle.stats.concealment = 28
	self.deagle.fire_mode_data.fire_rate = 60 / 500

	-- Beagle
	self.sparrow.CLIP_AMMO_MAX = 12
	self.sparrow.stats.damage = 140
	self.sparrow.stats.spread = 18
	self.sparrow.stats.recoil = 9
	self.sparrow.stats.reload = 11
	self.sparrow.stats.concealment = 29
	self.sparrow.fire_mode_data.fire_rate = 60 / 500

	-- White Streak
	self.pl14.CLIP_AMMO_MAX = 12
	self.pl14.stats.damage = 140
	self.pl14.stats.spread = 18
	self.pl14.stats.recoil = 9
	self.pl14.stats.reload = 11
	self.pl14.stats.concealment = 28
	self.pl14.fire_mode_data.fire_rate = 60 / 500
	self.pl14.can_shoot_through_enemy = true
	self.pl14.can_shoot_through_shield = true
	self.pl14.can_shoot_through_wall = true
	self.pl14.armor_piercing_chance = 1
	self.pl14.has_description = true
	self.pl14.desc_id = "bm_w_lemming_desc"

	-- Parabellum
	self.breech.CLIP_AMMO_MAX = 8
	self.breech.stats.damage = 180
	self.breech.stats.spread = 20
	self.breech.stats.recoil = 7
	self.breech.stats.reload = 11
	self.breech.stats.concealment = 29
	self.breech.fire_mode_data.fire_rate = 60 / 500
	
	-- Chunky Crosskill
	self.m1911.CLIP_AMMO_MAX = 12
	self.m1911.stats.damage = 140
	self.m1911.stats.spread = 17
	self.m1911.stats.recoil = 9
	self.m1911.stats.reload = 11
	self.m1911.stats.concealment = 28
	self.m1911.fire_mode_data.fire_rate = 60 / 500
	
	-- Gecko M2
	self.maxim9.CLIP_AMMO_MAX = 17
	self.maxim9.stats.damage = 140
	self.maxim9.stats.spread = 17
	self.maxim9.stats.recoil = 12
	self.maxim9.stats.reload = 11
	self.maxim9.stats.concealment = 29
	self.maxim9.fire_mode_data.fire_rate = 60 / 400

	-- Revolvers
	
	-- Frenchman
	self.model3.CLIP_AMMO_MAX = 6
	self.model3.stats.damage = 180
	self.model3.stats.spread = 20
	self.model3.stats.recoil = 8
	self.model3.stats.reload = 11
	self.model3.stats.concealment = 26
	self.model3.fire_mode_data.fire_rate = 60 / 400
	
	-- Kahn
	self.korth.CLIP_AMMO_MAX = 8
	self.korth.stats.damage = 180
	self.korth.stats.spread = 21
	self.korth.stats.recoil = 11
	self.korth.stats.reload = 11
	self.korth.stats.concealment = 27
	self.korth.fire_mode_data.fire_rate = 60 / 400
	
	-- Bronco
	self.new_raging_bull.CLIP_AMMO_MAX = 6
	self.new_raging_bull.stats.damage = 300
	self.new_raging_bull.stats.spread = 20
	self.new_raging_bull.stats.recoil = 2
	self.new_raging_bull.stats.reload = 10
	self.new_raging_bull.stats.concealment = 26
	self.new_raging_bull.fire_mode_data.fire_rate = 60 / 400

	-- Matever
	self.mateba.CLIP_AMMO_MAX = 6
	self.mateba.stats.damage = 300
	self.mateba.stats.spread = 22
	self.mateba.stats.recoil = 4
	self.mateba.stats.reload = 15
	self.mateba.stats.concealment = 26
	self.mateba.fire_mode_data.fire_rate = 60 / 400
	
	--Peacemaker
	self.peacemaker.CLIP_AMMO_MAX = 6
	self.peacemaker.stats.damage = 300
	self.peacemaker.stats.spread = 22
	self.peacemaker.stats.recoil = 4
	self.peacemaker.stats.reload = 17
	self.peacemaker.stats.concealment = 26
	self.peacemaker.fire_mode_data.fire_rate = 60 / 400
	self.peacemaker.can_shoot_through_enemy = true
	self.peacemaker.can_shoot_through_shield = true
	self.peacemaker.can_shoot_through_wall = true
	self.peacemaker.armor_piercing_chance = 1
	self.peacemaker.has_description = true
	self.peacemaker.desc_id = "bm_w_lemming_desc"

	-- Castigo
	self.chinchilla.CLIP_AMMO_MAX = 6
	self.chinchilla.stats.damage = 300
	self.chinchilla.stats.spread = 21
	self.chinchilla.stats.recoil = 2
	self.chinchilla.stats.reload = 13
	self.chinchilla.stats.concealment = 28
	self.chinchilla.fire_mode_data.fire_rate = 60 / 400
	
	-- Angry Tiger
	self.rsh12.CLIP_AMMO_MAX = 5
	self.rsh12.stats.damage = 300
	self.rsh12.stats.spread = 22
	self.rsh12.stats.recoil = 2
	self.rsh12.stats.reload = 10
	self.rsh12.stats.concealment = 25
	self.rsh12.fire_mode_data.fire_rate = 60 / 400

	-- Wasp
	self.fmg9.CLIP_AMMO_MAX = 30
	self.fmg9.stats.damage = 40
	self.fmg9.stats.spread = 15
	self.fmg9.stats.recoil = 10
	self.fmg9.stats.reload = 11
	self.fmg9.stats.concealment = 29
	self.fmg9.fire_mode_data.fire_rate = 60 / 1300
	self.fmg9.timers.unequip = 1.2
		
	-- Compact-5
	self.new_mp5.CLIP_AMMO_MAX = 30
	self.new_mp5.stats.damage = 40
	self.new_mp5.stats.spread = 12
	self.new_mp5.stats.recoil = 21
	self.new_mp5.stats.reload = 11
	self.new_mp5.stats.concealment = 24
	self.new_mp5.fire_mode_data.fire_rate = 60 / 750

	-- Blaster
	self.tec9.CLIP_AMMO_MAX = 20
	self.tec9.stats.damage = 40
	self.tec9.stats.spread = 11
	self.tec9.stats.recoil = 20
	self.tec9.stats.reload = 11
	self.tec9.stats.concealment = 27
	self.tec9.fire_mode_data.fire_rate = 60 / 900
	
	-- Cobra
	self.scorpion.CLIP_AMMO_MAX = 20
	self.scorpion.stats.damage = 40
	self.scorpion.stats.spread = 11
	self.scorpion.stats.recoil = 18
	self.scorpion.stats.reload = 11
	self.scorpion.stats.concealment = 28
	self.scorpion.fire_mode_data.fire_rate = 60 / 1000
	
	-- Micro Uzi
	self.baka.CLIP_AMMO_MAX = 32
	self.baka.stats.damage = 40
	self.baka.stats.spread = 11
	self.baka.stats.recoil = 20
	self.baka.stats.reload = 11
	self.baka.stats.concealment = 29
	self.baka.fire_mode_data.fire_rate = 60 / 1200

	-- CMP
	self.mp9.CLIP_AMMO_MAX = 30
	self.mp9.stats.damage = 50
	self.mp9.stats.spread = 11
	self.mp9.stats.recoil = 20
	self.mp9.stats.reload = 11
	self.mp9.stats.concealment = 26
	self.mp9.fire_mode_data.fire_rate = 60 / 950
	
	-- Mark 10
	self.mac10.CLIP_AMMO_MAX = 40
	self.mac10.stats.damage = 50
	self.mac10.stats.spread = 13
	self.mac10.stats.recoil = 17
	self.mac10.stats.reload = 11
	self.mac10.stats.concealment = 27
	self.mac10.fire_mode_data.fire_rate = 60 / 1000
	
	-- Kobus
	self.p90.CLIP_AMMO_MAX = 50
	self.p90.stats.damage = 50
	self.p90.stats.spread = 16
	self.p90.stats.recoil = 14
	self.p90.stats.reload = 11
	self.p90.stats.concealment = 25
	self.p90.fire_mode_data.fire_rate = 60 / 900

	-- Vertex
	self.polymer.CLIP_AMMO_MAX = 30
	self.polymer.stats.damage = 50
	self.polymer.stats.spread = 14
	self.polymer.stats.recoil = 20
	self.polymer.stats.reload = 11
	self.polymer.stats.concealment = 20
	self.polymer.fire_mode_data.fire_rate = 60 / 1200
	
	-- Jacket's Piece
	self.cobray.CLIP_AMMO_MAX = 32
	self.cobray.stats.damage = 50
	self.cobray.stats.spread = 14
	self.cobray.stats.recoil = 18
	self.cobray.stats.reload = 11
	self.cobray.stats.concealment = 25
	self.cobray.fire_mode_data.fire_rate = 60 / 1200
	self.cobray.timers.reload_not_empty = 1.9
	self.cobray.timers.reload_empty = 4.35
		
	-- Heather
	self.sr2.CLIP_AMMO_MAX = 32
	self.sr2.stats.damage = 50
	self.sr2.stats.spread = 14
	self.sr2.stats.recoil = 18
	self.sr2.stats.reload = 11
	self.sr2.stats.concealment = 28
	self.sr2.fire_mode_data.fire_rate = 60 / 750

	-- Spec Ops
	self.mp7.CLIP_AMMO_MAX = 20
	self.mp7.stats.damage = 60
	self.mp7.stats.spread = 17
	self.mp7.stats.recoil = 18
	self.mp7.stats.reload = 11
	self.mp7.stats.concealment = 23
	self.mp7.fire_mode_data.fire_rate = 60 / 900
	
	-- Thompson
	self.m1928.CLIP_AMMO_MAX = 50
	self.m1928.stats.damage = 60
	self.m1928.stats.spread = 15
	self.m1928.stats.recoil = 18
	self.m1928.stats.reload = 15
	self.m1928.stats.concealment = 18
	self.m1928.fire_mode_data.fire_rate = 60 / 725
	
	-- Signature
	self.shepheard.CLIP_AMMO_MAX = 20
	self.shepheard.stats.damage = 60
	self.shepheard.stats.spread = 14
	self.shepheard.stats.recoil = 12
	self.shepheard.stats.reload = 11
	self.shepheard.stats.concealment = 24
	self.shepheard.fire_mode_data.fire_rate = 60 / 850

	-- Miyaka
	self.pm9.CLIP_AMMO_MAX = 25
	self.pm9.stats.damage = 60
	self.pm9.stats.spread = 8
	self.pm9.stats.recoil = 15
	self.pm9.stats.reload = 11
	self.pm9.stats.concealment = 26
	self.pm9.fire_mode_data.fire_rate = 60 / 1100
	
	-- Para
	self.olympic.CLIP_AMMO_MAX = 25
	self.olympic.stats.damage = 80
	self.olympic.stats.spread = 12
	self.olympic.stats.recoil = 17
	self.olympic.stats.reload = 11
	self.olympic.stats.concealment = 24
	self.olympic.fire_mode_data.fire_rate = 60 / 675

	-- Krinkov
	self.akmsu.CLIP_AMMO_MAX = 30
	self.akmsu.stats.damage = 80
	self.akmsu.stats.spread = 16
	self.akmsu.stats.recoil = 12
	self.akmsu.stats.reload = 11
	self.akmsu.stats.concealment = 21
	self.akmsu.fire_mode_data.fire_rate = 60 / 825

	-- Uzi
	self.uzi.CLIP_AMMO_MAX = 40
	self.uzi.stats.damage = 80
	self.uzi.stats.spread = 14
	self.uzi.stats.recoil = 18
	self.uzi.stats.reload = 11
	self.uzi.stats.concealment = 24
	self.uzi.fire_mode_data.fire_rate = 60 / 850
	
	-- Swedish K
	self.m45.CLIP_AMMO_MAX = 40
	self.m45.stats.damage = 90
	self.m45.stats.spread = 18
	self.m45.stats.recoil = 12
	self.m45.stats.reload = 11
	self.m45.stats.concealment = 24
	self.m45.fire_mode_data.fire_rate = 60 / 600

	-- Pattchet
	self.sterling.CLIP_AMMO_MAX = 24
	self.sterling.stats.damage = 90
	self.sterling.stats.spread = 14
	self.sterling.stats.recoil = 20
	self.sterling.stats.reload = 11
	self.sterling.stats.concealment = 20
	self.sterling.fire_mode_data.fire_rate = 60 / 550
	
	-- Tatonka
	self.coal.CLIP_AMMO_MAX = 64
	self.coal.stats.damage = 90
	self.coal.stats.spread = 14
	self.coal.stats.recoil = 16
	self.coal.stats.reload = 9
	self.coal.stats.concealment = 24
	self.coal.fire_mode_data.fire_rate = 60 / 700
	
	-- MP40
	self.erma.CLIP_AMMO_MAX = 40
	self.erma.stats.damage = 90
	self.erma.stats.spread = 18
	self.erma.stats.recoil = 12
	self.erma.stats.reload = 13
	self.erma.stats.concealment = 24
	self.erma.fire_mode_data.fire_rate = 60 / 600
	
	-- AK GEN
	self.vityaz.CLIP_AMMO_MAX = 30
	self.vityaz.stats.damage = 90
	self.vityaz.stats.spread = 17
	self.vityaz.stats.recoil = 18
	self.vityaz.stats.reload = 11
	self.vityaz.stats.concealment = 23
	self.vityaz.fire_mode_data.fire_rate = 60 / 750

	-- Jackal
	self.schakal.CLIP_AMMO_MAX = 30
	self.schakal.stats.damage = 90
	self.schakal.stats.spread = 16
	self.schakal.stats.recoil = 14
	self.schakal.stats.reload = 11
	self.schakal.stats.concealment = 24
	self.schakal.fire_mode_data.fire_rate = 60 / 650
	
	-- Shotguns

	-- Izhma
	self.saiga.CLIP_AMMO_MAX = 7
	self.saiga.stats.damage = 240
	self.saiga.stats.spread = 12
	self.saiga.stats.recoil = 12
	self.saiga.stats.reload = 11
	self.saiga.stats.concealment = 13
	self.saiga.fire_mode_data.fire_rate = 60 / 350

	-- Steakout
	self.aa12.CLIP_AMMO_MAX = 8
	self.aa12.stats.damage = 240
	self.aa12.stats.spread = 12
	self.aa12.stats.recoil = 12
	self.aa12.stats.reload = 11
	self.aa12.stats.concealment = 8
	self.aa12.fire_mode_data.fire_rate = 60 / 300

	-- Grimm
	self.basset.CLIP_AMMO_MAX = 8
	self.basset.stats.damage = 240
	self.basset.stats.spread = 12
	self.basset.stats.recoil = 13
	self.basset.stats.reload = 11
	self.basset.stats.concealment = 21
	self.basset.fire_mode_data.fire_rate = 60 / 300
	
	-- Street Sweeper
	self.striker.CLIP_AMMO_MAX = 12
	self.striker.stats.damage = 320
	self.striker.stats.spread = 12
	self.striker.stats.recoil = 11
	self.striker.stats.reload = 11
	self.striker.stats.concealment = 24
	self.striker.fire_mode_data.fire_rate = 60 / 400

	-- M1014
	self.benelli.CLIP_AMMO_MAX = 8
	self.benelli.stats.damage = 320
	self.benelli.stats.spread = 13
	self.benelli.stats.recoil = 11
	self.benelli.stats.reload = 11
	self.benelli.stats.concealment = 12
	self.benelli.fire_mode_data.fire_rate = 60 / 400

	-- Predator
	self.spas12.CLIP_AMMO_MAX = 8
	self.spas12.stats.damage = 320
	self.spas12.stats.spread = 13
	self.spas12.stats.recoil = 10
	self.spas12.stats.reload = 11
	self.spas12.stats.concealment = 14
	self.spas12.fire_mode_data.fire_rate = 60 / 400

	-- Goliath
	self.rota.CLIP_AMMO_MAX = 6
	self.rota.stats.damage = 320
	self.rota.stats.spread = 12
	self.rota.stats.recoil = 11
	self.rota.stats.reload = 11
	self.rota.stats.concealment = 20
	self.rota.fire_mode_data.fire_rate = 60 / 400

	-- Argos
	self.ultima.CLIP_AMMO_MAX = 6
	self.ultima.stats.damage = 320
	self.ultima.stats.spread = 14
	self.ultima.stats.recoil = 11
	self.ultima.stats.reload = 10
	self.ultima.stats.concealment = 17
	self.ultima.fire_mode_data.fire_rate = 60 / 400
	
	-- VD-12
	self.sko12.CLIP_AMMO_MAX = 28
	self.sko12.stats.damage = 320
	self.sko12.stats.spread = 14
	self.sko12.stats.recoil = 12
	self.sko12.stats.reload = 11
	self.sko12.stats.concealment = 6
	self.sko12.fire_mode_data.fire_rate = 60 / 400
	self.sko12.FIRE_MODE = "single"
	self.sko12.CAN_TOGGLE_FIREMODE = false
	
	-- Reinfeld 880
	self.r870.CLIP_AMMO_MAX = 8
	self.r870.stats.damage = 400
	self.r870.stats.spread = 14
	self.r870.stats.recoil = 9
	self.r870.stats.reload = 11
	self.r870.stats.concealment = 11
	self.r870.fire_mode_data.fire_rate = 60 / 100

	-- Loco
	self.serbu.CLIP_AMMO_MAX = 4
	self.serbu.stats.damage = 400
	self.serbu.stats.spread = 13
	self.serbu.stats.recoil = 7
	self.serbu.stats.reload = 11
	self.serbu.stats.concealment = 23
	self.serbu.fire_mode_data.fire_rate = 60 / 100
	
	-- Raven
	self.ksg.CLIP_AMMO_MAX = 8
	self.ksg.stats.damage = 400
	self.ksg.stats.spread = 14
	self.ksg.stats.recoil = 12
	self.ksg.stats.reload = 11
	self.ksg.stats.concealment = 23
	self.ksg.fire_mode_data.fire_rate = 60 / 100

	-- Judge
	self.judge.CLIP_AMMO_MAX = 5
	self.judge.stats.damage = 400
	self.judge.stats.spread = 13
	self.judge.stats.recoil = 8
	self.judge.stats.reload = 11
	self.judge.stats.concealment = 29
	self.judge.fire_mode_data.fire_rate = 60 / 400
	
	-- Mosconi Tactical
	self.m590.CLIP_AMMO_MAX = 7
	self.m590.stats.damage = 400
	self.m590.stats.spread = 14
	self.m590.stats.recoil = 9
	self.m590.stats.reload = 11
	self.m590.stats.concealment = 11
	self.m590.fire_mode_data.fire_rate = 60 / 100

	-- Nova
	self.supernova.CLIP_AMMO_MAX = 7
	self.supernova.stats.damage = 400
	self.supernova.stats.spread = 14
	self.supernova.stats.recoil = 9
	self.supernova.stats.reload = 11
	self.supernova.stats.concealment = 13
	self.supernova.fire_mode_data.fire_rate = 60 / 100
	
	-- Breaker
	self.boot.CLIP_AMMO_MAX = 7
	self.boot.stats.damage = 480
	self.boot.stats.spread = 15
	self.boot.stats.recoil = 8
	self.boot.stats.reload = 11
	self.boot.stats.concealment = 20
	self.boot.fire_mode_data.fire_rate = 60 / 75

	-- GSPS
	self.m37.use_data.selection_index = 2
	self.m37.CLIP_AMMO_MAX = 7
	self.m37.stats.damage = 480
	self.m37.stats.spread = 14
	self.m37.stats.recoil = 12
	self.m37.stats.reload = 11
	self.m37.stats.concealment = 22
	self.m37.fire_mode_data.fire_rate = 60 / 100
	
	-- Reinfeld 88 (Trench Gun)
	self.m1897.CLIP_AMMO_MAX = 7
	self.m1897.stats.damage = 480
	self.m1897.stats.spread = 15
	self.m1897.stats.recoil = 10
	self.m1897.stats.reload = 11
	self.m1897.stats.concealment = 17
	self.m1897.fire_mode_data.fire_rate = 60 / 100

	-- Mosconi
	self.huntsman.CLIP_AMMO_MAX = 2
	self.huntsman.stats.damage = 640
	self.huntsman.stats.spread = 19
	self.huntsman.stats.recoil = 10
	self.huntsman.stats.reload = 11
	self.huntsman.stats.concealment = 7
	self.huntsman.fire_mode_data.fire_rate = 60 / 500

	-- Joceline
	self.b682.CLIP_AMMO_MAX = 2
	self.b682.stats.damage = 640
	self.b682.stats.spread = 19
	self.b682.stats.recoil = 10
	self.b682.stats.reload = 11
	self.b682.stats.concealment = 7
	self.b682.fire_mode_data.fire_rate = 60 / 500
	
	-- Claire
	self.coach.CLIP_AMMO_MAX = 2
	self.coach.stats.damage = 640
	self.coach.stats.spread = 17
	self.coach.stats.recoil = 10
	self.coach.stats.reload = 11
	self.coach.stats.concealment = 10
	self.coach.fire_mode_data.fire_rate = 60 / 500

	-- LMGs and Miniguns

	-- KSP
	self.m249.CLIP_AMMO_MAX = 200
	self.m249.stats.damage = 60
	self.m249.stats.spread = 9
	self.m249.stats.recoil = 6
	self.m249.stats.reload = 11
	self.m249.stats.concealment = 0
	self.m249.fire_mode_data.fire_rate = 60 / 900

	-- Buzzsaw
	self.mg42.CLIP_AMMO_MAX = 150
	self.mg42.stats.damage = 60
	self.mg42.stats.spread = 9
	self.mg42.stats.recoil = 6
	self.mg42.stats.reload = 11
	self.mg42.stats.concealment = 0
	self.mg42.fire_mode_data.fire_rate = 60 / 1200
	
	-- KSP 58
	self.par.CLIP_AMMO_MAX = 200
	self.par.stats.damage = 60
	self.par.stats.spread = 9
	self.par.stats.recoil = 6
	self.par.stats.reload = 11
	self.par.stats.concealment = 0
	self.par.fire_mode_data.fire_rate = 60 / 900

	-- Campbell
	self.kacchainsaw.CLIP_AMMO_MAX = 150
	self.kacchainsaw.stats.damage = 60
	self.kacchainsaw.stats.spread = 9
	self.kacchainsaw.stats.recoil = 6
	self.kacchainsaw.stats.reload = 11
	self.kacchainsaw.stats.concealment = 0
	self.kacchainsaw.fire_mode_data.fire_rate = 60 / 1000
	
	-- RPK
	self.rpk.CLIP_AMMO_MAX = 100
	self.rpk.stats.damage = 80
	self.rpk.stats.spread = 10
	self.rpk.stats.recoil = 2
	self.rpk.stats.reload = 11
	self.rpk.stats.concealment = 1
	self.rpk.fire_mode_data.fire_rate = 60 / 750
	
	-- Brenner
	self.hk21.CLIP_AMMO_MAX = 150
	self.hk21.stats.damage = 80
	self.hk21.stats.spread = 12
	self.hk21.stats.recoil = 2
	self.hk21.stats.reload = 11
	self.hk21.stats.concealment = 0
	self.hk21.fire_mode_data.fire_rate = 60 / 700
	
	-- M60
	self.m60.CLIP_AMMO_MAX = 150
	self.m60.stats.damage = 80
	self.m60.stats.spread = 13
	self.m60.stats.recoil = 2
	self.m60.stats.reload = 11
	self.m60.stats.concealment = 0
	self.m60.fire_mode_data.fire_rate = 60 / 550
	
	-- Akron
	self.hcar.CLIP_AMMO_MAX = 20
	self.hcar.stats.damage = 80
	self.hcar.stats.spread = 19
	self.hcar.stats.recoil = 11
	self.hcar.stats.reload = 11
	self.hcar.stats.concealment = 0
	self.hcar.fire_mode_data.fire_rate = 60 / 600

	-- Versteckt 
	self.hk51b.CLIP_AMMO_MAX = 60
	self.hk51b.stats.damage = 80
	self.hk51b.stats.spread = 11
	self.hk51b.stats.recoil = 2
	self.hk51b.stats.reload = 11
	self.hk51b.stats.concealment = 10
	self.hk51b.fire_mode_data.fire_rate = 60 / 700
	
	-- Minigun
	self.m134.CLIP_AMMO_MAX = 750
	self.m134.stats.damage = 40
	self.m134.stats.spread = 9
	self.m134.stats.recoil = 7
	self.m134.stats.reload = 11
	self.m134.stats.concealment = 0
	self.m134.fire_mode_data.fire_rate = 60 / 3000

	-- Hailstorm
	self.hailstorm.CLIP_AMMO_MAX = 120
	self.hailstorm.stats.damage = 40
	self.hailstorm.stats.spread = 19
	self.hailstorm.stats.recoil = 14
	self.hailstorm.stats.reload = 11
	self.hailstorm.stats.concealment = 3
	self.hailstorm.fire_mode_data.fire_rate = 60 / 2000
	self.hailstorm.fire_mode_data.volley.can_shoot_through_wall = true
	self.hailstorm.fire_mode_data.volley.spread_mul = 1
	self.hailstorm.fire_mode_data.volley.damage_mul = 20
	self.hailstorm.fire_mode_data.volley.rays = 6
	self.hailstorm.fire_mode_data.volley.ammo_usage = 120
	
	-- Microgun
	self.shuno.CLIP_AMMO_MAX = 750
	self.shuno.stats.damage = 60
	self.shuno.stats.spread = 9
	self.shuno.stats.recoil = 7
	self.shuno.stats.reload = 11
	self.shuno.stats.concealment = 0
	self.shuno.fire_mode_data.fire_rate = 60 / 2000
	
	-- Lebensauger
	table.insert(self.wa2000.categories, "ng")
	self.wa2000.CLIP_AMMO_MAX = 20
	self.wa2000.stats.damage = 200
	self.wa2000.stats.spread = 24
	self.wa2000.stats.recoil = 6
	self.wa2000.stats.reload = 13
	self.wa2000.stats.concealment = 16
	self.wa2000.fire_mode_data.fire_rate = 60 / 200
	
	-- Contractor
	table.insert(self.tti.categories, "ng")
	self.tti.CLIP_AMMO_MAX = 20
	self.tti.stats.damage = 200
	self.tti.stats.spread = 21
	self.tti.stats.recoil = 7
	self.tti.stats.reload = 11
	self.tti.stats.concealment = 16
	self.tti.fire_mode_data.fire_rate = 60 / 200
	
	-- Grom
	table.insert(self.tti.categories, "ng")
	self.tti.CLIP_AMMO_MAX = 10
	self.tti.stats.damage = 200
	self.tti.stats.spread = 20
	self.tti.stats.recoil = 4
	self.tti.stats.reload = 11
	self.tti.stats.concealment = 16
	self.tti.fire_mode_data.fire_rate = 60 / 200

	-- Kang Arms
	table.insert(self.qbu88.categories, "ng")
	self.qbu88.CLIP_AMMO_MAX = 10
	self.qbu88.stats.damage = 200
	self.qbu88.stats.spread = 21
	self.qbu88.stats.recoil = 7
	self.qbu88.stats.reload = 11
	self.qbu88.stats.concealment = 13
	self.qbu88.fire_mode_data.fire_rate = 60 / 200
	
	-- North Star
	table.insert(self.victor.categories, "ng")
	self.victor.CLIP_AMMO_MAX = 10
	self.victor.stats.damage = 200
	self.victor.stats.spread = 20
	self.victor.stats.recoil = 6
	self.victor.stats.reload = 11
	self.victor.stats.concealment = 9
	self.victor.fire_mode_data.fire_rate = 60 / 200

	-- Rangehitter
	table.insert(self.sbl.categories, "ng")
	self.sbl.use_data.selection_index = 1
	self.sbl.CLIP_AMMO_MAX = 10
	self.sbl.stats.damage = 300
	self.sbl.stats.spread = 20
	self.sbl.stats.recoil = 6
	self.sbl.stats.reload = 11
	self.sbl.stats.concealment = 19
	self.sbl.fire_mode_data.fire_rate = 60 / 150
	self.sbl.stats_modifiers = nil
	
	-- Rattlesnake
	self.msr.CLIP_AMMO_MAX = 10
	self.msr.stats.damage = 320
	self.msr.stats.spread = 23
	self.msr.stats.recoil = 8
	self.msr.stats.reload = 11
	self.msr.stats.concealment = 5
	self.msr.fire_mode_data.fire_rate = 60 / 60
	self.msr.stats_modifiers = nil
	
	-- Repeater
	self.winchester1874.CLIP_AMMO_MAX = 15
	self.winchester1874.stats.damage = 320
	self.winchester1874.stats.spread = 24
	self.winchester1874.stats.recoil = 6
	self.winchester1874.stats.reload = 11
	self.winchester1874.stats.concealment = 12
	self.winchester1874.fire_mode_data.fire_rate = 60 / 75
	self.winchester1874.stats_modifiers = nil

	-- R700
	self.r700.CLIP_AMMO_MAX = 10
	self.r700.stats.damage = 320
	self.r700.stats.spread = 24
	self.r700.stats.recoil = 8
	self.r700.stats.reload = 11
	self.r700.stats.concealment = 10
	self.r700.fire_mode_data.fire_rate = 60 / 60
	self.r700.stats_modifiers = nil
	
	-- Scout
	self.scout.CLIP_AMMO_MAX = 5
	self.scout.stats.damage = 320
	self.scout.stats.spread = 21
	self.scout.stats.recoil = 4
	self.scout.stats.reload = 11
	self.scout.stats.concealment = 18
	self.scout.fire_mode_data.fire_rate = 60 / 60
	self.scout.stats_modifiers = nil
	
	-- R93
	self.r93.CLIP_AMMO_MAX = 5
	self.r93.stats.damage = 480
	self.r93.stats.spread = 24
	self.r93.stats.recoil = 4
	self.r93.stats.reload = 11
	self.r93.stats.concealment = 5
	self.r93.fire_mode_data.fire_rate = 60 / 55
	self.r93.stats_modifiers = nil

	-- Platypus
	self.model70.CLIP_AMMO_MAX = 6
	self.model70.stats.damage = 480
	self.model70.stats.spread = 24
	self.model70.stats.recoil = 4
	self.model70.stats.reload = 11
	self.model70.stats.concealment = 6
	self.model70.fire_mode_data.fire_rate = 60 / 60
	self.model70.stats_modifiers = nil
	
	-- Nagant
	self.mosin.CLIP_AMMO_MAX = 5
	self.mosin.stats.damage = 480
	self.mosin.stats.spread = 24
	self.mosin.stats.recoil = 4
	self.mosin.stats.reload = 11
	self.mosin.stats.concealment = 12
	self.mosin.fire_mode_data.fire_rate = 60 / 70
	self.mosin.stats_modifiers = nil
	
	-- Desert Fox
	self.desertfox.CLIP_AMMO_MAX = 5
	self.desertfox.stats.damage = 480
	self.desertfox.stats.spread = 22
	self.desertfox.stats.recoil = 4
	self.desertfox.stats.reload = 11
	self.desertfox.stats.concealment = 19
	self.desertfox.fire_mode_data.fire_rate = 60 / 50
	self.desertfox.stats_modifiers = nil

	-- Aran
	self.contender.CLIP_AMMO_MAX = 1
	self.contender.stats.damage = 480
	self.contender.stats.spread = 21
	self.contender.stats.recoil = 6
	self.contender.stats.reload = 11
	self.contender.stats.concealment = 20
	self.contender.fire_mode_data.fire_rate = 60 / 90
	self.contender.timers.reload_empty = 1.7
	self.contender.timers.reload_not_empty = self.contender.timers.reload_empty
	self.contender.timers.reload_steelsight = self.contender.timers.reload_empty
	self.contender.timers.reload_steelsight_not_empty = self.contender.timers.reload_empty
	self.contender.stats_modifiers = nil
	self.contender.ignore_damage_upgrades = nil	
	self.contender.rays = nil 
	
	-- Thanatos
	self.m95.CLIP_AMMO_MAX = 5
	self.m95.stats.damage = 720
	self.m95.stats.spread = 24
	self.m95.stats.recoil = 2
	self.m95.stats.reload = 11
	self.m95.stats.concealment = 1
	self.m95.fire_mode_data.fire_rate = 60 / 40
	self.m95.stats_modifiers = { damage = 2 }
	self.m95.swap_speed_multiplier = 0.75

	-- AWP
	self.awp.CLIP_AMMO_MAX = 5
	self.awp.stats.damage = 720
	self.awp.stats.spread = 23
	self.awp.stats.recoil = 4
	self.awp.stats.reload = 9
	self.awp.stats.concealment = 1
	self.awp.fire_mode_data.fire_rate = 60 / 40
	self.awp.stats_modifiers = { damage = 2 }

	-- Akimbos

	-- Stryks
	
	-- Czechs

	
	-- Chimano 88s
	
	-- Bernetti 9s


	-- Chimano Compacts

	-- Crosskills

	-- Interceptors
	
	-- Chimano Customs

	-- Contractors

	-- Deagles

	-- Castigos

	-- Judges
	
	-- Specials

	-- Airbow
	self.ecp.use_data.selection_index = 1
	self.ecp.CLIP_AMMO_MAX = 6
	self.ecp.stats.damage = 24
	self.ecp.stats.spread = 22
	self.ecp.stats.recoil = 22
	self.ecp.stats.reload = 11
	self.ecp.stats.concealment = 5
	self.ecp.fire_mode_data.fire_rate = 60 / 120
	self.ecp.stats_modifiers = { damage = 10 }

	-- Pistol Crossbow
	self.hunter.CLIP_AMMO_MAX = 1
	self.hunter.stats.damage = 32
	self.hunter.stats.spread = 25
	self.hunter.stats.recoil = 25
	self.hunter.stats.reload = 11
	self.hunter.stats.concealment = 30
	self.hunter.fire_mode_data.fire_rate = 60 / 60
	self.hunter.stats_modifiers = { damage = 10 }
	
	-- Light Crossbow
	self.frankish.use_data.selection_index = 1
	self.frankish.CLIP_AMMO_MAX = 1
	self.frankish.stats.damage = 48
	self.frankish.stats.spread = 25
	self.frankish.stats.recoil = 25
	self.frankish.stats.reload = 11
	self.frankish.stats.concealment = 25
	self.frankish.fire_mode_data.fire_rate = 60 / 45
	self.frankish.stats_modifiers = { damage = 10 }
	
	-- Heavy Crossbow
	self.arblast.CLIP_AMMO_MAX = 1
	self.arblast.stats.damage = 96
	self.arblast.stats.spread = 25
	self.arblast.stats.recoil = 25
	self.arblast.stats.reload = 13
	self.arblast.stats.concealment = 23
	self.arblast.fire_mode_data.fire_rate = 60 / 30
	self.arblast.stats_modifiers = { damage = 10 }

	-- Plainsrider
	self.plainsrider.use_data.selection_index = 1
	self.plainsrider.CLIP_AMMO_MAX = 1
	self.plainsrider.stats.damage = 48
	self.plainsrider.stats.spread = 25
	self.plainsrider.stats.recoil = 25
	self.plainsrider.stats.reload = 11
	self.plainsrider.stats.concealment = 24
	self.plainsrider.fire_mode_data.fire_rate = 60 / 60
	self.plainsrider.stats_modifiers = { damage = 10 }

	self.long.CLIP_AMMO_MAX = 1
	self.long.stats.damage = 96
	self.long.stats.spread = 25
	self.long.stats.recoil = 25
	self.long.stats.reload = 11
	self.long.stats.concealment = 22
	self.long.fire_mode_data.fire_rate = 60 / 30
	self.long.stats_modifiers = { damage = 10 }

	self.elastic.CLIP_AMMO_MAX = 1
	self.elastic.stats.damage = 96
	self.elastic.stats.spread = 25
	self.elastic.stats.recoil = 25
	self.elastic.stats.reload = 11
	self.elastic.stats.concealment = 22
	self.elastic.fire_mode_data.fire_rate = 60 / 30
	self.elastic.stats_modifiers = { damage = 10 }
	
	-- Grenade / Rocket launchers

	-- Basilisk
	self.ms3gl.CLIP_AMMO_MAX = 3
	self.ms3gl.stats.damage = 48
	self.ms3gl.stats.spread = 10
	self.ms3gl.stats.recoil = 20
	self.ms3gl.stats.reload = 11
	self.ms3gl.stats.concealment = 21
	self.ms3gl.fire_mode_data = { fire_rate = 1 / 3, single = {}, burst_cooldown = 1 }
	self.ms3gl.fire_mode_data.toggable = { "burst", "single" }

	-- Arbiter
	self.arbiter.use_data.selection_index = 2
	self.arbiter.CLIP_AMMO_MAX = 3
	self.arbiter.stats.damage = 72
	self.arbiter.stats.spread = 25
	self.arbiter.stats.recoil = 25
	self.arbiter.stats.reload = 11
	self.arbiter.stats.concealment = 18
	self.arbiter.fire_mode_data.fire_rate = 60 / 90
	
	-- GL40
	self.gre_m79.use_data.selection_index = 1
	self.gre_m79.CLIP_AMMO_MAX = 1
	self.gre_m79.stats.damage = 80
	self.gre_m79.stats.spread = 25
	self.gre_m79.stats.recoil = 25
	self.gre_m79.stats.reload = 11
	self.gre_m79.stats.concealment = 18
	self.gre_m79.fire_mode_data.fire_rate = 60 / 60

	-- Compact 40
	self.slap.CLIP_AMMO_MAX = 1
	self.slap.stats.damage = 80
	self.slap.stats.spread = 22
	self.slap.stats.recoil = 22
	self.slap.stats.reload = 11
	self.slap.stats.concealment = 22
	self.slap.fire_mode_data.fire_rate = 60 / 60
	self.slap.timers.reload_not_empty = 3.1
	self.slap.timers.reload_empty = self.slap.timers.reload_not_empty

	-- Piglet
	self.m32.CLIP_AMMO_MAX = 6
	self.m32.stats.damage = 80
	self.m32.stats.spread = 25
	self.m32.stats.recoil = 25
	self.m32.stats.reload = 16
	self.m32.stats.concealment = 10
	self.m32.fire_mode_data.fire_rate = 60 / 60

	-- China Puff
	self.china.use_data.selection_index = 2
	self.china.CLIP_AMMO_MAX = 3
	self.china.stats.damage = 80
	self.china.stats.spread = 25
	self.china.stats.recoil = 25
	self.china.stats.reload = 16
	self.china.stats.concealment = 16
	self.china.fire_mode_data.fire_rate = 60 / 50
	
	-- Commando 101
	self.ray.use_data.selection_index = 2
	self.ray.categories = { "grenade_launcher", "heavy" }
	self.ray.CLIP_AMMO_MAX = 4
	self.ray.stats.damage = 128
	self.ray.stats.spread = 25
	self.ray.stats.recoil = 25
	self.ray.stats.reload = 8
	self.ray.stats.concealment = 5
	self.ray.fire_mode_data.fire_rate = 60 / 60
	self.ray.stats_modifiers = { damage = 10 }
	self.ray.has_description = false

	-- RPG
	self.rpg7.use_data.selection_index = 2
	self.rpg7.categories = { "grenade_launcher", "heavy" }
	self.rpg7.CLIP_AMMO_MAX = 1
	self.rpg7.stats.damage = 120
	self.rpg7.stats.spread = 25
	self.rpg7.stats.recoil = 25
	self.rpg7.stats.reload = 11
	self.rpg7.stats.concealment = 5
	self.rpg7.fire_mode_data.fire_rate = 60 / 30
	self.rpg7.stats_modifiers = { damage = 200 }
	self.rpg7.total_ammo_mul = 4
	
	-- Underbarrel Grenade Launchers

	-- Flamethrowers

	-- MK2
	self.flamethrower_mk2.CLIP_AMMO_MAX = 900
	self.flamethrower_mk2.stats.damage = 25
	self.flamethrower_mk2.stats.spread = 0
	self.flamethrower_mk2.stats.recoil = 0
	self.flamethrower_mk2.stats.reload = 11
	self.flamethrower_mk2.stats.concealment = 7
	self.flamethrower_mk2.fire_mode_data.fire_rate = 60 / 2000

	-- MA-17
	self.system.use_data.selection_index = 2
	self.system.CLIP_AMMO_MAX = 600
	self.system.stats.damage = 25
	self.system.stats.spread = 0
	self.system.stats.recoil = 0
	self.system.stats.reload = 11
	self.system.stats.concealment = 15
	self.system.fire_mode_data.fire_rate = 60 / 2000

	-- removed shit
	self.x_akmsu.use_data.selection_index = 4
	self.x_sr2.use_data.selection_index = 4
	self.x_mp5.use_data.selection_index = 4
	self.elastic.use_data.selection_index = 4
	self.long.use_data.selection_index = 4
	self.x_sko12.use_data.selection_index = 4
	self.x_korth.use_data.selection_index = 4
	self.x_basset.use_data.selection_index = 4
	self.x_rota.use_data.selection_index = 4
	self.x_coal.use_data.selection_index = 4
	self.x_baka.use_data.selection_index = 4
	self.x_cobray.use_data.selection_index = 4
	self.x_erma.use_data.selection_index = 4
	self.x_hajk.use_data.selection_index = 4
	self.x_m45.use_data.selection_index = 4
	self.x_m1928.use_data.selection_index = 4
	self.x_mac10.use_data.selection_index = 4
	self.x_mp7.use_data.selection_index = 4
	self.x_mp9.use_data.selection_index = 4
	self.x_olympic.use_data.selection_index = 4
	self.x_polymer.use_data.selection_index = 4
	self.x_schakal.use_data.selection_index = 4
	self.x_scorpion.use_data.selection_index = 4
	self.x_sterling.use_data.selection_index = 4
	self.x_tec9.use_data.selection_index = 4
	self.x_uzi.use_data.selection_index = 4
	self.x_2006m.use_data.selection_index = 4
	self.x_breech.use_data.selection_index = 4
	self.x_c96.use_data.selection_index = 4
	self.x_hs2000.use_data.selection_index = 4
	self.x_p226.use_data.selection_index = 4
	self.x_pl14.use_data.selection_index = 4
	self.x_ppk.use_data.selection_index = 4
	self.x_rage.use_data.selection_index = 4
	self.x_sparrow.use_data.selection_index = 4
	self.x_maxim9.use_data.selection_index = 4
	self.x_shrew.use_data.selection_index = 4
	self.x_model3.use_data.selection_index = 4
	self.x_beer.use_data.selection_index = 4
	self.x_stech.use_data.selection_index = 4
	self.x_holt.use_data.selection_index = 4
	self.x_m1911.use_data.selection_index = 4
	self.x_type54.use_data.selection_index = 4
	self.x_legacy.use_data.selection_index = 4
	self.x_p90.use_data.selection_index = 4
	self.x_vityaz.use_data.selection_index = 4
	self.x_type54.use_data.selection_index = 4
	self.x_pm9.use_data.selection_index = 4
	self.x_shepheard.use_data.selection_index = 4

	self:_init_weapons()
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


Hooks:PostHook(WeaponTweakData, "init", "eclipse_init_npcweapons", function(self, tweak_data)	
	self.tweak_data = tweak_data
	
	self.g36_npc = copy_data(self.g36_npc, self.m4_npc, self.g36_crew)
	
	self.scar_npc = copy_data(self.scar_npc, self.m4_npc, self.scar_crew)
	
	self.ak47_ass_npc = copy_data(self.ak47_ass_npc, self.m4_npc, self.ak47_crew)
	
	self.g3_npc = copy_data(self.g3_npc, self.m4_npc, self.g3_crew)

	self.beretta92_npc.has_suppressor = "suppressed_b"

	self.deagle_npc.CLIP_AMMO_MAX = 7
	self.deagle_npc.usage = "is_revolver"
	self.deagle_npc.anim_usage = "is_pistol"
	
	self.ump_npc.sounds.prefix = self.schakal_crew.sounds.prefix
	
	self.akmsu_smg_npc = copy_data(self.akmsu_smg_npc, self.mp5_npc, self.akmsu_crew)
	
	self.asval_smg_npc.sounds.prefix = "val_npc"
	self.asval_smg_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
	
	self.s552_zeal_npc = copy_data(self.s552_zeal_npc, self.mp5_npc, self.s552_crew)
	
	self.shepheard_npc = copy_data(self.shepheard_npc, self.mp5_npc, self.shepheard_crew)
	
	self.mac11_npc.sounds.prefix = self.mac10_crew.sounds.prefix
	self.mac11_npc.hold = "pistol"
	self.mac11_npc.reload = "uzi"

	self.sr2_smg_npc.sounds.prefix = self.sr2_crew.sounds.prefix
	
	self.r870_npc.CLIP_AMMO_MAX = 8

	self.benelli_npc = copy_data(self.benelli_npc, self.r870_npc, self.ben_crew)

	self.ksg_npc = copy_data(self.ksg_npc, self.r870_npc, self.ksg_crew)

	self.mossberg_npc.usage = "is_double_barrel"
	self.mossberg_npc.reload = "looped"
	self.mossberg_npc.looped_reload_single = true

	self.saiga_npc.CLIP_AMMO_MAX = 20

	self.m249_npc.muzzleflash = "effects/payday2/particles/weapons/556_auto"
	
	self.rpk_lmg_npc = copy_data(self.rpk_lmg_npc, self.m249_npc, self.rpk_crew)
	
	self.m14_npc.trail = "effects/particles/weapons/sniper_trail" 
	self.m14_npc.CLIP_AMMO_MAX = 10
	self.m14_npc.usage = "is_sniper"

	self.heavy_snp_npc.trail = "effects/particles/weapons/sniper_trail"
	self.heavy_snp_npc.CLIP_AMMO_MAX = 10
	self.heavy_snp_npc.usage = "is_sniper"
	
	self.dmr_npc.trail = "effects/particles/weapons/sniper_trail"
	self.dmr_npc.CLIP_AMMO_MAX = 10
	self.dmr_npc.usage = "is_sniper"
	
	self.m14_sniper_npc.trail = "effects/particles/weapons/sniper_trail"
	self.m14_sniper_npc.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
	self.m14_sniper_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_sniper"
	self.m14_sniper_npc.CLIP_AMMO_MAX = 10
	self.m14_sniper_npc.usage = "is_sniper"

	self.svd_snp_npc.trail = "effects/particles/weapons/sniper_trail"
	self.svd_snp_npc.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
	self.svd_snp_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_sniper"
	self.svd_snp_npc.CLIP_AMMO_MAX = 10
	self.svd_snp_npc.usage = "is_sniper"

	self.svdsil_snp_npc.trail = "effects/particles/weapons/sniper_trail"
	self.svdsil_snp_npc.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
	self.svdsil_snp_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_sniper"
	self.svdsil_snp_npc.CLIP_AMMO_MAX = 10
	self.svdsil_snp_npc.usage = "is_sniper"
	
	self.flamethrower_npc.flame_max_range = 600
end)


local turret_damage_mul = {
	{ 0, 1 },
	{ 1500, 0.5 },
	{ 3000, 0.25 },
	{ 10000, 0 }
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
	x_c45 = "x_g17"
}

local alert_sizes = {
	is_sniper = 10000,
	is_lmg = 6000,
	is_shotgun_pump = 5000,
	is_shotgun_mag = 5000,
	is_double_barrel = 5000,
	is_smg = 3000,
	is_pistol = 2500
}
		
function WeaponTweakData:_set_presets()	
	local diff_i = self.tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or "normal")
	local diff_i_no_normal = diff_i - 2
	local crew_presets = self.tweak_data.character.presets.weapon.gang_member
	for k, v in pairs(self) do
		if k:match("_turret_module") then
			v.DAMAGE = 1 + (0.25 * diff_i_no_normal)
			v.DAMAGE_MUL_RANGE = turret_damage_mul
			v.HEALTH_INIT = 400 + (100 * diff_i_no_normal)
			v.SHIELD_HEALTH_INIT = 100  + (25 * diff_i_no_normal)
			v.CLIP_SIZE = 400
			v.BAG_DMG_MUL = 20
			v.SHIELD_DMG_MUL = 1
			v.FIRE_DMG_MUL = 1
			v.EXPLOSION_DMG_MUL = 5
			v.SHIELD_DAMAGE_CLAMP = nil
			v.BODY_DAMAGE_CLAMP = nil
		elseif k:match("_npc$") then
			v.DAMAGE = 1
			v.suppression = v.armor_piercing and 3 or v.is_shotgun and 2 or 1
			v.spread = v.rays and v.rays > 1 and 6 or 0
			v.alert_size = (alert_sizes[v.usage] or 4000) * (v.has_suppressor and 0.2 or 1)
			
			if v.usage == "is_rifle" or v.usage == "is_bullpup" then
				v.auto = { fire_rate = 0.2 }
			elseif v.usage == "is_smg" then
				v.auto = { fire_rate = 0.15 }
			elseif v.usage == "is_lmg" or v.reload == "uzi" then
				v.auto = { fire_rate = 0.1 }
			elseif v.usage == "mini" or v.usage == "is_flamethrower" then
				v.auto = { fire_rate = 0.05 }
			else		
				v.auto = { fire_rate = 0.25 }
			end
		elseif k:match("_crew$") then
			local player_id = k:gsub("_crew$", ""):gsub("_secondary$", ""):gsub("_primary$", "")
			local player_weapon = crew_weapon_mapping[player_id] and self[crew_weapon_mapping[player_id]] or self[player_id]
			if player_weapon then
				v.CLIP_AMMO_MAX = player_weapon.CLIP_AMMO_MAX
				v.muzzleflash = player_weapon.muzzleflash
				v.shell_ejection = player_weapon.shell_ejection	
				v.alert_size = self.stats.alert_size[player_weapon.stats.alert_size] or v.alert_size
				
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