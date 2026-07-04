local diff_i = Eclipse.utils.difficulty_index()
local is_pro_job = Eclipse.utils.is_pro_job()
local set_diff_groups = Eclipse.utils.set_diff_groups
local get_difficulty_group_specific_value = Eclipse.utils.get_difficulty_group_specific_value
local preferred = Eclipse.preferred
local scripted_enemy = Eclipse.scripted_enemy
local filter_easy_above = {
	values = set_diff_groups("easy_above"),
}
local standard_spawn = {
	values = {
		interval = 15,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
}
local standard_init_spawn = {
	values = {
		interval = 20,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
	groups = preferred.no_shields_bulldozers,
}
local standard_init_spawn_why_does_it_have_11_spawn_points = {
	values = {
		interval = standard_init_spawn.values.interval,
		interval_balance_mul = standard_init_spawn.values.interval_balance_mul,
		elements = { 100426, 100204, 100200, 100192, 100199, 100193 },
	},
	groups = standard_init_spawn.groups,
}
local tower_spawn = {
	values = {
		interval = 25,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
	groups = preferred.no_shields_bulldozers,
}
local flank_spawn = {
	values = {
		interval = 30,
		interval_balance_mul = { 1.1, 1, 0.9, 0.8 },
	},
	groups = preferred.no_shields_bulldozers,
}
local heavy_swats = {
	enemy = {
		[scripted_enemy.heavy_swat_1] = get_difficulty_group_specific_value({ 4, 2, 1 }),
		[scripted_enemy.heavy_swat_2] = 3,
	},
}
local death_row_spawns = {
	on_executed = {
		{ id = 101678, delay = 0 },
		{ id = 101679, delay = 0 },
		{ id = 101680, delay = 0 },
		{ id = 101681, delay = 0 },
		{ id = 101682, delay = 0 },
	},
}
local cell_unlock_timer = (60 + (diff_i * 10)) * (is_pro_job and 1.5 or 1)
local ai_remove_area_triggers = {
	values = {
		instigator = "enemies_all",
	},
}
local disabled = {
	values = {
		enabled = false,
	},
}
local difficulty_add_25 = {
	difficulty_add = 0.25,
}
return {
	-- Combine some navigation areas
	[133004] = {
		ai_area = {
			{ 2, 72 },
			{ 4, 80 },
			{ 6, 81 },
			{ 32, 82, 83 },
			{ 52, 91 },
			{ 56, 97, 125 },
			{ 57, 99 },
			{ 73, 74 },
			{ 84, 85 },
			{ 89, 90 },
			{ 92, 124 },
			{ 93, 94 },
		},
	},
	-- Allow bot navigation earlier
	[102736] = {
		on_executed = {
			{ id = 103049, delay = 1 },
		},
	},
	-- Fix dominated enemies never being removed when moving on
	[100998] = ai_remove_area_triggers,
	[100991] = ai_remove_area_triggers,
	[100985] = ai_remove_area_triggers,
	[100984] = ai_remove_area_triggers,
	-- Adjusted diff curve
	-- [100022] = difficulty_add_25, -- Alarm (0.25)
	-- [101283] = difficulty_add_25, -- Intro ambush completed (0.5)
	-- [102997] = difficulty_add_25, -- Put drill on canteen door (0.75), OR
	-- [103010] = difficulty_add_25, -- Put drill on laundry door (0.75)
	-- [100269] = difficulty_add_25, -- Door to Bain opened (1)
	-- Modify intro ambush kill requirement, adding more difficulty scaling as well as player scaling
	[101344] = disabled,
	[101336] = filter_easy_above,
	[101334] = {
		pre_func = function(self)
			if self._modified_counter_triggers then
				return
			end
			self._modified_counter_triggers = true
			local counter_trigger = self:get_mission_element(100903)
			if counter_trigger then
				local intro_ambush_kill_requirement = {}
				for i = 1, 8 do
					intro_ambush_kill_requirement[i] = math.ceil(10 + i * diff_i)
				end
				local values = counter_trigger:values()
				values.amount = managers.groupai:state():_get_balancing_multiplier(intro_ambush_kill_requirement)
				for _, id in ipairs(values.elements or {}) do
					local counter = counter_trigger:get_mission_element(id)
					counter:add_trigger(counter_trigger:id(), values.trigger_type, values.amount, callback(counter_trigger, counter_trigger, "on_executed"))
				end
			end
		end,
	},
	-- Never switch from hunt to standard besiege on Pro Jobs
	[100115] = is_pro_job and disabled or nil,
	-- Adjust watchtower door logic
	-- Door is openable immediately, but the lever is not interactable until the normal time
	[101547] = {
		on_executed = {
			{ id = 101689, remove = true },
			{ id = 102902, delay = 0 },
		},
	},
	[100963] = {
		on_executed = {
			{ id = 102902, remove = true },
		},
	},
	-- No regular PONR, replace with FFO on Pro Jobs
	[101161] = disabled,
	[102736] = {
		set_ponr_state = true,
		on_executed = {
			{ id = 101689, delay = 0 },
			{ id = 101159, delay = 0.2 }, -- Delay hunt just long enough to avoid FFO's forced break :julespig:
		},
	},
	-- Extended cell unlock timer slightly on high difficulties (even more on Pro Jobs)
	[101402] = {
		values = {
			timer = cell_unlock_timer,
		},
	},
	-- Disable hiding Cloaker spots, they are very poorly set up (and unnecessary on this heist)
	[100800] = disabled,
	-- Prevent watchtower bridge reinforce point from being removed
	[102911] = disabled,
	-- Replace some Murky guards with heavy SWAT
	[101059] = heavy_swats, -- Intro
	[101060] = heavy_swats,
	[101061] = heavy_swats,
	[101064] = heavy_swats,
	[101065] = heavy_swats,
	[101066] = heavy_swats,
	[101067] = heavy_swats,
	[101068] = heavy_swats,
	[101367] = heavy_swats, -- Door-openers
	[101664] = heavy_swats,
	[101665] = heavy_swats,
	[101666] = heavy_swats,
	[101667] = heavy_swats,
	[101669] = heavy_swats, -- Security
	[101670] = heavy_swats,
	[101671] = heavy_swats,
	[101672] = heavy_swats,
	[101949] = heavy_swats,
	[101950] = heavy_swats,
	[101694] = heavy_swats, -- Cell block A entrance
	[101695] = heavy_swats,
	[101696] = heavy_swats,
	[101697] = heavy_swats,
	[102627] = disabled, -- Cells ambush (their SOs aren't set up correctly and honestly aren't really worthwhile)
	[102628] = disabled,
	[101366] = heavy_swats, -- Laundry/canteen entrance
	[101756] = heavy_swats,
	[101757] = heavy_swats,
	[101368] = heavy_swats,
	[101369] = heavy_swats,
	[101673] = heavy_swats, -- Turret room
	[101676] = heavy_swats,
	[103327] = heavy_swats,
	[103425] = heavy_swats,
	[101675] = heavy_swats,
	[103423] = heavy_swats,
	[103424] = heavy_swats,
	[101674] = heavy_swats,
	[101678] = heavy_swats, -- Death row
	[101679] = heavy_swats,
	[101680] = heavy_swats,
	[101681] = heavy_swats,
	[101682] = heavy_swats,
	[100596] = heavy_swats, -- Watchtower
	-- Add unused ambush spawns
	[100362] = {
		on_executed = {
			{ id = 101694, delay = 0 },
			{ id = 101695, delay = 0 },
			{ id = 101696, delay = 0 },
			{ id = 101697, delay = 0 },
			{ id = 101366, delay = 0 },
			{ id = 101368, delay = 0 },
			{ id = 101369, delay = 0 },
			{ id = 101757, delay = 0 },
			{ id = 101756, delay = 0 },
		},
	},
	[103326] = death_row_spawns,
	[102975] = death_row_spawns,
	-- Spawn group intervals
	[100821] = standard_spawn,
	[100875] = standard_spawn,
	[102431] = standard_spawn,
	[100007] = standard_spawn,
	[100128] = standard_spawn,
	[100130] = standard_spawn,
	[100663] = standard_spawn,
	[100669] = standard_spawn,
	[100675] = standard_spawn,
	[100741] = standard_init_spawn_why_does_it_have_11_spawn_points,
	[100131] = standard_init_spawn,
	[101365] = tower_spawn,
	[103529] = tower_spawn,
	[100888] = flank_spawn,
	[100951] = flank_spawn,
	[101420] = flank_spawn,
}
