local diff_i = tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or "normal")
local SniperInterval = 25
if diff_i == 6 then
	SniperInterval = 15
end
return {
	[100082] = {  -- prevent sniper respawn delays becoming ridiculously small as more assaults pass
		on_executed = {
			{ id = 100321, remove = true, },
		},
	},
	[100446] = {
		on_executed = {
			{ id = 100321, delay = 0, },
		},
	},
	[104782] = {
		ponr = {
			length = 420,
			player_mul = {1.5, 1.25, 1, 1}
		}
	},
	[103702] = {
		values = {
			interval = 20
		}
	},
	[100438] = {
		values = {
			interval = 20
		}
	},
}