local level_id = Eclipse.utils.level_id()
local diff_i = Eclipse.utils.difficulty_index()
local is_overkill = Eclipse.utils.is_overkill()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local short_ponr_heists = Eclipse:require("short_ponr_heists")
local diff_lerp = Eclipse.utils.diff_lerp
local table_multiplier = Eclipse.utils.table_multiplier
local get_difficulty_specific_value = Eclipse.utils.get_difficulty_specific_value

GroupAITweakData.group_ai_presets = {
	["small_urban"] = {
		cs_cops = 1.5,

		cs_heavies = { 0, 0, 1 },
		fbi_heavies = { 0, 0, 1 },
		elite_heavies = { 0, 0, 1 },

		cs_bulldozer = 0.75,
		fbi_bulldozer = 0.75,
		elite_bulldozer = 0.75,
		elite_bulldozer_shield = 0.75,

		cs_defend_init = { 2, 1.5, 1 },
		fbi_defend_init = { 1.5, 1, 1 },

		cs_defend_light = { 0, 0.5, 1 },
		fbi_defend_light = { 0, 0.5, 1 },
		elite_defend_light = { 0, 0.5, 1 },

		cs_defend_heavy = { 0, 0, 0.5 },
		fbi_defend_heavy = { 0, 0, 0.5 },
		elite_defend_heavy = { 0, 0, 0.5 },

		cs_stealth_heavy = { 0, 0, 0.75 },
		fbi_stealth_heavy = { 0, 0, 0.75 },
	},
	["heavy_response"] = {
		cs_cops = 0.5,

		cs_defend_init = { 0.5, 0, 0 },
		fbi_defend_init = { 0.5, 0, 0 },

		cs_stealth_init = { 1, 0.5, 0 },
		fbi_stealth_init = { 1, 0.5, 0 },

		cs_stealth_heavy = 1.5,
		fbi_stealth_heavy = 1.5,
	},
	["remote"] = {
		cs_cops = 0.25,

		cs_defend_init = { 0.5, 0, 0 },
		fbi_defend_init = { 0.5, 0, 0 },

		cs_stealth_init = { 1, 0.5, 0 },
		fbi_stealth_init = { 1, 0.5, 0 },

		cs_stealth_heavy = 2.5,
		fbi_stealth_heavy = 2.5,
	},
	["street"] = {
		cs_stealth_heavy = 2.5,
		fbi_stealth_heavy = 2.5,
	},
}

-- Helper to change freq based on engagement distance
function GroupAITweakData:_distance_weighted_spawn_entry(spawn_entry, from_dis, to_dis, from_weight, to_weight)
	local function dis_freq()
		local dis = 0
		local num = 0
		for _, data in pairs(managers and managers.groupai and managers.groupai:state()._police or {}) do
			local focus_enemy = data.unit:brain()._logic_data.attention_obj
			if focus_enemy and focus_enemy.criminal_record and focus_enemy.verified_dis and focus_enemy.verified_t then
				dis = dis + focus_enemy.verified_dis
				num = num + 1
			end
		end
		if num > 0 then
			self._last_dis_freq = dis / num
		end
		return math.map_range_clamped(self._last_dis_freq or (from_dis + to_dis) / 2, from_dis, to_dis, from_weight, to_weight)
	end

	local entry_freq = spawn_entry.freq_by_diff or spawn_entry.freq or 1
	spawn_entry.freq_by_diff = nil
	spawn_entry.freq = nil
	return setmetatable(spawn_entry, {
		__index = function(t, k)
			if k == "freq_by_diff" and type(entry_freq) == "table" then -- edit here
				local new_freq = {}
				for i, weight in pairs(entry_freq) do
					new_freq[i] = weight * dis_freq()
				end
				return new_freq
			elseif k == "freq" then
				return entry_freq * dis_freq()
			end
		end,
	})
end

-- Top level init
Hooks:PostHook(GroupAITweakData, "init", "eclipse_init", function(self, tweak_data)
	self.tweak_data = tweak_data

	self.timer_data = {}

	local lvl_tweak = self.tweak_data.levels[level_id]

	self._mission_settings = lvl_tweak and lvl_tweak.group_ai_settings or nil
end)

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
	self.enemy_chatter.contact.radius = radius_medium
	self.enemy_chatter.clear.duration = duration_medium
	self.enemy_chatter.clear.radius = radius_medium
	self.enemy_chatter.retreat.queue = "m01"
	self.enemy_chatter.push = clone(self.enemy_chatter.go_go)
	self.enemy_chatter.push.queue = "pus"
	self.enemy_chatter.stand_by = clone(self.enemy_chatter.go_go)
	self.enemy_chatter.stand_by.queue = "prm"
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
	self.enemy_chatter.hostage_delay_1 = clone(self.enemy_chatter.go_go)
	self.enemy_chatter.hostage_delay_1.queue = "p01"
	self.enemy_chatter.hostage_delay_1.duration = duration_long
	self.enemy_chatter.hostage_delay_1.radius = radius_medium
	self.enemy_chatter.hostage_delay_2 = clone(self.enemy_chatter.hostage_delay_1)
	self.enemy_chatter.hostage_delay_2.queue = "p02"
	self.enemy_chatter.group_death = clone(self.enemy_chatter.watch_background)
	self.enemy_chatter.group_death.queue = "lk3a"
	self.enemy_chatter.trip_mine = clone(self.enemy_chatter.contact)
	self.enemy_chatter.trip_mine.queue = "ch1"
	self.enemy_chatter.trip_mine.duration = duration_long
	self.enemy_chatter.trip_mine.radius = radius_large
	self.enemy_chatter.sentry_gun = clone(self.enemy_chatter.trip_mine)
	self.enemy_chatter.sentry_gun.queue = "ch2"
	self.enemy_chatter.reloading = clone(self.enemy_chatter.contact)
	self.enemy_chatter.reloading.queue = "rrl"
	self.enemy_chatter.jammer = clone(self.enemy_chatter.aggressive)
	self.enemy_chatter.jammer.queue = "ch3"
	self.enemy_chatter.jammer.radius = radius_medium
	self.enemy_chatter.saw = clone(self.enemy_chatter.sentry_gun)
	self.enemy_chatter.saw.queue = "ch4"
	self.enemy_chatter.assault_move_out_a = clone(self.enemy_chatter.go_go)
	self.enemy_chatter.assault_move_out_a.queue = "gr2a"
	self.enemy_chatter.assault_move_out_a.duration = duration_long
	self.enemy_chatter.assault_move_out_a.radius = radius_medium
	self.enemy_chatter.assault_move_out_b = clone(self.enemy_chatter.assault_move_out_a)
	self.enemy_chatter.assault_move_out_b.queue = "gr2b"
	self.enemy_chatter.assault_move_out_c = clone(self.enemy_chatter.assault_move_out_a)
	self.enemy_chatter.assault_move_out_c.queue = "gr2c"
	self.enemy_chatter.assault_move_out_d = clone(self.enemy_chatter.assault_move_out_a)
	self.enemy_chatter.assault_move_out_d.queue = "gr2d"
	self.enemy_chatter.recon_move_out_a = clone(self.enemy_chatter.go_go)
	self.enemy_chatter.recon_move_out_a.queue = "gr1a"
	self.enemy_chatter.recon_move_out_a.duration = duration_long
	self.enemy_chatter.recon_move_out_a.radius = radius_medium
	self.enemy_chatter.recon_move_out_b = clone(self.enemy_chatter.recon_move_out_a)
	self.enemy_chatter.recon_move_out_b.queue = "gr1b"
	self.enemy_chatter.recon_move_out_c = clone(self.enemy_chatter.recon_move_out_a)
	self.enemy_chatter.recon_move_out_c.queue = "gr1c"
	self.enemy_chatter.recon_move_out_d = clone(self.enemy_chatter.recon_move_out_a)
	self.enemy_chatter.recon_move_out_d.queue = "gr1d"

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

	-- ponr_state_special_limit_add is used primarily to enable new special types only during FFO
	if difficulty_index <= 2 then
		self.special_unit_spawn_limits = {
			shield = 2,
			taser = 0,
			tank = 0,
			spooc = 0,
			medic = 0,
			marksman = 0,
		}
		self.ponr_state_special_limit_add = {
			shield = 0,
			taser = 1,
			tank = 1,
			spooc = 1,
			medic = 1,
			marksman = 0,
		}
	elseif difficulty_index == 3 then
		self.special_unit_spawn_limits = {
			shield = 2,
			taser = 1,
			tank = 1,
			spooc = 1,
			medic = 0,
			marksman = 0,
		}
		self.ponr_state_special_limit_add = {
			shield = 0,
			taser = 0,
			tank = 0,
			spooc = 0,
			medic = 1,
			marksman = 0,
		}
	elseif difficulty_index == 4 then
		self.special_unit_spawn_limits = {
			shield = 3,
			taser = 1,
			tank = 1,
			spooc = 2,
			medic = 2,
			marksman = 0,
		}
		self.ponr_state_special_limit_add = {
			shield = 0,
			taser = 0,
			tank = 0,
			spooc = 0,
			medic = 0,
			marksman = 1,
		}
	elseif difficulty_index == 5 then
		self.special_unit_spawn_limits = {
			shield = 4,
			taser = 2,
			tank = 2,
			spooc = 2,
			medic = 3,
			marksman = 0,
		}
		self.ponr_state_special_limit_add = {
			shield = 0,
			taser = 0,
			tank = 0,
			spooc = 0,
			medic = 0,
			marksman = 2,
		}
	else
		self.special_unit_spawn_limits = {
			shield = 5,
			taser = 3,
			tank = 3,
			spooc = 3,
			medic = 4,
			marksman = 3,
		}
		self.ponr_state_special_limit_add = {
			shield = 0,
			taser = 0,
			tank = 0,
			spooc = 0,
			medic = 0,
			marksman = 0,
		}
	end

	-- Add special unit limit scaling for BigLobby
	self.special_unit_spawn_limits_balance_mul = {}
	for i = 0, 21, 1 do
		table.insert(self.special_unit_spawn_limits_balance_mul, 1 + math.floor(i * 0.05 / 0.2) * 0.2)
	end

	self.unit_categories.cs_cop_1 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_cop_1/ene_cop_1") },
			russia = { Idstring("units/payday2/characters/ene_cop_1/ene_cop_1") },
			zombie = { Idstring("units/payday2/characters/ene_cop_1/ene_cop_1") },
			murkywater = { Idstring("units/payday2/characters/ene_cop_1/ene_cop_1") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_policia_01/ene_policia_01") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.cs_cop_2 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_cop_2/ene_cop_2") },
			russia = { Idstring("units/payday2/characters/ene_cop_2/ene_cop_2") },
			zombie = { Idstring("units/payday2/characters/ene_cop_2/ene_cop_2") },
			murkywater = { Idstring("units/payday2/characters/ene_cop_2/ene_cop_2") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_policia_02/ene_policia_02") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.cs_cop_3 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_cop_3/ene_cop_3") },
			russia = { Idstring("units/payday2/characters/ene_cop_3/ene_cop_3") },
			zombie = { Idstring("units/payday2/characters/ene_cop_3/ene_cop_3") },
			murkywater = { Idstring("units/payday2/characters/ene_cop_3/ene_cop_3") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_policia_03/ene_policia_03") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.cs_cop_4 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_cop_4/ene_cop_4") },
			russia = { Idstring("units/payday2/characters/ene_cop_4/ene_cop_4") },
			zombie = { Idstring("units/payday2/characters/ene_cop_4/ene_cop_4") },
			murkywater = { Idstring("units/payday2/characters/ene_cop_4/ene_cop_4") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_policia_04/ene_policia_04") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.cs_cop_1_2 = {
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
				Idstring("units/pd2_dlc_bex/characters/ene_policia_01/ene_policia_01"),
				Idstring("units/pd2_dlc_bex/characters/ene_policia_02/ene_policia_02"),
			},
		},
		access = access_type_walk_only,
	}

	self.unit_categories.cs_cop_1_4 = {
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
				Idstring("units/pd2_dlc_bex/characters/ene_policia_01/ene_policia_01"),
				Idstring("units/pd2_dlc_bex/characters/ene_policia_04/ene_policia_04"),
			},
		},
		access = access_type_walk_only,
	}

	self.unit_categories.cs_cop_2_3 = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_cop_2/ene_cop_2"),
				Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_cop_2/ene_cop_2"),
				Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_cop_2/ene_cop_2"),
				Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_cop_2/ene_cop_2"),
				Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_policia_02/ene_policia_02"),
				Idstring("units/pd2_dlc_bex/characters/ene_policia_03/ene_policia_03"),
			},
		},
		access = access_type_walk_only,
	}

	self.unit_categories.cs_cop_3_4 = {
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
				Idstring("units/pd2_dlc_bex/characters/ene_policia_03/ene_policia_03"),
				Idstring("units/pd2_dlc_bex/characters/ene_policia_04/ene_policia_04"),
			},
		},
		access = access_type_walk_only,
	}

	self.unit_categories.cs_cop = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
				Idstring("units/payday2/characters/ene_cop_2/ene_cop_2"),
				Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
				Idstring("units/payday2/characters/ene_cop_4/ene_cop_4"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
				Idstring("units/payday2/characters/ene_cop_2/ene_cop_2"),
				Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
				Idstring("units/payday2/characters/ene_cop_4/ene_cop_4"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
				Idstring("units/payday2/characters/ene_cop_2/ene_cop_2"),
				Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
				Idstring("units/payday2/characters/ene_cop_4/ene_cop_4"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
				Idstring("units/payday2/characters/ene_cop_2/ene_cop_2"),
				Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
				Idstring("units/payday2/characters/ene_cop_4/ene_cop_4"),
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_policia_01/ene_policia_01"),
				Idstring("units/pd2_dlc_bex/characters/ene_policia_02/ene_policia_02"),
				Idstring("units/pd2_dlc_bex/characters/ene_policia_03/ene_policia_03"),
				Idstring("units/pd2_dlc_bex/characters/ene_policia_04/ene_policia_04"),
			},
		},
		access = access_type_walk_only,
	}

	self.unit_categories.cs_swat_1 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_swat_1/ene_swat_1") },
			russia = { Idstring("units/payday2/characters/ene_swat_1/ene_swat_1") },
			zombie = { Idstring("units/payday2/characters/ene_swat_1/ene_swat_1") },
			murkywater = { Idstring("units/payday2/characters/ene_swat_1/ene_swat_1") },
			federales = { Idstring("units/payday2/characters/ene_swat_1/ene_swat_1") },
		},
		access = access_type_all,
	}

	self.unit_categories.cs_swat_2 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_swat_2/ene_swat_2") },
			russia = { Idstring("units/payday2/characters/ene_swat_2/ene_swat_2") },
			zombie = { Idstring("units/payday2/characters/ene_swat_2/ene_swat_2") },
			murkywater = { Idstring("units/payday2/characters/ene_swat_2/ene_swat_2") },
			federales = { Idstring("units/payday2/characters/ene_swat_2/ene_swat_2") },
		},
		access = access_type_all,
	}

	self.unit_categories.cs_swat_3 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_swat_3/ene_swat_3") },
			russia = { Idstring("units/payday2/characters/ene_swat_3/ene_swat_3") },
			zombie = { Idstring("units/payday2/characters/ene_swat_3/ene_swat_3") },
			murkywater = { Idstring("units/payday2/characters/ene_swat_3/ene_swat_3") },
			federales = { Idstring("units/payday2/characters/ene_swat_3/ene_swat_3") },
		},
		access = access_type_all,
	}

	self.unit_categories.cs_swat_1_3 = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
				Idstring("units/payday2/characters/ene_swat_3/ene_swat_3"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
				Idstring("units/payday2/characters/ene_swat_3/ene_swat_3"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
				Idstring("units/payday2/characters/ene_swat_3/ene_swat_3"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
				Idstring("units/payday2/characters/ene_swat_3/ene_swat_3"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
				Idstring("units/payday2/characters/ene_swat_3/ene_swat_3"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.cs_swat_2_3 = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"),
				Idstring("units/payday2/characters/ene_swat_3/ene_swat_3"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"),
				Idstring("units/payday2/characters/ene_swat_3/ene_swat_3"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"),
				Idstring("units/payday2/characters/ene_swat_3/ene_swat_3"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"),
				Idstring("units/payday2/characters/ene_swat_3/ene_swat_3"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"),
				Idstring("units/payday2/characters/ene_swat_3/ene_swat_3"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.cs_swat = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
				Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"),
				Idstring("units/payday2/characters/ene_swat_3/ene_swat_3"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
				Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"),
				Idstring("units/payday2/characters/ene_swat_3/ene_swat_3"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
				Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"),
				Idstring("units/payday2/characters/ene_swat_3/ene_swat_3"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
				Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"),
				Idstring("units/payday2/characters/ene_swat_3/ene_swat_3"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
				Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"),
				Idstring("units/payday2/characters/ene_swat_3/ene_swat_3"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.cs_heavy_1 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1") },
			russia = { Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1") },
			zombie = { Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1") },
			murkywater = { Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1") },
			federales = { Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1") },
		},
		access = access_type_all,
	}

	self.unit_categories.cs_heavy_2 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870") },
			russia = { Idstring("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870") },
			zombie = { Idstring("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870") },
			murkywater = { Idstring("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870") },
			federales = { Idstring("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870") },
		},
		access = access_type_all,
	}

	self.unit_categories.cs_heavy = {
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

	self.unit_categories.cs_shield = {
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

	self.unit_categories.fbi_agent_1 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1") },
			russia = { Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1") },
			zombie = { Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1") },
			murkywater = { Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_policia_agent_01/ene_policia_agent_01") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.fbi_agent_2 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2") },
			russia = { Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2") },
			zombie = { Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2") },
			murkywater = { Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_policia_agent_02/ene_policia_agent_02") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.fbi_agent_3 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3") },
			russia = { Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3") },
			zombie = { Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3") },
			murkywater = { Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_policia_agent_03/ene_policia_agent_03") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.fbi_agent_1_2 = {
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
				Idstring("units/pd2_dlc_bex/characters/ene_policia_agent_01/ene_policia_agent_01"),
				Idstring("units/pd2_dlc_bex/characters/ene_policia_agent_02/ene_policia_agent_02"),
			},
		},
		access = access_type_walk_only,
	}

	self.unit_categories.fbi_agent_2_3 = {
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
				Idstring("units/pd2_dlc_bex/characters/ene_policia_agent_02/ene_policia_agent_02"),
				Idstring("units/pd2_dlc_bex/characters/ene_policia_agent_03/ene_policia_agent_03"),
			},
		},
		access = access_type_walk_only,
	}

	self.unit_categories.fbi_swat_1 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1") },
			russia = { Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1") },
			zombie = { Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1") },
			murkywater = { Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1") },
			federales = { Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1") },
		},
		access = access_type_all,
	}

	self.unit_categories.fbi_swat_2 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2") },
			russia = { Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2") },
			zombie = { Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2") },
			murkywater = { Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2") },
			federales = { Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2") },
		},
		access = access_type_all,
	}

	self.unit_categories.fbi_swat_3 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3") },
			russia = { Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3") },
			zombie = { Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3") },
			murkywater = { Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3") },
			federales = { Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3") },
		},
		access = access_type_all,
	}

	self.unit_categories.fbi_swat_1_3 = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
				Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
				Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
				Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
				Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
				Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.fbi_swat_2_3 = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
				Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
				Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
				Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
				Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
				Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.fbi_swat = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
				Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
				Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
				Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
				Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
				Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
				Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
				Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
				Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
				Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
				Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.fbi_heavy_1 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1") },
			russia = { Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1") },
			zombie = { Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1") },
			murkywater = { Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1") },
			federales = { Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1") },
		},
		access = access_type_all,
	}

	self.unit_categories.fbi_heavy_2 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870") },
			russia = { Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870") },
			zombie = { Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870") },
			murkywater = { Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870") },
			federales = { Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870") },
		},
		access = access_type_all,
	}

	self.unit_categories.fbi_heavy = {
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

	self.unit_categories.fbi_shield = {
		special_type = "shield",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_shield_1/ene_shield_1") },
			russia = { Idstring("units/payday2/characters/ene_shield_1/ene_shield_1") },
			zombie = { Idstring("units/payday2/characters/ene_shield_1/ene_shield_1") },
			murkywater = { Idstring("units/payday2/characters/ene_shield_1/ene_shield_1") },
			federales = { Idstring("units/payday2/characters/ene_shield_1/ene_shield_1") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.elite_swat_1 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1") },
			russia = { Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1") },
			zombie = { Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1") },
			murkywater = { Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1") },
			federales = { Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1") },
		},
		access = access_type_all,
	}

	self.unit_categories.elite_swat_2 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2") },
			russia = { Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2") },
			zombie = { Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2") },
			murkywater = { Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2") },
			federales = { Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2") },
		},
		access = access_type_all,
	}

	self.unit_categories.elite_swat_3 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3") },
			russia = { Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3") },
			zombie = { Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3") },
			murkywater = { Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3") },
			federales = { Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3") },
		},
		access = access_type_all,
	}

	self.unit_categories.elite_swat_1_3 = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1"),
				Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1"),
				Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1"),
				Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1"),
				Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1"),
				Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.elite_swat_2_3 = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2"),
				Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2"),
				Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2"),
				Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2"),
				Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2"),
				Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.elite_swat = {
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

	self.unit_categories.elite_heavy_1 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36") },
			russia = { Idstring("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36") },
			zombie = { Idstring("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36") },
			murkywater = { Idstring("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36") },
			federales = { Idstring("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36") },
		},
		access = access_type_all,
	}

	self.unit_categories.elite_heavy_2 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870") },
			russia = { Idstring("units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870") },
			zombie = { Idstring("units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870") },
			murkywater = { Idstring("units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870") },
			federales = { Idstring("units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870") },
		},
		access = access_type_all,
	}

	self.unit_categories.elite_heavy = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"),
				Idstring("units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"),
				Idstring("units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"),
				Idstring("units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"),
				Idstring("units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"),
				Idstring("units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.elite_sniper = {
		special_type = "marksman",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_sniper_3/ene_sniper_3") },
			russia = { Idstring("units/payday2/characters/ene_sniper_3/ene_sniper_3") },
			zombie = { Idstring("units/payday2/characters/ene_sniper_3/ene_sniper_3") },
			murkywater = { Idstring("units/payday2/characters/ene_sniper_3/ene_sniper_3") },
			federales = { Idstring("units/payday2/characters/ene_sniper_3/ene_sniper_3") },
		},
		access = access_type_all,
	}

	self.unit_categories.elite_shield = {
		special_type = "shield",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_city_shield/ene_city_shield") },
			russia = { Idstring("units/payday2/characters/ene_city_shield/ene_city_shield") },
			zombie = { Idstring("units/payday2/characters/ene_city_shield/ene_city_shield") },
			murkywater = { Idstring("units/payday2/characters/ene_city_shield/ene_city_shield") },
			federales = { Idstring("units/payday2/characters/ene_city_shield/ene_city_shield") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.taser_1 = {
		special_type = "taser",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1") },
			russia = { Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1") },
			zombie = { Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1") },
			murkywater = { Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1") },
			federales = { Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1") },
		},
		access = access_type_all,
	}

	self.unit_categories.taser_2 = {
		special_type = "taser",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_tazer_r870/ene_tazer_r870") },
			russia = { Idstring("units/payday2/characters/ene_tazer_r870/ene_tazer_r870") },
			zombie = { Idstring("units/payday2/characters/ene_tazer_r870/ene_tazer_r870") },
			murkywater = { Idstring("units/payday2/characters/ene_tazer_r870/ene_tazer_r870") },
			federales = { Idstring("units/payday2/characters/ene_tazer_r870/ene_tazer_r870") },
		},
		access = access_type_all,
	}

	self.unit_categories.taser = {
		special_type = "taser",
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
				Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
				Idstring("units/payday2/characters/ene_tazer_r870/ene_tazer_r870"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
				Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
				Idstring("units/payday2/characters/ene_tazer_r870/ene_tazer_r870"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
				Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
				Idstring("units/payday2/characters/ene_tazer_r870/ene_tazer_r870"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
				Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
				Idstring("units/payday2/characters/ene_tazer_r870/ene_tazer_r870"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
				Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
				Idstring("units/payday2/characters/ene_tazer_r870/ene_tazer_r870"),
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
				Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"),
				Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"),
				Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"),
				Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"),
				Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"),
				Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"),
				Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"),
				Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"),
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
			russia = { Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2") },
			zombie = { Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2") },
			murkywater = { Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2") },
			federales = { Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.bulldozer = {
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

	self.unit_categories.elite_bulldozer_1 = {
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

	self.unit_categories.elite_bulldozer_2 = {
		special_type = "tank",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3") },
			russia = { Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3") },
			zombie = { Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3") },
			murkywater = { Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3") },
			federales = { Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.elite_bulldozer = {
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

	self.unit_categories.fbi_readyteam = {
		unit_types = {
			america = {
				Idstring("units/pd2_mcmansion/characters/ene_hoxton_breakout_guard_1/ene_hoxton_breakout_guard_1"),
				Idstring("units/pd2_mcmansion/characters/ene_hoxton_breakout_guard_2/ene_hoxton_breakout_guard_2"),
			},
			russia = {
				Idstring("units/pd2_mcmansion/characters/ene_hoxton_breakout_guard_1/ene_hoxton_breakout_guard_1"),
				Idstring("units/pd2_mcmansion/characters/ene_hoxton_breakout_guard_2/ene_hoxton_breakout_guard_2"),
			},
			zombie = {
				Idstring("units/pd2_mcmansion/characters/ene_hoxton_breakout_guard_1/ene_hoxton_breakout_guard_1"),
				Idstring("units/pd2_mcmansion/characters/ene_hoxton_breakout_guard_2/ene_hoxton_breakout_guard_2"),
			},
			murkywater = {
				Idstring("units/pd2_mcmansion/characters/ene_hoxton_breakout_guard_1/ene_hoxton_breakout_guard_1"),
				Idstring("units/pd2_mcmansion/characters/ene_hoxton_breakout_guard_2/ene_hoxton_breakout_guard_2"),
			},
			federales = {
				Idstring("units/pd2_mcmansion/characters/ene_hoxton_breakout_guard_1/ene_hoxton_breakout_guard_1"),
				Idstring("units/pd2_mcmansion/characters/ene_hoxton_breakout_guard_2/ene_hoxton_breakout_guard_2"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.gensec_tacteam = {
		unit_types = {
			america = {
				Idstring("units/pd2_dlc1/characters/ene_gensec_operator_1/ene_gensec_operator_1"),
				Idstring("units/pd2_dlc1/characters/ene_gensec_operator_2/ene_gensec_operator_2"),
			},
			russia = {
				Idstring("units/pd2_dlc1/characters/ene_gensec_operator_1/ene_gensec_operator_1"),
				Idstring("units/pd2_dlc1/characters/ene_gensec_operator_2/ene_gensec_operator_2"),
			},
			zombie = {
				Idstring("units/pd2_dlc1/characters/ene_gensec_operator_1/ene_gensec_operator_1"),
				Idstring("units/pd2_dlc1/characters/ene_gensec_operator_2/ene_gensec_operator_2"),
			},
			murkywater = {
				Idstring("units/pd2_dlc1/characters/ene_gensec_operator_1/ene_gensec_operator_1"),
				Idstring("units/pd2_dlc1/characters/ene_gensec_operator_2/ene_gensec_operator_2"),
			},
			federales = {
				Idstring("units/pd2_dlc1/characters/ene_gensec_operator_1/ene_gensec_operator_1"),
				Idstring("units/pd2_dlc1/characters/ene_gensec_operator_2/ene_gensec_operator_2"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.murkywater = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_murkywater_1/ene_murkywater_1"),
				Idstring("units/payday2/characters/ene_murkywater_2/ene_murkywater_2"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_murkywater_1/ene_murkywater_1"),
				Idstring("units/payday2/characters/ene_murkywater_2/ene_murkywater_2"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_murkywater_1/ene_murkywater_1"),
				Idstring("units/payday2/characters/ene_murkywater_2/ene_murkywater_2"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_murkywater_1/ene_murkywater_1"),
				Idstring("units/payday2/characters/ene_murkywater_2/ene_murkywater_2"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_murkywater_1/ene_murkywater_1"),
				Idstring("units/payday2/characters/ene_murkywater_2/ene_murkywater_2"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.army_soldier_1 = {
		unit_types = {
			america = { Idstring("units/pd2_dlc_army/characters/ene_soldier_1/ene_soldier_1") },
			russia = { Idstring("units/pd2_dlc_army/characters/ene_soldier_1/ene_soldier_1") },
			zombie = { Idstring("units/pd2_dlc_army/characters/ene_soldier_1/ene_soldier_1") },
			murkywater = { Idstring("units/pd2_dlc_army/characters/ene_soldier_1/ene_soldier_1") },
			federales = { Idstring("units/pd2_dlc_army/characters/ene_soldier_1/ene_soldier_1") },
		},
		access = access_type_all,
	}

	self.unit_categories.army_soldier_2 = {
		unit_types = {
			america = { Idstring("units/pd2_dlc_army/characters/ene_soldier_2/ene_soldier_2") },
			russia = { Idstring("units/pd2_dlc_army/characters/ene_soldier_2/ene_soldier_2") },
			zombie = { Idstring("units/pd2_dlc_army/characters/ene_soldier_2/ene_soldier_2") },
			murkywater = { Idstring("units/pd2_dlc_army/characters/ene_soldier_2/ene_soldier_2") },
			federales = { Idstring("units/pd2_dlc_army/characters/ene_soldier_2/ene_soldier_2") },
		},
		access = access_type_all,
	}

	self.unit_categories.army_soldier_3 = {
		unit_types = {
			america = { Idstring("units/pd2_dlc_army/characters/ene_soldier_3/ene_soldier_3") },
			russia = { Idstring("units/pd2_dlc_army/characters/ene_soldier_3/ene_soldier_3") },
			zombie = { Idstring("units/pd2_dlc_army/characters/ene_soldier_3/ene_soldier_3") },
			murkywater = { Idstring("units/pd2_dlc_army/characters/ene_soldier_3/ene_soldier_3") },
			federales = { Idstring("units/pd2_dlc_army/characters/ene_soldier_3/ene_soldier_3") },
		},
		access = access_type_all,
	}

	self.unit_categories.army_soldier_4 = {
		unit_types = {
			america = { Idstring("units/pd2_dlc_army/characters/ene_soldier_4/ene_soldier_4") },
			russia = { Idstring("units/pd2_dlc_army/characters/ene_soldier_4/ene_soldier_4") },
			zombie = { Idstring("units/pd2_dlc_army/characters/ene_soldier_4/ene_soldier_4") },
			murkywater = { Idstring("units/pd2_dlc_army/characters/ene_soldier_4/ene_soldier_4") },
			federales = { Idstring("units/pd2_dlc_army/characters/ene_soldier_4/ene_soldier_4") },
		},
		access = access_type_all,
	}

	self.unit_categories.bellmead_security = {
		unit_types = {
			america = {
				Idstring("units/pd2_dlc_deep/characters/ene_deep_security_1/ene_deep_security_1"),
				Idstring("units/pd2_dlc_deep/characters/ene_deep_security_2/ene_deep_security_2"),
				Idstring("units/pd2_dlc_deep/characters/ene_deep_security_3/ene_deep_security_3"),
			},
			russia = {
				Idstring("units/pd2_dlc_deep/characters/ene_deep_security_1/ene_deep_security_1"),
				Idstring("units/pd2_dlc_deep/characters/ene_deep_security_2/ene_deep_security_2"),
				Idstring("units/pd2_dlc_deep/characters/ene_deep_security_3/ene_deep_security_3"),
			},
			zombie = {
				Idstring("units/pd2_dlc_deep/characters/ene_deep_security_1/ene_deep_security_1"),
				Idstring("units/pd2_dlc_deep/characters/ene_deep_security_2/ene_deep_security_2"),
				Idstring("units/pd2_dlc_deep/characters/ene_deep_security_3/ene_deep_security_3"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_deep/characters/ene_deep_security_1/ene_deep_security_1"),
				Idstring("units/pd2_dlc_deep/characters/ene_deep_security_2/ene_deep_security_2"),
				Idstring("units/pd2_dlc_deep/characters/ene_deep_security_3/ene_deep_security_3"),
			},
			federales = {
				Idstring("units/pd2_dlc_deep/characters/ene_deep_security_1/ene_deep_security_1"),
				Idstring("units/pd2_dlc_deep/characters/ene_deep_security_2/ene_deep_security_2"),
				Idstring("units/pd2_dlc_deep/characters/ene_deep_security_3/ene_deep_security_3"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.snowman_boss = {
		unit_types = {
			america = { Idstring("units/pd2_dlc_cg22/characters/ene_snowman_boss/ene_snowman_boss") },
			russia = { Idstring("units/pd2_dlc_cg22/characters/ene_snowman_boss/ene_snowman_boss") },
			zombie = { Idstring("units/pd2_dlc_cg22/characters/ene_snowman_boss/ene_snowman_boss") },
			murkywater = { Idstring("units/pd2_dlc_cg22/characters/ene_snowman_boss/ene_snowman_boss") },
			federales = { Idstring("units/pd2_dlc_cg22/characters/ene_snowman_boss/ene_snowman_boss") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.piggydozer = {
		unit_types = {
			america = { Idstring("units/pd2_dlc_pda10/characters/ene_dozer_piggy/ene_dozer_piggy") },
			russia = { Idstring("units/pd2_dlc_pda10/characters/ene_dozer_piggy/ene_dozer_piggy") },
			zombie = { Idstring("units/pd2_dlc_pda10/characters/ene_dozer_piggy/ene_dozer_piggy") },
			murkywater = { Idstring("units/pd2_dlc_pda10/characters/ene_dozer_piggy/ene_dozer_piggy") },
			federales = { Idstring("units/pd2_dlc_pda10/characters/ene_dozer_piggy/ene_dozer_piggy") },
		},
		access = access_type_walk_only,
	}
end)

Hooks:PostHook(GroupAITweakData, "_init_enemy_spawn_groups", "eclipse__init_enemy_spawn_groups", function(self, difficulty_index)
	local small_urban = self._mission_preset and self._mission_preset == "small_urban"
	local heavy_response = self._mission_preset and self._mission_preset == "heavy_response"
	local diff_scale_low = get_difficulty_specific_value({
		4,
		5,
		6,
		8,
		10,
	})
	local diff_scale = get_difficulty_specific_value({
		8,
		16,
		24,
		30,
		36,
	})

	self._tactics = {
		none = {},
		cop_init = {
			"no_push",
		},
		cop = {
			"ranged_fire",
			"no_push",
		},
		hrt_init = {
			"rescue",
			"ranged_fire",
			"flank",
		},
		hrt = {
			"rescue",
			"flank",
		},
		swat_def = {
			"ranged_fire",
			"smoke_grenade",
			"flash_grenade",
		},
		swat_agg = {
			"charge",
			"deathguard",
			"smoke_grenade",
			"flash_grenade",
		},
		swat_snk = {
			"rescue",
			"flank",
			"deathguard",
			"flash_grenade",
		},
		swat_snk_agg = {
			"charge",
			"flank",
			"deathguard",
			"flash_grenade",
		},
		swat_spt = {
			"ranged_fire",
			"unit_cover",
		},
		shield = {
			"shield",
		},
		shield_def = {
			"shield",
			"ranged_fire",
			"door_ambush",
		},
		shield_agg = {
			"shield",
			"charge",
			"deathguard",
		},
		shield_spt = {
			"shield_cover",
			"ranged_fire",
			"deathguard",
		},
		taser_snk = {
			"shield_cover",
			"murder",
			"flank",
			"flash_grenade",
		},
		taser_agg = {
			"shield_cover",
			"murder",
			"charge",
			"smoke_grenade",
		},
		taser_spt = {
			"shield",
			"murder",
		},
		bulldozer_def = {
			"shield",
			"door_ambush",
			"murder",
			"smoke_grenade",
		},
		bulldozer_agg = {
			"shield",
			"murder",
			"charge",
			"flash_grenade",
		},
		bulldozer_spt = {
			"shield_cover",
			"ranged_fire",
			"murder",
		},
		cloaker_def = {
			"no_push",
			"smoke_grenade",
		},
		cloaker_agg = {
			"flank",
			"charge",
			"smoke_grenade",
		},
		cloaker_spt = {
			"unit_cover",
			"murder",
		},
		sniper = {
			"unit_cover",
			"ranged_fire",
			"no_push",
		},
	}

	self._random_tactics = {
		light_rifle = {
			swat_def = 5,
			swat_snk = 2,
		},
		light_shotgun = {
			swat_agg = 2,
			swat_snk = 1,
		},
		light_smg = { "swat_def", "swat_snk" },
		heavy_rifle = {
			swat_def = 3,
			swat_snk = 1,
			swat_agg = 1,
		},
		heavy_shotgun = {
			swat_agg = 2,
			swat_snk_agg = 1,
		},
		shield = {
			shield_agg = 2,
			shield_def = 1,
		},
		bulldozer = {
			bulldozer_agg = 2,
			bulldozer_def = 1,
		},
		taser = { "taser_agg", "taser_snk" },
		cloaker = { "cloaker_def", "cloaker_agg" },
	}

	self._random_units = {
		light_special = {
			["medic_1"] = 2,
			["medic_2"] = 1,
			["cloaker"] = 1,
		},
		heavy_special = {
			["medic_1"] = 4,
			["medic_2"] = 2,
			["taser_1"] = 2,
			["taser_2"] = 1,
		},
		shield_special = {
			["medic_1"] = 5,
			["medic_2"] = 4,
			["cloaker"] = 3,
			["taser_1"] = 3,
			["taser_2"] = 2,
		},
		hrt_special = {
			"taser_1",
			"cloaker",
		},
	}

	-- соси хуй кк?
	self.enemy_spawn_groups = {}

	self.enemy_spawn_groups.cs_defend_init = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 1,
				rank = 1,
				unit = "cs_cop",
				tactics = self._tactics.cop_init,
			},
		},
	}

	self.enemy_spawn_groups.cs_defend_light = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 0.5,
				amount_max = 2,
				rank = 3,
				unit = "cs_swat_2_3",
				tactics = self._tactics.none,
			},
			{
				freq = 1,
				amount_min = 1,
				rank = 2,
				unit = "cs_swat_1",
				tactics = self._tactics.none,
			},
			{
				freq = 1,
				freq_by_diff = table_multiplier({
					6 / diff_scale_low,
					2 / diff_scale_low,
					0,
				}, heavy_response and 0 or 1),
				amount_max = 1,
				rank = 1,
				unit = "cs_cop_2_3",
				tactics = self._tactics.none,
			},
		},
	}

	self.enemy_spawn_groups.cs_defend_heavy = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 0.5,
				amount_max = 2,
				rank = 3,
				unit = "cs_heavy_2",
				tactics = self._tactics.none,
			},
			{
				freq = 1,
				amount_min = 1,
				rank = 2,
				unit = "cs_heavy_1",
				tactics = self._tactics.none,
			},
			{
				freq = 1,
				freq_by_diff = table_multiplier({
					3 / diff_scale_low,
					2 / diff_scale_low,
					1 / diff_scale_low,
				}, heavy_response and 0.25 or 1),
				amount_max = 2,
				rank = 1,
				unit = "cs_swat_1_3",
				tactics = self._tactics.none,
			},
		},
	}

	self.enemy_spawn_groups.cs_stealth_init = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 1,
				rank = 1,
				unit = "cs_cop_1",
				tactics = self._tactics.hrt_init,
			},
		},
	}

	self.enemy_spawn_groups.cs_stealth_light = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 1,
				rank = 1,
				unit = "cs_cop_3",
				tactics = self._tactics.hrt,
			},
		},
	}

	self.enemy_spawn_groups.cs_stealth_heavy = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 1,
				rank = 1,
				unit = "cs_swat_1_3",
				tactics = self._tactics.hrt,
			},
		},
	}

	self.enemy_spawn_groups.cs_cops = {
		amount = { 3, 3 },
		spawn = {
			{
				freq = 1,
				rank = 1,
				unit = "cs_cop",
				tactics = self._tactics.cop,
			},
		},
	}

	self.enemy_spawn_groups.cs_swats = {
		amount = { 3, 3 },
		spawn = {
			{
				freq = 0.5,
				amount_max = 2,
				rank = 1,
				unit = "cs_swat_2",
				tactics = self._tactics.swat_agg,
				random_tactics = self._random_tactics.light_shotgun,
			},
			{
				freq = 0.75,
				amount_max = 2,
				rank = 1,
				unit = "cs_swat_3",
				tactics = self._tactics.swat_snk,
				random_tactics = self._random_tactics.light_smg,
			},
			{
				freq = 1,
				amount_min = 1,
				amount_max = 3,
				rank = 1,
				unit = "cs_swat_1",
				tactics = self._tactics.swat_def,
				random_tactics = self._random_tactics.light_rifle,
			},
		},
	}

	self.enemy_spawn_groups.cs_heavies = {
		amount = { 3, 3 },
		spawn = {
			{
				freq = 0.5,
				amount_max = 2,
				rank = 2,
				unit = "cs_heavy_2",
				tactics = self._tactics.swat_agg,
				random_tactics = self._random_tactics.heavy_shotgun,
			},
			{
				freq = 1,
				amount_min = 1,
				amount_max = 3,
				rank = 2,
				unit = "cs_heavy_1",
				tactics = self._tactics.swat_def,
				random_tactics = self._random_tactics.heavy_rifle,
			},
			{
				freq = 1,
				freq_by_diff = table_multiplier({
					3 / diff_scale_low,
					2 / diff_scale_low,
					1 / diff_scale_low,
				}, heavy_response and 0.25 or 1),
				amount_max = 2,
				rank = 1,
				unit = "cs_swat_1_3",
				tactics = self._tactics.swat_spt,
			},
		},
	}

	self.enemy_spawn_groups.cs_shield = {
		amount = { 3, 4 },
		spawn = {
			{
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				rank = 3,
				unit = "cs_shield",
				tactics = self._tactics.shield_agg,
				random_tactics = self._random_tactics.shield,
			},
			{
				freq = 1,
				freq_by_diff = table_multiplier({
					6 / diff_scale_low,
					4 / diff_scale_low,
					2 / diff_scale_low,
				}, heavy_response and 0.25 or 1),
				rank = 2,
				unit = "cs_swat",
				tactics = self._tactics.shield_spt,
			},
			{
				freq = 0.75,
				rank = 2,
				unit = "cs_heavy",
				tactics = self._tactics.shield_spt,
			},
			{
				freq = 1,
				freq_by_diff = table_multiplier({
					2 / diff_scale_low,
					1 / diff_scale_low,
					0,
				}, heavy_response and 0 or 1),
				rank = 1,
				unit = "cs_cop_2_3",
				tactics = self._tactics.shield_spt,
			},
		},
	}

	self.enemy_spawn_groups.cs_taser = {
		amount = { 1, 3 },
		spawn = {
			{
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				rank = 2,
				unit = "taser",
				tactics = self._tactics.taser_agg,
				random_tactics = self._random_tactics.taser,
			},
			{
				freq = 0.75,
				rank = 1,
				unit = "cs_swat",
				tactics = self._tactics.taser_spt,
			},
		},
	}

	self.enemy_spawn_groups.cs_bulldozer = {
		amount = { 1, 3 },
		spawn = {
			{
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				rank = 2,
				unit = "bulldozer",
				tactics = self._tactics.bulldozer_agg,
				random_tactics = self._random_tactics.bulldozer,
			},
			{
				freq = 0.75,
				rank = 1,
				unit = "cs_heavy",
				tactics = self._tactics.bulldozer_spt,
			},
		},
	}

	self.enemy_spawn_groups.fbi_defend_init = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 1,
				amount_min = 1,
				rank = 2,
				unit = "fbi_agent_1_2",
				tactics = self._tactics.cop_init,
			},
			{
				freq = 1,
				freq_by_diff = table_multiplier({
					24 / diff_scale,
					6 / diff_scale,
					0,
				}, heavy_response and 0 or small_urban and 1.5 or 1),
				amount_max = 2,
				rank = 1,
				unit = "cs_cop_1_4",
				tactics = self._tactics.cop_init,
			},
		},
	}

	self.enemy_spawn_groups.fbi_defend_light = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 0.5,
				amount_max = 2,
				rank = 3,
				unit = "fbi_swat_2_3",
				tactics = self._tactics.none,
			},
			{
				freq = 1,
				amount_min = 1,
				rank = 2,
				unit = "fbi_swat_1",
				tactics = self._tactics.none,
			},
			{
				freq = 1,
				freq_by_diff = table_multiplier({
					30 / diff_scale,
					10 / diff_scale,
					0,
				}, heavy_response and 0 or 1),
				amount_max = 1,
				rank = 1,
				unit = "fbi_agent_3",
				tactics = self._tactics.none,
			},
			self:_distance_weighted_spawn_entry({
				freq = 1,
				freq_by_diff = {
					0,
					diff_scale / 240,
					diff_scale / 120,
				},
				amount_max = 1,
				rank = 1,
				unit = "cloaker",
				tactics = self._tactics.cloaker_spt,
			}, 1000, 3000, 3, 1),
			self:_distance_weighted_spawn_entry({
				freq = 1,
				freq_by_diff = {
					0,
					diff_scale / 360,
					diff_scale / 180,
				},
				amount_max = 1,
				rank = 1,
				unit = "elite_sniper",
				tactics = self._tactics.sniper,
			}, 1000, 3000, 1, 3),
		},
	}

	self.enemy_spawn_groups.fbi_defend_heavy = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 0.5,
				amount_max = 2,
				rank = 2,
				unit = "fbi_heavy_2",
				tactics = self._tactics.shield_spt,
			},
			{
				freq = 1,
				amount_min = 1,
				rank = 2,
				unit = "fbi_heavy_1",
				tactics = self._tactics.shield_spt,
			},
			{
				freq = 1,
				freq_by_diff = table_multiplier({
					20 / diff_scale,
					15 / diff_scale,
					10 / diff_scale,
				}, heavy_response and 0.25 or 1),
				amount_max = 1,
				rank = 1,
				unit = "fbi_swat_1_3",
				tactics = self._tactics.shield_spt,
			},
			self:_distance_weighted_spawn_entry({
				freq = 1,
				freq_by_diff = {
					0,
					diff_scale / 240,
					diff_scale / 120,
				},
				amount_max = 1,
				rank = 3,
				unit = "fbi_shield",
				tactics = self._tactics.shield,
			}, 1000, 3000, 3, 1),
			self:_distance_weighted_spawn_entry({
				freq = 1,
				freq_by_diff = {
					0,
					diff_scale / 360,
					diff_scale / 180,
				},
				amount_max = 1,
				rank = 1,
				unit = "elite_sniper",
				tactics = self._tactics.sniper,
			}, 1000, 3000, 1, 3),
		},
	}

	self.enemy_spawn_groups.fbi_stealth_init = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 1,
				rank = 1,
				unit = "fbi_agent_1_2",
				tactics = self._tactics.hrt_init,
			},
		},
	}

	self.enemy_spawn_groups.fbi_stealth_light = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 1,
				rank = 2,
				unit = "fbi_agent_3",
				tactics = self._tactics.hrt,
			},
			{
				freq = 1,
				freq_by_diff = {
					0,
					diff_scale / 180,
					diff_scale / 90,
				},
				amount_max = 1,
				rank = 1,
				unit = "taser",
				random_unit = self._random_units.hrt_special,
				tactics = self._tactics.swat_spt,
			},
		},
	}

	self.enemy_spawn_groups.fbi_stealth_heavy = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 1,
				rank = 2,
				unit = "fbi_swat_1_3",
				tactics = self._tactics.hrt,
			},
			{
				freq = 1,
				freq_by_diff = {
					0,
					diff_scale / 120,
					diff_scale / 60,
				},
				amount_max = 1,
				rank = 1,
				unit = "taser",
				random_unit = self._random_units.hrt_special,
				tactics = self._tactics.swat_spt,
			},
		},
	}

	self.enemy_spawn_groups.fbi_swats = {
		amount = { 3, 4 },
		spawn = {
			{
				freq = 0.5,
				amount_max = 2,
				rank = 2,
				unit = "fbi_swat_2",
				tactics = self._tactics.swat_agg,
				random_tactics = self._random_tactics.light_shotgun,
			},
			{
				freq = 0.75,
				amount_max = 2,
				rank = 2,
				unit = "fbi_swat_3",
				tactics = self._tactics.swat_snk,
				random_tactics = self._random_tactics.light_smg,
			},
			{
				freq = 1,
				amount_min = 1,
				amount_max = 3,
				rank = 2,
				unit = "fbi_swat_1",
				tactics = self._tactics.swat_def,
				random_tactics = self._random_tactics.light_rifle,
			},
			{
				freq = 1,
				freq_by_diff = table_multiplier({
					0,
					diff_scale / 120,
					diff_scale / 60,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				amount_max = 1,
				rank = 1,
				unit = "medic",
				random_unit = self._random_units.light_special,
				tactics = self._tactics.swat_spt,
			},
		},
	}

	self.enemy_spawn_groups.fbi_heavies = {
		amount = { 3, 4 },
		spawn = {
			{
				freq = 0.5,
				amount_max = 2,
				rank = 3,
				unit = "fbi_heavy_2",
				tactics = self._tactics.swat_agg,
				random_tactics = self._random_tactics.heavy_shotgun,
			},
			{
				freq = 1,
				amount_min = 1,
				amount_max = 3,
				rank = 3,
				unit = "fbi_heavy_1",
				tactics = self._tactics.swat_def,
				random_tactics = self._random_tactics.heavy_rifle,
			},
			{
				freq = 1,
				freq_by_diff = table_multiplier({
					20 / diff_scale,
					15 / diff_scale,
					10 / diff_scale,
				}, heavy_response and 0.25 or 1),
				amount_max = 2,
				rank = 2,
				unit = "fbi_swat_1_3",
				tactics = self._tactics.swat_spt,
			},
			{
				freq = 1,
				freq_by_diff = table_multiplier({
					0,
					diff_scale / 120,
					diff_scale / 60,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				amount_max = 1,
				rank = 1,
				unit = "medic",
				random_unit = self._random_units.heavy_special,
				tactics = self._tactics.swat_spt,
			},
		},
	}

	self.enemy_spawn_groups.fbi_shield = {
		amount = { 4, 4 },
		spawn = {
			{
				freq = (diff_scale / 90) * (heavy_response and 1.25 or small_urban and 0.5 or 1),
				amount_min = 1,
				amount_max = 2,
				rank = 3,
				unit = "fbi_shield",
				tactics = self._tactics.shield_agg,
				random_tactics = self._random_tactics.shield,
			},
			{
				freq = 1,
				freq_by_diff = table_multiplier({
					6 / diff_scale_low,
					4 / diff_scale_low,
					2 / diff_scale_low,
				}, heavy_response and 0.25 or 1),
				rank = 2,
				unit = "fbi_swat",
				tactics = self._tactics.shield_spt,
			},
			{
				freq = 0.75,
				rank = 2,
				unit = "fbi_heavy",
				tactics = self._tactics.shield_spt,
			},
			{
				freq = 1,
				freq_by_diff = table_multiplier({
					4 / diff_scale_low,
					2 / diff_scale_low,
					0,
				}, heavy_response and 0 or 1),
				rank = 1,
				unit = "fbi_agent_3",
				tactics = self._tactics.shield_spt,
			},
			{
				freq = 1,
				freq_by_diff = table_multiplier({
					0,
					diff_scale / 180,
					diff_scale / 90,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				amount_max = 1,
				rank = 1,
				unit = "medic",
				random_unit = self._random_units.shield_special,
				tactics = self._tactics.shield_spt,
			},
		},
	}

	self.enemy_spawn_groups.fbi_taser = {
		amount = { 2, 4 },
		spawn = {
			{
				freq = (diff_scale / 180) * (heavy_response and 1.25 or small_urban and 0.5 or 1),
				amount_min = 1,
				amount_max = 2,
				rank = 3,
				unit = "taser",
				tactics = self._tactics.taser_agg,
				random_tactics = self._random_tactics.taser,
			},
			{
				freq = 0.75,
				rank = 2,
				unit = "fbi_swat",
				tactics = self._tactics.taser_spt,
			},
			{
				freq = 1,
				freq_by_diff = table_multiplier({
					0,
					diff_scale / 240,
					diff_scale / 120,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				amount_max = 1,
				rank = 1,
				unit = "cloaker",
				random_unit = self._random_units.light_special,
				tactics = self._tactics.cloaker_spt,
			},
		},
	}

	self.enemy_spawn_groups.fbi_bulldozer = {
		amount = { 2, 4 },
		spawn = {
			{
				freq = (diff_scale / 480) * (heavy_response and 1.25 or small_urban and 0.5 or 1),
				amount_min = 1,
				amount_max = 2,
				rank = 3,
				unit = "bulldozer",
				tactics = self._tactics.bulldozer_agg,
				random_tactics = self._random_tactics.bulldozer,
			},
			{
				freq = 0.75,
				rank = 2,
				unit = "fbi_heavy",
				tactics = self._tactics.bulldozer_spt,
			},
			{
				freq = 1,
				freq_by_diff = table_multiplier({
					0,
					diff_scale / 300,
					diff_scale / 150,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				amount_max = 1,
				rank = 1,
				unit = "medic",
				random_unit = self._random_units.heavy_special,
				tactics = self._tactics.bulldozer_spt,
			},
		},
	}

	self.enemy_spawn_groups.fbi_cloaker = {
		amount = { 1, 2 },
		spawn = {
			{
				freq = 1,
				rank = 1,
				unit = "cloaker",
				tactics = self._tactics.cloaker_agg,
				random_tactics = self._random_tactics.cloaker,
			},
		},
	}

	self.enemy_spawn_groups.elite_defend_light = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 0.5,
				amount_max = 2,
				rank = 3,
				unit = "elite_swat_2_3",
				tactics = self._tactics.none,
			},
			{
				freq = 1,
				amount_min = 1,
				rank = 2,
				unit = "elite_swat_1",
				tactics = self._tactics.none,
			},
			self:_distance_weighted_spawn_entry({
				freq = 1,
				freq_by_diff = {
					0,
					diff_scale / 240,
					diff_scale / 120,
				},
				amount_max = 1,
				rank = 1,
				unit = "cloaker",
				tactics = self._tactics.cloaker_spt,
			}, 1000, 3000, 3, 1),
			self:_distance_weighted_spawn_entry({
				freq = 1,
				freq_by_diff = {
					0,
					diff_scale / 360,
					diff_scale / 180,
				},
				amount_max = 1,
				rank = 1,
				unit = "elite_sniper",
				tactics = self._tactics.sniper,
			}, 1000, 3000, 1, 3),
		},
	}

	self.enemy_spawn_groups.elite_defend_heavy = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 0.5,
				amount_max = 2,
				rank = 2,
				unit = "elite_heavy_2",
				tactics = self._tactics.shield_spt,
			},
			{
				freq = 1,
				amount_min = 1,
				rank = 2,
				unit = "elite_heavy_1",
				tactics = self._tactics.shield_spt,
			},
			{
				freq = 1,
				freq_by_diff = table_multiplier({
					20 / diff_scale,
					15 / diff_scale,
					10 / diff_scale,
				}, heavy_response and 0.25 or 1),
				amount_max = 1,
				rank = 1,
				unit = "elite_swat_1_3",
				tactics = self._tactics.shield_spt,
			},
			self:_distance_weighted_spawn_entry({
				freq = 1,
				freq_by_diff = {
					0,
					diff_scale / 240,
					diff_scale / 120,
				},
				amount_max = 1,
				rank = 3,
				unit = "elite_shield",
				tactics = self._tactics.shield,
			}, 1000, 3000, 3, 1),
			self:_distance_weighted_spawn_entry({
				freq = 1,
				freq_by_diff = {
					0,
					diff_scale / 360,
					diff_scale / 180,
				},
				amount_max = 1,
				rank = 1,
				unit = "elite_sniper",
				tactics = self._tactics.sniper,
			}, 1000, 3000, 1, 3),
		},
	}

	self.enemy_spawn_groups.elite_swats = {
		amount = { 3, 4 },
		spawn = {
			{
				freq = 0.5,
				amount_max = 2,
				rank = 2,
				unit = "elite_swat_2",
				tactics = self._tactics.swat_agg,
				random_tactics = self._random_tactics.light_shotgun,
			},
			{
				freq = 0.75,
				amount_max = 2,
				rank = 2,
				unit = "elite_swat_3",
				tactics = self._tactics.swat_snk,
				random_tactics = self._random_tactics.light_smg,
			},
			{
				freq = 1,
				amount_min = 1,
				amount_max = 3,
				rank = 2,
				unit = "elite_swat_1",
				tactics = self._tactics.swat_def,
				random_tactics = self._random_tactics.light_rifle,
			},
			{
				freq = 1,
				freq_by_diff = table_multiplier({
					0,
					diff_scale / 120,
					diff_scale / 60,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				amount_max = 1,
				rank = 1,
				unit = "medic",
				random_unit = self._random_units.light_special,
				tactics = self._tactics.swat_spt,
			},
		},
	}

	self.enemy_spawn_groups.elite_heavies = {
		amount = { 3, 4 },
		spawn = {
			{
				freq = 0.5,
				amount_max = 2,
				rank = 3,
				unit = "elite_heavy_2",
				tactics = self._tactics.swat_agg,
				random_tactics = self._random_tactics.heavy_shotgun,
			},
			{
				freq = 1,
				amount_min = 1,
				amount_max = 3,
				rank = 3,
				unit = "elite_heavy_1",
				tactics = self._tactics.swat_def,
				random_tactics = self._random_tactics.heavy_rifle,
			},
			{
				freq = 1,
				freq_by_diff = table_multiplier({
					20 / diff_scale,
					15 / diff_scale,
					10 / diff_scale,
				}, heavy_response and 0.5 or 1),
				amount_max = 2,
				rank = 2,
				unit = "elite_swat_1_3",
				tactics = self._tactics.swat_spt,
			},
			{
				freq = 1,
				freq_by_diff = table_multiplier({
					0,
					diff_scale / 120,
					diff_scale / 60,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				amount_max = 1,
				rank = 1,
				unit = "medic",
				random_unit = self._random_units.heavy_special,
				tactics = self._tactics.swat_spt,
			},
		},
	}

	self.enemy_spawn_groups.elite_shield = {
		amount = { 4, 4 },
		spawn = {
			{
				freq = (diff_scale / 360) * (heavy_response and 1.25 or small_urban and 0.5 or 1),
				amount_min = 1,
				amount_max = 2,
				rank = 3,
				unit = "elite_shield",
				tactics = self._tactics.shield_agg,
				random_tactics = self._random_tactics.shield,
			},
			{
				freq = 0.75,
				rank = 2,
				unit = "elite_swat",
				tactics = self._tactics.shield_spt,
			},
			{
				freq = 0.75,
				rank = 2,
				unit = "fbi_heavy",
				tactics = self._tactics.shield_spt,
			},
			{
				freq = 1,
				freq_by_diff = table_multiplier({
					0,
					diff_scale / 180,
					diff_scale / 90,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				amount_max = 1,
				rank = 1,
				unit = "medic",
				random_unit = self._random_units.shield_special,
				tactics = self._tactics.shield_spt,
			},
		},
	}

	self.enemy_spawn_groups.elite_taser = {
		amount = { 2, 4 },
		spawn = {
			{
				freq = (diff_scale / 180) * (heavy_response and 1.25 or small_urban and 0.5 or 1),
				amount_min = 1,
				amount_max = 2,
				rank = 3,
				unit = "taser",
				tactics = self._tactics.taser_agg,
				random_tactics = self._random_tactics.taser,
			},
			{
				freq = 0.75,
				rank = 2,
				unit = "elite_swat",
				tactics = self._tactics.taser_spt,
			},
			{
				freq = 1,
				freq_by_diff = table_multiplier({
					0,
					diff_scale / 240,
					diff_scale / 120,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				amount_max = 1,
				rank = 1,
				unit = "cloaker",
				random_unit = self._random_units.light_special,
				tactics = self._tactics.cloaker_spt,
			},
		},
	}

	self.enemy_spawn_groups.elite_bulldozer = {
		amount = { 2, 4 },
		spawn = {
			{
				freq = (diff_scale / 720) * (heavy_response and 1.25 or small_urban and 0.5 or 1),
				amount_min = 1,
				amount_max = 2,
				rank = 3,
				unit = "elite_bulldozer",
				tactics = self._tactics.bulldozer_agg,
				random_tactics = self._random_tactics.bulldozer,
			},
			{
				freq = 0.75,
				rank = 2,
				unit = "fbi_heavy",
				tactics = self._tactics.bulldozer_spt,
			},
			{
				freq = 1,
				freq_by_diff = table_multiplier({
					0,
					diff_scale / 300,
					diff_scale / 150,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				amount_max = 1,
				rank = 1,
				unit = "medic",
				random_unit = self._random_units.heavy_special,
				tactics = self._tactics.bulldozer_spt,
			},
		},
	}

	self.enemy_spawn_groups.elite_bulldozer_shield = {
		amount = { 3, 3 },
		spawn = {
			{
				freq = 1,
				amount_min = 2,
				amount_max = 2,
				rank = 2,
				unit = "fbi_shield",
				tactics = self._tactics.shield,
			},
			{
				freq = 1,
				rank = 1,
				unit = "bulldozer",
				tactics = self._tactics.shield_spt,
			},
			{
				freq = 0.5,
				rank = 1,
				unit = "elite_bulldozer",
				tactics = self._tactics.shield_spt,
			},
		},
	}

	self.enemy_spawn_groups.elite_sniper = {
		amount = { 1, 1 },
		spawn = {
			{
				freq = 1,
				rank = 1,
				unit = "elite_sniper",
				tactics = self._tactics.sniper,
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
				tactics = self._tactics.cloaker_spt,
			},
		},
	}

	local tank_spawn_point_ref = {
		"tac_bull_rush",
		"cs_bulldozer",
		"fbi_bulldozer",
		"elite_bulldozer",
	}

	self.enemy_spawn_groups.snowman_boss = {
		amount = { 1, 1 },
		spawn = {
			{
				freq = 1,
				amount_min = 1,
				rank = 1,
				unit = "snowman_boss",
				tactics = self._tactics.bulldozer_agg,
				random_tactics = self._random_tactics.bulldozer,
			},
		},
		spawn_point_chk_ref = table.list_to_set(tank_spawn_point_ref),
	}

	self.enemy_spawn_groups.piggydozer = {
		amount = { 1, 1 },
		spawn = {
			{
				freq = 1,
				amount_min = 1,
				rank = 1,
				unit = "piggydozer",
				tactics = self._tactics.bulldozer_agg,
				random_tactics = self._random_tactics.bulldozer,
			},
		},
		spawn_point_chk_ref = table.list_to_set(tank_spawn_point_ref),
	}

	for id, data in pairs(self.enemy_spawn_groups) do
		for i, enemy in pairs(data.spawn) do
			local category = self.unit_categories[enemy.unit]
			if not category then
				Eclipse:error_console("Nil unit category " .. tostring(enemy.unit))
			elseif not category.access then
				Eclipse:error_console("Nil access on unit category " .. tostring(enemy.unit))
			end
		end
	end
end)

GroupAITweakData.fbi_heists = {
	["watchdogs_1"] = true,
	["watchdogs_1_night"] = true,
	["watchdogs_2"] = true,
	["watchdogs_2_day"] = true,
	["firestarter_1"] = true,
	["firestarter_2"] = true,
	["firestarter_3"] = true,
	["alex_3"] = true,
	["hox_2"] = true,
	["hox_3"] = true,
	["man"] = true,
}
GroupAITweakData.murky_response_heists = {
	["dinner"] = true,
}
GroupAITweakData.murky_response_heists_scripted = {
	["brb"] = true,
}
GroupAITweakData.us_army_heists = {
	["arm_for"] = true,
	["crojob2"] = true,
	["crojob3"] = true,
	["jolly"] = true,
	["trai"] = true,
}
GroupAITweakData.us_army_heists_scripted = {
	["roberts"] = true,
	["peta2"] = true,
}
GroupAITweakData.gensec_tac_teams_heists = {
	["arm_cro"] = true,
	["arm_par"] = true,
	["arm_hcm"] = true,
	["arm_und"] = true,
	["arm_fac"] = true,
	["dah"] = true,
	["arena"] = true,
}
GroupAITweakData.bellmead_response_heists = {
	["ranc"] = true,
	["corp"] = true,
	["deep"] = true,
}

-- Timed groups tweak table
function GroupAITweakData:_init_enemy_spawn_groups_level(tweak_data, difficulty_index)
	local lvl_tweak = tweak_data.levels[level_id]

	-- This is needed for regional Beat Cops and such
	if lvl_tweak and lvl_tweak.ai_unit_group_overrides then
		local unit_types = nil

		for unit_type, faction_type_data in pairs(lvl_tweak.ai_unit_group_overrides) do
			unit_types = self.unit_categories[unit_type] and self.unit_categories[unit_type].unit_types

			if unit_types then
				for faction_type, override in pairs(faction_type_data) do
					if unit_types[faction_type] then
						unit_types[faction_type] = override
					end
				end
			end
		end
	end

	local swat_spawn_point_ref = {
		"tac_swat_shotgun_rush",
		"tac_swat_shotgun_flank",
		"tac_swat_rifle",
		"tac_swat_rifle_flank",
		"cs_defend_light",
		"cs_defend_heavy",
		"cs_swats",
		"cs_heavies",
		"fbi_defend_light",
		"fbi_defend_heavy",
		"fbi_swats",
		"fbi_heavies",
		"elite_defend_light",
		"elite_defend_heavy",
		"elite_swats",
		"elite_heavies",
	}

	self._timed_tactics = {
		none = {},
		murky_def = {
			"ranged_fire",
		},
		murky_agg = {
			"charge",
			"murder",
		},
		murky_snk = {
			"flank",
			"deathguard",
		},
		fbi_def = {
			"ranged_fire",
			"smoke_grenade",
			"flash_grenade",
		},
		fbi_snk = {
			"rescue",
			"flank",
			"deathguard",
			"flash_grenade",
		},
		army_def = {
			"shield",
			"ranged_fire",
			"flash_grenade",
			"smoke_grenade",
		},
		army_agg = {
			"shield",
			"charge",
			"murder",
			"flash_grenade",
		},
		army_snk = {
			"flank",
			"deathguard",
			"flash_grenade",
			"smoke_grenade",
		},
		army_spt = {
			"shield_cover",
			"ranged_fire",
			"smoke_grenade",
		},
	}

	self._timed_random_tactics = {
		murky_defensive = {
			murky_def = 2,
			murky_snk = 1,
		},
		murky_aggressive = {
			murky_agg = 2,
			murky_snk = 1,
		},
		fbi_readyteam = { "fbi_def", "fbi_snk" },
		army_defensive = {
			army_def = 4,
			army_snk = 2,
			army_agg = 1,
		},
		army_aggressive = {
			army_agg = 2,
			army_snk = 1,
		},
	}

	self.timed_enemy_spawn_groups = {}

	if self.fbi_heists[level_id] then
		self.timed_enemy_spawn_groups.fbi_group1 = Eclipse:require("timed_groups/fbi_group1")(self._timed_tactics, self._timed_random_tactics, swat_spawn_point_ref)
	end

	if self.murky_response_heists[level_id] then
		self.timed_enemy_spawn_groups.murky_group1 = Eclipse:require("timed_groups/murky_group1")(self._timed_tactics, self._timed_random_tactics, swat_spawn_point_ref)
	end

	if self.murky_response_heists_scripted[level_id] then
		self.timed_enemy_spawn_groups.murky_scripted_group1 = Eclipse:require("timed_groups/murky_scripted_group1")(self._timed_tactics, self._timed_random_tactics, swat_spawn_point_ref)
	end

	if self.us_army_heists[level_id] then
		self.timed_enemy_spawn_groups.us_group1 = Eclipse:require("timed_groups/us_group1")(self._timed_tactics, self._timed_random_tactics, difficulty_index, swat_spawn_point_ref)
	end

	if self.bellmead_response_heists[level_id] then
		self.timed_enemy_spawn_groups.bellmead_group1 = Eclipse:require("timed_groups/bellmead_group1")(self._timed_tactics, self._timed_random_tactics, swat_spawn_point_ref)
	end

	if self.us_army_heists_scripted[level_id] then
		self.timed_enemy_spawn_groups.us_scripted_group1 = Eclipse:require("timed_groups/us_scripted_group1")(self._timed_tactics, self._timed_random_tactics, difficulty_index, swat_spawn_point_ref)
	end

	if self.gensec_tac_teams_heists[level_id] then
		self.timed_enemy_spawn_groups.gensec_group1 = Eclipse:require("timed_groups/gensec_group1")(self._timed_tactics, self._timed_random_tactics, swat_spawn_point_ref)
	end
end

function GroupAITweakData:_apply_group_ai_preset(preset)
	local preset_settings = self.group_ai_presets[preset]

	if not preset_settings then
		return
	end

	for _, group_ai_state_name in pairs({ "besiege", "street", "safehouse", "ponr" }) do
		for _, assault_state in pairs(self[group_ai_state_name]) do
			if type(assault_state) == "table" and type(assault_state.groups) == "table" then
				for group_name, group_weights in pairs(assault_state.groups) do
					local mul = preset_settings[group_name]

					if mul then
						table_multiplier(group_weights, mul)

						Eclipse:log_console("Weights for " .. group_name .. " set to: ")
						-- Utils.PrintTable(group_weights)
					end
				end
			end
		end

		Eclipse:log_console("Group AI preset for " .. level_id .. " set to " .. preset)
	end
end

function GroupAITweakData:_apply_group_ai_settings(level_settings)
	local lvl_tweak = self.tweak_data.levels[level_id]

	self.difficulty_curve_points = level_settings.difficulty_curve_points or self.difficulty_curve_points
	self.difficulty_step_time = level_settings.difficulty_step_time or self.difficulty_step_time

	self.spawn_kill_distance = level_settings.spawn_kill_distance or self.spawn_kill_distance

	if level_settings.spawn_kill_distance ~= 1 then
		Eclipse:log_console("Spawn kill distance for " .. level_id .. " set to " .. self.spawn_kill_distance)
	end

	self.spawn_kill_cooldown = level_settings.spawn_kill_cooldown or self.spawn_kill_cooldown

	if level_settings.spawn_kill_cooldown ~= 1 then
		Eclipse:log_console("Spawn kill cooldown for " .. level_id .. " set to " .. self.spawn_kill_cooldown)
	end

	self.min_grenade_timeout = table_multiplier(self.min_grenade_timeout, level_settings.min_grenade_timeout_mul or 1)

	if level_settings.min_grenade_timeout_mul ~= 1 then
		Eclipse:log_console("Min grenade timeout for " .. level_id .. " set to: ")
		-- Utils.PrintTable(self.min_grenade_timeout)
	end

	if level_settings.difficulty_scaling then
		for name, value in pairs(level_settings.difficulty_scaling) do
			if self.difficulty_scaling[name] then
				self.difficulty_scaling[name] = value
			end

			Eclipse:log_console("Difficulty scaling for " .. level_id .. " set to: ")
			-- Utils.PrintTable(self.difficulty_scaling)
		end
	end

	if level_settings.use_equipment_reenforce ~= nil then
		self.use_equipment_reenforce = level_settings.use_equipment_reenforce
	end

	for _, group_ai_state_name in pairs({ "besiege", "street", "safehouse", "ponr", "skirmish" }) do
		local assault_state = self[group_ai_state_name]
		local level_group_ai_state = (lvl_tweak and lvl_tweak.group_ai_state or "besiege") == group_ai_state_name

		if assault_state then
			if assault_state.assault then
				if assault_state.assault.sustain_duration_min then
					assault_state.assault.sustain_duration_min = table_multiplier(assault_state.assault.sustain_duration_min, level_settings.sustain_duration_mul or 1)

					assault_state.assault.sustain_duration_max = assault_state.assault.sustain_duration_min

					if level_group_ai_state and level_settings.sustain_duration_mul ~= 1 then
						Eclipse:log_console("Sustain duration for " .. level_id .. " set to: ")
						-- Utils.PrintTable(assault_state.assault.sustain_duration_min)
					end
				end

				if assault_state.assault.delay then
					assault_state.assault.delay = table_multiplier(assault_state.assault.delay, level_settings.assault_delay_mul or 1)

					if level_group_ai_state and level_settings.assault_delay_mul ~= 1 then
						Eclipse:log_console("Assault delay for " .. level_id .. " set to: ")
						-- Utils.PrintTable(assault_state.assault.delay)
					end
				end

				if assault_state.assault.hostage_hesitation_delay then
					assault_state.assault.hostage_hesitation_delay = table_multiplier(assault_state.assault.hostage_hesitation_delay, level_settings.hostage_hesitation_delay_mul or 1)

					if level_group_ai_state and level_settings.hostage_hesitation_delay_mul ~= 1 then
						Eclipse:log_console("Hostage hesitation delay for " .. level_id .. " set to: ")
						-- Utils.PrintTable(assault_state.assault.hostage_hesitation_delay)
					end
				end

				if assault_state.assault.force then
					assault_state.assault.force = table_multiplier(assault_state.assault.force, level_settings.assault_force_mul or 1)

					if level_group_ai_state and level_settings.assault_force_mul ~= 1 then
						Eclipse:log_console("Assault force for " .. level_id .. " set to: ")
						-- Utils.PrintTable(assault_state.assault.force)
					end
				end

				if assault_state.assault.force_pool then
					assault_state.assault.force_pool = table_multiplier(assault_state.assault.force_pool, level_settings.assault_force_mul or 1)

					if level_group_ai_state and level_settings.assault_force_mul ~= 1 then
						Eclipse:log_console("Assault force for pool " .. level_id .. " set to: ")
						-- Utils.PrintTable(assault_state.assault.force_pool)
					end
				end

				if assault_state.assault.spawnrate then
					assault_state.assault.spawnrate = table_multiplier(assault_state.assault.spawnrate, level_settings.spawnrate_mul or 1)

					if level_group_ai_state and level_settings.spawnrate_mul ~= 1 then
						Eclipse:log_console("Spawnrate for " .. level_id .. " set to: ")
						-- Utils.PrintTable(assault_state.assault.spawnrate)
					end
				end
			end

			if assault_state.recon then
				assault_state.recon.interval_variation = assault_state.recon.interval_variation * (level_settings.recon_interval_variation_mul or 1)

				if level_group_ai_state and level_settings.recon_interval_variation_mul ~= 1 then
					Eclipse:log_console("Recon interval variation for " .. level_id .. " set to " .. assault_state.recon.interval_variation)
				end

				assault_state.recon.force = table_multiplier(assault_state.recon.force, level_settings.recon_force_mul or 1)

				if level_group_ai_state and level_settings.recon_force_mul ~= 1 then
					Eclipse:log_console("Recon force for " .. level_id .. " set to: ")
					-- Utils.PrintTable(assault_state.recon.force)
				end
			end

			if assault_state.reenforce then
				assault_state.reenforce.interval = table_multiplier(assault_state.reenforce.interval, level_settings.reenforce_interval_mul or 1)

				if level_group_ai_state and level_settings.reenforce_interval_mul ~= 1 then
					Eclipse:log_console("Reenforce interval for " .. level_id .. " set to: ")
					-- Utils.PrintTable(assault_state.reenforce.interval)
				end
			end

			if assault_state.cloaker then
				assault_state.cloaker.interval = table_multiplier(assault_state.cloaker.interval, level_settings.cloaker_interval_mul or 1)

				if level_group_ai_state and level_settings.cloaker_interval_mul ~= 1 then
					Eclipse:log_console("Cloaker spawn intervals for " .. level_id .. " set to: ")
					-- Utils.PrintTable(assault_state.cloaker.interval)
				end
			end

			if assault_state.push_delay then
				assault_state.push_delay = table_multiplier(assault_state.push_delay, level_settings.push_delay_mul or 1)

				if level_group_ai_state and level_settings.push_delay_mul ~= 1 then
					Eclipse:log_console("Push delay for " .. level_id .. " set to: ")
					-- Utils.PrintTable(assault_state.push_delay)
				end
			end
		end
	end

	if level_settings.grenade_timeout_mul then
		self.flash_grenade_timeout = table_multiplier(self.flash_grenade_timeout, level_settings.grenade_timeout_mul.flash_grenade or 1)

		if level_settings.grenade_timeout_mul.flash_grenade ~= 1 then
			Eclipse:log_console("Flash grenade timeout for " .. level_id .. " set to: ")
			-- Utils.PrintTable(self.flash_grenade_timeout)
		end

		self.smoke_grenade_timeout = table_multiplier(self.smoke_grenade_timeout, level_settings.grenade_timeout_mul.smoke_grenade or 1)

		if level_settings.grenade_timeout_mul.smoke_grenade ~= 1 then
			Eclipse:log_console("Smoke grenade timeout for " .. level_id .. " set to: ")
			-- Utils.PrintTable(self.smoke_grenade_timeout)
		end

		self.cs_grenade_timeout = table_multiplier(self.cs_grenade_timeout, level_settings.grenade_timeout_mul.cs_grenade or 1)

		if level_settings.grenade_timeout_mul.cs_grenade ~= 1 then
			Eclipse:log_console("CS grenade timeout for " .. level_id .. " set to: ")
			-- Utils.PrintTable(self.cs_grenade_timeout)
		end
	end

	self.cs_grenade_chance_times = table_multiplier(self.cs_grenade_chance_times, level_settings.cs_grenade_chance_times_mul or 1)

	if level_settings.cs_grenade_chance_times_mul ~= 1 then
		Eclipse:log_console("CS grenade chance times for " .. level_id .. " set to: ")
		-- Utils.PrintTable(self.cs_grenade_chance_times)
	end

	if level_settings.force_tactics then
		for name, force_tactics_table in pairs(level_settings.force_tactics) do
			local tactics_table = self._tactics[name]

			if tactics_table then
				for tactic, add in pairs(force_tactics_table) do
					if add and not table.contains(tactics_table, tactic) then
						table.insert(tactics_table, tactic)

						Eclipse:log_console("Added " .. tactic .. " to: " .. name)
					elseif not add and table.contains(tactics_table, tactic) then
						table.delete(tactics_table, tactic)

						Eclipse:log_console("Removed " .. tactic .. " from: " .. name)
					end
				end
			end
		end
	end

	local special_limits = deep_clone(self.special_unit_spawn_limits)
	for special, limit in pairs(special_limits) do
		local add = level_settings.special_limit_add and level_settings.special_limit_add[special] or 0

		if limit < 1 then
			-- Nothing
		else
			limit = math.max(limit + add, 0)
		end

		self.special_unit_spawn_limits[special] = limit

		if add ~= 0 then
			Eclipse:log_console("Special limit for " .. special .. " on " .. level_id .. " set to: " .. self.special_unit_spawn_limits[special])
		end
	end
end

Hooks:PostHook(GroupAITweakData, "_init_task_data", "eclipse__init_task_data", function(self, difficulty_index)
	local below_overkill = difficulty_index < 5

	-- Assault Data
	--In-heist difficulty scaling
	self.difficulty_scaling = {
		diff_init = 0.4,
		diff_min = 0,
		diff_max = 1,
		diff_step = 0.05,
		assault_delay = 45,
		diff_step_interval = 15,
		assault_add = 0.2,
		hostage_add = is_pro_job and 0.1 or nil,
	}

	-- BESIEGE --
	if difficulty_index <= 3 then
		self.besiege.scripted_tiers = {
			"CS",
			"CS",
			"CS",
		}
	elseif difficulty_index == 4 then
		self.besiege.scripted_tiers = {
			"CS",
			"FBI",
			"FBI",
		}
	elseif difficulty_index == 5 then
		self.besiege.scripted_tiers = {
			"CS",
			"FBI",
			"FBI",
		}
	else
		self.besiege.scripted_tiers = {
			"FBI",
			"Elite",
			"Elite",
		}
	end

	-- PHASES --

	-- Sustain
	self.besiege.assault.sustain_duration_min = {
		diff_lerp(60, 120),
		diff_lerp(90, 150),
		diff_lerp(120, 180),
	}
	self.besiege.assault.sustain_duration_max = self.besiege.assault.sustain_duration_min
	self.besiege.assault.sustain_duration_balance_mul = { 1, 1, 1, 1 }

	self.besiege.regroup.duration = { 30, 25, 20 }

	-- Control
	self.besiege.assault.delay = {
		diff_lerp(60, 30),
		diff_lerp(40, 20),
		diff_lerp(30, 15),
	}
	self.besiege.assault.hostage_hesitation_delay = { 10, 7.5, 5 }

	-- SPAWNS --

	-- Spawncap
	self.besiege.assault.force = {
		diff_lerp(3, 6),
		diff_lerp(5, 8),
		diff_lerp(7, 10),
	}

	self.besiege.assault.force_balance_mul = {} -- { 1, 1.25, 1.5, 1.75 }
	for i = 0, 21, 1 do
		table.insert(self.besiege.assault.force_balance_mul, 1 + (i * 0.25))
	end

	self.besiege.assault.force_pool = {
		self.besiege.assault.force[1] * 10,
		self.besiege.assault.force[2] * 10,
		self.besiege.assault.force[3] * 10,
	}
	self.besiege.assault.force_pool_balance_mul = {} -- { 1, 1.25, 1.5, 1.75 }
	for i = 0, 21, 1 do
		table.insert(self.besiege.assault.force_pool_balance_mul, 1 + (i * 0.25))
	end

	-- Spawnrate
	self.spawn_kill_distance = 1500
	self.spawn_kill_cooldown = 10

	self.besiege.assault.spawnrate = {
		diff_lerp(3, 2.5),
		diff_lerp(2.5, 2),
		diff_lerp(2, 1.5),
	}

	self.besiege.assault.spawnrate_balance_mul = {} -- { 1.75, 1.45, 1.2, 1 }
	local spawn_rate_entry
	for i = 0, 21, 1 do
		spawn_rate_entry = 1.75 * math.exp(-i * 0.185)
		spawn_rate_entry = math.round(spawn_rate_entry / 0.025) * 0.025

		table.insert(self.besiege.assault.spawnrate_balance_mul, spawn_rate_entry)
	end

	-- RECON / REENFORCE --

	-- Reenforce spawn interval
	self.besiege.reenforce.interval = { 10, 20, 30 }
	self.undershot_reenforce_mul = 0
	self.use_equipment_reenforce = true
	self.equipment_reenforce = table.list_to_set({
		"doctor_bag",
		"ammo_bag",
		"grenade_case",
	})

	-- Recon spawn interval and spawncap
	self.besiege.recon.interval_variation = 30
	self.besiege.recon.force = {
		diff_lerp(1, 2),
		diff_lerp(2, 3),
		diff_lerp(3, 4),
	}

	self.hostage_push_delay_mul = 1.5
	self.besiege.assault.push_delay = {
		diff_lerp(20, 16),
		diff_lerp(16, 12),
		diff_lerp(12, 8),
	}

	-- GRENADES --
	self.min_grenade_timeout = { 20, 15, 10 }

	self.flash_grenade.light_color = Vector3(255, 255, 255)
	self.flash_grenade.light_range = is_eclipse and 0 or 500
	self.flash_grenade_timeout = { 15, 20 }
	self.flash_grenade.timer = below_overkill and 2.5 or 1.5

	self.smoke_grenade_timeout = { 25, 35 }
	self.smoke_grenade_lifetime = below_overkill and 10 or 15

	self.cs_grenade_timeout = { 60, 90 }
	self.cs_grenade_lifetime = self.smoke_grenade_lifetime * 2
	self.cs_grenade_chance_times = {
		below_overkill and 60 or 45,
		below_overkill and 120 or 90,
	}

	local special_wgt = get_difficulty_specific_value({
		3,
		4,
		6,
		8,
		10,
	})
	local special_wgt_tbl = { special_wgt, special_wgt, special_wgt }
	local shield_wgt = table_multiplier(clone(special_wgt_tbl), below_overkill and { 0.25, 0.75, 1.25 } or { 0.5, 0.875, 1.25 })
	local spook_taser_wgt = table_multiplier(clone(special_wgt_tbl), below_overkill and { 0, 0.5, 1 } or { 0.25, 0.625, 1 })
	local tank_wgt = table_multiplier(clone(special_wgt_tbl), below_overkill and { 0, 0, 0.75 } or { 0, 0.1875, 0.75 })
	local elite_sniper_wgt = table_multiplier(clone(special_wgt_tbl), { 0.375, 0.625, 1 })
	local elite_shield_wgt = table_multiplier(clone(special_wgt_tbl), { 0, 0.25, 0.75 })
	local elite_tank_wgt = table_multiplier(clone(special_wgt_tbl), { 0, 0, 0.5 })

	-- Spawngroups
	if difficulty_index <= 2 then
		self.besiege.assault.groups = {
			cs_cops = { 12, 4, 0 },
			cs_swats = { 20, 20, 20 },
			cs_heavies = { 0, 0, 10 },
			cs_shield = shield_wgt,
		}
		self.besiege.recon.groups = {
			cs_stealth_init = { 3, 2, 1 },
			cs_stealth_light = { 0, 1, 2 },
		}
		self.besiege.reenforce.groups = {
			cs_defend_init = { 3, 1, 0 },
			cs_defend_light = { 0, 2, 4 },
		}
	elseif difficulty_index == 3 then
		self.besiege.assault.groups = {
			cs_cops = { 8, 4, 0 },
			cs_swats = { 24, 24, 24 },
			cs_heavies = { 0, 6, 12 },
			cs_shield = shield_wgt,
			cs_taser = spook_taser_wgt,
			cs_bulldozer = tank_wgt,
		}
		self.besiege.recon.groups = {
			cs_stealth_init = { 5, 3, 1 },
			cs_stealth_light = { 0, 2, 4 },
			cs_stealth_heavy = { 0, 1, 2 },
		}
		self.besiege.reenforce.groups = {
			cs_defend_init = { 6, 2, 0 },
			cs_defend_light = { 3, 4, 6 },
			cs_defend_heavy = { 0, 1, 3 },
		}
	elseif difficulty_index == 4 then
		self.besiege.assault.groups = {
			cs_swats = { 16, 8, 0 },
			fbi_swats = { 16, 20, 24 },
			fbi_heavies = { 0, 6, 12 },
			fbi_shield = shield_wgt,
			fbi_taser = spook_taser_wgt,
			fbi_cloaker = spook_taser_wgt,
			fbi_bulldozer = tank_wgt,
		}
		self.besiege.recon.groups = {
			fbi_stealth_init = { 5, 3, 1 },
			fbi_stealth_light = { 0, 2, 4 },
			fbi_stealth_heavy = { 0, 1, 2 },
		}
		self.besiege.reenforce.groups = {
			cs_defend_init = { 3, 0, 0 },
			cs_defend_light = { 2, 4, 0 },
			cs_defend_heavy = { 1, 2, 0 },
			fbi_defend_init = { 4, 2, 0 },
			fbi_defend_light = { 0, 2, 6 },
			fbi_defend_heavy = { 0, 1, 3 },
		}
	elseif difficulty_index == 5 then
		self.besiege.assault.groups = {
			cs_swats = { 12, 6, 0 },
			fbi_swats = { 20, 20, 20 },
			fbi_heavies = { 0, 8, 16 },
			fbi_shield = shield_wgt,
			fbi_taser = spook_taser_wgt,
			fbi_cloaker = spook_taser_wgt,
			fbi_bulldozer = tank_wgt,
		}
		self.besiege.recon.groups = {
			fbi_stealth_init = { 4, 2, 0 },
			fbi_stealth_light = { 0, 2, 4 },
			fbi_stealth_heavy = { 0, 1, 2 },
		}
		self.besiege.reenforce.groups = {
			cs_defend_init = { 4, 0, 0 },
			cs_defend_light = { 3, 6, 0 },
			cs_defend_heavy = { 2, 4, 0 },
			fbi_defend_init = { 6, 3, 0 },
			fbi_defend_light = { 0, 4, 8 },
			fbi_defend_heavy = { 0, 2, 6 },
		}
	else
		self.besiege.assault.groups = {
			fbi_swats = { 24, 12, 0 },
			elite_swats = { 12, 18, 24 },
			fbi_heavies = { 0, 12, 24 },
			fbi_shield = shield_wgt,
			elite_sniper = elite_sniper_wgt,
			elite_taser = spook_taser_wgt,
			fbi_cloaker = spook_taser_wgt,
			elite_shield = elite_shield_wgt,
			fbi_bulldozer = tank_wgt,
			elite_bulldozer = elite_tank_wgt,
		}
		self.besiege.recon.groups = {
			fbi_stealth_init = { 4, 2, 0 },
			fbi_stealth_light = { 0, 2, 4 },
			fbi_stealth_heavy = { 0, 1, 2 },
		}
		self.besiege.reenforce.groups = {
			cs_defend_init = { 2, 0, 0 },
			cs_defend_light = { 6, 3, 0 },
			cs_defend_heavy = { 4, 2, 0 },
			fbi_defend_init = { 4, 2, 0 },
			fbi_defend_light = { 3, 6, 0 },
			fbi_defend_heavy = { 0, 2, 8 },
			elite_defend_light = { 0, 2, 8 },
		}
	end

	self.besiege.cloaker.groups = {
		single_spooc = { 1, 1, 1 },
	}

	-- New data for the reworked Cloaker task
	self.use_reworked_cloaker_task = true
	self.besiege.cloaker.interval = {
		diff_lerp(60, 20),
		diff_lerp(120, 40),
	}
	self.besiege.cloaker.group_removed_delay_t = {
		2,
		7,
	}
	self.besiege.cloaker.hide_durations = {
		120,
		180,
	}
	self.besiege.cloaker.hide_retry_delay = {
		10,
		20,
	}
	self.besiege.cloaker.avoid_repeat_hiding_spots = true
	self.besiege.cloaker.avoid_repeat_hiding_spots_min_elements = 2
	self.besiege.cloaker.simultaneous_hiding_limit = 1
	self.besiege.cloaker.goggles_on_when_hiding = false
	self.besiege.cloaker.use_spawn_noise = true
	self.besiege.cloaker.use_idle_noise_when_hiding = true
	self.besiege.cloaker.whistle_on_leave_hiding = false -- Has whistle chatter now
	self.besiege.cloaker.max_rehide_attempts = {
		0,
		3,
	}
	self.besiege.cloaker.no_join_groups = table.list_to_set({
		-- CS-tier (allergic to navy blue uniforms)
		-- Will always retire after rehides expire on Normal difficulty
		"cs_defend_init",
		"cs_defend_light",
		"cs_defend_heavy",
		"cs_stealth_init",
		"cs_stealth_light",
		"cs_stealth_heavy",
		"cs_cops",
		"cs_swats",
		"cs_heavies",
		"cs_shield",
		"cs_taser",
		"cs_bulldozer",

		-- Other hiding Cloakers
		"single_spooc",

		-- Event bosses
		"snowman_boss",
		"piggydozer",

		-- Good game design
		"Phalanx",
		"marshal_squad",

		-- Scripted spawns
		"custom_assault",
		"custom_recon",

		-- Timed groups
		"bellmead_group1",
		"fbi_group1",
		"gensec_group1",
		"murky_group1",
		"murky_scripted_group1",
		"us_group1",
		"us_scripted_group1",
	})
	self.besiege.recurring_group_SO.recurring_cloaker_spawn.interval = clone(self.besiege.cloaker.interval)

	self.besiege.assault.groups.single_spooc = { 0, 0, 0 }
	self.besiege.assault.groups.Phalanx = { 0, 0, 0 }
	self.besiege.assault.groups.marshal_squad = { 0, 0, 0 }
	self.besiege.assault.groups.custom_assault = { 0, 0, 0 }
	self.besiege.assault.groups.snowman_boss = { 0, 0, 0 }
	self.besiege.assault.groups.piggydozer = { 0, 0, 0 }
	-- timed groups
	self.besiege.assault.groups.bellmead_group1 = { 0, 0, 0 }
	self.besiege.assault.groups.fbi_group1 = { 0, 0, 0 }
	self.besiege.assault.groups.gensec_group1 = { 0, 0, 0 }
	self.besiege.assault.groups.murky_group1 = { 0, 0, 0 }
	self.besiege.assault.groups.murky_scripted_group1 = { 0, 0, 0 }
	self.besiege.assault.groups.us_group1 = { 0, 0, 0 }
	self.besiege.assault.groups.us_scripted_group1 = { 0, 0, 0 }

	self.besiege.recon.groups.single_spooc = { 0, 0, 0 }
	self.besiege.recon.groups.Phalanx = { 0, 0, 0 }
	self.besiege.recon.groups.marshal_squad = { 0, 0, 0 }
	self.besiege.recon.groups.custom_recon = { 0, 0, 0 }
	self.besiege.recon.groups.snowman_boss = { 0, 0, 0 }
	self.besiege.recon.groups.piggydozer = { 0, 0, 0 }
	-- timed groups
	self.besiege.recon.groups.bellmead_group1 = { 0, 0, 0 }
	self.besiege.recon.groups.fbi_group1 = { 0, 0, 0 }
	self.besiege.recon.groups.gensec_group1 = { 0, 0, 0 }
	self.besiege.recon.groups.murky_group1 = { 0, 0, 0 }
	self.besiege.recon.groups.murky_scripted_group1 = { 0, 0, 0 }
	self.besiege.recon.groups.us_group1 = { 0, 0, 0 }
	self.besiege.recon.groups.us_scripted_group1 = { 0, 0, 0 }

	-- PONR --
	self.ponr = deep_clone(self.besiege)

	-- Control
	self.ponr.assault.force = {
		diff_lerp(8, 12),
		diff_lerp(8, 12),
		diff_lerp(8, 12),
	}

	if short_ponr_heists[level_id] then
		self.ponr.assault.delay = { 5, 5, 5 }
		self.ponr.assault.hostage_hesitation_delay = { 0, 0, 0 }
	end

	-- Recon
	self.ponr.recon.force = { 0, 0, 0 } -- no recon after ponr ran out

	if difficulty_index < 4 then
		self.ponr.scripted_tiers = {
			"FBI",
			"FBI",
			"FBI",
		}
	else
		self.ponr.scripted_tiers = {
			"Elite",
			"Elite",
			"Elite",
		}
	end

	local ponr_special_wgt = get_difficulty_specific_value({
		3,
		4,
		5,
		6,
		8,
	})
	local ponr_special_wgt_tbl = { ponr_special_wgt, ponr_special_wgt, ponr_special_wgt }
	local ponr_shield_wgt = table_multiplier(clone(ponr_special_wgt_tbl), 1.25)
	local ponr_spook_taser_wgt = table_multiplier(clone(ponr_special_wgt_tbl), 1)
	local ponr_tank_wgt = table_multiplier(clone(ponr_special_wgt_tbl), 0.75)
	local ponr_elite_shield_wgt = table_multiplier(clone(ponr_special_wgt_tbl), 0.875)
	local ponr_elite_tank_wgt = table_multiplier(clone(ponr_special_wgt_tbl), 0.5)

	-- Spawngroups
	if difficulty_index <= 2 then
		self.ponr.assault.groups = {
			fbi_swats = { 14, 14, 14 },
			fbi_heavies = { 14, 14, 14 },
			fbi_shield = ponr_shield_wgt,
			fbi_taser = ponr_spook_taser_wgt,
			fbi_cloaker = ponr_spook_taser_wgt,
			fbi_bulldozer = ponr_tank_wgt,
		}
		self.ponr.reenforce.groups = {
			fbi_defend_light = { 1, 1, 1 },
			fbi_defend_heavy = { 1, 1, 1 },
		}
	elseif difficulty_index == 3 then
		self.ponr.assault.groups = {
			fbi_swats = { 14, 14, 14 },
			fbi_heavies = { 14, 14, 14 },
			fbi_shield = ponr_shield_wgt,
			fbi_taser = ponr_spook_taser_wgt,
			fbi_cloaker = ponr_spook_taser_wgt,
			fbi_bulldozer = ponr_tank_wgt,
		}
		self.ponr.reenforce.groups = {
			fbi_defend_light = { 1, 1, 1 },
			fbi_defend_heavy = { 1, 1, 1 },
		}
	elseif difficulty_index == 4 then
		self.ponr.assault.groups = {
			elite_swats = { 14, 14, 14 },
			fbi_heavies = { 14, 14, 14 },
			fbi_shield = ponr_shield_wgt,
			elite_shield = ponr_elite_shield_wgt,
			elite_sniper = ponr_spook_taser_wgt,
			elite_taser = ponr_spook_taser_wgt,
			fbi_cloaker = ponr_spook_taser_wgt,
			fbi_bulldozer = ponr_tank_wgt,
			elite_bulldozer = ponr_elite_tank_wgt,
		}
		self.ponr.reenforce.groups = {
			elite_defend_light = { 1, 1, 1 },
			fbi_defend_heavy = { 1, 1, 1 },
		}
	elseif difficulty_index == 5 then
		self.ponr.assault.groups = {
			elite_swats = { 14, 14, 14 },
			fbi_heavies = { 14, 14, 14 },
			fbi_shield = ponr_shield_wgt,
			elite_shield = ponr_elite_shield_wgt,
			elite_sniper = ponr_spook_taser_wgt,
			elite_taser = ponr_spook_taser_wgt,
			fbi_cloaker = ponr_spook_taser_wgt,
			fbi_bulldozer = ponr_tank_wgt,
			elite_bulldozer = ponr_elite_tank_wgt,
		}
		self.ponr.reenforce.groups = {
			elite_defend_light = { 1, 1, 1 },
			fbi_defend_heavy = { 1, 1, 1 },
		}
	else
		self.ponr.assault.groups = {
			elite_swats = { 10, 10, 10 },
			elite_heavies = { 18, 18, 18 },
			elite_shield = ponr_shield_wgt,
			elite_sniper = ponr_spook_taser_wgt,
			elite_taser = ponr_spook_taser_wgt,
			fbi_cloaker = ponr_spook_taser_wgt,
			elite_bulldozer = ponr_tank_wgt,
		}
		self.ponr.reenforce.groups = {
			elite_defend_light = { 1, 1, 1 },
			elite_defend_heavy = { 1, 1, 1 },
		}
	end

	self.ponr.cloaker.groups = {
		single_spooc = { 1, 1, 1 },
	}

	self.ponr.assault.groups.single_spooc = { 0, 0, 0 }
	self.ponr.assault.groups.Phalanx = { 0, 0, 0 }
	self.ponr.assault.groups.marshal_squad = { 0, 0, 0 }
	self.ponr.assault.groups.custom_assault = { 0, 0, 0 }
	self.ponr.assault.groups.snowman_boss = { 0, 0, 0 }
	self.ponr.assault.groups.piggydozer = { 0, 0, 0 }
	-- timed groups
	self.ponr.assault.groups.fbi_group1 = { 0, 0, 0 }
	self.ponr.assault.groups.murky_group1 = { 0, 0, 0 }
	self.ponr.assault.groups.murky_scripted_group1 = { 0, 0, 0 }
	self.ponr.assault.groups.us_group1 = { 0, 0, 0 }
	self.ponr.assault.groups.us_scripted_group1 = { 0, 0, 0 }
	self.ponr.assault.groups.bellmead_group1 = { 0, 0, 0 }

	self.ponr.recon.groups.single_spooc = { 0, 0, 0 }
	self.ponr.recon.groups.Phalanx = { 0, 0, 0 }
	self.ponr.recon.groups.marshal_squad = { 0, 0, 0 }
	self.ponr.recon.groups.custom_recon = { 0, 0, 0 }
	self.ponr.recon.groups.snowman_boss = { 0, 0, 0 }
	self.ponr.recon.groups.piggydozer = { 0, 0, 0 }
	-- timed groups
	self.ponr.recon.groups.fbi_group1 = { 0, 0, 0 }
	self.ponr.recon.groups.murky_group1 = { 0, 0, 0 }
	self.ponr.recon.groups.murky_scripted_group1 = { 0, 0, 0 }
	self.ponr.recon.groups.us_group1 = { 0, 0, 0 }
	self.ponr.recon.groups.us_scripted_group1 = { 0, 0, 0 }
	self.ponr.recon.groups.bellmead_group1 = { 0, 0, 0 }

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

	if self._mission_preset then
		self:_apply_group_ai_preset(self._mission_preset)
	end

	if self._mission_settings then
		self:_apply_group_ai_settings(self._mission_settings)
	end
end)
