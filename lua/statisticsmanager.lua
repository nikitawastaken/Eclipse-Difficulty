--add Eclipse's tweak tables to special unit ids
StatisticsManager.special_unit_ids = {
	"shield",
	"fbi_shield",
	"spooc",
	"tank",
	"tank_elite",
	"tank_hw",
	"taser",
	"medic",
	"sniper",
	"phalanx_minion",
	"phalanx_minion_break",
	"phalanx_vip",
	"heavy_swat_sniper",
	"zeal_shield",
	"zeal_medic",
	"zeal_taser",
	"swat_turret",
	"biker_boss",
	"chavez_boss",
	"mobster_boss",
	"hector_boss",
	"hector_boss_no_armor",
	"tank_medic",
	"tank_mini",
	"marshal_marksman",
	"marshal_shield",
	"triad_boss",
	"triad_boss_no_armor",
	"snowman_boss",
	"deep_boss",
	"piggydozer",
}

--use vanilla's stat tweak_tables while adding new ones
local old_stats = StatisticsManager.init
function StatisticsManager:init()
	old_stats(self)
	self._defaults.killed.tank_elite = {
		count = 0,
		head_shots = 0,
		melee = 0,
		explosion = 0,
		tied = 0,
	}
	self._defaults.killed.zeal_shield = {
		count = 0,
		head_shots = 0,
		melee = 0,
		explosion = 0,
		tied = 0,
	}
	self._defaults.killed.zeal_taser = {
		count = 0,
		head_shots = 0,
		melee = 0,
		explosion = 0,
		tied = 0,
	}
	self._defaults.killed.zeal_medic = {
		count = 0,
		head_shots = 0,
		melee = 0,
		explosion = 0,
		tied = 0,
	}
	self._defaults.killed.phalanx_minion_break = {
		count = 0,
		head_shots = 0,
		melee = 0,
		explosion = 0,
		tied = 0,
	}
end
