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

	-- fix l5d having missing quotes
	if self._prefix == "l5d_" then
		if sound_name == "c01" or sound_name == "att" then
			sound_name = "g90"
		elseif sound_name == "rrl" then
			sound_name = "pus"
		elseif sound_name == "t01" then
			sound_name = "prm"
		elseif sound_name == "h01" then
			sound_name = "h10"
		end
	end

	local l5n_missing_police_calls = {
		"l5n_a09",
		"l5n_a23",
	}
	local l5n_contact_lines = {
		"Play_l5n_i01_con",
		"Play_l5n_g90",
	}
	local l5n_alert = {
		"Play_l5n_lk3_con",
		"l5n_a08",
	}

	-- restore the entire l5n voiceset
	if self._prefix == "l5n_" then
		if sound_name == "c01" or sound_name == "att" then
			full_sound = l5n_contact_lines[math.random(#l5n_contact_lines)] -- use i01 and g90 as contact since l5n doesn't have any
		end
		if sound_name == "rdy" then
			full_sound = "Play_l5n_rdy"
		end
		if sound_name == "h01" then
			full_sound = "Play_l5n_c01a" -- contact line is actually a rescue line
		end
		if sound_name == "cn1" then
			full_sound = "Play_l5n_cn1_con"
		end
		if sound_name == "civ" then
			full_sound = "Play_l5n_civ_con"
		end
		if sound_name == "cr1" then
			full_sound = "Play_l5n_cr1_con"
		end
		if sound_name == "clr" then
			full_sound = "Play_l5n_clr_con"
		end
		if sound_name == "g90" then
			full_sound = "Play_l5n_g90"
		end
		if sound_name == "d01" then
			full_sound = "Play_l5n_d01_con"
		end
		if sound_name == "d02" then
			full_sound = "Play_l5n_d02_con"
		end
		if sound_name == "ch1" then
			full_sound = "Play_l5n_ch1_con"
		end
		if sound_name == "ch2" then
			full_sound = "Play_l5n_ch2_con"
		end
		if sound_name == "ch3" then
			full_sound = "Play_l5n_ch3_con"
		end
		if sound_name == "ch4" then
			full_sound = "Play_l5n_ch4_con"
		end
		if sound_name == "gr1a" then
			full_sound = "Play_l5n_gr1a_con"
		end
		if sound_name == "gr1b" then
			full_sound = "Play_l5n_gr1b_con"
		end
		if sound_name == "gr1c" then
			full_sound = "Play_l5n_gr1c_con"
		end
		if sound_name == "gr1d" then
			full_sound = "Play_l5n_gr1d_con"
		end
		if sound_name == "gr2a" then
			full_sound = "Play_l5n_gr2a_con"
		end
		if sound_name == "gr2b" then
			full_sound = "Play_l5n_gr2b_con"
		end
		if sound_name == "gr2c" then
			full_sound = "Play_l5n_gr2c_con"
		end
		if sound_name == "gr2d" then
			full_sound = "Play_l5n_gr2d_con"
		end
		if sound_name == "med" then
			full_sound = "Play_l5n_med_con"
		end
		if sound_name == "m01" then
			full_sound = "Play_l5n_m01_any"
		end
		if sound_name == "mov" then
			full_sound = "Play_l5n_mov_ass"
		end
		if sound_name == "p01" then
			full_sound = "Play_l5n_p01_ass"
		end
		if sound_name == "p02" then
			full_sound = "Play_l5n_p02_ass"
		end
		if sound_name == "p03" then
			full_sound = "Play_l5n_p03_ass"
		end
		if sound_name == "pos" then
			full_sound = "Play_l5n_pos_con"
		end
		if sound_name == "prm" or sound_name == "t01" then
			full_sound = "Play_l5n_prm_con"
		end
		if sound_name == "pus" or sound_name == "rrl" then
			full_sound = "Play_l5n_pus_con"
		end
		if sound_name == "r01" then
			full_sound = "Play_l5n_r01_con"
		end
		if sound_name == "s01x" then
			full_sound = "Play_l5n_s01x_con"
		end
		if sound_name == "i01" then
			full_sound = "Play_l5n_i01_con"
		end
		if sound_name == "i02" then
			full_sound = "Play_l5n_i02_con"
		end
		if sound_name == "i03" then
			full_sound = "Play_l5n_i03_con__________________MISSING_i03c"
		end
		if sound_name == "l01" then
			full_sound = "Play_l5n_l01_con__________________MISSING_l01b"
		end
		if sound_name == "lk3a" then
			full_sound = "Play_l5n_lk3_ass"
		end
		if sound_name == "lk3b" then
			full_sound = "Play_l5n_lk3_con"
		end
		if sound_name == "hlp" then
			full_sound = "Play_l5n_hlp_con"
		end
		if sound_name == "x02a_any_3p" then
			full_sound = "l1n_x01a_any_3p"
		end
		if sound_name == "x01a_any_3p" then
			full_sound = "l1n_x02a_any_3p"
		end
		if sound_name == "a07a" or sound_name == "a07b" then
			full_sound = l5n_alert[math.random(#l5n_alert)]
		end
		if sound_name == "a10" or sound_name == "a11" or sound_name == "a12" then
			full_sound = l5n_missing_police_calls[math.random(#l5n_missing_police_calls)]
		end
	end

	-- fix one of the latin thug quotes being missing
	if self._prefix == "lt1_" then
		if sound_name == "g90" then
			sound_name = "c01"
		end
	end

	local fixed_sound = nil

	-- fix death and pain sounds being swapped
	if self._prefix == "l1n_" or self._prefix == "l2n_" or self._prefix == "l3n_" then
		if sound_name == "x02a_any_3p" then
			sound_name = "x01a_any_3p"
			fixed_sound = true
		end
		if sound_name == "x01a_any_3p" then
			sound_name = "x02a_any_3p"
		end
	end

	-- fix gangsters not having any pain burn lines
	if self._prefix == "ict1_" or self._prefix == "bik1_" or self._prefix == "lt1_" or self._prefix == "rt1_" then
		if sound_name == "burnhurt" then
			full_sound = "l1n_burnhurt"
		end
		if sound_name == "burndeath" or sound_name == "ch3" then
			full_sound = "l1n_burndeath"
		end
	end
	if self._prefix == "ict2_" or self._prefix == "bik2_" or self._prefix == "lt2_" or self._prefix == "rt2_" then
		if sound_name == "burnhurt" then
			full_sound = "l2n_burnhurt"
		end
		if sound_name == "burndeath" or sound_name == "ch3" then
			full_sound = "l2n_burndeath"
		end
	end

	-- female enemies vo fix
	if self._prefix == "fl1n_" then
		if sound_name == "burnhurt" then
			full_sound = "cf2_burnhurt"
		end
		if sound_name == "burndeath" then
			full_sound = "cf2_burndeath"
		end
		if sound_name == "x02a_any_3p" then
			full_sound = "fl1n_x01a_any_3p_01"
		end
	end

	if self._prefix == "l4n_" then
		if sound_name == "x02a_any_3p" then
			sound_name = "x01a_any_3p"
			fixed_sound = true
		end
		if sound_name == "x01a_any_3p" then
			sound_name = "l1n_x02a_any_3p"
		end
	end

	-- l2n and l3n has these lines swapped for some odd reason
	if self._prefix == "l2n_" or self._prefix == "l3n_" then
		if sound_name == "lk3a" then
			sound_name = "lk3b"
		end
		if sound_name == "lk3b" then
			sound_name = "lk3a"
		end
	end

	-- give regular clear lines for radio filtered enemies in stelf (just in case for maps that has heavy guards)
	if self._prefix == "l1d_" or self._prefix == "l2d_" or self._prefix == "l3d_" or self._prefix == "l4d_" or self._prefix == "l5d_" then
		if sound_name == "a05" or sound_name == "a06" then
			sound_name = "clr"
		end
	end

	local faction = tweak_data.levels:get_ai_group_type()

	if self._unit:base():has_tag("special") and not sound_name == "g90" and not sound_name == "c01" then --just making sure
		if sound_name == "x02a_any_3p" then
			if self._unit:base():has_tag("spooc") then
				if faction == "russia" then
					full_sound = "rclk_x02a_any_3p"
				else
					full_sound = "clk_x02a_any_3p"
				end
			end

			if self._unit:base():has_tag("taser") then
				if faction == "russia" then
					full_sound = "rtsr_x02a_any_3p"
				else
					full_sound = "tsr_x02a_any_3p"
				end
			end

			if self._unit:base():has_tag("tank") then
				full_sound = "bdz_x02a_any_3p"
			end

			if self._unit:base():has_tag("medic") then
				full_sound = "mdc_x02a_any_3p"
			end
		end

		if sound_name == "x01a_any_3p" then
			if self._unit:base():has_tag("spooc") then
				if faction == "russia" then
					full_sound = "rclk_x01a_any_3p"
				else
					full_sound = "l2d_x01a_any_3p" -- give him radio filtered hurting sounds since he doesn't have any unlike foregin cloakers
				end
			end
			if self._unit:base():has_tag("taser") then
				if faction == "russia" then
					full_sound = "rtsr_x01a_any_3p"
				else
					full_sound = "tsr_x01a_any_3p"
				end
			end
			if self._unit:base():has_tag("tank") then
				full_sound = "bdz_x01a_any_3p"
			end
			if self._unit:base():has_tag("medic") then
				full_sound = "mdc_x01a_any_3p"
			end
		end
	end

	-- give tasers and medics burndeath screams when getting affected by ecm feedback
	if sound_name == "ch3" then
		if self._unit:base():has_tag("taser") then
			if faction == "russia" then
				full_sound = "rtsr_burndeath"
			elseif faction == "federales" then
				full_sound = "mtsr_burndeath"
			else
				full_sound = "tsr_burndeath"
			end
		end

		if self._unit:base():has_tag("medic") then
			if faction == "russia" then
				full_sound = "rmdc_burndeath"
			elseif faction == "federales" then
				full_sound = "mmdc_burndeath"
			else
				full_sound = "mdc_burndeath"
			end
		end
	end

	-- fix l2d having missing death sound
	if self._prefix == "l2d_" then
		if sound_name == "x02a_any_3p" then
			full_sound = "l1d_x02a_any_3p"
		end
	end

	-- fix l3d having missing burnhurt/death sounds
	if self._prefix == "l3d_" then
		if sound_name == "burnhurt" then
			full_sound = "l1d_burnhurt"
		end
		if sound_name == "burndeath" then
			full_sound = "l1d_burndeath"
		end
	end

	local zombie_sounds = {
		"g90",
		"mov",
		"rdy",
		"c01",
		"d01",
	}
	-- tweak zombie quotes
	if self._prefix == "z1n_" then
		if
			sound_name == "x01a_any_3p"
			or sound_name == "x02a_any_3p"
			or sound_name == "burndeath"
			or sound_name == "burnhurt"
			or sound_name == "ch1"
			or sound_name == "ch2"
			or sound_name == "ch3"
			or sound_name == "ch4"
		then
			full_sound = zombie_sounds[math.random(#zombie_sounds)] -- pure zombie sounds
		end
	end

	if self._prefix == "z2n_" then
		if
			sound_name == "x01a_any_3p"
			or sound_name == "x02a_any_3p"
			or sound_name == "burndeath"
			or sound_name == "burnhurt"
			or sound_name == "ch1"
			or sound_name == "ch2"
			or sound_name == "ch3"
			or sound_name == "ch4"
		then
			full_sound = zombie_sounds[math.random(#zombie_sounds)] -- ditto
		end
	end

	if self._prefix == "z3n_" then
		if
			sound_name == "x01a_any_3p"
			or sound_name == "x02a_any_3p"
			or sound_name == "burndeath"
			or sound_name == "burnhurt"
			or sound_name == "ch1"
			or sound_name == "ch2"
			or sound_name == "ch3"
			or sound_name == "ch4"
		then
			full_sound = zombie_sounds[math.random(#zombie_sounds)] -- ditto
		end
	end

	if self._prefix == "z4n_" then
		if
			sound_name == "x01a_any_3p"
			or sound_name == "x02a_any_3p"
			or sound_name == "burndeath"
			or sound_name == "burnhurt"
			or sound_name == "ch1"
			or sound_name == "ch2"
			or sound_name == "ch3"
			or sound_name == "ch4"
		then
			full_sound = zombie_sounds[math.random(#zombie_sounds)] -- ditto
		end
	end

	-- tweak reaper quotes
	if self._prefix == "r1n_" then
		if sound_name == "x02a_any_3p" then
			full_sound = "l1n_x01a_any_3p"
		elseif sound_name == "x01a_any_3p" then
			full_sound = "l1n_x02a_any_3p"
		elseif sound_name == "ch3" then
			full_sound = "l1n_burndeath" -- ARGH MY FUCKING EARS!!!!!!!
		elseif sound_name == "ch1" or sound_name == "ch2" or sound_name == "ch4" or sound_name == "s01x" then
			full_sound = "r1n_hlp" -- use supressed lines when reacting to sentry gun, saw, being intimitaed or trip mine blowing up
		elseif sound_name == "d02" then
			full_sound = "r1n_g90" -- use regular taunt lines when deploying flashbangs
		end
	end

	if self._prefix == "r2n_" then
		if sound_name == "x02a_any_3p" then
			full_sound = "l2n_x01a_any_3p"
		elseif sound_name == "x01a_any_3p" then
			full_sound = "l2n_x02a_any_3p"
		elseif sound_name == "ch3" then
			full_sound = "l2n_burndeath" -- ditto
		elseif sound_name == "ch1" or sound_name == "ch2" or sound_name == "ch4" or sound_name == "s01x" then
			full_sound = "r2n_hlp" -- ditto
		elseif sound_name == "d02" then
			full_sound = "r2n_g90" -- ditto
		end
	end

	if self._prefix == "r3n_" then
		if sound_name == "x02a_any_3p" then
			full_sound = "l3n_x01a_any_3p"
		elseif sound_name == "x01a_any_3p" then
			full_sound = "l3n_x02a_any_3p"
		elseif sound_name == "ch3" then
			full_sound = "l3n_burndeath" -- ditto
		elseif sound_name == "ch1" or sound_name == "ch2" or sound_name == "ch4" or sound_name == "s01x" then
			full_sound = "r3n_hlp" -- ditto
		elseif sound_name == "d02" then
			full_sound = "r3n_g90" -- ditto
		end
	end

	if self._prefix == "r4n_" then
		if sound_name == "x02a_any_3p" then
			full_sound = "l4n_x01a_any_3p"
		elseif sound_name == "x01a_any_3p" then
			full_sound = "l4n_x02a_any_3p"
		elseif sound_name == "ch3" then
			full_sound = "l4n_burndeath" -- ditto
		elseif sound_name == "ch1" or sound_name == "ch2" or sound_name == "ch4" or sound_name == "s01x" then
			full_sound = "r4n_hlp" -- ditto
		elseif sound_name == "d02" then
			full_sound = "r4n_g90" -- ditto
		end
	end

	-- tweak federales quotes
	if self._prefix == "m1n_" then
		if sound_name == "ch3" then
			full_sound = "l1n_burndeath" -- ARGH MY FUCKING EARS!!!!!!!
		elseif sound_name == "ch1" or sound_name == "ch2" or sound_name == "ch4" or sound_name == "s01x" then
			full_sound = "m1n_hlp" -- use supressed lines when reacting to sentry gun, saw, being intimitaed or trip mine blowing up
		elseif sound_name == "d02" then
			full_sound = "m1n_g90" -- use regular taunt lines when deploying flashbangs
		end
	end

	if self._prefix == "m2n_" then
		if sound_name == "ch3" then
			full_sound = "l2n_burndeath" -- ditto
		elseif sound_name == "ch1" or sound_name == "ch2" or sound_name == "ch4" or sound_name == "s01x" then
			full_sound = "m2n_hlp" -- ditto
		elseif sound_name == "d02" then
			full_sound = "m2n_g90" -- ditto
		end
	end

	if self._prefix == "m3n_" then
		if sound_name == "ch3" then
			full_sound = "l3n_burndeath" -- ditto
		elseif sound_name == "ch1" or sound_name == "ch2" or sound_name == "ch4" or sound_name == "s01x" then
			full_sound = "m3n_hlp" -- ditto
		elseif sound_name == "d02" then
			full_sound = "m3n_g90" -- ditto
		end
	end

	if self._prefix == "m4n_" then
		if sound_name == "ch3" then
			full_sound = "l4n_burndeath" -- ditto
		elseif sound_name == "ch1" or sound_name == "ch2" or sound_name == "ch4" or sound_name == "s01x" then
			full_sound = "m4n_hlp" -- ditto
		elseif sound_name == "d02" then
			full_sound = "m4n_g90" -- ditto
		end
	end

	self._last_speech = self:_play(full_sound or event_id, nil, self._speak_done_callback)
	self._speak_expire_t = self._last_speech and TimerManager:game():time() + 10 or 0
end)
