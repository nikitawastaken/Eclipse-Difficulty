local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local sniper_trigger_times = {
	values = {
		trigger_times = 0,
	},
}
local warehouse_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	[103501] = disabled,
	[103051] = disabled,
	-- reinforce spots
	[102477] = {
		reinforce = {
			{
				name = "traincar1",
				force = 3,
				position = Vector3(-6220, 5800, 450),
			},
			{
				name = "traincar2",
				force = 3,
				position = Vector3(-3220, 4790, 450),
			},
			{
				name = "traincar3",
				force = 3,
				position = Vector3(2090, 5770, 450),
			},
		},
	},
	-- fix snipers being able to spawn only once
	[100368] = sniper_trigger_times,
	[100369] = sniper_trigger_times,
	[100370] = sniper_trigger_times,
	[100371] = sniper_trigger_times,
	[100372] = sniper_trigger_times,
	-- spawn point delays
	[100133] = warehouse_spawn,	
}
