local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local is_eclipse = Eclipse.utils.is_eclipse()
local swat_1 = scripted_enemy.swat_1
local heavy_1 = scripted_enemy.heavy_swat_1
local elite_sniper = scripted_enemy.elite_sniper
local light_harasser = swat_1
local heavy_harasser = is_eclipse and { [heavy_1] = 4, [elite_sniper] = 1 } or heavy_1
local harasser = {
	enemy = diff_i < 5 and light_harasser or heavy_harasser,
}
local jumpdown_spawn1 = {
	values = {
		interval = 15,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local jumpdown_spawn2 = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	-- Reinforce that scales with diff.
	[100150] = {
		reinforce = {
			{
				name = "ground1",
				force = 3,
				position = Vector3(1850, 3150, 0),
			},
			{
				name = "ground2",
				force = 3,
				position = Vector3(300, -900, 0),
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
		reinforce = { -- diff increased, add additional reinforce
			{
				name = "container1",
				force = 2,
				position = Vector3(3800, 1000, 550),
			},
			{
				name = "container2",
				force = 2,
				position = Vector3(2150, -400, 550),
			},
		},
	},
	-- Spawn group delays
	-- Election Day got butchered pretty badly when spawn group intervals were standardised.
	-- Slightly revising the original version with more pronounced intervals.
	[104110] = jumpdown_spawn1,
	[104324] = jumpdown_spawn1,
	[104330] = jumpdown_spawn1,
	[104410] = jumpdown_spawn1,
	[104111] = jumpdown_spawn2,
	[104321] = jumpdown_spawn2,
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
