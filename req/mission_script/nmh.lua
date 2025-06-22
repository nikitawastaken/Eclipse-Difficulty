local preferred = Eclipse.preferred
local normal, hard, eclipse = Eclipse.utils.diff_groups()
local scripted_enemy = Eclipse.scripted_enemy
local security_guard = scripted_enemy.security_1
local ben_dozer = scripted_enemy.elite_bulldozer_1
local security_spawn = { enemy = security_guard }
local cloaker_respawn_amount = normal and 1 or hard and 2 or 3
local disabled = {
	values = {
		enabled = false,
	},
}
local staircase_spawn = {
	values = {
		interval = 5,
	},
}
local exit_spawn = {
	values = {
		interval = 10,
	},
}
local vent_spawn = {
	values = {
		interval = 20,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local cloaker_respawn_trigger = {
	values = {
		trigger_times = cloaker_respawn_amount,
	},
}
local terminator_dozer_1 = {
	enemy = ben_dozer,
	spawn_action = "e_sp_kick_enter_bulldozer",
	values = {
		position = Vector3(-2378.635, 2784.454, 0),
		rotation = Rotation(88.329, 0, 0),
	},
}

local terminator_dozer_2 = {
	enemy = ben_dozer,
	spawn_action = "e_sp_kick_enter_bulldozer",
	values = {
		position = Vector3(-2376, 2887, 0),
		rotation = Rotation(90, 0, 0),
	},
}
return {
	-- delay SWAT response
	[102675] = {
		on_executed = {
			{ id = 103225, delay = 30 },
		},
	},
	-- trigger dozers event
	[103450] = {
		on_executed = {
			{ id = 400063, delay = 0 },
		},
	},
	-- disable custom spawns when all players are in the elevator
	[102880] = {
		on_executed = {
			{ id = 400076, delay = 0 },
		},
	},
	-- replace investigate beat cops with security guards to match with PDTH
	[102633] = security_spawn,
	[102632] = security_spawn,
	[102631] = security_spawn,
	[102629] = security_spawn,
	[102630] = security_spawn,
	[102625] = security_spawn,
	[102628] = security_spawn,
	[102626] = security_spawn,
	[102627] = security_spawn,
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
				position = Vector3(925, 650, 0),
			},
		},
		on_executed = {
			{ id = 103700, delay = 0 }, -- activate stair case spawns immediately
		},
	},
	-- diff 1, blow the wall
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
	-- restore ovk 145+'s elevator dozers ambush at the end of the heist
	-- keep it only on eclipse
	[104122] = disabled,
	[104123] = disabled,
	[104323] = {
		values = {
			difficulty_overkill = false,
			difficulty_overkill_145 = false,
		},
	},
	-- 50% chance for the event to happen
	[104124] = { chance = 50 },
	-- replace the shield and blackdozer with elite dozers
	[104113] = terminator_dozer_1,
	[104112] = terminator_dozer_2,
	-- tweak elevator cloakers respawns
	[104261] = cloaker_respawn_trigger,
	[104262] = cloaker_respawn_trigger,
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
