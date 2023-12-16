local diff_i = tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or "normal")
local SniperInterval = 25
if diff_i == 6 then
	SniperInterval = 15
end
return {
	-- Increase spawn delays on snipers
	[100319] = {
		values = {
			interval = SniperInterval
		}
	},
	[100320] = {
		values = {
			interval = SniperInterval
		}
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