-- Keep position saved for AI SOs to fix some older map scripting
Hooks:PreHook(ElementSpecialObjective, "_finalize_values", "sh__finalize_values", function(self, values)
	if self:value("so_action"):begins("AI") and values.path_style == "destination" then
		self._AI_SO_pos = values.position
	end
end)

-- Keep hunt and search as actual objective types instead of making it defend_area
-- This is done to be able to differentiate between those objectives and make hunt work properly (search is currently unused)
local get_objective_original = ElementSpecialObjective.get_objective
function ElementSpecialObjective:get_objective(...)
	local objective = get_objective_original(self, ...)

	if objective and (self._is_AI_SO or string.begins(self._values.so_action, "AI")) then
		local objective_type = self._values.so_action:sub(4)
		if objective_type == "hunt" or objective_type == "search" then
			objective.type = objective_type
		end

		if not objective.nav_seg and self._AI_SO_pos then
			objective.nav_seg = managers.navigation:get_nav_seg_from_pos(self._AI_SO_pos)
			objective.area = managers.groupai:state():get_area_from_nav_seg_id(objective.nav_seg)
		end
	end

	return objective
end

-- Hiding Cloaker task rework garbage below
ElementSpecialObjective._hiding_cloaker_actions = table.list_to_set({
	"e_so_idle_by_container",
	"e_so_sneak_wait_stand",
	"e_so_sneak_wait_crh",
	"e_so_hide_under_car_enter",
})

function ElementSpecialObjective:_is_hiding_cloaker_SO()
	return self._values.hiding_cloaker_SO or self._hiding_cloaker_actions[self._values.so_action]
end

function ElementSpecialObjective:_hiding_cloaker_tweak()
	local groupai_state = managers.groupai and managers.groupai:state()
	return groupai_state and groupai_state._tweak_data and groupai_state._tweak_data.cloaker or {}
end

Hooks:PreHook(ElementSpecialObjective, "_get_action_duration", "eclipse__get_action_duration", function(self)
	if not self:_is_hiding_cloaker_SO() then
		return
	end

	local hiding_cloaker_tweak = self:_hiding_cloaker_tweak()
	local hide_durations = hiding_cloaker_tweak.hide_durations or {
		120,
		180,
	}
	if self._values.action_duration_min then
		self._values.action_duration_min = hide_durations[1]
	end

	if self._values.action_duration_max then
		self._values.action_duration_max = hide_durations[2]
	end
end)

-- Surely there's a better way to do this?
-- TODO: make whistle on leave hiding not occur if interrupted on the way to the SO location
Hooks:PostHook(ElementSpecialObjective, "event", "eclipse_event", function(self, name, unit)
	if not (name == "anim_start" or name == "fail" or name == "complete") then
		return
	end

	if not alive(unit) or not self:_is_hiding_cloaker_SO() then
		return
	end

	local char_dmg_ext = unit:character_damage()
	if char_dmg_ext and char_dmg_ext:dead() then
		return
	end

	local base_ext = unit:base()
	if not base_ext then
		return
	end

	local hiding_cloaker_tweak = self:_hiding_cloaker_tweak()
	if name == "anim_start" then
		if hiding_cloaker_tweak.goggles_on_when_hiding == false then
			base_ext:set_cloaker_goggles_on(false)
		end

		if hiding_cloaker_tweak.use_idle_noise_when_hiding == false then
			base_ext:set_cloaker_noise_on(false)
		end
	else
		local whistle = hiding_cloaker_tweak.whistle_on_leave_hiding ~= false
		base_ext:set_cloaker_goggles_on(true)
		base_ext:set_cloaker_noise_on(true, whistle)
	end
end)
