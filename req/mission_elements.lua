---@module Mission Element Generators
local M = {}

---Generate a dummy element
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param pos Vector3: position for the element to be in
---@param rot Rotation: direction the element is facing
---@param opts? table: extra parameters
function M.gen_dummy(id, name, pos, rot, opts)
	opts = opts or {}
	local dummy = {
		id = id,
		editor_name = name,
		class = "ElementSpawnEnemyDummy",
		values = {
			execute_on_startup = opts.execute_on_startup or false,
			participate_to_group_ai = opts.participate_to_group_ai or false,
			position = pos,
			force_pickup = opts.force_pickup or "none",
			voice = opts.voice or 0,
			enemy = opts.enemy or "units/payday2/characters/ene_swat_1/ene_swat_1",
			trigger_times = opts.trigger_times or 0,
			spawn_action = opts.spawn_action or "none",
			accessibility = opts.accessibility or "any",
			on_executed = opts.on_executed or {},
			rotation = rot,
			team = opts.team or "default",
			base_delay = opts.base_delay or 0,
			enabled = opts.enabled or false,
			amount = opts.amount or 0,
			interval = opts.interval or 5,
		},
	}

	return dummy
end
---Generate a spawngroup element, used to organize dummys
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param elements table: what dummies will be used
---@param interval number: how minimum delay between spawns
function M.gen_spawngroup(id, name, elements, interval)
	local spawngroup = {
		id = id,
		editor_name = name,
		class = "ElementSpawnEnemyGroup",
		values = {
			on_executed = {},
			trigger_times = 0,
			base_delay = 0,
			ignore_disabled = false,
			amount = 0,
			spawn_type = "ordered",
			team = "default",
			execute_on_startup = false,
			enabled = true,
			preferred_spawn_groups = {
				"tac_shield_wall_charge",
				"FBI_spoocs",
				"tac_tazer_charge",
				"tac_tazer_flanking",
				"tac_shield_wall",
				"tac_swat_rifle_flank",
				"tac_shield_wall_ranged",
				"tac_bull_rush",
			},
			elements = elements,
			interval = interval or 0,
		},
	}

	return spawngroup
end

---Generate a special objective element
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param pos Vector3: position for the element to be in
---@param rot Rotation: direction the element is facing
---@param opts? table: extra parameters
function M.gen_so(id, name, pos, rot, opts)
	opts = opts or {}
	local special_objective = {
		id = id,
		editor_name = name,
		class = "ElementSpecialObjective",
		values = {
			path_style = opts.path_style or "destination",
			align_position = opts.align_position or false,
			ai_group = "enemies",
			is_navigation_link = opts.is_navigation_link or false,
			position = pos,
			scan = opts.scan or false,
			needs_pos_rsrv = opts.needs_pos_rsrv or false,
			enabled = true,
			execute_on_startup = false,
			rotation = rot,
			base_delay = 0,
			action_duration_min = 0,
			search_position = pos,
			use_instigator = true,
			trigger_times = 0,
			trigger_on = "none",
			search_distance = 0,
			so_action = opts.so_action or "none",
			path_stance = opts.path_stance or "hos",
			path_haste = "run",
			repeatable = false,
			attitude = "engage",
			interval = 2,
			action_duration_max = 0,
			align_rotation = opts.align_rotation or false,
			pose = opts.pose or "none",
			forced = opts.forced or false, --setting this to true skips the spawn anim
			base_chance = 1,
			interaction_voice = "none",
			SO_access = opts.SO_access or "512", -- default to sniper
			chance_inc = 0,
			interrupt_dmg = 1,
			interrupt_objective = false,
			on_executed = {},
			interrupt_dis = opts.interrupt_dis or 1,
			patrol_path = "none",
		},
	}

	return special_objective
end

---Generate an ai global event element
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param opts? table: extra parameters
function M.gen_aiglobalevent(id, name, opts)
	opts = opts or {}
	local aiglobalevent = {
		id = id,
		editor_name = name,
		class = "ElementAiGlobalEvent",
		values = {
			on_executed = opts.on_executed or {},
			trigger_times = 1,
			base_delay = 0,
			execute_on_startup = false,
			enabled = true,
			wave_mode = opts.wave_mode or "none",
			AI_event = opts.AI_event or "none",
			blame = opts.blame or "empty",
		},
	}

	return aiglobalevent
end

---Generate fake assault state element
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param state boolean: honestly dunno what this does
function M.gen_fakeassaultstate(id, name, state)
	local fakeassaultstate = {
		id = id,
		editor_name = name,
		class = "ElementFakeAssaultState",
		values = {
			on_executed = {},
			trigger_times = 1,
			base_delay = 0,
			execute_on_startup = false,
			enabled = true,
			state = state or false,
		},
	}

	return fakeassaultstate
end

---Generate an area element
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param pos Vector3: position for the element to be in
---@param rot Rotation: direction the element is facing
---@param opts? table: extra parameters
function M.gen_areatrigger(id, name, pos, rot, opts)
	opts = opts or {}
	local areatrigger = {
		id = id,
		editor_name = name,
		class = "ElementAreaTrigger",
		module = "CoreElementArea",
		values = {
			execute_on_startup = false,
			trigger_times = opts.trigger_times or 1,
			on_executed = opts.on_executed or {},
			base_delay = opts.base_delay or 0,
			position = pos,
			rotation = rot,
			enabled = true,
			interval = 0.1,
			trigger_on = "on_enter",
			instigator = "player",
			shape_type = opts.shape_type or "box",
			width = opts.width or 500,
			depth = opts.depth or 500,
			height = opts.height or 500,
			radius = opts.radius or 250,
			spawn_unit_elements = {},
			amount = opts.amount or "1",
			instigator_name = "",
			use_disabled_shapes = false,
			substitute_object = "",
		},
	}

	return areatrigger
end

---Generate a dummy trigger element
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param pos Vector3: position for the element to be in
---@param rot Rotation: direction the element is facing
---@param opts? table: extra parameters
function M.gen_dummytrigger(id, name, pos, rot, opts)
	opts = opts or {}
	local dummytrigger = {
		id = id,
		editor_name = name,
		class = "ElementEnemyDummyTrigger",
		values = {
			execute_on_startup = false,
			trigger_times = opts.trigger_times or 0,
			elements = opts.elements or {},
			on_executed = opts.on_executed or {},
			base_delay = opts.base_delay or 0,
			position = pos,
			rotation = rot,
			enabled = true,
			event = opts.event or "spawn",
		},
	}
	return dummytrigger
end

---Generate a mission script element
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param opts? table: extra parameters
function M.gen_missionscript(id, name, opts)
	opts = opts or {}
	local missionscript = {
		id = id,
		editor_name = name,
		class = "MissionScriptElement",
		module = "CoreMissionScriptElement",
		values = {
			execute_on_startup = false,
			trigger_times = opts.trigger_times or 0,
			on_executed = opts.on_executed or {},
			base_delay = opts.base_delay or 0,
			enabled = opts.enabled or false,
		},
	}
	return missionscript
end

---Generate a toggle element
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param opts? table: extra parameters
function M.gen_toggleelement(id, name, opts)
	opts = opts or {}
	local toggleelement = {
		id = id,
		editor_name = name,
		class = "ElementToggle",
		module = "CoreElementToggle",
		values = {
			execute_on_startup = false,
			trigger_times = opts.trigger_times or 0,
			set_trigger_times = opts.set_trigger_times or -1,
			elements = opts.elements or {},
			on_executed = opts.on_executed or {},
			base_delay = opts.base_delay or 0,
			enabled = opts.enabled or false,
			toggle = opts.toggle or "on",
		},
	}
	return toggleelement
end

---Generate a dialogue element
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param opts? table: extra parameters
function M.gen_dialogue(id, name, opts)
	opts = opts or {}
	local dialogue = {
		id = id,
		editor_name = name,
		class = "ElementDialogue",
		values = {
			execute_on_startup = false,
			trigger_times = opts.trigger_times or 0,
			on_executed = opts.on_executed or {},
			base_delay = opts.base_delay or 0,
			dialogue = opts.dialogue or "none",
			enabled = true,
			can_not_be_muted = opts.can_not_be_muted or false,
			execute_on_executed_when_done = opts.execute_on_executed_when_done or false,
			play_on_player_instigator_only = opts.play_on_player_instigator_only or false,
			use_instigator = opts.use_instigator or false,
			use_position = opts.use_position or false,
		},
	}
	return dialogue
end

---Generate a smoke grenade or flashbang element
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param pos Vector3: position for the element to be in
---@param rot Rotation: direction the element is facing
---@param opts? table: extra parameters
function M.gen_smokegrenade(id, name, pos, rot, opts)
	opts = opts or {}
	local smokegrenade = {
		id = id,
		editor_name = name,
		class = "ElementSmokeGrenade",
		values = {
			execute_on_startup = false,
			position = pos,
			rotation = rot,
			enabled = true,
			base_delay = opts.base_delay or 0,
			duration = opts.duration or 0,
			effect_type = opts.effect_type or "smoke",
			ignore_control = true,
			immediate = true,
			on_executed = opts.on_executed or {},
			trigger_times = opts.trigger_times or 0,
		},
	}
	return smokegrenade
end

---Generate a prefered add element
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param opts? table: extra parameters
function M.gen_preferedadd(id, name, opts)
	opts = opts or {}
	local preferedadd = {
		id = id,
		editor_name = name,
		class = "ElementEnemyPreferedAdd",
		values = {
			execute_on_startup = false,
			base_delay = opts.base_delay or 0,
			trigger_times = opts.trigger_times or 0,
			spawn_groups = opts.spawn_groups or {},
			on_executed = opts.on_executed or {},
			enabled = true,
		},
	}
	return preferedadd
end

---Generate a counter element
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param opts? table: extra parameters
function M.gen_counter(id, name, opts)
	opts = opts or {}
	local counter = {
		id = id,
		editor_name = name,
		module = "CoreElementCounter",
		class = "ElementCounter",
		values = {
			execute_on_startup = opts.execute_on_startup or false,
			on_executed = opts.on_executed or {},
			trigger_times = opts.trigger_times or 0,
			counter_target = opts.counter_target or 0,
			enabled = opts.enabled or true,
			base_delay = opts.base_delay or 0,
			digital_gui_unit_ids = opts.digital_gui_unit_ids or {},
		},
	}

	return counter
end

---Generate a global event element
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param pos Vector3: position for the element to be in
---@param rot Rotation: direction the element is facing
---@param opts? table: extra parameters
function M.gen_global_event(id, name, pos, rot, opts)
	opts = opts or {}
	local global_event = {
		id = id,
		editor_name = name,
		module = "CoreElementGlobalEventTrigger",
		class = "ElementGlobalEventTrigger",
		values = {
			execute_on_startup = opts.execute_on_startup or false,
			global_event = opts.global_event or "",
			on_executed = opts.on_executed or {},
			trigger_times = opts.trigger_times or 0,
			enabled = opts.enabled or true,
			base_delay = opts.base_delay or 0,
			position = pos,
			rotation = rot,
		},
	}

	return global_event
end

---Generate an object editor that lets edit objects that have unit sequences such as SWAT vans, choppers or vents
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param pos Vector3: position for the element to be in
---@param rot Rotation: direction the element is facing
---@param opts? table: extra parameters
function M.gen_object_editor(id, name, pos, rot, opts)
	opts = opts or {}
	local object_editor = {
		id = id,
		editor_name = name,
		module = "ElementUnitSequence",
		class = "CoreElementUnitSequence",
		values = {
			execute_on_startup = false,
			trigger_times = opts.trigger_times or 0,
			trigger_list = opts.trigger_list or {},
			on_executed = opts.on_executed or {},
			base_delay = opts.base_delay or 0,
			position = pos,
			rotation = rot,
			enabled = true,
		},
	}

	return object_editor
end

return M
