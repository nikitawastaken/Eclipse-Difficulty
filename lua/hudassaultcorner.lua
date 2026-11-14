local is_eclipse = Eclipse.utils.is_eclipse()

local faction = Eclipse.utils.faction
local has_ponr_text = Eclipse.settings.ponr_assault_text
local has_faction_text = Eclipse.settings.faction_assault_text

Hooks:PostHook(HUDAssaultCorner, "init", "eclipse_assault_corner_init", function(self)
	self._ponr_state = false

	-- Disable assault panel color override when mutators are active
	self._assault_mode = "normal"
	self._assault_color = Color(1, 1, 1, 0)
	self._vip_assault_color = Color(1, 1, 0.5019607843137255, 0) -- Just in case
end)

function HUDAssaultCorner:set_ponr_state()
	self._ponr_state = true
end

function HUDAssaultCorner:_get_assault_strings()
	local is_ponr = managers.groupai:state_name() == "ponr" or self._ponr_state

	local primary_assault_text = has_faction_text and "hud_assault_" .. faction() .. "_assault" or "hud_assault_assault"
	local secondary_assault_text = has_ponr_text and is_ponr and "hud_assault_ponr" or primary_assault_text

	if self._assault_mode == "normal" then
		if managers.job:current_difficulty_stars() > 0 or is_ponr then
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

	function HUDAssaultCorner:_animate_text(text_panel, bg_box, color, color_function)
		local text_list = (bg_box or self._bg_box):script().text_list
		local text_index = 0
		local texts = {}
		local padding = 10

		local function create_new_text(text_panel, text_list, text_index, texts)
			if texts[text_index] and texts[text_index].text then
				text_panel:remove(texts[text_index].text)

				texts[text_index] = nil
			end

			local text_id = text_list[text_index]
			local text_string = ""
			local is_ponr = managers.groupai:state_name() == "ponr" or self._ponr_state

			if type(text_id) == "string" then
				text_string = managers.localization:to_upper_text(text_id)
			elseif text_id == Idstring("risk") then
				local use_stars = true

				if managers.crime_spree:is_active() then
					text_string = text_string .. managers.localization:to_upper_text("menu_cs_level", {
						level = managers.experience:cash_string(managers.crime_spree:server_spree_level(), "")
					})
					use_stars = false
				end

				if use_stars then
					for i = 1, managers.job:current_difficulty_stars() do
						text_string = text_string .. managers.localization:get_default_macro("BTN_SKULL")
					end

					-- Add one extra skull if the Full Force Onslaught is active
					if is_ponr then
						text_string = text_string .. managers.localization:get_default_macro("BTN_SKULL")
					end
				end
			end

			local mod_color = color_function and color_function() or color or self._assault_color
			local text = text_panel:text({
				align = "center",
				blend_mode = "add",
				h = 10,
				layer = 1,
				vertical = "center",
				w = 10,
				text = text_string,
				color = mod_color,
				font_size = tweak_data.hud_corner.assault_size,
				font = tweak_data.hud_corner.assault_font
			})
			local _, _, w, h = text:text_rect()

			text:set_size(w, h)

			texts[text_index] = {
				x = text_panel:w() + w * 0.5 + padding * 2,
				text = text
			}
		end

		while true do
			local dt = coroutine.yield()
			local last_text = texts[text_index]

			if last_text and last_text.text then
				if last_text.x + last_text.text:w() * 0.5 + padding < text_panel:w() then
					text_index = text_index % #text_list + 1

					create_new_text(text_panel, text_list, text_index, texts)
				end
			else
				text_index = text_index % #text_list + 1

				create_new_text(text_panel, text_list, text_index, texts)
			end

			local speed = 90

			for i, data in pairs(texts) do
				if data.text then
					data.x = data.x - dt * speed

					data.text:set_center_x(data.x)
					data.text:set_center_y(text_panel:h() * 0.5)

					if data.x + data.text:w() * 0.5 < 0 then
						text_panel:remove(data.text)

						data.text = nil
					elseif color_function then
						data.text:set_color(color_function())
					end
				end
			end
		end
	end
end