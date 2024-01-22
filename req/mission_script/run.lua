local diff_i = tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or "normal")
local is_pro = Global.game_settings and Global.game_settings.one_down
local HeliDrop1 = Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1")
local HeliDrop2 = Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1")
local HeliDropChance = 12.5 * diff_i
if diff_i == 6 and is_pro then -- you get fucked on eclipse pro job
	HeliDropChance = 100
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
		},
		chance = HeliDropChance
	},
	[103591] = {
		values = {
			difficulty_overkill_145 = true, -- add ovk to low diff filter
			difficulty_normal = false, -- let's not do easy though
		},
	},
	[103590] = {
		values = {
			difficulty_overkill_145 = false -- exclude ovk from eclipse only filter
		}
	},
	[103593] = {
		chance = HeliDropChance
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
	[103578] = {
		chance = 12.5 * diff_i -- roof snipers ovk/eclipse chance
	},
	[103579] = {
		chance = 12.5 * diff_i -- roof snipers normal/hard chance
	},
	[101412] = {
		chance = 10 * diff_i -- alleyway sniper chance
	},
	[101010] = {
		values = {
			enabled = false -- disable far armitage sniper trigger in the first sequence of the heist
		}
	},
	[101262] = {
		on_executed = {
			{ id = 100567, delay = 0} -- far armitage sniper
		}
	},
	[100567] = {
		values = {
			on_executed = {
				{ id = 103563, delay = 0 } -- new SO for far armitage sniper
			}
		}
	},
	[103447] = {
		values = {
			enabled = true, -- reenable balcony parking lot sniper
			participate_to_group_ai = false
		}
	},
	[100959] = {
		on_executed = { -- roof snipers when you make a left turn to easy street
			{ id = 103581, delay = 0 }, -- ovk/eclipse filter
			{ id = 103582, delay = 0 }, -- normal/hard filter
		}
	},
	[102866] = {
		values = {
			enabled = false -- disable vanilla ponr
		}
	},
	[102880] = {
		values = {
			enabled = false -- disable vanilla ponr
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
