local diff_i = tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or "normal")
local DozerChance = 0
if diff_i == 6 then
	DozerChance = 100
end

return {
	[101356] = {
		ponr = 480,
		ponr_player_mul = {2, 1.5, 1.25, 1}
	},
	-- ovk145-alike dozer spawn on armitage avenue
	[103592] = {
		values = {
			enabled = false -- this one is used for difficulties below ovk (we don't want the heli there in the first place)
		}
	},
	[103593] = {
		values = {
			chance = DozerChance -- this is cringe cause it's turned on for normal ovk as well and we only want the armitage dozers to drop on Eclipse
		}
	},
	[100232] = {
		enemy = Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1")
	},
	[100341] = {
		enemy = Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2")
	},
	[100351] = {
		enemy = Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3")
	},
	[101202] = {
		values = {
			on_executed = {
				{delay = 5, id = 100232},
				{delay = 5, id = 100341},
				{delay = 5, id = 100351},
				{delay = 0, id = 101669},
				{delay = 15, id = 101648},
			}
		}
	},
	-- add missing sniper
	[103582] = {
		values = {
			difficulty_overkill_145 = true,
			difficulty_easy_wish = true
		}
	},
	[102866] = {
		values = {
			enabled = false
		}
	},
	[102880] = {
		values = {
			enabled = false
		}
	},
	[100029] = {
		values = {
			interval = 20
		}
	},
	-- slow down inkwell industrial spawnpoints
	[100441] = {
		values = {
			interval = 60
		}
	},
	[103333] = {
		values = {
			interval = 40
		}
	},
	[103719] = {
		values = {
			interval = 30
		}
	}
}
