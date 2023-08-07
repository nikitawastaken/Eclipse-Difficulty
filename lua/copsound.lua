-- Make CopSound return accurate speaking times
function CopSound:speak_done_callback(instance, event_type, unit, sound_source, label, identifier, position)
	if alive(unit) then
		unit:sound()._speak_expire_t = 0
	end
end

function CopSound:say(sound_name, sync, skip_prefix, important, callback)
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

	self._last_speech = self:_play(full_sound or event_id, nil, self.speak_done_callback)
	if self._last_speech then
		self._speak_expire_t = TimerManager:game():time() + 8
	end
end