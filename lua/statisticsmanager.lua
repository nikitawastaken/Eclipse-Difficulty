--add Eclipse's tweak tables to special unit ids
StatisticsManager.special_unit_ids = {
	"shield",
	"fbi_shield",
	"city_shield",
	"city_shield_break",
	"spooc",
	"tank",
	"city_tank",
	"tank_hw",
	"taser",
	"medic",
	"sniper",
	"fbi_sniper",
	"city_sniper",
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
	"fbi_boss",
	"tank_medic",
	"tank_mini",
	"marshal_marksman",
	"marshal_shield",
	"marshal_gunner",
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
	self._defaults.killed.fbi_boss = {
		count = 0,
		head_shots = 0,
		melee = 0,
		explosion = 0,
		tied = 0,
	}
	self._defaults.killed.cobra = {
		count = 0,
		head_shots = 0,
		melee = 0,
		explosion = 0,
		tied = 0,
	}
	self._defaults.killed.murky = {
		count = 0,
		head_shots = 0,
		melee = 0,
		explosion = 0,
		tied = 0,
	}
	self._defaults.killed.security_fat = {
		count = 0,
		head_shots = 0,
		melee = 0,
		explosion = 0,
		tied = 0,
	}
	self._defaults.killed.security_mcmansion = {
		count = 0,
		head_shots = 0,
		melee = 0,
		explosion = 0,
		tied = 0,
	}
	self._defaults.killed.security_army = {
		count = 0,
		head_shots = 0,
		melee = 0,
		explosion = 0,
		tied = 0,
	}
	self._defaults.killed.marshal_security = {
		count = 0,
		head_shots = 0,
		melee = 0,
		explosion = 0,
		tied = 0,
	}
	self._defaults.killed.cop_fat = {
		count = 0,
		head_shots = 0,
		melee = 0,
		explosion = 0,
		tied = 0,
	}
	self._defaults.killed.soldier = {
		count = 0,
		head_shots = 0,
		melee = 0,
		explosion = 0,
		tied = 0,
	}
	self._defaults.killed.fbi_sniper = {
		count = 0,
		head_shots = 0,
		melee = 0,
		explosion = 0,
		tied = 0,
	}
	self._defaults.killed.fbi_shield = {
		count = 0,
		head_shots = 0,
		melee = 0,
		explosion = 0,
		tied = 0,
	}
	self._defaults.killed.city_heavy_swat = {
		count = 0,
		head_shots = 0,
		melee = 0,
		explosion = 0,
		tied = 0,
	}
	self._defaults.killed.city_sniper = {
		count = 0,
		head_shots = 0,
		melee = 0,
		explosion = 0,
		tied = 0,
	}
	self._defaults.killed.city_shield = {
		count = 0,
		head_shots = 0,
		melee = 0,
		explosion = 0,
		tied = 0,
	}
	self._defaults.killed.city_shield_break = {
		count = 0,
		head_shots = 0,
		melee = 0,
		explosion = 0,
		tied = 0,
	}
	self._defaults.killed.city_tank = {
		count = 0,
		head_shots = 0,
		melee = 0,
		explosion = 0,
		tied = 0,
	}
	self._defaults.killed.marshal_gunner = {
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
end
