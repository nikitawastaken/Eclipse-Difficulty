function NetworkPeer:verify_bag(carry_id, pickup)
	if pickup then
		self._carry_id = self._carry_id or {}
		self._carry_id[carry_id] = self._carry_id[carry_id] and self._carry_id[carry_id] + 1 or 1
		return true
	elseif self._carry_id and self._carry_id[carry_id] > 0 then
		self._carry_id[carry_id] = self._carry_id[carry_id] - 1
		return true
	end
	for k, v in pairs(self._carry_id) do
		Eclipse:log_chat(tostring(k), tostring(v))
	end

	if Network:is_client() and not pickup and not self._skipped_first_cheat then
		self._skipped_first_cheat = true

		return true
	end

	if Network:is_server() then
		self:mark_cheater(not pickup and VoteManager.REASON.many_bags or VoteManager.REASON.many_bags_pickup, true)
	else
		managers.network:session():server_peer():mark_cheater(not pickup and VoteManager.REASON.many_bags or VoteManager.REASON.many_bags_pickup, Network:is_server())
	end

	return false
end

Hooks:PostHook(NetworkPeer, "mark_cheater", "eclipse_mark_cheater_debug", function()
	Eclipse:log_chat("[DEBUG] You were marked as cheater!\nSend the stacktrace from your log file to a developer and see if you can reproduce this so we can patch this out.")
	log("[ECLIPSE ANTI-CHEAT DEBUG]:\n", debug.traceback(), "\nEND STACKTRACE\n\n")
end)
