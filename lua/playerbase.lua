-- Detection risk transparency upgrade
function PlayerBase:sync_unit_upgrades()
	if managers.player:has_category_upgrade("player", "suspicion_multiplier") then
		local mul = managers.player:upgrade_value("player", "suspicion_multiplier", 1)

		self:set_suspicion_multiplier("suspicion_multiplier", mul)
	end

	if managers.player:has_category_upgrade("player", "detection_risk_transparency") then
		local transparency_value = managers.player:transparency_value()

		local mul = (1 - (0.05 * transparency_value)) or 1

		self:set_suspicion_multiplier("suspicion_transparency_multiplier", mul)
	end

	managers.environment_controller:set_flashbang_multiplier(managers.player:upgrade_value("player", "flashbang_multiplier"))

	local pm = managers.player
	local net_sesh = managers.network:session()

	for category, upgrades in pairs(pm._global.upgrades) do
		for upgrade, level in pairs(upgrades) do
			if pm:is_upgrade_synced(category, upgrade) then
				if category == "temporary" then
					net_sesh:send_to_peers_synched("sync_temporary_upgrade_owned", category, upgrade, level, pm:temporary_upgrade_index(category, upgrade))
				else
					net_sesh:send_to_peers_synched("sync_upgrade", category, upgrade, level)
				end
			end
		end
	end
end

Hooks:PreHook(PlayerBase, "set_suspicion_multiplier", "eclipse_set_suspicion_multiplier", function(self)
	self._suspicion_settings.multipliers.strikes_used = math.lerp(1, tweak_data.player.suspicion.strikes_used_mul, managers.groupai:state():_strike_ratio())
end)