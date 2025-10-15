local is_eclipse = Eclipse.utils.is_eclipse()

local faction = Eclipse.utils.faction
local has_ponr_text = Eclipse.settings.ponr_assault_text
local has_faction_text = Eclipse.settings.faction_assault_text

Hooks:PostHook(HUDAssaultCorner, "init", "eclipse_assault_corner_init", function(self)
	self._ponr_state = false
end)

function HUDAssaultCorner:set_ponr_state()
	self._ponr_state = true
end

function HUDAssaultCorner:_get_assault_strings()
	local is_ponr = managers.groupai:state_name() == "ponr" or self._ponr_state

	local primary_assault_text = has_faction_text and "hud_assault_" .. faction() .. "_assault" or "hud_assault_assault"
	local secondary_assault_text = has_ponr_text and is_ponr and "hud_assault_ponr" or primary_assault_text

	if self._assault_mode == "normal" then
		if managers.job:current_difficulty_stars() > 0 then
			local ids_risk = Idstring("risk")

			return {
				secondary_assault_text,
				"hud_assault_end_line",
				ids_risk,
				"hud_assault_end_line",
				primary_assault_text,
				"hud_assault_end_line",
				ids_risk,
				"hud_assault_end_line",
			}
		else
			return {
				secondary_assault_text,
				"hud_assault_end_line",
				primary_assault_text,
				"hud_assault_end_line",
				primary_assault_text,
				"hud_assault_end_line",
			}
		end
	end

	if self._assault_mode == "phalanx" then
		if managers.job:current_difficulty_stars() > 0 then
			local ids_risk = Idstring("risk")

			return {
				"hud_assault_vip",
				"hud_assault_padlock",
				ids_risk,
				"hud_assault_padlock",
				"hud_assault_vip",
				"hud_assault_padlock",
				ids_risk,
				"hud_assault_padlock",
			}
		else
			return {
				"hud_assault_vip",
				"hud_assault_padlock",
				"hud_assault_vip",
				"hud_assault_padlock",
				"hud_assault_vip",
				"hud_assault_padlock",
			}
		end
	end
end

if has_ponr_text then
	function HUDAssaultCorner:sync_start_assault(assault_number)
		local is_ponr = managers.groupai:state_name() == "ponr" or self._ponr_state

		if self._point_of_no_return or self._casing then
			return
		end

		local color = self._assault_color

		if is_ponr then
			if is_eclipse then
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
end
