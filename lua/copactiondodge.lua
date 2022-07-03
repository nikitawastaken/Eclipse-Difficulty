-- Fix incorrect sync of shoot accuracy
local init_original = CopActionDodge.init
function CopActionDodge:init(action_desc, ...)
	-- If server, multiply by 10 to send the correct number to clients (network message expects a value between 0-10)
	if Network:is_server() then
		action_desc.shoot_accuracy = (action_desc.shoot_accuracy or 1) * 10
	end

	local result = init_original(self, action_desc, ...)

	-- Devide by 10 again to get the correct value range
	action_desc.shoot_accuracy = (action_desc.shoot_accuracy or 10) / 10

	return result
end
