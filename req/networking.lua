local function get_unit_from_key(key)
	return managers.enemy:all_enemies()[key] or managers.enemy:all_civilians()[key]
end

NetworkHelper:AddReceiveHook("eclipse_hostage_trade", "eclipse_hostage_trade_hook", function(data, sender)
	local params = json.decode(data)
	local unit = get_unit_from_key(params.u_key)
	if not BaseNetworkHandler._verify_character(unit) then
		Eclipse:log_chat("Could not verify unit")
		return
	end
	Eclipse:log_chat("called hostage_trade", sender)
	CopLogicTrade.hostage_trade(unit, params.enable, params.trade_success, params.skip_hint, params.is_custody_trade)
end)
