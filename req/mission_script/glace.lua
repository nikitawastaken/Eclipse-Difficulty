local diff_i = tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or "normal")
local ziplineDozer = Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1")
if diff_i == 6 then
	ziplineDozer = Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic")
end

return {
	-- replace the cloaker spawn with dozer and make him participate to group ai
	[101320] = {
		enemy = ziplineDozer,
		values = {
			participate_to_group_ai = true
		}
	},
	-- Remove spawn groups closest to the broken bridge part (and add a few groups from the construction site)
	[101176] = {
		values = {
			spawn_groups = { 101847, 103886, 101250, 101154, 101160, 101156, 101159 }
		}
	},
	-- slow down spawnpoints closer to the vans
	[101154] = {
		values = {
			interval = 50
		}
	},
	[101160] = {
		values = {
			interval = 50
		}
	},
	[101156] = {
		values = {
			interval = 30
		}
	},
	[101159] = {
		values = {
			interval = 30
		}
	},
	[100521] = {
		values = {
			enabled = false
		}
	},
	[100533] = {
		set_ponr_state = true
	}
}