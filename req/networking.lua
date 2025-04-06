NetworkHelper:AddReceiveHook("eclipse_hostage_trade", "eclipse_hostage_trade_hook", function(data, sender)
	if not BaseNetworkHandler._verify_character_and_sender(data.unit, sender) then
		return
	end
	CopLogicTrade.hostage_trade(data.unit, data.enable, data.trade_success, data.skip_hint, data.is_custody_trade)
end)
