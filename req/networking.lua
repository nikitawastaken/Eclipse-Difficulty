-- For Network Hook IDs, the naming convention is as follows:
-- 1. Prefix with Eclipse_
-- 2. Follow with the class name that sends the network string
-- 3. Follow with the method in the class that sends the string
-- 4. In case a single method sends multiple strings, prefix
-- all following strings with an index
--
-- e.g. If you're sending a string from PlayerManager using
-- the function [PlayerManager.do_stuff(...)]
-- then the corresponding ID is "Eclipse_PlayerManager.do_stuff"
-- and if there is another request to send, the corresponding ID
-- would be "Eclipse_PlayerManager.do_stuff2"

---Sends networked data with a message id to the host
---@param id string @Unique name of the data to send
---@param data string @Data to send
function NetworkHelper:SendToHost(id, data)
	if self:IsClient() then
		local host_id = managers.network:session()._server_peer:id()
		self:SendToPeer(host_id, id, data)
	end
end

NetworkHelper:AddReceiveHook("Eclipse_CopLogicTrade.enter", "eclipse_hostage_trade_hook", function(data, sender)
	local params = json.decode(data)
	local unit = Eclipse.utils.get_unit_from_id(params.unit_id)
	if not unit or not alive(unit) then
		return
	end

	Eclipse:log_chat("called hostage_trade", sender)
	CopLogicTrade.hostage_trade(unit, params.enable, params.trade_success, params.skip_hint, params.is_custody_trade)
end)

NetworkHelper:AddReceiveHook("Eclipse_HuskCopBrain:on_trade", "eclipse_on_trade_hook", function(data, sender)
	local params = json.decode(data)
	local unit = Eclipse.utils.get_unit_from_id(params.unit_id)
	if not unit or not alive(unit) then
		return
	end
	if not NetworkHelper:IsHost() then
		-- How???
		return
	end

	Eclipse:log_chat("called on_trade", sender)
	unit:brain():on_trade(params.position, params.rotation, true, params.is_custody_trade)
	NetworkHelper:SendToPeers(
		"Eclipse_HuskCopBrain:on_trade2",
		json.encode({
			position = params.position,
			rotation = params.rotation,
			is_custody_trade = params.is_custody_trade,
		})
	)
end)

NetworkHelper:AddReceiveHook("Eclipse_HuskCopBrain:on_trade2", "eclipse_on_trade_hook2", function(data, sender)
	Eclipse:log_chat("called on_trade2", sender)
	if NetworkHelper:IsClient() then
		local params = json.decode(data)
		managers.trade:on_hostage_traded(params.position, params.rotation, params.is_custody_trade)
	end
end)
