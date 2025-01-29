local enabled = {
	values = {
		enabled = true
	}
}
local sniper_trigger_times = {
	values = {
        trigger_times = 0
	}
}
local alleyway_spawn ={
	values = {
		interval = 20
	}
}
return {
	[101190] = {
		reinforce = {
			{
				name = "store_front1",
				force = 3,
				position = Vector3(-2000, 300, -10)
			},
			{
				name = "store_front2",
				force = 3,
				position = Vector3(-1000, 300, -10)
			}
		}
	},
	[101647] = {
		reinforce = {
			{
				name = "store_front2"
			},
			{
				name = "back_alley",
				force = 3,
				position = Vector3(-1400, 4900, 540)
			}
		}
	},
	--Should fix enemies getting stuck in that certain spawn point
	--Yes, this shit was never fixed since the release of this heist lmao
	[101088] = enabled,
	[101238] = enabled,
	[100999] = enabled,
	[101265] = enabled,
	[101262] = enabled,
	[101264] = enabled,
	--Fixed snipers being able to spawn only once
	[100368] = sniper_trigger_times,
	[100369] = sniper_trigger_times,
	[100370] = sniper_trigger_times,
	[100371] = sniper_trigger_times,
	[100372] = sniper_trigger_times,
	[100373] = sniper_trigger_times,
	[100374] = sniper_trigger_times,
	[100375] = sniper_trigger_times,
	[100376] = sniper_trigger_times,
	[100377] = sniper_trigger_times,
	-- slow down a few spawn points in the back alleyway
	[100132] = alleyway_spawn,
	[100133] = alleyway_spawn,
	[100692] = alleyway_spawn,
}