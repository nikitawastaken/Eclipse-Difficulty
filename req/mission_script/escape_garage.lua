local get_difficulty_group_specific_value = Eclipse.utils.get_difficulty_group_specific_value
local preferred = Eclipse.preferred
local scripted_enemy = Eclipse.scripted_enemy
local swats = {
	enemy = {
		[scripted_enemy.heavy_swat_1] = get_difficulty_group_specific_value({ 4, 7, 10 }),
		[scripted_enemy.heavy_swat_2] = get_difficulty_group_specific_value({ 2, 4, 6 }),
		[scripted_enemy.swat_1] = 8,
		[scripted_enemy.swat_2] = 4,
	},
}
local enabled = {
	values = {
		enabled = true,
	},
}
local garage_spawn = {
	values = {
		interval = 15,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
}
return {
	-- Combine some navigation areas
	[101913] = {
		ai_area = {
			{ 48, 47 },		
			{ 45, 46, 91 },		
			{ 43, 44, 66 },		
			{ 41, 42 },		
			{ 37, 38, 39 },
			{ 34, 35 },
			{ 25, 26, 27 },
			{ 12, 13 },	
			{ 3, 11 },		
			{ 16, 18, 20 },			
			{ 4, 56 },
		},
	},
	-- Add new navlinks
	[102514] = { -- EnableNavLinks
		on_executed = {
			{ id = 400000, delay = 0 },
			{ id = 400001, delay = 0 },
			{ id = 400002, delay = 0 },
			{ id = 400003, delay = 0 },
		},
	},
	-- Enabled reinforce toggles and tweak the force value of one of the elements
	[102369] = enabled,
	[102370] = enabled,
	[102377] = enabled,
	[102372] = enabled,
	[102376] = enabled,
	[102378] = enabled,
	[102374] = {
		values = {
			amount = 6,
		},
	},
	-- Spawn group intervals
	[101923] = garage_spawn,
	[101924] = garage_spawn,
	[101925] = garage_spawn,
	-- SWATs
	[101912] = swats,
	[101913] = swats,
	[101914] = swats,
	[101915] = swats,
	[101916] = swats,
	[101917] = swats,
	[101918] = swats,
	[101919] = swats,
	[101920] = swats,
	[101921] = swats,
	[101949] = swats,
	[101948] = swats,
	[101729] = swats,
	[101728] = swats,
	[101727] = swats,
	[101726] = swats,
}
