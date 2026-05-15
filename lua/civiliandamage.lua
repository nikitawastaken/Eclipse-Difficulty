Hooks:PostHook(CivilianDamage, "die", "eclipse_die", function(self)
	if managers.groupai:state():is_police_called() then
		return
	end
	managers.groupai:state():register_strike(tweak_data.player.stealth_strikes.reason_addends.civilian_kill, "civ_too_many_killed")
end)
