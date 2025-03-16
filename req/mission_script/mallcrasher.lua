local preferred = Eclipse.preferred
local jump_SO = {
	pre_func = function(self)
		if not self._values.SO_access_original then
			self._values.SO_access_original = self._values.SO_access
			self._values.SO_access = managers.navigation:convert_access_filter_to_number({ "swat", "taser", "spooc" })
		end
	end,
}
local stairs_spawn = {
	values = {
		interval = 10,
	},
}
local skylight_spawn = {
	values = {
		interval = 40,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	-- Combine some navigation areas
	[300000] = {
		ai_area = {
			{ 47, 54, 67, 68, 70, 112 },
			{ 49, 61, 73 },
			{ 41, 52 },
			{ 29, 33, 42, 44 },
			{ 3, 4 },
			{ 45, 57, 60, 69 },
			{ 58, 65 },
			{ 76, 84 },
			{ 81, 72 },
			{ 55, 111 },
			{ 86, 101, 104, 106, 108, 109 },
			{ 24, 39 },
			{ 90, 93, 94, 96 },
		},
	},
	-- delay SWAT response
	[300203] = {
		on_executed = {
			{ id = 300164, delay = 45 },
		},
	},
	-- spawn point delays
	[300314] = stairs_spawn,
	[302083] = skylight_spawn,
	[302084] = skylight_spawn,
	[301852] = skylight_spawn,
	[301847] = skylight_spawn,
	-- disable the silly jump SOs for some enemies
	[301777] = jump_SO,
	[302013] = jump_SO,
	[302020] = jump_SO,
	[302024] = jump_SO,
	[302035] = jump_SO,
	[302047] = jump_SO,
	[302048] = jump_SO,
	[302049] = jump_SO,
	[302050] = jump_SO,
	[302051] = jump_SO,
	[302052] = jump_SO,
	[302053] = jump_SO,
	[302054] = jump_SO,
	[302055] = jump_SO,
	[302056] = jump_SO,
	[302057] = jump_SO,
	[302060] = jump_SO,
	[302061] = jump_SO,
	[302062] = jump_SO,
	[302063] = jump_SO,
	[302064] = jump_SO,
	[302065] = jump_SO,
	[302066] = jump_SO,
	[302067] = jump_SO,
	[302068] = jump_SO,
	[302069] = jump_SO,
	[302070] = jump_SO,
	[302071] = jump_SO,
	[302072] = jump_SO,
	[302073] = jump_SO,
	[302074] = jump_SO,
}
