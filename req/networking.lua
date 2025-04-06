local function get_unit_from_id(unit_id)
	for _, data in pairs(managers.enemy:all_enemies()) do
		if data.unit:id() == unit_id then
			return data.unit
		end
	end
	for _, data in pairs(managers.enemy:all_civilians()) do
		if data.unit:id() == unit_id then
			return data.unit
		end
	end

	return false
end

NetworkHelper:AddReceiveHook("eclipse_hostage_trade", "eclipse_hostage_trade_hook", function(data, sender)
	local params = json.decode(data)
	local unit = get_unit_from_id(params.unit_id)
	if not BaseNetworkHandler._verify_character(unit) then
		return
	end
	Eclipse:log_chat("called hostage_trade", sender)
	CopLogicTrade.hostage_trade(unit, params.enable, params.trade_success, params.skip_hint, params.is_custody_trade)
end)
