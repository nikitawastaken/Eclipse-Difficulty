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
function HUDManager:temp_show_carry_bag( carry_id, value )
	self._hud_temp:show_carry_bag( carry_id, value )
	self._sound_source:post_event( "Play_bag_generic_pickup" )
	self._sound_source:post_event( "Play_bag_generic_pickup" )
end

function HUDManager:temp_hide_carry_bag()
	self._hud_temp:hide_carry_bag()
	self._sound_source:post_event( "Play_bag_generic_throw" )
	self._sound_source:post_event( "Play_bag_generic_throw" )
end