local preferred = Eclipse.preferred
local disabled = {
	values = {
		enabled = false,
	},
}
local staircase_spawn = {
	values = {
		interval = 10,
	},
}
local exit_spawn = {
	values = {
		interval = 15,
	},
}
local vent_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
return {
	--delay SWAT response
	[102675] = {
		on_executed = {
			{ id = 103225, delay = 20 },
		},
	},
	--[[
	[103704] = { -- remove the stair case spawn from initial preferred randomisation
		pre_func = function(self)
			local groups = self._group_data.spawn_groups
			local exclude_element
			local exclude_ids = {
				103700,
			}

			for _, id in pairs(exclude_ids) do
				exclude_element = self:get_mission_element(id)

				while table.contains(groups, exclude_element) do
					table.delete(groups, exclude_element)
				end
			end
		end
	},
	]]
	[103225] = {
		reinforce = {
			{
				name = "reception",
				force = 3,
				position = Vector3(700, 675, 0),
			},
		},
		on_executed = {
			{ id = 103700, delay = 0 }, -- activate stair case spawns immediately
		},
	},
	--diff 1, blow wall
	[104057] = disabled,
	[103279] = {
		on_executed = {
			{ id = 104066, delay = 5 },
		},
	},
	-- alert all civs on mask up and delay panic button SO
	[102518] = {
		on_executed = {
			{ id = 102540, delay = 10 },
		},
		func = function()
			for _, u_data in pairs(managers.enemy:all_civilians()) do
				u_data.unit:movement():set_cool(false)
			end
		end,
	},
	-- enable flashlights when power is cut
	[103469] = {
		flashlight = true,
	},
	[103470] = {
		flashlight = false,
	},
	-- disable most reinforce points
	[103706] = disabled,
	[103707] = disabled,
	[103847] = disabled,
	-- spawn group delays
	[100407] = staircase_spawn,
	[100414] = exit_spawn,
	[100420] = exit_spawn,
	[103683] = vent_spawn,
	[103086] = vent_spawn,
	[103111] = vent_spawn,
	[101740] = vent_spawn,
	[103097] = vent_spawn,
	[103761] = vent_spawn,
	[103479] = vent_spawn,
	[103751] = vent_spawn,
	[103099] = vent_spawn,
	[103104] = vent_spawn,
	[103273] = vent_spawn,
	[100406] = vent_spawn,
	[103134] = vent_spawn,
	[103113] = vent_spawn,
}
