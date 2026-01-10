local scripted_enemy = Eclipse.scripted_enemy
local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local diff_i = Eclipse.utils.difficulty_index()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()
local swat_1 = scripted_enemy.swat_1
local heavy_1 = scripted_enemy.heavy_swat_1
local elite_sniper = scripted_enemy.elite_sniper
local light_harasser = swat_1
local heavy_harasser = is_eclipse and { [heavy_1] = 5, [elite_sniper] = 1 } or heavy_1
local fail_to_believe_chance = (is_eclipse and 30 or 20) + (is_pro_job and 5 or 0)

local disabled = {
	values = {
		enabled = false,
	},
}

-- the evil one
local timelock_normal_variant_1 = (is_eclipse and 300 or 240) + (is_pro_job and 60 or 0)
local timelock_fast_variant_1 = (is_eclipse and 240 or 180) + (is_pro_job and 60 or 0)

-- the lucky one
local timelock_normal_variant_2 = (is_eclipse and 120 or 90) + (is_pro_job and 15 or 0)
local timelock_fast_variant_2 = (is_eclipse and 90 or 60) + (is_pro_job and 15 or 0)

-- the normal one
local timelock_normal_variant_3 = (is_eclipse and 210 or 180) + (is_pro_job and 30 or 0)
local timelock_fast_variant_3 = (is_eclipse and 180 or 150) + (is_pro_job and 30 or 0)

-- roll the chance of selected timelock variant
-- thanks Mint
local timelock_variant_chance = math.random()

local timelock_normal = nil
local timelock_fast = nil

if timelock_variant_chance <= 0.05 then
	timelock_normal = timelock_normal_variant_1
	timelock_fast = timelock_fast_variant_1
elseif timelock_variant_chance <= 0.2 then
	timelock_normal = timelock_normal_variant_2
	timelock_fast = timelock_fast_variant_2
else
	timelock_normal = timelock_normal_variant_3
	timelock_fast = timelock_fast_variant_3
end

local harasser = {
	enemy = diff_i < 5 and light_harasser or heavy_harasser,
}
local no_shields_and_dozers = {
	so_access_filter = { "cop", "swat", "fbi", "taser", "spooc" },
}
local bags_required = {
	values = {
		amount = (is_eclipse and 6 or 4) + (is_pro_job and 2 or 0),
	},
}
local mga_thermite_event = {
	post_mga_event = "mga_thermite",
}
local mga_vault_event = {
	post_mga_event = { "mga_vault_a", "mga_vault_b", "mga_vault_c" },
}
local elevator_spawn = {
	values = {
		interval = 30,
	},
}
local elevator_close_spawn = {
	values = {
		interval = 40,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	[100809] = {
		ponr = {
			length = 240,
			player_mul = { 2, 1.25, 1, 1 },
		},
	},
	-- Combine some navigation areas
	[100017] = {
		ai_area = {
			{ 25, 26, 119 },
			{ 27, 120, 121 },
			{ 28, 118 },
			{ 38, 133 },
			{ 41, 42, 50, 66 },
			{ 43, 44, 51 },
		},
	},
	-- Add new reinforce
	[100109] = { -- Police
		reinforce = {
			{
				name = "entrance",
				force = 4,
				position = Vector3(3875, 0, -1100),
			},
		},
	},
	[102166] = { -- open gate (downstairs)
		reinforce = {
			{
				name = "gate",
				force = 2,
				position = Vector3(-175, -25, -1000),
			},
		},
	},
	[104371] = { -- open gate (upstairs)
		reinforce = {
			{
				name = "gate",
				force = 2,
				position = Vector3(-175, -25, -600),
			},
		},
	},
	[104369] = { -- explode wall (downstairs)
		reinforce = {
			{
				name = "breach",
				force = 2,
				position = Vector3(-175, -25, -1000),
			},
		},
	},
	[104367] = { -- explode wall (upstairs)
		reinforce = {
			{
				name = "breach",
				force = 2,
				position = Vector3(-175, -25, -600),
			},
		},
	},
	[100834] = { -- Elevator Escape
		reinforce = {
			{
				name = "elevator_escape",
				force = 2,
				position = Vector3(-1150, -1050, -1000),
			},
		},
	},
	[104523] = { -- Bus Escape
		reinforce = {
			{
				name = "bus_escspae",
				force = 2,
				position = Vector3(-2640, -1445, -600),
			},
		},
	},
	[100833] = { -- C4 Escape
		reinforce = {
			{
				name = "c4_escape",
				force = 2,
				position = Vector3(-3400, 1000, -600),
			},
		},
	},
	-- Enable roof spawngroups
	[100006] = {
		values = {
			spawn_groups = { 100019, 100007, 100692 },
		},
	},
	-- Disable Titan Cams
	[106265] = disabled,
	-- Add new elevator spawngroup
	[103316] = {
		on_executed = {
			{ id = 400020, delay = 0 },
		},
	},
	-- time lock is now randomized
	[103137] = {
		values = {
			time = timelock_normal,
		},
	},
	[100170] = {
		values = {
			time = timelock_fast,
		},
	},
	-- open the locked door if you bought the access asset
	[106046] = {
		on_executed = {
			{ id = 104260, delay = 0 },
		},
	},
	-- restore alternative phone call outcome that sends two beat cops to investigate (failed to fell for it)
	[105244] = { chance = fail_to_believe_chance },
	-- change amount of required bags
	[101868] = bags_required,
	[103961] = bags_required,
	-- Prevent shields/dozers from disabling the timelock
	[101195] = no_shields_and_dozers,
	[102268] = no_shields_and_dozers,
	-- trigger ambush cloakers when the time lock door opens
	[104397] = {
		on_executed = {
			{ id = 400012, delay = 0 },
		},
	},
	-- disable ambush cloakers on startup
	[100017] = {
		on_executed = {
			{ id = 400011, delay = 3 },
		},
	},
	-- enable ambush cloakers on loud
	[100023] = {
		on_executed = {
			{ id = 400010, delay = 0 },
		},
	},
	-- Sever hack chance in solo
	[104494] = {
		pre_func = function(self)
			if table.size(managers.network:session():peers()) == 0 then
				self._chance = is_pro_job and 75 or 100
			end
		end,
	},
	-- Play megaphone cop voice lines
	[105842] = mga_thermite_event,
	[105792] = mga_vault_event,
	-- Spawn Group delays
	[105434] = elevator_spawn,
	[105450] = elevator_spawn,
	[105500] = elevator_spawn,
	[400019] = elevator_close_spawn,
	-- Harassers
	[100883] = harasser,
	[100884] = harasser,
	[100885] = harasser,
	[100332] = harasser,
	[100334] = harasser,
	[100336] = harasser,
	[100906] = harasser,
	[100907] = harasser,
	[100908] = harasser,
	[100922] = harasser,
	[100923] = harasser,
	[100924] = harasser,
	[100938] = harasser,
	[100939] = harasser,
	[100940] = harasser,
	[100954] = harasser,
	[100955] = harasser,
	[100956] = harasser,
	[100969] = harasser,
	[100970] = harasser,
	[100971] = harasser,
	[100985] = harasser,
	[100986] = harasser,
	[100987] = harasser,
	[101001] = harasser,
	[101002] = harasser,
	[101003] = harasser,
	[101017] = harasser,
	[101018] = harasser,
	[101019] = harasser,
	[101033] = harasser,
	[101034] = harasser,
	[101035] = harasser,
	[101049] = harasser,
	[101050] = harasser,
	[101051] = harasser,
	[101065] = harasser,
	[101066] = harasser,
	[101067] = harasser,
	[101081] = harasser,
	[101082] = harasser,
	[101083] = harasser,
	[101097] = harasser,
	[101098] = harasser,
	[101099] = harasser,
	[101113] = harasser,
	[101114] = harasser,
	[101115] = harasser,
	[101129] = harasser,
	[101130] = harasser,
	[101131] = harasser,
	[101145] = harasser,
	[101146] = harasser,
	[101147] = harasser,
	[101161] = harasser,
	[101162] = harasser,
	[101163] = harasser,
	[101177] = harasser,
	[101178] = harasser,
	[101179] = harasser,
}
