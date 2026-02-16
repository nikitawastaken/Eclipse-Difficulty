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

function PlayerBase:set_suspicion_multiplier(reason, multiplier)
	self._suspicion_settings.multipliers[reason] = multiplier
	local buildup_mul = self._suspicion_settings.init_buildup_mul
	local range_mul = self._suspicion_settings.init_range_mul

	for reason, mul in pairs(self._suspicion_settings.multipliers) do
		buildup_mul = buildup_mul * mul

		if mul > 1 then
			range_mul = range_mul * math.sqrt(mul)
		end
	end

	self._suspicion_settings.buildup_mul = buildup_mul
	self._suspicion_settings.range_mul = range_mul

	Eclipse:log_chat(
		"PlayerBase: Set suspicion multiplier for reason '" .. reason .. "' to " .. (multiplier or "nil") .. ". New buildup multiplier is " .. buildup_mul .. " and new range multiplier is " .. range_mul
	)
end
