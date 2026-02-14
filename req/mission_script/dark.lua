local scripted_enemy = Eclipse.scripted_enemy
local normal_and_above, overkill_and_above = Eclipse.utils.diff_threshold()
local murky_arm_security = scripted_enemy.murkywater_1
local murky_security_1 = scripted_enemy.security_1
local murky_security_2 = scripted_enemy.security_2
local murky_security_3 = scripted_enemy.security_3
local murky_guard_list_low_diffs = { [murky_security_1] = 2, [murky_security_2] = 2, [murky_security_3] = 2, [murky_arm_security] = 1 }
local murky_guard_list_high_diffs = { [murky_arm_security] = 4, [murky_security_1] = 1, [murky_security_2] = 1, [murky_security_3] = 1 }

local murkywater_security_enemy = overkill_and_above and murky_guard_list_high_diffs or murky_guard_list_low_diffs

local murkywater_security = { enemy = murkywater_security_enemy }
return {
	-- add regular murkywater security to the spawn pool
	[101189] = murkywater_security,
	[102077] = murkywater_security,
	[102078] = murkywater_security,
	[102079] = murkywater_security,
	[102101] = murkywater_security,
	[102102] = murkywater_security,
	[102103] = murkywater_security,
	[102121] = murkywater_security,
	[102526] = murkywater_security,
	[103837] = murkywater_security,
	[103845] = murkywater_security,
	[103849] = murkywater_security,
	[103850] = murkywater_security,
	[103817] = murkywater_security,
	[103818] = murkywater_security,
	[103865] = murkywater_security,
	[103872] = murkywater_security,
	[103880] = murkywater_security,
	[103888] = murkywater_security,
	[103772] = murkywater_security,
	[103889] = murkywater_security,
	[105610] = murkywater_security,
	[105631] = murkywater_security,
	[102174] = murkywater_security,
	[102369] = murkywater_security,
	[103618] = murkywater_security,
	[103619] = murkywater_security,
	[100123] = murkywater_security,
	[100124] = murkywater_security,
	[101525] = murkywater_security,
	[101528] = murkywater_security,
}
