-- Fix pathing start position (should always be our current position)
if Network:is_server() then
	Hooks:PreHook(CopActionWalk, "init", "sh_init", function (self, action_desc, common_data)
		local pos =  common_data.pos
		local from_pos = action_desc.nav_path[1]
		if pos.x ~= from_pos.x or pos.y ~= from_pos.y or pos.z ~= from_pos.z then
			table.insert(action_desc.nav_path, 1, mvector3.copy(common_data.pos))
		end
	end)
end


-- Helper function to get the final path position
function CopActionWalk:get_destination_pos()
	return self._nav_point_pos(self._simplified_path and self._simplified_path[#self._simplified_path] or self._nav_path and self._nav_path[#self._nav_path])
end
