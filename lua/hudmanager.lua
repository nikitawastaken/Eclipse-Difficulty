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