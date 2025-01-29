local is_eclipse = Eclipse.utils.is_eclipse()

local bulldozer = scripted_enemy.bulldozer_1
local elite_bulldozer = scripted_enemy.elite_bulldozer_1

return {
	-- replace the cloaker spawn with dozer and make him participate to group ai
	[101320] = {
		enemy = is_eclipse and elite_bulldozer or bulldozer,
		values = {
			participate_to_group_ai = true
		}
	},
	--trigger spawns during escape part
	[103111] = {
		on_executed = {
			{id = 400001, delay = 0},
			{id = 400002, delay = 0},
			{id = 400003, delay = 0},
			{id = 400004, delay = 0}
		}
	},
	--trigger spawns in scaffolding part
	[103543] = {
		on_executed = {
			{id = 400005, delay = 0},
			{id = 400006, delay = 0},
			{id = 400007, delay = 0},
			{id = 400008, delay = 0}
		}
	},
	--Disable dozer spawn once George the pilot gets Kauzo out
	[100121] = {
		func = function(self)
			local turn_this_shit_off = self:get_mission_element(101320)

			if turn_this_shit_off then
				turn_this_shit_off:set_enabled(false)
			end
		end
	},
	-- Remove spawn groups closest to the broken bridge part (and add a few groups from the construction site)
	[101176] = {
		values = {
			spawn_groups = { 101847, 103886, 101250, 101154, 101160, 101156, 101159 }
		}
	},
	[100657] = { -- disable the entire attack heli
		values = {
			enabled = false
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
		ponr = {
			length = 20,
			player_mul = {2, 1.5, 1, 1}
		}
	}
}