local get_difficulty_group_specific_value = Eclipse.utils.get_difficulty_group_specific_value
local preferred = Eclipse.preferred
local so_access = Eclipse.access_filter
local is_eclipse = Eclipse.utils.is_eclipse()
local scripted_enemy = Eclipse.scripted_enemy
local swats_close = {
	enemy = {
		[scripted_enemy.heavy_swat_1] = get_difficulty_group_specific_value({ 3, 5, 7 }),
		[scripted_enemy.heavy_swat_2] = get_difficulty_group_specific_value({ 2, 3, 4 }),
		[scripted_enemy.swat_1] = 5,
		[scripted_enemy.swat_2] = 3,
	},
}
local swats_far = {
	enemy = is_eclipse and { [scripted_enemy.swat_1] = 4, [scripted_enemy.elite_sniper] = 1 } or scripted_enemy.swat_1,
}
local enabled = {
	values = {
		enabled = true,
	},
}
local exclude_shields_dozers = {
	so_access_filter = so_access.no_heavyweight,
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
	[102482] = { -- DifficultyUp_0.50
		set_ponr_state = true,
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
	-- tweak the navlinks to prevent dozers and shields from using it
	[400000] = exclude_shields_dozers,
	[400001] = exclude_shields_dozers,
	[400002] = exclude_shields_dozers,
	[400003] = exclude_shields_dozers,
	-- Enable reinforce toggles and tweak the force value of one of the elements
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
	[101912] = swats_close,
	[101913] = swats_close,
	[101914] = swats_close,
	[101915] = swats_close,
	[101916] = swats_close,
	[101917] = swats_close,
	[101918] = swats_close,
	[101919] = swats_close,
	[101920] = swats_close,
	[101921] = swats_close,
	[101949] = swats_close,
	[101948] = swats_close,
	[101729] = swats_far,
	[101728] = swats_far,
	[101727] = swats_far,
	[101726] = swats_far,
}
