local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local diff_i = Eclipse.utils.difficulty_index()
local is_eclipse = Eclipse.utils.is_eclipse()
local swat_1 = scripted_enemy.swat_1
local heavy_1 = scripted_enemy.heavy_swat_1
local elite_sniper = scripted_enemy.elite_sniper
local light_harasser = swat_1
local heavy_harasser = is_eclipse and { [heavy_1] = 10, [elite_sniper] = 1 } or heavy_1
local harasser = {
	enemy = diff_i < 5 and light_harasser or heavy_harasser,
}
local ground_spawn = {
	values = {
		interval = 5,
	},
}
local waterfront_spawn = {
	values = {
		interval = 15,
	},
}
local jumpdown_lower_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local jumpdown_upper_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	[100150] = {
		reinforce = {
			{
				name = "warehouse1",
				force = 2,
				position = Vector3(1800, 3135, 0),
			},
			{
				name = "warehouse2",
				force = 2,
				position = Vector3(525, -300, 0),
			},
		},
	},
	-- Tweak the difficulty curve slightly
	[100156] = {
		values = {
			difficulty = 0.5,
		},
	},
	[104076] = {
		values = {
			difficulty = 0.75,
		},
	},
	-- Spawn group delays
	-- Election Day got butchered pretty badly when spawn group intervals were standardised.
	-- Slightly revising the original version with more pronounced intervals.
	[104064] = ground_spawn,
	[104065] = ground_spawn,
	[101055] = waterfront_spawn,
	[101189] = waterfront_spawn,
	[101196] = waterfront_spawn,
	[104110] = jumpdown_lower_spawn,
	[104324] = jumpdown_lower_spawn,
	[104330] = jumpdown_lower_spawn,
	[104410] = jumpdown_lower_spawn,
	[104111] = jumpdown_upper_spawn,
	[104321] = jumpdown_upper_spawn,
	-- Harassers
	[104583] = harasser,
	[104112] = harasser,
	[104591] = harasser,
	[104584] = harasser,
	[103994] = harasser,
	[104592] = harasser,
	[104585] = harasser,
	[103993] = harasser,
	[104593] = harasser,
	[104586] = harasser,
	[104115] = harasser,
	[104594] = harasser,
	[104587] = harasser,
	[104175] = harasser,
	[104595] = harasser,
	[104588] = harasser,
	[104174] = harasser,
	[104596] = harasser,
	[104589] = harasser,
	[104176] = harasser,
	[104597] = harasser,
	[104590] = harasser,
	[104177] = harasser,
	[104598] = harasser,
}
