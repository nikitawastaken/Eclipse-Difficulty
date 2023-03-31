Hooks:PostHook(GroupAITweakData, "_init_unit_categories", "eclipse__init_unit_categories", function(self, difficulty_index)
	if difficulty_index == 2 then
		self.special_unit_spawn_limits = {
			tank = 0,
			taser = 0,
			spooc = 0,
			shield = 2,
			medic = 0
		}
	elseif difficulty_index == 3 then
		self.special_unit_spawn_limits = {
			tank = 0,
			taser = 1,
			spooc = 0,
			shield = 2,
			medic = 0
		}
	elseif difficulty_index == 4 then
		self.special_unit_spawn_limits = {
			tank = 1,
			taser = 2,
			spooc = 0,
			shield = 2,
			medic = 0
		}
	elseif difficulty_index == 5 then
		self.special_unit_spawn_limits = {
			tank = 1,
			taser = 3,
			spooc = 2,
			shield = 2,
			medic = 3
		}
	elseif difficulty_index == 6 then
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

	-- SWAT Rifleman
		self.unit_categories.beat_cop = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
					Idstring("units/payday2/characters/ene_cop_2/ene_cop_2"),
					Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
					Idstring("units/payday2/characters/ene_cop_4/ene_cop_4")
				},
				russia = {
					Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
					Idstring("units/payday2/characters/ene_cop_2/ene_cop_2"),
					Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
					Idstring("units/payday2/characters/ene_cop_4/ene_cop_4")
				},
				zombie = {
					Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
					Idstring("units/payday2/characters/ene_cop_2/ene_cop_2"),
					Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
					Idstring("units/payday2/characters/ene_cop_4/ene_cop_4")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
					Idstring("units/payday2/characters/ene_cop_2/ene_cop_2"),
					Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
					Idstring("units/payday2/characters/ene_cop_4/ene_cop_4")
				},
				federales = {
					Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
					Idstring("units/payday2/characters/ene_cop_2/ene_cop_2"),
					Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
					Idstring("units/payday2/characters/ene_cop_4/ene_cop_4")
				}
			},
			access = access_type_all
		}

	-- SWAT Rifleman
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

	-- SWAT Shotgunner
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

	-- SWAT Shield
		self.unit_categories.swat_shield = {
			special_type = "shield",
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_shield_2/ene_shield_2")
				},
				russia = {
					Idstring("units/payday2/characters/ene_shield_2/ene_shield_2")
				},
				zombie = {
					Idstring("units/payday2/characters/ene_shield_2/ene_shield_2")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_shield_2/ene_shield_2")
				},
				federales = {
					Idstring("units/payday2/characters/ene_shield_2/ene_shield_2")
				}
			},
			access = access_type_walk_only
		}

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

	-- FBI Shotgunners
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

	-- Elite Shield
		self.unit_categories.shield_elite = {
			special_type = "shield",
			unit_types = {
				america = {
					Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1/ene_phalanx_1")
				},
				russia = {
					Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1/ene_phalanx_1")
				},
				zombie = {
					Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1/ene_phalanx_1")
				},
				murkywater = {
					Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1/ene_phalanx_1")
				},
				federales = {
					Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1/ene_phalanx_1")
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

	-- FBI Dozers
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

	-- Elite Dozers
		self.unit_categories.tank_elite = {
			special_type = "tank",
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"),
					Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic")
				},
				russia = {
					Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"),
					Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic")
				},
				zombie = {
					Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"),
					Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"),
					Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic")
				},
				federales = {
					Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"),
					Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic")
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
	-- Only GenSec enemies can flank as well, this makes flanking less predictable and defines them as the superior faction
	self._tactics = {
		beat_cop = {
			"ranged_fire",
			"rescue_hostages"
		},
		swat_assault = {
			"shield_cover"
		},
		swat_shield = {
			"shield"
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
			"murder"
		},
		elite_special_flank = {
			"flank",
			"smoke_grenade",
			"flash_grenade",
			"murder"
		},
		elite_tank = {
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
			"smoke_grenade"
		},
		reenforce_aggressive = {
			"charge",
			"flash_grenade",
			"smoke_grenade"
		},
		reenforce_passive = {
			"ranged_fire",
			"flash_grenade",
			"smoke_grenade"
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
	self.enemy_spawn_groups.beat_cops = {
		amount = {
			2,
			3
		},
		spawn = {
			{
				amount_min = 2,
				freq = 0.5,
				amount_max = 3,
				rank = 1,
				unit = "beat_cop",
				tactics = self._tactics.beat_cop
			}
		}
	}
	self.enemy_spawn_groups.blue_swats = {
		amount = {
			2,
			3
		},
		spawn = {
			{
				amount_min = 1,
				freq = 0.75,
				amount_max = 3,
				rank = 1,
				unit = "swat_m4",
				tactics = self._tactics.swat_assault
			},
			{
				freq = 0.35,
				amount_max = 2,
				rank = 1,
				unit = "swat_r870",
				tactics = self._tactics.swat_assault
			}
		}
	}
	self.enemy_spawn_groups.swat_shields = {
		amount = {
			3,
			3
		},
		spawn = {
			{
				amount_min = 2,
				freq = 1,
				rank = 1,
				unit = "swat_m4",
				tactics = self._tactics.swat_assault
			},
			{
				amount_min = 1,
				freq = 1,
				amount_max = 1,
				rank = 2,
				unit = "swat_shield",
				tactics = self._tactics.swat_shield
			}
		}
	}
	self.enemy_spawn_groups.swat_tasers = {
		amount = {
			2,
			3
		},
		spawn = {
			{
				amount_min = 1,
				freq = 0.5,
				amount_max = 2,
				rank = 1,
				unit = "swat_m4",
				tactics = self._tactics.swat_assault
			},
			{
				freq = 0.5,
				amount_max = 1,
				rank = 2,
				unit = "swat_shield",
				tactics = self._tactics.swat_shield
			},
			{
				amount_min = 1,
				freq = 1,
				amount_max = 1,
				rank = 3,
				unit = "taser_unit",
				tactics = self._tactics.swat_assault
			}
		}
	}
	self.enemy_spawn_groups.swat_tanks = {
		amount = {
			1,
			2
		},
		spawn = {
			{
				amount_min = 1,
				freq = 1,
				amount_max = 1,
				rank = 2,
				unit = "tank_fbi",
				tactics = self._tactics.fbi_tank
			},
			{
				amount_min = 1,
				freq = 1,
				amount_max = 1,
				rank = 1,
				unit = "swat_m4",
				tactics = self._tactics.swat_assault
			}
		}
	}
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
			3
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
				freq = 1,
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
				amount_min = 1,
				freq = 2,
				amount_max = 1,
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
			4,
			4
		},
		spawn = {
			{
				amount_min = 1,
				freq = 1,
				amount_max = 1,
				rank = 3,
				unit = "tank_elite",
				tactics = self._tactics.elite_tank
			},
			{
				amount_min = 1,
				freq = 1,
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
				unit = "medic_unit",
				tactics = self._tactics.elite_special
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
				unit = "swat_r870",
				tactics = self._tactics.recon_attack
			},
			{
				amount_min = 1,
				freq = 1,
				amount_max = 1,
				rank = 1,
				unit = "swat_m4",
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

Hooks:PostHook(GroupAITweakData, "_init_task_data", "eclipse__init_task_data", function(self, difficulty_index)
	local f = ((difficulty_index ^ 2) / (difficulty_index * 3))

	-- Assault Data
		-- AI Tickrate
		self.ai_tickrate = 1 / (math.max(30, 30 * f))

		-- PHASES --

		-- Sustain
		self.besiege.assault.sustain_duration_min = {40 * f, 75 * f, 105 * f}
		self.besiege.assault.sustain_duration_max = {40 * f, 75 * f, 105 * f}
		self.besiege.assault.sustain_duration_balance_mul = {1, 1, 1, 1}

		-- Control
		self.besiege.assault.delay = {40 / f, 30 / f, 15 / f}

		-- SPAWNS --

		-- Spawncap
		self.besiege.assault.force = {4, 7, math.min(7, 7.5 * f)}
		self.besiege.assault.force_balance_mul = {1.5, 1.5, 1.75, 2}

		-- Spawnrate
		self.besiege.assault.spawnrate = {2, 1.6, 1.2}
		self.besiege.assault.spawnrate_balance_mul = {2.2, 1.6, 1.45, 1.35}

		-- RECON / REENFORCE --

		-- Reenforce spawn interval
		self.besiege.reenforce.interval = {60 / f, 40 / f, 20 / f}

    	-- Recon spawn interval and spawncap
    	self.besiege.recon.interval_variation = 0
    	self.besiege.recon.interval = {20 / f, 16 / f, 10 / f}
    	self.besiege.recon.force = {2, 4, 6}

		-- GRENADES --
		--flash
		self.flash_grenade.light_color = Vector3(255, 255, 255)
		self.flash_grenade.light_range = 500
		self.flash_grenade_timeout = {30 / f, 40 / f}
		self.flash_grenade.timer = 2 / f
		--smoke & gas
		self.smoke_grenade_timeout = {50 / f, 70 / f}
		self.smoke_grenade_lifetime = 10 * f
		self.cs_grenade_timeout = {110 / f, 150 / f}
		self.cs_grenade_lifetime = 10 * f


	-- Spawngroups
		if difficulty_index == 2 then
			self.besiege.assault.groups = {
				beat_cops = {0.5, 0.4, 0.25},
				blue_swats = {1, 1, 1},
				swat_shields = {0, 0, 0.25}
			}
			self.besiege.recon.groups = {
				blue_swats = {0, 0, 0}
			}
			self.besiege.reenforce.groups = {
				blue_swats = {1, 1, 1}
			}
		elseif difficulty_index == 3 then
			self.besiege.assault.groups = {
				beat_cops = {0.5, 0.25, 0},
				blue_swats = {0.8, 0.8, 1},
				swat_shields = {0, 0.125, 0.2},
				swat_tasers = {0, 0.1, 0.15},
				fbi_lights = {0, 0.1, 0.4}
			}
			self.besiege.recon.groups = {
				beat_cops = {1, 1, 1}
			}
			self.besiege.reenforce.groups = {
				blue_swats = {1, 1, 1}
			}
		elseif difficulty_index == 4 then
			self.besiege.assault.groups = {
				blue_swats = {0, 0.8, 0.75},
				swat_shields = {0, 0.125, 0.2},
				swat_tasers = {0, 0.1, 0.2},
				swat_tanks = {0, 0.01, 0.06},
				fbi_lights = {0, 1, 1.5},
				fbi_heavies = {0, 0.25, 0.75}
			}
			self.besiege.recon.groups = {
				recon_hrt = {1, 1, 1},
				recon_aggressive = {0.66, 0.66, 0.66}
			}
			self.besiege.reenforce.groups = {
				reenforce_common = {0.3, 0.3, 0.3}
			}
		elseif difficulty_index == 5 then
			self.besiege.assault.groups = {
				blue_swats = {1, 0.45, 0.25},
				swat_shields = {0.3, 0.3, 0.2},
				swat_tasers = {0.25, 0.25, 0.25},
				fbi_lights = {1.5, 1.5, 1.5},
				fbi_heavies = {0.3, 0.5, 1},
				fbi_shields = {0.2, 0.2, 0.3},
				fbi_tanks = {0, 0.02, 0.09},
				spoocs = {0, 0.03, 0.06}
			}
			self.besiege.recon.groups = {
				recon_hrt = {1, 1, 1},
				recon_aggressive = {0.66, 0.66, 0.66}
			}
			self.besiege.reenforce.groups = {
				reenforce_common = {0.3, 0.3, 0.3},
				reenforce_sneaky = {0, 0.05, 0.1}
			}
		elseif difficulty_index == 6 then
			self.besiege.assault.groups = {
				blue_swats = {1, 0.45, 0},
				fbi_lights = {1.75, 1.75, 0},
				fbi_heavies = {0.5, 0.5, 1.25},
				fbi_shields = {0.4, 0.4, 0.4},
				fbi_tanks = {0, 0.02, 0.13},
				gensec_cqc_lights = {0.3, 0.3, 0.5},
				gensec_ranged_lights = {0.3, 0.3, 0.5},
				gensec_flankers = {0.25, 0.25, 0.45},
				gensec_tasers = {0.15, 0.15, 0.3},
				gensec_shields = {0.00, 0.00, 0.15},
				gensec_tanks = {0, 0, 0.1},
				spoocs = {0, 0.045, 0.09},
			}
			self.besiege.recon.groups = {
				recon_hrt = {1, 1, 1},
				recon_aggressive = {0.66, 0.66, 0.66}
			}
			self.besiege.reenforce.groups = {
				reenforce_common = {0.3, 0.3, 0.3},
				reenforce_sneaky = {0.2, 0.2, 0.2}
			}
		end


	-- misc
	self.besiege.assault.groups.single_spooc = {0, 0, 0}
	self.besiege.assault.groups.Phalanx = {0, 0, 0}
	self.besiege.assault.groups.marshal_squad = {0, 0, 0}
	self.besiege.assault.groups.custom_assault = {0, 0, 0}
	self.besiege.recon.groups.single_spooc = {0, 0, 0}
	self.besiege.recon.groups.Phalanx = {0, 0, 0}
	self.besiege.recon.groups.marshal_squad = {0, 0, 0}
	self.besiege.recon.groups.custom_assault = {0, 0, 0}


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
