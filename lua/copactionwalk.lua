-- Helper function to get the final path position
function CopActionWalk:get_destination_pos()
	return self._nav_point_pos(self._simplified_path and self._simplified_path[#self._simplified_path] or self._nav_path and self._nav_path[#self._nav_path])
end

-- Fix occasional incorrect animation speed
local idstr_base = Idstring("base")
function CopActionWalk:_adjust_move_anim(side, speed)
	local anim_data = self._ext_anim
	local same_haste = not anim_data.haste and anim_data[speed] or anim_data.haste == speed
	if same_haste and anim_data["move_" .. side] then
		return
	end

	local enter_t
	local redirect_name = speed .. "_" .. side
	local move_side = anim_data.move_side
	if move_side and (side == move_side or self._matching_walk_anims[side][move_side]) then
		local seg_rel_t = self._machine:segment_relative_time(idstr_base)
		local pose = anim_data.pose or self._fallback_pos

		if
			not self._walk_anim_lengths[pose]
			or not self._walk_anim_lengths[pose][self._stance.name]
			or not self._walk_anim_lengths[pose][self._stance.name][speed]
			or not self._walk_anim_lengths[pose][self._stance.name][speed][side]
		then
			return
		end

		local walk_anim_length = self._walk_anim_lengths[pose][self._stance.name][speed][side]
		enter_t = seg_rel_t * walk_anim_length
	end

	return self._ext_movement:play_redirect(redirect_name, enter_t)
end

-- Fix potential crash when walk action gets interrupted on client
local get_husk_interrupt_desc_original = CopActionWalk.get_husk_interrupt_desc
function CopActionWalk:get_husk_interrupt_desc(...)
	local old_action_desc = get_husk_interrupt_desc_original(self, ...)

	if not old_action_desc.nav_path then
		old_action_desc.nav_path = self._nav_path
	end

	return old_action_desc
end

if Network:is_client() then
	return
end

-- Fix pathing start position (should always be our current position)
Hooks:PreHook(CopActionWalk, "init", "eclipse_init", function(self, action_desc, common_data)
	local pos = common_data.pos
	local from_pos = action_desc.nav_path[1]
	if pos.x ~= from_pos.x or pos.y ~= from_pos.y then
		table.insert(action_desc.nav_path, 1, mvector3.copy(common_data.pos))
	end
end)
