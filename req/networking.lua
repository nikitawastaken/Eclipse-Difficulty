NetworkHelper:AddReceiveHook("eclipse_hostage_trade", "eclipse_hostage_trade_hook", function(data, sender)
	local params = json.decode(data)
	if not BaseNetworkHandler._verify_character_and_sender(params.unit, sender) then
		return
	end
	CopLogicTrade.hostage_trade(params.unit, params.enable, params.trade_success, params.skip_hint, params.is_custody_trade)
end)
