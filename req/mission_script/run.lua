local diff_i = tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or "normal")
local HeliDrop1 = Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1")
local HeliDrop2 = Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1")
if diff_i == 6 then -- you get fucked on eclipse
	HeliDrop1 = Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic")
	HeliDrop2 = Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3")
end

return {
	[101356] = {
		ponr = {
			length = 480,
			player_mul = {2, 1.5, 1.25, 1}
		}
	},
	-- ovk145-alike dozer spawn on armitage avenue
	[103592] = {
		values = {
			enabled = true,
			difficulty_overkill_145 = true, -- ovk and below filter
		},
		chance = 100
	},
	[103590] = {
		values = {
			difficulty_overkill_145 = false -- eclipse only filter
		}
	},
	[103593] = {
		chance = 100
	},
	[100036] = {
		spawn_instigator_ids = {
			103586 -- give hunt logic to the fourth spawn
		}
	},
	[103586] = {
		enemy = HeliDrop1,
		difficulty = 0.2 -- lower assault diff when bossfight begins
	},
	[100232] = {
		enemy = HeliDrop1
	},
	[100341] = {
		enemy = HeliDrop2
	},
	[100351] = {
		enemy = HeliDrop2
	},
	[101202] = {
		values = {
			on_executed = {
				{delay = 5, id = 100232},
				{delay = 5, id = 100341},
				{delay = 5, id = 100351},
				{delay = 5, id = 103586},
				{delay = 0, id = 101669},
				{delay = 15, id = 101648},
			}
		}
	},
	[100271] = {
		difficulty = 1 -- set difficulty to max after the bossfight
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
