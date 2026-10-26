local massive_font = tweak_data.menu.pd2_massive_font
local large_font = tweak_data.menu.pd2_large_font
local medium_font = tweak_data.menu.pd2_medium_font
local small_font = tweak_data.menu.pd2_small_font
local tiny_font = tweak_data.menu.pd2_tiny_font
local massive_font_size = tweak_data.menu.pd2_massive_font_size
local large_font_size = tweak_data.menu.pd2_large_font_size
local medium_font_size = tweak_data.menu.pd2_medium_font_size
local small_font_size = tweak_data.menu.pd2_small_font_size
local tiny_font_size = tweak_data.menu.pd2_tiny_font_size

-- Fix for Pro Job text not being red when you press Tab
function HUDStatsScreen:recreate_left()
	self._left:clear()
	self._left:bitmap({
		layer = -1,
		render_template = "VertexColorTexturedBlur3D",
		texture = "guis/textures/test_blur_df",
		valign = "grow",
		w = self._left:w(),
		h = self._left:h()
	})

	local lb = HUDBGBox_create(self._left, {}, {
		blend_mode = "normal",
		color = Color.white
	})

	lb:child("bg"):set_color(Color(0, 0, 0):with_alpha(0.75))
	lb:child("bg"):set_alpha(1)

	local placer = UiPlacer:new(10, 10, 0, 8)
	local job_data = managers.job:current_job_data()
	local stage_data = managers.job:current_stage_data()

	if job_data and managers.job:current_job_id() == "safehouse" and Global.mission_manager.saved_job_values.playedSafeHouseBefore then
		self._left:set_visible(false)

		return
	end

	local is_whisper_mode = managers.groupai and managers.groupai:state():whisper_mode()

	if stage_data then
		if managers.crime_spree:is_active() then
			local level_data = managers.job:current_level_data()
			local mission = managers.crime_spree:get_mission(managers.crime_spree:current_played_mission())

			if mission then
				local level_str = managers.localization:to_upper_text(tweak_data.levels[mission.level.level_id].name_id) or ""

				placer:add_row(self._left:fine_text({
					font = large_font,
					font_size = tweak_data.hud_stats.objectives_title_size,
					text = level_str
				}))
			end

			placer:add_row(self._left:fine_text({
				font = medium_font,
				font_size = tweak_data.hud_stats.loot_size,
				text = managers.localization:to_upper_text("menu_lobby_difficulty_title"),
				color = tweak_data.screen_colors.text
			}), 8, 0)

			local str = managers.localization:text("menu_cs_level", {
				level = managers.experience:cash_string(managers.crime_spree:server_spree_level(), "")
			})

			placer:add_right(self._left:fine_text({
				font = medium_font,
				font_size = tweak_data.hud_stats.loot_size,
				text = str,
				color = tweak_data.screen_colors.crime_spree_risk
			}))
		else
			local job_chain = managers.job:current_job_chain_data()
			local day = managers.job:current_stage()
			local days = job_chain and #job_chain or 0
			local day_title = placer:add_bottom(self._left:fine_text({
				font = tweak_data.hud_stats.objectives_font,
				font_size = tweak_data.hud_stats.loot_size,
				text = managers.localization:to_upper_text("hud_days_title", {
					DAY = day,
					DAYS = days
				})
			}))

			if managers.job:is_level_ghostable(managers.job:current_level_id()) then
				local ghost_color = is_whisper_mode and Color.white or tweak_data.screen_colors.important_1
				local ghost = placer:add_right(self._left:bitmap({
					blend_mode = "add",
					h = 16,
					name = "ghost_icon",
					texture = "guis/textures/pd2/cn_minighost",
					w = 16,
					color = ghost_color
				}))

				ghost:set_center_y(day_title:center_y())
			end

			placer:new_row(8)

			local level_data = managers.job:current_level_data()

			if level_data then
				placer:add_bottom(self._left:fine_text({
					font = large_font,
					font_size = tweak_data.hud_stats.objectives_title_size,
					text = managers.localization:to_upper_text(level_data.name_id)
				}))
			end

			placer:add_bottom(self._left:fine_text({
				font = medium_font,
				font_size = tweak_data.hud_stats.loot_size,
				text = managers.localization:to_upper_text("menu_lobby_difficulty_title"),
				color = tweak_data.screen_colors.text
			}), 0)

			if job_data then
				local job_stars = managers.job:current_job_stars()
				local difficulty_stars = managers.job:current_difficulty_stars()
				local difficulty = tweak_data.difficulties[difficulty_stars + 2] or 1
				local difficulty_string = managers.localization:to_upper_text(tweak_data.difficulty_name_ids[difficulty])
				local difficulty_text = self._left:fine_text({
					font = medium_font,
					font_size = tweak_data.hud_stats.loot_size,
					text = difficulty_string,
					color = difficulty_stars > 0 and tweak_data.screen_colors.risk or tweak_data.screen_colors.text
				})

				if Global.game_settings.one_down then
					local one_down_string = managers.localization:to_upper_text("menu_one_down")
					local text_string = difficulty_string .. " " .. one_down_string

					difficulty_text:set_text(text_string)
					difficulty_text:set_range_color(utf8.len(difficulty_string) + 1, utf8.len(text_string), tweak_data.screen_colors.one_down)
				end

				do
					local _, _, tw, th = difficulty_text:text_rect()

					difficulty_text:set_size(tw, th)
				end

				placer:add_right(difficulty_text)
			end

			placer:new_row(8, 0)

			local payout = managers.localization:text("hud_day_payout", {
				MONEY = managers.experience:cash_string(managers.money:get_potential_payout_from_current_stage())
			})

			placer:add_bottom(self._left:fine_text({
				keep_w = true,
				font = tweak_data.hud_stats.objectives_font,
				font_size = tweak_data.hud_stats.loot_size,
				text = payout
			}), 0)
		end

		placer:new_row()
	end

	placer:add_bottom(self._left:fine_text({
		align = "left",
		vertical = "top",
		font_size = tweak_data.hud_stats.objectives_title_size,
		font = tweak_data.hud_stats.objectives_font,
		text = managers.localization:to_upper_text("hud_objective")
	}), 16)
	placer:new_row(8)

	local row_w = self._left:w() - placer:current_left() * 2

	for i, data in pairs(managers.objectives:get_active_objectives()) do
		placer:add_bottom(self._left:fine_text({
			align = "left",
			word_wrap = true,
			wrap = true,
			text = utf8.to_upper(data.text),
			font = tweak_data.hud.medium_font,
			font_size = tweak_data.hud.active_objective_title_font_size,
			w = row_w
		}))
		placer:add_bottom(self._left:fine_text({
			align = "left",
			font_size = 24,
			word_wrap = true,
			wrap = true,
			text = data.description,
			font = tweak_data.hud_stats.objective_desc_font,
			w = row_w
		}), 0)
	end

	local loot_panel = ExtendedPanel:new(self._left, {
		w = self._left:w() - 16 - 8
	})

	placer = UiPlacer:new(16, 0, 8, 4)

	if not is_whisper_mode and managers.player:has_category_upgrade("player", "convert_enemies") then
		local minion_text = placer:add_bottom(loot_panel:fine_text({
			keep_w = true,
			text = managers.localization:text("hud_stats_enemies_converted"),
			font = medium_font,
			font_size = medium_font_size
		}))

		placer:add_right(nil, 0)

		local minion_texture, minion_rect = tweak_data.hud_icons:get_icon_data("minions_converted")
		local minion_icon = placer:add_left(loot_panel:fit_bitmap({
			h = 17,
			w = 17,
			texture = minion_texture,
			texture_rect = minion_rect
		}))

		minion_icon:set_center_y(minion_text:center_y())
		placer:add_left(loot_panel:fine_text({
			text = tostring(managers.player:num_local_minions()),
			font = medium_font,
			font_size = medium_font_size
		}), 7)
		placer:new_row()
	end

	if is_whisper_mode then
		local pagers_used = managers.groupai:state():get_nr_successful_alarm_pager_bluffs()
		local max_pagers_data = managers.player:has_category_upgrade("player", "corpse_alarm_pager_bluff") and tweak_data.player.alarm_pager.bluff_success_chance_w_skill or tweak_data.player.alarm_pager.bluff_success_chance
		local max_num_pagers = #max_pagers_data

		for i, chance in ipairs(max_pagers_data) do
			if chance == 0 then
				max_num_pagers = i - 1

				break
			end
		end

		local pagers_text = placer:add_bottom(loot_panel:fine_text({
			keep_w = true,
			text = managers.localization:text("hud_stats_pagers_used"),
			font = medium_font,
			font_size = medium_font_size
		}))

		placer:add_right(nil, 0)

		local pagers_texture, pagers_rect = tweak_data.hud_icons:get_icon_data("pagers_used")
		local pagers_icon = placer:add_left(loot_panel:fit_bitmap({
			h = 17,
			w = 17,
			texture = pagers_texture,
			texture_rect = pagers_rect
		}))

		pagers_icon:set_center_y(pagers_text:center_y())
		placer:add_left(loot_panel:fine_text({
			text = tostring(pagers_used) .. "/" .. tostring(max_num_pagers),
			font = medium_font,
			font_size = medium_font_size
		}), 7)
		placer:new_row()
	end

	local mandatory_bags_data = managers.loot:get_mandatory_bags_data()
	local mandatory_amount = mandatory_bags_data and mandatory_bags_data.amount
	local secured_amount = managers.loot:get_secured_mandatory_bags_amount()
	local bonus_amount = managers.loot:get_secured_bonus_bags_amount()
	local bag_text = placer:add_bottom(loot_panel:fine_text({
		keep_w = true,
		text = managers.localization:text("hud_stats_bags_secured"),
		font = medium_font,
		font_size = medium_font_size
	}))

	placer:add_right(nil, 0)

	local bag_texture, bag_rect = tweak_data.hud_icons:get_icon_data("bag_icon")
	local bag_icon = placer:add_left(loot_panel:fit_bitmap({
		h = 16,
		w = 16,
		texture = bag_texture,
		texture_rect = bag_rect
	}))

	bag_icon:set_center_y(bag_text:center_y())

	if mandatory_amount and mandatory_amount > 0 then
		local str = bonus_amount > 0 and string.format("%d/%d+%d", secured_amount, mandatory_amount, bonus_amount) or string.format("%d/%d", secured_amount, mandatory_amount)

		placer:add_left(loot_panel:fine_text({
			text = str,
			font = medium_font,
			font_size = medium_font_size
		}))
	else
		placer:add_left(loot_panel:fine_text({
			text = tostring(bonus_amount),
			font = medium_font,
			font_size = medium_font_size
		}))
	end

	placer:new_row()

	local body_text = placer:add_bottom(loot_panel:fine_text({
		keep_w = true,
		text = managers.localization:to_upper_text("hud_body_bags"),
		font = medium_font,
		font_size = medium_font_size
	}))

	placer:add_right(nil, 0)

	local body_texture, body_rect = tweak_data.hud_icons:get_icon_data("equipment_body_bag")
	local body_icon = placer:add_left(loot_panel:fit_bitmap({
		h = 17,
		w = 17,
		texture = body_texture,
		texture_rect = body_rect
	}))

	body_icon:set_center_y(body_text:center_y())
	placer:add_left(loot_panel:fine_text({
		text = tostring(managers.player:get_body_bags_amount()),
		font = medium_font,
		font_size = medium_font_size
	}), 7)
	placer:new_row()

	local secured_bags_money = managers.experience:cash_string(managers.money:get_secured_mandatory_bags_money() + managers.money:get_secured_bonus_bags_money())

	placer:add_bottom(loot_panel:fine_text({
		keep_w = true,
		text_id = "hud_stats_bags_secured_value",
		font = medium_font,
		font_size = medium_font_size
	}), 12)
	placer:add_right(nil, 0)
	placer:add_left(loot_panel:fine_text({
		text = secured_bags_money,
		font = medium_font,
		font_size = medium_font_size
	}))
	placer:new_row()

	local instant_cash = managers.experience:cash_string(managers.loot:get_real_total_small_loot_value())

	placer:add_bottom(loot_panel:fine_text({
		keep_w = true,
		text = managers.localization:to_upper_text("hud_instant_cash"),
		font = medium_font,
		font_size = medium_font_size
	}))
	placer:add_right(nil, 0)
	placer:add_left(loot_panel:fine_text({
		text = instant_cash,
		font = medium_font,
		font_size = medium_font_size
	}))
	loot_panel:set_size(placer:most_rightbottom())
	loot_panel:set_leftbottom(0, self._left:h() - 16)
end
