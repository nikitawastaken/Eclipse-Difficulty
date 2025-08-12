local level_id = Eclipse.utils.level_id()
local diff_i = Eclipse.utils.difficulty_index()
local is_overkill = Eclipse.utils.is_overkill()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()

local function diff_lerp(value_1, value_2)
	return Eclipse.utils.diff_lerp(value_1, value_2)
end

local function table_multiplier(target_table, mul)
	for diff_step, value in pairs(target_table) do
		target_table[diff_step] = value * mul
	end

	return target_table
end

local function group_weight_multiplier(group_weights, mul)
	for diff_step, weight in pairs(group_weights) do
		group_weights[diff_step] = weight * mul[diff_step]
	end
end

GroupAITweakData.group_ai_presets = {
	["small_urban"] = {
		cs_cops = { 1.5, 1, 1 },

		cs_heavies = { 0, 0, 0.75 },
		fbi_heavies = { 0, 0, 0.75 },
		elite_heavies = { 0, 0, 0.75 },

		cs_bulldozer = { 0, 0, 0.75 },
		fbi_bulldozer = { 0, 0, 0.75 },
		elite_bulldozer = { 0, 0, 0.75 },
		elite_bulldozer_shield = { 0, 0, 0.75 },
		elite_bulldozer_takedown = { 0, 0, 0.75 },

		cs_defend_init = { 2, 1, 1 },
		fbi_defend_init = { 1.5, 1, 1 },

		cs_defend_light = { 0, 0.5, 1 },
		fbi_defend_light = { 0, 0.5, 1 },
		elite_defend_light = { 0, 0.5, 1 },

		cs_defend_heavy = { 0, 0, 0.5 },
		fbi_defend_heavy = { 0, 0, 0.5 },
		elite_defend_heavy = { 0, 0, 0.5 },
	},
	["heavy_response"] = {
		cs_cops = { 0.25, 0, 0 },

		cs_defend_init = { 0.25, 0, 0 },
		fbi_defend_init = { 0.5, 0, 0 },

		cs_stealth_light = { 1, 0.5, 0 },
		fbi_stealth_light = { 1, 0.5, 0 },
	},
	["remote"] = {
		cs_cops = { 0.25, 0, 0 },

		cs_defend_init = { 0.25, 0, 0 },
		fbi_defend_init = { 0.5, 0, 0 },

		cs_stealth_light = { 1, 0.5, 0 },
		fbi_stealth_light = { 1, 0.5, 0 },
	},
	["skyscraper"] = {
		cs_shield = { 0, 0.75, 1 },
		fbi_shield = { 0, 0.75, 1 },
		elite_shield = { 0, 0.75, 1 },

		fbi_cloaker = { 1.25, 1.25, 1.25 },

		cs_defend_init = { 0.25, 0, 0 },
		fbi_defend_init = { 0.5, 0, 0 },

		cs_stealth_light = { 1, 0.5, 0 },
		fbi_stealth_light = { 1, 0.5, 0 },
	},
}

-- Helper function for Group AI presets
function GroupAITweakData:_apply_group_ai_preset(preset)
	local preset_settings = self.group_ai_presets[preset]

	if not preset_settings then
		return
	end

	for _, group_ai_state_name in pairs({ "besiege", "street", "safehouse", "ponr" }) do
		for _, assault_state in pairs(self[group_ai_state_name]) do
			if type(assault_state) == "table" and type(assault_state.groups) == "table" then
				for group_name, group_weights in pairs(assault_state.groups) do
					local weight_muls = preset_settings[group_name]

					if weight_muls then
						group_weight_multiplier(group_weights, weight_muls)

						Eclipse:log_console("Weight multipliers for " .. group_name .. " set to: ")
						Utils.PrintTable(group_weights)
					end
				end
			end
		end
	end
end

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
Hooks:PostHook(GroupAITweakData, "init", "eclipse_groupaitd_init", function(self, tweak_data)
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
	self.enemy_chatter.jammer = clone(self.enemy_chatter.aggressive)
	self.enemy_chatter.jammer.queue = "ch3"
	self.enemy_chatter.jammer.radius = radius_medium
	self.enemy_chatter.saw = clone(self.enemy_chatter.sentry_gun)
	self.enemy_chatter.saw.queue = "ch4"

	-- Stealth chatter
	self.enemy_chatter.idle = clone(self.enemy_chatter.go_go)
	self.enemy_chatter.idle.queue = "a06"
	self.enemy_chatter.idle.duration = duration_long
	self.enemy_chatter.idle.radius = radius_large
	self.enemy_chatter.report = clone(self.enemy_chatter.idle)
	self.enemy_chatter.report.queue = "a05"
end)

Hooks:PostHook(GroupAITweakData, "_init_unit_categories", "eclipse__init_unit_categories", function(self, difficulty_index)
	if difficulty_index then
		Eclipse:log_console("Difficulty index is " .. difficulty_index)
	end

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
	elseif difficulty_index == 4 then
		self.special_unit_spawn_limits = {
			shield = 3,
			taser = 1,
			tank = 1,
			spooc = 2,
			medic = 2,
			marksman = 0,
		}
	elseif difficulty_index == 5 then
		self.special_unit_spawn_limits = {
			shield = 4,
			taser = 2,
			tank = 1,
			spooc = 2,
			medic = 3,
			marksman = 0,
		}
	elseif difficulty_index == 6 then
		self.special_unit_spawn_limits = {
			shield = 5,
			taser = 3,
			tank = 2,
			spooc = 3,
			medic = 4,
			marksman = 3,
		}
	end

	self.unit_categories.cs_cop_1 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_cop_1/ene_cop_1") },
			russia = { Idstring("units/payday2/characters/ene_cop_1/ene_cop_1") },
			zombie = { Idstring("units/payday2/characters/ene_cop_1/ene_cop_1") },
			murkywater = { Idstring("units/payday2/characters/ene_cop_1/ene_cop_1") },
			federales = { Idstring("units/payday2/characters/ene_cop_1/ene_cop_1") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.cs_cop_2 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_cop_2/ene_cop_2") },
			russia = { Idstring("units/payday2/characters/ene_cop_2/ene_cop_2") },
			zombie = { Idstring("units/payday2/characters/ene_cop_2/ene_cop_2") },
			murkywater = { Idstring("units/payday2/characters/ene_cop_2/ene_cop_2") },
			federales = { Idstring("units/payday2/characters/ene_cop_2/ene_cop_2") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.cs_cop_3 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_cop_3/ene_cop_3") },
			russia = { Idstring("units/payday2/characters/ene_cop_3/ene_cop_3") },
			zombie = { Idstring("units/payday2/characters/ene_cop_3/ene_cop_3") },
			murkywater = { Idstring("units/payday2/characters/ene_cop_3/ene_cop_3") },
			federales = { Idstring("units/payday2/characters/ene_cop_3/ene_cop_3") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.cs_cop_4 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_cop_4/ene_cop_4") },
			russia = { Idstring("units/payday2/characters/ene_cop_4/ene_cop_4") },
			zombie = { Idstring("units/payday2/characters/ene_cop_4/ene_cop_4") },
			murkywater = { Idstring("units/payday2/characters/ene_cop_4/ene_cop_4") },
			federales = { Idstring("units/payday2/characters/ene_cop_4/ene_cop_4") },
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
				Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
				Idstring("units/payday2/characters/ene_cop_2/ene_cop_2"),
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
				Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
				Idstring("units/payday2/characters/ene_cop_4/ene_cop_4"),
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
				Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
				Idstring("units/payday2/characters/ene_cop_4/ene_cop_4"),
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
				Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
				Idstring("units/payday2/characters/ene_cop_2/ene_cop_2"),
				Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
				Idstring("units/payday2/characters/ene_cop_4/ene_cop_4"),
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
			federales = { Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.fbi_agent_2 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2") },
			russia = { Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2") },
			zombie = { Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2") },
			murkywater = { Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2") },
			federales = { Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.fbi_agent_3 = {
		unit_types = {
			america = { Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3") },
			russia = { Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3") },
			zombie = { Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3") },
			murkywater = { Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3") },
			federales = { Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3") },
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
				Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
				Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
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
				Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
				Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3"),
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
		access = access_type_walk_only
	}
	
	self.unit_categories.piggydozer = {
		unit_types = {
			america = { Idstring("units/pd2_dlc_pda10/characters/ene_dozer_piggy/ene_dozer_piggy") },
			russia = { Idstring("units/pd2_dlc_cg22/characters/ene_snowman_boss/ene_snowman_boss") },
			zombie = { Idstring("units/pd2_dlc_cg22/characters/ene_snowman_boss/ene_snowman_boss") },
			murkywater = { Idstring("units/pd2_dlc_cg22/characters/ene_snowman_boss/ene_snowman_boss") },
			federales = { Idstring("units/pd2_dlc_cg22/characters/ene_snowman_boss/ene_snowman_boss") },
		},
		access = access_type_walk_only
	}
	
end)

Hooks:PostHook(GroupAITweakData, "_init_enemy_spawn_groups", "eclipse__init_enemy_spawn_groups", function(self, difficulty_index)
	local small_urban = self._mission_settings and self._mission_settings.small_urban
	local heavy_response = self._mission_settings and self._mission_settings.heavy_response
	local skyscraper = self._mission_settings and self._mission_settings.skyscraper

	self._tactics = {
		none = {},
		cop_init = {
			"no_push",
		},
		cop_def = {
			"ranged_fire",
			"no_push",
		},
		hrt_def = {
			"rescue",
			"ranged_fire",
			"flank",
		},
		hrt_snk = {
			"rescue",
			"flank",
		},
		swat_init = {
			"rescue",
			"ranged_fire",
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
		swat_support = {
			"ranged_fire",
			"unit_cover",
		},
		shield_wall = {
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
		shield_support = {
			"shield_cover",
		},
		taser_snk = {
			"murder",
			"flank",
		},
		taser_agg = {
			"murder",
			"charge",
		},
		taser_support = {
			"murder",
		},
		bulldozer_def = {
			"shield",
			"door_ambush",
			"murder",
		},
		bulldozer_agg = {
			"shield",
			"murder",
			"charge",
		},
		bulldozer_support = {
			"shield_cover",
			"smoke_grenade",
			"flash_grenade",
		},
		cloaker_def = {
			"no_push",
		},
		cloaker_agg = {
			"flank",
			"charge",
		},
		cloaker_support = {
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

	-- соси хуй кк?
	self.enemy_spawn_groups = {}

	local medic_cloaker = { 
		["medic_1"] = 2,
		["medic_2"] = 1,
		["cloaker"] = 1,
	}
	local medic_taser = { 
		["medic_1"] = 4,
		["medic_2"] = 2,
		["taser_1"] = 2,
		["taser_2"] = 1,
	}
	local taser_cloaker = { "taser_1", "cloaker" }

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
				freq_by_diff = table_multiplier({
					15 / (difficulty_index ^ 2),
					0,
					0,
				}, heavy_response and 0.25 or 1),
				amount_max = 1,
				freq = 1,
				rank = 1,
				unit = "cs_cop_3",
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
				freq_by_diff = table_multiplier({
					6 / (difficulty_index ^ 2),
					4 / (difficulty_index ^ 2),
					2 / (difficulty_index ^ 2),
				}, heavy_response and 0.5 or 1),
				amount_max = 1,
				freq = 1,
				rank = 1,
				unit = "cs_swat_1_3",
				tactics = self._tactics.none,
			},
		},
	}

	self.enemy_spawn_groups.cs_stealth_light = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 1,
				rank = 1,
				unit = "cs_cop_1",
				tactics = self._tactics.hrt_def,
			},
		},
	}

	self.enemy_spawn_groups.cs_stealth_heavy = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 1,
				rank = 1,
				unit = "cs_cop_3",
				tactics = self._tactics.hrt_snk,
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
				tactics = self._tactics.cop_def,
			},
		},
	}

	self.enemy_spawn_groups.cs_swats = {
		amount = { 3, 4 },
		spawn = {
			{
				freq_by_diff = table_multiplier({
					1.5,
					0.5,
					0,
				}, heavy_response and 0.25 or small_urban and 1.5 or 1),
				amount_max = 3,
				rank = 1,
				unit = "cs_swat",
				tactics = self._tactics.swat_init,
			},
			{
				freq = 0.75,
				amount_max = 2,
				rank = 2,
				unit = "cs_swat_2",
				tactics = self._tactics.swat_agg,
			},
			{
				freq = 0.75,
				amount_max = 2,
				rank = 2,
				unit = "cs_swat_3",
				tactics = self._tactics.swat_snk,
			},
			{
				freq = 1,
				amount_min = 1,
				amount_max = 2,
				rank = 2,
				unit = "cs_swat_1",
				tactics = self._tactics.swat_def,
			},
		},
	}

	self.enemy_spawn_groups.cs_heavies = {
		amount = { 3, 4 },
		spawn = {
			{
				freq = 0.75,
				amount_max = 2,
				rank = 2,
				unit = "cs_heavy_2",
				tactics = self._tactics.swat_agg,
			},
			{
				freq = 0.75,
				amount_max = 2,
				rank = 2,
				unit = "cs_heavy_1",
				tactics = self._tactics.swat_snk,
			},
			{
				freq = 1,
				amount_min = 1,
				amount_max = 2,
				rank = 2,
				unit = "cs_heavy_1",
				tactics = self._tactics.swat_def,
			},
			{
				freq_by_diff = table_multiplier({
					6 / (difficulty_index ^ 2),
					4 / (difficulty_index ^ 2),
					2 / (difficulty_index ^ 2),
				}, heavy_response and 0.5 or 1),
				amount_max = 2,
				rank = 1,
				unit = "cs_swat_1_3",
				tactics = self._tactics.swat_support,
			},
		},
	}

	self.enemy_spawn_groups.cs_shield = {
		amount = { 4, 4 },
		spawn = {
			{
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				rank = 3,
				unit = "cs_shield",
				random_tactics = self._random_tactics.shield,
			},
			{
				freq_by_diff = table_multiplier({
					18 / (difficulty_index ^ 2),
					12 / (difficulty_index ^ 2),
					6 / (difficulty_index ^ 2),
				}, heavy_response and 0.25 or 1),
				rank = 2,
				unit = "cs_swat",
				tactics = self._tactics.shield_support,
			},
			{
				freq = 1,
				rank = 2,
				unit = "cs_heavy",
				tactics = self._tactics.shield_support,
			},
			{
				freq_by_diff = table_multiplier({
					12 / (difficulty_index ^ 2),
					6 / (difficulty_index ^ 2),
					0,
				}, heavy_response and 0.25 or 1),
				rank = 1,
				unit = "cs_cop_3",
				tactics = self._tactics.shield_support,
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
				random_tactics = self._random_tactics.taser,
			},
			{
				freq = 1,
				rank = 1,
				unit = "cs_swat",
				tactics = self._tactics.taser_support,
			},
		},
	}

	self.enemy_spawn_groups.cs_bulldozer = {
		amount = { 3, 4 },
		spawn = {
			{
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				rank = 3,
				unit = "bulldozer_1",
				random_tactics = self._random_tactics.bulldozer,
			},
			{
				freq = 0.75,
				amount_min = 2,
				rank = 2,
				unit = "cs_heavy",
				tactics = self._tactics.bulldozer_support,
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
				freq_by_diff = table_multiplier({
					36 / (difficulty_index ^ 2),
					0,
					0,
				}, heavy_response and 0.25 or small_urban and 1.5 or 1),
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
				freq_by_diff = table_multiplier({
					30 / (difficulty_index ^ 2),
					0,
					0,
				}, heavy_response and 0.25 or 1),
				amount_max = 1,
				freq = 1,
				rank = 1,
				unit = "fbi_agent_3",
				tactics = self._tactics.none,
			},
			self:_distance_weighted_spawn_entry({
				freq_by_diff = table_multiplier({
					0,
					(difficulty_index ^ 2) / 480,
					(difficulty_index ^ 2) / 240,
				}, skyscraper and 1.25 or 1),
				amount_max = 1,
				rank = 1,
				unit = "cloaker",
				tactics = self._tactics.cloaker_support,
			}, 1000, 3000, 3, 1),
			self:_distance_weighted_spawn_entry({
				freq_by_diff = table_multiplier({
					0,
					(difficulty_index ^ 2) / 480,
					(difficulty_index ^ 2) / 240,
				}, small_urban and 0.75 or 1),
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
				tactics = self._tactics.none,
			},
			{
				freq = 1,
				amount_min = 1,
				rank = 2,
				unit = "fbi_heavy_1",
				tactics = self._tactics.none,
			},
			{
				freq_by_diff = table_multiplier({
					18 / (difficulty_index ^ 2),
					12 / (difficulty_index ^ 2),
					6 / (difficulty_index ^ 2),
				}, heavy_response and 0.5 or 1),
				amount_max = 1,
				rank = 1,
				unit = "fbi_swat_1_3",
				tactics = self._tactics.none,
			},
			self:_distance_weighted_spawn_entry({
				freq_by_diff = table_multiplier({
					0,
					(difficulty_index ^ 2) / 480,
					(difficulty_index ^ 2) / 240,
				}, heavy_response and 1.25 or 1),
				amount_max = 1,
				rank = 3,
				unit = "fbi_shield",
				tactics = self._tactics.shield_wall,
			}, 1000, 3000, 3, 1),
			self:_distance_weighted_spawn_entry({
				freq_by_diff = table_multiplier({
					0,
					(difficulty_index ^ 2) / 480,
					(difficulty_index ^ 2) / 240,
				}, small_urban and 0.75 or 1),
				amount_max = 1,
				rank = 1,
				unit = "elite_sniper",
				tactics = self._tactics.sniper,
			}, 1000, 3000, 1, 3),
		},
	}

	self.enemy_spawn_groups.fbi_stealth_light = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 1,
				rank = 1,
				unit = "fbi_agent_1_2",
				tactics = self._tactics.hrt_def,
			},
		},
	}

	self.enemy_spawn_groups.fbi_stealth_heavy = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 1,
				amount_min = 1,
				rank = 2,
				unit = "fbi_agent_3",
				tactics = self._tactics.hrt_snk,
			},
			{
				freq_by_diff = table_multiplier({
					0,
					(difficulty_index ^ 2) / 160,
					(difficulty_index ^ 2) / 80,
				}, skyscraper and 1.25 or 1),
				amount_max = 1,
				rank = 1,
				unit = "taser",
				random_unit = taser_cloaker,
				tactics = self._tactics.swat_support,
			},
		},
	}

	self.enemy_spawn_groups.fbi_swats = {
		amount = { 3, 4 },
		spawn = {
			{
				freq_by_diff = table_multiplier({
					1.5,
					0.5,
					0,
				}, heavy_response and 0.25 or small_urban and 1.5 or 1),
				amount_max = 3,
				rank = 2,
				unit = "fbi_swat",
				tactics = self._tactics.swat_init,
			},
			{
				freq = 0.75,
				amount_max = 2,
				rank = 3,
				unit = "fbi_swat_2",
				tactics = self._tactics.swat_agg,
			},
			{
				freq = 0.75,
				amount_max = 2,
				rank = 3,
				unit = "fbi_swat_3",
				tactics = self._tactics.swat_snk,
			},
			{
				freq = 1,
				amount_min = 1,
				amount_max = 2,
				rank = 3,
				unit = "fbi_swat_1",
				tactics = self._tactics.swat_def,
			},
			{
				freq_by_diff = table_multiplier({
					0,
					(difficulty_index ^ 2) / 120,
					(difficulty_index ^ 2) / 60,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				amount_max = 1,
				rank = 1,
				unit = "medic",
				random_unit = medic_cloaker,
				tactics = self._tactics.swat_support,
			},
		},
	}

	self.enemy_spawn_groups.fbi_heavies = {
		amount = { 3, 4 },
		spawn = {
			{
				freq = 0.75,
				amount_max = 2,
				rank = 3,
				unit = "fbi_heavy_2",
				tactics = self._tactics.swat_agg,
			},
			{
				freq = 0.75,
				amount_max = 2,
				rank = 3,
				unit = "fbi_heavy_1",
				tactics = self._tactics.swat_snk,
			},
			{
				freq = 1,
				amount_min = 1,
				amount_max = 2,
				rank = 3,
				unit = "fbi_heavy_1",
				tactics = self._tactics.swat_def,
			},
			{
				freq_by_diff = table_multiplier({
					18 / (difficulty_index ^ 2),
					12 / (difficulty_index ^ 2),
					6 / (difficulty_index ^ 2),
				}, heavy_response and 0.5 or 1),
				amount_max = 2,
				rank = 2,
				unit = "fbi_swat_1_3",
				tactics = self._tactics.swat_support,
			},
			{
				freq_by_diff = table_multiplier({
					0,
					(difficulty_index ^ 2) / 120,
					(difficulty_index ^ 2) / 60,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				amount_max = 1,
				rank = 1,
				unit = "medic",
				random_unit = medic_taser,
				tactics = self._tactics.swat_support,
			},
		},
	}

	self.enemy_spawn_groups.fbi_shield = {
		amount = { 4, 4 },
		spawn = {
			{
				freq = (difficulty_index ^ 2) / 80 * (heavy_response and 1.25 or small_urban and 0.5 or 1),
				amount_min = 1,
				amount_max = 2,
				rank = 3,
				unit = "fbi_shield",
				random_tactics = self._random_tactics.shield,
			},
			{
				freq_by_diff = table_multiplier({
					36 / (difficulty_index ^ 2),
					24 / (difficulty_index ^ 2),
					12 / (difficulty_index ^ 2),
				}, heavy_response and 0.25 or 1),
				rank = 2,
				unit = "fbi_swat",
				tactics = self._tactics.shield_support,
			},
			{
				freq = 1,
				rank = 2,
				unit = "fbi_heavy",
				tactics = self._tactics.shield_support,
			},
			{
				freq_by_diff = table_multiplier({
					24 / (difficulty_index ^ 2),
					12 / (difficulty_index ^ 2),
					0,
				}, heavy_response and 0.25 or 1),
				rank = 1,
				unit = "fbi_agent_3",
				tactics = self._tactics.shield_support,
			},
			{
				freq_by_diff = table_multiplier({
					0,
					(difficulty_index ^ 2) / 240,
					(difficulty_index ^ 2) / 120,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				amount_max = 1,
				rank = 1,
				unit = "medic",
				tactics = self._tactics.shield_support,
			},
		},
	}

	self.enemy_spawn_groups.fbi_taser = {
		amount = { 2, 4 },
		spawn = {
			{
				freq = (difficulty_index ^ 2) / 80 * (heavy_response and 1.25 or small_urban and 0.5 or 1),
				amount_min = 1,
				amount_max = 2,
				rank = 2,
				unit = "taser",
				random_tactics = self._random_tactics.taser,
			},
			{
				freq = 1,
				rank = 1,
				unit = "fbi_swat",
				tactics = self._tactics.taser_support,
			},
		},
	}

	self.enemy_spawn_groups.fbi_bulldozer = {
		amount = { 3, 4 },
		spawn = {
			{
				freq = (difficulty_index ^ 2) / 200 * (heavy_response and 1.25 or small_urban and 0.5 or 1),
				amount_min = 1,
				amount_max = 2,
				rank = 3,
				unit = "bulldozer",
				random_tactics = self._random_tactics.bulldozer,
			},
			{
				freq = 0.75,
				amount_min = 2,
				rank = 2,
				unit = "fbi_heavy",
				tactics = self._tactics.bulldozer_support,
			},
			{
				freq_by_diff = table_multiplier({
					0,
					(difficulty_index ^ 2) / 320,
					(difficulty_index ^ 2) / 160,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				amount_max = 1,
				rank = 1,
				unit = "medic",
				tactics = self._tactics.bulldozer_support,
			},
		},
	}

	self.enemy_spawn_groups.fbi_cloaker = {
		amount = skyscraper and { 2, 3 } or { 1, 2 },
		spawn = {
			{
				freq = 1,
				rank = 1,
				unit = "cloaker",
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
				freq_by_diff = table_multiplier({
					0,
					(difficulty_index ^ 2) / 480,
					(difficulty_index ^ 2) / 240,
				}, skyscraper and 1.25 or 1),
				amount_max = 1,
				rank = 1,
				unit = "cloaker",
				tactics = self._tactics.cloaker_support,
			}, 1000, 3000, 3, 1),
			self:_distance_weighted_spawn_entry({
				freq_by_diff = table_multiplier({
					0,
					(difficulty_index ^ 2) / 480,
					(difficulty_index ^ 2) / 240,
				}, small_urban and 0.75 or 1),
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
				rank = 3,
				unit = "elite_heavy_2",
				tactics = self._tactics.none,
			},
			{
				freq = 1,
				amount_min = 1,
				rank = 2,
				unit = "elite_heavy_1",
				tactics = self._tactics.none,
			},
			{
				freq_by_diff = table_multiplier({
					18 / (difficulty_index ^ 2),
					12 / (difficulty_index ^ 2),
					6 / (difficulty_index ^ 2),
				}, heavy_response and 0.5 or 1),
				amount_max = 1,
				rank = 1,
				unit = "elite_swat_1_3",
				tactics = self._tactics.none,
			},
			self:_distance_weighted_spawn_entry({
				freq_by_diff = table_multiplier({
					0,
					(difficulty_index ^ 2) / 480,
					(difficulty_index ^ 2) / 240,
				}, heavy_response and 1.25 or 1),
				amount_max = 1,
				rank = 4,
				unit = "fbi_shield",
				tactics = self._tactics.shield_wall,
			}, 1000, 3000, 3, 1),
			self:_distance_weighted_spawn_entry({
				freq_by_diff = table_multiplier({
					0,
					(difficulty_index ^ 2) / 480,
					(difficulty_index ^ 2) / 240,
				}, small_urban and 0.75 or 1),
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
				freq = 0.75,
				amount_max = 2,
				rank = 2,
				unit = "elite_swat_2",
				tactics = self._tactics.swat_agg,
			},
			{
				freq = 0.75,
				amount_max = 2,
				rank = 2,
				unit = "elite_swat_3",
				tactics = self._tactics.swat_snk,
			},
			{
				freq = 1,
				amount_min = 1,
				amount_max = 2,
				rank = 2,
				unit = "elite_swat_1",
				tactics = self._tactics.swat_def,
			},
			{
				freq_by_diff = table_multiplier({
					0,
					(difficulty_index ^ 2) / 120,
					(difficulty_index ^ 2) / 60,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				amount_max = 1,
				rank = 1,
				unit = "medic",
				random_unit = medic_cloaker,
				tactics = self._tactics.swat_support,
			},
		},
	}

	self.enemy_spawn_groups.elite_heavies = {
		amount = { 3, 4 },
		spawn = {
			{
				freq = 0.75,
				amount_max = 2,
				rank = 3,
				unit = "elite_heavy_2",
				tactics = self._tactics.swat_agg,
			},
			{
				freq = 0.75,
				amount_max = 2,
				rank = 3,
				unit = "elite_heavy_1",
				tactics = self._tactics.swat_snk,
			},
			{
				freq = 1,
				amount_min = 1,
				amount_max = 2,
				rank = 3,
				unit = "elite_heavy_1",
				tactics = self._tactics.swat_def,
			},
			{
				freq_by_diff = table_multiplier({
					18 / (difficulty_index ^ 2),
					12 / (difficulty_index ^ 2),
					6 / (difficulty_index ^ 2),
				}, heavy_response and 0.5 or 1),
				amount_max = 2,
				rank = 2,
				unit = "elite_swat_1_3",
				tactics = self._tactics.swat_support,
			},
			{
				freq_by_diff = table_multiplier({
					0,
					(difficulty_index ^ 2) / 120,
					(difficulty_index ^ 2) / 60,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				amount_max = 1,
				rank = 1,
				unit = "medic",
				random_unit = medic_taser,
				tactics = self._tactics.swat_support,
			},
		},
	}

	self.enemy_spawn_groups.elite_shield = {
		amount = { 4, 4 },
		spawn = {
			{
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				rank = 3,
				unit = "elite_shield",
				random_tactics = self._random_tactics.shield,
			},
			{
				freq = 1,
				rank = 2,
				unit = "elite_swat",
				tactics = self._tactics.shield_support,
			},
			{
				freq = 1,
				rank = 2,
				unit = "fbi_heavy",
				tactics = self._tactics.shield_support,
			},
			{
				freq_by_diff = table_multiplier({
					0,
					(difficulty_index ^ 2) / 240,
					(difficulty_index ^ 2) / 120,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				amount_max = 1,
				rank = 1,
				unit = "medic",
				tactics = self._tactics.shield_support,
			},
		},
	}

	self.enemy_spawn_groups.elite_taser = {
		amount = { 2, 4 },
		spawn = {
			{
				freq = (difficulty_index ^ 2) / 80 * (heavy_response and 1.25 or small_urban and 0.5 or 1),
				amount_min = 1,
				amount_max = 2,
				rank = 2,
				unit = "taser",
				random_tactics = self._random_tactics.taser,
			},
			{
				freq = 1,
				rank = 1,
				unit = "elite_swat",
				tactics = self._tactics.taser_support,
			},
		},
	}

	self.enemy_spawn_groups.elite_taser_takedown = {
		amount = { 2, 2 },
		spawn = {
			{
				freq = 1,
				amount_min = 1,
				rank = 2,
				unit = "taser",
				tactics = self._tactics.taser_snk,
			},
			{
				freq = 1,
				amount_min = 1,
				rank = 1,
				unit = "cloaker",
				tactics = self._tactics.cloaker_support,
			},
		},
	}

	self.enemy_spawn_groups.elite_bulldozer = {
		amount = { 3, 4 },
		spawn = {
			{
				freq = (difficulty_index ^ 2) / 200 * (heavy_response and 1.25 or small_urban and 0.5 or 1),
				amount_min = 1,
				amount_max = 2,
				rank = 3,
				unit = "elite_bulldozer",
				random_tactics = self._random_tactics.bulldozer,
			},
			{
				freq = 0.75,
				amount_min = 2,
				rank = 2,
				unit = "fbi_heavy",
				tactics = self._tactics.bulldozer_support,
			},
			{
				freq_by_diff = table_multiplier({
					0,
					(difficulty_index ^ 2) / 320,
					(difficulty_index ^ 2) / 160,
				}, heavy_response and 1.25 or small_urban and 0.75 or 1),
				amount_max = 1,
				rank = 1,
				unit = "medic",
				tactics = self._tactics.bulldozer_support,
			},
		},
	}

	self.enemy_spawn_groups.elite_bulldozer_takedown = {
		amount = { 2, 2 },
		spawn = {
			{
				freq = 1,
				rank = 2,
				unit = "bulldozer",
				random_tactics = self._random_tactics.bulldozer,
			},
			{
				freq = 0.75,
				rank = 2,
				unit = "elite_bulldozer",
				random_tactics = self._random_tactics.bulldozer,
			},
			{
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				rank = 1,
				unit = "taser",
				tactics = self._tactics.bulldozer_support,
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
				tactics = self._tactics.shield_wall,
			},
			{
				freq = 1,
				rank = 1,
				unit = "bulldozer",
				tactics = self._tactics.shield_support,
			},
			{
				freq = 0.5,
				rank = 1,
				unit = "elite_bulldozer",
				tactics = self._tactics.shield_support,
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
				random_tactics = self._random_tactics.cloaker,
			},
		},
	}

	self.enemy_spawn_groups.snowman_boss = {
		amount = { 1, 1 },
		spawn = {
			{
				freq = 1,
				amount_min = 1,
				rank = 1,
				unit = "snowman_boss",
				random_tactics = self._random_tactics.bulldozer,
			}
		},
		spawn_point_chk_ref = table.list_to_set({
			"cs_bulldozer",
		})
	}
	self.enemy_spawn_groups.piggydozer = {
		amount = { 1, 1 },
		spawn = {
			{
				freq = 1,
				amount_min = 1,
				rank = 1,
				unit = "piggydozer",
				random_tactics = self._random_tactics.bulldozer,
			}
		},
		spawn_point_chk_ref = table.list_to_set({
			"cs_bulldozer",
		})
	}
	
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
GroupAITweakData.bellmead_response_heists = {
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
			"ranged_fire",
			"flash_grenade",
			"smoke_grenade",
		},
		army_agg = {
			"charge",
			"murder",
			"flash_grenade",
		},
		army_spt = {
			"unit_cover",
			"ranged_fire",
		},
		bellmead_def = {
			"ranged_fire",
			"flash_grenade",
			"smoke_grenade",
		},
		bellmead_agg = {
			"charge",
			"murder",
			"flash_grenade",
		},
		bellmead_snk = {
			"flank",
			"deathguard",
			"smoke_grenade",
		},
	}

	self.timed_enemy_spawn_groups = {}

	if self.fbi_heists[level_id] then
		self.timed_enemy_spawn_groups.fbi_group1 = Eclipse:require("timed_groups/fbi_group1")(self._timed_tactics)
	end

	if self.murky_response_heists[level_id] then
		self.timed_enemy_spawn_groups.murky_group1 = Eclipse:require("timed_groups/murky_group1")(self._timed_tactics)
	end

	if self.murky_response_heists_scripted[level_id] then
		self.timed_enemy_spawn_groups.murky_scripted_group1 = Eclipse:require("timed_groups/murky_scripted_group1")(self._timed_tactics)
	end

	if self.us_army_heists[level_id] then
		self.timed_enemy_spawn_groups.us_group1 = Eclipse:require("timed_groups/us_group1")(self._timed_tactics, difficulty_index)
	end

	if self.bellmead_response_heists[level_id] then
		self.timed_enemy_spawn_groups.bellmead_group1 = Eclipse:require("timed_groups/bellmead_group1")(self._timed_tactics)
	end

	if self.us_army_heists_scripted[level_id] then
		self.timed_enemy_spawn_groups.us_scripted_group1 = Eclipse:require("timed_groups/us_scripted_group1")(self._timed_tactics, difficulty_index)
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

	self.first_responders_trade_delay = level_settings.first_responders_trade_delay or self.first_responders_trade_delay

	if level_settings.first_responders_trade_delay ~= 1 then
		Eclipse:log_console("First responders trade delay for " .. level_id .. " set to " .. self.first_responders_trade_delay)
	end

	self.min_grenade_timeout = table_multiplier(self.min_grenade_timeout, level_settings.min_grenade_timeout_mul or 1)

	if level_settings.min_grenade_timeout_mul ~= 1 then
		Eclipse:log_console("Min grenade timeout for " .. level_id .. " set to: ")
		Utils.PrintTable(self.min_grenade_timeout)
	end

	if level_settings.difficulty_scaling then
		for name, value in pairs(level_settings.difficulty_scaling) do
			if self.difficulty_scaling[name] then
				self.difficulty_scaling[name] = value
			end

			Eclipse:log_console("Difficulty scaling for " .. level_id .. " set to: ")
			Utils.PrintTable(self.difficulty_scaling)
		end
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
						Utils.PrintTable(assault_state.assault.sustain_duration_min)
					end
				end

				if assault_state.assault.delay then
					assault_state.assault.delay = table_multiplier(assault_state.assault.delay, level_settings.assault_delay_mul or 1)

					if level_group_ai_state and level_settings.assault_delay_mul ~= 1 then
						Eclipse:log_console("Assault delay for " .. level_id .. " set to: ")
						Utils.PrintTable(assault_state.assault.delay)
					end
				end

				if assault_state.assault.hostage_hesitation_delay then
					assault_state.assault.hostage_hesitation_delay = table_multiplier(assault_state.assault.hostage_hesitation_delay, level_settings.hostage_hesitation_delay_mul or 1)

					if level_group_ai_state and level_settings.hostage_hesitation_delay_mul ~= 1 then
						Eclipse:log_console("Hostage hesitation delay for " .. level_id .. " set to: ")
						Utils.PrintTable(assault_state.assault.hostage_hesitation_delay)
					end
				end

				if assault_state.assault.force then
					assault_state.assault.force = table_multiplier(assault_state.assault.force, level_settings.assault_force_mul or 1)

					if level_group_ai_state and level_settings.assault_force_mul ~= 1 then
						Eclipse:log_console("Assault force for " .. level_id .. " set to: ")
						Utils.PrintTable(assault_state.assault.force)
					end
				end

				if assault_state.assault.force_pool then
					assault_state.assault.force_pool = table_multiplier(assault_state.assault.force_pool, level_settings.assault_force_mul or 1)

					if level_group_ai_state and level_settings.assault_force_mul ~= 1 then
						Eclipse:log_console("Assault force for pool " .. level_id .. " set to: ")
						Utils.PrintTable(assault_state.assault.force_pool)
					end
				end

				if assault_state.assault.spawnrate then
					assault_state.assault.spawnrate = table_multiplier(assault_state.assault.spawnrate, level_settings.spawnrate_mul or 1)

					if level_group_ai_state and level_settings.spawnrate_mul ~= 1 then
						Eclipse:log_console("Spawnrate for " .. level_id .. " set to: ")
						Utils.PrintTable(assault_state.assault.spawnrate)
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
					Utils.PrintTable(assault_state.recon.force)
				end
			end

			if assault_state.reenforce then
				assault_state.reenforce.interval = table_multiplier(assault_state.reenforce.interval, level_settings.reenforce_interval_mul or 1)

				if level_group_ai_state and level_settings.reenforce_interval_mul ~= 1 then
					Eclipse:log_console("Reenforce interval for " .. level_id .. " set to: ")
					Utils.PrintTable(assault_state.reenforce.interval)
				end
			end

			if assault_state.cloaker then
				assault_state.cloaker.interval = table_multiplier(assault_state.cloaker.interval, level_settings.cloaker_interval_mul or 1)

				if level_group_ai_state and level_settings.cloaker_interval_mul ~= 1 then
					Eclipse:log_console("Cloaker spawn intervals for " .. level_id .. " set to: ")
					Utils.PrintTable(assault_state.cloaker.interval)
				end
			end
		
			if assault_state.push_delay then
				assault_state.push_delay = table_multiplier(assault_state.push_delay, level_settings.push_delay_mul or 1)

				if level_group_ai_state and level_settings.push_delay_mul ~= 1 then
					Eclipse:log_console("Push delay for " .. level_id .. " set to: ")
					Utils.PrintTable(assault_state.push_delay)
				end
			end
		end
	end

	if level_settings.grenade_timeout_mul then
		self.flash_grenade_timeout = table_multiplier(self.flash_grenade_timeout, level_settings.grenade_timeout_mul.flash_grenade or 1)

		if level_settings.grenade_timeout_mul.flash_grenade ~= 1 then
			Eclipse:log_console("Flash grenade timeout for " .. level_id .. " set to: ")
			Utils.PrintTable(self.flash_grenade_timeout)
		end

		self.smoke_grenade_timeout = table_multiplier(self.smoke_grenade_timeout, level_settings.grenade_timeout_mul.smoke_grenade or 1)

		if level_settings.grenade_timeout_mul.smoke_grenade ~= 1 then
			Eclipse:log_console("Smoke grenade timeout for " .. level_id .. " set to: ")
			Utils.PrintTable(self.smoke_grenade_timeout)
		end

		self.cs_grenade_timeout = table_multiplier(self.cs_grenade_timeout, level_settings.grenade_timeout_mul.cs_grenade or 1)

		if level_settings.grenade_timeout_mul.cs_grenade ~= 1 then
			Eclipse:log_console("CS grenade timeout for " .. level_id .. " set to: ")
			Utils.PrintTable(self.cs_grenade_timeout)
		end
	end

	self.cs_grenade_chance_times = table_multiplier(self.cs_grenade_chance_times, level_settings.cs_grenade_chance_times_mul or 1)

	if level_settings.cs_grenade_chance_times_mul ~= 1 then
		Eclipse:log_console("CS grenade chance times for " .. level_id .. " set to: ")
		Utils.PrintTable(self.cs_grenade_chance_times)
	end

	self.min_reenforce_interval = table_multiplier(self.min_reenforce_interval, level_settings.min_reenforce_interval_mul or 1)

	if level_settings.min_reenforce_interval_mul ~= 1 then
		Eclipse:log_console("Min reenforce interval for " .. level_id .. " set to: ")
		Utils.PrintTable(self.min_reenforce_interval)
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
	-- AI Tickrate
	self.ai_tickrate = 1 / (below_overkill and 60 or 90)

	--In-heist difficulty scaling
	self.difficulty_scaling = {
		diff_init = 0.4,
		diff_min = 0,
		diff_max = 1,
		diff_step = 0.05,
		assault_delay = 45,
		diff_step_interval = { 15, 20 },
		assault_add = 0.2,
		hostage_add = is_pro_job and 0.1 or nil,
	}

	-- BESIEGE --

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
	self.first_responders_trade_delay = 45

	self.besiege.assault.delay = {
		diff_lerp(60, 40),
		diff_lerp(45, 30),
		diff_lerp(30, 20),
	}
	self.besiege.assault.hostage_hesitation_delay = { 10, 7.5, 5 }

	-- SPAWNS --

	-- Spawncap
	self.besiege.assault.force = {
		diff_lerp(2, 4),
		diff_lerp(5, 8),
		diff_lerp(8, 12),
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
	self.min_reenforce_interval = { 5, 7.5, 10 }

	self.besiege.reenforce.interval = { 10, 20, 30 }

	-- Recon spawn interval and spawncap
	self.besiege.recon.interval_variation = 30
	self.besiege.recon.force = {
		diff_lerp(1, 3),
		diff_lerp(2, 4),
		diff_lerp(3, 5),
	}

	self.hostage_push_delay_mul = 1.5
	self.besiege.push_delay = {
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

	self.smoke_grenade_timeout = { 30, 40 }
	self.smoke_grenade_lifetime = below_overkill and 10 or 15

	self.cs_grenade_timeout = { 60, 90 }
	self.cs_grenade_lifetime = self.smoke_grenade_lifetime * 2
	self.cs_grenade_chance_times = {
		60,
		below_overkill and 240 or 180,
	}

	if difficulty_index <= 3 then
		self.besiege.faction = {
			"CS",
			"CS",
			"CS",
		}
	elseif difficulty_index == 4 then
		self.besiege.faction = {
			"CS",
			"FBI",
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
			"FBI",
			"FBI",
			"Elite",
		}
	end

	-- Spawngroups
	if difficulty_index <= 2 then
		self.besiege.assault.groups = {
			cs_cops = { 0.8, 0.4, 0 },
			cs_swats = { 1, 1, 1 },
			cs_heavies = { 0, 0, 0.5 },
			cs_shield = { 0, 0.1, 0.2 },
		}
		self.besiege.recon.groups = {
			cs_stealth_light = { 1, 0.7, 0.4 },
			cs_stealth_heavy = { 0, 0.4, 1 },
		}
		self.besiege.reenforce.groups = {
			cs_defend_init = { 1, 0.2, 0 },
			cs_defend_light = { 0, 0.4, 1 },
			cs_defend_heavy = { 0, 0, 0.4 },
		}
	elseif difficulty_index == 3 then
		self.besiege.assault.groups = {
			cs_cops = { 0.6, 0.2, 0 },
			cs_swats = { 1, 1, 1 },
			cs_heavies = { 0, 0.2, 0.6 },
			cs_shield = { 0, 0.1, 0.2 },
			cs_taser = { 0, 0.1, 0.2 },
			cs_bulldozer = { 0, 0, 0.15 },
		}
		self.besiege.recon.groups = {
			cs_stealth_light = { 1, 0.7, 0.4 },
			cs_stealth_heavy = { 0, 0.4, 1 },
		}
		self.besiege.reenforce.groups = {
			cs_defend_init = { 0.8, 0.2, 0 },
			cs_defend_light = { 0.2, 0.4, 1 },
			cs_defend_heavy = { 0, 0, 0.5 },
		}
	elseif difficulty_index == 4 then
		self.besiege.assault.groups = {
			cs_swats = { 0.8, 0.4, 0 },
			fbi_swats = { 0.6, 0.8, 1 },
			fbi_heavies = { 0, 0.2, 0.6 },
			fbi_shield = { 0, 0.1, 0.25 },
			fbi_taser = { 0, 0.1, 0.25 },
			fbi_cloaker = { 0, 0.1, 0.25 },
			fbi_bulldozer = { 0, 0, 0.2 },
		}
		self.besiege.recon.groups = {
			fbi_stealth_light = { 1, 0.7, 0.4 },
			fbi_stealth_heavy = { 0, 0.4, 1 },
		}
		self.besiege.reenforce.groups = {
			cs_defend_init = { 0.4, 0, 0 },
			cs_defend_light = { 0.3, 0.1, 0 },
			cs_defend_heavy = { 0.1, 0.2, 0 },
			fbi_defend_init = { 0.6, 0.3, 0 },
			fbi_defend_light = { 0, 0.4, 0.8 },
			fbi_defend_heavy = { 0, 0, 0.6 },
		}
	elseif difficulty_index == 5 then
		self.besiege.assault.groups = {
			cs_swats = { 0.4, 0.2, 0 },
			fbi_swats = { 1, 1, 1 },
			fbi_heavies = { 0, 0.2, 0.6 },
			fbi_shield = { 0, 0.15, 0.3 },
			fbi_taser = { 0, 0.15, 0.3 },
			fbi_cloaker = { 0, 0.15, 0.3 },
			fbi_bulldozer = { 0, 0, 0.25 },
		}
		self.besiege.recon.groups = {
			fbi_stealth_light = { 1, 0.7, 0.4 },
			fbi_stealth_heavy = { 0, 0.4, 1 },
		}
		self.besiege.reenforce.groups = {
			cs_defend_init = { 0.4, 0, 0 },
			cs_defend_light = { 0.3, 0.1, 0 },
			cs_defend_heavy = { 0.1, 0.2, 0 },
			fbi_defend_init = { 0.6, 0.3, 0 },
			fbi_defend_light = { 0, 0.4, 0.8 },
			fbi_defend_heavy = { 0, 0, 0.6 },
		}
	else
		self.besiege.assault.groups = {
			cs_swats = { 0.4, 0.1, 0 },
			fbi_swats = { 1, 0.8, 0 },
			elite_swats = { 0, 0.4, 0.8 },
			fbi_heavies = { 0, 0.3, 0.8 },
			elite_sniper = { 0, 0.2, 0.4 },
			fbi_shield = { 0, 0.15, 0.3 },
			elite_shield = { 0, 0, 0.3 },
			elite_taser = { 0, 0.15, 0.3 },
			elite_taser_takedown = { 0, 0.1, 0.2 },
			fbi_cloaker = { 0, 0.15, 0.3 },
			fbi_bulldozer = { 0, 0, 0.25 },
			elite_bulldozer = { 0, 0, 0.25 },
			elite_bulldozer_takedown = { 0, 0, 0.1 },
			elite_bulldozer_shield = { 0, 0, 0.1 },
		}
		self.besiege.recon.groups = {
			fbi_stealth_light = { 1, 0.7, 0.4 },
			fbi_stealth_heavy = { 0, 0.4, 1 },
		}
		self.besiege.reenforce.groups = {
			cs_defend_init = { 0.2, 0, 0 },
			cs_defend_light = { 0.2, 0.1, 0 },
			cs_defend_heavy = { 0.1, 0.2, 0 },
			fbi_defend_init = { 0.4, 0.2, 0 },
			fbi_defend_light = { 0.1, 0.3, 0 },
			fbi_defend_heavy = { 0, 0.2, 0.6 },
			elite_defend_light = { 0, 0.2, 0.6 },
		}
	end

	self.besiege.cloaker.groups = {
		single_spooc = { 1, 1, 1 },
	}

	-- New data for the reworked Cloaker task
	self.besiege.cloaker.interval = {
		diff_lerp(60, 20),
		diff_lerp(120, 40),
	}
	self.besiege.cloaker.hide_durations = { 120, 180 }
	self.besiege.cloaker.hide_retry_delay = { 10, 20 }
	self.besiege.cloaker.avoid_repeat_hiding_spots = true -- Rehiding not implemented yet
	self.besiege.cloaker.avoid_repeat_hiding_spots_min_elements = 2 -- Rehiding not implemented yet
	self.besiege.cloaker.simultaneous_hiding_limit = 1
	self.besiege.cloaker.goggles_on_when_hiding = false
	self.besiege.cloaker.use_spawn_noise = true
	self.besiege.cloaker.use_idle_noise_when_hiding = true
	self.besiege.cloaker.whistle_on_leave_hiding = true
	self.besiege.cloaker.assault_on_objective_failed_chance = 1 -- Rehiding not implemented yet
	self.besiege.recurring_group_SO.recurring_cloaker_spawn.interval = clone(self.besiege.cloaker.interval)

	self.besiege.assault.groups.single_spooc = { 0, 0, 0 }
	self.besiege.assault.groups.Phalanx = { 0, 0, 0 }
	self.besiege.assault.groups.marshal_squad = { 0, 0, 0 }
	self.besiege.assault.groups.custom_assault = { 0, 0, 0 }
	self.besiege.assault.groups.snowman_boss = { 0, 0, 0 }
	self.besiege.assault.groups.piggydozer = { 0, 0, 0 }
	-- timed groups
	self.besiege.assault.groups.fbi_group1 = { 0, 0, 0 }
	self.besiege.assault.groups.murky_group1 = { 0, 0, 0 }
	self.besiege.assault.groups.murky_scripted_group1 = { 0, 0, 0 }
	self.besiege.assault.groups.us_group1 = { 0, 0, 0 }
	self.besiege.assault.groups.us_scripted_group1 = { 0, 0, 0 }
	self.besiege.assault.groups.bellmead_group1 = { 0, 0, 0 }

	self.besiege.recon.groups.single_spooc = { 0, 0, 0 }
	self.besiege.recon.groups.Phalanx = { 0, 0, 0 }
	self.besiege.recon.groups.marshal_squad = { 0, 0, 0 }
	self.besiege.recon.groups.custom_recon = { 0, 0, 0 }
	self.besiege.recon.groups.snowman_boss = { 0, 0, 0 }
	self.besiege.recon.groups.piggydozer = { 0, 0, 0 }
	-- timed groups
	self.besiege.recon.groups.fbi_group1 = { 0, 0, 0 }
	self.besiege.recon.groups.murky_group1 = { 0, 0, 0 }
	self.besiege.recon.groups.murky_scripted_group1 = { 0, 0, 0 }
	self.besiege.recon.groups.us_group1 = { 0, 0, 0 }
	self.besiege.recon.groups.us_scripted_group1 = { 0, 0, 0 }
	self.besiege.recon.groups.bellmead_group1 = { 0, 0, 0 }

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
		framing_frame_2 = true,
		roberts = true,
		dah = true,
		rvd2 = true,
		man = true,
	}

	-- Control
	self.ponr.assault.force = {
		diff_lerp(2, 4),
		diff_lerp(5, 8),
		diff_lerp(8, 12),
	}

	self.ponr.assault.delay = { 20, 20, 20 }
	self.ponr.assault.hostage_hesitation_delay = { 10, 7.5, 5 }

	self.ponr.push_delay = {
		diff_lerp(12, 8),
		diff_lerp(12, 8),
		diff_lerp(12, 8),
	}

	if level_id and short_ponr_heists[level_id] then
		self.ponr.assault.delay = { 5, 5, 5 }
		self.ponr.assault.hostage_hesitation_delay = { 0, 0, 0 }
	end

	-- Recon
	self.ponr.recon.force = { 0, 0, 0 } -- no recon after ponr ran out

	if difficulty_index < 4 then
		self.ponr.faction = {
			"FBI",
			"FBI",
			"FBI",
		}
	else
		self.ponr.faction = {
			"Elite",
			"Elite",
			"Elite",
		}
	end

	-- Spawngroups
	if difficulty_index <= 2 then
		self.ponr.assault.groups = {
			fbi_swats = { 1, 1, 1 },
			fbi_heavies = { 1, 1, 1 },
			fbi_shield = { 0.4, 0.4, 0.4 },
		}
		self.ponr.reenforce.groups = {
			fbi_defend_light = { 2, 2, 2 },
			fbi_defend_heavy = { 1, 1, 1 },
		}
	elseif difficulty_index == 3 then
		self.ponr.assault.groups = {
			fbi_swats = { 1, 1, 1 },
			fbi_heavies = { 1, 1, 1 },
			fbi_shield = { 0.4, 0.4, 0.4 },
			fbi_taser = { 0.4, 0.4, 0.4 },
			fbi_bulldozer = { 0.3, 0.3, 0.3 },
		}
		self.ponr.reenforce.groups = {
			fbi_defend_light = { 2, 2, 2 },
			fbi_defend_heavy = { 1, 1, 1 },
		}
	elseif difficulty_index == 4 then
		self.ponr.assault.groups = {
			elite_swats = { 1, 1, 1 },
			fbi_heavies = { 1, 1, 1 },
			fbi_shield = { 0.3, 0.3, 0.3 },
			elite_shield = { 0.2, 0.2, 0.2 },
			elite_taser = { 0.5, 0.5, 0.5 },
			fbi_cloaker = { 0.5, 0.5, 0.5 },
			fbi_bulldozer = { 0.2, 0.2, 0.2 },
			elite_bulldozer = { 0.1, 0.1, 0.1 },
		}
		self.ponr.reenforce.groups = {
			elite_defend_light = { 1, 1, 1 },
			fbi_defend_heavy = { 1, 1, 1 },
		}
	elseif difficulty_index == 5 then
		self.ponr.assault.groups = {
			elite_swats = { 1, 1, 1 },
			fbi_heavies = { 1, 1, 1 },
			fbi_shield = { 0.3, 0.3, 0.3 },
			elite_shield = { 0.2, 0.2, 0.2 },
			elite_taser = { 0.5, 0.5, 0.5 },
			fbi_cloaker = { 0.5, 0.5, 0.5 },
			fbi_bulldozer = { 0.2, 0.2, 0.2 },
			elite_bulldozer = { 0.1, 0.1, 0.1 },
		}
		self.ponr.reenforce.groups = {
			elite_defend_light = { 1, 1, 1 },
			fbi_defend_heavy = { 1, 1, 1 },
		}
	else
		self.ponr.assault.groups = {
			elite_swats = { 0.8, 0.8, 0.8 },
			elite_heavies = { 1, 1, 1 },
			elite_shield = { 0.6, 0.6, 0.6 },
			elite_taser = { 0.6, 0.6, 0.6 },
			fbi_cloaker = { 0.6, 0.6, 0.6 },
			elite_bulldozer = { 0.4, 0.4, 0.4 },
		}
		self.ponr.reenforce.groups = {
			elite_defend_light = { 0.8, 0.8, 0.8 },
			elite_defend_heavy = { 1, 1, 1 },
		}
	end

	self.ponr.cloaker.groups = {
		single_spooc = { 1, 1, 1 },
	}

	-- misc
	self.ponr.assault.groups.single_spooc = { 0, 0, 0 }
	self.ponr.assault.groups.Phalanx = { 0, 0, 0 }
	self.ponr.assault.groups.marshal_squad = { 0, 0, 0 }
	self.ponr.assault.groups.custom_assault = { 0, 0, 0 }
	self.ponr.assault.groups.snowman_boss = { 0, 0, 0 }
	self.ponr.assault.groups.piggydozer = { 0, 0, 0 }

	-- recurring groups
	self.ponr.assault.groups.fbi_timed_group = { 0, 0, 0 }
	self.ponr.assault.groups.murkywater_timed_group = { 0, 0, 0 }
	self.ponr.assault.groups.army_timed_group = { 0, 0, 0 }
	self.ponr.assault.groups.bellmead_timed_group = { 0, 0, 0 }

	self.ponr.recon.groups.single_spooc = { 0, 0, 0 }
	self.ponr.recon.groups.Phalanx = { 0, 0, 0 }
	self.ponr.recon.groups.marshal_squad = { 0, 0, 0 }
	self.ponr.recon.groups.custom_recon = { 0, 0, 0 }
	self.ponr.recon.groups.snowman_boss = { 0, 0, 0 }
	self.ponr.recon.groups.piggydozer = { 0, 0, 0 }
	-- recurring groups
	self.ponr.recon.groups.fbi_timed_group = { 0, 0, 0 }
	self.ponr.recon.groups.murkywater_timed_group = { 0, 0, 0 }
	self.ponr.recon.groups.army_timed_group = { 0, 0, 0 }
	self.ponr.recon.groups.bellmead_timed_group = { 0, 0, 0 }

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

		Eclipse:log_console("Group AI preset for " .. level_id .. " set to " .. self._mission_preset)
	end

	if self._mission_settings then
		self:_apply_group_ai_settings(self._mission_settings)
	end
end)
