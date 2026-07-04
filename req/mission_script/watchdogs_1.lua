local preferred = Eclipse.preferred
local filter_disable = {
	values = Eclipse.utils.set_diff_groups("disable"),
}
local filter_easy_above = {
	values = Eclipse.utils.set_diff_groups("easy_above"),
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
	-- Disable the catwalk gap
	[101407] = filter_disable,
	[103762] = filter_easy_above,
	-- Set shields to stay in place
	[102848] = shield_so,
	[102849] = shield_so,
	[102850] = shield_so,
	[102851] = shield_so,
	-- Spawn Group delays
	[400007] = scripted_swat_van_spawn,
	[400014] = scripted_swat_van_spawn,
	[100699] = street_spawn,
	[100711] = street_spawn,
	[100719] = street_spawn,
	[100760] = street_spawn,
	[100767] = street_spawn,
	[102827] = catwalk_spawn,
	[101687] = roof_spawn,
}
