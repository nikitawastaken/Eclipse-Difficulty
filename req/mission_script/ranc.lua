local sniper_trigger_times = {
	values = {
		trigger_times = 0,
	},
}
local spawn_anim_fix = {
	values = {
		spawn_action = "e_sp_over_3m",
	},
}
return {
	-- fix snipers being able to spawn only once
	[100368] = sniper_trigger_times,
	[100369] = sniper_trigger_times,
	[100370] = sniper_trigger_times,
	[100371] = sniper_trigger_times,
	-- fixes some spawn typos
	[100683] = spawn_anim_fix,
	[100684] = spawn_anim_fix,
	[100789] = spawn_anim_fix,
	[100790] = spawn_anim_fix,
	[100791] = spawn_anim_fix,
}
