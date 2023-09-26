-- Limit logic updates, there's no need to update it every frame
local update_original = CivilianBrain.update
function CivilianBrain:update(unit, t, ...)
	if self._next_logic_upd_t <= t then
		self._next_logic_upd_t = t + 1 / 30
		return update_original(self, unit, t, ...)
	end
end

local set_hostage_move_original = CivilianBrain.on_hostage_move_interaction
function CivilianBrain:on_hostage_move_interaction(interacting_unit, command, ...)
	if not self._logic_data.is_tied then
		return
	end

	local extra_hostages = managers.player:has_category_upgrade("player", "extra_hostages")
	if extra_hostages then
		tweak_data.player.max_nr_following_hostages = 5 -- i don't like this way of doing it but i don't care enough to investigate why the addend upgrade is being cringe here
	end

	if command == "move" then
		local following_hostages = managers.groupai:state():get_following_hostages(interacting_unit)

		if following_hostages and table.size(following_hostages) >= tweak_data.player.max_nr_following_hostages then
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
		set_hostage_move_original(self, interacting_unit, command, ...)
	end
end
