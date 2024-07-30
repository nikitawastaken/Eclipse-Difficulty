Hooks:OverrideFunction(CopSound, "init", function(self, unit)
	self._speak_done_callback = function()
		self._speak_expire_t = 0
	end

	self._unit = unit
	self._speak_expire_t = 0
	local char_tweak = tweak_data.character[unit:base()._tweak_table]

	self:set_voice_prefix(nil)

	local nr_variations = char_tweak.speech_prefix_count
	self._prefix = (char_tweak.speech_prefix_p1 or "") .. (nr_variations and tostring(math.random(nr_variations)) or "") .. (char_tweak.speech_prefix_p2 or "") .. "_"

	if self._unit:base():char_tweak().spawn_sound_event then
		self._unit:sound():play(self._unit:base():char_tweak().spawn_sound_event, nil, nil)
	end

	--Mostly just here in the event we have a unit to have both an 'entrance' line *and* a global spawn in noise
	if self._unit:base():char_tweak().spawn_sound_event_2 then
		self._unit:sound():play(self._unit:base():char_tweak().spawn_sound_event_2, nil, nil)
	end

	unit:base():post_init()
end)

Hooks:OverrideFunction(CopSound, "say", function(self, sound_name, sync, skip_prefix)
	if self._last_speech then
		self._last_speech:stop()
	end

	local event_id = nil
	local full_sound = skip_prefix and sound_name or self._prefix .. sound_name
	if type(full_sound) == "number" then
		event_id = full_sound
		full_sound = nil
	end

	if sync then
		event_id = event_id or SoundDevice:string_to_id(full_sound)
		self._unit:network():send("say", event_id)
	end

	self._last_speech = self:_play(full_sound or event_id, nil, self._speak_done_callback)
	self._speak_expire_t = self._last_speech and TimerManager:game():time() + 10 or 0
end)
