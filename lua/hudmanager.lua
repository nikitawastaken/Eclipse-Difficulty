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

-- Various screen effects setup
Hooks:PostHook(HUDManager, "init_finalize", "init_finalize_vignette_screen_effect", function(self)
    local hud = self:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
		
	self._screen_vignette_panel = hud.panel:bitmap({
		name = "screen_vignette_panel",
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
	self._screen_vignette_reversed_panel = hud.panel:bitmap({
        name = "screen_vignette_reversed_panel",
        visible = true,
        texture = "guis/textures/pd2/screen_vignette_reversed",
        layer = 1,
        color = Color(0.5, 0.5, 0.5),
        alpha = 0,
        blend_mode = "add",
        w = hud.panel:w(),
        h = hud.panel:h(),
        x = 0,
        y = 0 
    })
	self._screen_vignette_friendly_fire_panel = hud.panel:bitmap({
		name = "screen_vignette_friendly_fire",
		visible = true,
		texture = "guis/textures/pd2/screen_vignette",
		layer = 2,
		color = Color(1, 1, 1),
		alpha = 0,
		blend_mode = "add",
		w = hud.panel:w(),
		h = hud.panel:h(),
		x = 0,
		y = 0 
	})
end)

-- Screen effect functions
-- Helper function
function HUDManager:effect_screen(duration, color, effect_name)
	if effect_name == nil then
		effect_name = "screen_vignette"
	end
		
	if effect_name == "screen_vignette" then
		self:_do_effect_screen_vignette_panel(duration, color)
	elseif effect_name == "screen_vignette_reversed" then
		self:_do_effect_screen_vignette_reversed_panel(duration, color)
	elseif effect_name == "screen_vignette_friendly_fire" then
		self:_do_effect_screen_vignette_friendly_fire_panel(duration, color)
	end
end

-- Functions that do effect related stuff
function HUDManager:_do_effect_screen_vignette_panel(duration, color)	
	if not _G.is_vr then
		self._screen_vignette_panel:set_alpha(1)
		self._screen_vignette_panel_duration = duration
		self._screen_vignette_panel:set_color(Color(color[1], color[2], color[3]))
		if self._screen_vignette_panel_active then
			self._screen_vignette_panel:stop()
		end
		self._screen_vignette_panel_active = true
		self._screen_vignette_panel:animate(callback(self, self, "_fadeout_effect_screen_vignette_panel"))
	end
end

function HUDManager:_fadeout_effect_screen_vignette_panel()
	local start_time = Application:time()
	local curr_time = start_time
	while curr_time - start_time < self._screen_vignette_panel_duration do
		curr_time = Application:time()
		self._screen_vignette_panel:set_alpha(1 - ((curr_time - start_time) / self._screen_vignette_panel_duration))
		coroutine.yield()
	end
	self._screen_vignette_panel:set_alpha(0)
	self._screen_vignette_panel_active = false
end


function HUDManager:_do_effect_screen_vignette_reversed_panel(duration, color)	
	if not _G.is_vr then
		self._screen_vignette_reversed_panel:set_alpha(1)
		self._screen_vignette_reversed_panel_duration = duration
		self._screen_vignette_reversed_panel:set_color(Color(color[1], color[2], color[3]))
		if self._screen_vignette_reversed_panel_active then
			self._screen_vignette_reversed_panel:stop()
		end
		self._screen_vignette_reversed_panel_active = true
		self._screen_vignette_reversed_panel:animate(callback(self, self, "_fadeout_effect_screen_vignette_reversed_panel_duration"))
	end
end

function HUDManager:_fadeout_effect_screen_vignette_reversed_panel_duration()
	local start_time = Application:time()
	local curr_time = start_time
	while curr_time - start_time < self._screen_vignette_reversed_panel_duration do
		curr_time = Application:time()
		self._screen_vignette_reversed_panel:set_alpha(1 - ((curr_time - start_time) / self._screen_vignette_reversed_panel_duration))
		coroutine.yield()
	end
	self._screen_vignette_reversed_panel:set_alpha(0)
	self._screen_vignette_panel_active = false
end

function HUDManager:_do_effect_screen_vignette_friendly_fire_panel(duration, color)	
	if not _G.is_vr then
		self._screen_vignette_friendly_fire_panel:set_alpha(1)
		self._screen_vignette_friendly_fire_panel_duration = duration
		self._screen_vignette_friendly_fire_panel:set_color(Color(color[1], color[2], color[3]))
		if self._screen_vignette_friendly_fire_panel_active then
			self._screen_vignette_friendly_fire_panel:stop()
		end
		self._screen_vignette_friendly_fire_panel_active = true
		self._screen_vignette_friendly_fire_panel:animate(callback(self, self, "_fadeout_effect_screen_vignette_friendly_fire_panel"))
	end
end

function HUDManager:_fadeout_effect_screen_vignette_friendly_fire_panel()
	local start_time = Application:time()
	local curr_time = start_time
	while curr_time - start_time < self._screen_vignette_friendly_fire_panel_duration do
		curr_time = Application:time()
		self._screen_vignette_friendly_fire_panel:set_alpha(1 - ((curr_time - start_time) / self._screen_vignette_friendly_fire_panel_duration))
		coroutine.yield()
	end
	self._screen_vignette_friendly_fire_panel:set_alpha(0)
	self._screen_vignette_friendly_fire_panel_active = false
end