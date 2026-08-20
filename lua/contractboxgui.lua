local function make_fine_text(text)
	local x, y, w, h = text:text_rect()

	if text:wrap() == true then
		text:set_h(h)
	else
		text:set_size(w, h)
	end

	text:set_position(math.round(text:x()), math.round(text:y()))
end

local data = ContractBoxGui.create_contract_box
function ContractBoxGui:create_contract_box()
	data(self)
	
	local job_id = managers.job:current_job_id()
	if managers.job:current_contact_data() and not self._contract_panel:child("paygrade_text_header") and job_id ~= "chill" then
		self._contract_panel:set_h(self._contract_panel:h() + 20)
		self._contract_panel:set_rightbottom(self._panel:w() - 0, self._panel:h() - 60)
		
		for i = 1, self._contract_panel:num_children() - 2 do
			self._contract_panel:child(i):set_y(self._contract_panel:child(i):y() + 20)
		end
			
		local difficulty_header = self._contract_panel:child(2)
		local paygrade_text_header = self._contract_panel:text({
			name = "paygrade_text_header",
			text = managers.localization:to_upper_text("cn_menu_contract_paygrade_header"),
			font_size = tweak_data.menu.pd2_small_font_size,
			font = tweak_data.menu.pd2_small_font,
			color = tweak_data.screen_colors.text
		})
		make_fine_text(paygrade_text_header)
		paygrade_text_header:set_rightbottom(difficulty_header:right() - 2, difficulty_header:top())

		local cy = paygrade_text_header:center_y()
		local sx = paygrade_text_header:right() + 5
	
		for i = 1, 15 do
			local x = sx + (i - 1) * 18
			local star_data = { 
				texture = "guis/textures/pd2/mission_briefing/difficulty_icons", 
				texture_rect = {0, 33, 32, 32}, 
				w = 16, 
				h = 16,
				alpha = 1 
			}

			local star = self._contract_panel:bitmap(star_data)
			star:set_color(managers.crimenet:stars_color(i, managers.job:current_job_stars(), managers.job:current_difficulty_stars()))
			star:set_x(x)
			star:set_center_y(math.round(cy))
		end
		
		if alive(self._contract_text_header) then
			self._contract_text_header:set_bottom(self._contract_panel:top())
		end
	end
end
