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
	"e_so_hide_behind_door_enter",
})

-- "group_ai_flagged" -> flagged by SO group element, genuine GroupAI-handled hiding Cloaker SO
-- "double_flagged" -> flagged by both an SO group element and in mission scripting, NOT ideal
-- "mission_flagged" -> flagged in mission scripting, NOT a GroupAI-handled hiding Cloaker SO but should act like one
-- "animation_flagged" -> uses a common hiding SO action, likely a scripted hide SO
-- "forced_not_flagged" -> flagged in mission scripting as NOT a hiding Cloaker SO, regardless of SO action
-- "not_flagged" -> no other flags raised, likely not a hiding Cloaker SO
-- "vanilla" -> hiding Cloaker task rework disabled
ElementSpecialObjective.hiding_cloaker_SO_states = {
	group_ai_flagged = 7,
	double_flagged = 6,
	mission_flagged = 5,
	animation_flagged = 4,
	forced_not_flagged = 3,
	not_flagged = 2,
	vanilla = 1,
}

function ElementSpecialObjective:get_hiding_cloaker_SO_state()
	if not tweak_data.group_ai.use_reworked_cloaker_task then
		return self.hiding_cloaker_SO_states.vanilla
	end

	local values = self._values
	if values.SO_group_hiding_cloaker_SO and values.hiding_cloaker_SO then
		if not self._double_flagged_warned then
			self._double_flagged_warned = true
			Eclipse:warn_console(string.format("Hiding Cloaker SO %u is double-flagged", self._id))
		end

		return self.hiding_cloaker_SO_states.double_flagged
	elseif values.SO_group_hiding_cloaker_SO then
		return self.hiding_cloaker_SO_states.group_ai_flagged
	elseif values.hiding_cloaker_SO then
		return self.hiding_cloaker_SO_states.mission_flagged
	elseif values.hiding_cloaker_SO == false then
		return self.hiding_cloaker_SO_states.forced_not_flagged
	elseif self._hiding_cloaker_actions[values.so_action] then
		return self.hiding_cloaker_SO_states.animation_flagged
	end

	return self.hiding_cloaker_SO_states.not_flagged
end

function ElementSpecialObjective:_hiding_cloaker_tweak()
	local groupai_state = managers.groupai and managers.groupai:state()
	return groupai_state and groupai_state._tweak_data and groupai_state._tweak_data.cloaker or {}
end

Hooks:PreHook(ElementSpecialObjective, "_get_action_duration", "eclipse__get_action_duration", function(self)
	if self:get_hiding_cloaker_SO_state() < self.hiding_cloaker_SO_states.group_ai_flagged then
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
Hooks:PostHook(ElementSpecialObjective, "event", "eclipse_event", function(self, name, unit)
	if not (name == "anim_start" or name == "fail" or name == "complete") then
		return
	end

	if not alive(unit) then
		return
	end

	if self:get_hiding_cloaker_SO_state() < self.hiding_cloaker_SO_states.animation_flagged then
		return
	end

	local char_dmg_ext = unit:character_damage()
	if char_dmg_ext and char_dmg_ext:dead() then
		return
	end

	local base_ext = unit:base()
	if not base_ext then
		Eclipse:warn_console(string.format("Unit on special objective %u without base extension", self._id))
		return
	end

	local hiding_cloaker_tweak = self:_hiding_cloaker_tweak()
	if name == "anim_start" then
		self:_set_cloaker_is_hiding(unit:key(), true)

		if hiding_cloaker_tweak.goggles_on_when_hiding == false then
			self:_chk_run_base_ext_method(base_ext, "set_cloaker_goggles_on", false)
		end

		if hiding_cloaker_tweak.use_idle_noise_when_hiding == false then
			self:_chk_run_base_ext_method(base_ext, "set_cloaker_noise_on", false)
		end
	elseif self._cloakers_currently_hiding and self._cloakers_currently_hiding[unit:key()] then
		self:_set_cloaker_is_hiding(unit:key(), false)

		self:_chk_run_base_ext_method(base_ext, "set_cloaker_goggles_on", true)

		local whistle = hiding_cloaker_tweak.whistle_on_leave_hiding ~= false
		self:_chk_run_base_ext_method(base_ext, "set_cloaker_noise_on", true, whistle)
	end
end)

function ElementSpecialObjective:_chk_run_base_ext_method(base_ext, method, ...)
	if base_ext[method] then
		base_ext[method](base_ext, ...)
		return true
	end

	Eclipse:warn_console(string.format('Unit on special objective %u without base extension method "%s"', self._id, method))
end

function ElementSpecialObjective:_set_cloaker_is_hiding(u_key, is_hiding)
	if is_hiding then
		self._cloakers_currently_hiding = self._cloakers_currently_hiding or {}
		self._cloakers_currently_hiding[u_key] = true
	elseif self._cloakers_currently_hiding then
		self._cloakers_currently_hiding[u_key] = nil
		if not next(self._cloakers_currently_hiding) then
			self._cloakers_currently_hiding = nil
		end
	end
end
