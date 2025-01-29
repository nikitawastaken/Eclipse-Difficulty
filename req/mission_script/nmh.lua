local disabled = {
	values = {
		enabled = false
	}
}
	
return {
	[103469] = {
		flashlight = true
	},
	[103470] = {
		flashlight = false
	},
	-- Alert all civs on mask up and delay panic button SO
	[102518] = {
		on_executed = {
			{ id = 102540, delay = 10 }
		},
		func = function()
			for _, u_data in pairs(managers.enemy:all_civilians()) do
				u_data.unit:movement():set_cool(false)
			end
		end
	},
	-- Disable most reinforce points
	[103706] = disabled,
	[103707] = disabled,
	[103847] = disabled,
}