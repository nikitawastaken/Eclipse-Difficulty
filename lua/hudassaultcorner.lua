Hooks:PostHook(HUDAssaultCorner, "init", "eclipse_assault_corner_init", function(self)
	self._ponr_state = false
end)

function HUDAssaultCorner:set_ponr_state()
	self._ponr_state = true
end

if Eclipse.settings.ponr_assault_text then
	function HUDAssaultCorner:sync_start_assault(assault_number)
		if self._point_of_no_return or self._casing then
			return
		end

		local color = self._assault_color
		local diff_i = tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or "normal")

		if managers.groupai:state_name() == "ponr" or self._ponr_state then
			if diff_i == 6 then
				color = Color.red
			else
				color = self._vip_assault_color
			end
		end

		if self._assault_mode == "phalanx" then
			color = self._vip_assault_color
		end

		self:_update_assault_hud_color(color)
		self:set_assault_wave_number(assault_number)

		self._start_assault_after_hostage_offset = true

		self:_set_hostage_offseted(true)
	end

	function HUDAssaultCorner:_get_assault_strings()
		local diff_i = tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or "normal")

		if self._assault_mode == "normal" then
			if managers.job:current_difficulty_stars() > 0 then
				local ids_risk = Idstring("risk")

				if managers.groupai:state_name() == "ponr" or self._ponr_state then
					if diff_i == 6 then
						return {
							"hud_assault_ponr",
							"hud_assault_end_line",
							ids_risk,
							"hud_assault_end_line",
							"hud_assault_zeal_ponr",
							"hud_assault_end_line",
							ids_risk,
							"hud_assault_end_line",
						}
					else
						return {
							"hud_assault_ponr",
							"hud_assault_end_line",
							ids_risk,
							"hud_assault_end_line",
							"hud_assault_normal_ponr",
							"hud_assault_end_line",
							ids_risk,
							"hud_assault_end_line",
						}
					end
				else
					return {
						"hud_assault_assault",
						"hud_assault_end_line",
						ids_risk,
						"hud_assault_end_line",
						"hud_assault_assault",
						"hud_assault_end_line",
						ids_risk,
						"hud_assault_end_line",
					}
				end
			else
				if managers.groupai:state_name() == "ponr" or self._ponr_state then
					return {
						"hud_assault_ponr",
						"hud_assault_end_line",
						"hud_assault_normal_ponr",
						"hud_assault_end_line",
					}
				else
					return {
						"hud_assault_assault",
						"hud_assault_end_line",
						"hud_assault_assault",
						"hud_assault_end_line",
						"hud_assault_assault",
						"hud_assault_end_line",
					}
				end
			end
		end
	end
end
