-- Limit logic updates, there's no need to update it every frame
local update_original = CivilianBrain.update
function CivilianBrain:update(unit, t, ...)
	if self._next_logic_upd_t <= t then
		self._next_logic_upd_t = t + 1 / 30
		return update_original(self, unit, t, ...)
	end
end

function CivilianBrain:init(unit)
	self._unit = unit
	self._timer = TimerManager:game()

	self:set_update_enabled_state(false)

	self._current_logic = nil
	self._current_logic_name = nil
	self._active = true
	self._SO_access = managers.navigation:convert_access_flag(tweak_data.character[unit:base()._tweak_table].access)
	self._slotmask_enemies = managers.slot:get_mask("criminals")
	CopBrain._reload_clbks[unit:key()] = callback(self, self, "on_reload")

	if unit:base().add_tweak_data_changed_listener then
		unit:base():add_tweak_data_changed_listener("CivilianBrainTweakDataChange" .. tostring(unit:key()), callback(self, self, "_clbk_tweak_data_changed"))
	end

	local tutorial = Global.level_data and (Global.level_data.level_id == "short2_stage1" or Global.level_data.level_id == "short2_stage2b")
	local extra_hostages = managers.player:upgrade_value("player", "extra_hostages", 0)
	tweak_data.player.max_nr_following_hostages = extra_hostages

	if tutorial then
		tweak_data.player.max_nr_following_hostages = 1
	end
end

function CivilianBrain:on_hostage_move_interaction(interacting_unit, command)
	if not self._logic_data.is_tied then
		return
	end

	if command == "move" then
		local following_hostages = managers.groupai:state():get_following_hostages(interacting_unit)

		if tweak_data.player.max_nr_following_hostages < 1 or following_hostages and tweak_data.player.max_nr_following_hostages <= table.size(following_hostages) then
			return
		end

		if not self._unit:anim_data().drop and self._unit:anim_data().tied then
			return
		end

		local stand_action_desc = {
			clamp_to_graph = true,
			variant = "stand_tied",
			body_part = 1,
			type = "act",
		}
		local action = self._unit:movement():action_request(stand_action_desc)

		if not action then
			return
		end

		self._unit:movement():set_stance("cbt", nil, true)

		local follow_objective = {
			interrupt_health = 0,
			distance = 500,
			type = "follow",
			lose_track_dis = 2000,
			stance = "cbt",
			interrupt_dis = 0,
			follow_unit = interacting_unit,
			nav_seg = interacting_unit:movement():nav_tracker():nav_segment(),
			fail_clbk = callback(self, self, "on_hostage_follow_objective_failed"),
		}

		self:set_objective(follow_objective)
		self._unit:interaction():set_tweak_data("hostage_stay")
		self._unit:interaction():set_active(true, true)
		interacting_unit:sound():say("f38_any", true, false)

		self._following_hostage_contour_id = self._unit:contour():add("friendly", true)

		managers.groupai:state():on_hostage_follow(interacting_unit, self._unit, true)
	elseif command == "stay" then
		if not self._unit:anim_data().stand then
			return
		end

		self:set_objective({
			amount = 1,
			type = "surrender",
			aggressor_unit = interacting_unit,
		})

		if not self._unit:anim_data().stand then
			return
		end

		local stand_action_desc = {
			clamp_to_graph = true,
			variant = "drop",
			body_part = 1,
			type = "act",
		}
		local action = self._unit:movement():action_request(stand_action_desc)

		if not action then
			return
		end

		self._unit:movement():set_stance("hos", nil, true)
		self._unit:interaction():set_tweak_data("hostage_move")
		self._unit:interaction():set_active(true, true)

		if alive(interacting_unit) then
			interacting_unit:sound():say("f02x_sin", true, false)
		end

		if self._following_hostage_contour_id then
			self._unit:contour():remove_by_id(self._following_hostage_contour_id, true)

			self._following_hostage_contour_id = nil
		end

		managers.groupai:state():on_hostage_follow(interacting_unit, self._unit, false)
	elseif command == "release" then
		self._logic_data.is_tied = nil

		if self._logic_data.objective and self._logic_data.objective.type == "follow" then
			self:set_objective(nil)
		end

		self._unit:movement():set_stance("hos", nil, true)

		local stand_action_desc = {
			variant = "panic",
			body_part = 1,
			type = "act",
		}
		local action = self._unit:movement():action_request(stand_action_desc)

		if not action then
			return
		end

		self._unit:interaction():set_tweak_data("intimidate")
		self._unit:interaction():set_active(false, true)

		if self._following_hostage_contour_id then
			self._unit:contour():remove_by_id(self._following_hostage_contour_id, true)

			self._following_hostage_contour_id = nil
		end

		managers.groupai:state():on_hostage_follow(interacting_unit, self._unit, false)
	end

	return true
end
