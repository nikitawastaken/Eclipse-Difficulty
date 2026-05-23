-- No outlines mutator setting (hide teammate HUD panels)
Hooks:PostHook(HUDTeammate, "add_panel", "add_panel_mutator_no_outlines", function(self)
	if managers.mutators:modify_value("HUDTeammate:NoOutlines", false) then
		local teammate_panel = self._panel
		local main_player = self._main_player
		if not main_player then
			teammate_panel:set_visible(false)
		end
	end
end)

-- Leech segment count HUD display
function HUDTeammate:set_health(data)
	local prev_data = self._health_data
	self._health_data = data
	local radial_health_panel = self._radial_health_panel
	local radial_health = radial_health_panel:child("radial_health")
	local radial_rip = radial_health_panel:child("radial_rip")
	local radial_rip_bg = radial_health_panel:child("radial_rip_bg")
	local red = data.current / data.total

	if managers.player:has_activate_temporary_upgrade("temporary", "copr_ability_new") and self._id == HUDManager.PLAYER_PANEL then
		local static_damage_ratio = managers.player:body_armor_value("copr_static_damage_ratio") -- The number of Leech segments depends on the armor you're wearing

		if static_damage_ratio then
			red = math.floor((red + 0.01) / static_damage_ratio) * static_damage_ratio
		end

		local copr_overlay_panel = radial_health_panel:child("copr_overlay_panel")

		if alive(copr_overlay_panel) then
			for _, notch in ipairs(copr_overlay_panel:children()) do
				notch:set_visible(notch:script().red <= red + 0.01)
			end
		end
	end

	radial_health:stop()

	if data.current < prev_data.current then
		self:_damage_taken()
		radial_health:set_color(Color(1, red, 1, 1))

		if alive(radial_rip) then
			radial_rip:set_rotation((1 - radial_health:color().r) * 360)
			radial_rip_bg:set_rotation((1 - radial_health:color().r) * 360)
		end

		self:update_delayed_damage()
	else
		radial_health:animate(function (o)
			local s = radial_health:color().r
			local e = red
			local health_ratio = nil

			over(0.2, function (p)
				health_ratio = math.lerp(s, e, p)

				radial_health:set_color(Color(1, health_ratio, 1, 1))

				if alive(radial_rip) then
					radial_rip:set_rotation((1 - radial_health:color().r) * 360)
					radial_rip_bg:set_rotation((1 - radial_health:color().r) * 360)
				end

				self:update_delayed_damage()

				local copr_overlay_panel = radial_health_panel:child("copr_overlay_panel")

				if alive(copr_overlay_panel) then
					for _, notch in ipairs(copr_overlay_panel:children()) do
						notch:set_visible(notch:script().red <= health_ratio + 0.01)
					end
				end
			end)
		end)
	end
end

