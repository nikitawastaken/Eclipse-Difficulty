local preferred = Eclipse.preferred
local get_difficulty_group_specific_value = Eclipse.utils.get_difficulty_group_specific_value
local scripted_enemy = Eclipse.scripted_enemy
local disabled = {
	values = {
		enabled = false,
	},
}
local bellmead_merc = {
	enemy = scripted_enemy.bellmead_security_1,
}
local specials_list = {
	[scripted_enemy.taser_1] = get_difficulty_group_specific_value({ 1, 2, 2 }),
	[scripted_enemy.medic_1] = get_difficulty_group_specific_value({ 0, 2, 2 }),
	[scripted_enemy.cloaker] = get_difficulty_group_specific_value({ 0, 2, 2 }),
	[scripted_enemy.bulldozer_1] = get_difficulty_group_specific_value({ 0, 1, 0 }),
	[scripted_enemy.bulldozer_2] = get_difficulty_group_specific_value({ 0, 1, 0 }),
	[scripted_enemy.elite_bulldozer_1] = get_difficulty_group_specific_value({ 0, 0, 1 }),
	[scripted_enemy.elite_bulldozer_2] = get_difficulty_group_specific_value({ 0, 0, 1 }),
}
local specials = {
	enemy = specials_list,
}
local green_security = {
	enemy = {
		[scripted_enemy.green_security_1] = 2,
		[scripted_enemy.green_security_2] = 2,
		[scripted_enemy.green_security_3] = 2,
		[scripted_enemy.green_security_4] = 1,
		[scripted_enemy.green_security_5] = 2,
	},
}
local enemy_filter_dozers = {
	values = {
		rules = {
			enemy_names = {
				"units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1",
				"units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2",
				"units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3",
				"units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic",
				"units/pd2_dlc_drm/characters/ene_bulldozer_medic_classic/ene_bulldozer_medic_classic",
			},
		},
	},
}
local office_window_spawn = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local staircase_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}

return {
	-- A bunch of reinforce spots to fill up this pretty large level
	[100115] = {
		reinforce = {
			{
				name = "meetingroom01",
				force = 2,
				position = Vector3(3700, 2200, 500),
			},
			{
				name = "meetingroom02",
				force = 2,
				position = Vector3(5300, 2000, 900),
			},
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
				name = "labroof01",
				force = 2,
				position = Vector3(4000, 400, 670),
			},
			{
				name = "labroof02",
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
	-- fix nasty crash with the security room upon startup
	[101926] = {
		on_executed = {
			{ id = 101927, delay = 3 },
		},
	},
	-- Remove office building and research facility spawns from initial preferreds
	[100129] = {
		on_executed = {
			{ id = 100006, remove = true },
			{ id = 100021, remove = true },
		},
	},
	[100761] = { -- player_inside_office_building
		on_executed = {
			{ id = 100006, delay = 15, delay_rand = 15 },
			{ id = 100021, delay = 15, delay_rand = 15 },
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
	-- death wish
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
	-- death wish
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
	-- Begin spawning Cloakers earlier. Vanilla begins spawning them at the start of the 2nd assault.
	[100765] = { -- 2_assaults_started
		values = {
			counter_target = 1,
		},
	},
	-- Scripted difficulty scaling
	[101124] = { -- display_case_open (Prototype found)
		on_executed = {
			{ id = 400001, delay = 0 },
		},
	},
	[101934] = { -- output_lab_flooded (Flooded the lab)
		on_executed = {
			{ id = 400002, delay = 0 },
		},
	},
	-- Spawn group intervals
	[102044] = office_window_spawn,
	[100694] = office_window_spawn,
	[102376] = staircase_spawn,
	-- Replace regular security with green security
	[100670] = green_security,
	[100671] = green_security,
	[100672] = green_security,
	[100673] = green_security,
	[100674] = green_security,
	[100675] = green_security,
	[100676] = green_security,
	[100677] = green_security,
	[100678] = green_security,
	[100679] = green_security,
	[101490] = green_security,
	[101491] = green_security,
	[101493] = green_security,
	[101498] = green_security,
	[101503] = green_security,
	[101519] = green_security,
	[101520] = green_security,
	[101522] = green_security,
	[101527] = green_security,
	[101532] = green_security,
	[101548] = green_security,
	[101549] = green_security,
	[101551] = green_security,
	[101556] = green_security,
	[101561] = green_security,
	[101577] = green_security,
	[101578] = green_security,
	[101580] = green_security,
	[101585] = green_security,
	[101590] = green_security,
	[101644] = green_security,
	[101645] = green_security,
	[101646] = green_security,
	[101648] = green_security,
	[101649] = green_security,
	[101677] = green_security,
	[101678] = green_security,
	[101679] = green_security,
	[101681] = green_security,
	[101710] = green_security,
	[101711] = green_security,
	[101712] = green_security,
	[101714] = green_security,
	[101715] = green_security,
}
