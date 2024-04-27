-- Stop shooting when entering arrest logic
Hooks:PostHook(CopLogicArrest, "enter", "sh_enter", function(data)
	data.unit:movement():set_allow_fire(false)
end)

-- Fix incorrect body part use when calling in, getting enemies stuck if they failed calling in
function CopLogicArrest._call_the_police(data, my_data)
	my_data.calling_the_police = data.unit:movement():action_request({
		variant = "arrest_call",
		body_part = 2,
		type = "act",
		blocks = {
			aim = -1,
			action = -1,
			walk = -1,
		},
	})

	if my_data.calling_the_police then
		managers.groupai:state():on_criminal_suspicion_progress(nil, data.unit, "calling")
	end

	CopLogicArrest._say_call_the_police(data, my_data)
end
