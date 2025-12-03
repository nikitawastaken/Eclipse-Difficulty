local preferred = Eclipse.preferred
local is_eclipse = Eclipse.utils.is_eclipse()
local diff_i = Eclipse.utils.difficulty_index()
local dance_civs = is_eclipse and 17 or 7
local dance_civs_bad_music = is_eclipse and 7 or 3
local rear_spawn = {
	values = {
		interval = 10,
	},
}
local side_spawn = {
	values = {
		interval = 15,
	},
}
local window_spawn = {
	values = {
		interval = 40,
	},
	groups = preferred.no_cops_agents_shields_bulldozers,
}
local alleyway_spawn = {
	values = {
		interval = 45,
	},
	groups = preferred.no_bulldozers,
}
local law_team = {
	values = {
		team = "law1",
	},
}

local random_club_music = math.random()

local club_music = nil
local club_music_off = nil

-- Music stuff
if diff_i <= 5 then
	if random_club_music <= 0.30 then
		club_music = "diegetic_club_rock_music"
		club_music_off = "diegetic_club_rock_music_stop"
	else
		club_music = "diegetic_club_music"
		club_music_off = "diegetic_club_music_stop"
	end
else
	club_music = "dah_party_music"
	club_music_off = "dah_party_music_stop"
end

return {
	-- Combine some navigation areas
	[100087] = {
		ai_area = {
			{ 6, 7 },
			{ 8, 10 },
			{ 15, 16 },
			{ 17, 18 },
			{ 19, 20 },
			{ 21, 22 },
			{ 23, 24 },
			{ 38, 39 },
			{ 54, 59 },
			{ 69, 70 },
			{ 13, 68 },
			{ 36, 95 },
			{ 91, 92 },
			{ 32, 33, 34 },
			{ 83, 85, 90 },
		},
	},
	[101169] = {
		reinforce = {
			{
				name = "dance_floor",
				force = 3,
				position = Vector3(2400, -5600, -50),
			},
			{
				name = "street",
				force = 3,
				position = Vector3(1400, -2900, 25),
			},
		},
	},
	[101475] = {
		values = {
			sound_event = club_music_off,
		},
	},
	[103041] = {
		values = {
			sound_event = club_music,
		},
	},
	-- more civilians on the dance floor on Eclipse
	[101916] = {
		values = {
			counter_target = dance_civs,
		},
	},
	[101949] = {
		values = {
			amount = dance_civs_bad_music,
		},
	},
	-- Spawn group intervals
	[101046] = side_spawn,
	[101213] = side_spawn,
	[100806] = rear_spawn,
	[101345] = rear_spawn,
	[103174] = window_spawn,
	[104731] = window_spawn,
	[101221] = alleyway_spawn,
	-- Dimitri's men are friendly to cops
	[101858] = law_team,
	[101865] = law_team,
	[101927] = law_team,
	[101934] = law_team,
	[102193] = law_team,
	[102200] = law_team,
	[102202] = law_team,
	[102206] = law_team,
	[102617] = law_team,
	[102619] = law_team,
	[100513] = law_team,
	[100517] = law_team,
	[100518] = law_team,
	[100520] = law_team,
	[100522] = law_team,
	[100522] = law_team,
	[100523] = law_team,
	[100528] = law_team,
	[100530] = law_team,
	[100532] = law_team,
	[100534] = law_team,
	[101252] = law_team,
	[102708] = law_team,
	[102709] = law_team,
	[103450] = law_team,
	[103451] = law_team,
	[103452] = law_team,
	[103637] = law_team,
	[103638] = law_team,
	[103639] = law_team,
	[100991] = law_team,
	[100994] = law_team,
	[101100] = law_team,
	[101231] = law_team,
	[101232] = law_team,
	[101233] = law_team,
	[102088] = law_team,
	[102099] = law_team,
}
