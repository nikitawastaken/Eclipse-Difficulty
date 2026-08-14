local preferred = Eclipse.preferred
local so_access = Eclipse.access_filter
local enabled = {
	values = {
		enabled = true,
	},
}
local filter_disable = {
	values = Eclipse.utils.set_diff_groups("disable"),
}
local filter_easy_above = {
	values = Eclipse.utils.set_diff_groups("easy_above"),
}
local exclude_cop_agents_shields_dozers = {
	so_access_filter = so_access.acrobatic,
}
local shield_so = {
	pre_func = function(element)
		if Network:is_client() then
			return
		end
		element:add_event_callback("spawn", function(unit)
			local pos = unit:movement():m_pos()
			unit:brain():set_objective({
				type = "sniper",
				pos = pos,
				nav_seg = managers.navigation:get_nav_seg_from_pos(pos),
				no_retreat = true,
			})
		end)
	end,
}
local catwalk_spawn = {
	values = {
		interval = 15,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
}
local street_spawn = {
	values = {
		interval = 25,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
}
local roof_spawn = deep_clone(catwalk_spawn)
roof_spawn.groups = preferred.no_shields_bulldozers

local scripted_swat_van_spawn = {
	groups = preferred.no_cops_agents_hrt_cloakers_snipers,
}

return {
	-- Combine some navigation areas
	[100125] = {
		ai_area = {
			{ 55, 144 },
			{ 42, 75 },
			{ 51, 76 },
			{ 52, 134 },
			{ 81, 166, 167 },
			{ 127, 129 },
		},
	},
	[101146] = { -- activateSecondEscapeVehicle
		ponr = {
			length = 240,
			length_balance_mul = { 1.375, 1.25, 1.125, 1 },
		},
	},
	-- Replace the turrets with spawngroups
	[100450] = {
		on_executed = {
			{ id = 101164, remove = true },
			{ id = 400005, delay = 0, delay_rand = 5 },
		},
	},
	[101293] = {
		on_executed = {
			{ id = 101294, remove = true },
			{ id = 400012, delay = 0, delay_rand = 5 },
		},
	},
	-- Change loot vehicle arrival timing
	-- Reduce the delay for choosing the loot vehicle location
	[100771] = { -- driver_3
		on_executed = { -- From 38s + 7s to 18s + 7s
			{ id = 100658, delay = 18 }, -- LootVehicleArrived
		},
	},
	-- Increase the delays of elements responsible for moving the vehicle into place by 20s.
	-- Bain's voiceline delays remain unchaged, so you get notified of the loot vehicle's location 20s in advance.
	[100771] = { -- lootDropOff1 (Walkway)
		on_executed = {
			{ id = 100773, delay = 20 },
			{ id = 102693, delay = 20 },
		},
	},
	[100306] = { -- lootDropOff2 (Street)
		on_executed = {
			{ id = 100929, delay = 20 },
			{ id = 102692, delay = 20 },
		},
	},
	[101459] = { -- lootDropOff3 (Crane)
		on_executed = {
			{ id = 100842, delay = 20 },
			{ id = 102695, delay = 20 },
		},
	},
	-- Add weights to loot vehicle RNG.
	[100770] = { -- chooseLootVehicle
		pre_func = function(self)
			local selector = EclipseWeightedSelector:new()
			selector:add(100772, 2) -- Street
			selector:add(100773, 3) -- Crane
			selector:add(100771, 4) -- Walkway
			self._original_on_executed = {
				{ id = selector:select(), delay = 0 },
			}
		end,
	},
	-- Disable the catwalk gap
	[101407] = filter_disable,
	[103762] = filter_easy_above,
	-- Set shields to stay in place
	[102848] = shield_so,
	[102849] = shield_so,
	[102850] = shield_so,
	[102851] = shield_so,
	-- Restore unused navlinks and add new ones
	[102362] = {
		values = {
			so_action = "e_nl_up_2m_var4",
			align_position = false,
			enabled = true,
		},
	},
	[102357] = {
		values = {
			so_action = "e_nl_up_2m",
			align_position = false,
			enabled = true,
		},
	},
	[100812] = {
		on_executed = {
			{ id = 400015, delay = 0 },
			{ id = 400016, delay = 0 },
		},
	},
	-- Add the custom large window jump navlink
	[101735] = {
		on_executed = {
			{ id = 400019, delay = 0 },
		},
	},
	-- Restrict large window jump navlink access
	[100176] = exclude_cop_agents_shields_dozers,
	[400019] = exclude_cop_agents_shields_dozers,
	-- Restore unused cloaker hiding spots
	[103477] = enabled,
	[103478] = enabled,
	[103580] = enabled,
	-- Spawn Group delays
	[100699] = street_spawn,
	[100711] = street_spawn,
	[100719] = street_spawn,
	[100760] = street_spawn,
	[100767] = street_spawn,
	[102827] = catwalk_spawn,
	[101687] = roof_spawn,
	[400007] = scripted_swat_van_spawn,
	[400014] = scripted_swat_van_spawn,
}
