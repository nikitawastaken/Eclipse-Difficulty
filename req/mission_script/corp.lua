local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local is_eclipse = Eclipse.utils.is_eclipse()
local scripted_enemy = Eclipse.scripted_enemy

local bellmead_1 = scripted_enemy.bellmead_security_1
local bellmead_heavy_1 = scripted_enemy.bellmead_gunner_1
local bellmead_heavy_2 = scripted_enemy.bellmead_gunner_2
local green_bulldozer = scripted_enemy.bulldozer_1
local black_bulldozer = scripted_enemy.bulldozer_2
local elite_ben_bulldozer = scripted_enemy.elite_bulldozer_1
local elite_skull_bulldozer = scripted_enemy.elite_bulldozer_2
local cloaker = scripted_enemy.cloaker
local medic = scripted_enemy.medic_1
local taser = scripted_enemy.taser_1

local disabled = {
	values = {
		enabled = false,
	},
}
local bellmead_mercs = { [bellmead_1] = 5, [bellmead_heavy_1] = 1, [bellmead_heavy_2] = 1 }
local bellmead_merc = {
	enemy = bellmead_mercs,
}
local specials_list_eclipse = { [taser] = 2, [medic] = 2, [cloaker] = 2, [elite_ben_bulldozer] = 1 }
local specials_list_hard_ovk = { [taser] = 4, [medic] = 3, [cloaker] = 2, [green_bulldozer] = 1 }
local specials_list_easy_normal = { [taser] = 3, [cloaker] = 1 }
local specials = {
	enemy = normal and specials_list_easy_normal or hard and specials_list_hard_ovk or specials_list_eclipse,
}
local enemy_filter_dozers = {
	values = {
		rules = {
			enemy_names = {
				"units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1",
				"units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2",
				"units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3",
				"units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic",
			},
		},
	},
}
local lab_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents_bulldozers,
}
local elevator_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents,
}
local office_window_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local staircase_spawn = {
	values = {
		interval = 40,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	-- A bunch of reinforce spots to fill up this pretty large level
	[100115] = {
		reinforce = {
			{
				name = "admin",
				force = 2,
				position = Vector3(-5600, 1200, -200),
			},
			{
				name = "parkinglot",
				force = 2,
				position = Vector3(6000, 5100, 0),
			},
			{
				name = "garden",
				force = 2,
				position = Vector3(7200, -3900, 10),
			},
			{
				name = "labroof1",
				force = 2,
				position = Vector3(4000, 400, 670),
			},
			{
				name = "labroof2",
				force = 2,
				position = Vector3(-1200, 2600, 670),
			},
			{
				name = "statue",
				force = 3,
				position = Vector3(700, -75, 0),
			},
		},
	},
	-- Remove office building and research facility spawns from initial preferreds
	[100129] = {
		on_executed = {
			{ id = 100006, remove = true },
			{ id = 100021, remove = true },
		},
	},
	[100124] = { -- diff 0.75
		on_executed = {
			{ id = 100006, delay = 0 },
			{ id = 100021, delay = 0 },
		},
	},
	-- Disable the sketchy killzone crap
	[102159] = disabled,
	-- tweak swat vans spawns to have variety
	-- 2 bellmead mercs with one specials
	-- 1st van
	-- easy-normal
	[103058] = bellmead_merc,
	[103552] = specials,
	[103559] = bellmead_merc,
	-- hard-overkill
	[103491] = bellmead_merc,
	[103560] = specials,
	[103553] = bellmead_merc,
	-- eclipse
	[103550] = bellmead_merc,
	[103561] = specials,
	[103557] = bellmead_merc,
	-- 2nd van
	-- easy-normal
	[103576] = bellmead_merc,
	[103572] = specials,
	[103580] = bellmead_merc,
	-- hard-overkill
	[103575] = bellmead_merc,
	[103571] = specials,
	[103579] = bellmead_merc,
	-- eclipse
	[103574] = bellmead_merc,
	[103570] = specials,
	[103578] = bellmead_merc,
	-- 3rd van
	-- easy-normal
	[103589] = bellmead_merc,
	[103597] = specials,
	[103593] = bellmead_merc,
	-- hard-overkill
	[103590] = bellmead_merc,
	[103598] = specials,
	[103594] = bellmead_merc,
	-- eclipse
	[103591] = bellmead_merc,
	[103599] = specials,
	[103595] = bellmead_merc,
	--Update turret dozer filters to include benellidozer
	[102783] = enemy_filter_dozers,
	--[[ 	DON'T DESPAWN THOSE UNITS, PLEASEEEEE! THEY ARE IMPORTANT!
	[103639] = enemy_filter_dozers,
	[103640] = enemy_filter_dozers,
	[103641] = enemy_filter_dozers,
	[103642] = enemy_filter_dozers,
	[103643] = enemy_filter_dozers,
	[103644] = enemy_filter_dozers,
]]
	--
	-- spawn point delays
	[102820] = lab_spawn,
	[102784] = elevator_spawn,
	[102828] = elevator_spawn,
	[102044] = office_window_spawn,
	[100694] = office_window_spawn,
	[102044] = office_window_spawn,
}
