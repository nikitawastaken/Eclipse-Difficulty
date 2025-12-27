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
			enemy_table = opts.enemy_table or nil,
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
			callback = opts.callback or false,
		},
	}

	return dummy
end

---Generate a civilian dummy element
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param pos Vector3: position for the element to be in
---@param rot Rotation: direction the element is facing
---@param opts? table: extra parameters
function M.gen_civilian_dummy(id, name, pos, rot, opts)
	opts = opts or {}
	local civilian_dummy = {
		id = id,
		editor_name = name,
		class = "ElementSpawnCivilian",
		values = {
			execute_on_startup = opts.execute_on_startup or false,
			position = pos,
			force_pickup = opts.force_pickup or "none",
			enemy = opts.enemy or nil,
			trigger_times = opts.trigger_times or 0,
			state = opts.state or "none",
			on_executed = opts.on_executed or {},
			rotation = rot,
			team = opts.team or "default",
			base_delay = opts.base_delay or 0,
			enabled = opts.enabled or false,
			callback = opts.callback or false,
		},
	}

	return civilian_dummy
end

---Generate a spawngroup element, used to organize dummys
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param elements table: what dummies will be used
---@param interval number: how minimum delay between spawns
function M.gen_spawngroup(id, name, elements, interval, opts)
	opts = opts or {}
	local spawngroup = {
		id = id,
		editor_name = name,
		class = "ElementSpawnEnemyGroup",
		values = {
			on_executed = {},
			trigger_times = 0,
			base_delay = 0,
			ignore_disabled = false,
			amount = opts.amount or 0,
			spawn_type = opts.spawn_type or "ordered",
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
			action_duration_min = opts.action_duration_min or 0,
			search_position = opts.search_position or pos,
			use_instigator = opts.use_instigator or false,
			trigger_times = 0,
			trigger_on = "none",
			search_distance = 0,
			so_action = opts.so_action or "none",
			path_stance = opts.path_stance or "hos",
			path_haste = "run",
			repeatable = false,
			attitude = "engage",
			interval = opts.interval or 2,
			action_duration_max = opts.action_duration_max or 0,
			align_rotation = opts.align_rotation or false,
			pose = opts.pose or "none",
			forced = opts.forced or false, --setting this to true skips the spawn anim
			base_chance = 1,
			interaction_voice = "none",
			SO_access = opts.SO_access or "512", -- default to sniper
			chance_inc = 0,
			interrupt_dmg = opts.interrupt_dmg or 1,
			interrupt_objective = false,
			on_executed = opts.on_executed or {},
			spawn_instigator_ids = opts.spawn_instigator_ids or {},
			followup_elements = opts.followup_elements or {},
			interrupt_dis = opts.interrupt_dis or 1,
			patrol_path = "none",
			callback = opts.callback or false,
			no_arrest = opts.no_arrest or false,
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
			callback = opts.callback or false,
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
			enabled = opts.enabled or false,
			interval = 0.1,
			trigger_on = opts.trigger_on or "on_enter",
			instigator = opts.instigator or "player",
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
			callback = opts.callback or false,
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
			callback = opts.callback or false,
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
			callback = opts.callback or false,
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
			callback = opts.callback or false,
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
			callback = opts.callback or false,
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
			callback = opts.callback or false,
		},
	}
	return smokegrenade
end

---Generate a elementspecialobjectivegroup element
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param opts? table: extra parameters
function M.gen_sogroup(id, name, pos, rot, opts)
	opts = opts or {}
	local sogroup = {
		id = id,
		editor_name = name,
		class = "ElementSpecialObjectiveGroup",
		values = {
			execute_on_startup = false,
			position = pos,
			rotation = rot,
			use_instigator = false,
			base_delay = opts.base_delay or 0,
			base_chance = opts.base_chance or 1,
			trigger_times = opts.trigger_times or 0,
			mode = opts.mode or "recurring_cloaker_spawn",
			followup_elements = opts.followup_elements or {},
			on_executed = opts.on_executed or {},
			enabled = true,
			callback = opts.callback or false,
		},
	}
	return sogroup
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
			callback = opts.callback or false,
		},
	}
	return preferedadd
end

---Generate a prefered remove element
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param opts? table: extra parameters
function M.gen_preferedremove(id, name, opts)
	opts = opts or {}
	local preferedremove = {
		id = id,
		editor_name = name,
		class = "ElementEnemyPreferedRemove",
		values = {
			execute_on_startup = false,
			base_delay = opts.base_delay or 0,
			trigger_times = opts.trigger_times or 0,
			elements = opts.elements or {},
			on_executed = opts.on_executed or {},
			enabled = true,
			callback = opts.callback or false,
		},
	}
	return preferedremove
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
			enabled = opts.enabled or false,
			base_delay = opts.base_delay or 0,
			digital_gui_unit_ids = opts.digital_gui_unit_ids or {},
			callback = opts.callback or false,
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
			enabled = opts.enabled or false,
			base_delay = opts.base_delay or 0,
			position = pos,
			rotation = rot,
			callback = opts.callback or false,
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
		module = "CoreElementUnitSequence",
		class = "ElementUnitSequence",
		values = {
			execute_on_startup = false,
			trigger_times = opts.trigger_times or 0,
			trigger_list = opts.trigger_list or {},
			on_executed = opts.on_executed or {},
			base_delay = opts.base_delay or 0,
			position = pos,
			rotation = rot,
			enabled = opts.enabled or false,
			callback = opts.callback or false,
		},
	}

	return object_editor
end

---Generate an object editor trigger
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param pos Vector3: position for the element to be in
---@param rot Rotation: direction the element is facing
---@param opts? table: extra parameters
function M.gen_object_editor_trigger(id, name, opts)
	opts = opts or {}
	local object_editor_trigger = {
		id = id,
		editor_name = name,
		module = "CoreElementUnitSequenceTrigger",
		class = "ElementUnitSequenceTrigger",
		values = {
			execute_on_startup = false,
			trigger_times = 1,
			sequence_list = opts.sequence_list or {},
			on_executed = opts.on_executed or {},
			base_delay = opts.base_delay or 0,
			enabled = opts.enabled or false,
			callback = opts.callback or false,
		},
	}

	return object_editor_trigger
end

---Generate a random element
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param opts? table: extra parameters
function M.gen_element_random(id, name, opts)
	opts = opts or {}
	local random_element = {
		id = id,
		editor_name = name,
		module = "CoreElementRandom",
		class = "ElementRandom",
		values = {
			execute_on_startup = false,
			ignore_disabled = opts.ignore_disabled or false,
			trigger_times = opts.trigger_times or 0,
			amount = opts.amount or 0,
			amount_random = opts.amount_random or 0,
			on_executed = opts.on_executed or {},
			base_delay = opts.base_delay or 0,
			enabled = true,
			callback = opts.callback or false,
		},
	}

	return random_element
end

---Generate a difficulty element
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param pos Vector3: position for the element to be in
---@param rot Rotation: direction the element is facing
---@param opts? table: extra parameters
function M.gen_difficulty(id, name, pos, rot, opts)
	opts = opts or {}
	local difficulty_element = {
		id = id,
		editor_name = name,
		class = "ElementDifficulty",
		values = {
			execute_on_startup = false,
			trigger_times = opts.trigger_times or 0,
			difficulty = opts.difficulty or 0,
			on_executed = opts.on_executed or {},
			base_delay = opts.base_delay or 0,
			position = pos,
			rotation = rot,
			enabled = true,
			callback = opts.callback or false,
		},
	}

	return difficulty_element
end

---Generate a chance element
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param pos Vector3: position for the element to be in
---@param rot Rotation: direction the element is facing
---@param opts? table: extra parameters
function M.gen_chance(id, name, pos, rot, opts)
	opts = opts or {}
	local chance_element = {
		id = id,
		editor_name = name,
		module = "CoreElementLogicChance",
		class = "ElementLogicChance",
		values = {
			execute_on_startup = false,
			trigger_times = opts.trigger_times or 0,
			chance = opts.chance or 0,
			on_executed = opts.on_executed or {},
			base_delay = opts.base_delay or 0,
			position = pos,
			rotation = rot,
			enabled = opts.enabled or false,
			callback = opts.callback or false,
		},
	}

	return chance_element
end

---Generate a enable unit element
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param pos Vector3: position for the element to be in
---@param rot Rotation: direction the element is facing
---@param opts? table: extra parameters
function M.gen_enable_unit(id, name, pos, rot, opts)
	opts = opts or {}
	local enable_unit = {
		id = id,
		editor_name = name,
		class = "ElementEnableUnit",
		values = {
			execute_on_startup = false,
			trigger_times = opts.trigger_times or 0,
			on_executed = opts.on_executed or {},
			unit_ids = opts.unit_ids or {},
			base_delay = opts.base_delay or 0,
			position = pos,
			rotation = rot,
			enabled = true,
			callback = opts.callback or false,
		},
	}

	return enable_unit
end

---Generate a disable unit element
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param pos Vector3: position for the element to be in
---@param rot Rotation: direction the element is facing
---@param opts? table: extra parameters
function M.gen_disable_unit(id, name, pos, rot, opts)
	opts = opts or {}
	local disable_unit = {
		id = id,
		editor_name = name,
		class = "ElementDisableUnit",
		values = {
			execute_on_startup = false,
			trigger_times = opts.trigger_times or 0,
			on_executed = opts.on_executed or {},
			unit_ids = opts.unit_ids or {},
			base_delay = opts.base_delay or 0,
			position = pos,
			rotation = rot,
			enabled = true,
			callback = opts.callback or false,
		},
	}

	return disable_unit
end

---Generate a instance param element
---@param id number: id of element, start from 400000
---@param name string: name of element for reference
---@param pos Vector3: position for the element to be in
---@param rot Rotation: direction the element is facing
---@param opts? table: extra parameters
function M.gen_instance_params(id, name, pos, rot, opts)
	opts = opts or {}
	local instance_param = {
		id = id,
		editor_name = name,
		module = "CoreElementInstance",
		class = "ElementInstanceSetParams",
		values = {
			execute_on_startup = false,
			trigger_times = opts.trigger_times or 0,
			on_executed = opts.on_executed or {},
			params = opts.params or {},
			instance = opts.instance or nil,
			base_delay = opts.base_delay or 0,
			position = pos,
			rotation = rot,
			enabled = true,
			callback = opts.callback or false,
		},
	}

	return instance_param
end

function M.gen_element_filter(id, name, pos, rot, opts)
	opts = opts or {}
	local element_filter = {
		id = id,
		editor_name = name,
		class = "ElementFilter",
		values = {
			execute_on_startup = opts.execute_on_startup or false,
			trigger_times = opts.trigger_times or 0,
			on_executed = opts.on_executed or {},
			base_delay = opts.base_delay or 0,
			mode_assault = true,
			mode_control = true,
			difficulty_easy = opts.difficulty_easy or false,
			difficulty_normal = opts.difficulty_normal or false,
			difficulty_hard = opts.difficulty_hard or false,
			difficulty_overkill = opts.difficulty_overkill or false,
			difficulty_overkill_145 = opts.difficulty_overkill_145 or false,
			difficulty_easy_wish = opts.difficulty_easy_wish or false,
			--difficulty_overkill_290 = opts.difficulty_overkill_290 or false,
			--difficulty_sm_wish = opts.difficulty_sm_wish or false,
			player_1 = opts.player_1 or false,
			player_2 = opts.player_2 or false,
			player_3 = opts.player_3 or false,
			player_4 = opts.player_4 or false,
			platform_pc_only = false,
			platform_win32 = true,
			platform_ps3 = false,
			platform_ps4_only = false,
			platform_xb1_only = false,
			position = pos,
			rotation = rot,
			enabled = opts.enabled or false,
		},
	}

	return element_filter
end

function M.gen_operator(id, name, pos, rot, opts)
	opts = opts or {}
	local operator = {
		id = id,
		editor_name = name,
		class = "ElementOperator",
		module = "CoreElementOperator",
		values = {
			execute_on_startup = opts.execute_on_startup or false,
			trigger_times = opts.trigger_times or 0,
			on_executed = opts.on_executed or {},
			base_delay = opts.base_delay or 0,
			position = pos,
			rotation = rot,
			enabled = opts.enabled or false,
			operation = opts.operation or "add",
			elements = opts.elements or {},
		},
	}

	return operator
end

return M
