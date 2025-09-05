local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local so_access = Eclipse.access_filter
local diff_i = Eclipse.utils.difficulty_index()
local is_eclipse = Eclipse.utils.is_eclipse()
local swat_1 = scripted_enemy.swat_1
local heavy_1 = scripted_enemy.heavy_swat_1
local elite_sniper = scripted_enemy.elite_sniper
local light_harasser = swat_1
local heavy_harasser = is_eclipse and { [heavy_1] = 10, [elite_sniper] = 1 } or heavy_1
local exclude_shields_dozers = {
	so_access_filter = so_access.no_heavyweight,
}
local harasser = {
	enemy = diff_i < 5 and light_harasser or heavy_harasser,
}
local standard_spawn = {
	values = {
		interval = 20,
	},
}
local jumpdown_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	-- Add new reinforce
	[100150] = {
		reinforce = {
			{
				name = "warehouse1",
				force = 2,
				position = Vector3(2000, 3135, 0),
			},
			{
				name = "warehouse2",
				force = 2,
				position = Vector3(525, -500, 0),
			},
			{
				name = "warehouse3",
				force = 2,
				position = Vector3(1750, 1850, 0),
			},
			{
				name = "warehouse4",
				force = 2,
				position = Vector3(4700, 3150, 0),
			},
		},
	},
	-- Keep Shields and Dozers from using some of the jump SOs
	[103164] = exclude_shields_dozers,
	[103423] = exclude_shields_dozers,
	[103457] = exclude_shields_dozers,
	[103627] = exclude_shields_dozers,
	[104017] = exclude_shields_dozers,
	[104018] = exclude_shields_dozers,
	[104019] = exclude_shields_dozers,
	[104243] = exclude_shields_dozers,
	[104298] = exclude_shields_dozers,
	[104299] = exclude_shields_dozers,
	[104299] = exclude_shields_dozers,
	[104858] = exclude_shields_dozers,
	[104859] = exclude_shields_dozers,
	[104000] = exclude_shields_dozers,
	[104001] = exclude_shields_dozers,
	[104002] = exclude_shields_dozers,
	[104005] = exclude_shields_dozers,
	[104007] = exclude_shields_dozers,
	-- Spawn group intervals
	-- Election Day got butchered pretty badly when spawn group intervals were standardised.
	-- Slightly revising the original version with more pronounced intervals.
	[104064] = standard_spawn,
	[104065] = standard_spawn,
	[101055] = standard_spawn,
	[101188] = standard_spawn,
	[101189] = standard_spawn,
	[101196] = standard_spawn,
	[101211] = standard_spawn,
	[104110] = jumpdown_spawn,
	[104324] = jumpdown_spawn,
	[104330] = jumpdown_spawn,
	[104410] = jumpdown_spawn,
	[104111] = jumpdown_spawn,
	[104321] = jumpdown_spawn,
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
