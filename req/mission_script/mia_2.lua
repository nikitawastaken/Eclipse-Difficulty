local scripted_enemy = Eclipse.scripted_enemy

local cloaker = scripted_enemy.cloaker

return {
	-- Boss spawn
	[100154] = {
		difficulty = 0.1
	},
	-- Boss dead
	[100153] = {
		difficulty = 1
	},
	[101133] = {
		enemy = cloaker
	},
	[101141] = {
		enemy = cloaker
	}
}
