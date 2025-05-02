local scripted_enemy = Eclipse.scripted_enemy
local is_eclipse = Eclipse.utils.is_eclipse()
local headless_dozer_black = scripted_enemy.headless_bulldozer_1
local headless_dozer_white = scripted_enemy.headless_bulldozer_2
local headless_tanks = is_eclipse and { [headless_dozer_black] = 3, [headless_dozer_white] = 1 } or headless_dozer_black

local headless_tank = {
	enemy = headless_tanks,
}

return {
	[100457] = headless_tank,
	[101402] = headless_tank,
	[101423] = headless_tank,
	[101433] = headless_tank,
	[101441] = headless_tank,
	[101471] = headless_tank,
	[101526] = headless_tank,
	[101553] = headless_tank,
	[101570] = headless_tank,
	[101616] = headless_tank,
	[101628] = headless_tank,
	[101636] = headless_tank,
	[101646] = headless_tank,
	[101657] = headless_tank,
	[101661] = headless_tank,
}
