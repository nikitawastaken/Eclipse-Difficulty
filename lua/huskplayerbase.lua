function HuskPlayerBase:get_value_from_risk_upgrade(risk_upgrade, detection_risk)
	local risk_value = 0

	if not detection_risk then
		if not self._suspicion_settings.hud_offset then
			self._suspicion_settings.hud_offset = managers.blackmarket:get_suspicion_offset_of_peer(peer, tweak_data.player.SUSPICION_OFFSET_LERP or 0.75)
		end

		detection_risk = math.round(self._suspicion_settings.hud_offset * 100)
	end

	if risk_upgrade and type(risk_upgrade) == "table" then
		local value = risk_upgrade[1]
		local step = risk_upgrade[2]
		local operator = risk_upgrade[3]
		local threshold = risk_upgrade[4]
		local cap = risk_upgrade[5]
		local num_steps = 0

		if operator == "above" then
			num_steps = math.max(math.floor((detection_risk - threshold) / step), 0)
		elseif operator == "below" then
			num_steps = math.max(math.floor((threshold - detection_risk) / step), 0)
		end

		risk_value = num_steps * value

		if cap then
			risk_value = math.min(cap, risk_value) or risk_value
		end
	end

	return risk_value
end
