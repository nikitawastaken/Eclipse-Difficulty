local level_id = Eclipse.utils.level_id()
local is_pro_job = Eclipse.utils.is_pro_job()

local function diff_lerp(value_1, value_2)
	return Eclipse.utils.diff_lerp(value_1, value_2)
end

-- Improve enemy chatter, make proper use of chatter settings like duration and radius
Hooks:PostHook(GroupAITweakData, "_init_chatter_data", "sh__init_chatter_data", function(self)
	local interval = { 1, 2 }
	local duration_short = { 5, 10 }
	local duration_medium = { 10, 20 }
	local duration_long = { 20, 40 }
	local radius_small = 1000
	local radius_medium = 1500
	local radius_large = 2000

	for _, chatter in pairs(self.enemy_chatter) do
		chatter.interval = interval
		chatter.duration = duration_short
		chatter.radius = radius_small
		chatter.max_nr = 1
	end

	-- Loud chatter
	self.enemy_chatter.aggressive.duration = duration_medium
	self.enemy_chatter.contact.duration = duration_medium
	self.enemy_chatter.retreat.queue = "m01"
	self.enemy_chatter.push = clone(self.enemy_chatter.go_go)
	self.enemy_chatter.push.queue = "pus"
	self.enemy_chatter.flank = clone(self.enemy_chatter.go_go)
	self.enemy_chatter.flank.queue = "t01"
	self.enemy_chatter.open_fire = clone(self.enemy_chatter.go_go)
	self.enemy_chatter.open_fire.queue = "att"
	self.enemy_chatter.suppress = clone(self.enemy_chatter.go_go)
	self.enemy_chatter.suppress.queue = "hlp"
	self.enemy_chatter.get_hostages = clone(self.enemy_chatter.go_go)
	self.enemy_chatter.get_hostages.queue = "civ"
	self.enemy_chatter.get_loot = clone(self.enemy_chatter.go_go)
	self.enemy_chatter.get_loot.queue = "l01"
	self.enemy_chatter.watch_background = clone(self.enemy_chatter.go_go)
	self.enemy_chatter.watch_background.queue = "bak"
	self.enemy_chatter.watch_background.duration = duration_medium
	self.enemy_chatter.hostage_delay = clone(self.enemy_chatter.go_go)
	self.enemy_chatter.hostage_delay.queue = "p02"
	self.enemy_chatter.hostage_delay.duration = duration_long
	self.enemy_chatter.hostage_delay.radius = radius_medium
	self.enemy_chatter.group_death = clone(self.enemy_chatter.watch_background)
	self.enemy_chatter.group_death.queue = "lk3a"
	self.enemy_chatter.sentry_gun = clone(self.enemy_chatter.contact)
	self.enemy_chatter.sentry_gun.queue = "ch2"
	self.enemy_chatter.sentry_gun.duration = duration_long
	self.enemy_chatter.sentry_gun.radius = radius_large
	self.enemy_chatter.jammer = clone(self.enemy_chatter.aggressive)
	self.enemy_chatter.jammer.queue = "ch3"
	self.enemy_chatter.jammer.radius = radius_medium

	-- Stealth chatter
	self.enemy_chatter.idle = clone(self.enemy_chatter.go_go)
	self.enemy_chatter.idle.queue = "a06"
	self.enemy_chatter.idle.duration = duration_long
	self.enemy_chatter.idle.radius = radius_large
	self.enemy_chatter.report = clone(self.enemy_chatter.idle)
	self.enemy_chatter.report.queue = "a05"
end)

Hooks:PostHook(GroupAITweakData, "_init_unit_categories", "eclipse__init_unit_categories", function(self, difficulty_index)
	local access_type_walk_only = {
		walk = true,
	}
	local access_type_all = {
		acrobatic = true,
		walk = true,
	}
	
	if difficulty_index <= 2 then
		self.special_unit_spawn_limits = {
			shield = 2,
			taser = 0,
			tank = 0,
			spooc = 0,
			medic = 0,
		}
	elseif difficulty_index == 3 then
		self.special_unit_spawn_limits = {
			shield = 2,
			taser = 1,
			tank = 1,
			spooc = 0,
			medic = 0,
		}
	elseif difficulty_index == 4 then
		self.special_unit_spawn_limits = {
			shield = 3,
			taser = 1,
			tank = 1,
			spooc = 2,
			medic = 2,
		}
	elseif difficulty_index == 5 then
		self.special_unit_spawn_limits = {
			shield = 4,
			taser = 2,
			tank = 1,
			spooc = 2,
			medic = 3,
		}
	elseif difficulty_index == 6 then
		self.special_unit_spawn_limits = {
			shield = 5,
			taser = 3,
			tank = 2,
			spooc = 3,
			medic = 4,
		}
	end

	self.unit_categories.CS_cop_1 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_cop_1/ene_cop_1") },
			russia = { Idstring("units/payday2/characters/ene_cop_1/ene_cop_1") },
			zombie = { Idstring("units/payday2/characters/ene_cop_1/ene_cop_1") },
			murkywater = { Idstring("units/payday2/characters/ene_cop_1/ene_cop_1") },
			federales = { Idstring("units/payday2/characters/ene_cop_1/ene_cop_1") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.CS_cop_2 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_cop_2/ene_cop_2") },
			russia = { Idstring("units/payday2/characters/ene_cop_2/ene_cop_2") },
			zombie = { Idstring("units/payday2/characters/ene_cop_2/ene_cop_2") },
			murkywater = { Idstring("units/payday2/characters/ene_cop_2/ene_cop_2") },
			federales = { Idstring("units/payday2/characters/ene_cop_2/ene_cop_2") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.CS_cop_3 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_cop_3/ene_cop_3") },
			russia = { Idstring("units/payday2/characters/ene_cop_3/ene_cop_3") },
			zombie = { Idstring("units/payday2/characters/ene_cop_3/ene_cop_3") },
			murkywater = { Idstring("units/payday2/characters/ene_cop_3/ene_cop_3") },
			federales = { Idstring("units/payday2/characters/ene_cop_3/ene_cop_3") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.CS_cop_4 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_cop_4/ene_cop_4") },
			russia = { Idstring("units/payday2/characters/ene_cop_4/ene_cop_4") },
			zombie = { Idstring("units/payday2/characters/ene_cop_4/ene_cop_4") },
			murkywater = { Idstring("units/payday2/characters/ene_cop_4/ene_cop_4") },
			federales = { Idstring("units/payday2/characters/ene_cop_4/ene_cop_4") },
		},
		access = access_type_walk_only,
	}
	
	self.unit_categories.CS_cop_1_2 = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
				Idstring("units/payday2/characters/ene_cop_2/ene_cop_2"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
				Idstring("units/payday2/characters/ene_cop_2/ene_cop_2"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
				Idstring("units/payday2/characters/ene_cop_2/ene_cop_2"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
				Idstring("units/payday2/characters/ene_cop_2/ene_cop_2"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
				Idstring("units/payday2/characters/ene_cop_2/ene_cop_2"),
			},
		},
		access = access_type_walk_only,
	}

	self.unit_categories.CS_cop_1_4 = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
				Idstring("units/payday2/characters/ene_cop_4/ene_cop_4"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
				Idstring("units/payday2/characters/ene_cop_4/ene_cop_4"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
				Idstring("units/payday2/characters/ene_cop_4/ene_cop_4"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
				Idstring("units/payday2/characters/ene_cop_4/ene_cop_4"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
				Idstring("units/payday2/characters/ene_cop_4/ene_cop_4"),
			},
		},
		access = access_type_walk_only,
	}
	
	self.unit_categories.CS_cop_3_4 = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
				Idstring("units/payday2/characters/ene_cop_4/ene_cop_4"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
				Idstring("units/payday2/characters/ene_cop_4/ene_cop_4"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
				Idstring("units/payday2/characters/ene_cop_4/ene_cop_4"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
				Idstring("units/payday2/characters/ene_cop_4/ene_cop_4"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
				Idstring("units/payday2/characters/ene_cop_4/ene_cop_4"),
			},
		},
		access = access_type_walk_only,
	}
	
	self.unit_categories.CS_swat_1 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_swat_1/ene_swat_1") },
			russia = { Idstring("units/payday2/characters/ene_swat_1/ene_swat_1") },
			zombie = { Idstring("units/payday2/characters/ene_swat_1/ene_swat_1") },
			murkywater = { Idstring("units/payday2/characters/ene_swat_1/ene_swat_1") },
			federales = { Idstring("units/payday2/characters/ene_swat_1/ene_swat_1") },
		},
		access = access_type_all,
	}

	self.unit_categories.CS_swat_2 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_swat_2/ene_swat_2") },
			russia = { Idstring("units/payday2/characters/ene_swat_2/ene_swat_2") },
			zombie = { Idstring("units/payday2/characters/ene_swat_2/ene_swat_2") },
			murkywater = { Idstring("units/payday2/characters/ene_swat_2/ene_swat_2") },
			federales = { Idstring("units/payday2/characters/ene_swat_2/ene_swat_2") },
		},
		access = access_type_all,
	}

	self.unit_categories.CS_swat_3 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_swat_1/ene_swat_1") },
			russia = { Idstring("units/payday2/characters/ene_swat_1/ene_swat_1") },
			zombie = { Idstring("units/payday2/characters/ene_swat_1/ene_swat_1") },
			murkywater = { Idstring("units/payday2/characters/ene_swat_1/ene_swat_1") },
			federales = { Idstring("units/payday2/characters/ene_swat_1/ene_swat_1") },
		},
		access = access_type_all,
	}

	self.unit_categories.CS_swat_1_3 = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
			},
		},
		access = access_type_all,
	}
	
	self.unit_categories.CS_swat_2_3 = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"),
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"),
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"),
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"),
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"),
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.CS_swat = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
				Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"),
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
				Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"),
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
				Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"),
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
				Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"),
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
				Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"),
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
			},
		},
		access = access_type_all,
	}
	
	self.unit_categories.CS_heavy_1 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1") },
			russia = { Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1") },
			zombie = { Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1") },
			murkywater = { Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1") },
			federales = { Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1") },
		},
		access = access_type_all,
	}

	self.unit_categories.CS_heavy_2 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870") },
			russia = { Idstring("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870") },
			zombie = { Idstring("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870") },
			murkywater = { Idstring("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870") },
			federales = { Idstring("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870") },
		},
		access = access_type_all,
	}

	self.unit_categories.CS_heavy = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"),
				Idstring("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"),
				Idstring("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"),
				Idstring("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"),
				Idstring("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"),
				Idstring("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"),
			},
		},
		access = access_type_all,
	}
	
	self.unit_categories.CS_shield = {
		special_type = "shield",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_shield_2/ene_shield_2") },
			russia = { Idstring("units/payday2/characters/ene_shield_2/ene_shield_2") },
			zombie = { Idstring("units/payday2/characters/ene_shield_2/ene_shield_2") },
			murkywater = { Idstring("units/payday2/characters/ene_shield_2/ene_shield_2") },
			federales = { Idstring("units/payday2/characters/ene_shield_2/ene_shield_2") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.FBI_agent_1 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1") },
			russia = { Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1") },
			zombie = { Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1") },
			murkywater = { Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1") },
			federales = { Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.FBI_agent_2 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2") },
			russia = { Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2") },
			zombie = { Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2") },
			murkywater = { Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2") },
			federales = { Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.FBI_agent_3 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3") },
			russia = { Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2") },
			zombie = { Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2") },
			murkywater = { Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2") },
			federales = { Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.FBI_agent_1_2 = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
				Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
				Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
				Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
				Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
				Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
			},
		},
		access = access_type_walk_only,
	}
	
	self.unit_categories.FBI_agent_2_3 = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
				Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
				Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
				Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
				Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
				Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3"),
			},
		},
		access = access_type_walk_only,
	}
	
	self.unit_categories.FBI_swat_1 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1") },
			russia = { Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1") },
			zombie = { Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1") },
			murkywater = { Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1") },
			federales = { Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1") },
		},
		access = access_type_all,
	}

	self.unit_categories.FBI_swat_2 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2") },
			russia = { Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2") },
			zombie = { Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2") },
			murkywater = { Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2") },
			federales = { Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2") },
		},
		access = access_type_all,
	}

	self.unit_categories.FBI_swat_3 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1") },
			russia = { Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1") },
			zombie = { Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1") },
			murkywater = { Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1") },
			federales = { Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1") },
		},
		access = access_type_all,
	}

	self.unit_categories.FBI_swat = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
				Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
				Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
				Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
				Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
				Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
				Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
				Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
				Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
				Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
				Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.FBI_heavy_1 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1") },
			russia = { Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1") },
			zombie = { Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1") },
			murkywater = { Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1") },
			federales = { Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1") },
		},
		access = access_type_all,
	}

	self.unit_categories.FBI_heavy_2 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870") },
			russia = { Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870") },
			zombie = { Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870") },
			murkywater = { Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870") },
			federales = { Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870") },
		},
		access = access_type_all,
	}

	self.unit_categories.FBI_heavy = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"),
				Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"),
				Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"),
				Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"),
				Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"),
				Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"),
			},
		},
		access = access_type_all,
	}
	
	self.unit_categories.FBI_shield = {
		special_type = "shield",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_shield_1/ene_shield_1") },
			russia =  { Idstring("units/payday2/characters/ene_shield_1/ene_shield_1") },
			zombie =  { Idstring("units/payday2/characters/ene_shield_1/ene_shield_1") },
			murkywater = { Idstring("units/payday2/characters/ene_shield_1/ene_shield_1") },
			federales = { Idstring("units/payday2/characters/ene_shield_1/ene_shield_1") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.Elite_swat_1 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1") },
			russia =  { Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1") },
			zombie =  { Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1") },
			murkywater = { Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1") },
			federales = { Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1") },
		},
		access = access_type_all,
	}

	self.unit_categories.Elite_swat_2 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2") },
			russia =  { Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2") },
			zombie =  { Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2") },
			murkywater = { Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2") },
			federales = { Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2") },
		},
		access = access_type_all,
	}

	self.unit_categories.Elite_swat_3 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3") },
			russia =  { Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3") },
			zombie =  { Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3") },
			murkywater = { Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3") },
			federales = { Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3") },
		},
		access = access_type_all,
	}

	self.unit_categories.Elite_swat_3 = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1"),
				Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2"),
				Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1"),
				Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2"),
				Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1"),
				Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2"),
				Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1"),
				Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2"),
				Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1"),
				Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2"),
				Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.Elite_shield = {
		special_type = "shield",
		unit_types = {
			america = { Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1/ene_phalanx_1") },
			russia = { Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1/ene_phalanx_1") },
			zombie = { Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1/ene_phalanx_1") },
			murkywater = { Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1/ene_phalanx_1") },
			federales = { Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1/ene_phalanx_1") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.taser_1 = {
		special_type = "taser",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1") },
			russia =  { Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1") },
			zombie =  { Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1") },
			murkywater = { Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1") },
			federales = { Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1") },
		},
		access = access_type_all,
	}

	self.unit_categories.taser_2 = {
		special_type = "taser",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1") },
			russia =  { Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1") },
			zombie =  { Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1") },
			murkywater = { Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1") },
			federales = { Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1") },
		},
		access = access_type_all,
	}

	self.unit_categories.taser = {
		special_type = "taser",
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
				Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
				Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
			},
			zombie =  {
				Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
				Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
				Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
				Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.medic_1 = {
		special_type = "medic",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4") },
			russia = { Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4") },
			zombie = { Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4") },
			murkywater = { Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4") },
			federales = { Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4") },
		},
		access = access_type_all,
	}

	self.unit_categories.medic_2 = {
		special_type = "medic",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870") },
			russia = { Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870") },
			zombie = { Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870") },
			murkywater = { Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870") },
			federales = { Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870") },
		},
		access = access_type_all,
	}

	self.unit_categories.medic = {
		special_type = "medic",
		unit_types = {
			america = { 
				Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"),
				Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870"),
			},
			russia = { 
				Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"),
				Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870"),
			},
			zombie = { 
				Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"),
				Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870"),
			},
			murkywater = { 
				Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"),
				Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870"),
			},
			federales = { 
				Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"),
				Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870"),
			},
		},
		access = access_type_all,
	}
	
	self.unit_categories.bulldozer_1 = {
		special_type = "tank",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1") },
			russia = { Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1") },
			zombie = { Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1") },
			murkywater = { Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1") },
			federales = { Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.bulldozer_2 = {
		special_type = "tank",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2") },
			russia =  { Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1") },
			zombie =  { Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1") },
			murkywater =  { Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1") },
			federales =  { Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.bulldozer_1_2 = {
		special_type = "tank",
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"),
				Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"),
				Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"),
				Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"),
				Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"),
				Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"),
			},
		},
		access = access_type_walk_only,
	}
	
	self.unit_categories.Elite_bulldozer_1 = {
		special_type = "tank",
		unit_types = {
			america = { Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic") },
			russia = { Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic") },
			zombie = { Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic") },
			murkywater = { Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic") },
			federales = { Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.Elite_bulldozer_2 = {
		special_type = "tank",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3") },
			russia =  { Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3") },
			zombie =  { Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3") },
			murkywater =  { Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3") },
			federales =  { Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.Elite_bulldozer_1_2 = {
		special_type = "tank",
		unit_types = {
			america = {
				Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic"),
				Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"),
			},
			russia = {
				Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic"),
				Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"),
			},
			zombie = {
				Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic"),
				Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic"),
				Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"),
			},
			federales = {
				Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic"),
				Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"),
			},
		},
		access = access_type_walk_only,
	}
	
	self.unit_categories.cloaker = {
		special_type = "spooc",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_spook_1/ene_spook_1") },
			russia = { Idstring("units/payday2/characters/ene_spook_1/ene_spook_1") },
			zombie = { Idstring("units/payday2/characters/ene_spook_1/ene_spook_1") },
			murkywater = { Idstring("units/payday2/characters/ene_spook_1/ene_spook_1") },
			federales = { Idstring("units/payday2/characters/ene_spook_1/ene_spook_1") },
		},
		access = access_type_all,
	}

	self.unit_categories.Zeal_swat_1 = {
		unit_types = {
			america = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat") },
			russia = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat") },
			zombie = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat") },
			murkywater = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat") },
			federales = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat") },
		},
		access = access_type_all,
	}

	-- ZEAL Shotgunner
	self.unit_categories.Zeal_swat_2 = {
		unit_types = {
			america = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2") },
			russia = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2") },
			zombie = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2") },
			murkywater = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2") },
			federales = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2") },
		},
		access = access_type_all,
	}

	self.unit_categories.Zeal_swat_3 = {
		unit_types = {
			america = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat") },
			russia = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat") },
			zombie = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat") },
			murkywater = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat") },
			federales = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat") },
		},
		access = access_type_all,
	}

	self.unit_categories.Zeal_swat = {
		unit_types = {
			america = {
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"),
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2"),
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"),
			},
			russia = {
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"),
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2"),
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2"),
			},
			zombie = {
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"),
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2"),
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"),
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2"),
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"),
			},
			federales = {
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"),
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2"),
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"),
			},
		},
		access = access_type_all,
	}
	
	self.unit_categories.Zeal_heavy_1 = {
		unit_types = {
			america = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy") },
			russia = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy") },
			zombie = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy") },
			murkywater = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy") },
			federales = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy") },
		},
		access = access_type_all,
	}

	self.unit_categories.Zeal_heavy_2 = {
		unit_types = {
			america = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2") },
			russia = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2") },
			zombie = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2") },
			murkywater = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2") },
			federales = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2") },
		},
		access = access_type_all,
	}

	self.unit_categories.Zeal_heavy = {
		unit_types = {
			america = {
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"),
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2"),
			},
			russia = {
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"),
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2"),
			},
			zombie = {
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"),
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"),
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2"),
			},
			federales = {
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"),
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2"),
			},
		},
		access = access_type_all,
	}

	-- ZEAL Shield
	self.unit_categories.Zeal_shield = {
		special_type = "shield",
		unit_types = {
			america = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield") },
			russia =  { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield") },
			zombie = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield") },
			murkywater =  { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield") },
			federales =  { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield") },
		},
		access = access_type_walk_only,
	}
	
	self.unit_categories.Zeal_taser_1 = {
		special_type = "taser",
		unit_types = {
			america = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer") },
			russia = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer") },
			zombie = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer") },
			murkywater = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer") },
			federales = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer") },
		},
		access = access_type_all,
	}

	self.unit_categories.Zeal_taser_2 = {
		special_type = "taser",
		unit_types = {
			america = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer") },
			russia = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer") },
			zombie = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer") },
			murkywater = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer") },
			federales = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer") },
		},
		access = access_type_all,
	}

	self.unit_categories.Zeal_taser = {
		special_type = "taser",
		unit_types = {
			america = { 
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer"),
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer"),
			},
			russia = { 
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer"),
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer"),
			},
			zombie = { 
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer"),
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer"),
			},
			murkywater = { 
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer"),
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer"),
			},
			federales = { 
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer"),
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer"),
			},
		},
		access = access_type_all,
	}
	
	self.unit_categories.Zeal_medic_1 = {
		special_type = "medic",
		unit_types = {
			america = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_m4/ene_zeal_medic_m4") },
			russia = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_m4/ene_zeal_medic_m4") },
			zombie = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_m4/ene_zeal_medic_m4") },
			murkywater = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_m4/ene_zeal_medic_m4") },
			federales = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_m4/ene_zeal_medic_m4") },
		},
		access = access_type_all,
	}

	self.unit_categories.Zeal_medic_2 = {
		special_type = "medic",
		unit_types = {
			america = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_r870/ene_zeal_medic_r870") },
			russia = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_r870/ene_zeal_medic_r870") },
			zombie = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_r870/ene_zeal_medic_r870") },
			murkywater = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_r870/ene_zeal_medic_r870") },
			federales = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_r870/ene_zeal_medic_r870") },
		},
		access = access_type_all,
	}

	self.unit_categories.Zeal_medic = {
		special_type = "medic",
		unit_types = {
			america = { 
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_m4/ene_zeal_medic_m4"),
			    Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_r870/ene_zeal_medic_r870"),
			},
			russia = { 
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_m4/ene_zeal_medic_m4"),
			    Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_r870/ene_zeal_medic_r870"),
			},
			zombie = { 
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_m4/ene_zeal_medic_m4"),
			    Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_r870/ene_zeal_medic_r870"),
			},
			murkywater = { 
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_m4/ene_zeal_medic_m4"),
			    Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_r870/ene_zeal_medic_r870"),
			},
			federales = { 
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_m4/ene_zeal_medic_m4"),
			    Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_r870/ene_zeal_medic_r870"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.Zeal_cloaker = {
		special_type = "spooc",
		unit_types = {
			america = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_cloaker/ene_zeal_cloaker") },
			russia = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_cloaker/ene_zeal_cloaker") },
			zombie = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_cloaker/ene_zeal_cloaker") },
			murkywater = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_cloaker/ene_zeal_cloaker") },
			federales = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_cloaker/ene_zeal_cloaker") },
		},
		access = access_type_all,
	}

	self.unit_categories.Zeal_tank = {
		special_type = "tank",
		unit_types = {
			america = {
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer"),
				Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun"),
			},
			russia = {
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer"),
				Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun"),
			},
			zombie = {
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer"),
				Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer"),
				Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun"),
			},
			federales = {
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer"),
				Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun"),
			},
		},
		access = access_type_walk_only,
	}
end)

Hooks:PostHook(GroupAITweakData, "_init_enemy_spawn_groups", "eclipse__init_enemy_spawn_groups", function(self, difficulty_index)
	self._tactics = {
		none = {},
		cop_init = {
			"no_push",
		},
		cop_def = {
			"ranged_fire",
		},
		cop_snk = {
			"rescue",
			"flank",
		},
		swat_init = {
			"rescue",
			"ranged_fire",
		},
		swat_def = {
			"ranged_fire",
			"flash_grenade",
			"smoke_grenade",
		},
		swat_agg = {
			"charge",
			"deathguard",
			"flash_grenade",
		},
		swat_snk = {
			"flank",
			"deathguard",
			"smoke_grenade",
		},
		swat_spt = {
			"unit_cover",
			"ranged_fire",
		},
		shield_def = {
			"ranged_fire",
			"door_ambush",
			"shield",
		},
		shield_agg = {
			"charge",
			"deathguard",
			"shield",
		},
		shield_spt = {
			"shield_cover",
			"flash_grenade",
			"smoke_grenade",
		},
		taser_agg = {
			"charge",
			"murder",
		},
		taser_snk = {
			"flank",
			"murder",
		},
		taser_spt = {
			"murder",
			"flash_grenade",
			"smoke_grenade",
		},
		bulldozer = {
			"charge",
			"shield",
			"murder",
			"target_vulnerable",
		},
		bulldozer_spt = {
			"shield_cover",
			"target_vulnerable",
			"flash_grenade",
			"smoke_grenade",
		},
		medic = {
			"unit_cover",
		},
		cloaker_def = {
			"no_push",
			"target_isolated",
			"smoke_grenade",
		},
		cloaker_snk = {
			"flank",
			"target_isolated",
			"smoke_grenade",
		},
		marksman = {
			"no_push",
			"ranged_fire",
		},
	}

	-- соси хуй кк?
	self.enemy_spawn_groups = {}

	local swat_random_tactics_1 = { self._tactics.swat_def, self._tactics.swat_def, self._tactics.swat_snk }
	local swat_random_tactics_2 = { self._tactics.swat_def, self._tactics.swat_snk }
	local swat_random_tactics_3 = { self._tactics.swat_agg, self._tactics.swat_snk }

	self.enemy_spawn_groups.CS_reinforce_cops = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 1,
				rank = 2,
				unit = "CS_cop_1_4",
				tactics = self._tactics.cop_def,
			},
			{
				amount_max = 1,
				freq = 0.25,
				rank = 1,
				unit = "CS_cop_2",
				tactics = self._tactics.cop_snk,
			},
		},
	}

	self.enemy_spawn_groups.CS_reinforce_swats = {
		amount = { 2, 3 },
		spawn = {
			{
				amount_min = 1,
				freq = 1,
				rank = 2,
				unit = "CS_swat",
				tactics = self._tactics.cop_def,
			},
			{
				amount_max = 1,
				freq_by_diff = { 
					1 / math.sqrt(difficulty_index), 
					0.5 / math.sqrt(difficulty_index), 
					0
				},
				rank = 1,
				unit = "CS_cop_3",
				tactics = self._tactics.cop_def,
			},
		},
	}

	self.enemy_spawn_groups.CS_recon_cops = {
		amount = { 2, 3 },
		spawn = {
			{
				freq_by_diff = { 1.5, 1, 0.5 },
				rank = 1,
				unit = "CS_cop_1",
				tactics = self._tactics.cop_snk,
			},
			{
				amount_max = 2,
				freq = 1,
				rank = 2,
				unit = "CS_cop_3",
				tactics = self._tactics.cop_snk,
			},
		},
	}

	self.enemy_spawn_groups.CS_recon_swats = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 1,
				rank = 1,
				unit = "CS_swat",
				tactics = self._tactics.cop_snk,
			},
		},
	}
	
	self.enemy_spawn_groups.CS_assault_cops = {
		amount = { 3, 3 },
		spawn = {
			{
				freq = 1,
				rank = 1,
				unit = "CS_cop_1_4",
				tactics = self._tactics.cop_init,
			},
			{
				amount_max = 1,
				freq = 0.25,
				rank = 1,
				unit = "CS_cop_2",
				tactics = self._tactics.cop_init,
			},
			{
				amount_max = 1,
				freq_by_diff = { 
					difficulty_index / 4, 
					difficulty_index / 2, 
					difficulty_index,  
				},
				rank = 2,
				unit = "CS_cop_3",
				tactics = self._tactics.cop_snk,
			},
		},
	}
	
	self.enemy_spawn_groups.CS_assault_swats = {
		amount = { 3, 4 },
		spawn = {
			{
				freq_by_diff = { 1, 0, 0 },
				rank = 1,
				unit = "CS_swat",
				tactics = self._tactics.swat_init,
			},
			{
				amount_min = 1,
				freq_by_diff = { 0, 1, 1 },
				rank = 2,
				unit = "CS_swat_1",
				tactics = self._tactics.swat_def,
				random_tactics = swat_random_tactics_1,
			},
			{
				amount_min = 1,
				freq_by_diff = { 0, 0.8, 0.8 },
				rank = 2,
				unit = "CS_swat_3",
				tactics = self._tactics.swat_snk,
				random_tactics = swat_random_tactics_2,
			},
			{
				amount_max = 2,
				freq_by_diff = { 0, 0.6, 0.6 },
				rank = 2,
				unit = "CS_swat_2",
				tactics = self._tactics.swat_agg,
				random_tactics = swat_random_tactics_3,
			},
		},
	}

	self.enemy_spawn_groups.CS_assault_heavies = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_min = 1,
				freq = 1,
				rank = 2,
				unit = "CS_heavy_1",
				tactics = self._tactics.swat_def,
				random_tactics = swat_random_tactics_2,
			},
			{
				amount_max = 2,
				freq = 0.6,
				rank = 2,
				unit = "CS_heavy_2",
				tactics = self._tactics.swat_agg,
				random_tactics = swat_random_tactics_3,
			},
			{
				amount_max = 2,
				freq_by_diff = { 
					6 / (difficulty_index ^ 2), 
					4 / (difficulty_index ^ 2), 
					2 / (difficulty_index ^ 2), 
				},
				rank = 1,
				unit = "CS_swat",
				tactics = self._tactics.swat_spt,
			},
		},
	}

	local shield_random_tactics = { self._tactics.shield_def, self._tactics.shield_agg }

	self.enemy_spawn_groups.CS_assault_shield = {
		amount = { 4, 4 },
		spawn = {
			{
				amount_min = 1,
				freq = 1,
				amount_max = 1,
				rank = 3,
				unit = "CS_shield",
				tactics = self._tactics.shield_agg,
				random_tactics = shield_random_tactics,
			},
			{
				freq_by_diff = { 0, 0, 1 },
				rank = 2,
				unit = "CS_heavy",
				tactics = self._tactics.shield_spt,
			},
			{
				freq_by_diff = { 1, 1, 0.5 },
				rank = 1,
				unit = "CS_swat",
				tactics = self._tactics.shield_spt,
			},
		},
	}

	local taser_random_tactics = { self._tactics.taser_agg, self._tactics.taser_snk }
	
	self.enemy_spawn_groups.CS_assault_taser = {
		amount = { 3, 3 },
		spawn = {
			{
				amount_min = 1,
				freq = 1,
				amount_max = 1,
				rank = 2,
				unit = "taser",
				tactics = self._tactics.taser_snk,
				random_tactics = taser_random_tactics,
			},
			{
				freq = 1,
				rank = 1,
				unit = "CS_swat",
				tactics = self._tactics.taser_spt,
			},
		},
	}


	self.enemy_spawn_groups.CS_assault_bulldozer = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_min = 1,
				freq = 1,
				amount_max = 1,
				rank = 2,
				unit = "bulldozer_1",
				tactics = self._tactics.bulldozer,
			},
			{
				freq = 1,
				rank = 1,
				unit = "CS_heavy",
				tactics = self._tactics.bulldozer_spt,
			},
		},
	}

	self.enemy_spawn_groups.FBI_reinforce_agents = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 1,
				rank = 2,
				unit = "FBI_agent_1",
				tactics = self._tactics.cop_def,
			},
			{
				amount_max = 2,
				freq_by_diff = { 
					difficulty_index / 12, 
					difficulty_index / 4, 
					difficulty_index
				},
				rank = 1,
				unit = "FBI_agent_2_3",
				tactics = self._tactics.cop_snk,
			},
		},
	}

	self.enemy_spawn_groups.FBI_reinforce_swats = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 1,
				rank = 2,
				unit = "FBI_swat",
				tactics = self._tactics.cop_def,	
			},
		}
	}

	self.enemy_spawn_groups.FBI_recon_agents = {
		amount = { 2, 3 },
		spawn = {
			{
				freq_by_diff = { 1.5, 1, 0.5 },
				rank = 1,
				unit = "FBI_agent_1_2",
				tactics = self._tactics.cop_snk,
			},
			{
				amount_max = 2,
				freq = 1,
				rank = 2,
				unit = "FBI_agent_2_3",
				tactics = self._tactics.cop_snk,
			},
		},
	}

	self.enemy_spawn_groups.FBI_recon_swats = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 1,
				rank = 1,
				unit = "FBI_swat",
				tactics = self._tactics.cop_snk,
			},
		},
	}
	
	self.enemy_spawn_groups.FBI_assault_swats = {
		amount = { 3, 4 },
		spawn = {
			{
				freq_by_diff = { 1, 0, 0 },
				rank = 1,
				unit = "FBI_swat",
				tactics = self._tactics.swat_init,
			},
			{
				amount_min = 1,
				freq_by_diff = { 0, 1, 1 },
				rank = 2,
				unit = "FBI_swat_1",
				tactics = self._tactics.swat_def,
				random_tactics = swat_random_tactics_1,
			},
			{
				amount_min = 1,
				freq_by_diff = { 0, 0.8, 0.8 },
				rank = 2,
				unit = "FBI_swat_3",
				tactics = self._tactics.swat_snk,
				random_tactics = swat_random_tactics_2,
			},
			{
				amount_max = 2,
				freq_by_diff = { 0, 0.6, 0.6 },
				rank = 2,
				unit = "FBI_swat_2",
				tactics = self._tactics.swat_agg,
				random_tactics = swat_random_tactics_3,
			},
			{
				amount_max = 1,
				freq_by_diff = { 
					0,
					difficulty_index / 24, 
					difficulty_index / 12, 
				},
				rank = 1,
				unit = "medic",
				tactics = self._tactics.medic,
			},
		},
	}
	
	self.enemy_spawn_groups.FBI_assault_heavies = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_min = 1,
				freq = 1,
				rank = 3,
				unit = "FBI_heavy_1",
				tactics = self._tactics.swat_def,
				random_tactics = swat_random_tactics_2,
			},
			{
				amount_max = 2,
				freq = 0.6,
				rank = 3,
				unit = "FBI_heavy_2",
				tactics = self._tactics.swat_agg,
				random_tactics = swat_random_tactics_3,
			},
			{
				amount_max = 2,
				freq_by_diff = { 
					24 / (difficulty_index ^ 2), 
					16 / (difficulty_index ^ 2), 
					8 / (difficulty_index ^ 2), 
				},
				rank = 2,
				unit = "FBI_swat",
				tactics = self._tactics.swat_spt,
			},
			{
				amount_max = 1,
				freq_by_diff = { 
					0,
					difficulty_index / 24, 
					difficulty_index / 12, 
				},
				rank = 1,
				unit = "medic",
				tactics = self._tactics.medic,
			},
		},
	}

	self.enemy_spawn_groups.FBI_assault_shield = {
		amount = { 4, 4 },
		spawn = {
			{
				amount_min = 1,
				freq = 1,
				amount_max = 1,
				rank = 3,
				unit = "FBI_shield",
				tactics = self._tactics.shield_agg,
				random_tactics = shield_random_tactics,
			},
			{
				freq_by_diff = { 0, 0, 1 },
				rank = 2,
				unit = "FBI_heavy",
				tactics = self._tactics.shield_spt,
			},
			{
				freq_by_diff = { 1, 1, 0.5 },
				rank = 1,
				unit = "FBI_swat",
				tactics = self._tactics.shield_spt,
			},
			{
				amount_max = 1,
				freq_by_diff = { 
					0,
					difficulty_index / 32, 
					difficulty_index / 16, 
				},
				rank = 1,
				unit = "medic",
				tactics = self._tactics.medic,
			},
		},
	}
	
	self.enemy_spawn_groups.FBI_assault_taser = {
		amount = { 3, 3 },
		spawn = {
			{
				amount_min = 1,
				freq = 1,
				amount_max = 1,
				rank = 2,
				unit = "taser",
				tactics = self._tactics.taser_snk,
				random_tactics = taser_random_tactics,
			},
			{
				freq = 1,
				rank = 1,
				unit = "FBI_swat",
				tactics = self._tactics.taser_spt,
			},
			{
				amount_max = 1,
				freq_by_diff = { 
					0,
					difficulty_index / 40, 
					difficulty_index / 20, 
				},
				rank = 1,
				unit = "medic",
				tactics = self._tactics.medic,
			},
		},
	}


	self.enemy_spawn_groups.FBI_assault_bulldozer = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_min = 1,
				freq = 1,
				amount_max = 1,
				rank = 3,
				unit = "bulldozer_1_2",
				tactics = self._tactics.bulldozer,
			},
			{
				freq = 1,
				rank = 2,
				unit = "FBI_heavy",
				tactics = self._tactics.bulldozer_spt,
			},
			{
				amount_max = 1,
				freq_by_diff = { 
					0,
					difficulty_index / 48, 
					difficulty_index / 24, 
				},
				rank = 1,
				unit = "medic",
				tactics = self._tactics.medic,
			},
		},
	}
	
	local cloaker_random_tactics = { self._tactics.cloaker_def, self._tactics.cloaker_snk }

	self.enemy_spawn_groups.FBI_assault_cloaker = {
		amount = { 1, 1 },
		spawn = {
			{
				freq = 1,
				rank = 1,
				unit = "cloaker",
				tactics = self._tactics.cloaker_snk,
				random_tactics = cloaker_random_tactics,
			},
		},
	}


	self.enemy_spawn_groups.single_spooc = {
		amount = { 1, 1 },
		spawn = {
			{
				freq = 1,
				rank = 1,
				unit = "cloaker",
				tactics = self._tactics.cloaker_snk,
				random_tactics = cloaker_random_tactics,
			},
		},
	}

	self.enemy_spawn_groups.FBI_spoocs = self.enemy_spawn_groups.single_spooc

	self.enemy_spawn_groups.Elite_reinforce_swats = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 1,
				rank = 2,
				unit = "Elite_swat",
				tactics = self._tactics.cop_def,	
			},
		}
	}
	
	self.enemy_spawn_groups.Elite_assault_swats = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_min = 1,
				freq_by_diff = { 0, 1, 1 },
				rank = 2,
				unit = "Elite_swat_1",
				tactics = self._tactics.swat_def,
				random_tactics = swat_random_tactics_1,
			},
			{
				amount_min = 1,
				freq_by_diff = { 0, 0.8, 0.8 },
				rank = 2,
				unit = "Elite_swat_3",
				tactics = self._tactics.swat_snk,
				random_tactics = swat_random_tactics_2,
			},
			{
				amount_max = 2,
				freq_by_diff = { 0, 0.6, 0.6 },
				rank = 2,
				unit = "Elite_swat_2",
				tactics = self._tactics.swat_agg,
				random_tactics = swat_random_tactics_3,
			},
			{
				amount_max = 1,
				freq_by_diff = { 
					0,
					difficulty_index / 24, 
					difficulty_index / 12, 
				},
				rank = 1,
				unit = "medic",
				tactics = self._tactics.medic,
			},
		},
	}
	
	local Random_shield = { "FBI_shield", "Elite_shield" }
	
	self.enemy_spawn_groups.Elite_assault_shield = {
		amount = { 4, 4 },
		spawn = {
			{
				amount_min = 1,
				freq = 1,
				amount_max = 1,
				rank = 3,
				unit = "FBI_shield",
				random_unit = Random_shield,
				tactics = self._tactics.shield_agg,
				random_tactics = shield_random_tactics,
			},
			{
				freq_by_diff = { 0, 0, 1 },
				rank = 2,
				unit = "FBI_heavy",
				tactics = self._tactics.shield_spt,
			},
			{
				freq_by_diff = { 1, 1, 0.5 },
				rank = 1,
				unit = "Elite_swat",
				tactics = self._tactics.shield_spt,
			},
			{
				amount_max = 1,
				freq_by_diff = { 
					0,
					difficulty_index / 32, 
					difficulty_index / 16, 
				},
				rank = 1,
				unit = "medic",
				tactics = self._tactics.medic,
			},
		},
	}
	
	self.enemy_spawn_groups.Elite_assault_taser = {
		amount = { 3, 3 },
		spawn = {
			{
				amount_min = 1,
				freq = 1,
				amount_max = 1,
				rank = 2,
				unit = "taser",
				tactics = self._tactics.taser_snk,
				random_tactics = taser_random_tactics,
			},
			{
				freq = 1,
				rank = 1,
				unit = "Elite_swat",
				tactics = self._tactics.taser_spt,
			},
			{
				amount_max = 1,
				freq_by_diff = { 
					0,
					difficulty_index / 40, 
					difficulty_index / 20, 
				},
				rank = 1,
				unit = "medic",
				tactics = self._tactics.medic,
			},
		},
	}

	local Random_bulldozer = { "bulldozer_1_2", "Elite_bulldozer_1_2" }
	
	self.enemy_spawn_groups.Elite_assault_bulldozer = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_min = 1,
				freq = 1,
				amount_max = 1,
				rank = 3,
				unit = "bulldozer_1_2",
				random_unit = Random_bulldozer,
				tactics = self._tactics.bulldozer,
			},
			{
				freq = 1,
				rank = 2,
				unit = "FBI_heavy",
				tactics = self._tactics.bulldozer_spt,
			},
			{
				amount_max = 1,
				freq_by_diff = { 
					0,
					difficulty_index / 48, 
					difficulty_index / 24, 
				},
				rank = 1,
				unit = "medic",
				tactics = self._tactics.medic,
			},
		},
	}

	self.enemy_spawn_groups.Zeal_reinforce_swats = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 1,
				rank = 2,
				unit = "Zeal_swat",
				tactics = self._tactics.cop_def,	
			},
		}
	}
	self.enemy_spawn_groups.Zeal_assault_swats = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_min = 1,
				freq_by_diff = { 0, 1, 1 },
				rank = 2,
				unit = "Zeal_swat_1",
				tactics = self._tactics.swat_def,
				random_tactics = swat_random_tactics_1,
			},
			{
				amount_min = 1,
				freq_by_diff = { 0, 0.8, 0.8 },
				rank = 2,
				unit = "Zeal_swat_3",
				tactics = self._tactics.swat_snk,
				random_tactics = swat_random_tactics_2,
			},
			{
				amount_max = 2,
				freq_by_diff = { 0, 0.6, 0.6 },
				rank = 2,
				unit = "Zeal_swat_2",
				tactics = self._tactics.swat_agg,
				random_tactics = swat_random_tactics_3,
			},
			{
				amount_max = 1,
				freq_by_diff = { 
					0,
					difficulty_index / 18, 
					difficulty_index / 9, 
				},
				rank = 1,
				unit = "Zeal_medic",
				tactics = self._tactics.medic,
			},
		},
	}
	
	self.enemy_spawn_groups.Zeal_assault_heavies = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_min = 1,
				freq = 1,
				rank = 3,
				unit = "Zeal_heavy_1",
				tactics = self._tactics.swat_def,
				random_tactics = swat_random_tactics_2,
			},
			{
				amount_max = 2,
				freq = 0.5,
				rank = 3,
				unit = "Zeal_heavy_2",
				tactics = self._tactics.swat_agg,
				random_tactics = swat_random_tactics_3,
			},
			{
				amount_max = 2,
				freq_by_diff = { 
					24 / (difficulty_index ^ 2), 
					16 / (difficulty_index ^ 2), 
					8 / (difficulty_index ^ 2), 
				},
				rank = 2,
				unit = "Zeal_swat",
				tactics = self._tactics.swat_spt,
			},
			{
				amount_max = 1,
				freq_by_diff = { 
					0,
					difficulty_index / 18, 
					difficulty_index / 9, 
				},
				rank = 1,
				unit = "Zeal_medic",
				tactics = self._tactics.medic,
			},
		},
	}

	self.enemy_spawn_groups.Zeal_assault_shield = {
		amount = { 4, 4 },
		spawn = {
			{
				amount_min = 1,
				freq = 1,
				amount_max = 1,
				rank = 3,
				unit = "Zeal_shield",
				tactics = self._tactics.shield_agg,
				random_tactics = shield_random_tactics,
			},
			{
				freq_by_diff = { 0, 0, 1 },
				rank = 2,
				unit = "Zeal_heavy",
				tactics = self._tactics.shield_spt,
			},
			{
				freq_by_diff = { 1, 1, 0.5 },
				rank = 1,
				unit = "Zeal_swat",
				tactics = self._tactics.shield_spt,
			},
			{
				amount_max = 1,
				freq_by_diff = { 
					0,
					difficulty_index / 24, 
					difficulty_index / 12, 
				},
				rank = 1,
				unit = "Zeal_medic",
				tactics = self._tactics.medic,
			},
		},
	}

	self.enemy_spawn_groups.Zeal_assault_taser = {
		amount = { 3, 3 },
		spawn = {
			{
				amount_min = 1,
				freq = 1,
				amount_max = 1,
				rank = 2,
				unit = "Zeal_taser",
				tactics = self._tactics.taser_snk,
				random_tactics = taser_random_tactics,
			},
			{
				freq = 1,
				rank = 1,
				unit = "Zeal_swat",
				tactics = self._tactics.taser_spt,
			},
			{
				amount_max = 1,
				freq_by_diff = { 
					0,
					difficulty_index / 30, 
					difficulty_index / 15, 
				},
				rank = 1,
				unit = "Zeal_medic",
				tactics = self._tactics.medic,
			},
		},
	}

	self.enemy_spawn_groups.Zeal_assault_cloaker = {
		amount = { 1, 1 },
		spawn = {
			{
				freq = 1,
				rank = 1,
				unit = "Zeal_cloaker",
				tactics = self._tactics.cloaker_snk,
				random_tactics = cloaker_random_tactics,
			},
		},
	}
	
end)

-- get rid of marshals
function GroupAITweakData:_init_enemy_spawn_groups_level() end

Hooks:PostHook(GroupAITweakData, "_init_task_data", "eclipse__init_task_data", function(self, difficulty_index)
	-- difficulty scaling
	local map_scale_factor = 1
	local map_scales = Eclipse.map_sizes

	for _, vs in pairs(map_scales.very_small) do
		if level_id == vs then
			map_scale_factor = 0.5
		end
	end

	for _, s in pairs(map_scales.small) do
		if level_id == s then
			map_scale_factor = 0.75
		end
	end

	for _, l in pairs(map_scales.large) do
		if level_id == l then
			map_scale_factor = 1.25
		end
	end

	for _, vl in pairs(map_scales.very_large) do
		if level_id == vl then
			map_scale_factor = 1.5
		end
	end

	local map_scale_force = map_scale_factor
	local map_scale_spawnrate = math.sqrt(map_scale_factor)
	
	-- Assault Data
	-- AI Tickrate
	self.ai_tickrate = 1 / (is_pro_job and 90 or 60)
	
	-- BESIEGE --

	-- PHASES --

	-- Sustain
	self.besiege.assault.sustain_duration_min = {
		diff_lerp(60, 120),
		diff_lerp(90, 150),
		diff_lerp(120, 180)
	}	
	self.besiege.assault.sustain_duration_max = self.besiege.assault.sustain_duration_min
	self.besiege.assault.sustain_duration_balance_mul = { 1, 1, 1, 1 }

	self.besiege.regroup.duration = { 30, 25, 20 }

	-- Control
	self.besiege.assault.delay = {
		diff_lerp(50, 40),
		diff_lerp(40, 30),
		diff_lerp(30, 20)
	}	
	self.besiege.assault.hostage_hesitation_delay = { 10, 7.5, 5 }

	self.besiege.assault.fade = {
		enemies_defeated_percentage = 0.5,
		enemies_defeated_time = 30,
		engagement_percentage = 0.25,
		engagement_time = 20,
		drama_time = 10
	}
	
	-- SPAWNS --

	-- Spawncap
	self.besiege.assault.force = { 
		diff_lerp(5, 6) * map_scale_force,  
		diff_lerp(7, 9) * map_scale_force,  
		diff_lerp(9, 12) * map_scale_force
	}
	self.besiege.assault.force_balance_mul = { 1, 1.25, 1.5, 1.75 }

	self.besiege.assault.force_pool = { 
		self.besiege.assault.force[1] * 10,
		self.besiege.assault.force[2] * 10, 
		self.besiege.assault.force[3] * 10
	}
	self.besiege.assault.force_pool_balance_mul = { 0.75, 1, 1.25, 1.5 }
	
	-- Spawnrate
	self.spawn_kill_cooldown = 10
	
	self.besiege.assault.spawnrate = { 
		diff_lerp(3, 2) / map_scale_spawnrate,
		diff_lerp(2.5, 1.5) / map_scale_spawnrate,
		diff_lerp(2, 1) / map_scale_spawnrate,
	}
	self.besiege.assault.spawnrate_balance_mul = { 2.5, 2, 1.5, 1 }

	-- RECON / REENFORCE --

	-- Reenforce spawn interval
	self.besiege.reenforce.interval = { 40, 30, 20 }

	-- Recon spawn interval and spawncap
	self.besiege.recon.interval_variation = 20
	self.besiege.recon.force = { 
		2 * math.sqrt(map_scale_force),
		4 * math.sqrt(map_scale_force),
		6 * math.sqrt(map_scale_force),
	}

	self.besiege.push_delay = {
		diff_lerp(25, 20),
		diff_lerp(20, 15),
		diff_lerp(15, 10)	
	}
	
	-- GRENADES --
	self.min_grenade_timeout = 20
	
	local timeout_mult = diff_lerp(1, 0.75)
	
	self.flash_grenade.light_color = Vector3(255, 255, 255)
	--self.flash_grenade.light_range = (is_pro_job and 0) or 500
	self.flash_grenade_timeout = { 
		10 * timeout_mult,
		15 * timeout_mult,
	}
	self.flash_grenade.timer = 2

	self.smoke_grenade_timeout = { 
		20 * timeout_mult,
		30 * timeout_mult,
	}
	self.smoke_grenade_lifetime = 15
	
	self.cs_grenade_timeout = { 
		40 * timeout_mult,
		60 * timeout_mult,
	}
	self.cs_grenade_lifetime = 25
	self.cs_grenade_chance_times = { 60, diff_lerp(180, 120) }

	if difficulty_index <= 3 then
		self.besiege.faction = {
			"CS",
			"CS",
			"CS",
		}	
	elseif difficulty_index == 4 then
		self.besiege.faction = {
			"CS",
			"CS",
			"FBI",
		}
	elseif difficulty_index == 5 then
		self.besiege.faction = {
			"CS",
			"FBI",
			"FBI",
		}
	else
		self.besiege.faction = {
			"CS",
			"FBI",
			"Elite",
		}
	end

	-- Spawngroups
	if difficulty_index <= 2 then
		self.besiege.assault.groups = {
			CS_assault_cops = { 0.5, 0.25, 0 },
			CS_assault_swats = { 1, 1, 0.75 },
			CS_assault_heavies = { 0, 0, 0.75 },
			CS_assault_shield = { 0, 0.15, 0.2 },
		}
		self.besiege.recon.groups = {
			CS_recon_cops = { 1, 1, 0 },
			CS_recon_swat = { 0, 0, 1 },
		}
		self.besiege.reenforce.groups = {
			CS_reinforce_cops = { 1, 0.5, 0 },
			CS_reinforce_swats = { 0, 0.5, 1 },
		}
	elseif difficulty_index == 3 then
		self.besiege.assault.groups = {
			CS_assault_cops = { 0.5, 0, 0 },
			CS_assault_swats = { 1, 1, 0.75 },
			CS_assault_heavies = { 0, 0, 0.75 },
			CS_assault_shield = { 0, 0.15, 0.2 },
			CS_assault_taser = { 0, 0.1, 0.15 },
			CS_assault_bulldozer = { 0, 0, 0.1 },
		}
		self.besiege.recon.groups = {
			CS_recon_cops = { 1, 1, 0 },
			CS_recon_swat = { 0, 0, 1 },
		}
		self.besiege.reenforce.groups = {
			CS_reinforce_cops = { 1, 0.5, 0 },
			CS_reinforce_swats = { 0, 0.5, 1 },
		}
	elseif difficulty_index == 4 then
		self.besiege.assault.groups = {
			CS_assault_cops = { 0.25, 0, 0 },
			CS_assault_swats = { 1, 1, 0 },
			
			FBI_assault_swats = { 0, 0.5, 0.75 },
			FBI_assault_heavies = { 0, 0, 0.75 },
			FBI_assault_shield = { 0, 0.15, 0.2 },
			FBI_assault_taser = { 0, 0.1, 0.15 },
			FBI_assault_cloaker = { 0, 0.1, 0.15 },
			FBI_assault_bulldozer = { 0, 0, 0.1 },
		}
		self.besiege.recon.groups = {	
			FBI_recon_agents = { 1, 1, 0 },
			FBI_recon_swats = { 0, 0, 1 },
		}
		self.besiege.reenforce.groups = {			
			CS_reinforce_cops = { 0.5, 0, 0 },
			CS_reinforce_swats = { 0, 0.5, 0 },
			
			FBI_reinforce_agents = { 0.5, 0.5, 0 },
			FBI_reinforce_swats = { 0, 0, 1 },
		}
	elseif difficulty_index == 5 then
		self.besiege.assault.groups = {
			CS_assault_swats = { 1, 0.5, 0 },
			
			FBI_assault_swats = { 1, 1, 0.5 },
			FBI_assault_heavies = { 0, 0, 1 },
			FBI_assault_shield = { 0, 0.2, 0.3 },
			FBI_assault_taser = { 0, 0.15, 0.2 },
			FBI_assault_cloaker = { 0, 0.15, 0.2 },
			FBI_assault_bulldozer = { 0, 0, 0.15 },
		}
		self.besiege.recon.groups = {		
			FBI_recon_agents = { 1, 1, 0 },
			FBI_recon_swats = { 0, 0, 1 },
		}
		self.besiege.reenforce.groups = {
			CS_reinforce_cops = { 0.5, 0, 0 },
			CS_reinforce_swats = { 0, 0.5, 0 },
			
			FBI_reinforce_agents = { 0.5, 0.5, 0 },
			FBI_reinforce_swats = { 0, 0, 1 },
		}
	elseif difficulty_index == 6 then
		self.besiege.assault.groups = {
			CS_assault_swats = { 0.5, 0.25, 0 },
			
			FBI_assault_swats = { 1, 1, 0 },
			FBI_assault_heavies = { 0, 0, 0.75 },
			FBI_assault_shield = { 0, 0.2, 0 },
			FBI_assault_taser = { 0, 0.15, 0 },
			FBI_assault_cloaker = { 0, 0.15, 0.3 },
			
			Elite_assault_swats = { 0, 0.25, 0.75 },
			Elite_assault_shield = { 0, 0, 0.3 },
			Elite_assault_taser = { 0, 0, 0.2 },
			Elite_assault_bulldozer = { 0, 0, 0.15 },
		}
		self.besiege.recon.groups = {
			FBI_recon_agents = { 1, 1, 0 },
			FBI_recon_swats = { 0, 0, 1 },
		}
		self.besiege.reenforce.groups = {
			CS_reinforce_cops = { 0.5, 0, 0 },
			CS_reinforce_swats = { 0, 0.5, 0 },
			
			FBI_reinforce_agents = { 0.5, 0.5, 0 },
			FBI_reinforce_swats = { 0, 0, 1 },
		}
	end

	self.besiege.cloaker.groups = { 
		single_spooc = { 1, 1, 1 } 
	}
	
	self.besiege.recurring_group_SO.recurring_cloaker_spawn.interval = { 
		diff_lerp(60, 15), 
		diff_lerp(120, 30)
	}

	self.besiege.assault.groups.single_spooc = { 0, 0, 0 }
	self.besiege.assault.groups.Phalanx = { 0, 0, 0 }
	self.besiege.assault.groups.marshal_squad = { 0, 0, 0 }
	self.besiege.assault.groups.custom_assault = { 0, 0, 0 }
	self.besiege.assault.groups.snowman_boss = { 0, 0, 0 }
	self.besiege.assault.groups.piggydozer = { 0, 0, 0 }
	
	self.besiege.recon.groups.single_spooc = { 0, 0, 0 }
	self.besiege.recon.groups.Phalanx = { 0, 0, 0 }
	self.besiege.recon.groups.marshal_squad = { 0, 0, 0 }
	self.besiege.recon.groups.custom_assault = { 0, 0, 0 }
	self.besiege.recon.groups.snowman_boss = { 0, 0, 0 }
	self.besiege.recon.groups.piggydozer = { 0, 0, 0 }
	
	-- PONR --
	self.ponr = deep_clone(self.besiege)

	local short_ponr_heists = {
		bph = true,
		red2 = true,
		bex = true,
		pex = true,
		glace = true,
		hox_2 = true,
		firestarter_2 = true,
		dah = true,
		rvd2 = true,
		man = true,
	}

	-- Control
	self.ponr.assault.delay = { 20, 20, 20 }
	self.ponr.assault.hostage_hesitation_delay = { 10, 7.5, 5 }

	self.ponr.push_delay = {
		diff_lerp(20, 16),
		diff_lerp(16, 12),
		diff_lerp(12, 8)	
	}
	
	if level_id and short_ponr_heists[level_id] then
		self.ponr.assault.delay = { 5, 5, 5 }
		self.ponr.assault.hostage_hesitation_delay = { 0, 0, 0 }
	end

	-- Recon
	self.ponr.recon.groups = {}
	self.ponr.recon.force = { 0, 0, 0 } -- no recon after ponr ran out

	if difficulty_index < 4 then
		self.ponr.faction = {
			"FBI",
			"FBI",
			"FBI",
		}
	elseif difficulty_index < 6 then
		self.ponr.faction = {
			"Elite",
			"Elite",
			"Elite",
		}
	else
		self.ponr.faction = {
			"Zeal",
			"Zeal",
			"Zeal",
		}
	end

	-- Spawngroups
	if difficulty_index <= 2 then
		self.ponr.assault.groups = {
			FBI_assault_swats = { 0.5, 0.5, 0.5 },
			FBI_assault_heavies = { 1, 1, 1 },
			FBI_assault_shield = { 0.3, 0.3, 0.3 },
		}
		self.ponr.reenforce.groups = {
			FBI_reinforce_swats = { 1, 1, 1 },
		}
	elseif difficulty_index == 3 then
		self.ponr.assault.groups = {
			FBI_assault_swats = { 0.5, 0.5, 0.5 },
			FBI_assault_heavies = { 1, 1, 1 },
			FBI_assault_shield = { 0.3, 0.3, 0.3 },
			FBI_assault_taser = { 0.2, 0.2, 0.2 },
			FBI_assault_bulldozer = { 0.15, 0.15, 0.15 },
		}
		self.ponr.reenforce.groups = {
			FBI_reinforce_swats = { 1, 1, 1 },
		}
	elseif difficulty_index == 4 then
		self.ponr.assault.groups = {
			FBI_assault_heavies = { 1, 1, 1 },
			FBI_assault_shield = { 0.3, 0.3, 0.3 },
			FBI_assault_cloaker = { 0.25, 0.25, 0.25 },
			
			Elite_assault_swats = { 0.5, 0.5, 0.5 },
			Elite_assault_shield = { 0.4, 0.4, 0.4 },
			Elite_assault_taser = { 0.25, 0.25, 0.25 },
			Elite_assault_bulldozer = { 0.2, 0.2, 0.2 },
		}
		self.ponr.reenforce.groups = {
			Elite_reinforce_swats = { 1, 1, 1 },
		}
	elseif difficulty_index == 5 then
		self.ponr.assault.groups = {
			FBI_assault_heavies = { 1, 1, 1 },
			FBI_assault_shield = { 0.3, 0.3, 0.3 },
			FBI_assault_cloaker = { 0.25, 0.25, 0.25 },
			
			Elite_assault_swats = { 0.5, 0.5, 0.5 },
			Elite_assault_shield = { 0.4, 0.4, 0.4 },
			Elite_assault_taser = { 0.25, 0.25, 0.25 },
			Elite_assault_bulldozer = { 0.2, 0.2, 0.2 },
		}
		self.ponr.reenforce.groups = {
			Elite_reinforce_swats = { 1, 1, 1 },
		}
	elseif difficulty_index == 6 then
		self.ponr.assault.groups = {
			Elite_assault_shield = { 0.4, 0.4, 0.4 },
			Elite_assault_bulldozer = { 0.25, 0.25, 0.25 },

			Zeal_assault_swats = { 0.5, 0.5, 0.5 },
			Zeal_assault_heavies = { 1, 1, 1 },
			Zeal_assault_shield = { 0.5, 0.5, 0.5 },
			Zeal_assault_taser = { 0.3, 0.3, 0.3 },
			Zeal_assault_cloaker = { 0.3, 0.3, 0.3 },
		}
		self.ponr.reenforce.groups = {
			Zeal_reinforce_swats = { 1, 1, 1 },
		}
	end

	self.ponr.cloaker.groups = { 
		single_spooc = { 1, 1, 1 } 
	}
	
	-- misc
	self.ponr.assault.groups.single_spooc = { 0, 0, 0 }
	self.ponr.assault.groups.Phalanx = { 0, 0, 0 }
	self.ponr.assault.groups.marshal_squad = { 0, 0, 0 }
	self.ponr.assault.groups.custom_assault = { 0, 0, 0 }
	self.ponr.assault.groups.snowman_boss = { 0, 0, 0 }
	self.ponr.assault.groups.piggydozer = { 0, 0, 0 }
	
	self.ponr.recon.groups.single_spooc = { 0, 0, 0 }
	self.ponr.recon.groups.Phalanx = { 0, 0, 0 }
	self.ponr.recon.groups.marshal_squad = { 0, 0, 0 }
	self.ponr.recon.groups.custom_assault = { 0, 0, 0 }
	self.ponr.recon.groups.snowman_boss = { 0, 0, 0 }
	self.ponr.recon.groups.piggydozer = { 0, 0, 0 }

	-- nuke captain
	self.phalanx.spawn_chance = {
		decrease = 0,
		start = 0,
		respawn_delay = 300000,
		increase = 0,
		max = 1,
	}

	self.street = deep_clone(self.besiege)
	self.safehouse = deep_clone(self.besiege)
end)
