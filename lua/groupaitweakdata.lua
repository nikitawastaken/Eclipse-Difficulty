-- Increase tickrate to 90
Hooks:PostHook(GroupAITweakData, "init", "eclipse_init", function (self)
	self.ai_tick_rate = 1 / 90
end)

Hooks:PostHook(GroupAITweakData, "_init_unit_categories", "eclipse__init_unit_categories", function(self, difficulty_index)
	if difficulty_index >= 7 then
		self.special_unit_spawn_limits = {
			tank = 2,
			taser = 3,
			spooc = 3,
			shield = 4,
			medic = 4
		}
	end

local access_type_walk_only = {
	walk = true
}
local access_type_all = {
	acrobatic = true,
	walk = true
}

-- UNIT CATEGORIES
-- Honestly if only i could be arsed to actually support all factions

	-- FBI Riflemen
		self.unit_categories.fbi_m4 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1")
				},
				russia = {
					Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1")
				},
				zombie = {
					Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1")
				},
				federales = {
					Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1")
				}
			},
			access = access_type_all
		}

		self.unit_categories.fbi_r870 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2")
				},
				russia = {
					Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2")
				},
				zombie = {
					Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2")
				},
				federales = {
					Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2")
				}
			},
			access = access_type_all
		}

	-- FBI Heavy Riflemen
		self.unit_categories.heavy_fbi_m4 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1")
				},
				russia = {
					Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1")
				},
				zombie = {
					Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1")
				},
				federales = {
					Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1")
				}
			},
			access = access_type_all
		}
	-- FBI Heavy Shotgunners
		self.unit_categories.heavy_fbi_r870 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870")
				},
				russia = {
					Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870")
				},
				zombie = {
					Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870")
				},
				federales = {
					Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870")
				}
			},
			access = access_type_all
		}

	-- GenSec Long Range Riflemen
		self.unit_categories.g36_elite = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1")
				},
				russia = {
					Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1")
				},
				zombie = {
					Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1")
				},
				federales = {
					Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1")
				}
			},
			access = access_type_all
		}

	-- GenSec Shotgunners
		self.unit_categories.benelli_elite = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2")
				},
				russia = {
					Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2")
				},
				zombie = {
					Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2")
				},
				federales = {
					Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2")
				}
			},
			access = access_type_all
		}

	-- GenSec Short Range Riflemen
		self.unit_categories.ump_elite = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3")
				},
				russia = {
					Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3")
				},
				zombie = {
					Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3")
				},
				federales = {
					Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3")
				}
			},
			access = access_type_all
		}

	-- Blue Rifleman
		self.unit_categories.swat_m4 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_swat_1/ene_swat_1")
				},
				russia = {
					Idstring("units/payday2/characters/ene_swat_1/ene_swat_1")
				},
				zombie = {
					Idstring("units/payday2/characters/ene_swat_1/ene_swat_1")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_swat_1/ene_swat_1")
				},
				federales = {
					Idstring("units/payday2/characters/ene_swat_1/ene_swat_1")
				}
			},
			access = access_type_all
		}

	-- Blue Rifleman
		self.unit_categories.swat_r870 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_swat_2/ene_swat_2")
				},
				russia = {
					Idstring("units/payday2/characters/ene_swat_2/ene_swat_2")
				},
				zombie = {
					Idstring("units/payday2/characters/ene_swat_2/ene_swat_2")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_swat_2/ene_swat_2")
				},
				federales = {
					Idstring("units/payday2/characters/ene_swat_2/ene_swat_2")
				}
			},
			access = access_type_all
		}

	-- Balaclava HRU
		self.unit_categories.balaclava = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
				},
				russia = {
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
				},
				zombie = {
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
				},
				federales = {
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
				}
			},
			access = access_type_all
		}

	-- Whiteshirt HRU
		self.unit_categories.whiteshirt = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2")
				},
				russia = {
					Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2")
				},
				zombie = {
					Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2")
				},
				federales = {
					Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2")
				}
			},
			access = access_type_all
		}

	-- FBI Shield
		self.unit_categories.shield_fbi = {
			special_type = "shield",
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_shield_1/ene_shield_1")
				},
				russia = {
					Idstring("units/payday2/characters/ene_shield_1/ene_shield_1")
				},
				zombie = {
					Idstring("units/payday2/characters/ene_shield_1/ene_shield_1")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_shield_1/ene_shield_1")
				},
				federales = {
					Idstring("units/payday2/characters/ene_shield_1/ene_shield_1")
				}
			},
			access = access_type_walk_only
		}

		-- Elite Shield
		self.unit_categories.shield_elite = {
			special_type = "shield",
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_city_shield/ene_city_shield")
				},
				russia = {
					Idstring("units/payday2/characters/ene_city_shield/ene_city_shield")
				},
				zombie = {
					Idstring("units/payday2/characters/ene_city_shield/ene_city_shield")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_city_shield/ene_city_shield")
				},
				federales = {
					Idstring("units/payday2/characters/ene_city_shield/ene_city_shield")
				}
			},
			access = access_type_walk_only
		}

	-- Taser
		self.unit_categories.taser_unit = {
			special_type = "taser",
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1")
				},
				russia = {
					Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1")
				},
				zombie = {
					Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1")
				},
				federales = {
					Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1")
				}
			},
			access = access_type_all
		}

	-- Medic
		self.unit_categories.medic_unit = {
			special_type = "medic",
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"),
					Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870")
				},
				russia = {
					Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"),
					Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870")
				},
				zombie = {
					Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"),
					Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"),
					Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870")
				},
				federales = {
					Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"),
					Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870")
				}
			},
			access = access_type_all
		}

	-- Green / Saiga Dozers
		self.unit_categories.tank_fbi = {
			special_type = "tank",
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"),
					Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2")
				},
				russia = {
					Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"),
					Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2")
				},
				zombie = {
					Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"),
					Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"),
					Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2")
				},
				federales = {
					Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"),
					Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2")
				}
			},
			access = access_type_all
		}

	-- Lmg Dozers
		self.unit_categories.tank_elite = {
			special_type = "tank",
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3")
				},
				russia = {
					Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3")
				},
				zombie = {
					Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3")
				},
				federales = {
					Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3")
				}
			},
			access = access_type_all
		}

	-- Cloakers
		self.unit_categories.cloaker = {
			special_type = "spooc",
			unit_types = {
				america = {
					Idstring( "units/payday2/characters/ene_spook_1/ene_spook_1" )
				},
				russia = {
					Idstring( "units/payday2/characters/ene_spook_1/ene_spook_1" )
				},
				zombie = {
					Idstring( "units/payday2/characters/ene_spook_1/ene_spook_1" )
				},
				murkywater = {
					Idstring( "units/payday2/characters/ene_spook_1/ene_spook_1" )
				},
				federales = {
					Idstring( "units/payday2/characters/ene_spook_1/ene_spook_1" )
				}
			},
			access = access_type_all
		}

end)

Hooks:PostHook(GroupAITweakData, "_init_enemy_spawn_groups", "eclipse__init_enemy_spawn_groups", function(self, difficulty_index)
	-- Tactic Presets
	-- GenSec presets are more advanced than FBI ones
	-- Only GenSec enemies can flank as well, this should make flanking less predictable and far scarier
	self._tactics = {
		Phalanx_minion = {
			"ranged_fire"
		},
		Phalanx_vip = {
			"ranged_fire"
		},
		fbi_rifle = {
			"shield_cover",
			"ranged_fire"
		},
		fbi_shotgun = {
			"charge"
		},
		fbi_special = {
			"flash_grenade",
			"shield_cover",
			"murder"
		},
		fbi_shield = {
			"shield",
			"ranged_fire"
		},
		fbi_tank = {
			"charge",
			"flash_grenade"
		},
		elite_ranged = {
			"ranged_fire",
			"smoke_grenade",
			"flash_grenade",
			"rescue_hostages",
			"shield_cover"
		},
		elite_assault = {
			"smoke_grenade",
			"flash_grenade",
			"rescue_hostages",
			"shield_cover",
			"deathguard",
			"murder"
		},
		elite_shotgun = {
			"charge",
			"flash_grenade",
			"rescue_hostages",
			"shield_cover",
			"deathguard",
			"murder"
		},
		elite_flank = {
			"flank",
			"smoke_grenade",
			"flash_grenade",
			"rescue_hostages",
			"deathguard",
			"murder"
		},
		elite_shield = {
			"shield",
			"ranged_fire",
			"smoke_grenade"
		},
		elite_special = {
			"ranged_fire",
			"shield_cover",
			"smoke_grenade",
			"flash_grenade",
			"deathguard",
			"murder"
		},
		elite_special_flank = {
			"flank",
			"smoke_grenade",
			"flash_grenade",
			"deathguard",
			"murder"
		},
		elite_tank_ranged = {
			"ranged_fire",
			"flash_grenade",
			"smoke_grenade",
			"deathguard",
			"murder"
		},
		spooc_charge = {
			"charge",
			"flash_grenade",
			"smoke_grenade",
			"deathguard"
		},
		spooc_flank = {
			"flank",
			"flash_grenade",
			"smoke_grenade",
			"deathguard"
		},
		reenforce_aggressive = {
			"charge",
			"flash_grenade",
			"smoke_grenade",
		},
		reenforce_passive = {
			"ranged_fire",
			"flash_grenade",
			"smoke_grenade",
		},
		recon_attack = {
			"ranged_fire",
			"smoke_grenade"
		},
		recon_rescue = {
			"flank",
			"flash_grenade",
			"rescue_hostages"
		}
	}

	-- соси хуй кк?
	self.enemy_spawn_groups = {}

	-- Custom spawngroups
	if difficulty_index >= 7 then
		self.enemy_spawn_groups.fbi_lights = {
			amount = {
				3,
				4
			},
			spawn = {
				{
					freq = 0.75,
					amount_max = 3,
					rank = 1,
					unit = "fbi_m4",
					tactics = self._tactics.fbi_rifle
				},
				{
					freq = 0.75,
					amount_max = 3,
					rank = 1,
					unit = "fbi_r870",
					tactics = self._tactics.fbi_shotgun
				},
				{
					freq = 0.35,
					amount_max = 1,
					rank = 2,
					unit = "whiteshirt",
					tactics = self._tactics.elite_ranged
				}
			}
		}
		self.enemy_spawn_groups.fbi_heavies = {
			amount = {
				3,
				4
			},
			spawn = {
				{
					freq = 0.75,
					amount_max = 3,
					rank = 1,
					unit = "heavy_fbi_m4",
					tactics = self._tactics.fbi_rifle
				},
				{
					freq = 0.75,
					amount_max = 3,
					rank = 1,
					unit = "heavy_fbi_r870",
					tactics = self._tactics.fbi_shotgun
				},
				{
					freq = 0.35,
					amount_max = 1,
					rank = 2,
					unit = "medic_unit",
					tactics = self._tactics.fbi_special
				}
			}
		}
		self.enemy_spawn_groups.fbi_shields = {
			amount = {
				3,
				4
			},
			spawn = {
				{
					amount_min = 2,
					freq = 2,
					amount_max = 2,
					rank = 3,
					unit = "shield_fbi",
					tactics = self._tactics.fbi_shield
				},
				{
					freq = 0.35,
					amount_max = 1,
					rank = 2,
					unit = "taser_unit",
					tactics = self._tactics.fbi_special
				},
				{
					amount_min = 1,
					freq = 1,
					amount_max = 1,
					rank = 1,
					unit = "heavy_fbi_m4",
					tactics = self._tactics.fbi_rifle
				}
			}
		}
		self.enemy_spawn_groups.fbi_tanks = {
			amount = {
				3,
				4
			},
			spawn = {
				{
					amount_min = 1,
					freq = 1,
					amount_max = 1,
					rank = 3,
					unit = "tank_fbi",
					tactics = self._tactics.fbi_tank
				},
				{
					amount_min = 1,
					freq = 0.5,
					amount_max = 1,
					rank = 2,
					unit = "taser_unit",
					tactics = self._tactics.fbi_special
				},
				{
					freq = 0.75,
					amount_max = 1,
					rank = 2,
					unit = "medic_unit",
					tactics = self._tactics.fbi_special
				},
				{
					amount_min = 1,
					freq = 1,
					amount_max = 1,
					rank = 1,
					unit = "heavy_fbi_m4",
					tactics = self._tactics.fbi_rifle
				}
			}
		}
		self.enemy_spawn_groups.gensec_cqc_lights = {
			amount = {
				3,
				4
			},
			spawn = {
				{
					freq = 0.66,
					amount_max = 3,
					rank = 2,
					unit = "benelli_elite",
					tactics = self._tactics.elite_shotgun
				},
				{
					freq = 0.66,
					amount_max = 3,
					rank = 2,
					unit = "ump_elite",
					tactics = self._tactics.elite_assault
				},
				{
					freq = 0.15,
					amount_max = 1,
					rank = 3,
					unit = "cloaker",
					tactics = self._tactics.spooc_charge
				},
			}
		}
		self.enemy_spawn_groups.gensec_ranged_lights = {
			amount = {
				3,
				4
			},
			spawn = {
				{
					freq = 0.66,
					amount_max = 3,
					rank = 2,
					unit = "g36_elite",
					tactics = self._tactics.elite_ranged
				},
				{
					freq = 0.66,
					amount_max = 3,
					rank = 2,
					unit = "ump_elite",
					tactics = self._tactics.elite_assault
				},
				{
					freq = 0.15,
					amount_max = 1,
					rank = 3,
					unit = "taser_unit",
					tactics = self._tactics.elite_special
				},
			}
		}
		self.enemy_spawn_groups.gensec_shields = {
			amount = {
				3,
				4
			},
			spawn = {
				{
					amount_min = 2,
					freq = 2,
					amount_max = 2,
					rank = 3,
					unit = "shield_elite",
					tactics = self._tactics.elite_shield
				},
				{
					freq = 0.35,
					amount_max = 1,
					rank = 2,
					unit = "taser_unit",
					tactics = self._tactics.elite_special
				},
				{
					amount_min = 1,
					freq = 1,
					amount_max = 1,
					rank = 1,
					unit = "g36_elite",
					tactics = self._tactics.elite_ranged
				},
				{
					freq = 0.75,
					amount_max = 1,
					rank = 1,
					unit = "heavy_fbi_m4",
					tactics = self._tactics.elite_ranged
				}
			}
		}
		self.enemy_spawn_groups.gensec_flankers = {
			amount = {
				3,
				4
			},
			spawn = {
				{
					freq = 0.2,
					amount_max = 1,
					rank = 3,
					unit = "taser_unit",
					tactics = self._tactics.elite_special_flank
				},
				{
					freq = 0.66,
					amount_max = 3,
					rank = 2,
					unit = "ump_elite",
					tactics = self._tactics.elite_flank
				},
				{
					freq = 0.66,
					amount_max = 3,
					rank = 2,
					unit = "benelli_elite",
					tactics = self._tactics.elite_flank
				}
			}
		}
		self.enemy_spawn_groups.gensec_tasers = {
			amount = {
				3,
				4
			},
			spawn = {
				{
					amount_min = 2,
					freq = 2,
					amount_max = 2,
					rank = 3,
					unit = "taser_unit",
					tactics = self._tactics.elite_special
				},
				{
					freq = 0.33,
					amount_max = 1,
					rank = 2,
					unit = "medic_unit",
					tactics = self._tactics.elite_special
				},
				{
					freq = 0.15,
					amount_max = 1,
					rank = 2,
					unit = "cloaker",
					tactics = self._tactics.spooc_charge
				},
				{
					freq = 0.75,
					amount_max = 2,
					rank = 1,
					unit = "ump_elite",
					tactics = self._tactics.elite_assault
				}
			}
		}
		self.enemy_spawn_groups.gensec_tanks = {
			amount = {
				3,
				4
			},
			spawn = {
				{
					amount_min = 1,
					freq = 1,
					amount_max = 1,
					rank = 3,
					unit = "tank_elite",
					tactics = self._tactics.elite_tank_ranged
				},
				{
					amount_min = 1,
					freq = 1,
					amount_max = 1,
					rank = 2,
					unit = "medic_unit",
					tactics = self._tactics.elite_special
				},
				{
					amount_min = 1,
					freq = 0.33,
					amount_max = 2,
					rank = 1,
					unit = "shield_elite",
					tactics = self._tactics.elite_shield
				}
			}
		}
		self.enemy_spawn_groups.spoocs = {
			amount = {
				2,
				2
			},
			spawn = {
				{
					freq = 2,
					amount_min = 2,
					amount_max = 2,
					rank = 1,
					unit = "cloaker",
					tactics = self._tactics.spooc_flank
				}
			}
		}
		self.enemy_spawn_groups.reenforce_tank = {
			amount = {
				4,
				4
			},
			spawn = {
				{
					amount_min = 1,
					freq = 1,
					amount_max = 1,
					rank = 3,
					unit = "tank_fbi",
					tactics = self._tactics.reenforce_aggressive
				},
				{
					amount_min = 1,
					freq = 1,
					amount_max = 1,
					rank = 2,
					unit = "taser_unit",
					tactics = self._tactics.reenforce_aggressive
				},
				{
					amount_min = 2,
					freq = 2,
					amount_max = 2,
					rank = 1,
					unit = "balaclava",
					tactics = self._tactics.reenforce_aggressive
				}
			}
		}
		self.enemy_spawn_groups.reenforce_sneaky = {
			amount = {
				4,
				4
			},
				spawn = {
				{
					amount_min = 2,
					freq = 2,
					amount_max = 2,
					rank = 2,
					unit = "cloaker",
					tactics = self._tactics.reenforce_aggressive
				},
				{
					amount_min = 2,
					freq = 2,
					amount_max = 2,
					rank = 1,
					unit = "whiteshirt",
					tactics = self._tactics.reenforce_aggressive
				}
			}
		}
		self.enemy_spawn_groups.reenforce_common = {
			amount = {
				4,
				4
			},
				spawn = {
				{
					amount_min = 2,
					freq = 2,
					amount_max = 2,
					rank = 1,
					unit = "balaclava",
					tactics = self._tactics.reenforce_aggressive
				},
				{
					amount_min = 2,
					freq = 2,
					amount_max = 2,
					rank = 1,
					unit = "whiteshirt",
					tactics = self._tactics.reenforce_passive
				}
			}
		}
		self.enemy_spawn_groups.recon_hrt = {
			amount = {
				4,
				4
			},
				spawn = {
				{
					amount_min = 2,
					freq = 1,
					amount_max = 2,
					rank = 1,
					unit = "balaclava",
					tactics = self._tactics.recon_rescue
				},
				{
					amount_min = 2,
					freq = 1,
					amount_max = 2,
					rank = 1,
					unit = "whiteshirt",
					tactics = self._tactics.recon_rescue
				}
			}
		}
		self.enemy_spawn_groups.recon_aggressive = {
			amount = {
				3,
				3
			},
				spawn = {
				{
					amount_min = 1,
					freq = 1,
					amount_max = 1,
					rank = 1,
					unit = "swat_shotgun",
					tactics = self._tactics.recon_attack
				},
				{
					amount_min = 1,
					freq = 1,
					amount_max = 1,
					rank = 1,
					unit = "swat_rifle",
					tactics = self._tactics.recon_attack
				},
				{
					amount_min = 1,
					freq = 1,
					amount_max = 1,
					rank = 2,
					unit = "taser_unit",
					tactics = self._tactics.recon_attack
				}
			}
		}
	end
	self.enemy_spawn_groups.single_spooc = {
		amount = {
			1,
			1
		},
		spawn = {
			{
				freq = 1,
				amount_min = 1,
				rank = 1,
				unit = "cloaker",
				tactics = self._tactics.spooc
			}
		}
	}
	self.enemy_spawn_groups.FBI_spoocs = self.enemy_spawn_groups.single_spooc

    -- remove marshals
    if self.enemy_spawn_groups.marshal_squad then
        self.enemy_spawn_groups.marshal_squad.max_nr_simultaneous_groups = 0
    end
end)

Hooks:PostHook(GroupAITweakData, "_init_task_data", "eclipse__init_task_data", function(self, difficulty_index, difficulty)
	local is_console = SystemInfo:platform() ~= Idstring("WIN32")
	if difficulty_index == 7 or 8 then
		self.besiege.recurring_group_SO = {
			recurring_cloaker_spawn = {
				retire_delay = 30,
				interval = {
					20,
					40
				}
			},
			recurring_spawn_1 = {interval = {
				30,
				60
			}}
		}
	end

	-- Assault Data
		-- PHASES --

		-- Sustain
		self.besiege.assault.sustain_duration_min = {70, 140, 210}
		self.besiege.assault.sustain_duration_max = {70, 140, 210}
		self.besiege.assault.sustain_duration_balance_mul = {1, 1, 1, 1}

		-- Control
		self.besiege.assault.delay = {20, 15, 7.5}

		-- SPAWNS --

		-- Spawncap
		self.besiege.assault.force = {8, 12, 16}
		self.besiege.assault.force_balance_mul = {1, 1.5, 1.75, 2}

		-- Spawnrate
		if difficulty_index == 7 then
			self.besiege.assault.spawnrate_balance_mul = {2.25, 1.6, 1.4, 1.3}
		elseif difficulty_index == 8 then
			self.besiege.assault.spawnrate_balance_mul = {2, 1.4, 1.25, 1.15}
		end

		-- RECON / REENFORCE --

		-- Make reenforce spawngroups spawn faster
		self.besiege.reenforce.interval = {45, 35, 25}

    	-- Make recon spawngroups spawn faster and increase their spawncap
    	self.besiege.recon.interval_variation = 0
    	self.besiege.recon.interval = {10, 8, 5}
    	self.besiege.recon.force = {2, 6, 10}

		-- GRENADES --
		--shared
		self.flash_grenade.light_color = Vector3(255, 255, 255)
		self.flash_grenade.light_range = 500
		self.smoke_grenade_timeout = {25, 35}
		self.flash_grenade_timeout = {15, 20}
		self.cs_grenade_timeout = {55, 75}

		if difficulty_index == 7 then
			self.flash_grenade.timer = 1.35
			self.smoke_grenade_lifetime = 14
			self.cs_grenade_lifetime = 14

		elseif difficulty_index == 8 then
			self.flash_grenade.timer = 1
			self.smoke_grenade_lifetime = 20
			self.cs_grenade_lifetime = 20
		end

	-- Spawngroups
	if difficulty_index >= 7 then
		self.besiege.assault.groups = {
			fbi_lights = {1.75, 1.75, 0},
			fbi_heavies = {0.5, 0.5, 1.25},
			fbi_shields = {0.4, 0.4, 0.25},
			fbi_tanks = {0, 0.02, 0.13},
			gensec_cqc_lights = {0.3, 0.3, 0.5},
			gensec_ranged_lights = {0.3, 0.3, 0.5},
			gensec_shields = {0.15, 0.15, 0.3},
			gensec_flankers = {0.25, 0.25, 0.45},
			gensec_tasers = {0.15, 0.15, 0.3},
			gensec_tanks = {0, 0, 0.09},
			spoocs = {0, 0.06, 0.12},
			single_spooc = {0, 0, 0},
			Phalanx = {0, 0, 0},
			marshal_squad = {0, 0, 0},
			custom_assault = {0, 0, 0}
		}
		self.besiege.recon.groups = {
			recon_hrt = {1, 1, 1},
			recon_aggressive = {0.66, 0.66, 0.66},
			single_spooc = {0, 0, 0},
			Phalanx = {0, 0, 0},
			marshal_squad = {0, 0, 0},
			custom_recon = {0, 0, 0}
		}
		self.besiege.reenforce.groups = {
			reenforce_common = {0.3, 0.3, 0.3},
			reenforce_sneaky = {0.2, 0.2, 0.2},
			reenforce_tank = {0.15, 0.15, 0.15}
		}
	end

	-- Hoxd1 is a shit heist
	if Global.level_data and Global.level_data.level_id == "hox_1" then
		self.besiege.assault.spawnrate_balance_mul = {2.75, 1.85, 1.45, 1.2}
	end

	-- nuke captain
	self.phalanx.spawn_chance = {
		decrease = 0,
		start = 0,
		respawn_delay = 300000,
		increase = 0,
		max = 1
	}

	self.street = deep_clone(self.besiege)
	self.safehouse = deep_clone(self.besiege)
end)
