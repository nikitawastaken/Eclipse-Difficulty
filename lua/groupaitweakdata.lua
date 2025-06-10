local level_id = Eclipse.utils.level_id()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local is_solo = Eclipse.utils.is_solo

local function diff_lerp(value_1, value_2)
	return Eclipse.utils.diff_lerp(value_1, value_2)
end

local function group_weight_multiplier(group_weights, mul)
	for diff_step, weight in pairs(group_weights) do
		group_weights[diff_step] = weight * mul[diff_step]
	end
end

GroupAITweakData.group_ai_presets = {
	["ambush"] = {
		cs_shield_ranged = { 1, 1.25, 1.25 },
		cs_shield_charge = { 1, 1.25, 1.25 },
		fbi_shield_ranged = { 1, 1.25, 1.25 },
		fbi_shield_charge = { 1, 1.25, 1.25 },
		elite_shield_ranged = { 1, 1.25, 1.25 },
		elite_shield_charge = { 1, 1.25, 1.25 },

		cs_taser_flank = { 1, 1.25, 1.25 },
		cs_taser_charge = { 1, 1.25, 1.25 },
		fbi_taser_flank = { 1, 1.25, 1.25 },
		fbi_taser_charge = { 1, 1.25, 1.25 },
		elite_taser_takedown = { 1, 1.25, 1.25 },
		elite_taser_flank = { 1, 1.25, 1.25 },
		elite_taser_charge = { 1, 1.25, 1.25 },

		cs_bulldozer_charge = { 1, 1.25, 1.25 },
		fbi_bulldozer_charge = { 1, 1.25, 1.25 },
		elite_bulldozer_shield = { 1, 1.25, 1.25 },
		elite_bulldozer_takedown = { 1, 1.25, 1.25 },
		elite_bulldozer_charge = { 1, 1.25, 1.25 },

		fbi_cloaker_charge = { 1, 1.5, 1.5 },
		fbi_cloaker_hide = { 1, 1.5, 1.5 },
	},
	["small_urban"] = {
		cs_cops_init = { 1.5, 1.25, 1 },

		cs_bulldozer_charge = { 0, 0, 0.75 },
		fbi_bulldozer_charge = { 0, 0, 0.75 },
		elite_bulldozer_shield = { 0, 0, 0.75 },
		elite_bulldozer_takedown = { 0, 0, 0.75 },
		elite_bulldozer_charge = { 0, 0, 0.75 },

		cs_defend_init = { 1.5, 1.25, 1 },

		cs_defend_light = { 0, 0.5, 1 },
		fbi_defend_light = { 0, 0.5, 1 },
		elite_defend_light = { 0, 0.5, 1 },

		cs_defend_heavy = { 0, 0, 1 },
		fbi_defend_heavy = { 0, 0, 1 },
		elite_defend_heavy = { 0, 0, 1 },
	},
	["remote"] = {
		cs_cops_init = { 0, 0, 0 },

		cs_defend_init = { 0.5, 0.25, 0 },
		fbi_defend_init = { 0.5, 0.25, 0 },

		cs_stealth_light = { 0.5, 0.25, 0 },
		fbi_stealth_light = { 0.5, 0.25, 0 },
	},
	["skyscraper"] = {
		cs_defend_init = { 1.5, 1.25, 1 },

		cs_shield_ranged = { 0, 0.75, 1 },
		cs_shield_charge = { 0, 0.75, 1 },
		fbi_shield_ranged = { 0, 0.75, 1 },
		fbi_shield_charge = { 0, 0.75, 1 },
		elite_shield_ranged = { 0, 0.75, 1 },
		elite_shield_charge = { 0, 0.75, 1 },

		fbi_cloaker_charge = { 1, 1.25, 1.25 },
		fbi_cloaker_hide = { 1, 1.25, 1.25 },

		cs_defend_init = { 0.5, 0.25, 0 },
		fbi_defend_init = { 0.5, 0.25, 0 },

		cs_stealth_light = { 0.5, 0.25, 0 },
		fbi_stealth_light = { 0.5, 0.25, 0 },
	},
}

-- Helper function for Group AI presets
function GroupAITweakData:_run_group_ai_preset(preset)
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

						Eclipse:log_console("Weight multipliers for " .. group_name .. " set.")
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
				for i, weight in pairs(entry_freq) do
					entry_freq[i] = weight * dis_freq()
				end

				return entry_freq
			elseif k == "freq" then
				return entry_freq * dis_freq()
			end
		end,
	})
end

-- Top level init
Hooks:PostHook(GroupAITweakData, "init", "eclipse_groupaitd_init", function(self)
	self.timer_data = {}
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
			marshal = 0,
		}
	elseif difficulty_index == 3 then
		self.special_unit_spawn_limits = {
			shield = 2,
			taser = 1,
			tank = 1,
			spooc = 0,
			medic = 0,
			marksman = 0,
			marshal = 2,
		}
	elseif difficulty_index == 4 then
		self.special_unit_spawn_limits = {
			shield = 3,
			taser = 1,
			tank = 1,
			spooc = 2,
			medic = 2,
			marksman = 0,
			marshal = 2,
		}
	elseif difficulty_index == 5 then
		self.special_unit_spawn_limits = {
			shield = 4,
			taser = 2,
			tank = 1,
			spooc = 2,
			medic = 3,
			marksman = 0,
			marshal = 3,
		}
	elseif difficulty_index == 6 then
		self.special_unit_spawn_limits = {
			shield = 5,
			taser = 3,
			tank = 2,
			spooc = 3,
			medic = 4,
			marksman = 3,
			marshal = 4,
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
				Idstring("units/payday2/characters/ene_tazer_r870/ene_tazer_r870"),
			},
			russia = {
				Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
				Idstring("units/payday2/characters/ene_tazer_r870/ene_tazer_r870"),
			},
			zombie = {
				Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
				Idstring("units/payday2/characters/ene_tazer_r870/ene_tazer_r870"),
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
				Idstring("units/payday2/characters/ene_tazer_r870/ene_tazer_r870"),
			},
			federales = {
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

	self.unit_categories.zeal_swat_1 = {
		unit_types = {
			america = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat") },
			russia = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat") },
			zombie = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat") },
			murkywater = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat") },
			federales = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat") },
		},
		access = access_type_all,
	}

	self.unit_categories.zeal_swat_2 = {
		unit_types = {
			america = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2") },
			russia = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2") },
			zombie = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2") },
			murkywater = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2") },
			federales = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2") },
		},
		access = access_type_all,
	}

	self.unit_categories.zeal_swat_3 = {
		unit_types = {
			america = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat") },
			russia = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat") },
			zombie = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat") },
			murkywater = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat") },
			federales = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat") },
		},
		access = access_type_all,
	}

	self.unit_categories.zeal_swat = {
		unit_types = {
			america = {
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"),
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2"),
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"),
			},
			russia = {
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"),
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2"),
				Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"),
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

	self.unit_categories.zeal_heavy_1 = {
		unit_types = {
			america = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy") },
			russia = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy") },
			zombie = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy") },
			murkywater = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy") },
			federales = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy") },
		},
		access = access_type_all,
	}

	self.unit_categories.zeal_heavy_2 = {
		unit_types = {
			america = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2") },
			russia = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2") },
			zombie = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2") },
			murkywater = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2") },
			federales = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2") },
		},
		access = access_type_all,
	}

	self.unit_categories.zeal_heavy = {
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

	self.unit_categories.zeal_shield = {
		special_type = "shield",
		unit_types = {
			america = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield") },
			russia = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield") },
			zombie = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield") },
			murkywater = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield") },
			federales = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield") },
		},
		access = access_type_walk_only,
	}

	self.unit_categories.zeal_taser_1 = {
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

	self.unit_categories.zeal_taser_2 = {
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

	self.unit_categories.zeal_taser = {
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

	self.unit_categories.zeal_medic_1 = {
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

	self.unit_categories.zeal_medic_2 = {
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

	self.unit_categories.zeal_medic = {
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

	self.unit_categories.zeal_cloaker = {
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

	self.unit_categories.zeal_tank = {
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
end)

Hooks:PostHook(GroupAITweakData, "_init_enemy_spawn_groups", "eclipse__init_enemy_spawn_groups", function(self, difficulty_index)
	self._tactics = {
		none = {},
		cop_init = {
			"no_push",
		},
		cop_ranged = {
			"ranged_fire",
			"no_push",
		},
		cop_flank = {
			"ranged_fire",
			"flank",
		},
		hrt = {
			"rescue",
			"flank",
		},
		swat_init = {
			"rescue",
			"ranged_fire",
		},
		swat_ranged = {
			"ranged_fire",
			"smoke_grenade",
			"flash_grenade",
		},
		swat_charge = {
			"charge",
			"deathguard",
			"flash_grenade",
		},
		swat_flank = {
			"flank",
			"deathguard",
			"smoke_grenade",
		},
		swat_support_ranged = {
			"unit_cover",
			"ranged_fire",
		},
		swat_support_charge = {
			"unit_cover",
			"charge",
		},
		swat_support_flank = {
			"unit_cover",
			"flank",
		},
		shield_ranged = {
			"shield",
			"ranged_fire",
			"door_ambush",
		},
		shield_charge = {
			"shield",
			"charge",
			"deathguard",
		},
		shield_support_ranged = {
			"shield_cover",
			"ranged_fire",
		},
		shield_support_charge = {
			"shield_cover",
			"charge",
		},
		taser_flank = {
			"murder",
			"flank",
		},
		taser_charge = {
			"murder",
			"charge",
		},
		bulldozer_charge = {
			"shield",
			"murder",
			"charge",
		},
		bulldozer_support_charge = {
			"shield_cover",
			"charge",
			"smoke_grenade",
			"flash_grenade",
		},
		cloaker_hide = {
			"no_push",
			"deathguard",
		},
		cloaker_charge = {
			"flank",
			"charge",
		},
		sniper = {
			"unit_cover",
			"ranged_fire",
			"no_push",
		},
	}

	-- соси хуй кк?
	self.enemy_spawn_groups = {}

	local cloaker_medic_1 = { "medic_1", "medic_1", "cloaker" }
	local cloaker_medic_2 = { "medic_2", "medic_2", "cloaker" }

	local taser_medic_1 = { "medic_1", "medic_1", "taser_1" }
	local taser_medic_2 = { "medic_2", "medic_2", "taser_2" }

	local taser_cloaker = { "taser_1", "taser_2", "cloaker", "cloaker" }

	self.enemy_spawn_groups.cs_defend_init = {
		amount = { 2, 3 },
		spawn = {
			{
				amount_max = 2,
				freq = 2,
				rank = 3,
				unit = "cs_cop_4",
				tactics = self._tactics.cop_init,
			},
			{
				amount_min = 1,
				freq = 4,
				rank = 2,
				unit = "cs_cop_1",
				tactics = self._tactics.cop_init,
			},
			{
				amount_max = 1,
				freq = 1,
				rank = 1,
				unit = "cs_cop_2",
				tactics = self._tactics.cop_init,
			},
		},
	}

	self.enemy_spawn_groups.cs_defend_light = {
		amount = { 2, 3 },
		spawn = {
			{
				amount_max = 2,
				freq = 1,
				rank = 3,
				unit = "cs_swat_2_3",
				tactics = self._tactics.none,
			},
			{
				amount_min = 1,
				freq = 2,
				rank = 2,
				unit = "cs_swat_1",
				tactics = self._tactics.none,
			},
			{
				amount_max = 1,
				freq_by_diff = {
					15 / (difficulty_index ^ 2),
					0,
					0,
				},
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
				amount_max = 2,
				freq = 1,
				rank = 3,
				unit = "cs_heavy_2",
				tactics = self._tactics.none,
			},
			{
				amount_min = 1,
				freq = 2,
				rank = 2,
				unit = "cs_heavy_1",
				tactics = self._tactics.none,
			},
			{
				amount_max = 1,
				freq_by_diff = {
					45 / (difficulty_index ^ 2),
					30 / (difficulty_index ^ 2),
					15 / (difficulty_index ^ 2),
				},
				freq = 1,
				rank = 1,
				unit = "cs_swat_3",
				tactics = self._tactics.none,
			},
		},
	}

	self.enemy_spawn_groups.cs_stealth_light = {
		amount = { 2, 3 },
		spawn = {
			{
				amount_max = 2,
				freq_by_diff = { 0, 1, 1 },
				rank = 3,
				unit = "cs_cop_3",
				tactics = self._tactics.hrt,
			},
			{
				amount_max = 2,
				freq_by_diff = { 1, 1, 0 },
				rank = 2,
				unit = "cs_cop_1",
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
				unit = "cs_cop_3",
				tactics = self._tactics.hrt,
			},
		},
	}

	self.enemy_spawn_groups.cs_cops_init = {
		amount = { 3, 3 },
		spawn = {
			{
				amount_min = 1,
				freq = 4,
				rank = 2,
				unit = "cs_cop_1",
				tactics = self._tactics.cop_ranged,
			},
			{
				amount_max = 2,
				freq = 1,
				rank = 1,
				unit = "cs_cop_2",
				tactics = self._tactics.cop_ranged,
			},
			{
				amount_max = 2,
				freq_by_diff = {
					(difficulty_index ^ 2) / 5,
					(difficulty_index ^ 2),
					(difficulty_index ^ 2),
				},
				rank = 3,
				unit = "cs_cop_3_4",
				tactics = self._tactics.cop_flank,
			},
		},
	}

	self.enemy_spawn_groups.cs_swats_ranged = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_max = 2,
				freq = 1,
				rank = 3,
				unit = "cs_swat_2_3",
				tactics = self._tactics.swat_flank,
			},
			{
				amount_max = 3,
				freq_by_diff = { 10, 1, 0 },
				rank = 2,
				unit = "cs_swat",
				tactics = self._tactics.swat_init,
			},
			{
				amount_min = 2,
				amount_max = 3,
				freq = 2,
				rank = 2,
				unit = "cs_swat_1",
				tactics = self._tactics.swat_ranged,
			},
		},
	}

	self.enemy_spawn_groups.cs_swats_charge = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_max = 2,
				freq = 1,
				rank = 3,
				unit = "cs_swat_1_3",
				tactics = self._tactics.swat_flank,
			},
			{
				amount_max = 3,
				freq_by_diff = { 10, 1, 0 },
				rank = 2,
				unit = "cs_swat",
				tactics = self._tactics.swat_init,
			},
			{
				amount_min = 2,
				amount_max = 3,
				freq = 2,
				rank = 2,
				unit = "cs_swat_2",
				tactics = self._tactics.swat_ranged,
			},
		},
	}

	self.enemy_spawn_groups.cs_heavies_ranged = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_max = 2,
				freq = 1,
				rank = 3,
				unit = "cs_heavy_2",
				tactics = self._tactics.swat_flank,
			},
			{
				amount_min = 2,
				amount_max = 3,
				freq = 2,
				rank = 2,
				unit = "cs_heavy_1",
				tactics = self._tactics.swat_ranged,
			},
			{
				amount_max = 2,
				freq_by_diff = {
					45 / (difficulty_index ^ 2),
					30 / (difficulty_index ^ 2),
					15 / (difficulty_index ^ 2),
				},
				rank = 1,
				unit = "cs_swat_1_3",
				tactics = self._tactics.swat_support_ranged,
			},
		},
	}

	self.enemy_spawn_groups.cs_heavies_charge = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_max = 2,
				freq = 1,
				rank = 3,
				unit = "cs_heavy_1",
				tactics = self._tactics.swat_flank,
			},
			{
				amount_min = 2,
				amount_max = 3,
				freq = 2,
				rank = 2,
				unit = "cs_heavy_2",
				tactics = self._tactics.swat_charge,
			},
			{
				amount_max = 2,
				freq_by_diff = {
					45 / (difficulty_index ^ 2),
					30 / (difficulty_index ^ 2),
					15 / (difficulty_index ^ 2),
				},
				rank = 1,
				unit = "cs_swat_1_3",
				tactics = self._tactics.swat_support_charge,
			},
		},
	}

	self.enemy_spawn_groups.cs_shield_ranged = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_min = 1,
				amount_max = 1,
				freq = 1,
				rank = 3,
				unit = "cs_shield",
				tactics = self._tactics.shield_ranged,
			},
			{
				freq_by_diff = { 3, 2, 1 },
				rank = 2,
				unit = "cs_swat_1_3",
				tactics = self._tactics.shield_support_ranged,
			},
			{
				freq_by_diff = { 0, 1, 2 },
				rank = 2,
				unit = "cs_heavy_1",
				tactics = self._tactics.shield_support_ranged,
			},
			{
				freq_by_diff = { 2, 0, 0 },
				rank = 1,
				unit = "cs_cop_3",
				tactics = self._tactics.shield_support_ranged,
			},
		},
	}

	self.enemy_spawn_groups.cs_shield_charge = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_min = 1,
				amount_max = 1,
				freq = 1,
				rank = 3,
				unit = "cs_shield",
				tactics = self._tactics.shield_charge,
			},
			{
				freq_by_diff = { 1, 2, 1 },
				rank = 2,
				unit = "cs_swat_2_3",
				tactics = self._tactics.shield_support_charge,
			},
			{
				freq_by_diff = { 0, 1, 2 },
				rank = 2,
				unit = "cs_heavy_2",
				tactics = self._tactics.shield_support_charge,
			},
			{
				freq_by_diff = { 2, 0, 0 },
				rank = 1,
				unit = "cs_cop_3",
				tactics = self._tactics.shield_support_charge,
			},
		},
	}

	self.enemy_spawn_groups.cs_taser_flank = {
		amount = { 3, 3 },
		spawn = {
			{
				amount_min = 1,
				amount_max = 1,
				freq = 1,
				rank = 3,
				unit = "taser_1",
				tactics = self._tactics.taser_flank,
			},
			{
				freq = 1,
				rank = 2,
				unit = "cs_swat_1_3",
				tactics = self._tactics.taser_flank,
			},
		},
	}

	self.enemy_spawn_groups.cs_taser_charge = {
		amount = { 3, 3 },
		spawn = {
			{
				amount_min = 1,
				amount_max = 1,
				freq = 1,
				rank = 3,
				unit = "taser_2",
				tactics = self._tactics.taser_charge,
			},
			{
				freq = 1,
				rank = 2,
				unit = "cs_swat_2_3",
				tactics = self._tactics.taser_charge,
			},
		},
	}

	self.enemy_spawn_groups.cs_bulldozer_charge = {
		amount = { 3, 3 },
		spawn = {
			{
				amount_min = 1,
				amount_max = 1,
				freq = 1,
				rank = 3,
				unit = "bulldozer_1",
				tactics = self._tactics.bulldozer_charge,
			},
			{
				freq = 1,
				rank = 2,
				unit = "cs_heavy",
				tactics = self._tactics.bulldozer_support_charge,
			},
		},
	}

	self.enemy_spawn_groups.fbi_defend_init = {
		amount = { 2, 3 },
		spawn = {
			{
				amount_max = 2,
				freq_by_diff = { 1, 2, 2 },
				rank = 3,
				unit = "fbi_agent_2_3",
				tactics = self._tactics.cop_init,
			},
			{
				amount_max = 2,
				freq_by_diff = { 2, 1, 0 },
				rank = 2,
				unit = "fbi_agent_1_2",
				tactics = self._tactics.cop_init,
			},
			{
				amount_max = 2,
				freq_by_diff = {
					25 / (difficulty_index ^ 2),
					0,
					0,
				},
				rank = 1,
				unit = "cs_cop",
				tactics = self._tactics.cop_init,
			},
		},
	}

	self.enemy_spawn_groups.fbi_defend_light = {
		amount = { 2, 3 },
		spawn = {
			{
				amount_max = 2,
				freq = 1,
				rank = 3,
				unit = "fbi_swat_2_3",
				tactics = self._tactics.none,
			},
			{
				amount_min = 1,
				freq = 2,
				rank = 2,
				unit = "fbi_swat_1",
				tactics = self._tactics.none,
			},
			{
				amount_max = 1,
				freq_by_diff = {
					25 / (difficulty_index ^ 2),
					0,
					0,
				},
				rank = 1,
				unit = "fbi_agent_3",
				tactics = self._tactics.none,
			},
		},
	}

	self.enemy_spawn_groups.fbi_defend_heavy = {
		amount = { 2, 3 },
		spawn = {
			{
				amount_max = 2,
				freq = 1,
				rank = 3,
				unit = "fbi_heavy_2",
				tactics = self._tactics.none,
			},
			{
				amount_min = 1,
				freq = 2,
				rank = 2,
				unit = "fbi_heavy_1",
				tactics = self._tactics.none,
			},
			{
				amount_max = 1,
				freq_by_diff = {
					75 / (difficulty_index ^ 2),
					50 / (difficulty_index ^ 2),
					25 / (difficulty_index ^ 2),
				},
				freq = 1,
				rank = 1,
				unit = "fbi_swat_3",
				tactics = self._tactics.none,
			},
		},
	}

	self.enemy_spawn_groups.fbi_stealth_light = {
		amount = { 2, 3 },
		spawn = {
			{
				amount_max = 2,
				freq_by_diff = { 0, 1, 1 },
				rank = 3,
				unit = "fbi_agent_2_3",
				tactics = self._tactics.hrt,
			},
			{
				amount_max = 2,
				freq_by_diff = { 1, 1, 0 },
				rank = 2,
				unit = "fbi_agent_1_2",
				tactics = self._tactics.hrt,
			},
		},
	}

	self.enemy_spawn_groups.fbi_stealth_heavy = {
		amount = { 2, 3 },
		spawn = {
			{
				amount_min = 1,
				freq = 4,
				rank = 2,
				unit = "fbi_agent_3",
				tactics = self._tactics.hrt,
			},
			{
				amount_max = 1,
				freq = (difficulty_index ^ 2) / 25,
				rank = 1,
				unit = "taser",
				random_unit = taser_cloaker,
				tactics = self._tactics.swat_support_flank,
			},
		},
	}

	self.enemy_spawn_groups.fbi_swats_ranged = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_max = 2,
				freq = 2,
				rank = 3,
				unit = "fbi_swat_2_3",
				tactics = self._tactics.swat_flank,
			},
			{
				amount_min = 2,
				amount_max = 3,
				freq = 3,
				rank = 2,
				unit = "fbi_swat_1",
				tactics = self._tactics.swat_ranged,
			},
			{
				amount_max = 3,
				freq_by_diff = { 10, 1, 0 },
				rank = 2,
				unit = "fbi_swat",
				tactics = self._tactics.swat_init,
			},
			{
				amount_max = 1,
				freq_by_diff = {
					0,
					(difficulty_index ^ 2) / 50,
					(difficulty_index ^ 2) / 25,
				},
				rank = 1,
				unit = "medic_1",
				random_unit = cloaker_medic_1,
				tactics = self._tactics.swat_support_ranged,
			},
		},
	}

	self.enemy_spawn_groups.fbi_swats_charge = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_max = 2,
				freq = 2,
				rank = 3,
				unit = "fbi_swat_1_3",
				tactics = self._tactics.swat_flank,
			},
			{
				amount_min = 2,
				amount_max = 3,
				freq = 3,
				rank = 2,
				unit = "fbi_swat_2",
				tactics = self._tactics.swat_ranged,
			},
			{
				amount_max = 3,
				freq_by_diff = { 10, 1, 0 },
				rank = 2,
				unit = "fbi_swat",
				tactics = self._tactics.swat_init,
			},
			{
				amount_max = 1,
				freq_by_diff = {
					0,
					(difficulty_index ^ 2) / 50,
					(difficulty_index ^ 2) / 25,
				},
				rank = 1,
				unit = "medic_2",
				random_unit = cloaker_medic_2,
				tactics = self._tactics.swat_support_charge,
			},
		},
	}

	self.enemy_spawn_groups.fbi_heavies_ranged = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_max = 2,
				freq = 2,
				rank = 3,
				unit = "fbi_heavy_2",
				tactics = self._tactics.swat_flank,
			},
			{
				amount_min = 2,
				amount_max = 3,
				freq = 3,
				rank = 2,
				unit = "fbi_heavy_1",
				tactics = self._tactics.swat_ranged,
			},
			{
				amount_max = 2,
				freq_by_diff = {
					75 / (difficulty_index ^ 2),
					50 / (difficulty_index ^ 2),
					25 / (difficulty_index ^ 2),
				},
				rank = 1,
				unit = "fbi_swat_1_3",
				tactics = self._tactics.swat_support_ranged,
			},
			{
				amount_max = 1,
				freq_by_diff = {
					0,
					(difficulty_index ^ 2) / 50,
					(difficulty_index ^ 2) / 25,
				},
				rank = 1,
				unit = "medic_1",
				random_unit = taser_medic_1,
				tactics = self._tactics.swat_support_ranged,
			},
		},
	}

	self.enemy_spawn_groups.fbi_heavies_charge = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_max = 2,
				freq = 2,
				rank = 3,
				unit = "fbi_heavy_1",
				tactics = self._tactics.swat_flank,
			},
			{
				amount_min = 2,
				amount_max = 3,
				freq = 3,
				rank = 2,
				unit = "fbi_heavy_2",
				tactics = self._tactics.swat_charge,
			},
			{
				amount_max = 2,
				freq_by_diff = {
					75 / (difficulty_index ^ 2),
					50 / (difficulty_index ^ 2),
					25 / (difficulty_index ^ 2),
				},
				rank = 1,
				unit = "fbi_swat_1_3",
				tactics = self._tactics.swat_support_charge,
			},
			{
				amount_max = 1,
				freq_by_diff = {
					0,
					(difficulty_index ^ 2) / 50,
					(difficulty_index ^ 2) / 25,
				},
				rank = 1,
				unit = "medic_2",
				random_unit = taser_medic_2,
				tactics = self._tactics.swat_support_charge,
			},
		},
	}

	self.enemy_spawn_groups.fbi_shield_ranged = {
		amount = { 4, 4 },
		spawn = {
			{
				amount_min = 1,
				amount_max = 2,
				freq = (difficulty_index ^ 2) / 25,
				rank = 3,
				unit = "fbi_shield",
				tactics = self._tactics.shield_ranged,
			},
			{
				freq_by_diff = { 1, 2, 1 },
				rank = 2,
				unit = "fbi_swat_1_3",
				tactics = self._tactics.shield_support_ranged,
			},
			{
				freq_by_diff = { 0, 1, 2 },
				rank = 2,
				unit = "fbi_heavy_1",
				tactics = self._tactics.shield_support_ranged,
			},
			{
				freq_by_diff = { 2, 0, 0 },
				rank = 1,
				unit = "fbi_agent_3",
				tactics = self._tactics.shield_support_ranged,
			},
			{
				amount_max = 1,
				freq_by_diff = {
					0,
					0,
					(difficulty_index ^ 2) / 50,
				},
				rank = 1,
				unit = "medic_1",
				tactics = self._tactics.shield_support_ranged,
			},
		},
	}

	self.enemy_spawn_groups.fbi_shield_charge = {
		amount = { 4, 4 },
		spawn = {
			{
				amount_min = 1,
				amount_max = 2,
				freq = (difficulty_index ^ 2) / 25,
				rank = 3,
				unit = "fbi_shield",
				tactics = self._tactics.shield_charge,
			},
			{
				freq_by_diff = { 1, 2, 1 },
				rank = 2,
				unit = "fbi_swat_2_3",
				tactics = self._tactics.shield_support_charge,
			},
			{
				freq_by_diff = { 0, 1, 2 },
				rank = 2,
				unit = "fbi_heavy_2",
				tactics = self._tactics.shield_support_charge,
			},
			{
				freq_by_diff = { 2, 0, 0 },
				rank = 1,
				unit = "fbi_agent_3",
				tactics = self._tactics.shield_support_charge,
			},
			{
				amount_max = 1,
				freq_by_diff = {
					0,
					0,
					(difficulty_index ^ 2) / 50,
				},
				rank = 1,
				unit = "medic_2",
				tactics = self._tactics.shield_support_charge,
			},
		},
	}

	self.enemy_spawn_groups.fbi_taser_flank = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_min = 1,
				amount_max = 2,
				freq = (difficulty_index ^ 2) / 25,
				rank = 2,
				unit = "taser_1",
				tactics = self._tactics.taser_flank,
			},
			{
				freq = 3,
				rank = 1,
				unit = "fbi_swat_1_3",
				tactics = self._tactics.taser_flank,
			},
		},
	}

	self.enemy_spawn_groups.fbi_taser_charge = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_min = 1,
				amount_max = 2,
				freq = (difficulty_index ^ 2) / 25,
				rank = 2,
				unit = "taser_2",
				tactics = self._tactics.taser_charge,
			},
			{
				freq = 3,
				rank = 1,
				unit = "fbi_swat_2_3",
				tactics = self._tactics.taser_charge,
			},
		},
	}

	self.enemy_spawn_groups.fbi_bulldozer_charge = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_min = 1,
				amount_max = 2,
				freq = (difficulty_index ^ 2) / 200,
				rank = 3,
				unit = "bulldozer",
				tactics = self._tactics.bulldozer_charge,
			},
			{
				amount_min = 2,
				freq = 1,
				rank = 2,
				unit = "fbi_heavy",
				tactics = self._tactics.bulldozer_support_charge,
			},
			{
				amount_max = 1,
				freq_by_diff = {
					0,
					0,
					(difficulty_index ^ 2) / 100,
				},
				rank = 1,
				unit = "medic_2",
				tactics = self._tactics.bulldozer_support_charge,
			},
		},
	}

	self.enemy_spawn_groups.fbi_cloaker_charge = {
		amount = { 2, 2 },
		spawn = {
			{
				freq = 1,
				rank = 1,
				unit = "cloaker",
				tactics = self._tactics.cloaker_charge,
			},
		},
	}

	self.enemy_spawn_groups.fbi_cloaker_hide = {
		amount = { 2, 2 },
		spawn = {
			{
				freq = 1,
				rank = 1,
				unit = "cloaker",
				tactics = self._tactics.cloaker_hide,
			},
		},
	}

	self.enemy_spawn_groups.elite_defend_light = {
		amount = { 2, 3 },
		spawn = {
			{
				amount_max = 2,
				freq = 2,
				rank = 3,
				unit = "elite_swat_2_3",
				tactics = self._tactics.none,
			},
			{
				amount_min = 1,
				freq = 4,
				rank = 2,
				unit = "elite_swat_1",
				tactics = self._tactics.none,
			},
			self:_distance_weighted_spawn_entry({
				amount_max = 1,
				freq_by_diff = {
					0,
					(difficulty_index ^ 2) / 50,
					(difficulty_index ^ 2) / 25,
				},
				rank = 1,
				unit = "elite_sniper",
				tactics = self._tactics.sniper,
			}, 1500, 3000, 0, 1),
		},
	}

	self.enemy_spawn_groups.elite_defend_heavy = {
		amount = { 2, 3 },
		spawn = {
			{
				amount_max = 2,
				freq = 1,
				rank = 2,
				unit = "elite_heavy_2",
				tactics = self._tactics.none,
			},
			{
				amount_min = 1,
				freq = 2,
				rank = 1,
				unit = "elite_heavy_1",
				tactics = self._tactics.none,
			},
			self:_distance_weighted_spawn_entry({
				amount_max = 1,
				freq_by_diff = {
					0,
					(difficulty_index ^ 2) / 50,
					(difficulty_index ^ 2) / 25,
				},
				rank = 1,
				unit = "elite_sniper",
				tactics = self._tactics.sniper,
			}, 1500, 3000, 0, 1),
		},
	}

	self.enemy_spawn_groups.elite_swats_ranged = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_max = 2,
				freq = 2,
				rank = 3,
				unit = "elite_swat_2_3",
				tactics = self._tactics.swat_flank,
			},
			{
				amount_min = 2,
				amount_max = 3,
				freq = 3,
				rank = 2,
				unit = "elite_swat_1",
				tactics = self._tactics.swat_ranged,
			},
			{
				amount_max = 1,
				freq_by_diff = {
					0,
					(difficulty_index ^ 2) / 50,
					(difficulty_index ^ 2) / 25,
				},
				rank = 1,
				unit = "medic_1",
				random_unit = cloaker_medic_1,
				tactics = self._tactics.swat_support_ranged,
			},
			self:_distance_weighted_spawn_entry({
				amount_max = 1,
				freq_by_diff = {
					0,
					(difficulty_index ^ 2) / 50,
					(difficulty_index ^ 2) / 25,
				},
				rank = 1,
				unit = "elite_sniper",
				tactics = self._tactics.sniper,
			}, 1500, 3000, 0, 1),
		},
	}

	self.enemy_spawn_groups.elite_swats_charge = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_max = 2,
				freq = 2,
				rank = 3,
				unit = "elite_swat_1_3",
				tactics = self._tactics.swat_flank,
			},
			{
				amount_min = 2,
				amount_max = 3,
				freq = 3,
				rank = 2,
				unit = "elite_swat_2",
				tactics = self._tactics.swat_ranged,
			},
			{
				amount_max = 1,
				freq_by_diff = {
					0,
					(difficulty_index ^ 2) / 50,
					(difficulty_index ^ 2) / 25,
				},
				rank = 1,
				unit = "medic_2",
				random_unit = cloaker_medic_2,
				tactics = self._tactics.swat_support_charge,
			},
		},
	}

	self.enemy_spawn_groups.elite_heavies_ranged = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_max = 2,
				freq = 1,
				rank = 3,
				unit = "elite_heavy_2",
				tactics = self._tactics.swat_flank,
			},
			{
				amount_min = 2,
				amount_max = 3,
				freq = 2,
				rank = 2,
				unit = "elite_heavy_1",
				tactics = self._tactics.swat_ranged,
			},
			{
				amount_max = 1,
				freq_by_diff = {
					0,
					(difficulty_index ^ 2) / 50,
					(difficulty_index ^ 2) / 25,
				},
				rank = 1,
				unit = "medic_1",
				random_unit = taser_medic_1,
				tactics = self._tactics.swat_support_ranged,
			},
			self:_distance_weighted_spawn_entry({
				amount_max = 1,
				freq_by_diff = {
					0,
					(difficulty_index ^ 2) / 50,
					(difficulty_index ^ 2) / 25,
				},
				rank = 1,
				unit = "elite_sniper",
				tactics = self._tactics.sniper,
			}, 1500, 3000, 0, 1),
		},
	}

	self.enemy_spawn_groups.elite_heavies_charge = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_max = 2,
				freq = 1,
				rank = 3,
				unit = "elite_heavy_1",
				tactics = self._tactics.swat_flank,
			},
			{
				amount_min = 2,
				amount_max = 3,
				freq = 2,
				rank = 2,
				unit = "elite_heavy_2",
				tactics = self._tactics.swat_charge,
			},
			{
				amount_max = 1,
				freq_by_diff = {
					0,
					(difficulty_index ^ 2) / 50,
					(difficulty_index ^ 2) / 25,
				},
				rank = 1,
				unit = "medic_2",
				random_unit = taser_medic_2,
				tactics = self._tactics.swat_support_charge,
			},
		},
	}

	self.enemy_spawn_groups.elite_shield_ranged = {
		amount = { 4, 4 },
		spawn = {
			{
				amount_min = 1,
				amount_max = 1,
				freq = 1,
				rank = 3,
				unit = "elite_shield",
				tactics = self._tactics.shield_ranged,
			},
			{
				freq_by_diff = { 2, 2, 1 },
				rank = 2,
				unit = "city_swat_1_3",
				tactics = self._tactics.shield_support_ranged,
			},
			{
				freq_by_diff = { 0, 1, 2 },
				rank = 2,
				unit = "fbi_heavy_1",
				tactics = self._tactics.shield_support_ranged,
			},
			{
				amount_max = 1,
				freq_by_diff = {
					0,
					0,
					(difficulty_index ^ 2) / 50,
				},
				rank = 1,
				unit = "medic_1",
				tactics = self._tactics.shield_support_ranged,
			},
			self:_distance_weighted_spawn_entry({
				amount_max = 1,
				freq_by_diff = {
					0,
					0,
					(difficulty_index ^ 2) / 50,
				},
				rank = 1,
				unit = "elite_sniper",
				tactics = self._tactics.sniper,
			}, 1500, 3000, 0, 1),
		},
	}

	self.enemy_spawn_groups.elite_shield_charge = {
		amount = { 4, 4 },
		spawn = {
			{
				amount_min = 1,
				amount_max = 1,
				freq = 1,
				rank = 3,
				unit = "elite_shield",
				tactics = self._tactics.shield_charge,
			},
			{
				freq_by_diff = { 2, 2, 1 },
				rank = 2,
				unit = "city_swat_2_3",
				tactics = self._tactics.shield_support_charge,
			},
			{
				freq_by_diff = { 0, 1, 2 },
				rank = 2,
				unit = "fbi_heavy_2",
				tactics = self._tactics.shield_support_charge,
			},
			{
				amount_max = 1,
				freq_by_diff = {
					0,
					0,
					(difficulty_index ^ 2) / 50,
				},
				rank = 1,
				unit = "medic_2",
				tactics = self._tactics.shield_support_charge,
			},
		},
	}

	self.enemy_spawn_groups.elite_taser_flank = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_min = 1,
				amount_max = 2,
				freq = (difficulty_index ^ 2) / 25,
				rank = 2,
				unit = "taser_1",
				tactics = self._tactics.taser_flank,
			},
			{
				freq = 3,
				rank = 1,
				unit = "elite_swat_1_3",
				tactics = self._tactics.taser_flank,
			},
		},
	}

	self.enemy_spawn_groups.elite_taser_takedown = {
		amount = { 2, 2 },
		spawn = {
			{
				amount_min = 1,
				freq = 1,
				rank = 2,
				unit = "taser",
				tactics = self._tactics.taser_flank,
			},
			{
				amount_min = 1,
				freq = 1,
				rank = 1,
				unit = "cloaker",
				tactics = self._tactics.swat_support_flank,
			},
		},
	}

	self.enemy_spawn_groups.elite_taser_charge = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_min = 1,
				amount_max = 2,
				freq = (difficulty_index ^ 2) / 25,
				rank = 2,
				unit = "taser_2",
				tactics = self._tactics.taser_charge,
			},
			{
				freq = 3,
				rank = 1,
				unit = "elite_swat_2_3",
				tactics = self._tactics.taser_charge,
			},
		},
	}

	self.enemy_spawn_groups.elite_bulldozer_charge = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_min = 1,
				amount_max = 2,
				freq = (difficulty_index ^ 2) / 200,
				rank = 3,
				unit = "elite_bulldozer",
				tactics = self._tactics.bulldozer_charge,
			},
			{
				amount_min = 2,
				freq = 1,
				rank = 2,
				unit = "fbi_heavy",
				tactics = self._tactics.bulldozer_support_charge,
			},
			{
				amount_max = 1,
				freq_by_diff = {
					0,
					0,
					(difficulty_index ^ 2) / 100,
				},
				rank = 1,
				unit = "medic_2",
				tactics = self._tactics.bulldozer_support_charge,
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
				tactics = self._tactics.bulldozer_charge,
			},
			{
				freq = 0.5,
				rank = 2,
				unit = "elite_bulldozer",
				tactics = self._tactics.bulldozer_charge,
			},
			{
				amount_min = 1,
				amount_max = 1,
				freq = 1,
				rank = 1,
				unit = "taser",
				tactics = self._tactics.bulldozer_support_charge,
			},
		},
	}

	self.enemy_spawn_groups.elite_bulldozer_shield = {
		amount = { 3, 3 },
		spawn = {
			{
				amount_min = 2,
				amount_max = 2,
				freq = 1,
				rank = 2,
				unit = "fbi_shield",
				tactics = self._tactics.shield_charge,
			},
			{
				freq = 1,
				rank = 1,
				unit = "bulldozer",
				tactics = self._tactics.bulldozer_support_charge,
			},
			{
				freq = 0.5,
				rank = 1,
				unit = "elite_bulldozer",
				tactics = self._tactics.bulldozer_support_charge,
			},
		},
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
GroupAITweakData.us_army_heists = {
	["arm_for"] = true,
	--["roberts"] = true,
	["crojob2"] = true,
	["crojob3"] = true,
	["jolly"] = true,
	["peta2"] = true,
	["trai"] = true,
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
			"murder",
		},
		murky_agg = {
			"charge",
			"deathguard",
			"murder",
		},
		murky_snk = {
			"flank",
			"deathguard",
			"murder",
		},
		fbi_def = {
			"rescue",
			"ranged_fire",
		},
		fbi_snk = {
			"rescue",
			"flank",
		},
		army_def = {
			"ranged_fire",
			"flash_grenade",
			"smoke_grenade",
		},
		army_agg = {
			"charge",
			"flash_grenade",
			"smoke_grenade",
			"murder",
		},
		army_spt = {
			"unit_cover",
			"ranged_fire",
		},
		bellmead_def = {
			"ranged_fire",
			"murder",
		},
		bellmead_agg = {
			"charge",
			"deathguard",
			"murder",
		},
		bellmead_snk = {
			"flank",
			"deathguard",
			"murder",
		},
	}

	self.timed_enemy_spawn_groups = {}

	if self.fbi_heists[level_id] then
		self.timed_enemy_spawn_groups = {
			{
				timer_data = {
					initial_delay = 0,
					cooldown = { 15, 30 },
					diff_scale = { 1, 1.5, 2 },
				},
				group_data = {
					fbi_timed_group = {
						enabled = true,
						team_id = "law1",
						max_nr_simultaneous_groups = 2,
						amount = { 3, 3 },
						disable_timer = nil,
						disable_diff = 0.75,
						objective = function(spawn_group)
							return {
								attitude = "engage",
								pose = "stand",
								type = "assault_area",
								stance = "hos",
								area = spawn_group.area,
								coarse_path = {
									{
										spawn_group.area.pos_nav_seg,
										spawn_group.area.pos,
									},
								},
							}
						end,
						spawn = {
							{
								amount_min = 1,
								rank = 2,
								freq = 1,
								unit = "fbi_readyteam",
								tactics = self._timed_tactics.fbi_def,
							},
							{
								amount_max = 2,
								rank = 2,
								freq = 0.5,
								unit = "fbi_readyteam",
								tactics = self._timed_tactics.fbi_snk,
							},
						},
						spawn_point_chk_ref = table.list_to_set({
							"tac_swat_rifle",
							"tac_swat_rifle_flank",
						}),
					},
				},
			},
		}
	end
	if self.murky_response_heists[level_id] then
		self.timed_enemy_spawn_groups = {
			{
				timer_data = {
					initial_delay = 0,
					cooldown = { 15, 30 },
					diff_scale = { 1, 1.5, 2 },
				},
				group_data = {
					murkywater_timed_group = {
						enabled = true,
						team_id = "law1",
						max_nr_simultaneous_groups = 2,
						amount = { 3, 3 },
						disable_timer = 360, -- 6 minutes
						disable_diff = nil,
						objective = function(spawn_group)
							return {
								attitude = "engage",
								pose = "stand",
								type = "assault_area",
								stance = "hos",
								area = spawn_group.area,
								coarse_path = {
									{
										spawn_group.area.pos_nav_seg,
										spawn_group.area.pos,
									},
								},
							}
						end,
						spawn = {
							{
								amount_min = 1,
								rank = 2,
								freq = 1,
								unit = "murkywater",
								tactics = self._timed_tactics.murky_def,
							},
							{
								amount_max = 2,
								rank = 2,
								freq = 0.4,
								unit = "murkywater",
								tactics = self._timed_tactics.murky_agg,
							},
							{
								amount_max = 2,
								rank = 2,
								freq = 0.6,
								unit = "murkywater",
								tactics = self._timed_tactics.murky_snk,
							},
						},
						spawn_point_chk_ref = table.list_to_set({
							"tac_swat_rifle",
							"tac_swat_rifle_flank",
						}),
					},
				},
			},
		}
	end
	if self.us_army_heists[level_id] then
		self.timed_enemy_spawn_groups = {
			{
				timer_data = {
					initial_delay = 180,
					cooldown = { 20, 30 },
					diff_scale = { 2, 1.5, 1 },
				},
				group_data = {
					army_timed_group = {
						enabled = true,
						team_id = "law1",
						max_nr_simultaneous_groups = 2,
						amount = { 3, 3 },
						disable_timer = nil,
						disable_diff = nil,
						objective = function(spawn_group)
							return {
								attitude = "engage",
								pose = "stand",
								type = "assault_area",
								stance = "hos",
								area = spawn_group.area,
								coarse_path = {
									{
										spawn_group.area.pos_nav_seg,
										spawn_group.area.pos,
									},
								},
							}
						end,
						spawn = {
							{
								amount_min = 1,
								rank = 2,
								freq = 1,
								unit = "army_soldier_2",
								tactics = self._tactics.army_def,
							},
							{
								amount_max = 2,
								rank = 2,
								freq_by_diff = {
									difficulty_index / 16,
									difficulty_index / 12,
									difficulty_index / 8,
								},
								unit = "army_soldier_2",
								tactics = self._tactics.army_agg,
							},
							{
								amount_max = 1,
								rank = 1,
								freq_by_diff = {
									0,
									difficulty_index / 30,
									difficulty_index / 10,
								},
								unit = "army_soldier_3",
								tactics = self._timed_tactics.army_spt,
							},
						},
						spawn_point_chk_ref = table.list_to_set({
							"tac_swat_rifle",
							"tac_swat_rifle_flank",
						}),
					},
				},
			},
		}
	end
	if self.bellmead_response_heists[level_id] then
		self.timed_enemy_spawn_groups = {
			{
				timer_data = {
					initial_delay = 0,
					cooldown = { 15, 30 },
					diff_scale = { 1, 1.5, 2 },
				},
				group_data = {
					bellmead_timed_group = {
						enabled = true,
						team_id = "law1",
						max_nr_simultaneous_groups = 2,
						amount = { 3, 3 },
						disable_timer = nil,
						disable_diff = nil,
						objective = function(spawn_group)
							return {
								attitude = "engage",
								pose = "stand",
								type = "assault_area",
								stance = "hos",
								area = spawn_group.area,
								coarse_path = {
									{
										spawn_group.area.pos_nav_seg,
										spawn_group.area.pos,
									},
								},
							}
						end,
						spawn = {
							{
								amount_min = 1,
								rank = 2,
								freq = 1,
								unit = "bellmead_security",
								tactics = self._timed_tactics.bellmead_def,
							},
							{
								amount_max = 2,
								rank = 2,
								freq = 0.4,
								unit = "bellmead_security",
								tactics = self._timed_tactics.bellmead_agg,
							},
							{
								amount_max = 2,
								rank = 2,
								freq = 0.6,
								unit = "bellmead_security",
								tactics = self._timed_tactics.bellmead_snk,
							},
						},
						spawn_point_chk_ref = table.list_to_set({
							"tac_swat_rifle",
							"tac_swat_rifle_flank",
						}),
					},
				},
			},
		}
	end
end

Hooks:PostHook(GroupAITweakData, "_init_task_data", "eclipse__init_task_data", function(self, difficulty_index)
	local level_scale_mul = Eclipse.level_scale and Eclipse.level_scale.scale_multiplier(level_id) or 1

	if level_id then
		Eclipse:log_console("Map scale multiplier for " .. level_id .. " set to " .. level_scale_mul)
	end

	local force_mul = level_scale_mul
	local spawnrate_mul = math.sqrt(force_mul)

	local is_ambush = self._mission_preset and self._mission_preset == "ambush"
	local is_high_alert = self._mission_preset and self._mission_preset == "high_alert"
	local is_small_urban = self._mission_preset and self._mission_preset == "small_urban"
	local is_remote = self._mission_preset and self._mission_preset == "remote"
	local is_skyscraper = self._mission_preset and self._mission_preset == "skyscraper"

	-- Assault Data
	-- AI Tickrate
	self.ai_tickrate = 1 / (is_pro_job and 90 or 60)

	--In-heist difficulty scaling
	self.difficulty_curve_points = { 0.5 }
	self.difficulty_step_time = 15

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
	self.besiege.first_responders_delay_per_map = {
		branchbank = 60,
	}
	self.besiege.assault.delay = {
		diff_lerp(50, 40),
		diff_lerp(40, 30),
		diff_lerp(30, 20),
	}
	self.besiege.assault.hostage_hesitation_delay = { 10, 7.5, 5 }

	self.besiege.assault.fade = {
		enemies_defeated_percentage = 0.5,
		enemies_defeated_time = 30,
		engagement_percentage = 0.25,
		engagement_time = 20,
		drama_time = 10,
	}

	-- SPAWNS --

	-- Spawncap
	self.besiege.assault.force = {
		diff_lerp(4, 6) * force_mul,
		diff_lerp(6, 9) * force_mul,
		diff_lerp(8, 12) * force_mul,
	}
	self.besiege.assault.force_balance_mul = { 1, 1.25, 1.5, 1.75 }

	self.besiege.assault.force_pool = {
		self.besiege.assault.force[1] * 10,
		self.besiege.assault.force[2] * 10,
		self.besiege.assault.force[3] * 10,
	}
	self.besiege.assault.force_pool_balance_mul = { 0.75, 1, 1.25, 1.5 }

	-- Spawnrate
	self.spawn_kill_cooldown = 10

	self.besiege.assault.spawnrate = {
		diff_lerp(3, 2) / spawnrate_mul,
		diff_lerp(2.5, 1.5) / spawnrate_mul,
		diff_lerp(2, 1) / spawnrate_mul,
	}
	self.besiege.assault.spawnrate_balance_mul = { 2.5, 2, 1.5, 1 }

	-- RECON / REENFORCE --

	-- Reenforce spawn interval
	self.besiege.reenforce.interval = { 15, 30, 45 }

	-- Recon spawn interval and spawncap
	self.besiege.recon.interval_variation = 20
	self.besiege.recon.force = {
		2 * math.sqrt(force_mul),
		4 * math.sqrt(force_mul),
		6 * math.sqrt(force_mul),
	}

	self.besiege.push_delay = {
		diff_lerp(20, 16),
		diff_lerp(16, 12),
		diff_lerp(12, 8),
	}

	-- GRENADES --
	self.min_grenade_timeout = 20

	local timeout_mult = diff_lerp(1, 0.75)

	self.flash_grenade.light_color = Vector3(255, 255, 255)
	self.flash_grenade.light_range = (is_eclipse and 0) or 500
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
			cs_cops_init = { 18, 0, 0 },

			cs_swats_ranged = { 36, 48, 16 },
			cs_swats_charge = { 18, 24, 8 },

			cs_heavies_ranged = { 0, 0, 32 },
			cs_heavies_charge = { 0, 0, 16 },

			cs_shield_ranged = { 0, 2, 4 },
			cs_shield_charge = { 0, 2, 4 },
		}
		self.besiege.recon.groups = {
			cs_stealth_light = { 1, 3, 1 },
			cs_stealth_heavy = { 0, 1, 3 },
		}
		self.besiege.reenforce.groups = {
			cs_defend_init = { 1, 1, 0 },
			cs_defend_light = { 0, 1, 1 },
		}
	elseif difficulty_index == 3 then
		self.besiege.assault.groups = {
			cs_cops_init = { 18, 0, 0 },

			cs_swats_ranged = { 36, 48, 16 },
			cs_swats_charge = { 18, 24, 8 },

			cs_heavies_ranged = { 0, 0, 16 },
			cs_heavies_charge = { 0, 0, 8 },

			cs_shield_ranged = { 0, 2, 4 },
			cs_shield_charge = { 0, 2, 4 },

			cs_taser_flank = { 0, 2, 4 },
			cs_taser_charge = { 0, 2, 4 },

			cs_bulldozer_charge = { 0, 0, 4 },
		}
		self.besiege.recon.groups = {
			cs_stealth_light = { 1, 3, 1 },
			cs_stealth_heavy = { 0, 1, 3 },
		}
		self.besiege.reenforce.groups = {
			cs_defend_init = { 1, 1, 0 },
			cs_defend_light = { 0, 1, 1 },
		}
	elseif difficulty_index == 4 then
		self.besiege.assault.groups = {
			cs_swats_ranged = { 48, 24, 0 },
			cs_swats_charge = { 24, 12, 0 },

			fbi_swats_ranged = { 0, 24, 16 },
			fbi_swats_charge = { 0, 12, 8 },

			fbi_heavies_ranged = { 0, 0, 32 },
			fbi_heavies_charge = { 0, 0, 16 },

			fbi_shield_ranged = { 0, 3, 6 },
			fbi_shield_charge = { 0, 3, 6 },

			fbi_taser_flank = { 0, 3, 6 },
			fbi_taser_charge = { 0, 3, 6 },

			fbi_cloaker_hide = { 0, 3, 6 },
			fbi_cloaker_charge = { 0, 3, 6 },

			fbi_bulldozer_charge = { 0, 0, 6 },
		}
		self.besiege.recon.groups = {
			fbi_stealth_light = { 1, 3, 1 },
			fbi_stealth_heavy = { 0, 1, 3 },
		}
		self.besiege.reenforce.groups = {
			fbi_defend_init = { 1, 1, 0 },
			fbi_defend_light = { 0, 1, 1 },
		}
	elseif difficulty_index == 5 then
		self.besiege.assault.groups = {
			cs_swats_ranged = { 32, 12, 0 },
			cs_swats_charge = { 16, 6, 0 },

			fbi_swats_ranged = { 0, 36, 16 },
			fbi_swats_charge = { 0, 18, 8 },

			fbi_heavies_ranged = { 0, 0, 32 },
			fbi_heavies_charge = { 0, 0, 16 },

			fbi_shield_ranged = { 0, 4, 8 },
			fbi_shield_charge = { 0, 4, 8 },

			fbi_taser_flank = { 0, 4, 8 },
			fbi_taser_charge = { 0, 4, 8 },

			fbi_cloaker_hide = { 0, 4, 8 },
			fbi_cloaker_charge = { 0, 4, 8 },

			fbi_bulldozer_charge = { 0, 0, 8 },
		}
		self.besiege.recon.groups = {
			fbi_stealth_light = { 1, 3, 1 },
			fbi_stealth_heavy = { 0, 1, 3 },
		}
		self.besiege.reenforce.groups = {
			fbi_defend_init = { 1, 1, 0 },
			fbi_defend_light = { 0, 1, 1 },
		}
	else
		self.besiege.assault.groups = {
			cs_swats_ranged = { 24, 0, 0 },
			cs_swats_charge = { 12, 0, 0 },

			fbi_swats_ranged = { 24, 24, 0 },
			fbi_swats_charge = { 12, 12, 0 },

			elite_swats_ranged = { 0, 16, 24 },
			elite_swats_charge = { 0, 8, 12 },

			fbi_heavies_ranged = { 0, 8, 24 },
			fbi_heavies_charge = { 0, 4, 12 },

			fbi_shield_ranged = { 0, 5, 5 },
			fbi_shield_charge = { 0, 5, 5 },

			elite_shield_ranged = { 0, 0, 5 },
			elite_shield_charge = { 0, 0, 5 },

			elite_taser_flank = { 0, 5, 10 },
			elite_taser_charge = { 0, 5, 10 },
			elite_taser_takedown = { 0, 5, 10 },

			fbi_cloaker_hide = { 0, 5, 10 },
			fbi_cloaker_charge = { 0, 5, 10 },

			elite_bulldozer_charge = { 0, 0, 4 },
			elite_bulldozer_shield = { 0, 0, 3 },
			elite_bulldozer_takedown = { 0, 0, 3 },
		}
		self.besiege.recon.groups = {
			fbi_stealth_light = { 1, 3, 1 },
			fbi_stealth_heavy = { 0, 1, 3 },
		}
		self.besiege.reenforce.groups = {
			fbi_defend_init = { 2, 1, 0 },
			fbi_defend_light = { 0, 2, 1 },
			elite_defend_light = { 0, 0, 2 },
		}
	end

	self.besiege.cloaker.groups = {
		single_spooc = { 1, 1, 1 },
	}

	self.besiege.recurring_group_SO.recurring_cloaker_spawn.interval = {
		diff_lerp(120, 20),
		diff_lerp(180, 40),
	}

	self.besiege.assault.groups.single_spooc = { 0, 0, 0 }
	self.besiege.assault.groups.Phalanx = { 0, 0, 0 }
	self.besiege.assault.groups.marshal_squad = { 0, 0, 0 }
	self.besiege.assault.groups.custom_assault = { 0, 0, 0 }
	self.besiege.assault.groups.snowman_boss = { 0, 0, 0 }
	self.besiege.assault.groups.piggydozer = { 0, 0, 0 }
	-- recurring groups
	self.besiege.assault.groups.fbi_timed_group = { 0, 0, 0 }
	self.besiege.assault.groups.murkywater_timed_group = { 0, 0, 0 }
	self.besiege.assault.groups.army_timed_group = { 0, 0, 0 }
	self.besiege.assault.groups.bellmead_timed_group = { 0, 0, 0 }

	self.besiege.recon.groups.single_spooc = { 0, 0, 0 }
	self.besiege.recon.groups.Phalanx = { 0, 0, 0 }
	self.besiege.recon.groups.marshal_squad = { 0, 0, 0 }
	self.besiege.recon.groups.custom_recon = { 0, 0, 0 }
	self.besiege.recon.groups.snowman_boss = { 0, 0, 0 }
	self.besiege.recon.groups.piggydozer = { 0, 0, 0 }
	-- recurring groups
	self.besiege.recon.groups.fbi_timed_group = { 0, 0, 0 }
	self.besiege.recon.groups.murkywater_timed_group = { 0, 0, 0 }
	self.besiege.recon.groups.army_timed_group = { 0, 0, 0 }
	self.besiege.recon.groups.bellmead_timed_group = { 0, 0, 0 }

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
	self.ponr.recon.groups = {}
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
			fbi_swats_ranged = { 8, 8, 8 },
			fbi_swats_charge = { 4, 4, 4 },

			fbi_heavies_ranged = { 16, 16, 16 },
			fbi_heavies_charge = { 8, 8, 8 },

			fbi_shield_ranged = { 6, 6, 6 },
			fbi_shield_charge = { 6, 6, 6 },
		}
		self.ponr.reenforce.groups = {
			fbi_defend_light = { 2, 2, 2 },
			fbi_defend_heavy = { 1, 1, 1 },
		}
	elseif difficulty_index == 3 then
		self.ponr.assault.groups = {
			fbi_swats_ranged = { 8, 8, 8 },
			fbi_swats_charge = { 4, 4, 4 },

			fbi_heavies_ranged = { 16, 16, 16 },
			fbi_heavies_charge = { 8, 8, 8 },

			fbi_shield_ranged = { 6, 6, 6 },
			fbi_shield_charge = { 6, 6, 6 },

			fbi_taser_flank = { 4, 4, 4 },
			fbi_taser_charge = { 4, 4, 4 },

			fbi_bulldozer_charge = { 4, 4, 4 },
		}
		self.ponr.reenforce.groups = {
			fbi_defend_light = { 2, 2, 2 },
			fbi_defend_heavy = { 1, 1, 1 },
		}
	elseif difficulty_index == 4 then
		self.ponr.assault.groups = {
			elite_swats_ranged = { 12, 12, 12 },
			elite_swats_charge = { 6, 6, 6 },

			fbi_heavies_ranged = { 12, 12, 12 },
			fbi_heavies_charge = { 6, 6, 6 },

			fbi_shield_ranged = { 4, 4, 4 },
			fbi_shield_charge = { 4, 4, 4 },

			elite_shield_ranged = { 4, 4, 4 },
			elite_shield_charge = { 4, 4, 4 },

			elite_taser_flank = { 6, 6, 6 },
			elite_taser_charge = { 6, 6, 6 },

			fbi_cloaker_hide = { 6, 6, 6 },
			fbi_cloaker_charge = { 6, 6, 6 },

			fbi_bulldozer_charge = { 3, 3, 3 },

			elite_bulldozer_charge = { 3, 3, 3 },
		}
		self.ponr.reenforce.groups = {
			elite_defend_light = { 1, 1, 1 },
			fbi_defend_heavy = { 1, 1, 1 },
		}
	elseif difficulty_index == 5 then
		self.ponr.assault.groups = {
			elite_swats_ranged = { 12, 12, 12 },
			elite_swats_charge = { 6, 6, 6 },

			fbi_heavies_ranged = { 12, 12, 12 },
			fbi_heavies_charge = { 6, 6, 6 },

			fbi_shield_ranged = { 6, 6, 6 },
			fbi_shield_charge = { 6, 6, 6 },

			elite_shield_ranged = { 6, 6, 6 },
			elite_shield_charge = { 6, 6, 6 },

			elite_taser_flank = { 8, 8, 8 },
			elite_taser_charge = { 8, 8, 8 },

			fbi_cloaker_hide = { 8, 8, 8 },
			fbi_cloaker_charge = { 8, 8, 8 },

			fbi_bulldozer_charge = { 4, 4, 4 },

			elite_bulldozer_charge = { 4, 4, 4 },
		}
		self.ponr.reenforce.groups = {
			elite_defend_light = { 1, 1, 1 },
			fbi_defend_heavy = { 1, 1, 1 },
		}
	else
		self.ponr.assault.groups = {
			elite_swats_ranged = { 8, 8, 8 },
			elite_swats_charge = { 4, 4, 4 },

			elite_heavies_ranged = { 16, 16, 16 },
			elite_heavies_charge = { 8, 8, 8 },

			elite_shield_ranged = { 10, 10, 10 },
			elite_shield_charge = { 10, 10, 10 },

			elite_taser_flank = { 10, 10, 10 },
			elite_taser_charge = { 10, 10, 10 },

			fbi_cloaker_hide = { 10, 10, 10 },
			fbi_cloaker_charge = { 10, 10, 10 },

			elite_bulldozer_charge = { 10, 10, 10 },
		}
		self.ponr.reenforce.groups = {
			elite_defend_light = { 1, 1, 1 },
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
		self:_run_group_ai_preset(self._mission_preset)

		Eclipse:log_console("Group AI preset for " .. level_id .. " set to " .. self._mission_preset)
	end
end)
