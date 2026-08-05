local short_ponr_heists = Eclipse:require("short_ponr_heists")
local level_id = Eclipse.utils.clean_level_id()
local diff_i = Eclipse.utils.difficulty_index()
local is_overkill = Eclipse.utils.is_overkill()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local group_ai_state_names = Eclipse.utils.get_group_ai_state_names()
local table_multiply = Eclipse.utils.table_multiply
local get_difficulty_specific_value = Eclipse.utils.get_difficulty_specific_value
local calc_team_ai_wgt = Eclipse.utils.calculate_team_ai_weight
local access_table = Eclipse.utils.access_table
local generate_big_lobby_balance_muls = Eclipse.utils.generate_big_lobby_balance_muls

GroupAITweakData.group_ai_presets = {
	["small_urban"] = {
		cs_defend_init = 1.5,
		fbi_defend_init = 1.5,

		cs_defend_light = { 0.5, 0.75, 1 },
		fbi_defend_light = { 0.5, 0.75, 1 },
		elite_defend_light = { 0.5, 0.75, 1 },

		cs_defend_heavy = { 0.25, 0.5, 0.75 },
		fbi_defend_heavy = { 0.25, 0.5, 0.75 },
		elite_defend_heavy = { 0.25, 0.5, 0.75 },

		cs_stealth_init = 1.5,
		fbi_stealth_init = 1.5,
	},
	["heavy_response"] = {
		cs_defend_init = 0.5,
		fbi_defend_init = 0.5,

		cs_defend_heavy = 1.25,
		fbi_defend_heavy = 1.25,
		elite_defend_heavy = 1.25,

		cs_stealth_init = 1.5,
		fbi_stealth_init = 1.5,
	},
	["remote"] = {
		cs_defend_init = 0.5,
		fbi_defend_init = 0.5,

		cs_stealth_init = 1.5,
		fbi_stealth_init = 1.5,
	},
}
GroupAITweakData.force_size_presets = {
	["reduced_t3"] = {
		assault = 0.55,
		recon = 0.7,
	},
	["reduced_t2"] = {
		assault = 0.7,
		recon = 0.85,
	},
	["reduced_t1"] = {
		assault = 0.85,
		recon = 1,
	},
	["increased_t1"] = {
		assault = 1.15,
		recon = 1.15,
	},
	["increased_t2"] = {
		assault = 1.3,
		recon = 1.3,
	},
	["increased_t3"] = {
		assault = 1.45,
		recon = 1.45,
	},
}
GroupAITweakData.difficulty_scaling_presets = {
	-- Fast response, scales to max quite quickly
	["timed_slow"] = {
		addends = {
			on_enemy_weapons_hot = {
				amount = 1,
				delay = 15,
				time = { 150, 210 },
			},
		},
	},
	["timed"] = {
		addends = {
			on_enemy_weapons_hot = {
				amount = 1,
				delay = 15,
				time = { 120, 180 },
			},
		},
	},
	["timed_fast"] = {
		addends = {
			on_enemy_weapons_hot = {
				amount = 1,
				delay = 15,
				time = { 90, 150 },
			},
		},
	},
	-- Reaches max on assault #4's regroup (if on_enemy_weapons_hot is 0.25)
	["regroup_slow"] = {
		addends = {
			on_entered_regroup = {
				amount = 0.25,
				delay = 0,
				time = 60,
			},
		},
	},
	-- Starts high, reaches max on assault #3's regroup
	["regroup_aggressive"] = {
		addends = {
			on_enemy_weapons_hot = {
				amount = 0.5,
				delay = 45,
				time = 120,
			},
			on_entered_regroup = {
				amount = 0.25,
				delay = 0,
				time = 60,
			},
		},
	},
	-- Randomized sustain addend meant to be used for levels with primarily scripted difficulty curves
	["regroup_random"] = {
		addends = {
			on_entered_regroup = {
				amount = { 0.125, 0.1875 },
				delay = 0,
				time = 45,
			},
		},
	},
	-- Reaches max on assault #3's sustain (if on_enemy_weapons_hot is 0.25, on_entered_sustain is 0.375)
	["sustain"] = {
		allowed_addends = {
			on_entered_regroup = false,
			on_entered_sustain = true,
		},
	},
	-- Reaches max on assault #4's sustain (if on_enemy_weapons_hot is 0.25)
	["sustain_slow"] = {
		addends = {
			on_entered_sustain = {
				amount = 0.25,
				delay = 0,
				time = 60,
			},
		},
		allowed_addends = {
			on_entered_regroup = false,
			on_entered_sustain = true,
		},
	},
	-- Starts high, reaches max on assault #3's sustain
	["sustain_aggressive"] = {
		addends = {
			on_enemy_weapons_hot = {
				amount = 0.5,
				delay = 45,
				time = 120,
			},
			on_entered_sustain = {
				amount = 0.25,
				delay = 0,
				time = 60,
			},
		},
		allowed_addends = {
			on_entered_regroup = false,
			on_entered_sustain = true,
		},
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

	local entry_freq, entry_freq_by_diff = spawn_entry.freq, spawn_entry.freq_by_diff
	spawn_entry.freq, spawn_entry.freq_by_diff = nil
	return setmetatable(spawn_entry, {
		__index = function(t, k)
			if k == "freq_by_diff" then -- edit here
				if entry_freq_by_diff then
					local new_freq = {}
					local d_freq = dis_freq()
					for i, weight in pairs(entry_freq_by_diff) do
						new_freq[i] = weight * d_freq
					end
					return new_freq
				end
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

	self.ai_tick_rate = 1 / 60

	if level_id then
		self._groupai_settings = Eclipse:require("groupai_settings/" .. level_id)
	end

	self:_apply_group_ai_settings_new(self._groupai_settings)
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
		chatter.group_min = 0
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
	self.enemy_chatter.detect = clone(self.enemy_chatter.contact)
	self.enemy_chatter.detect.queue = "a01"
	self.enemy_chatter.detect.radius = radius_small
	self.enemy_chatter.detect.duration = duration_short
	self.enemy_chatter.ready.queue = nil -- Random chance for pos to be used instead of rdy
	setmetatable(self.enemy_chatter.ready, {
		__index = function(t, k)
			return k == "queue" and (math.random() < 0.5 and "rdy" or "pos") or nil
		end,
	})
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
	self.enemy_chatter.idle.interval = { 5, 10 }
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
			taser = 1,
			tank = 0,
			spooc = 0,
			medic = 0,
			marksman = 0,
		}
		self.ponr_state_special_limit_add = {
			shield = 0,
			taser = 0,
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
	self.special_unit_spawn_limits_balance_mul = generate_big_lobby_balance_muls({
		{ 1, 1 },
		{ 1, 4 },
		{ 1.25, 10 },
		{ 1.5, 16 },
		{ 1.75, 22 },
	}, 0.025)

	self.unit_categories.cs_cop_1 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_cop_1/ene_cop_1") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_c45/ene_akan_cs_cop_c45") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_1/ene_cop_hvh_1") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_cop_1/ene_murkywater_cop_1") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_policia_01/ene_policia_01") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.cs_cop_2 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_cop_2/ene_cop_2") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_raging_bull/ene_akan_cs_cop_raging_bull") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_2/ene_cop_hvh_2") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_cop_2/ene_murkywater_cop_2") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_policia_02/ene_policia_02") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.cs_cop_3 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_cop_3/ene_cop_3") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_akmsu_smg/ene_akan_cs_cop_akmsu_smg") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_3/ene_cop_hvh_3") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_cop_3/ene_murkywater_cop_3") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_policia_03/ene_policia_03") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.cs_cop_4 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_cop_4/ene_cop_4") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_r870/ene_akan_cs_cop_r870") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_4/ene_cop_hvh_4") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_cop_4/ene_murkywater_cop_4") },
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
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_c45/ene_akan_cs_cop_c45"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_raging_bull/ene_akan_cs_cop_raging_bull"),
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_1/ene_cop_hvh_1"),
				Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_2/ene_cop_hvh_2"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_cop_1/ene_murkywater_cop_1"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_cop_2/ene_murkywater_cop_2"),
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
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_c45/ene_akan_cs_cop_c45"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_r870/ene_akan_cs_cop_r870"),
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_1/ene_cop_hvh_1"),
				Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_4/ene_cop_hvh_4"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_cop_1/ene_murkywater_cop_1"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_cop_4/ene_murkywater_cop_4"),
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
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_raging_bull/ene_akan_cs_cop_raging_bull"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_akmsu_smg/ene_akan_cs_cop_akmsu_smg"),
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_2/ene_cop_hvh_2"),
				Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_3/ene_cop_hvh_3"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_cop_2/ene_murkywater_cop_2"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_cop_3/ene_murkywater_cop_3"),
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
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_akmsu_smg/ene_akan_cs_cop_akmsu_smg"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_r870/ene_akan_cs_cop_r870"),
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_3/ene_cop_hvh_3"),
				Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_4/ene_cop_hvh_4"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_cop_3/ene_murkywater_cop_3"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_cop_4/ene_murkywater_cop_4"),
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
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_c45/ene_akan_cs_cop_c45"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_raging_bull/ene_akan_cs_cop_raging_bull"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_akmsu_smg/ene_akan_cs_cop_akmsu_smg"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_r870/ene_akan_cs_cop_r870"),
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_1/ene_cop_hvh_1"),
				Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_2/ene_cop_hvh_2"),
				Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_3/ene_cop_hvh_3"),
				Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_4/ene_cop_hvh_4"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_cop_1/ene_murkywater_cop_1"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_cop_2/ene_murkywater_cop_2"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_cop_3/ene_murkywater_cop_3"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_cop_4/ene_murkywater_cop_4"),
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
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_swat_ak47_ass/ene_akan_cs_swat_ak47_ass") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_1/ene_swat_hvh_1") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light/ene_murkywater_light") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale/ene_swat_policia_federale") },
		},
		access = access_type_all,
	}

	self.unit_categories.cs_swat_2 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_swat_2/ene_swat_2") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_swat_r870/ene_akan_cs_swat_r870") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_2/ene_swat_hvh_2") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_r870/ene_murkywater_light_r870") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_r870/ene_swat_policia_federale_r870") },
		},
		access = access_type_all,
	}

	self.unit_categories.cs_swat_3 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_swat_3/ene_swat_3") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_swat_akmsu_smg/ene_akan_cs_swat_akmsu_smg") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_3/ene_swat_hvh_3") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_mp5/ene_murkywater_light_mp5") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_mp5/ene_swat_policia_federale_mp5") },
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
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_swat_ak47_ass/ene_akan_cs_swat_ak47_ass"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_swat_akmsu_smg/ene_akan_cs_swat_akmsu_smg"),
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_1/ene_swat_hvh_1"),
				Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_3/ene_swat_hvh_3"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light/ene_murkywater_light"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_mp5/ene_murkywater_light_mp5"),
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale/ene_swat_policia_federale"),
				Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_mp5/ene_swat_policia_federale_mp5"),
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
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_swat_r870/ene_akan_cs_swat_r870"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_swat_akmsu_smg/ene_akan_cs_swat_akmsu_smg"),
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_2/ene_swat_hvh_2"),
				Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_3/ene_swat_hvh_3"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_r870/ene_murkywater_light_r870"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_mp5/ene_murkywater_light_mp5"),
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_r870/ene_swat_policia_federale_r870"),
				Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_mp5/ene_swat_policia_federale_mp5"),
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
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_swat_ak47_ass/ene_akan_cs_swat_ak47_ass"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_swat_r870/ene_akan_cs_swat_r870"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_swat_akmsu_smg/ene_akan_cs_swat_akmsu_smg"),
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_1/ene_swat_hvh_1"),
				Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_2/ene_swat_hvh_2"),
				Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_3/ene_swat_hvh_3"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light/ene_murkywater_light"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_r870/ene_murkywater_light_r870"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_mp5/ene_murkywater_light_mp5"),
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale/ene_swat_policia_federale"),
				Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_r870/ene_swat_policia_federale_r870"),
				Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_mp5/ene_swat_policia_federale_mp5"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.cs_heavy_1 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_heavy_ak47_ass/ene_akan_cs_heavy_ak47_ass") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_1/ene_swat_heavy_hvh_1") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy/ene_murkywater_heavy") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale/ene_swat_heavy_policia_federale") },
		},
		access = access_type_all,
	}

	self.unit_categories.cs_heavy_2 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_heavy_r870/ene_akan_cs_heavy_r870") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_r870/ene_swat_heavy_hvh_r870") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy_shotgun/ene_murkywater_heavy_shotgun") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_r870/ene_swat_heavy_policia_federale_r870") },
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
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_heavy_ak47_ass/ene_akan_cs_heavy_ak47_ass"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_heavy_r870/ene_akan_cs_heavy_r870"),
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_1/ene_swat_heavy_hvh_1"),
				Idstring("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_r870/ene_swat_heavy_hvh_r870"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy/ene_murkywater_heavy"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy_shotgun/ene_murkywater_heavy_shotgun"),
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale/ene_swat_heavy_policia_federale"),
				Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_r870/ene_swat_heavy_policia_federale_r870"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.cs_shield = {
		special_type = "shield",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_shield_2/ene_shield_2") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_shield_c45/ene_akan_cs_shield_c45") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_shield_hvh_2/ene_shield_hvh_2") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_shield/ene_murkywater_shield") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_c45/ene_swat_shield_policia_federale_c45") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.fbi_agent_1 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_agent_c45/ene_akan_fbi_agent_c45") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_fbi_hvh_1/ene_fbi_hvh_1") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_agent_1/ene_murkywater_agent_1") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_policia_agent_01/ene_policia_agent_01") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.fbi_agent_2 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_agent_ak47_ass/ene_akan_fbi_agent_ak47_ass") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_fbi_hvh_2/ene_fbi_hvh_2") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_agent_2/ene_murkywater_agent_2") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_policia_agent_02/ene_policia_agent_02") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.fbi_agent_3 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_agent_akmsu_smg/ene_akan_fbi_agent_akmsu_smg") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_fbi_hvh_3/ene_fbi_hvh_3") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_agent_3/ene_murkywater_agent_3") },
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
				Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_agent_c45/ene_akan_fbi_agent_c45"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_agent_ak47_ass/ene_akan_fbi_agent_ak47_ass"),
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_fbi_hvh_1/ene_fbi_hvh_1"),
				Idstring("units/pd2_dlc_hvh/characters/ene_fbi_hvh_2/ene_fbi_hvh_2"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_agent_1/ene_murkywater_agent_1"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_agent_2/ene_murkywater_agent_2"),
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
				Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_agent_ak47_ass/ene_akan_fbi_agent_ak47_ass"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_agent_akmsu_smg/ene_akan_fbi_agent_akmsu_smg"),
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_fbi_hvh_2/ene_fbi_hvh_2"),
				Idstring("units/pd2_dlc_hvh/characters/ene_fbi_hvh_3/ene_fbi_hvh_3"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_agent_2/ene_murkywater_agent_2"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_agent_3/ene_murkywater_agent_3"),
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
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_ak47_ass/ene_akan_fbi_swat_ak47_ass") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_1/ene_fbi_swat_hvh_1") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi/ene_murkywater_light_fbi") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi/ene_swat_policia_federale_fbi") },
		},
		access = access_type_all,
	}

	self.unit_categories.fbi_swat_2 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_r870/ene_akan_fbi_swat_r870") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_2/ene_fbi_swat_hvh_2") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi_r870/ene_murkywater_light_fbi_r870") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_r870/ene_swat_policia_federale_fbi_r870") },
		},
		access = access_type_all,
	}

	self.unit_categories.fbi_swat_3 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_akmsu_smg/ene_akan_fbi_swat_akmsu_smg") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_3/ene_fbi_swat_hvh_3") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi_mp5/ene_murkywater_light_fbi_mp5") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_mp5/ene_swat_policia_federale_fbi_mp5") },
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
				Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_ak47_ass/ene_akan_fbi_swat_ak47_ass"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_akmsu_smg/ene_akan_fbi_swat_akmsu_smg"),
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_1/ene_fbi_swat_hvh_1"),
				Idstring("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_3/ene_fbi_swat_hvh_3"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi/ene_murkywater_light_fbi"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi_mp5/ene_murkywater_light_fbi_mp5"),
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi/ene_swat_policia_federale_fbi"),
				Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_mp5/ene_swat_policia_federale_fbi_mp5"),
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
				Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_r870/ene_akan_fbi_swat_r870"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_akmsu_smg/ene_akan_fbi_swat_akmsu_smg"),
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_2/ene_fbi_swat_hvh_2"),
				Idstring("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_3/ene_fbi_swat_hvh_3"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi_r870/ene_murkywater_light_fbi_r870"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi_mp5/ene_murkywater_light_fbi_mp5"),
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_r870/ene_swat_policia_federale_fbi_r870"),
				Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_mp5/ene_swat_policia_federale_fbi_mp5"),
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
				Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_ak47_ass/ene_akan_fbi_swat_ak47_ass"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_r870/ene_akan_fbi_swat_r870"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_akmsu_smg/ene_akan_fbi_swat_akmsu_smg"),
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_1/ene_fbi_swat_hvh_1"),
				Idstring("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_2/ene_fbi_swat_hvh_2"),
				Idstring("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_3/ene_fbi_swat_hvh_3"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi/ene_murkywater_light_fbi"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi_r870/ene_murkywater_light_fbi_r870"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi_mp5/ene_murkywater_light_fbi_mp5"),
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi/ene_swat_policia_federale_fbi"),
				Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_r870/ene_swat_policia_federale_fbi_r870"),
				Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_mp5/ene_swat_policia_federale_fbi_mp5"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.fbi_heavy_1 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_1/ene_fbi_heavy_hvh_1") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy_fbi/ene_murkywater_heavy_fbi") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi/ene_swat_heavy_policia_federale_fbi") },
		},
		access = access_type_all,
	}

	self.unit_categories.fbi_heavy_2 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_r870/ene_akan_fbi_heavy_r870") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_r870/ene_fbi_heavy_hvh_r870") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy_fbi_r870/ene_murkywater_heavy_fbi_r870") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_r870/ene_swat_heavy_policia_federale_fbi_r870") },
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
				Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_r870/ene_akan_fbi_heavy_r870"),
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_1/ene_fbi_heavy_hvh_1"),
				Idstring("units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_r870/ene_fbi_heavy_hvh_r870"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy_fbi/ene_murkywater_heavy_fbi"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy_fbi_r870/ene_murkywater_heavy_fbi_r870"),
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi/ene_swat_heavy_policia_federale_fbi"),
				Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_r870/ene_swat_heavy_policia_federale_fbi_r870"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.fbi_shield = {
		special_type = "shield",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_shield_1/ene_shield_1") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_shield_sr2_smg/ene_akan_fbi_shield_sr2_smg") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_shield_hvh_1/ene_shield_hvh_1") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_shield_fbi/ene_murkywater_shield_fbi") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_mp9/ene_swat_shield_policia_federale_mp9") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.elite_swat_1 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_city_swat_ak47_ass/ene_akan_city_swat_ak47_ass") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_city_swat_hvh_1/ene_city_swat_hvh_1") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_city/ene_murkywater_light_city") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city/ene_swat_policia_federale_city") },
		},
		access = access_type_all,
	}

	self.unit_categories.elite_swat_2 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_city_swat_r870/ene_akan_city_swat_r870") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_city_swat_hvh_2/ene_city_swat_hvh_2") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_city_r870/ene_murkywater_light_city_r870") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_r870/ene_swat_policia_federale_city_r870") },
		},
		access = access_type_all,
	}

	self.unit_categories.elite_swat_3 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_city_swat_akmsu_smg/ene_akan_city_swat_akmsu_smg") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_city_swat_hvh_3/ene_city_swat_hvh_3") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_city_mp5/ene_murkywater_light_city_mp5") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_mp5/ene_swat_policia_federale_city_mp5") },
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
				Idstring("units/pd2_dlc_mad/characters/ene_akan_city_swat_ak47_ass/ene_akan_city_swat_ak47_ass"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_city_swat_akmsu_smg/ene_akan_city_swat_akmsu_smg"),
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_city_swat_hvh_1/ene_city_swat_hvh_1"),
				Idstring("units/pd2_dlc_hvh/characters/ene_city_swat_hvh_3/ene_city_swat_hvh_3"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_city/ene_murkywater_light_city"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_city_mp5/ene_murkywater_light_city_mp5"),
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city/ene_swat_policia_federale_city"),
				Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_mp5/ene_swat_policia_federale_city_mp5"),
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
				Idstring("units/pd2_dlc_mad/characters/ene_akan_city_swat_r870/ene_akan_city_swat_r870"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_city_swat_akmsu_smg/ene_akan_city_swat_akmsu_smg"),
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_city_swat_hvh_2/ene_city_swat_hvh_2"),
				Idstring("units/pd2_dlc_hvh/characters/ene_city_swat_hvh_3/ene_city_swat_hvh_3"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_city_r870/ene_murkywater_light_city_r870"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_city_mp5/ene_murkywater_light_city_mp5"),
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_r870/ene_swat_policia_federale_city_r870"),
				Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_mp5/ene_swat_policia_federale_city_mp5"),
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
				Idstring("units/pd2_dlc_mad/characters/ene_akan_city_swat_ak47_ass/ene_akan_city_swat_ak47_ass"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_city_swat_r870/ene_akan_city_swat_r870"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_city_swat_akmsu_smg/ene_akan_city_swat_akmsu_smg"),
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_city_swat_hvh_1/ene_city_swat_hvh_1"),
				Idstring("units/pd2_dlc_hvh/characters/ene_city_swat_hvh_2/ene_city_swat_hvh_2"),
				Idstring("units/pd2_dlc_hvh/characters/ene_city_swat_hvh_3/ene_city_swat_hvh_3"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_city/ene_murkywater_light_city"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_city_r870/ene_murkywater_light_city_r870"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_city_mp5/ene_murkywater_light_city_mp5"),
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city/ene_swat_policia_federale_city"),
				Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_r870/ene_swat_policia_federale_city_r870"),
				Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_mp5/ene_swat_policia_federale_city_mp5"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.elite_heavy_1 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_city_heavy_g36/ene_akan_city_heavy_g36") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_city_heavy_hvh_1/ene_city_heavy_hvh_1") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy_city/ene_murkywater_heavy_city") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_city/ene_swat_heavy_policia_federale_city") },
		},
		access = access_type_all,
	}

	self.unit_categories.elite_heavy_2 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_city_heavy_r870/ene_akan_city_heavy_r870") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_city_heavy_hvh_r870/ene_city_heavy_hvh_r870") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy_city_r870/ene_murkywater_heavy_city_r870") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_city_r870/ene_swat_heavy_policia_federale_city_r870") },
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
				Idstring("units/pd2_dlc_mad/characters/ene_akan_city_heavy_g36/ene_akan_city_heavy_g36"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_city_heavy_r870/ene_akan_city_heavy_r870"),
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_city_heavy_hvh_1/ene_city_heavy_hvh_1"),
				Idstring("units/pd2_dlc_hvh/characters/ene_city_heavy_hvh_r870/ene_city_heavy_hvh_r870"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy_city/ene_murkywater_heavy_city"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy_city_r870/ene_murkywater_heavy_city_r870"),
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_city/ene_swat_heavy_policia_federale_city"),
				Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_city_r870/ene_swat_heavy_policia_federale_city_r870"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.elite_sniper = {
		special_type = "marksman",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_sniper_3/ene_sniper_3") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_city_swat_sniper_svd_dmr/ene_akan_city_swat_sniper_svd_dmr") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_sniper_hvh_3/ene_sniper_hvh_3") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_sniper_city/ene_murkywater_sniper_city") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_sniper_city/ene_swat_policia_sniper_city") },
		},
		access = access_type_all,
	}

	self.unit_categories.elite_shield = {
		special_type = "shield",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_city_shield/ene_city_shield") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_city_shield/ene_akan_city_shield") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_city_shield_hvh/ene_city_shield_hvh") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_shield_city/ene_murkywater_shield_city") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_city/ene_swat_shield_policia_federale_city") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.taser_1 = {
		special_type = "taser",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_tazer_ak47_ass/ene_akan_cs_tazer_ak47_ass") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_tazer_hvh_1/ene_tazer_hvh_1") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_tazer/ene_murkywater_tazer") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_tazer_policia_federale/ene_swat_tazer_policia_federale") },
		},
		access = access_type_all,
	}

	self.unit_categories.taser_2 = {
		special_type = "taser",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_tazer_r870/ene_tazer_r870") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_tazer_r870/ene_akan_cs_tazer_r870") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_tazer_hvh_r870/ene_tazer_hvh_r870") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_tazer_r870/ene_murkywater_tazer_r870") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_tazer_policia_federale_r870/ene_swat_tazer_policia_federale_r870") },
		},
		access = access_type_all,
	}

	self.unit_categories.taser = {
		special_type = "taser",
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
				Idstring("units/payday2/characters/ene_tazer_r870/ene_tazer_r870"),
			},
			russia = {
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_tazer_ak47_ass/ene_akan_cs_tazer_ak47_ass"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_tazer_r870/ene_akan_cs_tazer_r870"),
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_tazer_hvh_1/ene_tazer_hvh_1"),
				Idstring("units/pd2_dlc_hvh/characters/ene_tazer_hvh_r870/ene_tazer_hvh_r870"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_tazer/ene_murkywater_tazer"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_tazer_r870/ene_murkywater_tazer_r870"),
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_swat_tazer_policia_federale/ene_swat_tazer_policia_federale"),
				Idstring("units/pd2_dlc_bex/characters/ene_swat_tazer_policia_federale_r870/ene_swat_tazer_policia_federale_r870"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.medic_1 = {
		special_type = "medic",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_medic_ak47_ass/ene_akan_medic_ak47_ass") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_medic_hvh_m4/ene_medic_hvh_m4") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_medic/ene_murkywater_medic") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_medic_policia_federale/ene_swat_medic_policia_federale") },
		},
		access = access_type_all,
	}

	self.unit_categories.medic_2 = {
		special_type = "medic",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_medic_r870/ene_akan_medic_r870") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_medic_hvh_r870/ene_medic_hvh_r870") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_medic_r870/ene_murkywater_medic_r870") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_medic_policia_federale_r870/ene_swat_medic_policia_federale_r870") },
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
				Idstring("units/pd2_dlc_mad/characters/ene_akan_medic_ak47_ass/ene_akan_medic_ak47_ass"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_medic_r870/ene_akan_medic_r870"),
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_medic_hvh_m4/ene_medic_hvh_m4"),
				Idstring("units/pd2_dlc_hvh/characters/ene_medic_hvh_r870/ene_medic_hvh_r870"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_medic/ene_murkywater_medic"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_medic_r870/ene_murkywater_medic_r870"),
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_swat_medic_policia_federale/ene_swat_medic_policia_federale"),
				Idstring("units/pd2_dlc_bex/characters/ene_swat_medic_policia_federale_r870/ene_swat_medic_policia_federale_r870"),
			},
		},
		access = access_type_all,
	}

	self.unit_categories.bulldozer_1 = {
		special_type = "tank",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_1/ene_bulldozer_hvh_1") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_1/ene_murkywater_bulldozer_1") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_r870/ene_swat_dozer_policia_federale_r870") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.bulldozer_2 = {
		special_type = "tank",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_saiga/ene_akan_fbi_tank_saiga") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_2/ene_bulldozer_hvh_2") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_2/ene_murkywater_bulldozer_2") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_saiga/ene_swat_dozer_policia_federale_saiga") },
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
				Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_saiga/ene_akan_fbi_tank_saiga"),
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_1/ene_bulldozer_hvh_1"),
				Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_2/ene_bulldozer_hvh_2"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_1/ene_murkywater_bulldozer_1"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_2/ene_murkywater_bulldozer_2"),
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_r870/ene_swat_dozer_policia_federale_r870"),
				Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_saiga/ene_swat_dozer_policia_federale_saiga"),
			},
		},
		access = access_type_walk_only,
	}

	self.unit_categories.elite_bulldozer_1 = {
		special_type = "tank",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_rpk_lmg/ene_akan_fbi_tank_rpk_lmg") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_3/ene_bulldozer_hvh_3") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_3/ene_murkywater_bulldozer_3") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_m249/ene_swat_dozer_policia_federale_m249") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.elite_bulldozer_2 = {
		special_type = "tank",
		unit_types = {
			america = { Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_mini/ene_akan_fbi_tank_mini") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_4/ene_bulldozer_hvh_4") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_4/ene_murkywater_bulldozer_4") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_minigun/ene_swat_dozer_policia_federale_minigun") },
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
				Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_mini/ene_akan_fbi_tank_mini"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_rpk_lmg/ene_akan_fbi_tank_rpk_lmg"),
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_4/ene_bulldozer_hvh_4"),
				Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_3/ene_bulldozer_hvh_3"),
			},
			murkywater = {
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_4/ene_murkywater_bulldozer_4"),
				Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_3/ene_murkywater_bulldozer_3"),
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_minigun/ene_swat_dozer_policia_federale_minigun"),
				Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_m249/ene_swat_dozer_policia_federale_m249"),
			},
		},
		access = access_type_walk_only,
	}

	self.unit_categories.cloaker = {
		special_type = "spooc",
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_spook_1/ene_spook_1") },
			russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_spooc_asval_smg/ene_akan_fbi_spooc_asval_smg") },
			zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_spook_hvh_1/ene_spook_hvh_1") },
			murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_cloaker/ene_murkywater_cloaker") },
			federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_cloaker_policia_federale/ene_swat_cloaker_policia_federale") },
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

	self.unit_categories.gensec_security = {
		unit_types = {
			america = {
				Idstring("units/pd2_dlc1/characters/ene_security_gensec_1/ene_security_gensec_1"),
				Idstring("units/pd2_dlc1/characters/ene_security_gensec_2/ene_security_gensec_2"),
			},
			russia = {
				Idstring("units/pd2_dlc1/characters/ene_security_gensec_1/ene_security_gensec_1"),
				Idstring("units/pd2_dlc1/characters/ene_security_gensec_2/ene_security_gensec_2"),
			},
			zombie = {
				Idstring("units/pd2_dlc1/characters/ene_security_gensec_1/ene_security_gensec_1"),
				Idstring("units/pd2_dlc1/characters/ene_security_gensec_2/ene_security_gensec_2"),
			},
			murkywater = {
				Idstring("units/pd2_dlc1/characters/ene_security_gensec_1/ene_security_gensec_1"),
				Idstring("units/pd2_dlc1/characters/ene_security_gensec_2/ene_security_gensec_2"),
			},
			federales = {
				Idstring("units/pd2_dlc1/characters/ene_security_gensec_1/ene_security_gensec_1"),
				Idstring("units/pd2_dlc1/characters/ene_security_gensec_2/ene_security_gensec_2"),
			},
		},
		access = access_type_walk_only,
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

	self.unit_categories.headless_dozers = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4"),
				Idstring("units/payday2/characters/ene_bulldozer_5/ene_bulldozer_5"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4"),
				Idstring("units/payday2/characters/ene_bulldozer_5/ene_bulldozer_5"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4"),
				Idstring("units/payday2/characters/ene_bulldozer_5/ene_bulldozer_5"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4"),
				Idstring("units/payday2/characters/ene_bulldozer_5/ene_bulldozer_5"),
			},
			federales = {
				Idstring("units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4"),
				Idstring("units/payday2/characters/ene_bulldozer_5/ene_bulldozer_5"),
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
	--	local small_urban = self._mission_preset and self._mission_preset == "small_urban"
	--	local heavy_response = self._mission_preset and self._mission_preset == "heavy_response"

	local small_urban = false
	local heavy_response = false

	self._group_difficulty_scale = get_difficulty_specific_value({
		8,
		10,
		12,
		15,
		18,
	})
	self._group_difficulty_scale_lin = get_difficulty_specific_value({
		4,
		5,
		6,
		7,
		8,
	})

	self._tactics = {
		none = {},
		beat_cop = {
			"ranged_fire",
			"no_push",
		},
		hrt = {
			"flank",
			"rescue",
		},
		swat_def = {
			"ranged_fire",
			"smoke_grenade",
		},
		swat_agg = {
			"charge",
			"flash_grenade",
			"deathguard",
		},
		swat_snk = {
			"flank",
			"flash_grenade",
		},
		swat_snk_agg = {
			"charge",
			"flank",
			"flash_grenade",
			"deathguard",
		},
		swat_spt = {
			"unit_cover",
			"ranged_fire",
		},
		shield_def = {
			"shield",
			"ranged_fire",
			"smoke_grenade",
			"deathguard",
		},
		shield_agg = {
			"shield",
			"charge",
			"flash_grenade",
			"deathguard",
		},
		shield_spt = {
			"shield_cover",
			"ranged_fire",
			"deathguard",
		},
		taser_snk = {
			"shield_cover",
			"flank",
			"smoke_grenade",
			"murder",
		},
		taser_agg = {
			"shield_cover",
			"charge",
			"flash_grenade",
			"murder",
		},
		taser_spt = {
			"shield",
			"ranged_fire",
			"murder",
		},
		bulldozer_def = {
			"shield",
			"flash_grenade",
			"deathguard",
			"murder",
		},
		bulldozer_agg = {
			"shield",
			"charge",
			"smoke_grenade",
			"murder",
		},
		bulldozer_spt = {
			"shield_cover",
			"ranged_fire",
			"murder",
		},
		cloaker_def = {
			"flank",
			"no_push",
		},
		cloaker_agg = {
			"charge",
			"flank",
			"smoke_grenade",
		},
		marksman = {
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
		light_smg = {
			swat_snk = 3,
			swat_def = 2,
		},
		heavy_rifle = {
			swat_def = 3,
			swat_snk = 1,
			swat_agg = 1,
		},
		heavy_shotgun = {
			swat_agg = 2,
			swat_snk_agg = 1,
		},
		light_defend = {
			swat_def = 5,
			swat_snk = 2,
			swat_agg = 1,
		},
		heavy_defend = {
			swat_def = 3,
			swat_snk = 2,
			swat_agg = 1,
		},
		shield = {
			"shield_agg",
			"shield_def",
		},
		taser = {
			"taser_agg",
			"taser_snk",
		},
		cloaker = {
			"cloaker_def",
			"cloaker_agg",
		},
		bulldozer = {
			"bulldozer_def",
			"bulldozer_agg",
		},
	}

	self._random_units = {
		hrt_special = {
			"taser_1",
			"cloaker",
		},
		light_special = {
			["medic_1"] = 4,
			["cloaker"] = 3,
			["medic_2"] = 2,
		},
		heavy_special = {
			["medic_1"] = 5,
			["taser_1"] = 4,
			["medic_2"] = 3,
			["taser_2"] = 2,
		},
		shield_special = {
			["medic_1"] = 6,
			["cloaker"] = 5,
			["taser_1"] = 5,
			["medic_2"] = 4,
			["taser_2"] = 3,
		},
		taser_special = {
			["cloaker"] = 6,
			["medic_1"] = 4,
			["medic_2"] = 2,
		},
		bulldozer_special = {
			["taser_1"] = 8,
			["medic_1"] = 6,
			["taser_2"] = 4,
			["medic_2"] = 3,
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
				tactics = self._tactics.beat_cop,
			},
		},
	}

	self.enemy_spawn_groups.cs_defend_light = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 0.5,
				amount_max = 2,
				rank = 2,
				unit = "cs_swat_2_3",
				tactics = self._tactics.swat_agg,
				random_tactics = self._random_tactics.light_defend,
			},
			{
				freq = 1,
				amount_min = 1,
				rank = 2,
				unit = "cs_swat_1_3",
				tactics = self._tactics.swat_snk,
				random_tactics = self._random_tactics.light_defend,
			},
			{
				freq = 1,
				freq_by_diff = table_multiply({
					2 / self._group_difficulty_scale_lin,
					1 / self._group_difficulty_scale_lin,
					0,
				}, heavy_response and 0 or 1),
				amount_max = 1,
				rank = 1,
				unit = "cs_cop_2_3",
				tactics = self._tactics.beat_cop,
			},
		},
	}

	self.enemy_spawn_groups.cs_defend_heavy = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 0.5,
				amount_max = 2,
				rank = 2,
				unit = "cs_heavy_2",
				tactics = self._tactics.swat_agg,
				random_tactics = self._random_tactics.heavy_defend,
			},
			{
				freq = 1,
				amount_min = 1,
				rank = 2,
				unit = "cs_heavy_1",
				tactics = self._tactics.swat_def,
				random_tactics = self._random_tactics.heavy_defend,
			},
			{
				freq = 1,
				freq_by_diff = table_multiply({
					4 / self._group_difficulty_scale_lin,
					2 / self._group_difficulty_scale_lin,
					0,
				}, heavy_response and 0.25 or 1),
				amount_max = 2,
				rank = 1,
				unit = "cs_swat_1_3",
				tactics = self._tactics.swat_snk,
				random_tactics = self._random_tactics.light_defend,
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
				tactics = self._tactics.hrt,
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
				tactics = self._tactics.beat_cop,
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
				unit = "cs_swat_1",
				tactics = self._tactics.swat_snk,
				random_tactics = self._random_tactics.light_smg,
			},
			{
				freq = 1,
				amount_min = 1,
				rank = 1,
				unit = "cs_swat_3",
				tactics = self._tactics.swat_def,
				random_tactics = self._random_tactics.light_rifle,
			},
		},
	}

	self.enemy_spawn_groups.cs_heavies = {
		amount_weighted = {
			[3] = 6,
			[2] = get_difficulty_specific_value({ 4, 2 }),
		},
		amount = { 2, 3 },
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
				rank = 2,
				unit = "cs_heavy_1",
				tactics = self._tactics.swat_def,
				random_tactics = self._random_tactics.heavy_rifle,
			},
			{
				freq = 1,
				freq_by_diff = table_multiply({
					4 / self._group_difficulty_scale_lin,
					2 / self._group_difficulty_scale_lin,
					0,
				}, heavy_response and 0.25 or 1),
				amount_max = 1,
				rank = 1,
				unit = "cs_swat_1_3",
				tactics = self._tactics.swat_spt,
			},
		},
	}

	self.enemy_spawn_groups.cs_shield = {
		drama_category = "shield",
		amount = { 4, 4 },
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
				freq_by_diff = table_multiply({
					6 / self._group_difficulty_scale_lin,
					4 / self._group_difficulty_scale_lin,
					2 / self._group_difficulty_scale_lin,
				}, heavy_response and 0.25 or 1),
				amount_max = 3,
				rank = 2,
				unit = "cs_swat",
				tactics = self._tactics.shield_spt,
			},
			{
				freq = 1,
				amount_max = 3,
				rank = 2,
				unit = "cs_heavy",
				tactics = self._tactics.shield_spt,
			},
			{
				freq = 1,
				freq_by_diff = table_multiply({
					4 / self._group_difficulty_scale_lin,
					2 / self._group_difficulty_scale_lin,
					0,
				}, heavy_response and 0 or 1),
				amount_max = 2,
				rank = 1,
				unit = "cs_cop_3",
				tactics = self._tactics.shield_spt,
			},
			{
				freq = 1,
				freq_by_diff = table_multiply({
					2 / self._group_difficulty_scale_lin,
					0,
					0,
				}, heavy_response and 0 or 1),
				amount_max = 1,
				rank = 1,
				unit = "cs_cop_2", -- For Sonic
				tactics = self._tactics.shield_spt,
			},
		},
	}

	self.enemy_spawn_groups.cs_taser = {
		drama_category = "taser",
		amount_weighted = {
			[3] = get_difficulty_specific_value({ 1, 3 }),
			[2] = 5,
			[1] = get_difficulty_specific_value({ 3, 1 }),
		},
		amount = { 1, 3 },
		spawn = {
			{
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				rank = 2,
				unit = "taser",
				tactics = self._tactics.taser_snk,
				random_tactics = self._random_tactics.taser,
			},
			{
				freq = 1,
				rank = 1,
				unit = "cs_swat",
				tactics = self._tactics.taser_spt,
			},
		},
	}

	self.enemy_spawn_groups.cs_bulldozer = {
		drama_category = "tank",
		amount_weighted = {
			[3] = get_difficulty_specific_value({ 1, 3 }),
			[2] = 5,
			[1] = get_difficulty_specific_value({ 3, 1 }),
		},
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
				freq = 1,
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
				tactics = self._tactics.beat_cop,
			},
			{
				freq = 1,
				freq_by_diff = table_multiply({
					9 / self._group_difficulty_scale,
					3 / self._group_difficulty_scale,
					0,
				}, heavy_response and 0 or small_urban and 1.5 or 1),
				amount_max = 2,
				rank = 1,
				unit = "cs_cop_1_4",
				tactics = self._tactics.beat_cop,
			},
		},
	}

	self.enemy_spawn_groups.fbi_defend_light = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 0.5,
				amount_max = 2,
				rank = 2,
				unit = "fbi_swat_2_3",
				tactics = self._tactics.swat_agg,
				random_tactics = self._random_tactics.light_defend,
			},
			{
				freq = 1,
				amount_min = 1,
				rank = 2,
				unit = "fbi_swat_1",
				tactics = self._tactics.swat_snk,
				random_tactics = self._random_tactics.light_defend,
			},
			{
				freq = 1,
				freq_by_diff = table_multiply({
					9 / self._group_difficulty_scale,
					3 / self._group_difficulty_scale,
					0,
				}, heavy_response and 0 or 1),
				amount_max = 1,
				rank = 1,
				unit = "fbi_agent_3",
				tactics = self._tactics.beat_cop,
			},
			self:_distance_weighted_spawn_entry({
				freq = 1,
				freq_by_diff = {
					0,
					self._group_difficulty_scale / 240,
					self._group_difficulty_scale / 120,
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
				tactics = self._tactics.swat_agg,
				random_tactics = self._random_tactics.heavy_defend,
			},
			{
				freq = 1,
				amount_min = 1,
				rank = 2,
				unit = "fbi_heavy_1",
				tactics = self._tactics.swat_snk,
				random_tactics = self._random_tactics.heavy_defend,
			},
			{
				freq = 1,
				freq_by_diff = table_multiply({
					12 / self._group_difficulty_scale,
					6 / self._group_difficulty_scale,
					0,
				}, heavy_response and 0.25 or 1),
				amount_max = 2,
				rank = 1,
				unit = "fbi_swat_1_3",
				tactics = self._tactics.swat_spt,
			},
			self:_distance_weighted_spawn_entry({
				freq = 1,
				freq_by_diff = {
					0,
					self._group_difficulty_scale / 240,
					self._group_difficulty_scale / 120,
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
				tactics = self._tactics.hrt,
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
					self._group_difficulty_scale / 90,
					self._group_difficulty_scale / 45,
				},
				drama_category = "supporting_special",
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
					self._group_difficulty_scale / 60,
					self._group_difficulty_scale / 30,
				},
				drama_category = "supporting_special",
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
				rank = 2,
				unit = "fbi_swat_1",
				tactics = self._tactics.swat_def,
				random_tactics = self._random_tactics.light_rifle,
			},
			{
				freq = 1,
				freq_by_diff = table_multiply({
					0,
					self._group_difficulty_scale / 60,
					self._group_difficulty_scale / 30,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				drama_category = "supporting_special",
				amount_max = 1,
				rank = 1,
				unit = "medic",
				random_unit = self._random_units.light_special,
				tactics = self._tactics.swat_spt,
			},
		},
	}

	self.enemy_spawn_groups.fbi_heavies = {
		amount_weighted = {
			[4] = get_difficulty_specific_value({ 1, 1, 1, 2, 3 }),
			[3] = 6,
			[2] = get_difficulty_specific_value({ 3, 3, 3, 2, 1 }),
		},
		amount = { 2, 4 },
		spawn = {
			{
				freq = 0.5,
				amount_max = 2,
				rank = 2,
				unit = "fbi_heavy_2",
				tactics = self._tactics.swat_agg,
				random_tactics = self._random_tactics.heavy_shotgun,
			},
			{
				freq = 1,
				amount_min = 1,
				rank = 2,
				unit = "fbi_heavy_1",
				tactics = self._tactics.swat_def,
				random_tactics = self._random_tactics.heavy_rifle,
			},
			{
				freq = 1,
				freq_by_diff = table_multiply({
					12 / self._group_difficulty_scale,
					6 / self._group_difficulty_scale,
					0,
				}, heavy_response and 0.25 or 1),
				amount_max = 1,
				rank = 1,
				unit = "fbi_swat_1_3",
				tactics = self._tactics.swat_spt,
			},
			{
				freq = 1,
				freq_by_diff = table_multiply({
					0,
					self._group_difficulty_scale / 60,
					self._group_difficulty_scale / 30,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				drama_category = "supporting_special",
				amount_max = 1,
				rank = 1,
				unit = "medic",
				random_unit = self._random_units.heavy_special,
				tactics = self._tactics.swat_spt,
			},
		},
	}

	self.enemy_spawn_groups.fbi_shield = {
		drama_category = "shield",
		amount = { 4, 5 },
		spawn = {
			{
				freq = 1,
				freq_by_diff = table_multiply({
					self._group_difficulty_scale / 120,
					self._group_difficulty_scale / 60,
					self._group_difficulty_scale / 30,
				}, heavy_response and 1.25 or small_urban and 0.5 or 1),
				freq_balance_mul = { 0.25, 0.5, 0.75, 1 },
				amount_min = 1,
				amount_max = 2,
				rank = 3,
				unit = "fbi_shield",
				tactics = self._tactics.shield_def,
				random_tactics = self._random_tactics.shield,
			},
			{
				freq = 1,
				freq_by_diff = table_multiply({
					10 / self._group_difficulty_scale_lin,
					6 / self._group_difficulty_scale_lin,
					2 / self._group_difficulty_scale_lin,
				}, heavy_response and 0.25 or 1),
				amount_max = 3,
				rank = 2,
				unit = "fbi_swat",
				tactics = self._tactics.shield_spt,
			},
			{
				freq = 1,
				amount_max = 3,
				rank = 2,
				unit = "fbi_heavy",
				tactics = self._tactics.shield_spt,
			},
			{
				freq = 1,
				freq_by_diff = table_multiply({
					6 / self._group_difficulty_scale_lin,
					2 / self._group_difficulty_scale_lin,
					0,
				}, heavy_response and 0 or 1),
				amount_max = 2,
				rank = 1,
				unit = "fbi_agent_3",
				tactics = self._tactics.shield_spt,
			},
			{
				freq = 1,
				freq_by_diff = table_multiply({
					4 / self._group_difficulty_scale_lin,
					0,
					0,
				}, heavy_response and 0 or 1),
				amount_max = 1,
				rank = 1,
				unit = "cs_cop_2", -- For Sonic
				tactics = self._tactics.shield_spt,
			},
			{
				freq = 1,
				freq_by_diff = table_multiply({
					0,
					self._group_difficulty_scale / 90,
					self._group_difficulty_scale / 45,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				freq_balance_mul = { 0.5, 0.75, 1, 1 },
				drama_category = "supporting_special",
				amount_max = 1,
				rank = 1,
				unit = "medic",
				random_unit = self._random_units.shield_special,
				tactics = self._tactics.shield_spt,
			},
		},
	}

	self.enemy_spawn_groups.fbi_taser = {
		drama_category = "taser",
		amount_weighted = {
			[4] = get_difficulty_specific_value({ 2, 2, 2, 4, 6 }),
			[3] = 4,
			[2] = get_difficulty_specific_value({ 3, 3, 3, 2, 1 }),
		},
		amount = { 2, 4 },
		spawn = {
			{
				freq = 1,
				freq_by_diff = table_multiply({
					0,
					self._group_difficulty_scale / 150,
					self._group_difficulty_scale / 75,
				}, heavy_response and 1.25 or small_urban and 0.5 or 1),
				freq_balance_mul = { 0.55, 0.7, 0.85, 1 },
				amount_min = 1,
				amount_max = 2,
				rank = 2,
				unit = "taser",
				tactics = self._tactics.taser_snk,
				random_tactics = self._random_tactics.taser,
			},
			{
				freq = 1,
				rank = 1,
				unit = "fbi_swat",
				tactics = self._tactics.taser_spt,
			},
			{
				freq = 1,
				freq_by_diff = table_multiply({
					0,
					self._group_difficulty_scale / 90,
					self._group_difficulty_scale / 45,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				freq_balance_mul = { 0.5, 0.75, 1, 1 },
				drama_category = "supporting_special",
				amount_max = 1,
				rank = 1,
				unit = "cloaker",
				random_unit = self._random_units.taser_special,
				tactics = self._tactics.taser_spt,
			},
		},
	}

	self.enemy_spawn_groups.fbi_bulldozer = {
		drama_category = "tank",
		amount_weighted = {
			[4] = get_difficulty_specific_value({ 2, 2, 2, 4, 6 }),
			[3] = 4,
			[2] = get_difficulty_specific_value({ 3, 3, 3, 2, 1 }),
		},
		amount = { 2, 4 },
		spawn = {
			{
				freq = 1,
				freq_by_diff = table_multiply({
					0,
					0,
					self._group_difficulty_scale / 150,
				}, heavy_response and 1.25 or small_urban and 0.5 or 1),
				freq_balance_mul = { 0.1, 0.4, 0.7, 1 },
				amount_min = 1,
				amount_max = 2,
				rank = 2,
				unit = "bulldozer",
				tactics = self._tactics.bulldozer_agg,
				random_tactics = self._random_tactics.bulldozer,
			},
			{
				freq = 1,
				rank = 1,
				unit = "fbi_heavy",
				tactics = self._tactics.bulldozer_spt,
			},
			{
				freq = 1,
				freq_by_diff = table_multiply({
					0,
					self._group_difficulty_scale / 90,
					self._group_difficulty_scale / 45,
				}, heavy_response and 1.25 or small_urban and 0.5 or 1),
				freq_balance_mul = { 0.5, 0.75, 1, 1 },
				drama_category = "supporting_special",
				amount_max = 1,
				rank = 1,
				unit = "medic",
				random_unit = self._random_units.bulldozer_special,
				tactics = self._tactics.bulldozer_spt,
			},
		},
	}

	self.enemy_spawn_groups.fbi_cloaker = {
		drama_category = "spooc",
		amount_weighted = {
			[2] = get_difficulty_specific_value({ 1, 1, 1, 2, 3 }),
			[1] = 1,
		},
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
				rank = 2,
				unit = "elite_swat_2_3",
				tactics = self._tactics.swat_agg,
				random_tactics = self._random_tactics.light_defend,
			},
			{
				freq = 1,
				amount_min = 1,
				rank = 2,
				unit = "elite_swat_1",
				tactics = self._tactics.swat_snk,
				random_tactics = self._random_tactics.light_defend,
			},
			self:_distance_weighted_spawn_entry({
				freq = 1,
				freq_by_diff = {
					0,
					self._group_difficulty_scale / 240,
					self._group_difficulty_scale / 120,
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
				tactics = self._tactics.swat_agg,
				random_tactics = self._random_tactics.heavy_defend,
			},
			{
				freq = 1,
				amount_min = 1,
				rank = 2,
				unit = "elite_heavy_1",
				tactics = self._tactics.swat_snk,
				random_tactics = self._random_tactics.heavy_defend,
			},
			{
				freq = 1,
				freq_by_diff = table_multiply({
					8 / self._group_difficulty_scale,
					6 / self._group_difficulty_scale,
					4 / self._group_difficulty_scale,
				}, heavy_response and 0.25 or 1),
				amount_max = 2,
				rank = 1,
				unit = "elite_swat_1_3",
				tactics = self._tactics.swat_spt,
			},
			self:_distance_weighted_spawn_entry({
				freq = 1,
				freq_by_diff = {
					0,
					self._group_difficulty_scale / 240,
					self._group_difficulty_scale / 120,
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
				rank = 1,
				unit = "elite_swat_1",
				tactics = self._tactics.swat_def,
				random_tactics = self._random_tactics.light_rifle,
			},
			{
				freq = 1,
				freq_by_diff = table_multiply({
					0,
					self._group_difficulty_scale / 60,
					self._group_difficulty_scale / 30,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				drama_category = "supporting_special",
				amount_max = 1,
				rank = 1,
				unit = "medic",
				random_unit = self._random_units.light_special,
				tactics = self._tactics.swat_spt,
			},
		},
	}

	self.enemy_spawn_groups.elite_heavies = {
		amount_weighted = {
			[4] = get_difficulty_specific_value({ 1, 1, 1, 2, 3 }),
			[3] = 6,
			[2] = get_difficulty_specific_value({ 3, 3, 3, 2, 1 }),
		},
		amount = { 2, 4 },
		spawn = {
			{
				freq = 0.5,
				amount_max = 2,
				rank = 2,
				unit = "elite_heavy_2",
				tactics = self._tactics.swat_agg,
				random_tactics = self._random_tactics.heavy_shotgun,
			},
			{
				freq = 1,
				amount_min = 1,
				rank = 2,
				unit = "elite_heavy_1",
				tactics = self._tactics.swat_def,
				random_tactics = self._random_tactics.heavy_rifle,
			},
			{
				freq = 1,
				freq_by_diff = table_multiply({
					8 / self._group_difficulty_scale,
					6 / self._group_difficulty_scale,
					4 / self._group_difficulty_scale,
				}, heavy_response and 0.5 or 1),
				amount_max = 1,
				rank = 1,
				unit = "elite_swat_1_3",
				tactics = self._tactics.swat_spt,
			},
			{
				freq = 1,
				freq_by_diff = table_multiply({
					0,
					self._group_difficulty_scale / 60,
					self._group_difficulty_scale / 30,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				drama_category = "supporting_special",
				amount_max = 1,
				rank = 1,
				unit = "medic",
				random_unit = self._random_units.heavy_special,
				tactics = self._tactics.swat_spt,
			},
		},
	}

	self.enemy_spawn_groups.elite_shield = {
		drama_category = "shield",
		amount = { 4, 5 },
		spawn = {
			{
				freq = 1,
				freq_by_diff = table_multiply({
					0,
					self._group_difficulty_scale / 240,
					self._group_difficulty_scale / 120,
				}, heavy_response and 1.25 or small_urban and 0.5 or 1),
				freq_balance_mul = { 0.25, 0.5, 0.75, 1 },
				amount_min = 1,
				amount_max = 2,
				rank = 3,
				unit = "elite_shield",
				tactics = self._tactics.shield_def,
				random_tactics = self._random_tactics.shield,
			},
			{
				freq = 0.75,
				amount_max = 3,
				rank = 2,
				unit = "elite_swat",
				tactics = self._tactics.shield_spt,
			},
			{
				freq = 0.75,
				amount_max = 3,
				rank = 2,
				unit = "fbi_heavy",
				tactics = self._tactics.shield_spt,
			},
			{
				freq = 1,
				freq_by_diff = table_multiply({
					0,
					self._group_difficulty_scale / 90,
					self._group_difficulty_scale / 45,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				freq_balance_mul = { 0.5, 0.75, 1, 1 },
				drama_category = "supporting_special",
				amount_max = 1,
				rank = 1,
				unit = "medic",
				random_unit = self._random_units.shield_special,
				tactics = self._tactics.shield_spt,
			},
		},
	}

	self.enemy_spawn_groups.elite_taser = {
		drama_category = "taser",
		amount_weighted = {
			[4] = get_difficulty_specific_value({ 2, 2, 2, 4, 6 }),
			[3] = 4,
			[2] = get_difficulty_specific_value({ 3, 3, 3, 2, 1 }),
		},
		amount = { 2, 4 },
		spawn = {
			{
				freq = 1,
				freq_by_diff = table_multiply({
					0,
					self._group_difficulty_scale / 150,
					self._group_difficulty_scale / 75,
				}, heavy_response and 1.25 or small_urban and 0.5 or 1),
				freq_balance_mul = { 0.55, 0.7, 0.85, 1 },
				amount_min = 1,
				amount_max = 2,
				rank = 2,
				unit = "taser",
				tactics = self._tactics.taser_snk,
				random_tactics = self._random_tactics.taser,
			},
			{
				freq = 1,
				rank = 1,
				unit = "elite_swat",
				tactics = self._tactics.taser_spt,
			},
			{
				freq = 1,
				freq_by_diff = table_multiply({
					0,
					self._group_difficulty_scale / 90,
					self._group_difficulty_scale / 45,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				freq_balance_mul = { 0.5, 0.75, 1, 1 },
				drama_category = "supporting_special",
				amount_max = 1,
				rank = 1,
				unit = "cloaker",
				random_unit = self._random_units.taser_special,
				tactics = self._tactics.taser_spt,
			},
		},
	}

	self.enemy_spawn_groups.elite_bulldozer = {
		drama_category = "tank",
		amount_weighted = {
			[4] = get_difficulty_specific_value({ 2, 2, 2, 4, 6 }),
			[3] = 4,
			[2] = get_difficulty_specific_value({ 3, 3, 3, 2, 1 }),
		},
		amount = { 2, 4 },
		spawn = {
			{
				freq = 1,
				freq_by_diff = table_multiply({
					0,
					0,
					self._group_difficulty_scale / 300,
				}, heavy_response and 1.25 or small_urban and 0.5 or 1),
				freq_balance_mul = { 0.1, 0.4, 0.7, 1 },
				amount_min = 1,
				amount_max = 2,
				rank = 2,
				unit = "elite_bulldozer",
				tactics = self._tactics.bulldozer_agg,
				random_tactics = self._random_tactics.bulldozer,
			},
			{
				freq = 1,
				rank = 1,
				unit = "fbi_heavy",
				tactics = self._tactics.bulldozer_spt,
			},
			{
				freq = 1,
				freq_by_diff = table_multiply({
					0,
					self._group_difficulty_scale / 90,
					self._group_difficulty_scale / 45,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				freq_balance_mul = { 0.5, 0.75, 1, 1 },
				drama_category = "supporting_special",
				amount_max = 1,
				rank = 1,
				unit = "medic",
				random_unit = self._random_units.bulldozer_special,
				tactics = self._tactics.bulldozer_spt,
			},
		},
	}

	self.enemy_spawn_groups.elite_sniper = {
		drama_category = "marksman",
		amount_weighted = {
			[2] = get_difficulty_specific_value({ 1, 1, 1, 2, 3 }),
			[1] = 9,
		},
		amount = { 1, 2 },
		spawn = {
			{
				freq = 1,
				freq_by_diff = table_multiply({
					0,
					self._group_difficulty_scale / 180,
					self._group_difficulty_scale / 90,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				freq_balance_mul = { 0.25, 0.5, 0.75, 1 },
				amount_max = 1,
				rank = 2,
				unit = "elite_shield",
				tactics = self._tactics.shield_def,
			},
			{
				freq = 1,
				amount_min = 1,
				amount_max = 2,
				rank = 1,
				unit = "elite_sniper",
				tactics = self._tactics.marksman,
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
				tactics = self._tactics.swat_spt,
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

GroupAITweakData.fbi_heists = table.list_to_set({
	"watchdogs_1",
	"watchdogs_1_night",
	"watchdogs_2",
	"watchdogs_2_day",
	"firestarter_1",
	"firestarter_2",
	"firestarter_3",
	"alex_1",
	"alex_2",
	"alex_3",
	"hox_2",
	"hox_3",
	"man",
})
GroupAITweakData.murky_response_heists = table.list_to_set({
	"dinner",
})
GroupAITweakData.murky_response_heists_scripted = table.list_to_set({
	--	"brb",
})
GroupAITweakData.us_army_heists = table.list_to_set({
	"arm_for",
	"crojob2",
	"crojob3",
	"jolly",
	"trai",
})
GroupAITweakData.us_army_heists_scripted = table.list_to_set({
	"roberts",
	"peta2",
	"vit",
})
GroupAITweakData.gensec_tac_teams_heists = table.list_to_set({
	"arm_cro",
	"arm_par",
	"arm_hcm",
	"arm_und",
	"arm_fac",
	"roberts",
	"dah",
	"arena",
})
GroupAITweakData.bellmead_response_heists = table.list_to_set({
	"ranc",
	"corp",
	"deep",
})
GroupAITweakData.headless_dozer_heists = table.list_to_set({
	"nail",
	"help",
	--"hvh",
})

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
			"murder",
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
		},
		fbi_snk = {
			"flank",
			"flash_grenade",
			"deathguard",
		},
		fbi_spt = {
			"unit_cover",
			"ranged_fire",
		},
		army_def = {
			"shield",
			"ranged_fire",
			"smoke_grenade",
			"murder",
		},
		army_agg = {
			"shield",
			"charge",
			"flash_grenade",
			"murder",
		},
		army_snk = {
			"shield",
			"flank",
			"flash_grenade",
			"murder",
		},
		army_spt = {
			"shield_cover",
			"ranged_fire",
			"murder",
		},
		bulldozer_def = {
			"shield",
			"murder",
		},
		bulldozer_agg = {
			"shield",
			"charge",
			"murder",
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
		fbi_readyteam = {
			"fbi_def",
			"fbi_snk",
		},
		army_defensive = {
			army_def = 3,
			army_snk = 2,
			army_agg = 1,
		},
		army_aggressive = {
			army_agg = 2,
			army_snk = 1,
		},
		headless_dozers = {
			"bulldozer_def",
			"bulldozer_agg",
		},
	}

	self.timed_enemy_spawn_groups = {}

	if self.fbi_heists[level_id] then
		self.timed_enemy_spawn_groups.fbi_group1 = Eclipse:require("timed_groups/fbi_group1")(self._timed_tactics, self._timed_random_tactics, swat_spawn_point_ref, self._group_difficulty_scale)
	end

	if self.murky_response_heists[level_id] then
		self.timed_enemy_spawn_groups.murky_group1 = Eclipse:require("timed_groups/murky_group1")(self._timed_tactics, self._timed_random_tactics, swat_spawn_point_ref)
	end

	if self.murky_response_heists_scripted[level_id] then
		self.timed_enemy_spawn_groups.murky_scripted_group1 = Eclipse:require("timed_groups/murky_scripted_group1")(self._timed_tactics, self._timed_random_tactics, swat_spawn_point_ref)
	end

	if self.us_army_heists[level_id] then
		self.timed_enemy_spawn_groups.us_group1 = Eclipse:require("timed_groups/us_group1")(self._timed_tactics, self._timed_random_tactics, swat_spawn_point_ref, self._group_difficulty_scale)
	end

	if self.bellmead_response_heists[level_id] then
		self.timed_enemy_spawn_groups.bellmead_group1 = Eclipse:require("timed_groups/bellmead_group1")(self._timed_tactics, self._timed_random_tactics, swat_spawn_point_ref)
	end

	if self.us_army_heists_scripted[level_id] then
		self.timed_enemy_spawn_groups.us_scripted_group1 =
			Eclipse:require("timed_groups/us_scripted_group1")(self._timed_tactics, self._timed_random_tactics, swat_spawn_point_ref, self._group_difficulty_scale)
	end

	if self.gensec_tac_teams_heists[level_id] then
		self.timed_enemy_spawn_groups.gensec_group1 = Eclipse:require("timed_groups/gensec_group1")(self._timed_tactics, self._timed_random_tactics, swat_spawn_point_ref, self._group_difficulty_scale)
	end

	if self.headless_dozer_heists[level_id] then
		self.timed_enemy_spawn_groups.headless_dozer_group1 = Eclipse:require("timed_groups/headless_dozer_group1")(self._timed_tactics, self._timed_random_tactics, swat_spawn_point_ref)
	end
end

Hooks:PostHook(GroupAITweakData, "_init_task_data", "eclipse__init_task_data", function(self, difficulty_index)
	local below_overkill = difficulty_index < 5
	local empty_tbl = { 0, 0, 0 }

	-- Assault Data
	-- In-heist difficulty scaling
	--[[
	self.difficulty_scaling = {
		assault_delay = 45,
		diff_min = 0,
		diff_max = 1,
		diff_init = 0.25,
		diff_step = 0.05,
		diff_step_interval = get_difficulty_specific_value({ 10, 9, 8, 7, 6 }),
		assault_add = 0.25,
		hostage_kill_add = is_pro_job and 0.15 or nil,
	}
	]]
	-- Quick translations from the old system to the new one
	-- assault_delay -> addends.on_enemy_weapons_hot.delay
	-- diff_init -> addends.on_enemy_weapons_hot.amount
	-- diff_min, diff_max -> mission scripting only, as "forced difficulty"
	-- diff_step, diff_step_interval -> no more global target/step time, each addend has its own time
	-- assault_add -> addends.on_entered_regroup
	-- hostage_kill_add -> addends.on_hostage_killed
	self.difficulty_scaling = {
		-- New timed steps are added to the stack once the previous timed step has completed
		steps = {
			--[[
			{
				amount = 0,
				delay = 0,
				time = 0,
			},
			{
				amount = 0,
				delay = 0,
				time = 0,
			},
			]]
		},
		addends = {
			on_enemy_weapons_hot = {
				amount = 0.25,
				delay = 45,
				time = 60,
			},
			-- Not enabled by default, only allowed for assault 2+ if enabled
			on_entered_sustain = {
				amount = 0.375,
				delay = 0,
				time = 60,
			},
			on_entered_regroup = {
				amount = 0.375,
				delay = 0,
				time = 60,
			},
			on_entered_full_force_onslaught = {
				amount = 1,
				delay = 0,
				time = 60,
			},
			on_hostage_killed = {
				amount = { 0.075, 0.125 },
				delay = 0,
				time = { 10, 15 },
			},
		},
		-- So that certain heists may toggle addends on/off in tweakdata or mission scripting
		-- Adding not-allowed addends is blocked completely
		allowed_addends = {
			on_enemy_weapons_hot = true,
			on_entered_sustain = false,
			on_entered_regroup = true,
			on_entered_full_force_onslaught = is_pro_job and true or false,
			on_hostage_killed = is_pro_job and true or false,
		},
		-- So that certain heists may pause addends in tweakdata or mission scripting
		-- Adding paused addends caches them (up to a limit) to be added later, when they're unpaused
		paused_addends = {
			-- on_enemy_weapons_hot = 2,
			on_enemy_weapons_hot = false,
			on_entered_sustain = false,
			on_entered_regroup = false,
			on_entered_full_force_onslaught = false,
			on_hostage_killed = false,
		},
		-- So that certain heists may change addends and have automatic difficulty scaling
		addend_time_multipliers = {
			on_enemy_weapons_hot = get_difficulty_specific_value({ 1.2, 1.1, 1, 0.8, 0.6 }),
			on_entered_sustain = get_difficulty_specific_value({ 1.2, 1.1, 1, 0.8, 0.6 }),
			on_entered_regroup = get_difficulty_specific_value({ 1.2, 1.1, 1, 0.8, 0.6 }),
			on_entered_full_force_onslaught = get_difficulty_specific_value({ 1.2, 1.1, 1, 0.8, 0.6 }),
			on_hostage_killed = get_difficulty_specific_value({ 1.2, 1.1, 1, 0.8, 0.6 }),
		},
		addend_time_balance_muls = {
			on_enemy_weapons_hot = { 1.45, 1.3, 1.15, 1 },
			on_entered_sustain = { 1.45, 1.3, 1.15, 1 },
			on_entered_regroup = { 1.45, 1.3, 1.15, 1 },
			on_entered_full_force_onslaught = { 1.45, 1.3, 1.15, 1 },
			on_hostage_killed = { 1.45, 1.3, 1.15, 1 },
		},
		-- The initial trade delay is not currently affected by on_enemy_weapons_hot delay multipliers
		addend_delay_multipliers = {
			on_enemy_weapons_hot = get_difficulty_specific_value({ 1.2, 1.2, 1, 0.9, 0.8 }),
			on_entered_sustain = get_difficulty_specific_value({ 1, 1, 1, 1, 1 }),
			on_entered_regroup = get_difficulty_specific_value({ 1, 1, 1, 1, 1 }),
			on_entered_full_force_onslaught = get_difficulty_specific_value({ 1, 1, 1, 1, 1 }),
			on_hostage_killed = get_difficulty_specific_value({ 1, 1, 1, 1, 1 }),
		},
		addend_delay_balance_muls = {
			on_enemy_weapons_hot = { 1, 1, 1, 1 },
			on_entered_sustain = { 1, 1, 1, 1 },
			on_entered_regroup = { 1, 1, 1, 1 },
			on_entered_full_force_onslaught = { 1, 1, 1, 1 },
			on_hostage_killed = { 1, 1, 1, 1 },
		},
	}

	-- BESIEGE --
	self.besiege.drama_gain_mul = { 1.25, 1, 0.75 }

	if difficulty_index <= 3 then
		self.besiege.scripted_tiers = {
			"CS",
			"CS",
			"CS",
		}
	elseif difficulty_index <= 5 then
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
	self.besiege.assault.sustain_duration_min = get_difficulty_specific_value({
		{ 40, 80, 120 },
		{ 50, 90, 140 },
		{ 60, 100, 160 },
		{ 70, 120, 180 },
		{ 80, 140, 200 },
	})
	self.besiege.assault.sustain_duration_max = self.besiege.assault.sustain_duration_min
	self.besiege.assault.sustain_duration_balance_mul = { 1, 1, 1, 1 }

	self.besiege.regroup.duration = { 30, 25, 20 }

	-- Control
	self.besiege.assault.delay = get_difficulty_specific_value({
		{ 60, 45, 30 },
		{ 50, 40, 30 },
		{ 40, 30, 25 },
		{ 35, 25, 20 },
		{ 30, 20, 15 },
	})
	self.besiege.assault.delay_balance_mul = { 1, 1, 1, 1 }
	self.besiege.assault.hostage_hesitation_delay = { 10, 7.5, 5 }

	-- SPAWNS --

	-- Spawncap
	self.besiege.assault.force = get_difficulty_specific_value({
		{ 6, 10, 14 },
		{ 6, 10, 14 },
		{ 8, 12, 16 },
		{ 10, 14, 18 },
		{ 12, 16, 20 },
	})
	self.besiege.assault.force_balance_mul = generate_big_lobby_balance_muls({
		{ 0.55, 1 },
		{ 0.7, 2 },
		{ 0.85, 3 },
		{ 1, 4 },
		{ 1.5, 10 },
		{ 2, 16 },
		{ 3, 22 },
	}, 0.025)

	self.besiege.assault.force_pool = {
		self.besiege.assault.force[1] * 10,
		self.besiege.assault.force[2] * 10,
		self.besiege.assault.force[3] * 10,
	}
	self.besiege.assault.force_pool_balance_mul = self.besiege.assault.force_balance_mul

	self.use_team_ai_balance_mul_weights = true
	self.team_ai_balance_mul_weights = {
		drama = calc_team_ai_wgt(2),
		spawn_rate = calc_team_ai_wgt(2.5),
		force = calc_team_ai_wgt(2.5),
		assault_delay = calc_team_ai_wgt(2.5),
		sustain_duration = calc_team_ai_wgt(2.5),
		freq = calc_team_ai_wgt(2),
		spawn_group_interval = calc_team_ai_wgt(2.5),
		difficulty_addend_time = calc_team_ai_wgt(2),
		difficulty_addend_delay = calc_team_ai_wgt(2.5),
		ponr_length = calc_team_ai_wgt(2),
	}

	-- Spawn rate
	self.spawn_kill_cooldown = get_difficulty_specific_value({
		20,
		20,
		15,
		15,
		10,
	})
	self.spawn_kill_max_dis = 1500

	self.min_spawn_group_interval = get_difficulty_specific_value({
		10,
		9,
		8,
		7,
		6,
	})

	self.besiege.assault.spawn_rate = get_difficulty_specific_value({
		{ 3, 2.5, 2 },
		{ 3, 2.5, 2 },
		{ 2.75, 2.25, 1.75 },
		{ 2.75, 2.25, 1.75 },
		{ 2.5, 2, 1.5 },
	})
	self.besiege.assault.spawn_rate_balance_mul = generate_big_lobby_balance_muls({
		{ 1.75, 1 },
		{ 1.5, 2 },
		{ 1.25, 3 },
		{ 1, 4 },
		{ 0.75, 10 },
		{ 0.5, 16 },
		{ 0.25, 22 },
	}, 0.025)

	-- RECON / REENFORCE --

	-- Reenforce spawn interval
	self.besiege.reenforce.interval = { 10, 20, 30 }
	self.undershot_reenforce_interval_factor = 1
	self.init_reenforce_delay = 15
	self.use_loot_drop_reenforce = true
	self.use_equipment_reenforce = true
	self.equipment_reenforce = table.list_to_set({
		"doctor_bag",
		"ammo_bag",
		"grenade_case",
		"grenade_crate",
	})

	-- Recon spawn interval and spawncap
	self.besiege.recon.force = get_difficulty_specific_value({
		{ 4, 6, 8 },
		{ 4, 6, 8 },
		{ 5, 7, 9 },
		{ 5, 7, 9 },
		{ 6, 8, 10 },
	})
	self.besiege.recon.interval_variation = 30

	-- Push delay
	self.besiege.assault.push_delay = get_difficulty_specific_value({
		{ 18, 14, 12 },
		{ 18, 14, 12 },
		{ 16, 12, 10 },
		{ 16, 12, 10 },
		{ 14, 10, 8 },
	})
	self.hostage_push_delay_mul = 1.5

	-- GRENADES --
	self.min_grenade_timeout = get_difficulty_specific_value({
		{ 25, 20, 15 },
		{ 25, 20, 15 },
		{ 20, 15, 10 },
	})

	self.flash_grenade_timeout = { 15, 20 }
	self.flash_grenade.light_color = Vector3(255, 255, 255)
	self.flash_grenade.light_range = is_eclipse and 0 or 500
	self.flash_grenade.timer = get_difficulty_specific_value({
		2,
		2,
		1.75,
		1.5,
		1.5,
	})

	self.smoke_grenade_timeout = { 25, 35 }
	self.smoke_grenade_lifetime = get_difficulty_specific_value({
		9,
		9,
		12,
		15,
		15,
	})

	self.cs_grenade_timeout = { 60, 90 }
	self.cs_grenade_lifetime = get_difficulty_specific_value({
		15,
		15,
		20,
		30,
		30,
	})
	self.cs_grenade_chance_times = get_difficulty_specific_value({
		{ 60, 180 },
		{ 60, 180 },
		{ 60, 120 },
		{ 45, 90 },
		{ 30, 60 },
	})

	self._special_wgt = get_difficulty_specific_value({
		7,
		8,
		9,
		11,
		13,
	})
	local special_wgt_tbl = { self._special_wgt, self._special_wgt, self._special_wgt }
	local shield_wgt = table_multiply(clone(special_wgt_tbl), below_overkill and { 0.4, 0.8, 1.2 } or { 0.6, 0.9, 1.2 })
	local taser_wgt = table_multiply(clone(special_wgt_tbl), below_overkill and { 0, 0.5, 1 } or { 0.4, 0.7, 1 })
	local spook_wgt = table_multiply(clone(special_wgt_tbl), below_overkill and { 0, 0.4, 0.8 } or { 0.4, 0.6, 0.8 })
	local tank_wgt = table_multiply(clone(special_wgt_tbl), below_overkill and { 0, 0.2, 0.4 } or { 0, 0.3, 0.4 })
	local elite_sniper_wgt = table_multiply(clone(special_wgt_tbl), { 0.2, 0.6, 1 })
	local elite_shield_wgt = table_multiply(clone(special_wgt_tbl), { 0, 0.4, 0.8 })
	local elite_tank_wgt = table_multiply(clone(special_wgt_tbl), { 0, 0, 0.2 })

	-- Spawngroups
	if difficulty_index <= 2 then
		self.besiege.assault.groups = {
			cs_cops = { 18, 9, 0 },
			cs_swats = { 24, 26, 30 },
			cs_heavies = { 6, 12, 18 },
			cs_shield = shield_wgt,
			cs_taser = taser_wgt,
		}
		self.besiege.recon.groups = {
			cs_stealth_init = { 12, 6, 0 },
			cs_stealth_light = { 0, 8, 16 },
			cs_stealth_heavy = { 0, 4, 8 },
		}
		self.besiege.reenforce.groups = {
			cs_defend_init = { 16, 8, 0 },
			cs_defend_light = { 8, 12, 16 },
		}
	elseif difficulty_index == 3 then
		self.besiege.assault.groups = {
			cs_cops = { 18, 9, 0 },
			cs_swats = { 24, 27, 30 },
			cs_heavies = { 6, 12, 18 },
			cs_shield = shield_wgt,
			cs_taser = taser_wgt,
			cs_bulldozer = tank_wgt,
		}
		self.besiege.recon.groups = {
			cs_stealth_init = { 12, 6, 0 },
			cs_stealth_light = { 0, 8, 16 },
			cs_stealth_heavy = { 0, 4, 8 },
		}
		self.besiege.reenforce.groups = {
			cs_defend_init = { 16, 8, 0 },
			cs_defend_light = { 8, 12, 16 },
			cs_defend_heavy = { 0, 4, 8 },
		}
	elseif difficulty_index == 4 then
		self.besiege.assault.groups = {
			cs_swats = { 24, 12, 0 },
			fbi_swats = { 16, 24, 30 },
			fbi_heavies = { 6, 12, 18 },
			fbi_shield = shield_wgt,
			fbi_taser = taser_wgt,
			fbi_cloaker = spook_wgt,
			fbi_bulldozer = tank_wgt,
		}
		self.besiege.recon.groups = {
			fbi_stealth_init = { 12, 6, 0 },
			fbi_stealth_light = { 0, 8, 16 },
			fbi_stealth_heavy = { 0, 4, 8 },
		}
		self.besiege.reenforce.groups = {
			cs_defend_init = { 15, 0, 0 },
			cs_defend_light = { 10, 20, 0 },
			cs_defend_heavy = { 5, 10, 0 },
			fbi_defend_init = { 20, 10, 0 },
			fbi_defend_light = { 0, 10, 30 },
			fbi_defend_heavy = { 0, 5, 15 },
		}
	elseif difficulty_index == 5 then
		self.besiege.assault.groups = {
			cs_swats = { 16, 8, 0 },
			fbi_swats = { 24, 24, 24 },
			fbi_heavies = { 8, 16, 24 },
			fbi_shield = shield_wgt,
			fbi_taser = taser_wgt,
			fbi_cloaker = spook_wgt,
			fbi_bulldozer = tank_wgt,
		}
		self.besiege.recon.groups = {
			fbi_stealth_init = { 12, 6, 0 },
			fbi_stealth_light = { 8, 12, 16 },
			fbi_stealth_heavy = { 0, 4, 8 },
		}
		self.besiege.reenforce.groups = {
			cs_defend_init = { 12, 0, 0 },
			cs_defend_light = { 8, 16, 0 },
			cs_defend_heavy = { 8, 12, 0 },
			fbi_defend_init = { 16, 12, 0 },
			fbi_defend_light = { 0, 12, 24 },
			fbi_defend_heavy = { 0, 8, 24 },
		}
	else
		self.besiege.assault.groups = {
			fbi_swats = { 12, 6, 0 },
			elite_swats = { 24, 24, 24 },
			fbi_heavies = { 12, 18, 24 },
			fbi_shield = shield_wgt,
			elite_sniper = elite_sniper_wgt,
			elite_taser = taser_wgt,
			fbi_cloaker = spook_wgt,
			elite_shield = elite_shield_wgt,
			fbi_bulldozer = tank_wgt,
			elite_bulldozer = elite_tank_wgt,
		}
		self.besiege.recon.groups = {
			fbi_stealth_init = { 12, 6, 0 },
			fbi_stealth_light = { 8, 12, 16 },
			fbi_stealth_heavy = { 0, 4, 8 },
		}
		self.besiege.reenforce.groups = {
			cs_defend_init = { 8, 0, 0 },
			cs_defend_light = { 16, 8, 0 },
			cs_defend_heavy = { 12, 6, 0 },
			fbi_defend_init = { 12, 6, 0 },
			fbi_defend_light = { 8, 16, 0 },
			fbi_defend_heavy = { 0, 8, 24 },
			elite_defend_light = { 0, 8, 24 },
		}
	end

	self.besiege.cloaker.groups = {
		single_spooc = { 1, 1, 1 },
	}

	-- New data for the reworked Cloaker task
	self.use_reworked_cloaker_task = true
	self.besiege.cloaker.interval_min = get_difficulty_specific_value({
		{ 60, 67.5, 75 },
		{ 60, 67.5, 75 },
		{ 40, 45, 50 },
		{ 30, 33.75, 37.5 },
		{ 20, 22.5, 25 },
	})
	self.besiege.cloaker.interval_max = get_difficulty_specific_value({
		{ 120, 135, 150 },
		{ 120, 135, 150 },
		{ 60, 67.5, 75 },
		{ 50, 56.25, 62.5 },
		{ 40, 45, 50 },
	})
	self.besiege.cloaker.group_removed_delay_t = {
		0,
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
	self.besiege.cloaker.SO_weighting = {
		near_distance = 1000,
		far_distance = 3000,
		far_chance_mul = 0.1,
		too_far_distance = 5000,
		too_close_distance = 1000,
		-- Values not finalized
		z_near_distance = 300,
		z_far_distance = 1200,
		z_far_chance_mul = 0.25,
	}
	self.besiege.cloaker.repeat_hiding_spots = {
		avoid = true,
		min_elements = 3,
		min_distance = 1500,
	}
	self.besiege.cloaker.simultaneous_hiding_limit = 2
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

		-- FBI-tier
		"fbi_defend_init",
		"fbi_defend_light",
		"fbi_defend_heavy",
		"fbi_stealth_init",
		"fbi_stealth_light",
		"fbi_stealth_heavy",

		-- Elite-tier
		"elite_defend_light",
		"elite_defend_heavy",

		-- Other hiding Cloakers
		"single_spooc",

		-- Event bosses
		"snowman_boss",
		"piggydozer",

		-- Good game design
		"Phalanx",
		"marshal_squad",

		-- Scripted spawns
		"custom",
		"custom_assault",
		"custom_recon",

		-- Timed groups
		"bellmead_timed_group",
		"fbi_timed_group",
		"gensec_timed_group",
		"murkywater_timed_group",
		"army_timed_group",
	})
	self.besiege.recurring_group_SO.recurring_cloaker_spawn.interval = {
		self.besiege.cloaker.interval_min[1],
		self.besiege.cloaker.interval_max[1],
	}

	self.besiege.assault.groups.single_spooc = empty_tbl
	self.besiege.assault.groups.Phalanx = empty_tbl
	self.besiege.assault.groups.marshal_squad = empty_tbl
	self.besiege.assault.groups.custom = empty_tbl
	self.besiege.assault.groups.custom_assault = empty_tbl
	self.besiege.assault.groups.snowman_boss = empty_tbl
	self.besiege.assault.groups.piggydozer = empty_tbl
	-- timed groups
	self.besiege.assault.groups.bellmead_group1 = empty_tbl
	self.besiege.assault.groups.fbi_group1 = empty_tbl
	self.besiege.assault.groups.gensec_group1 = empty_tbl
	self.besiege.assault.groups.murky_group1 = empty_tbl
	self.besiege.assault.groups.murky_scripted_group1 = empty_tbl
	self.besiege.assault.groups.us_group1 = empty_tbl
	self.besiege.assault.groups.us_scripted_group1 = empty_tbl

	self.besiege.recon.groups.single_spooc = empty_tbl
	self.besiege.recon.groups.Phalanx = empty_tbl
	self.besiege.recon.groups.marshal_squad = empty_tbl
	self.besiege.recon.groups.custom = empty_tbl
	self.besiege.recon.groups.custom_recon = empty_tbl
	self.besiege.recon.groups.snowman_boss = empty_tbl
	self.besiege.recon.groups.piggydozer = empty_tbl
	-- timed groups
	self.besiege.recon.groups.bellmead_group1 = empty_tbl
	self.besiege.recon.groups.fbi_group1 = empty_tbl
	self.besiege.recon.groups.gensec_group1 = empty_tbl
	self.besiege.recon.groups.murky_group1 = empty_tbl
	self.besiege.recon.groups.murky_scripted_group1 = empty_tbl
	self.besiege.recon.groups.us_group1 = empty_tbl
	self.besiege.recon.groups.us_scripted_group1 = empty_tbl

	-- PONR --
	self.ponr = deep_clone(self.besiege)
	self.ponr.drama_gain_mul = { 0.5, 0.5, 0.5 }

	-- Control
	if short_ponr_heists[level_id] then
		self.ponr.assault.delay = { 10, 10, 10 }
		self.ponr.assault.hostage_hesitation_delay = empty_tbl
	end

	-- Push delay
	self.ponr.assault.push_delay = get_difficulty_specific_value({
		{ 10, 10, 10 },
		{ 10, 10, 10 },
		{ 8, 8, 8 },
		{ 8, 8, 8 },
		{ 6, 6, 6 },
	})

	-- Recon
	self.ponr.recon.force = empty_tbl -- no recon after ponr ran out

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
		8,
		9,
		10,
		11,
		12,
	})
	local ponr_special_wgt_tbl = { ponr_special_wgt, ponr_special_wgt, ponr_special_wgt }
	local ponr_shield_wgt = table_multiply(clone(ponr_special_wgt_tbl), 1)
	local ponr_taser_wgt = table_multiply(clone(ponr_special_wgt_tbl), 0.8)
	local ponr_spook_wgt = table_multiply(clone(ponr_special_wgt_tbl), 0.6)
	local ponr_sniper_wgt = table_multiply(clone(ponr_special_wgt_tbl), 0.5)
	local ponr_elite_shield_wgt = table_multiply(clone(ponr_special_wgt_tbl), 0.5)
	local ponr_tank_wgt = table_multiply(clone(ponr_special_wgt_tbl), 0.4)
	local ponr_elite_tank_wgt = table_multiply(clone(ponr_special_wgt_tbl), 0.2)

	-- Spawngroups
	if difficulty_index <= 3 then
		self.ponr.assault.groups = {
			fbi_swats = { 18, 18, 18 },
			fbi_heavies = { 18, 18, 18 },
			fbi_shield = ponr_shield_wgt,
			fbi_taser = ponr_taser_wgt,
			fbi_cloaker = ponr_spook_wgt,
			fbi_bulldozer = ponr_tank_wgt,
		}
		self.ponr.reenforce.groups = {
			fbi_defend_light = { 1, 1, 1 },
			fbi_defend_heavy = { 1, 1, 1 },
		}
	elseif difficulty_index <= 5 then
		self.ponr.assault.groups = {
			elite_swats = { 18, 18, 18 },
			fbi_heavies = { 18, 18, 18 },
			fbi_shield = ponr_shield_wgt,
			elite_shield = ponr_elite_shield_wgt,
			elite_sniper = ponr_sniper_wgt,
			elite_taser = ponr_taser_wgt,
			fbi_cloaker = ponr_spook_wgt,
			fbi_bulldozer = ponr_tank_wgt,
			elite_bulldozer = ponr_elite_tank_wgt,
		}
		self.ponr.reenforce.groups = {
			elite_defend_light = { 1, 1, 1 },
			fbi_defend_heavy = { 1, 1, 1 },
		}
	else
		self.ponr.assault.groups = {
			elite_swats = { 18, 18, 18 },
			elite_heavies = { 18, 18, 18 },
			elite_shield = ponr_shield_wgt,
			elite_sniper = ponr_sniper_wgt,
			elite_taser = ponr_taser_wgt,
			fbi_cloaker = ponr_spook_wgt,
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

	-- Add various groups to assault and recon group tables that don't spawn normally but need to be able to participate
	local function add_groups_as_empty(groups, junk_groups)
		for _, group in ipairs(junk_groups) do
			groups[group] = groups[group] or empty_tbl
		end
	end

	local junk_groups = {
		"single_spooc",
		"Phalanx",
		"marshal_squad",
		"custom_assault",
		"custom",
		"snowman_boss",
		"piggydozer",

		-- Timed groups
		"bellmead_timed_group",
		"fbi_timed_group",
		"gensec_timed_group",
		"murkywater_timed_group",
		"army_timed_group",

		-- Reinforce groups
		"cs_defend_init",
		"cs_defend_light",
		"cs_defend_heavy",
		"fbi_defend_init",
		"fbi_defend_light",
		"fbi_defend_heavy",
		"elite_defend_light",
		"elite_defend_heavy",
	}
	add_groups_as_empty(self.besiege.assault.groups, junk_groups)
	add_groups_as_empty(self.ponr.assault.groups, junk_groups)

	local custom_assault_i = table.get_vector_index(junk_groups, "custom_assault")
	if custom_assault_i then
		junk_groups[custom_assault_i] = "custom_recon"
	end
	add_groups_as_empty(self.besiege.recon.groups, junk_groups)
	add_groups_as_empty(self.ponr.recon.groups, junk_groups)

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

function GroupAITweakData:_apply_group_ai_preset(preset)
	if not preset then
		return
	end

	local preset_settings = self.group_ai_presets[preset]

	if not preset_settings then
		return
	end

	for _, group_ai_state in pairs(group_ai_state_names) do
		if self[group_ai_state] then
			for _, task in pairs(self[group_ai_state]) do
				if type(task) == "table" and type(task.groups) == "table" then
					for group_name, group_weights in pairs(task.groups) do
						local mul = preset_settings[group_name]

						if mul then
							table_multiply(group_weights, mul)
						end
					end
				end
			end
		end
	end
end

function GroupAITweakData:_apply_group_ai_settings_new(level_settings)
	self:_apply_group_ai_preset(self._mission_preset)

	local lvl_tweak = self.tweak_data.levels[level_id]

	if not lvl_tweak then
		return
	end

	local function apply_difficulty_scaling(tbl)
		if not tbl then
			return
		end
		for key, value in pairs(tbl) do
			if key == "steps" then
				self.difficulty_scaling.steps = value
			elseif self.difficulty_scaling[key] then
				for category, data in pairs(value) do
					self.difficulty_scaling[key][category] = data
				end
			end
		end
	end

	apply_difficulty_scaling(self.difficulty_scaling_presets[lvl_tweak.difficulty_scaling_preset])

	local function apply_force(tbl)
		if not tbl then
			return
		end
		for _, group_ai_state in pairs(group_ai_state_names) do
			for key, value in pairs(tbl) do
				if self[group_ai_state] and self[group_ai_state][key] and self[group_ai_state][key].force and value ~= 1 then
					table_multiply(self[group_ai_state][key].force, value)
				end
			end
		end
	end

	apply_force(self.force_size_presets[lvl_tweak.force_size_preset])

	if not level_settings then
		return
	end

	apply_difficulty_scaling(level_settings.difficulty_scaling_mod)

	self:_apply_tactics_mod(level_settings.tactics_mod)
	self:_apply_special_limit_mod(level_settings.special_limit_mod)
	self:_apply_task_data_mod(level_settings.task_data_mod)
end

local function modify_groupai_value(value, modifier, mode)
	if not mode then
		return
	end
	if type(value) == "table" then
		local mode_func = Eclipse.utils["table_" .. mode]
		if mode_func then
			return mode_func(value, modifier)
		else
			Eclipse:warn_console("Mode func is nil")
		end
	elseif mode == "replace" then
		return modifier
	elseif tonumber(value) then
		if mode == "multiply" then
			return value * modifier
		elseif mode == "add" then
			return value + modifier
		elseif mode == "subtract" then
			return math.max(0, value - modifier)
		end
	end
	return value
end

local function validate_groupai_mod_entry(i, entry, typ)
	if not entry.tweak or not entry.value then
		Eclipse:error_console("Skipping malformed %s entry at index %u", typ, i)
		return
	elseif type(entry.value) ~= "table" then
		Eclipse:warn_console("%s entry value %s at index %u was not a table", typ, tostring(entry.value), i)
		entry.value = { entry.value }
	end
	local keys = clone(entry.value)
	local final_key = table.remove(keys)
	if final_key == nil then
		Eclipse:error_console("%s entry value at index %u was empty", typ, i)
		return
	end
	return keys, final_key
end

function GroupAITweakData:_apply_tactics_mod(special_limit_settings)
	if not special_limit_settings then
		return
	end

	for i, entry in ipairs(special_limit_settings) do
		local keys, final_key = validate_groupai_mod_entry(i, entry, "tactics_mod")
		if not keys then
			goto __continue_tactics_mod
		end
		local group_ai_value = access_table(self, unpack(keys))
		if group_ai_value and group_ai_value[final_key] and type(group_ai_value[final_key]) == "table" then
			local tactics_table = deep_clone(group_ai_value[final_key])

			for tactic, add in pairs(entry.tweak) do
				if add and not table.contains(tactics_table, tactic) then
					table.insert(tactics_table, tactic)

					Eclipse:log_console("Added " .. tactic .. " to: " .. final_key)
				elseif not add and table.contains(tactics_table, tactic) then
					table.delete(tactics_table, tactic)

					Eclipse:log_console("Removed " .. tactic .. " from: " .. final_key)
				end
			end

			group_ai_value[final_key] = tactics_table
		end
		::__continue_tactics_mod::
	end
end

-- In a separate function so as to keep the "no changes if base special limit is 0" rule, at least for now
-- Does not apply for modifications to FFO special limit add
function GroupAITweakData:_apply_special_limit_mod(special_limit_settings)
	if not special_limit_settings then
		return
	end

	for i, entry in ipairs(special_limit_settings) do
		local keys, final_key = validate_groupai_mod_entry(i, entry, "special_limit_mod")
		if not keys then
			goto __continue_special_limit_mod
		end
		local group_ai_value = access_table(self, unpack(keys))
		if group_ai_value and group_ai_value[final_key] and (keys[1] ~= "special_unit_spawn_limits" or group_ai_value[final_key] > 0) then
			group_ai_value[final_key] = modify_groupai_value(group_ai_value[final_key], entry.tweak.modifier, entry.tweak.mode)
		end
		::__continue_special_limit_mod::
	end
end

function GroupAITweakData:_apply_task_data_mod(task_data_settings)
	if not task_data_settings then
		return
	end

	for i, entry in ipairs(task_data_settings) do
		local keys, final_key = validate_groupai_mod_entry(i, entry, "task_data_mod")
		if not keys then
			goto __continue_task_data_mod
		end
		local group_ai_value
		if entry.groupai_state == "all" then
			for _, group_ai_state in pairs(group_ai_state_names) do
				group_ai_value = access_table(self[group_ai_state], unpack(keys))
				if group_ai_value then
					group_ai_value[final_key] = modify_groupai_value(group_ai_value[final_key], entry.tweak.modifier, entry.tweak.mode)

					Eclipse:log_console(entry.tweak.mode .. " " .. tostring(entry.tweak.modifier) .. " for " .. entry.value[#entry.value] .. " in " .. group_ai_state)
				end
			end
		elseif entry.groupai_state == "none" then
			group_ai_value = access_table(self, unpack(keys))
			if group_ai_value then
				group_ai_value[final_key] = modify_groupai_value(group_ai_value[final_key], entry.tweak.modifier, entry.tweak.mode)

				Eclipse:log_console(entry.tweak.mode .. " " .. tostring(entry.tweak.modifier) .. " for " .. entry.value[#entry.value])
			end
		elseif entry.groupai_state ~= nil then
			group_ai_value = access_table(self[entry.groupai_state], unpack(keys))
			if group_ai_value then
				group_ai_value[final_key] = modify_groupai_value(group_ai_value[final_key], entry.tweak.modifier, entry.tweak.mode)

				Eclipse:log_console(entry.tweak.mode .. " " .. tostring(entry.tweak.modifier) .. " for " .. entry.value[#entry.value])
			end
		end
		::__continue_task_data_mod::
	end
end
