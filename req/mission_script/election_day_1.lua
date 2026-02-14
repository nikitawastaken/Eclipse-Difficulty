local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local so_access = Eclipse.access_filter
local diff_i = Eclipse.utils.difficulty_index()
local swat_1 = scripted_enemy.swat_1
local heavy_1 = scripted_enemy.heavy_swat_1
local elite_sniper = scripted_enemy.elite_sniper
local disabled = {
	values = {
		enabled = false,
	},
}
local exclude_shields_dozers = {
	so_access_filter = so_access.no_heavyweight,
}
local harasser = {
	enemy = diff_i > 5 and { [swat_1] = 10, [elite_sniper] = 1 } or swat_1,
}
local standard_spawn = {
	values = {
		interval = 15,
	},
}
local jumpdown_spawn = {
	values = {
		interval = 30,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	-- Combine some navigation areas
	[101786] = {
		ai_area = {
			{ 125, 139, 140 },
			{ 75, 188, 199, 200, 213, 224 },
			{ 73, 74, 205 },
			{ 225, 226 },
			{ 178, 180 },
			{ 181, 219 },
			{ 76, 187, 227, 228, 230 },
			{ 78, 184 },
			{ 77, 185 },
			{ 79, 80, 183 },
			{ 186, 206 },
			{ 203, 211 },
			{ 190, 191, 192, 193, 194, 195, 196, 197, 214, 215, 216, 217, 218 },
			{ 120, 122 },
			{ 143, 144 },
			{ 145, 146 },
			{ 202, 223 },
		},
	},
	-- Add new reinforce
	[100150] = { -- poFuckinLice
		reinforce = {
			{
				name = "warehouse01",
				force = 2,
				position = Vector3(1800, 3135, 5),
			},
			{
				name = "warehouse02",
				force = 2,
				position = Vector3(1900, 1850, 5),
			},
			{
				name = "warehouse03",
				force = 2,
				position = Vector3(525, -500, 5),
			},
			{
				name = "warehouse04",
				force = 2,
				position = Vector3(5575, 2825, 105),
			},
		},
	},
	-- Disable choppers before the first assault
	[100183] = { -- first_time
		on_executed = {
			{ id = 104073, remove = true }, -- setup_flyin_choppers
		},
	},
	-- Choppers drop SWATs after assaults
	[104133] = {
		on_executed = {
			{ id = 400019, delay = 0, delay_rand = 10 },
		},
	},
	-- 1st chopper
	[104074] = {
		on_executed = {
			{ id = 104075, delay = 45 },
			{ id = 400005, delay = 33 },
		},
	},
	-- 2nd chopper
	[104125] = {
		on_executed = {
			{ id = 104128, delay = 45 },
			{ id = 400011, delay = 33 },
		},
	},
	-- 3rd chopper
	[104126] = {
		on_executed = {
			{ id = 104129, delay = 45 },
			{ id = 400017, delay = 33 },
		},
	},
	-- fly outs are handled in their on_executed now
	[104127] = disabled,
	-- Disable harassers
	[104156] = disabled,
	[104157] = disabled,
	[104158] = disabled,
	[104159] = disabled,
	[104188] = disabled,
	[104197] = disabled,
	[104206] = disabled,
	[104215] = disabled,
	-- Disable the silly water preferreds
	[101095] = disabled,
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
	[104063] = standard_spawn,
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
