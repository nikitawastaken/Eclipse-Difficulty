core:module("CoreMissionManager")
local level = Global.level_data and Global.level_data.level_id or ""

local function _remove_downed()
	count = managers.network:session() and managers.network:session():amount_of_alive_players() or 1
	for _,peer in pairs(managers.groupai:state():all_char_criminals()) do
		if peer.unit:movement():downed() then
			count = count - 1
		end
	end

	return count ~= 0 and count or 1
end

function MissionManager:update(t, dt)
	for _, script in pairs(self._scripts) do
		script:update(t, dt)
	end

	-- Hoxton Breakout
	if Network:is_client() then
	elseif level == "hox_1" then
		self:get_element_by_id(100247):values().amount = _remove_downed()
	end
end