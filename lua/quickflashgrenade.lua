local diff_i = Eclipse.utils.difficulty_index()

-- disable the beeping sound of the flashbang grenade if the difficulty is overkill or higher
function QuickFlashGrenade:_beep()
	if diff_i >= 5 then
		return
	end

	self._unit:sound_source():post_event("pfn_beep")

	self._beep_t = self:_get_next_beep_time()
	self._light_multiplier = self._beep_mul
end
