-- Prevent changing back to hostile stance if bot entered with combat stance
local enter_original = TeamAILogicAssault.enter
function TeamAILogicAssault.enter(data, ...)
	local movement = data.unit:movement()
	local set_stance = movement.set_stance
	movement.set_stance = function(self, ...)
		if self:stance_code() == 1 then
			return set_stance(self, ...)
		end
	end

	enter_original(data, ...)

	movement.set_stance = set_stance ~= getmetatable(movement).set_stance and set_stance or nil
end
