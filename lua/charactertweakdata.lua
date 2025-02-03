local diff_i = Eclipse.utils.difficulty_index()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()

local function diff_lerp(value_1, value_2)
	return Eclipse.utils.diff_lerp(value_1, value_2)
end

-- Clones a weapon preset and optionally sets values for all weapons contained in that preset
-- if the value is a function, it calls the function with the data of the value name instead
local nil_value = {}

local function based_on(preset, values)
	local p = deep_clone(preset)
	if not values then
		return p
	end
	for _, entry in pairs(p) do
		for val_name, val in pairs(values) do
			if type(val) == "function" then
				val(entry[val_name])
			else
				entry[val_name] = val ~= nil_value and val
			end
		end
	end
	return p
end

-- Helper scaling functions
local function speed_multiplier(tbl, multiplier)
	for _, pose in pairs(tbl) do
		for _, haste in pairs(pose) do
			for _, stance in pairs(haste) do
				for dir, speed in pairs(stance) do
					stance[dir] = speed * multiplier
				end
			end
		end
	end
end

local function damage_multiplier(tbl, multiplier)
	for _, weapon in pairs(tbl) do
		for _, falloff in pairs(weapon.FALLOFF) do
			falloff.dmg_mul = falloff.dmg_mul * multiplier
		end
	end
end

local function accuracy_multiplier(tbl, multiplier)
	for _, weapon in pairs(tbl) do
		for _, falloff in pairs(weapon.FALLOFF) do
			for _, accuracy in pairs(falloff.acc) do
				accuracy = math.min(1, accuracy * multiplier)
			end
		end
	end
end

local function recoil_multiplier(tbl, multiplier)
	for _, weapon in pairs(tbl) do
		for _, falloff in pairs(weapon.FALLOFF) do
			for _, recoil in pairs(falloff.recoil) do
				recoil = recoil * multiplier
			end
		end
	end
end

local function burst_multiplier(tbl, multiplier)
	for _, weapon in pairs(tbl) do
		if not weapon.autofire_rounds then
			return
		end

		for _, falloff in pairs(weapon.FALLOFF) do
			for _, autofire_rounds in pairs(falloff.autofire_rounds) do
				autofire_rounds = math.max(1, math.ceil(autofire_rounds * multiplier))
			end
		end
	end
end

local _presets_orig = CharacterTweakData._presets
function CharacterTweakData:_presets(tweak_data, ...)
	local presets = _presets_orig(self, tweak_data, ...)

	local dmg_mul_tbl = { 0.2, 0.4, 0.6, 0.8, 1, 1, 1, 1 }
	local dmg_mul = dmg_mul_tbl[diff_i]

	local aim_delay_tbl = { 1.25, 1, 0.875, 0.75, 0.625, 0.5, 0.5, 0.5 }
	local aim_delay_mul = aim_delay_tbl[diff_i]
	
	presets.weapon.base = based_on(presets.weapon.expert, {
		aim_delay = { 0, 1 },
		focus_delay = 0.8,
		melee_dmg = 7.5 * dmg_mul,
		melee_speed = 1,
		melee_retry_delay = { 1, 2 },
		melee_range = 125,
		melee_force = 400,
		range = { close = 750, optimal = 1500, far = 3000 },
		RELOAD_SPEED = 1,
	})

	presets.weapon.base.is_pistol.FALLOFF = {
		{ dmg_mul = 3 * dmg_mul, r = 0, acc = { 0.5, 0.8 }, recoil = { 0.2, 0.3 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 3 * dmg_mul, r = 3000, acc = { 0.2, 0.3 }, recoil = { 0.3, 0.6 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.akimbo_pistol.melee_dmg = nil
	presets.weapon.base.akimbo_pistol.melee_speed = nil
	presets.weapon.base.akimbo_pistol.melee_retry_delay = nil
	presets.weapon.base.akimbo_pistol.FALLOFF = {
		{ dmg_mul = 3 * dmg_mul, r = 0, acc = { 0.3, 0.7 }, recoil = { 0.1, 0.2 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 3 * dmg_mul, r = 3000, acc = { 0.1, 0.2 }, recoil = { 0.2, 0.4 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_revolver.RELOAD_SPEED = 0.9
	presets.weapon.base.is_revolver.range = { close = 1000, optimal = 2000, far = 4000 }
	presets.weapon.base.is_revolver.FALLOFF = {
		{ dmg_mul = 7.5 * dmg_mul, r = 0, acc = { 0.7, 0.9 }, recoil = { 0.75, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 7.5 * dmg_mul, r = 4000, acc = { 0.3, 0.5 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_sniper = deep_clone(presets.weapon.base.is_revolver)
	presets.weapon.base.is_sniper.range = { close = 1500, optimal = 3000, far = 6000 }
	presets.weapon.base.is_sniper.FALLOFF = {
		{ dmg_mul = 12 * dmg_mul, r = 0, acc = { 0, 0.5 }, recoil = { 1.5, 2 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 12 * dmg_mul, r = 2000, acc = { 0.5, 1 }, recoil = { 1.5, 2 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 12 * dmg_mul, r = 4000, acc = { 0.5, 1 }, recoil = { 1.5, 2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_shotgun_pump.RELOAD_SPEED = 1.5
	presets.weapon.base.is_shotgun_pump.range = { close = 500, optimal = 1000, far = 2000 }
	presets.weapon.base.is_shotgun_pump.FALLOFF = {
		{ dmg_mul = 7.5 * dmg_mul, r = 0, acc = { 0.8, 1 }, recoil = { 0.8, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 5 * dmg_mul, r = 1000, acc = { 0.7, 0.9 }, recoil = { 1, 1.4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 0.5 * dmg_mul, r = 2000, acc = { 0.6, 0.8 }, recoil = { 1.2, 1.8 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_shotgun_mag = deep_clone(presets.weapon.base.is_shotgun_pump)
	presets.weapon.base.is_shotgun_mag.RELOAD_SPEED = 1
	presets.weapon.base.is_shotgun_mag.autofire_rounds = { 1, 3 }
	presets.weapon.base.is_shotgun_mag.FALLOFF = {
		{ dmg_mul = 6 * dmg_mul, r = 0, acc = { 0.6, 0.9 }, recoil = { 0.4, 0.7 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 4 * dmg_mul, r = 1000, acc = { 0.5, 0.8 }, recoil = { 0.45, 0.8 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 0.5 * dmg_mul, r = 2000, acc = { 0.3, 0.6 }, recoil = { 1, 1.2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_double_barrel = deep_clone(presets.weapon.base.is_shotgun_pump)
	presets.weapon.base.is_double_barrel.FALLOFF = {
		{ dmg_mul = 9 * dmg_mul, r = 0, acc = { 0.8, 1 }, recoil = { 0.8, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 1 * dmg_mul, r = 2000, acc = { 0.6, 0.8 }, recoil = { 1, 1.4 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_rifle.autofire_rounds = { 1, 5 }
	presets.weapon.base.is_rifle.range = { close = 1000, optimal = 2000, far = 4000 }
	presets.weapon.base.is_rifle.FALLOFF = {
		{ dmg_mul = 3 * dmg_mul, r = 0, acc = { 0.5, 0.7 }, recoil = { 0.5, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 3 * dmg_mul, r = 3000, acc = { 0.2, 0.4 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_smg = deep_clone(presets.weapon.base.is_rifle)
	presets.weapon.base.is_smg.autofire_rounds = { 3, 8 }
	presets.weapon.base.is_smg.FALLOFF = {
		{ dmg_mul = 2.5 * dmg_mul, r = 0, acc = { 0.4, 0.6 }, recoil = { 0.5, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 2.5 * dmg_mul, r = 3000, acc = { 0.1, 0.2 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_lmg = deep_clone(presets.weapon.base.is_smg)
	presets.weapon.base.is_lmg.autofire_rounds = { 10, 30 }
	presets.weapon.base.is_lmg.FALLOFF = {
		{ dmg_mul = 2 * dmg_mul, r = 0, acc = { 0.3, 0.6 }, recoil = { 0.7, 1.4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 2 * dmg_mul, r = 1000, acc = { 0.2, 0.4 }, recoil = { 0.8, 1.6 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 2 * dmg_mul, r = 3000, acc = { 0.1, 0.2 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.mini = deep_clone(presets.weapon.base.is_lmg)
	presets.weapon.base.mini.autofire_rounds = { 50, 200 }
	presets.weapon.base.mini.FALLOFF = {
		{ dmg_mul = 1.5 * dmg_mul, r = 0, acc = { 0.2, 0.5 }, recoil = { 0.7, 1.4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 1.5 * dmg_mul, r = 1000, acc = { 0.1, 0.3 }, recoil = { 0.8, 1.6 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 1.5 * dmg_mul, r = 3000, acc = { 0, 0.1 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_flamethrower.melee_dmg = nil
	presets.weapon.base.is_flamethrower.melee_speed = nil
	presets.weapon.base.is_flamethrower.melee_retry_delay = nil
	presets.weapon.base.is_flamethrower.range = { close = 500, optimal = 1000, far = 1750 }
	presets.weapon.base.is_flamethrower.FALLOFF = {
		{ dmg_mul = 2 * dmg_mul, r = 0, acc = { 0.2, 0.4 }, recoil = { 0.4, 0.8 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 1 * dmg_mul, r = 1000, acc = { 0.1, 0.3 }, recoil = { 0.5, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 0 * dmg_mul, r = 2000, acc = { 0, 0.1 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
	}
	
	
	presets.weapon.security = based_on(presets.weapon.base, {
		aim_delay = { 0, 1.2 },
		focus_delay = 1,
		melee_dmg = 5 * dmg_mul,
	})	
	accuracy_multiplier(presets.weapon.security, 0.8)
	
	
	presets.weapon.cop = based_on(presets.weapon.base, {
		aim_delay = { 0, 1.2 },
		focus_delay = 1,
		melee_dmg = 5 * dmg_mul,
	})
	accuracy_multiplier(presets.weapon.cop, 0.9)
	
	
	presets.weapon.gangster = based_on(presets.weapon.base, {
		aim_delay = { 0, 1.2 },
		focus_delay = 1,
	})	
	damage_multiplier(presets.weapon.gangster, 5 / 4)
	accuracy_multiplier(presets.weapon.gangster, 0.5)
	recoil_multiplier(presets.weapon.gangster, 0.75)
	burst_multiplier(presets.weapon.gangster, 2)
	
	
	presets.weapon.swat = based_on(presets.weapon.base)
	
	
	presets.weapon.fbi = based_on(presets.weapon.swat)
	damage_multiplier(presets.weapon.fbi, 3 / 2)


	presets.weapon.fbi_swat = based_on(presets.weapon.swat, {
		aim_delay = { 0, 0.8 },
		focus_delay = 0.6,
		melee_dmg = 10 * dmg_mul,
	})	
	damage_multiplier(presets.weapon.fbi_swat, 4 / 3)
	accuracy_multiplier(presets.weapon.fbi_swat, 1.1)


	presets.weapon.city_swat = based_on(presets.weapon.swat, {
		aim_delay = { 0, 0.6 },
		focus_delay = 0.4,
		melee_dmg = 12.5 * dmg_mul,
	})	
	damage_multiplier(presets.weapon.city_swat, 5 / 3)
	accuracy_multiplier(presets.weapon.city_swat, 1.15)
	
	
	presets.weapon.zeal_swat = based_on(presets.weapon.swat, {
		aim_delay = { 0, 0.4 },
		focus_delay = 0.2,
		melee_dmg = 15 * dmg_mul,
	})	
	damage_multiplier(presets.weapon.zeal_swat, 6 / 3)
	accuracy_multiplier(presets.weapon.zeal_swat, 1.2)
	

	presets.weapon.shield = based_on(presets.weapon.base, {
		melee_range = 150,
		melee_force = 500,
		range = { close = 500, optimal = 1000, far = 2000 },
	})
	damage_multiplier(presets.weapon.shield, 3 / 4)
	accuracy_multiplier(presets.weapon.shield, 0.9)
		
		
	presets.weapon.fbi_shield = based_on(presets.weapon.shield)


	presets.weapon.elite_shield = based_on(presets.weapon.shield)

	presets.weapon.elite_shield.is_revolver.FALLOFF = {
		{ dmg_mul = 7.5 * dmg_mul, r = 0, acc = { 0.6, 0.8 }, recoil = { 0.5, 0.75 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 7.5 * dmg_mul, r = 4000, acc = { 0.2, 0.4 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } },
	}
	
	presets.weapon.elite_shield.is_shotgun_mag.autofire_rounds = { 1, 4 }
	presets.weapon.elite_shield.is_shotgun_mag.FALLOFF = {
		{ dmg_mul = 7.5 * dmg_mul, r = 0, acc = { 0.6, 0.9 }, recoil = { 0.4, 0.7 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 3, 4 } },
		{ dmg_mul = 5 * dmg_mul, r = 1000, acc = { 0.5, 0.8 }, recoil = { 0.45, 0.8 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 2, 3 } },
		{ dmg_mul = 0.5 * dmg_mul, r = 2000, acc = { 0.3, 0.6 }, recoil = { 1, 1.2 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 1, 2 } },
	}
	
	presets.weapon.zeal_shield = based_on(presets.weapon.shield)	

	presets.weapon.sniper = based_on(presets.weapon.swat)
	
	presets.weapon.sniper.is_sniper.aim_delay = { 
		1 * aim_delay_mul, 
		2 * aim_delay_mul,
	}
	
	presets.weapon.sniper.is_sniper.range = { close = 5000, optimal = 10000, far = 15000 }
	presets.weapon.sniper.is_sniper.FALLOFF = {
		{ dmg_mul = 18 * dmg_mul, r = 0, acc = { 0, 0.5 }, recoil = { 3, 4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 18 * dmg_mul, r = 1000, acc = { 0.5, 1 }, recoil = { 3, 4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 18 * dmg_mul, r = 4000, acc = { 0.5, 1 }, recoil = { 3, 4 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.elite_sniper = based_on(presets.weapon.swat)
	
	presets.weapon.elite_sniper.is_sniper.aim_delay = { 
		1 * aim_delay_mul, 
		2 * aim_delay_mul,
	}
	presets.weapon.elite_sniper.is_sniper.range = { close = 1500, optimal = 3000, far = 6000 }
	presets.weapon.elite_sniper.is_sniper.FALLOFF = {
		{ dmg_mul = 9 * dmg_mul, r = 0, acc = { 0, 0.5 }, recoil = { 0.5, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 9 * dmg_mul, r = 1000, acc = { 0.5, 1 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 9 * dmg_mul, r = 4000, acc = { 0.5, 1 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
	}
	
	presets.weapon.taser = based_on(presets.weapon.swat, {
		aim_delay_tase = { 
			0.5 * aim_delay_mul,
			1 * aim_delay_mul,
		},
		tase_sphere_cast_radius = 15,
		tase_distance = 1500,
	})

	presets.weapon.zeal_tazer = based_on(presets.weapon.taser)


	presets.weapon.medic = based_on(presets.weapon.swat, {
		melee_dmg = 5 * dmg_mul,
		range = { close = 1500, optimal = 2750, far = 4000 },
	})
	damage_multiplier(presets.weapon.medic, 3 / 4)
	
	presets.weapon.cloaker = based_on(presets.weapon.swat)

	presets.weapon.cloaker.is_pistol.RELOAD_SPEED = 1.1
	presets.weapon.cloaker.is_pistol.FALLOFF = {
		{ dmg_mul = 3 * dmg_mul, r = 0, acc = { 0.7, 0.9 }, recoil = { 0.15, 0.25 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 3 * dmg_mul, r = 3000, acc = { 0.3, 0.5 }, recoil = { 0.25, 0.5 }, mode = { 1, 0, 0, 0 } },
	}
	
	presets.weapon.cloaker.is_smg.autofire_rounds = { 3, 10 }
	presets.weapon.cloaker.is_smg.range = { close = 750, optimal = 1250, far = 2500 }
	presets.weapon.cloaker.is_smg.FALLOFF = {
		{ dmg_mul = 2.5 * dmg_mul, r = 0, acc = { 0.4, 0.6 }, recoil = { 0.5, 0.75 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 7, 8 } },
		{ dmg_mul = 2.5 * dmg_mul, r = 1500, acc = { 0.3, 0.4 }, recoil = { 0.75, 1 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 5, 6 } },
		{ dmg_mul = 2.5 * dmg_mul, r = 3000, acc = { 0.1, 0.2 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 3, 4 } },
	}
	
	presets.weapon.tank = based_on(presets.weapon.base, {
		aim_delay = { 0, 1.5 },
		melee_dmg = 30 * dmg_mul,
		melee_range = 175,
		melee_force = 600,
	})
	
	presets.weapon.tank.is_shotgun_pump.RELOAD_SPEED = 1
	presets.weapon.tank.is_shotgun_pump.FALLOFF = {
		{ dmg_mul = 24 * dmg_mul, r = 0, acc = { 0.8, 1 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 16 * dmg_mul, r = 1000, acc = { 0.7, 0.9 }, recoil = { 1.5, 2 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 4 * dmg_mul, r = 2000, acc = { 0.6, 0.8 }, recoil = { 1.5, 2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.tank.is_shotgun_mag.RELOAD_SPEED = 0.9
	presets.weapon.tank.is_shotgun_mag.autofire_rounds = { 1, 6 }
	presets.weapon.tank.is_shotgun_mag.FALLOFF = {
		{ dmg_mul = 8 * dmg_mul, r = 0, acc = { 0.6, 0.9 }, recoil = { 0.4, 0.7 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 5, 6 } },
		{ dmg_mul = 4 * dmg_mul, r = 1000, acc = { 0.5, 0.8 }, recoil = { 0.45, 0.8 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 3, 4 } },
		{ dmg_mul = 2 * dmg_mul, r = 2000, acc = { 0.3, 0.6 }, recoil = { 1, 1.2 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 1, 2 } },
	}

	presets.weapon.elite_tank = based_on(presets.weapon.tank)

	presets.weapon.elite_tank.is_shotgun_pump.FALLOFF = {
		{ dmg_mul = 24 * dmg_mul, r = 0, acc = { 0.8, 1 }, recoil = { 0.75, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 16 * dmg_mul, r = 1000, acc = { 0.7, 0.9 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 4 * dmg_mul, r = 2000, acc = { 0.6, 0.8 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.elite_tank.is_lmg.RELOAD_SPEED = 0.7
	presets.weapon.elite_tank.is_lmg.autofire_rounds = { 20, 50 }
	presets.weapon.elite_tank.is_lmg.FALLOFF = {
		{ dmg_mul = 3 * dmg_mul, r = 0, acc = { 0.3, 0.7 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 3 * dmg_mul, r = 1000, acc = { 0.2, 0.5 }, recoil = { 1.5, 2 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 3 * dmg_mul, r = 3000, acc = { 0.1, 0.3 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
	}


	presets.weapon.boss = based_on(presets.weapon.base)
	damage_multiplier(presets.weapon.boss, 3 / 2)

	presets.weapon.gang_member = based_on(presets.weapon.base, {
		aim_delay = { 0, 1 },
		focus_delay = 0,
		melee_speed = nil_value,
		melee_dmg = nil_value,
		melee_retry_delay = nil_value,
		weapon_switch = nil_value
	})

	for _, v in pairs(presets.weapon.gang_member) do
		v.FALLOFF = {
			{ dmg_mul = 4, r = 0, acc = { 0.5, 1 }, recoil = v.FALLOFF[1].recoil, mode = { 1, 0, 0, 0 } },
			{ dmg_mul = 2, r = 3000, acc = { 0, 0.5 }, recoil = v.FALLOFF[1].recoil, mode = { 1, 0, 0, 0 } }
		}
	end	
	
	presets.weapon.gang_member.is_flamethrower.no_autofire_stop = true
	presets.weapon.gang_member.is_lmg.no_autofire_stop = true
	presets.weapon.gang_member.mini.no_autofire_stop = true
	
	presets.move_speed.normal = {
		stand = {
			walk = {
				ntl = { fwd = 180, strafe = 130, bwd = 90 },
				cbt = { fwd = 220, strafe = 170, bwd = 130 },
				hos = { fwd = 260, strafe = 210, bwd = 170 },
			},
			run = {
				ntl = { fwd = 300, strafe = 250, bwd = 200 },
				cbt = { fwd = 375, strafe = 300, bwd = 225 },
				hos = { fwd = 450, strafe = 350, bwd = 250 },
			},
		},
		crouch = {
			walk = {
				ntl = { fwd = 140, strafe = 90, bwd = 60 },
				cbt = { fwd = 160, strafe = 120, bwd = 80 },
				hos = { fwd = 200, strafe = 150, bwd = 120 },
			},
			run = {
				ntl = { fwd = 180, strafe = 130, bwd = 90 },
				cbt = { fwd = 220, strafe = 170, bwd = 130 },
				hos = { fwd = 260, strafe = 210, bwd = 170 },
			},
		},
	}

	presets.move_speed.extremely_slow = deep_clone(presets.move_speed.normal)
	presets.move_speed.very_slow = deep_clone(presets.move_speed.normal)
	presets.move_speed.slow = deep_clone(presets.move_speed.normal)
	presets.move_speed.fast = deep_clone(presets.move_speed.normal)
	presets.move_speed.very_fast = deep_clone(presets.move_speed.normal)
	presets.move_speed.lightning = deep_clone(presets.move_speed.normal)

	speed_multiplier(presets.move_speed.extremely_slow, 0.4)
	speed_multiplier(presets.move_speed.very_slow, 0.6)
	speed_multiplier(presets.move_speed.slow, 0.8)
	speed_multiplier(presets.move_speed.fast, 1.15)
	speed_multiplier(presets.move_speed.very_fast, 1.3)
	speed_multiplier(presets.move_speed.lightning, 1.4)

	presets.gang_member_damage.HEALTH_INIT = 100 + (50 * diff_i)
	presets.gang_member_damage.HEALTH_REGEN = presets.gang_member_damage.HEALTH_INIT * 0.15
	presets.gang_member_damage.MIN_DAMAGE_INTERVAL = 0.05
	presets.gang_member_damage.REGENERATE_TIME = 5
	presets.gang_member_damage.REGENERATE_TIME_AWAY = 5
	presets.gang_member_damage.hurt_severity.bullet = {
		health_reference = "full",
		zones = {
			{
				health_limit = 0.3,
				none = 0.6,
				light = 0.4
			},
			{
				light = 1
			}
		},
	}

	-- escort speed stuff
	presets.move_speed.escort_normal = deep_clone(presets.move_speed.normal)
	presets.move_speed.escort_slow = deep_clone(presets.move_speed.slow)

	-- Tweak dodge presets
	presets.dodge.heavy.occasions.preemptive.chance = 0.25
	presets.dodge.athletic.occasions.preemptive.chance = 0.5 

	presets.dodge.ninja.speed = 2
	for _, occasion in pairs(presets.dodge.ninja.occasions) do
		occasion.chance = 1
		if occasion.variations.side_step then
			occasion.variations.side_step.chance = 1
		end
	end

	for _, preset in pairs(presets.hurt_severities) do
		for _, damage_type in pairs(preset) do
			if type(damage_type) == "table" then
				damage_type.health_reference = "full"
			end
		end
	end

	presets.hurt_severities.base.bullet.zones = {
		{
			health_limit = 0.2,
			none = 0.2,
			light = 0.6,
			moderate = 0.2
		},
		{
			health_limit = 0.4,
			light = 0.4,
			moderate = 0.4,
			heavy = 0.2
		},
		{
			health_limit = 0.6,
			light = 0.2,
			moderate = 0.2,
			heavy = 0.6
		},
		{
			health_limit = 0.8,
			heavy = 1
		}
	}
	presets.hurt_severities.base.melee.zones = {
		{
			health_limit = 0.2,
			light = 1
		},
		{
			health_limit = 0.4,
			light = 0.5,
			moderate = 0.5
		},
		{
			health_limit = 0.6,
			moderate = 0.5,
			heavy = 0.5
		},
		{
			health_limit = 0.8,
			heavy = 1
		}
	}
	presets.hurt_severities.base.explosion.zones = {
		{
			health_limit = 0.2,
			light = 0.5,
			moderate = 0.5
		},
		{
			health_limit = 0.4,
			moderate = 0.5,
			heavy = 0.5
		},
		{
			health_limit = 0.6,
			heavy = 0.5,
			explode = 0.5
		},
		{
			health_limit = 0.8,
			explode = 1
		}
	}

	presets.hurt_severities.only_light_hurt.bullet.zones = {
		{
			health_limit = 0.3,
			none = 0.6,
			light = 0.4
		},
		{
			light = 1
		}
	}
	presets.hurt_severities.only_light_hurt.melee.zones = deep_clone(presets.hurt_severities.only_light_hurt.bullet.zones)
	presets.hurt_severities.only_light_hurt.explosion.zones = deep_clone(presets.hurt_severities.only_light_hurt.bullet.zones)

	presets.hurt_severities.only_light_hurt_and_fire = deep_clone(presets.hurt_severities.base)
	presets.hurt_severities.only_light_hurt_and_fire.bullet.zones = {
		{ light = 1 },
	}
	
	presets.hurt_severities.only_light_hurt_and_fire.explosion.zones = {
		{ explode = 1 },
	}

	presets.hurt_severities.only_light_hurt_and_fire.melee.zones = {
		{ light = 1 },
	}		

	presets.hurt_severities.only_light_hurt_and_fire.fire.zones = {
		{ fire = 1 },
	}	

	presets.hurt_severities.only_light_hurt_and_fire.poison.zones = {
		{ none = 1 },
	}	
	
	presets.hurt_severities.no_heavy_hurt = deep_clone(presets.hurt_severities.base)
	presets.hurt_severities.no_heavy_hurt.bullet.zones = {
		{
			health_limit = 0.2,
			none = 0.6,
			light = 0.4
		},
		{
			health_limit = 0.4,
			light = 0.6,
			moderate = 0.4
		},
		{
			health_limit = 0.6,
			light = 0.4,
			moderate = 0.6
		},
		{
			health_limit = 0.8,
			moderate = 1
		}
	}
	presets.hurt_severities.no_heavy_hurt.melee.zones = {
		{
			health_limit = 0.2,
			none = 0.2,
			light = 0.8
		},
		{
			health_limit = 0.4,
			light = 0.8,
			moderate = 0.2
		},
		{
			health_limit = 0.6,
			light = 0.2,
			moderate = 0.8
		},
		{
			health_limit = 0.8,
			moderate = 0.8,
			heavy = 0.2
		}
	}
	presets.hurt_severities.no_heavy_hurt.explosion.zones = {
		{
			health_limit = 0.2,
			light = 1,
		},
		{
			health_limit = 0.4,
			light = 0.5,
			moderate = 0.5
		},
		{
			health_limit = 0.6,
			moderate = 0.5,
			heavy = 0.5
		},
		{
			health_limit = 0.8,
			heavy = 0.5,
			explode = 0.5
		}
	}

	-- Setup surrender presets
	presets.surrender.easy = {
		base_chance = 0,
		significant_chance = 0,
		reasons = {
			not_assault = 1,
			pants_down = 0.8,
			weapon_down = 0.6,
			flanked = 0.5,
			unaware_of_aggressor = 0.4,
			isolated = 0.3
		},
		factors = {
			health = {
				[1.0] = 0,
				[0.0] = 1
			},
			aggressor_dis = {
				[100] = 0.25,
				[800] = 0
			}
		}
	}
	
	presets.surrender.average = {
		base_chance = 0,
		significant_chance = 0,
		reasons = {
			not_assault = 0.8,
			pants_down = 0.6,
			weapon_down = 0.5,
			flanked = 0.4,
			unaware_of_aggressor = 0.3,
			isolated = 0.2
		},
		factors = {
			health = {
				[0.75] = 0,
				[0.0] = 0.75
			},
			aggressor_dis = {
				[100] = 0.2,
				[800] = 0
			}
		}
	}
	
	presets.surrender.hard = {
		base_chance = 0,
		significant_chance = 0,
		reasons = {
			not_assault = 0.6,
			pants_down = 0.5,
			weapon_down = 0.4,
			flanked = 0.3,
			unaware_of_aggressor = 0.2,
			isolated = 0.1
		},
		factors = {
			health = {
				[0.5] = 0,
				[0.0] = 0.5
			},
			aggressor_dis = {
				[100] = 0.15,
				[800] = 0
			}
		}
	}

	presets.surrender.very_hard = deep_clone(presets.surrender.hard)
	presets.surrender.very_hard = {
		base_chance = 0,
		significant_chance = 0,
		reasons = {
			not_assault = 0.6,
			pants_down = 0.4,
			weapon_down = 0.3,
			flanked = 0.2,
			unaware_of_aggressor = 0.1,
			isolated = 0
		},
		factors = {
			health = {
				[0.75] = 0,
				[0.0] = 0.25
			},
			aggressor_dis = {
				[100] = 0.1,
				[800] = 0
			}
		}
	}

	presets.base.surrender_break_time = { 10, 15 }

	
	presets.suppression.easy = {
		panic_chance_mul = 1,
		duration = { 8, 10 },
		react_point = { 0, 2 },
		brown_point = { 3, 5 },
	}

	presets.suppression.average = deep_clone(presets.surrender.easy)	
	
	presets.suppression.average = {
		panic_chance_mul = 0.8,
		duration = { 6, 8 },
		react_point = { 2, 4 },
		brown_point = { 5, 7 },
	}

	presets.suppression.hard = deep_clone(presets.surrender.easy)	
	
	presets.suppression.hard = {
		panic_chance_mul = 0.6,
		duration = { 4, 6 },
		react_point = { 4, 6 },
		brown_point = { 7, 9 },
	}

	presets.suppression.very_hard = deep_clone(presets.surrender.easy)	
	
	presets.suppression.very_hard = {
		panic_chance_mul = 0.5,
		duration = { 3, 5 },
		react_point = { 5, 7 },
		brown_point = { 8, 10 },
	}
	
	-- Enemy chatter
	presets.enemy_chatter.cop.aggressive = true
	presets.enemy_chatter.cop.go_go = true
	presets.enemy_chatter.cop.contact = true
	presets.enemy_chatter.cop.flank = true
	presets.enemy_chatter.cop.open_fire = true
	presets.enemy_chatter.cop.watch_background = true
	presets.enemy_chatter.cop.hostage_delay = true
	presets.enemy_chatter.cop.get_hostages = true
	presets.enemy_chatter.cop.get_loot = true
	presets.enemy_chatter.cop.group_death = true
	presets.enemy_chatter.cop.idle = true
	presets.enemy_chatter.cop.report = true

	presets.enemy_chatter.swat.push = true
	presets.enemy_chatter.swat.flank = true
	presets.enemy_chatter.swat.flash_grenade = true
	presets.enemy_chatter.swat.open_fire = true
	presets.enemy_chatter.swat.watch_background = true
	presets.enemy_chatter.swat.hostage_delay = true
	presets.enemy_chatter.swat.get_hostages = true
	presets.enemy_chatter.swat.get_loot = true
	presets.enemy_chatter.swat.group_death = true

	presets.enemy_chatter.gangster = {
		aggressive = true,
		contact = true,
		go_go = true,
	}

	presets.enemy_chatter.security = {
		aggressive = true,
		go_go = true,
		contact = true,
		suppress = true,
		idle = true,
		report = true,
	}

	return presets
end

Hooks:PostHook(CharacterTweakData, "init", "eclipse_init", function(self)
	self._prefix_data_p1 = {
		cop = function()
			return self._unit_prefixes.cop
		end,
		swat = function()
			return self._unit_prefixes.swat
		end,
		heavy_swat = function()
			return self._unit_prefixes.heavy_swat
		end,
		taser = function()
			return self._unit_prefixes.taser
		end,
		cloaker = function()
			return self._unit_prefixes.cloaker
		end,
		bulldozer = function()
			return self._unit_prefixes.bulldozer
		end,
		medic = function()
			return self._unit_prefixes.medic
		end,
	}

	self.security.chatter = self.presets.enemy_chatter.security

	self.security_undominatable.chatter = self.presets.enemy_chatter.security

	self.gensec.speech_prefix_p1 = self._unit_prefixes.cop
	self.gensec.dodge = self.presets.dodge.poor
	self.gensec.chatter = self.presets.enemy_chatter.security

	self.security_mex.chatter = self.presets.enemy_chatter.security

	self.security_mex_no_pager.chatter = self.presets.enemy_chatter.security

	self.cop.speech_prefix_p1 = self._unit_prefixes.cop

	self.cop_scared.speech_prefix_p1 = self._unit_prefixes.cop

	self.fbi.speech_prefix_p1 = self._unit_prefixes.cop
	self.fbi.dodge = self.presets.dodge.average

	self.fbi_female = deep_clone(self.cop_female)
	self.fbi_female.dodge = self.presets.dodge.average

	self.gangster.speech_prefix_p1 = "lt"
	self.gangster.speech_prefix_p2 = nil
	self.gangster.speech_prefix_count = 2

	self.mobster.speech_prefix_p1 = "rt"
	self.mobster.speech_prefix_p2 = nil
	self.mobster.speech_prefix_count = 2
	self.mobster.chatter = self.presets.enemy_chatter.gangster

	self.biker.melee_weapon = "knife_1"
	self.biker.speech_prefix_p1 = "bik"
	self.biker.speech_prefix_p2 = nil
	self.biker.speech_prefix_count = 2
	self.biker.chatter = self.presets.enemy_chatter.gangster

	self.biker_female.chatter = self.presets.enemy_chatter.gangster
	self.biker_escape.chatter = self.presets.enemy_chatter.gangster
	self.bolivian.chatter = self.presets.enemy_chatter.gangster
	self.bolivian_indoors.chatter = self.presets.enemy_chatter.gangster

	self.swat.HEALTH_INIT = 20
	self.swat.headshot_dmg_mul = 2 -- 100 head health
	self.swat.speech_prefix_p2 = "n"
	self.swat.surrender = self.presets.surrender.average
	self.swat.suppression = self.presets.suppression.average

	self.heavy_swat.HEALTH_INIT = 30
	self.heavy_swat.headshot_dmg_mul = 1.875 -- 160 head health
	self.heavy_swat.surrender = self.presets.surrender.average
	self.heavy_swat.suppression = self.presets.suppression.average
	self.heavy_swat.damage.hurt_severity = self.presets.hurt_severities.no_heavy_hurt

	self.fbi_swat.HEALTH_INIT = 24
	self.fbi_swat.headshot_dmg_mul = 2 -- 120 head health
	self.fbi_swat.speech_prefix_p2 = "n"
	self.fbi_swat.surrender = self.presets.surrender.average
	self.fbi_swat.suppression = self.presets.suppression.average

	self.fbi_heavy_swat.HEALTH_INIT = 36
	self.fbi_heavy_swat.headshot_dmg_mul = 1.5 -- 240 head health
	self.fbi_heavy_swat.surrender = self.presets.surrender.hard
	self.fbi_heavy_swat.suppression = self.presets.suppression.hard
	self.fbi_heavy_swat.damage.hurt_severity = self.presets.hurt_severities.no_heavy_hurt

	self.city_swat.HEALTH_INIT = 28
	self.city_swat.headshot_dmg_mul = 1.75 -- 160 head health
	self.city_swat.speech_prefix_p2 = "n"
	self.city_swat.surrender = self.presets.surrender.hard
	self.city_swat.suppression = self.presets.suppression.hard

	self.zeal_swat = deep_clone(self.city_swat)
	self.zeal_swat.HEALTH_INIT = 32
	self.zeal_swat.headshot_dmg_mul = 1.6 -- 200 head health
	--self.zeal_swat.dodge = self.presets.dodge.ninja
	self.zeal_swat.surrender = self.presets.surrender.very_hard
	self.zeal_swat.suppression = self.presets.suppression.hard
	self.zeal_swat.move_speed_mul = { walk = 1.1, run = 1.1 }

	self.zeal_heavy_swat = deep_clone(self.fbi_heavy_swat)
	self.zeal_heavy_swat.HEALTH_INIT = 48
	self.zeal_heavy_swat.headshot_dmg_mul = 1.5 -- 320 head health
	self.zeal_heavy_swat.surrender = self.presets.surrender.very_hard
	self.zeal_heavy_swat.suppression = self.presets.suppression.very_hard
	self.zeal_heavy_swat.move_speed_mul = { walk = 1.1, run = 1.1 }

	self.sniper.HEALTH_INIT = 8
	self.sniper.headshot_dmg_mul = 4 -- 20 head health
	self.sniper.speech_prefix_p1 = self._unit_prefixes.cop

	self.shield.HEALTH_INIT = 30
	self.shield.headshot_dmg_mul = 1.875 -- 160 head health
	self.shield.move_speed.crouch = self.shield.move_speed.stand
	self.shield.speech_prefix_p1 = self._unit_prefixes.heavy_swat
	self.shield.min_obj_interrupt_dis = 500
	self.shield.shield_explosion_damage_mul = 0.8 -- % of damage blocked by the Shield opeator's shield
	self.shield.damage.hurt_severity = self.presets.hurt_severities.only_explosion_and_light_hurt
	self.shield.spawn_sound_event = "shield_identification" --BANG BANG BANG!!!!
	self.shield.die_sound_event = nil --he already has his death sound

	self.fbi_shield = deep_clone(self.shield)
	self.fbi_shield.HEALTH_INIT = 30
	self.fbi_shield.headshot_dmg_mul = 1.875 -- 160 head health
	self.fbi_shield.shield_explosion_damage_mul = 0.6

	self.zeal_shield = deep_clone(self.fbi_shield)
	self.zeal_shield.speech_prefix_p1 = "l5d" -- that's my homie L5D!
	self.zeal_shield.speech_prefix_p2 = nil
	self.zeal_shield.speech_prefix_count = nil
	self.zeal_shield.spawn_sound_event = "hos_shield_indication_sound_terminator_style" --Come with me if you wanna live...
	self.zeal_shield.spawn_sound_event_2 = "l5d_mov" --MOOOOVE!!!!!!!!!
	self.zeal_shield.shield_explosion_damage_mul = 0.4
	self.zeal_shield.move_speed_mul = { walk = 1.1, run = 1.1 }
	table.insert(self._enemy_list, "zeal_shield")
	
	self.taser.HEALTH_INIT = 72
	self.taser.headshot_dmg_mul = 2 -- 360 head health
	self.taser.min_obj_interrupt_dis = 1000
	self.taser.damage.hurt_severity = self.presets.hurt_severities.base
	self.taser.spawn_sound_event = self._prefix_data_p1.taser() .. "_entrance" --tazeah coming through!!!

	self.zeal_taser = deep_clone(self.taser)
	self.zeal_taser.HEALTH_INIT = 72
	self.zeal_taser.headshot_dmg_mul = 2 -- 360 head health
	self.zeal_taser.spawn_sound_event = self._prefix_data_p1.taser() .. "_elite" --elite tazeah coming through!!!
	self.zeal_taser.move_speed_mul = { walk = 1.1, run = 1.1 }
	table.insert(self._enemy_list, "zeal_taser")
	
	self.tank.HEALTH_INIT = 800
	self.tank.headshot_dmg_mul = 25 -- 320 head health
	self.tank.ecm_vulnerability = 0
	self.tank.min_obj_interrupt_dis = 600
	self.tank.damage.hurt_severity = self.presets.hurt_severities.only_light_hurt -- cool damage react thing
	self.tank.move_speed.stand.run.cbt = self.tank.move_speed.stand.walk.cbt
	self.tank.spawn_sound_event = self._prefix_data_p1.bulldozer() .. "_entrance" -- bulldozah coming through!!!
	self.tank.melee_weapon = "weapon"
	
	self.tank_elite = deep_clone(self.tank)
	self.tank_elite.move_speed_mul = { walk = 0.85, run = 0.85 }
	self.tank_elite.spawn_sound_event = self._prefix_data_p1.bulldozer() .. "_entrance_elite" -- elite bulldozah coming through!!!
	table.insert(self._enemy_list, "tank_elite")

	self.spooc.HEALTH_INIT = 48
	self.spooc.headshot_dmg_mul = 3 -- 160 head health
	self.spooc.min_obj_interrupt_dis = 800
	self.spooc.spooc_attack_use_smoke_chance = 0
	self.spooc.spooc_charge_move_speed_mul = 1.75
	self.spooc.damage.hurt_severity = self.presets.hurt_severities.only_light_hurt_and_fire
	self.spooc.use_animation_on_fire_damage = true
	self.spooc.melee_weapon = "baton"
	self.spooc.spawn_sound_event_2 = "clk_c01x_plu" --*WOOOSH*

	self.medic.HEALTH_INIT = 48
	self.medic.headshot_dmg_mul = 2 -- 320 head health
	self.medic.damage.hurt_severity = self.presets.hurt_severities.base
	self.medic.use_animation_on_fire_damage = true
	self.medic.can_be_healed = false
	self.medic.melee_weapon = "weapon"

	self.zeal_medic = deep_clone(self.medic)
	self.zeal_medic.HEALTH_INIT = 48
	self.zeal_medic.headshot_dmg_mul = 2 -- 240 head health
	self.zeal_medic.spawn_sound_event = self._prefix_data_p1.medic() .. "_g90" --You chose the wrong career, asshole! (More aggresive spawn voicelines)
	self.zeal_medic.move_speed_mul = { walk = 1.1, run = 1.1 }
	table.insert(self._enemy_list, "zeal_medic")

	self.phalanx_minion.HEALTH_INIT = 60
	self.phalanx_minion.headshot_dmg_mul = 1.875 -- 320 head health
	self.phalanx_minion.min_obj_interrupt_dis = 500
	self.phalanx_minion.shield_explosion_damage_mul = 0.2
	self.phalanx_minion.move_speed.crouch = self.phalanx_minion.move_speed.stand
	self.phalanx_minion.damage.hurt_severity = self.presets.hurt_severities.only_light_hurt
	self.phalanx_minion.speech_prefix_p1 = "dont_be_dumb"
	self.phalanx_minion.speech_prefix_p2 = nil
	self.phalanx_minion.speech_prefix_count = nil
	self.phalanx_minion.die_sound_event = "shd_x02a_any_3p_01" --PDTH SWAT SCREEEAM!!!!!!
	self.phalanx_minion.spawn_sound_event = "hos_shield_indication_sound_terminator_style" --DUN..DUN..DUN....DUN..DUN..DUN!!
	self.phalanx_minion.spawn_sound_event_2 = "shd_mov" --Holy shit! PDTH SWAT voice in PD2?!
	self.phalanx_minion.access = "shield"

	self.phalanx_minion_break = deep_clone(self.phalanx_minion)
	self.phalanx_minion_break.tags = { "law", "shield" }
	self.phalanx_minion_break.move_speed = self.presets.move_speed.fast
	self.phalanx_minion_break.allowed_stances = nil
	self.phalanx_minion_break.allowed_poses = nil
	self.phalanx_minion_break.no_equip_anim = nil
	self.phalanx_minion_break.no_run_start = nil
	self.phalanx_minion_break.no_run_stop = nil
	self.phalanx_minion_break.always_face_enemy = nil
	self.phalanx_minion_break.wall_fwd_offset = nil
	self.phalanx_minion_break.priority_shout = nil
	self.phalanx_minion_break.dodge = self.presets.dodge.athletic
	self.phalanx_minion_break.access = "swat"
	self.phalanx_minion_break.chatter = self.presets.enemy_chatter.swat
	self.phalanx_minion_break.announce_incomming = nil
	self.phalanx_minion_break.damage.hurt_severity = self.presets.hurt_severities.base
	self.phalanx_minion_break.use_animation_on_fire_damage = nil
	self.phalanx_minion_break.damage.shield_knocked = nil
	self.phalanx_minion_break.tmp_invulnerable_on_tweak_change = 0.25
	table.insert(self._enemy_list, "phalanx_minion_break")

	self.mobster_boss.HEALTH_INIT = 200
	self.mobster_boss.headshot_dmg_mul = 2
	self.mobster_boss.no_headshot_add_mul = true
	self.mobster_boss.damage.hurt_severity = self.presets.hurt_severities.only_light_hurt

	self.chavez_boss.HEALTH_INIT = 200
	self.chavez_boss.headshot_dmg_mul = 2
	self.chavez_boss.no_headshot_add_mul = true
	self.chavez_boss.damage.hurt_severity = self.presets.hurt_severities.only_light_hurt

	self.hector_boss.HEALTH_INIT = 300
	self.hector_boss.headshot_dmg_mul = 2
	self.hector_boss.no_headshot_add_mul = true
	self.hector_boss.damage.hurt_severity = self.presets.hurt_severities.only_light_hurt
	self.hector_boss.throwable = "frag"
	self.hector_boss.throwable_cooldown = 15

	self.biker_boss.HEALTH_INIT = 300
	self.biker_boss.headshot_dmg_mul = 2
	self.biker_boss.no_headshot_add_mul = true
	self.biker_boss.damage.hurt_severity = self.presets.hurt_severities.only_light_hurt
	self.biker_boss.throwable = "concussion"
	self.biker_boss.throwable_cooldown = 10

	self.drug_lord_boss.HEALTH_INIT = 300
	self.drug_lord_boss.headshot_dmg_mul = 2
	self.drug_lord_boss.no_headshot_add_mul = true
	self.drug_lord_boss.damage.hurt_severity = self.presets.hurt_severities.only_light_hurt
	self.drug_lord_boss.throwable = "launcher_m203"
	self.drug_lord_boss.throwable_target_verified = true
	self.drug_lord_boss.throwable_cooldown = 10

	self.triad_boss.HEALTH_INIT = 300
	self.triad_boss.player_health_scaling_mul = 1.5
	self.triad_boss.headshot_dmg_mul = 2
	self.triad_boss.no_headshot_add_mul = true
	self.triad_boss.damage.hurt_severity = self.presets.hurt_severities.only_light_hurt
	self.triad_boss.bullet_damage_only_from_front = nil
	self.triad_boss.invulnerable_to_slotmask = nil
	self.triad_boss.throwable_target_verified = false
	self.triad_boss.throwable_cooldown = 20

	self.deep_boss.HEALTH_INIT = 400
	self.deep_boss.headshot_dmg_mul = 2
	self.deep_boss.ignore_headshot = false
	self.deep_boss.no_headshot_add_mul = true
	self.deep_boss.damage.hurt_severity = self.presets.hurt_severities.only_light_hurt

	-- escort speed stuff
	self.escort_cfo.move_speed = self.presets.move_speed.escort_normal
	self.escort_chinese_prisoner.move_speed = self.presets.move_speed.escort_slow
	self.escort_sand.move_speed = self.presets.move_speed.escort_slow
	self.spa_vip.move_speed = self.presets.move_speed.escort_normal
	self.escort_undercover.move_speed = self.presets.move_speed.escort_slow

	if self._unit_prefixes.heavy_swat == "l" then
		self.zeal_swat.speech_prefix_p2 = "d"
		self.zeal_swat.speech_prefix_count = 4
		self.heavy_swat.speech_prefix_p2 = "d"
		self.heavy_swat.speech_prefix_count = 4
		self.fbi_heavy_swat.speech_prefix_p2 = "d"
		self.fbi_heavy_swat.speech_prefix_count = 4
		self.zeal_heavy_swat.speech_prefix_p2 = "d"
		self.zeal_heavy_swat.speech_prefix_count = 4
		self.shield.speech_prefix_p2 = "d"
		self.shield.speech_prefix_count = 4
		self.fbi_shield.speech_prefix_p2 = "d"
		self.fbi_shield.speech_prefix_count = 4
		self.phalanx_minion.speech_prefix_p2 = "d"
		self.phalanx_minion.speech_prefix_count = 4
		self.phalanx_minion_break.speech_prefix_p2 = "d"
		self.phalanx_minion_break.speech_prefix_count = 4
		self.zeal_shield.speech_prefix_p2 = "d"
		self.zeal_shield.speech_prefix_count = 4
	end
end)

-- Add new enemies to the character map
local character_map_original = CharacterTweakData.character_map
function CharacterTweakData:character_map(...)
	local char_map = character_map_original(self, ...)

	table.insert(char_map.gitgud.list, "ene_zeal_swat_2")
	table.insert(char_map.gitgud.list, "ene_zeal_swat_heavy_2")
	table.insert(char_map.gitgud.list, "ene_zeal_medic_m4")
	table.insert(char_map.gitgud.list, "ene_zeal_medic_r870")

	return char_map
end

-- Add new weapons
Hooks:PostHook(CharacterTweakData, "_create_table_structure", "sh__create_table_structure", function(self)
	table.insert(self.weap_ids, "r870_tank")
	table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_r870_bulldozer/wpn_npc_r870_bulldozer"))

	table.insert(self.weap_ids, "aa12")
	table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_aa12/wpn_npc_aa12"))

	table.insert(self.weap_ids, "aa12_tank")
	table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_aa12_bulldozer/wpn_npc_aa12_bulldozer"))

	table.insert(self.weap_ids, "m249_tank")
	table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_m249_bulldozer/wpn_npc_m249_bulldozer"))

	table.insert(self.weap_ids, "benelli_tank")
	table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_benelli_bulldozer/wpn_npc_benelli_bulldozer"))

	table.insert(self.weap_ids, "shepheard")
	table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_shepheard/wpn_npc_shepheard"))

	table.insert(self.weap_ids, "ksg")
	table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_ksg/wpn_npc_ksg"))

	table.insert(self.weap_ids, "s552_zeal")
	table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_s552/wpn_npc_s552_zeal"))

	table.insert(self.weap_ids, "g3")
	table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_g3/wpn_npc_g3"))
end)

-- fixed movement speed difficulty scaling
-- thanks redflame
function CharacterTweakData:_multiply_all_speeds(walk_mul, run_mul)
	for preset_name, preset in pairs(self.presets.move_speed) do
		if preset_name ~= "civ_fast" and preset_name ~= "escort_slow" and preset_name ~= "escort_normal" then
			for _, pose in pairs(preset) do
				for haste_name, haste in pairs(pose) do
					for stance_name, stance in pairs(haste) do
						if stance_name ~= "ntl" then
							for move_dir in pairs(stance) do
								stance[move_dir] = stance[move_dir] * (haste_name == "walk" and walk_mul or run_mul)
							end
						end
					end
				end
			end
		end
	end
end

CharacterTweakData.access_health = {
	security = 8,
	cop = 12,
	gangster = 16,
	fbi = 16,
}

CharacterTweakData.access_hs_mul = {
	security = 4,
	cop = 4,
	gangster = 4,
	fbi = 4,
}

CharacterTweakData.tweak_table_preset = {
	swat = "swat",
	heavy_swat = "swat",
	fbi_swat = "fbi_swat",
	fbi_heavy_swat = "fbi_swat",	
	fbi_swat = "fbi_swat",
	fbi_heavy_swat = "fbi_swat",	
	city_swat = "city_swat",	
	zeal_swat = "zeal_swat",
	zeal_heavy_swat = "zeal_swat",	
	shield = "shield",
	fbi_shield = "fbi_shield",
	zeal_shield = "zeal_shield",
	phalanx_minion = "elite_shield",	
	phalanx_minion_break = "elite_shield",
	sniper = "sniper",
	tank = "tank",
	tank_elite = "elite_tank",
	mobster_boss = "boss",
	chavez_boss = "boss",
	hector_boss = "boss",
	biker_boss = "boss",
	drug_lord_boss = "boss",
	triad_boss = "boss",
	deep_boss = "boss",
}

CharacterTweakData.access_preset = {
	security = "security",
	cop = "cop",
	gangster = "gangster",
	fbi = "fbi",
	taser = "taser",
	spooc = "cloaker",
}

CharacterTweakData.tweak_table_move_speed = {
	city_swat = "very_fast",
	zeal_swat = "very_fast",
	heavy_swat = "normal",
	fbi_heavy_swat = "normal",
	zeal_heavy_swat = "fast",
	medic = "normal",
	zeal_medic = "normal",
	heavy_swat_sniper = "fast",
	mobster_boss = "fast",
	chavez_boss = "fast",
	drug_lord_boss = "normal",
	triad_boss = "normal",
	hector_boss = "slow",
	biker_boss = "slow",
	deep_boss = "slow",
	tank = "very_slow",
	tank_elite = "very_slow",
}

CharacterTweakData.access_move_speed = {
	spooc = "lightning",
	swat = "fast",
	shield = "fast",
	fbi = "fast",
	gangster = "fast",
	taser = "normal",
	security = "normal",
	cop = "normal",
	sniper = "normal",
}

CharacterTweakData.access_surrender = {
	security = "easy",
	cop = "easy",
	fbi = "easy",
}

function CharacterTweakData:_set_presets()
	local health_mul_tbl = { 1, 1, 1.25, 1.5, 1.75, 2, 2, 2 }
	local health_mul = health_mul_tbl[diff_i]

	for _, name in pairs(self._enemy_list) do
		local char_preset = self[name]

		-- Set move speed based on the tweak table or access
		local move_speed_preset = self.tweak_table_move_speed[name] or self.access_move_speed[char_preset.access]

		if move_speed_preset then
			char_preset.move_speed = self.presets.move_speed[move_speed_preset] or self.presets.move_speed.normal
		end

		local surrender_preset = self.access_surrender[char_preset.access]
		
		if surrender_preset then
			char_preset.surrender = self.presets.surrender[surrender_preset]
		end
		
		local is_boss = name:match("_boss$")

		-- Set health and HS mul based on access
		if self.access_health[char_preset.access] and not is_boss then
			char_preset.HEALTH_INIT = self.access_health[char_preset.access]
		end

		if self.access_hs_mul[char_preset.access] and not is_boss then
			char_preset.headshot_dmg_mul = self.access_hs_mul[char_preset.access]
		end

		-- Boss related stuff
		if is_boss then
			char_preset.HEALTH_INIT = char_preset.HEALTH_INIT * health_mul
			char_preset.player_health_scaling_mul = 1.5
			char_preset.no_headshot_add_mul = true
			char_preset.no_run_start = true
			char_preset.no_run_stop = true
		end

		-- Remove damage clamps, they are not a fun or intuitive mechanic
		char_preset.DAMAGE_CLAMP_BULLET = nil
		char_preset.DAMAGE_CLAMP_EXPLOSION = nil
		
		if char_preset.damage and char_preset.damage.explosion_damage_mul then
			char_preset.damage.explosion_damage_mul = 1
		end
		
		if char_preset.surrender_break_time then
			char_preset.surrender_break_time = self.presets.base.surrender_break_time
		end

		char_preset.weapon = self.presets.weapon[self.tweak_table_preset[name] or self.access_preset[char_preset.access] or "base"]
	end

	self.tase_shock_strength = diff_lerp(4, 6)
	
	self.spooc.spooc_kick_damage = is_eclipse and 0.5 or 0.25
	self.shadow_spooc.spooc_kick_damage = self.spooc.spooc_kick_damage
	
	self.spooc.spooc_attack_timeout = { 
		diff_lerp(2, 4), 
		diff_lerp(4, 6),
	}
	self.shadow_spooc.shadow_spooc_attack_timeout = self.spooc.spooc_attack_timeout

	self.flashbang_multiplier = diff_lerp(1, 1.5)
	self.concussion_multiplier = 1

	self.phalanx_shield_balance_mul = { 1, 1.5, 2, 2.5 }

	local bulldozer_armor = diff_lerp(1, 2)
	local elite_bulldozer_armor = diff_lerp(2, 3)
	
	self.tank.armor_damage_mul = 1 / bulldozer_armor
	self.tank_elite.armor_damage_mul = 1 / elite_bulldozer_armor

	self.tank_armor_balance_mul = { 1, 1.5, 2, 2.5 }

	-- eclipse exclusive edits
	if is_eclipse then
		self:_multiply_all_speeds(1.1, 1.05)

		self.spooc.spooc_sound_events = { detect_stop = "cloaker_presence_stop", detect = "cloaker_presence_loop" } -- cloakers are silent
	end
end

CharacterTweakData._set_normal = CharacterTweakData._set_presets
CharacterTweakData._set_hard = CharacterTweakData._set_presets
CharacterTweakData._set_overkill = CharacterTweakData._set_presets
CharacterTweakData._set_overkill_145 = CharacterTweakData._set_presets
CharacterTweakData._set_easy_wish = CharacterTweakData._set_presets
