local diff_i = tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or "normal")
local is_pro = Global.game_settings and Global.game_settings.one_down
local escapeshield = ((diff_i == 6 and is_pro) and "units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield") or "units/payday2/characters/ene_shield_1/ene_shield_1"
local escapedozer = ((diff_i == 6 and is_pro) and "units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer") or "units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"
local vaultAmbush = Idstring("units/payday2/characters/ene_spook_1/ene_spook_1")
local vaultCount = 4
local vaultAmbushChance = 0.5
if math.random() < vaultAmbushChance then
	vaultAmbush = "units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"
	vaultCount = 2
end

return {
	-- Disable forced manager flee objective
	[100665] = {
		values = {
			enabled = false
		}
	},
	-- Disable the right vault path
	[105498] = {
		values = {
			enabled = false
		}
	},
	-- nuke swat van
	[105921] = {
		values = {
			enabled = false
		}
	},
	-- vault ambush
	[104132] = {
		enemy = vaultAmbush
	},
	[104170] = {
		enemy = vaultAmbush
	},
	[104131] = {
		enemy = vaultAmbush
	},
	[104169] = {
		enemy = vaultAmbush
	},
	[100763] = {
		enemy = vaultAmbush
	},
	[104000] = {
		chance = 15 * diff_i
	},
	[100225] = {
		values = {
			amount = vaultCount
		}
	},
	[103999] = {
		values = {
			enabled = false
		}
	},
	[103985] = {
		values = {
			enabled = false
		}
	},
	[104049] = {
		values = {
			enabled = false
		}
	},
	-- slow down a few repel spawnpoints
	[105112] = {
		values = {
			interval = 30
		}
	},
	[106890] = {
		values = {
			interval = 30
		}
	},
	[103953] = {
		values = {
			interval = 10
		}
	},

	-- custom spawns
	-- add point of no return and spawn lobby ambushes
	[101660] = {
		ponr = {
			length = 150,
			player_mul = { 1.1, 0.9, 0.7, 0.5 }
		},
		on_executed = {
			{ id = 400000, delay = 0 },
			{ id = 400001, delay = 1 },
			{ id = 400002, delay = 2 },
			{ id = 400003, delay = 3 },
			{ id = 400004, delay = 4 },
			{ id = 400005, delay = 5 },
			{ id = 400006, delay = 6 },
			{ id = 400007, delay = 7 },
			{ id = 400027, delay = 8 },
			{ id = 400028, delay = 9 },
		}
	},
	-- two dozers spawn on e/pj when leaving vault
	-- also two hallway escape shields on ovk+ (chance) and guaranteed on e/pj
	[103705] = {
		on_executed = {
			{ id = 400050, delay = 0 },
			{ id = 400051, delay = 0 },
			{ id = 400015, delay = 15 },
			{ id = 400016, delay = 15 }
		}
	},
	-- spawn two extra dozers on eclipse as a 193+ throwback
	[100850] = {
		on_executed = {
			{ id = 400012, delay = 20 },
			{ id = 400013, delay = 20 },
			{ id = 101953, delay = 100 }
		}
	},
	-- Make this Bo Dozer use custom set up AI_Hunt
	[105119] = {
		on_executed = {
			{ id = 400014, delay = 0 }
		}
	},
	-- one extra Bo Dozer
	[101953] = {
		on_executed = {
			{ id = 400011, delay = 1 }
		}
	},
	-- Killing Bo The Manager results of spawning two angry dozers
	[100689] = {
		on_executed = {
			{ id = 100682, delay = 0 }
		}
	},
	-- 2 blockade shields in vault area
	[100635] = {
		on_executed = {
			{ id = 400023, delay = 0 },
			{ id = 400024, delay = 0 }
		}
	},
	-- rework the escape sequence scripted spawns
	-- remove spawning the group and spawn 3 tasers+1 heavy swat as a 145+ throwback on hard and above
	-- spawn 2 Zeal Dozers as a sudden spawn on E/PJ (50% chance)
	[103710] = {
		chance = 100,
		on_executed = {
			{ id = 101400, remove = true },
			{ id = 400017, delay = 0 },
			{ id = 400018, delay = 0 },
			{ id = 400019, delay = 0 },
			{ id = 400020, delay = 0 },
			{ id = 400021, delay = 1, delay_rand = 1 },
			{ id = 400022, delay = 1, delay_rand = 1 }
		}
	},
	-- disable a bunch of vanilla spawns i don't like
	[103595] = {
		values = {
			enabled = false
		}
	},
	[102575] = {
		values = {
			enabled = false
		}
	},
	[103578] = {
		values = {
			enabled = false
		}
	},
	[103669] = {
		values = {
			enabled = false
		}
	},
	-- replace them with cooler ambush
	[100589] = {
		on_executed = {
			{ id = 400031, delay = 0 },
			{ id = 400033, delay = 0 },
			{ id = 400034, delay = 0 },
			{ id = 400036, delay = 0 },
			{ id = 400038, delay = 0 },
			{ id = 400040, delay = 0 },
			{ id = 400042, delay = 0 },
			{ id = 400043, delay = 0 },
			{ id = 400044, delay = 0 },
			{ id = 400045, delay = 0 },
		}
	},
	-- make the rest of vanilla spawns turn into zeals on E/PJ
	-- 2 shields at the bottom of the staircase
	[103693] = {
		enemy = escapeshield
	},
	[103697] = {
		enemy = escapeshield
	},
	-- door knock dozers
	[103162] = {
		enemy = escapedozer
	},
	[103163] = {
		enemy = escapedozer
	},
	[103198] = {
		enemy = escapedozer
	},
	[103231] = {
		enemy = escapedozer
	},
	-- ambush cloakers
	[103136] = {
		enemy = escapedozer
	},
	[103143] = {
		enemy = escapedozer
	},
	[103151] = {
		enemy = escapedozer
	},
}
