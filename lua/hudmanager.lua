-- Fix rare crash with anticipation voice
local check_anticipation_voice_original = HUDManager.check_anticipation_voice
function HUDManager:check_anticipation_voice(...)
	return self._anticipation_dialogs and check_anticipation_voice_original(self, ...)
end

function HUDManager:on_ff_confirmed()
	if not managers.user:get_setting("hit_indicator") then
		return
	end

	self._hud_hit_confirm:on_ff_confirmed()
end

--bag pickup/throw sounds
function HUDManager:temp_show_carry_bag(carry_id, value)
	if self._hud_temp then
		self._hud_temp:show_carry_bag(carry_id, value)
	end

	self._sound_source:post_event("Play_bag_generic_pickup")
	self._sound_source:post_event("Play_bag_generic_pickup")
end

function HUDManager:temp_hide_carry_bag()
	if self._hud_temp then
		self._hud_temp:hide_carry_bag(carry_id, value)
	end

	self._sound_source:post_event("Play_bag_generic_throw")
	self._sound_source:post_event("Play_bag_generic_throw")
end
-- No Outlines mutator (hide name label panels)
Hooks:PostHook(HUDManager, "_update_name_labels", "_update_name_labels_mutator_no_outlines", function(self)
	if managers.mutators:modify_value("HUDManager:NoOutlines", false) then
		for _, data in ipairs(self._hud.name_labels) do
			local label_panel = data.panel
			label_panel:set_visible(false)
		end
	end
end)

-- Taser screen effect setup
Hooks:PostHook(HUDManager, "init_finalize", "init_finalize_test_effect", function(self)
    local hud = self:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
		
	self._taser_effect_panel = hud.panel:bitmap({
		name = "taser_effect_panel",
		visible = true,
		texture = "guis/textures/pd2/screen_vignette",
		layer = 0,
		color = Color(1, 1, 1),
		alpha = 0,
		blend_mode = "add",
		w = hud.panel:w(),
		h = hud.panel:h(),
		x = 0,
		y = 0 
	})
end)

-- Taser screen effect functions
function HUDManager:taser_effect_screen(duration, color)	
	if not _G.is_vr then
		self._taser_effect_panel:set_alpha(1)
		self._duration = duration
		self._taser_effect_panel:set_color(Color(color[1], color[2], color[3]))
		if self._active or stop then
			self._taser_effect_panel:stop()
		end
		self._active = true
		self._taser_effect_panel:animate(callback(self, self, "_fadeout_effect_screen"))
	end
end

function HUDManager:_fadeout_effect_screen()
	local start_time = Application:time()
	local curr_time = start_time
	while curr_time - start_time < self._duration do
		curr_time = Application:time()
		self._taser_effect_panel:set_alpha(1 - ((curr_time - start_time) / self._duration))
		coroutine.yield()
	end
	self._taser_effect_panel:set_alpha(0)
	self._active = false
end

-- OG Kingpin effect code
--[[
local ability_radial = HUDManager.set_teammate_ability_radial
function HUDManager:set_teammate_ability_radial(i, data)
	local hud = managers.hud:script( PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
	if not hud.panel:child("chico_injector_left") then
		local chico_injector_left = hud.panel:bitmap({
			name = "chico_injector_left",
			visible = false,
			texture = "guis/textures/alphawipe_test",
			layer = 0,
			color = Color(0, 0, 1),
			blend_mode = "add",
			w = hud.panel:w(),
			h = hud.panel:h(),
			x = 0,
			y = 0 
		})
	end
	local chico_injector_left = hud.panel:child("chico_injector_left")
	if i == 4 and data.current < data.total and data.current > 0 and chico_injector_left then
		chico_injector_left:set_visible(true)
		local hudinfo = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
		chico_injector_left:animate(hudinfo.flash_icon, 1000000)
	elseif hud.panel:child("chico_injector_left") then
		chico_injector_left:stop()
		chico_injector_left:set_visible(false)
	end
	if chico_injector_left and data.current == 0 then
		chico_injector_left:set_visible(false)
	end
	return ability_radial(self, i, data)
end
--]]