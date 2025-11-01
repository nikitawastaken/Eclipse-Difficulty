local lorefriendly_team_ai_weapons = Eclipse.settings.team_ai_weapons == 2
local classic_team_ai_weapons = Eclipse.settings.team_ai_weapons == 3

local level_id = Eclipse.utils.level_id()
local diff_i = Eclipse.utils.difficulty_index()
local diff_i_no_easy = Eclipse.utils.difficulty_index_no_easy()
local is_overkill = Eclipse.utils.is_overkill()
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_pro_job()

local bellmead_response_heists = {
	["corp"] = true,
	["deep"] = true,
}
local is_undercover = level_id == "man"
local is_no_mercy = level_id == "nmh"
local is_mountain_master = level_id == "pent"
local has_bellmead_response = bellmead_response_heists[level_id]

local diff_lerp = Eclipse.utils.diff_lerp

local weighted_selector = Eclipse.utils.weighted_selector

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
			for i, accuracy in pairs(falloff.acc) do
				falloff.acc[i] = math.min(1, accuracy * multiplier)
			end
		end
	end
end

local function recoil_multiplier(tbl, multiplier)
	for _, weapon in pairs(tbl) do
		for _, falloff in pairs(weapon.FALLOFF) do
			for i, recoil in pairs(falloff.recoil) do
				falloff.recoil[i] = recoil * multiplier
			end
		end
	end
end

local function burst_multiplier(tbl, multiplier)
	local function chk_apply_multiplier(t)
		if t.autofire_rounds then
			for i, autofire_rounds in pairs(t.autofire_rounds) do
				t.autofire_rounds[i] = math.max(1, math.ceil(autofire_rounds * multiplier))
			end
		end
	end

	for _, weapon in pairs(tbl) do
		chk_apply_multiplier(weapon)

		for _, falloff in pairs(weapon.FALLOFF) do
			chk_apply_multiplier(falloff)
		end
	end
end

local _presets_orig = CharacterTweakData._presets
function CharacterTweakData:_presets(tweak_data, ...)
	local presets = _presets_orig(self, tweak_data, ...)

	local dmg_mul_tbl = { 1, 1, 1, 1, 1, 1, 1, 1 }
	local dmg_mul = dmg_mul_tbl[diff_i]

	local special_dmg_mul_tbl = { 0.25, 0.5, 0.75, 1, 1, 1, 1, 1 }
	local special_dmg_mul = special_dmg_mul_tbl[diff_i]

	local aim_delay_tbl = { 1.2, 1, 0.8, 0.6, 0.5, 0.4, 0.4, 0.4 }
	local aim_delay_mul = aim_delay_tbl[diff_i]

	presets.weapon.base = based_on(presets.weapon.expert, {
		aim_delay = { 0, 1 },
		focus_delay = 0.6,
		melee_dmg = 8 * dmg_mul,
		melee_speed = 1,
		melee_retry_delay = { 2, 3 },
		melee_range = 125,
		melee_force = 400,
		range = { close = 750, optimal = 1500, far = 3000 },
		RELOAD_SPEED = 1,
	})

	presets.weapon.base.is_pistol.FALLOFF = {
		{ dmg_mul = 4 * dmg_mul, r = 0, acc = { 0.6, 0.9 }, recoil = { 0.15, 0.3 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 4 * dmg_mul, r = 3000, acc = { 0.1, 0.4 }, recoil = { 0.3, 0.6 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.akimbo_pistol.melee_dmg = nil
	presets.weapon.base.akimbo_pistol.melee_speed = nil
	presets.weapon.base.akimbo_pistol.melee_retry_delay = nil
	presets.weapon.base.akimbo_pistol.FALLOFF = {
		{ dmg_mul = 4 * dmg_mul, r = 0, acc = { 0.5, 0.8 }, recoil = { 0.1, 0.2 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 4 * dmg_mul, r = 3000, acc = { 0.1, 0.3 }, recoil = { 0.2, 0.4 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_revolver.range = { close = 1000, optimal = 2000, far = 4000 }
	presets.weapon.base.is_revolver.FALLOFF = {
		{ dmg_mul = 7.5 * dmg_mul, r = 0, acc = { 0.8, 1 }, recoil = { 0.75, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 7.5 * dmg_mul, r = 3000, acc = { 0.3, 0.6 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_sniper = deep_clone(presets.weapon.base.is_revolver)
	presets.weapon.base.is_sniper.range = { close = 2000, optimal = 3000, far = 5000 }
	presets.weapon.base.is_sniper.FALLOFF = {
		{ dmg_mul = 8 * dmg_mul, r = 0, acc = { 0.25, 0.75 }, recoil = { 1.5, 2 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 8 * dmg_mul, r = 2000, acc = { 0.5, 1 }, recoil = { 1.5, 2 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 8 * dmg_mul, r = 4000, acc = { 0.5, 1 }, recoil = { 1.5, 2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_shotgun_pump.RELOAD_SPEED = 1.5
	presets.weapon.base.is_shotgun_pump.range = { close = 500, optimal = 1000, far = 2000 }
	presets.weapon.base.is_shotgun_pump.FALLOFF = {
		{ dmg_mul = 7.5 * dmg_mul, r = 0, acc = { 0.8, 1 }, recoil = { 0.8, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 5 * dmg_mul, r = 1000, acc = { 0.7, 0.9 }, recoil = { 1, 1.4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 1 * dmg_mul, r = 2000, acc = { 0.6, 0.8 }, recoil = { 1.2, 1.8 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_shotgun_mag = deep_clone(presets.weapon.base.is_shotgun_pump)
	presets.weapon.base.is_shotgun_mag.RELOAD_SPEED = 1
	presets.weapon.base.is_shotgun_mag.autofire_rounds = { 1, 3 }
	presets.weapon.base.is_shotgun_mag.FALLOFF = {
		{ dmg_mul = 4.5 * dmg_mul, r = 0, acc = { 0.7, 0.9 }, recoil = { 0.4, 0.8 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 3 * dmg_mul, r = 1000, acc = { 0.5, 0.7 }, recoil = { 0.6, 1.2 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 1 * dmg_mul, r = 2000, acc = { 0.3, 0.5 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_double_barrel = deep_clone(presets.weapon.base.is_shotgun_pump)
	presets.weapon.base.is_double_barrel.RELOAD_SPEED = 6
	presets.weapon.base.is_double_barrel.FALLOFF = {
		{ dmg_mul = 7.5 * dmg_mul, r = 0, acc = { 0.8, 1 }, recoil = { 0.5, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 3 * dmg_mul, r = 2000, acc = { 0.6, 0.8 }, recoil = { 1, 1.4 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_rifle.autofire_rounds = { 1, 5 }
	presets.weapon.base.is_rifle.range = { close = 1000, optimal = 2000, far = 4000 }
	presets.weapon.base.is_rifle.FALLOFF = {
		{ dmg_mul = 3 * dmg_mul, r = 0, acc = { 0.6, 0.9 }, recoil = { 0.5, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 3 * dmg_mul, r = 3000, acc = { 0.2, 0.4 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_smg = deep_clone(presets.weapon.base.is_rifle)
	presets.weapon.base.is_smg.autofire_rounds = { 3, 8 }
	presets.weapon.base.is_smg.FALLOFF = {
		{ dmg_mul = 2 * dmg_mul, r = 0, acc = { 0.5, 0.8 }, recoil = { 0.4, 0.6 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 2 * dmg_mul, r = 3000, acc = { 0.1, 0.3 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_lmg = deep_clone(presets.weapon.base.is_smg)
	presets.weapon.base.is_lmg.autofire_rounds = { 10, 30 }
	presets.weapon.base.is_lmg.FALLOFF = {
		{ dmg_mul = 2 * dmg_mul, r = 0, acc = { 0.4, 0.7 }, recoil = { 0.7, 1.4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 2 * dmg_mul, r = 1000, acc = { 0.2, 0.6 }, recoil = { 0.8, 1.6 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 2 * dmg_mul, r = 3000, acc = { 0.1, 0.3 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.mini = deep_clone(presets.weapon.base.is_lmg)
	presets.weapon.base.mini.autofire_rounds = { 50, 200 }
	presets.weapon.base.mini.FALLOFF = {
		{ dmg_mul = 1.5 * dmg_mul, r = 0, acc = { 0.2, 0.4 }, recoil = { 0.7, 1.4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 1.5 * dmg_mul, r = 1000, acc = { 0.1, 0.3 }, recoil = { 0.8, 1.6 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 1.5 * dmg_mul, r = 3000, acc = { 0, 0.15 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.base.is_flamethrower.melee_dmg = nil
	presets.weapon.base.is_flamethrower.melee_speed = nil
	presets.weapon.base.is_flamethrower.melee_retry_delay = nil
	presets.weapon.base.is_flamethrower.RELOAD_SPEED = 0.6
	presets.weapon.base.is_flamethrower.autofire_rounds = { 20, 40 }
	presets.weapon.base.is_flamethrower.range = { close = 500, optimal = 1000, far = 2000 }
	presets.weapon.base.is_flamethrower.FALLOFF = {
		{ dmg_mul = 2 * dmg_mul, r = 0, acc = { 0.3, 0.5 }, recoil = { 0.4, 0.8 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 1 * dmg_mul, r = 1000, acc = { 0.1, 0.3 }, recoil = { 0.5, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 0 * dmg_mul, r = 2000, acc = { 0, 0.15 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.security = based_on(presets.weapon.base, {
		aim_delay = { 0, 1.25 },
		focus_delay = 0.8,
	})
	accuracy_multiplier(presets.weapon.security, 0.8)

	presets.weapon.security_fat = based_on(presets.weapon.security, {
		melee_dmg = 10 * dmg_mul,
		melee_force = 500,
	})
	damage_multiplier(presets.weapon.security_fat, 6 / 5)

	presets.weapon.cop = based_on(presets.weapon.base)

	presets.weapon.cop_fat = based_on(presets.weapon.cop, {
		melee_dmg = 10 * dmg_mul,
		melee_force = 500,
	})
	damage_multiplier(presets.weapon.cop_fat, 6 / 5)

	presets.weapon.gangster = based_on(presets.weapon.base, {
		range = { close = 500, optimal = 1000, far = 3000 },
	})

	damage_multiplier(presets.weapon.gangster, 6 / 4)
	accuracy_multiplier(presets.weapon.gangster, 0.6)
	recoil_multiplier(presets.weapon.gangster, 0.8)
	burst_multiplier(presets.weapon.gangster, 1.5)

	presets.weapon.swat = based_on(presets.weapon.base)

	presets.weapon.fbi = based_on(presets.weapon.base)

	damage_multiplier(presets.weapon.fbi, 6 / 4)

	presets.weapon.fbi_swat = based_on(presets.weapon.swat, {
		aim_delay = { 0, 0.75 },
		focus_delay = 0.4,
		melee_dmg = 12 * dmg_mul,
	})
	damage_multiplier(presets.weapon.fbi_swat, 6 / 5)
	accuracy_multiplier(presets.weapon.fbi_swat, 1.2)

	presets.weapon.elite_swat = based_on(presets.weapon.swat, {
		aim_delay = { 0, 0.5 },
		focus_delay = 0.2,
		melee_dmg = 16 * dmg_mul,
	})
	damage_multiplier(presets.weapon.elite_swat, 7 / 5)
	accuracy_multiplier(presets.weapon.elite_swat, 1.4)

	presets.weapon.zeal_swat = based_on(presets.weapon.elite_swat)

	presets.weapon.murky = based_on(presets.weapon.swat)
	damage_multiplier(presets.weapon.murky, 6 / 4)
	accuracy_multiplier(presets.weapon.murky, 1.4)
	recoil_multiplier(presets.weapon.murky, 1.2)
	burst_multiplier(presets.weapon.murky, 0.6)

	presets.weapon.security_mcmansion = based_on(presets.weapon.murky)

	presets.weapon.marshal_security = based_on(presets.weapon.murky)

	presets.weapon.soldier = based_on(presets.weapon.fbi_swat)

	presets.weapon.shield = based_on(presets.weapon.base, {
		melee_range = 150,
		melee_force = 500,
		melee_retry_delay = { 1, 2 },
		range = { close = 500, optimal = 1000, far = 2000 },
	})

	presets.weapon.shield.is_pistol.FALLOFF = {
		{ dmg_mul = 3 * dmg_mul, r = 0, acc = { 0.4, 0.8 }, recoil = { 0.2, 0.4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 3 * dmg_mul, r = 1500, acc = { 0.3, 0.6 }, recoil = { 0.3, 0.5 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 3 * dmg_mul, r = 3000, acc = { 0.1, 0.3 }, recoil = { 0.4, 0.6 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.shield.is_smg.FALLOFF = {
		{ dmg_mul = 2 * dmg_mul, r = 0, acc = { 0.4, 0.8 }, recoil = { 0.4, 0.8 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 2 * dmg_mul, r = 1500, acc = { 0.3, 0.6 }, recoil = { 0.6, 1.2 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 2 * dmg_mul, r = 3000, acc = { 0.1, 0.3 }, recoil = { 1, 1.6 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.fbi_shield = based_on(presets.weapon.shield)

	presets.weapon.elite_shield = based_on(presets.weapon.swat)

	presets.weapon.elite_shield.is_revolver.melee_range = 175
	presets.weapon.elite_shield.is_revolver.melee_force = 600
	presets.weapon.elite_shield.is_revolver.melee_retry_delay = { 1, 2 }
	presets.weapon.elite_shield.is_revolver.range = { close = 500, optimal = 1000, far = 2000 }
	presets.weapon.elite_shield.is_revolver.FALLOFF = {
		{ dmg_mul = 6 * dmg_mul, r = 0, acc = { 0.6, 0.9 }, recoil = { 0.3, 0.6 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 6 * dmg_mul, r = 1500, acc = { 0.5, 0.8 }, recoil = { 0.5, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 6 * dmg_mul, r = 3000, acc = { 0.3, 0.6 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.elite_shield.is_shotgun_mag.range = { close = 750, optimal = 1500, far = 3000 }
	presets.weapon.elite_shield.is_shotgun_mag.FALLOFF = {
		{ dmg_mul = 4.5 * dmg_mul, r = 0, acc = { 0.7, 0.9 }, recoil = { 0.3, 0.6 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 3, 5 } },
		{ dmg_mul = 3 * dmg_mul, r = 1000, acc = { 0.5, 0.7 }, recoil = { 0.4, 0.8 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 2, 3 } },
		{ dmg_mul = 1.5 * dmg_mul, r = 2000, acc = { 0.3, 0.5 }, recoil = { 0.6, 1.2 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 1, 2 } },
	}

	presets.weapon.zeal_shield = based_on(presets.weapon.shield)

	presets.weapon.sniper = based_on(presets.weapon.swat)

	local cs_sniper_aim_delay_mul = aim_delay_mul ^ 0.6
	local elite_sniper_aim_delay_mul = aim_delay_mul ^ 1.25

	presets.weapon.sniper.is_sniper.aim_delay = {
		1 * cs_sniper_aim_delay_mul,
		2 * cs_sniper_aim_delay_mul,
	}
	presets.weapon.sniper.is_sniper.focus_delay = presets.weapon.base.is_sniper.focus_delay * cs_sniper_aim_delay_mul
	presets.weapon.sniper.is_sniper.range = { close = 5000, optimal = 10000, far = 15000 }
	presets.weapon.sniper.is_sniper.FALLOFF = {
		{ dmg_mul = 14 * special_dmg_mul, r = 0, acc = { 0.25, 0.75 }, recoil = { 3, 4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 14 * special_dmg_mul, r = 1000, acc = { 0.5, 1 }, recoil = { 3, 4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 14 * special_dmg_mul, r = 4000, acc = { 0.5, 1 }, recoil = { 3, 4 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.fbi_sniper = based_on(presets.weapon.sniper)

	presets.weapon.fbi_sniper.is_sniper.aim_delay = {
		1 * aim_delay_mul,
		2 * aim_delay_mul,
	}
	presets.weapon.fbi_sniper.is_sniper.focus_delay = presets.weapon.base.is_sniper.focus_delay * aim_delay_mul
	presets.weapon.fbi_sniper.is_sniper.FALLOFF = {
		{ dmg_mul = 20 * special_dmg_mul, r = 0, acc = { 0.25, 0.75 }, recoil = { 3, 4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 20 * special_dmg_mul, r = 1000, acc = { 0.5, 1 }, recoil = { 3, 4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 20 * special_dmg_mul, r = 4000, acc = { 0.5, 1 }, recoil = { 3, 4 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.elite_sniper = based_on(presets.weapon.swat)

	presets.weapon.elite_sniper.is_sniper.aim_delay = {
		1 * elite_sniper_aim_delay_mul,
		2 * elite_sniper_aim_delay_mul,
	}
	presets.weapon.elite_sniper.is_sniper.focus_delay = presets.weapon.base.is_sniper.focus_delay * elite_sniper_aim_delay_mul
	presets.weapon.elite_sniper.is_sniper.range = { close = 2000, optimal = 3000, far = 5000 }
	presets.weapon.elite_sniper.is_sniper.FALLOFF = {
		{ dmg_mul = 8 * special_dmg_mul, r = 0, acc = { 0.25, 0.75 }, recoil = { 0.5, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 8 * special_dmg_mul, r = 1000, acc = { 0.5, 1 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 8 * special_dmg_mul, r = 4000, acc = { 0.5, 1 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.taser = based_on(presets.weapon.swat, {
		aim_delay_tase = {
			0.5 * aim_delay_mul,
			1 * aim_delay_mul,
		},
		tase_sphere_cast_radius = 15,
		tase_distance = 1400,
	})

	presets.weapon.taser.is_rifle.autofire_rounds = nil
	presets.weapon.taser.is_rifle.FALLOFF = {
		{ dmg_mul = 4 * dmg_mul, r = 0, acc = { 0.7, 1 }, recoil = { 0.2, 0.4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 4 * dmg_mul, r = 3000, acc = { 0.3, 0.5 }, recoil = { 0.6, 0.8 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.taser.is_shotgun_pump.FALLOFF = {
		{ dmg_mul = 7.5 * dmg_mul, r = 0, acc = { 0.8, 1 }, recoil = { 0.8, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 6 * dmg_mul, r = 1000, acc = { 0.7, 0.9 }, recoil = { 1, 1.4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 4.5 * dmg_mul, r = 2000, acc = { 0.6, 0.8 }, recoil = { 1.2, 1.8 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.medic = based_on(presets.weapon.swat, {
		range = { close = 1500, optimal = 2500, far = 4000 },
	})
	damage_multiplier(presets.weapon.medic, 4 / 5)

	presets.weapon.cloaker = based_on(presets.weapon.swat)

	presets.weapon.cloaker.is_pistol.FALLOFF = {
		{ dmg_mul = 4 * dmg_mul, r = 0, acc = { 0.8, 1 }, recoil = { 0.2, 0.3 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 4 * dmg_mul, r = 3000, acc = { 0.3, 0.5 }, recoil = { 0.4, 0.6 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.cloaker.is_smg.FALLOFF = {
		{ dmg_mul = 2 * dmg_mul, r = 0, acc = { 0.6, 0.8 }, recoil = { 0.4, 0.6 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 2 * dmg_mul, r = 3000, acc = { 0.2, 0.3 }, recoil = { 1, 1.6 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.bulldozer = based_on(presets.weapon.base, {
		aim_delay = { 0, 2 },
		melee_dmg = 30 * special_dmg_mul,
		melee_force = 600,
	})

	presets.weapon.bulldozer.is_smg.range = { close = 1500, optimal = 2500, far = 4000 }

	presets.weapon.bulldozer.is_shotgun_pump.RELOAD_SPEED = 1
	presets.weapon.bulldozer.is_shotgun_pump.FALLOFF = {
		{ dmg_mul = 30 * special_dmg_mul, r = 0, acc = { 0.8, 1 }, recoil = { 1.5, 2 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 15 * special_dmg_mul, r = 1000, acc = { 0.7, 0.9 }, recoil = { 1.5, 2 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 5 * special_dmg_mul, r = 2000, acc = { 0.6, 0.8 }, recoil = { 1.5, 2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.bulldozer.is_shotgun_mag.RELOAD_SPEED = 0.8
	presets.weapon.bulldozer.is_shotgun_mag.FALLOFF = {
		{ dmg_mul = 6 * dmg_mul, r = 0, acc = { 0.7, 0.9 }, recoil = { 0.4, 0.8 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 4, 6 } },
		{ dmg_mul = 4.5 * dmg_mul, r = 1000, acc = { 0.5, 0.7 }, recoil = { 0.6, 0.9 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 2, 4 } },
		{ dmg_mul = 3 * dmg_mul, r = 2000, acc = { 0.3, 0.5 }, recoil = { 0.8, 1.2 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 1, 2 } },
	}

	presets.weapon.bulldozer.is_lmg.RELOAD_SPEED = 0.5
	presets.weapon.bulldozer.is_lmg.autofire_rounds = { 20, 50 }
	presets.weapon.bulldozer.is_lmg.FALLOFF = {
		{ dmg_mul = 3 * dmg_mul, r = 0, acc = { 0.6, 0.8 }, recoil = { 0.5, 0.8 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 3 * dmg_mul, r = 1000, acc = { 0.4, 0.6 }, recoil = { 0.8, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 3 * dmg_mul, r = 3000, acc = { 0.1, 0.3 }, recoil = { 1, 1.6 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.bulldozer.is_flamethrower.melee_dmg = nil
	presets.weapon.bulldozer.is_flamethrower.melee_speed = nil
	presets.weapon.bulldozer.is_flamethrower.melee_retry_delay = nil
	presets.weapon.bulldozer.is_flamethrower.FALLOFF = {
		{ dmg_mul = 3 * dmg_mul, r = 0, acc = { 0.3, 0.5 }, recoil = { 0.4, 0.8 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 2 * dmg_mul, r = 1000, acc = { 0.1, 0.3 }, recoil = { 0.5, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 0 * dmg_mul, r = 2000, acc = { 0, 0.15 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.headless_bulldozer = based_on(presets.weapon.bulldozer, {
		melee_speed = 0.5,
		melee_range = 200,
	})

	presets.weapon.elite_bulldozer = based_on(presets.weapon.bulldozer)

	presets.weapon.elite_bulldozer.is_shotgun_pump.FALLOFF = {
		{ dmg_mul = 20 * special_dmg_mul, r = 0, acc = { 0.7, 0.9 }, recoil = { 0.8, 1.4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 10 * special_dmg_mul, r = 1000, acc = { 0.5, 0.7 }, recoil = { 0.8, 1.4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 5 * special_dmg_mul, r = 2000, acc = { 0.3, 0.5 }, recoil = { 0.8, 1.4 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.elite_bulldozer.is_lmg.RELOAD_SPEED = 0.5
	presets.weapon.elite_bulldozer.is_lmg.autofire_rounds = { 20, 50 }
	presets.weapon.elite_bulldozer.is_lmg.FALLOFF = {
		{ dmg_mul = 3 * dmg_mul, r = 0, acc = { 0.6, 0.8 }, recoil = { 0.5, 0.8 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 3 * dmg_mul, r = 1000, acc = { 0.4, 0.6 }, recoil = { 0.8, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 3 * dmg_mul, r = 3000, acc = { 0.1, 0.3 }, recoil = { 1, 1.6 }, mode = { 1, 0, 0, 0 } },
	}

	presets.weapon.boss = based_on(presets.weapon.base)

	presets.weapon.gang_member = based_on(presets.weapon.base, {
		aim_delay = { 0, 0.25 },
		focus_delay = 0,
		melee_dmg = 10,
	})

	for _, v in pairs(presets.weapon.gang_member) do
		v.FALLOFF = {
			{ dmg_mul = 6, r = 0, acc = { 0.5, 1 }, recoil = v.FALLOFF[1].recoil, mode = { 1, 0, 0, 0 } },
			{ dmg_mul = 4, r = 1500, acc = { 0.25, 0.75 }, recoil = v.FALLOFF[1].recoil, mode = { 1, 0, 0, 0 } },
			{ dmg_mul = 2, r = 3000, acc = { 0, 0.5 }, recoil = v.FALLOFF[1].recoil, mode = { 1, 0, 0, 0 } },
		}
	end

	presets.weapon.gang_member.is_flamethrower.no_autofire_stop = true
	presets.weapon.gang_member.is_lmg.no_autofire_stop = true
	presets.weapon.gang_member.mini.no_autofire_stop = true

	presets.move_speed.normal = {
		stand = {
			walk = {
				ntl = { fwd = 160, strafe = 120, bwd = 100 },
				cbt = { fwd = 220, strafe = 180, bwd = 160 },
				hos = { fwd = 220, strafe = 180, bwd = 160 },
			},
			run = {
				cbt = { fwd = 400, strafe = 240, bwd = 240 },
				hos = { fwd = 450, strafe = 300, bwd = 240 },
			},
		},
		crouch = {
			walk = {
				cbt = { fwd = 200, strafe = 140, bwd = 120 },
				hos = { fwd = 200, strafe = 140, bwd = 120 },
			},
			run = {
				cbt = { fwd = 300, strafe = 240, bwd = 200 },
				hos = { fwd = 360, strafe = 240, bwd = 200 },
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
	speed_multiplier(presets.move_speed.fast, 1.2)
	speed_multiplier(presets.move_speed.very_fast, 1.3)
	speed_multiplier(presets.move_speed.lightning, 1.4)

	for speed_preset_name, poses in pairs(presets.move_speed) do
		for pose, hastes in pairs(poses) do
			hastes.run.ntl = hastes.run.hos
		end

		poses.crouch.walk.ntl = poses.crouch.walk.hos
		poses.crouch.run.ntl = poses.crouch.run.hos
		poses.stand.run.ntl = poses.stand.run.hos
		poses.panic = poses.stand
	end

	presets.gang_member_damage.HEALTH_INIT = (72 + math.floor(diff_i_no_easy / 2) * 28) * (UsefulBots and 0.75 or 1) * (Keepers and 0.75 or 1)
	presets.gang_member_damage.HEALTH_REGEN = presets.gang_member_damage.HEALTH_INIT * 0.1
	presets.gang_member_damage.MIN_DAMAGE_INTERVAL = 0.35
	presets.gang_member_damage.REGENERATE_TIME = 5
	presets.gang_member_damage.REGENERATE_TIME_AWAY = presets.gang_member_damage.REGENERATE_TIME
	presets.gang_member_damage.hurt_severity.bullet = {
		health_reference = "full",
		zones = {
			{
				health_limit = 0.4,
				none = 0.6,
				light = 0.4,
			},
			{
				light = 1,
			},
		},
	}

	-- escort speed stuff
	presets.move_speed.escort_normal = deep_clone(presets.move_speed.normal)
	presets.move_speed.escort_slow = deep_clone(presets.move_speed.slow)

	-- Tweak dodge presets
	presets.dodge.heavy.occasions.preemptive.chance = 0.25
	presets.dodge.athletic.occasions.preemptive.chance = 0.5

	presets.dodge.medic = deep_clone(presets.dodge.poor)
	presets.dodge.medic.speed = 1
	presets.dodge.medic.occasions.scared.chance = 0.6

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
			moderate = 0.2,
		},
		{
			health_limit = 0.4,
			light = 0.4,
			moderate = 0.4,
			heavy = 0.2,
		},
		{
			health_limit = 0.6,
			light = 0.2,
			moderate = 0.2,
			heavy = 0.6,
		},
		{
			health_limit = 0.8,
			heavy = 1,
		},
	}
	presets.hurt_severities.base.melee.zones = {
		{
			health_limit = 0.2,
			light = 1,
		},
		{
			health_limit = 0.4,
			light = 0.5,
			moderate = 0.5,
		},
		{
			health_limit = 0.6,
			moderate = 0.5,
			heavy = 0.5,
		},
		{
			health_limit = 0.8,
			heavy = 1,
		},
	}
	presets.hurt_severities.base.explosion.zones = {
		{
			health_limit = 0.2,
			light = 0.5,
			moderate = 0.5,
		},
		{
			health_limit = 0.4,
			moderate = 0.5,
			heavy = 0.5,
		},
		{
			health_limit = 0.6,
			heavy = 0.5,
			explode = 0.5,
		},
		{
			health_limit = 0.8,
			explode = 1,
		},
	}

	presets.hurt_severities.only_light_hurt.bullet.zones = {
		{
			health_limit = 0.3,
			none = 0.6,
			light = 0.4,
		},
		{
			light = 1,
		},
	}
	presets.hurt_severities.only_light_hurt.melee.zones = deep_clone(presets.hurt_severities.only_light_hurt.bullet.zones)
	presets.hurt_severities.only_light_hurt.explosion.zones = deep_clone(presets.hurt_severities.only_light_hurt.bullet.zones)

	presets.hurt_severities.only_explosion_and_fire = deep_clone(presets.hurt_severities.base)
	presets.hurt_severities.only_explosion_and_fire.bullet.zones = {
		{ none = 1 },
	}
	presets.hurt_severities.only_explosion_and_fire.melee.zones = deep_clone(presets.hurt_severities.only_explosion_and_fire.bullet.zones)
	presets.hurt_severities.only_explosion_and_fire.poison.zones = deep_clone(presets.hurt_severities.only_explosion_and_fire.bullet.zones)

	presets.hurt_severities.no_heavy_hurt = deep_clone(presets.hurt_severities.base)
	presets.hurt_severities.no_heavy_hurt.bullet.zones = {
		{
			health_limit = 0.2,
			none = 0.6,
			light = 0.4,
		},
		{
			health_limit = 0.4,
			light = 0.6,
			moderate = 0.4,
		},
		{
			health_limit = 0.6,
			light = 0.4,
			moderate = 0.6,
		},
		{
			health_limit = 0.8,
			moderate = 1,
		},
	}
	presets.hurt_severities.no_heavy_hurt.melee.zones = {
		{
			health_limit = 0.2,
			none = 0.2,
			light = 0.8,
		},
		{
			health_limit = 0.4,
			light = 0.8,
			moderate = 0.2,
		},
		{
			health_limit = 0.6,
			light = 0.2,
			moderate = 0.8,
		},
		{
			health_limit = 0.8,
			moderate = 0.8,
			heavy = 0.2,
		},
	}
	presets.hurt_severities.no_heavy_hurt.explosion.zones = {
		{
			health_limit = 0.2,
			light = 1,
		},
		{
			health_limit = 0.4,
			light = 0.5,
			moderate = 0.5,
		},
		{
			health_limit = 0.6,
			moderate = 0.5,
			heavy = 0.5,
		},
		{
			health_limit = 0.8,
			heavy = 0.5,
			explode = 0.5,
		},
	}

	-- Setup surrender presets
	presets.surrender.easy = {
		base_chance = 0,
		significant_chance = 0,
		reasons = {
			pants_down = 0.7,
			not_assault = 0.6,
			weapon_down = 0.5,
			flanked = 0.4,
			unaware_of_aggressor = 0.3,
			isolated = 0.2,
		},
		factors = {
			health = {
				[1.0] = 0,
				[0.0] = 0.75,
			},
			aggressor_dis = {
				[100] = 0.3,
				[800] = 0,
			},
		},
	}
	presets.surrender.normal = {
		base_chance = 0,
		significant_chance = 0,
		reasons = {
			pants_down = 0.6,
			not_assault = 0.5,
			weapon_down = 0.4,
			flanked = 0.3,
			unaware_of_aggressor = 0.2,
			isolated = 0.1,
		},
		factors = {
			health = {
				[0.75] = 0,
				[0.0] = 0.5,
			},
			aggressor_dis = {
				[100] = 0.2,
				[800] = 0,
			},
		},
	}
	presets.surrender.hard = {
		base_chance = 0,
		significant_chance = 0,
		reasons = {
			pants_down = 0.5,
			not_assault = 0.4,
			weapon_down = 0.3,
			flanked = 0.2,
			unaware_of_aggressor = 0.1,
			isolated = 0,
		},
		factors = {
			health = {
				[0.5] = 0,
				[0.0] = 0.25,
			},
			aggressor_dis = {
				[100] = 0.1,
				[800] = 0,
			},
		},
	}

	presets.surrender.no_assault = deep_clone(presets.surrender.hard)
	presets.surrender.no_assault = {
		base_chance = 0,
		significant_chance = 0,
		reasons = {
			pants_down = 0,
			not_assault = 0.4,
			weapon_down = 0,
			flanked = 0,
			unaware_of_aggressor = 0,
			isolated = 0,
		},
		factors = {
			health = {
				[1] = 0,
				[0.0] = 0,
			},
			aggressor_dis = {
				[100] = 0,
				[800] = 0,
			},
		},
	}

	-- Tweak suppression presets
	presets.suppression.easy.panic_chance_mul = 1
	presets.suppression.easy.duration = { 8, 10 }
	presets.suppression.easy.react_point = { 2, 4 }
	presets.suppression.easy.brown_point = { 5, 7 }

	presets.suppression.hard_def.panic_chance_mul = 0.8
	presets.suppression.hard_def.duration = { 6, 8 }
	presets.suppression.hard_def.react_point = { 4, 6 }
	presets.suppression.hard_def.brown_point = { 7, 9 }

	presets.suppression.hard_agg.panic_chance_mul = 0.6
	presets.suppression.hard_agg.duration = { 4, 6 }
	presets.suppression.hard_agg.react_point = { 6, 8 }
	presets.suppression.hard_agg.brown_point = { 9, 11 }

	-- Enemy chatter
	presets.enemy_chatter.cop.aggressive = true
	presets.enemy_chatter.cop.go_go = true
	presets.enemy_chatter.cop.contact = true
	presets.enemy_chatter.cop.flank = true
	presets.enemy_chatter.cop.open_fire = true
	presets.enemy_chatter.cop.watch_background = true
	presets.enemy_chatter.cop.hostage_delay_1 = true
	presets.enemy_chatter.cop.hostage_delay_2 = true
	presets.enemy_chatter.cop.get_hostages = true
	presets.enemy_chatter.cop.get_loot = true
	presets.enemy_chatter.cop.group_death = true
	presets.enemy_chatter.cop.idle = true
	presets.enemy_chatter.cop.report = true
	presets.enemy_chatter.cop.trip_mine = true
	presets.enemy_chatter.cop.saw = true

	presets.enemy_chatter.swat.push = true
	presets.enemy_chatter.swat.stand_by = true
	presets.enemy_chatter.swat.flank = true
	presets.enemy_chatter.swat.flash_grenade = true
	presets.enemy_chatter.swat.open_fire = true
	presets.enemy_chatter.swat.watch_background = true
	presets.enemy_chatter.swat.hostage_delay_1 = true
	presets.enemy_chatter.swat.hostage_delay_2 = true
	presets.enemy_chatter.swat.get_hostages = true
	presets.enemy_chatter.swat.get_loot = true
	presets.enemy_chatter.swat.group_death = true
	presets.enemy_chatter.swat.trip_mine = true
	presets.enemy_chatter.swat.saw = true

	presets.enemy_chatter.gangster = {
		aggressive = true,
		contact = true,
		go_go = true,
		idle = true,
		report = true,
	}

	presets.enemy_chatter.security = {
		aggressive = true,
		go_go = true,
		contact = true,
		suppress = true,
		idle = true,
		report = true,
	}

	presets.enemy_chatter.security_assault = {
		aggressive = true,
		go_go = true,
		contact = true,
		suppress = true,
		push = true,
		stand_by = true,
		flank = true,
		open_fire = true,
		watch_background = true,
		group_death = true,
		--for stealth heists
		idle = true,
		report = true,
	}

	presets.enemy_chatter.special = {
		aggressive = true,
		contact = true,
		go_go = true,
	}

	presets.enemy_chatter.cloaker = {
		aggressive = true,
		contact = true,
	}

	return presets
end

function CharacterTweakData:_multiply_all_speeds(walk_mul, run_mul)
	for preset_name, preset in pairs(self.presets.move_speed) do
		if preset_name ~= "civ_fast" then
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

Hooks:PostHook(CharacterTweakData, "init", "eclipse_init", function(self, tweak_data)
	local faction = Eclipse.utils.faction(tweak_data.levels)

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

	self.civilian.speech_prefix_count = 6 -- restore 4 more civilian voices that are unused

	-- fix civilians having no death sounds
	self.civilian.die_sound_event = "l1n_x02a_any_3p"
	self.civilian_female.die_sound_event = "fl1n_x02a_any_3p"

	self.security.chatter = self.presets.enemy_chatter.security
	self.security.has_alarm_pager = not is_no_mercy and true or false

	self.security_fat = deep_clone(self.security)
	self.security_fat.HEALTH_INIT = 6
	self.security_fat.dodge = nil
	self.security_fat.damage.hurt_severity = self.presets.hurt_severities.no_heavy_hurt
	self.security_fat.melee_weapon = "fists"
	table.insert(self._enemy_list, "security_fat")

	self.security_female = deep_clone(self.security)
	self.security_female.speech_prefix_p1 = "fl"
	self.security_female.speech_prefix_p2 = "n"
	self.security_female.speech_prefix_count = 1

	self.security_undominatable.chatter = self.presets.enemy_chatter.security

	self.gensec.chatter = self.presets.enemy_chatter.security
	self.gensec.speech_prefix_p1 = self._unit_prefixes.cop
	self.gensec.suppression = self.presets.suppression.easy
	self.gensec.dodge = self.presets.dodge.poor

	self.security_mex.chatter = self.presets.enemy_chatter.security

	self.security_mex_no_pager.chatter = self.presets.enemy_chatter.security

	self.security_army = deep_clone(self.security)
	self.security_army.melee_weapon = "weapon"
	--self.security_army.no_arrest = true
	self.security_army.speech_prefix_count = 5
	table.insert(self._enemy_list, "security_army")

	self.cop.speech_prefix_p1 = self._unit_prefixes.cop

	self.cop_scared.speech_prefix_p1 = self._unit_prefixes.cop

	self.cop_fat = deep_clone(self.cop)
	self.cop_fat.HEALTH_INIT = 6
	self.cop_fat.dodge = nil
	self.cop_fat.damage.hurt_severity = self.presets.hurt_severities.no_heavy_hurt
	self.cop_fat.melee_weapon = "fists"
	table.insert(self._enemy_list, "cop_fat")

	self.fbi.speech_prefix_p1 = self._unit_prefixes.cop
	self.fbi.suppression = self.presets.suppression.easy
	self.fbi.no_arrest = false

	self.fbi_office = deep_clone(self.fbi)
	self.fbi_office.melee_weapon = "taser"
	table.insert(self._enemy_list, "fbi_office")

	self.fbi_female = deep_clone(self.fbi_office)
	self.fbi_female.speech_prefix_p1 = "fl"
	self.fbi_female.speech_prefix_p2 = "n"
	self.fbi_female.speech_prefix_count = 1

	self.fbi_office_mex = deep_clone(self.security_mex)
	self.fbi_office_mex.HEALTH_INIT = 6
	self.fbi_office_mex.dodge = self.presets.dodge.athletic
	self.fbi_office_mex.suppression = self.presets.suppression.easy
	self.fbi_office_mex.crouch_move = true
	self.fbi_office_mex.deathguard = true
	self.fbi_office_mex.rescue_hostages = true
	self.fbi_office_mex.steal_loot = true
	self.fbi_office_mex.melee_weapon = "taser"
	table.insert(self._enemy_list, "fbi_office_mex")

	self.gangster.speech_prefix_p1 = "lt"
	self.gangster.speech_prefix_p2 = nil
	self.gangster.speech_prefix_count = 2

	self.triad.speech_prefix_p1 = "lt"
	self.triad.speech_prefix_p2 = nil
	self.triad.speech_prefix_count = 2
	self.triad.chatter = self.presets.enemy_chatter.gangster

	self.mobster.speech_prefix_p1 = "rt"
	self.mobster.speech_prefix_p2 = nil
	self.mobster.speech_prefix_count = 2
	self.mobster.chatter = self.presets.enemy_chatter.gangster
	self.mobster.calls_in = true

	self.cobra = deep_clone(self.gangster)
	self.cobra.tags = is_undercover and { "law" } or { "gangster" }
	self.cobra.speech_prefix_p1 = is_undercover and "l5n" or "ict"
	self.cobra.speech_prefix_count = not is_undercover and 2 or nil
	table.insert(self._enemy_list, "cobra")

	self.biker.speech_prefix_p1 = "bik"
	self.biker.speech_prefix_p2 = nil
	self.biker.speech_prefix_count = 2
	self.biker.melee_weapon = "knife_1"
	self.biker.chatter = self.presets.enemy_chatter.gangster

	self.biker_female.chatter = self.presets.enemy_chatter.gangster

	self.biker_escape.chatter = self.presets.enemy_chatter.gangster

	self.bolivian.chatter = self.presets.enemy_chatter.gangster
	self.bolivian.speech_prefix_p1 = "lt"
	self.bolivian.speech_prefix_p2 = nil
	self.bolivian.speech_prefix_count = 2

	self.bolivian_indoors.chatter = self.presets.enemy_chatter.gangster
	self.bolivian_indoors.speech_prefix_p1 = is_mountain_master and "rt" or "lt"
	self.bolivian_indoors.speech_prefix_p2 = nil
	self.bolivian_indoors.speech_prefix_count = 2

	self.bolivian_indoors_mex.chatter = self.presets.enemy_chatter.gangster
	self.bolivian_indoors_mex.speech_prefix_p1 = "lt"
	self.bolivian_indoors_mex.speech_prefix_p2 = nil
	self.bolivian_indoors_mex.speech_prefix_count = 2

	self.swat.HEALTH_INIT = 8
	self.swat.headshot_dmg_mul = 2.5 -- 32 head health
	self.swat.speech_prefix_p2 = "n"
	self.swat.surrender = self.presets.surrender.normal
	self.swat.suppression = self.presets.suppression.hard_def
	self.swat.no_arrest = false

	self.heavy_swat.HEALTH_INIT = 16
	self.heavy_swat.headshot_dmg_mul = 2.5 -- 64 head health
	self.heavy_swat.surrender = self.presets.surrender.normal
	self.heavy_swat.suppression = self.presets.suppression.hard_def
	self.heavy_swat.damage.hurt_severity = self.presets.hurt_severities.no_heavy_hurt
	self.heavy_swat.no_arrest = false

	self.fbi_swat.HEALTH_INIT = 12
	self.fbi_swat.headshot_dmg_mul = 2.5 -- 48 head health
	self.fbi_swat.speech_prefix_p2 = "n"
	self.fbi_swat.surrender = self.presets.surrender.normal
	self.fbi_swat.suppression = self.presets.suppression.hard_def
	self.fbi_swat.no_arrest = false

	self.fbi_heavy_swat.HEALTH_INIT = 20
	self.fbi_heavy_swat.headshot_dmg_mul = 2.5 -- 80 head health
	self.fbi_heavy_swat.surrender = self.presets.surrender.hard
	self.fbi_heavy_swat.suppression = self.presets.suppression.hard_agg
	self.fbi_heavy_swat.damage.hurt_severity = self.presets.hurt_severities.no_heavy_hurt
	self.fbi_heavy_swat.no_arrest = false

	self.city_swat.HEALTH_INIT = 16
	self.city_swat.headshot_dmg_mul = 2.5 -- 64 head health
	self.city_swat.speech_prefix_p2 = "n"
	self.city_swat.surrender = self.presets.surrender.hard
	self.city_swat.suppression = self.presets.suppression.hard_agg
	self.city_swat.no_arrest = false

	self.city_heavy_swat = deep_clone(self.fbi_heavy_swat)
	self.city_heavy_swat.HEALTH_INIT = 28
	self.city_heavy_swat.headshot_dmg_mul = 2.5 -- 112 head health
	self.city_heavy_swat.surrender = self.presets.surrender.no_assault
	self.city_heavy_swat.suppression = self.presets.suppression.hard_agg
	self.city_heavy_swat.damage.hurt_severity = self.presets.hurt_severities.only_light_hurt
	table.insert(self._enemy_list, "city_heavy_swat")

	self.zeal_swat = deep_clone(self.city_swat)
	table.insert(self._enemy_list, "zeal_swat")

	self.zeal_heavy_swat = deep_clone(self.fbi_heavy_swat)
	table.insert(self._enemy_list, "zeal_heavy_swat")

	self.hrt = deep_clone(self.swat)
	self.hrt.surrender = self.presets.surrender.easy
	self.hrt.speech_prefix_p1 = self._unit_prefixes.cop
	self.hrt.chatter = self.presets.enemy_chatter.cop
	self.hrt.melee_weapon = "weapon"
	table.insert(self._enemy_list, "hrt")

	self.security_mcmansion = deep_clone(self.swat)
	self.security_mcmansion.HEALTH_INIT = 12
	self.security_mcmansion.headshot_dmg_mul = 3.75 -- 32 head health
	self.security_mcmansion.melee_weapon = "weapon"
	self.security_mcmansion.speech_prefix_p2 = "n"
	self.security_mcmansion.silent_priority_shout = "f37"
	self.security_mcmansion.chatter = self.presets.enemy_chatter.security_assault
	self.security_mcmansion.has_alarm_pager = true
	table.insert(self._enemy_list, "security_mcmansion")

	self.marshal_security = deep_clone(self.security_mcmansion)
	table.insert(self._enemy_list, "marshal_security")

	self.murky = deep_clone(self.security_mcmansion)
	self.murky.speech_prefix_p1 = "l5n"
	self.murky.speech_prefix_p2 = nil
	self.murky.speech_prefix_count = nil
	self.murky.radio_prefix = "fri_" --unprofessional radio from Scarface Mansion
	self.murky.use_radio = "dsp_radio_russian" --gibberish radio (but it's better than Scarface's radio)
	--self.murky.no_arrest = true -- harder stealth
	self.murky.rescue_hostages = false -- mercs don't rescue hostages
	self.murky.steal_loot = false
	table.insert(self._enemy_list, "murky")

	self.soldier = deep_clone(self.swat)
	self.soldier.HEALTH_INIT = 14
	self.soldier.headshot_dmg_mul = 2.5 -- 56 head health
	self.soldier.surrender = self.presets.surrender.no_assault
	self.soldier.suppression = self.presets.suppression.hard_agg
	self.soldier.damage.hurt_severity = self.presets.hurt_severities.no_heavy_hurt
	self.soldier.use_radio = "dsp_radio_russian"
	self.soldier.no_arrest = true
	self.soldier.steal_loot = false
	self.soldier.speech_prefix_count = 5
	table.insert(self._enemy_list, "soldier")

	self.sniper.HEALTH_INIT = 4
	self.sniper.headshot_dmg_mul = 2.5 -- 16 head health
	self.sniper.speech_prefix_p1 = self._unit_prefixes.cop

	self.fbi_sniper = deep_clone(self.sniper)

	self.city_sniper = deep_clone(self.swat)
	self.city_sniper.tags = {
		"law",
		"marksman",
		"special",
	}
	self.city_sniper.HEALTH_INIT = 24
	self.city_sniper.headshot_dmg_mul = 2.5 -- 96 head health
	self.city_sniper.priority_shout = "f34"
	self.city_sniper.chatter = self.presets.enemy_chatter.no_chatter
	self.city_sniper.damage.hurt_severity = self.presets.hurt_severities.no_heavy_hurt
	--self.city_sniper.misses_first_player_shot = true
	self.city_sniper.surrender = nil
	self.city_sniper.suppression = nil
	self.city_sniper.shooting_death = false
	self.city_sniper.no_retreat = true
	self.city_sniper.no_arrest = true
	self.city_sniper.steal_loot = nil
	self.city_sniper.rescue_hostages = false
	table.insert(self._enemy_list, "city_sniper")

	self.shield.HEALTH_INIT = 16
	self.shield.headshot_dmg_mul = 2.5 -- 64 head health
	self.shield.speech_prefix_p1 = self._unit_prefixes.heavy_swat
	self.shield.damage.hurt_severity = self.presets.hurt_severities.only_explosion_and_light_hurt
	self.shield.spawn_sound_event = "shield_identification" --BANG BANG BANG!!!!
	self.shield.die_sound_event = nil --he already has his death sound

	self.fbi_shield = deep_clone(self.shield)
	table.insert(self._enemy_list, "fbi_shield")

	self.city_shield = deep_clone(self.shield)
	self.city_shield.HEALTH_INIT = 36
	self.city_shield.headshot_dmg_mul = 2.5 -- 144 head health
	self.city_shield.damage.hurt_severity = self.presets.hurt_severities.only_light_hurt
	self.city_shield.spawn_sound_event = "hos_shield_indication_sound_terminator_style" --DUN..DUN..DUN....DUN..DUN..DUN!!
	self.city_shield.damage.shield_knocked = false
	self.city_shield.damage.immune_to_knockback = true
	self.city_shield.can_be_tased = false
	self.city_shield.immune_to_knock_down = true
	self.city_shield.immune_to_concussion = true
	self.city_shield.no_shield_penetration = true
	table.insert(self._enemy_list, "city_shield")

	self.city_shield_break = deep_clone(self.city_shield)
	self.city_shield_break.tags = {
		"law",
		"special",
		"shield",
	}
	self.city_shield_break.tmp_invulnerable_on_tweak_change = 1
	self.city_shield_break.chatter = self.presets.enemy_chatter.special
	self.city_shield_break.dodge = self.presets.dodge.athletic
	self.city_shield_break.damage.hurt_severity = self.presets.hurt_severities.no_heavy_hurt
	self.city_shield_break.allowed_stances = nil
	self.city_shield_break.allowed_poses = nil
	self.city_shield_break.no_equip_anim = nil
	self.city_shield_break.no_run_start = nil
	self.city_shield_break.no_run_stop = nil
	self.city_shield_break.always_face_enemy = nil
	self.city_shield_break.wall_fwd_offset = nil
	self.city_shield_break.priority_shout = nil
	self.city_shield_break.announce_incomming = nil
	self.city_shield_break.use_animation_on_fire_damage = nil
	self.city_shield_break.ignore_medic_revive_animation = false
	self.city_shield_break.modify_health_on_tweak_change = true
	self.city_shield_break.access = "swat"
	table.insert(self._enemy_list, "city_shield_break")

	self.zeal_shield = deep_clone(self.fbi_shield)
	table.insert(self._enemy_list, "zeal_shield")

	self.taser.HEALTH_INIT = 36
	self.taser.headshot_dmg_mul = 2.5 -- 144 head health
	self.taser.damage.hurt_severity = self.presets.hurt_severities.base
	self.taser.spawn_sound_event = self._prefix_data_p1.taser() .. "_entrance" --tazeah coming through!!!

	self.zeal_taser = deep_clone(self.taser)
	table.insert(self._enemy_list, "zeal_taser")

	self.tank.HEALTH_INIT = 400
	self.tank.headshot_dmg_mul = 25 -- 160 head health
	self.tank.damage.hurt_severity = self.presets.hurt_severities.only_light_hurt
	self.tank.spawn_sound_event = self._prefix_data_p1.bulldozer() .. "_entrance" -- bulldozah coming through!!!
	self.tank.melee_weapon = "weapon"
	self.tank.die_sound_event = (faction == "russia" or faction == "federales") and "bdz_x02a_any_3p" or nil -- Fix Dozer's death sound for foreign factions

	self.tank_medic.HEALTH_INIT = 400
	self.tank_medic.headshot_dmg_mul = 25 -- 160 head health
	self.tank_medic.die_sound_event = self.tank.die_sound_event

	self.tank_hw.HEALTH_INIT = 200
	self.tank_hw.headshot_dmg_mul = 1
	self.tank_hw.ignore_headshot = true
	self.tank_hw.melee_anims = nil
	self.tank_hw.move_speed_mul = { walk = 0.75, run = 0.75 }
	self.tank_hw.melee_weapon = "helloween"
	self.tank_hw.die_sound_event = self.tank.die_sound_event
	--self.tank_hw.spawn_sound_event = self._prefix_data_p1.bulldozer() .. "_entrance_elite" -- elite headless bulldozah coming through!!!

	self.city_tank = deep_clone(self.tank)
	self.city_tank.HEALTH_INIT = 800
	self.city_tank.headshot_dmg_mul = 25 -- 320 head health
	self.city_tank.move_speed_mul = { walk = 0.85, run = 0.85 }
	self.city_tank.spawn_sound_event = self._prefix_data_p1.bulldozer() .. "_entrance_elite" -- elite bulldozah coming through!!!
	table.insert(self._enemy_list, "city_tank")

	self.spooc.HEALTH_INIT = 18
	self.spooc.headshot_dmg_mul = 3.75 -- 48 head health
	self.spooc.damage.hurt_severity = self.presets.hurt_severities.only_explosion_and_fire
	self.spooc.melee_weapon = "baton"
	self.spooc.chatter = self.presets.enemy_chatter.cloaker

	self.shadow_spooc.HEALTH_INIT = 18
	self.shadow_spooc.headshot_dmg_mul = 3.75 -- 48 head health
	self.shadow_spooc.damage.hurt_severity = self.presets.hurt_severities.only_explosion_and_fire

	self.medic.HEALTH_INIT = 30
	self.medic.headshot_dmg_mul = 2.5 -- 120 head health
	self.medic.damage.hurt_severity = self.presets.hurt_severities.base
	self.medic.dodge = self.presets.dodge.medic

	self.zeal_medic = deep_clone(self.medic)
	table.insert(self._enemy_list, "zeal_medic")

	-- Different radio chatter for Bellmead units
	-- Unique voice set for Bellmead's heavy gunner
	if has_bellmead_response then
		self.marshal_security.speech_prefix_p1 = "l5n"
		self.marshal_security.speech_prefix_p2 = nil
		self.marshal_security.speech_prefix_count = nil
		self.marshal_security.radio_prefix = "fri_"
		self.marshal_security.use_radio = "dsp_radio_russian"
	end

	self.mobster_boss.HEALTH_INIT = 80
	self.mobster_boss.headshot_dmg_mul = 1.5
	self.mobster_boss.damage.hurt_severity = self.presets.hurt_severities.only_light_hurt
	self.mobster_boss.die_sound_event = "Play_com_hm2_09"

	self.fbi_boss = deep_clone(self.mobster_boss)
	self.fbi_boss.throwable_cooldown = 10
	self.fbi_boss.throwable = "concussion"
	self.fbi_boss.melee_weapon = "taser"
	self.fbi_boss.access = "fbi"
	self.fbi_boss.die_sound_event = "l1n_x02a_any_3p"
	table.insert(self._enemy_list, "fbi_boss")

	self.chavez_boss.HEALTH_INIT = 80
	self.chavez_boss.headshot_dmg_mul = 1.5
	self.chavez_boss.damage.hurt_severity = self.presets.hurt_severities.no_hurts
	self.chavez_boss.die_sound_event = "l3n_x02a_any_3p"

	self.hector_boss.HEALTH_INIT = 120
	self.hector_boss.headshot_dmg_mul = 1
	self.hector_boss.damage.hurt_severity = self.presets.hurt_severities.only_light_hurt
	self.hector_boss.throwable = "concussion"
	self.hector_boss.throwable_cooldown = 10
	self.hector_boss.die_sound_event = "l4n_x02a_any_3p"

	self.hector_boss_no_armor.HEALTH_INIT = 8
	self.hector_boss_no_armor.headshot_dmg_mul = 2.5
	self.hector_boss_no_armor.die_sound_event = "l4n_x02a_any_3p"

	self.biker_boss.HEALTH_INIT = 120
	self.biker_boss.headshot_dmg_mul = 1
	self.biker_boss.damage.hurt_severity = self.presets.hurt_severities.only_light_hurt
	self.biker_boss.throwable = "frag"
	self.biker_boss.throwable_cooldown = 15
	self.biker_boss.die_sound_event = "fl1n_x02a_any_3p"

	self.drug_lord_boss.HEALTH_INIT = 120
	self.drug_lord_boss.headshot_dmg_mul = 1.5
	self.drug_lord_boss.damage.hurt_severity = self.presets.hurt_severities.only_light_hurt
	self.drug_lord_boss.throwable_target_verified = true
	self.drug_lord_boss.throwable = "launcher_m203"
	self.drug_lord_boss.throwable_cooldown = 15
	self.drug_lord_boss.die_sound_event = "l2n_x02a_any_3p"

	self.drug_lord_boss_stealth.HEALTH_INIT = 8
	self.drug_lord_boss_stealth.headshot_dmg_mul = 2.5
	self.drug_lord_boss_stealth.die_sound_event = "l2n_x02a_any_3p"

	self.triad_boss.HEALTH_INIT = 120
	self.triad_boss.headshot_dmg_mul = 1
	self.triad_boss.damage.hurt_severity = self.presets.hurt_severities.only_light_hurt
	self.triad_boss.bullet_damage_only_from_front = nil
	self.triad_boss.invulnerable_to_slotmask = nil
	self.triad_boss.throwable_target_verified = false
	self.triad_boss.throwable_cooldown = 20

	self.triad_boss_no_armor.HEALTH_INIT = 8
	self.triad_boss_no_armor.headshot_dmg_mul = 2.5

	self.deep_boss.HEALTH_INIT = 160
	self.deep_boss.headshot_dmg_mul = 1
	self.deep_boss.ignore_headshot = false
	self.deep_boss.damage.hurt_severity = self.presets.hurt_severities.only_light_hurt

	self.snowman_boss.HEALTH_INIT = 180
	self.snowman_boss.headshot_dmg_mul = 2
	self.snowman_boss.damage.hurt_severity = self.presets.hurt_severities.only_light_hurt

	self.piggydozer.HEALTH_INIT = 180
	self.piggydozer.headshot_dmg_mul = 2
	self.piggydozer.damage.hurt_severity = self.presets.hurt_severities.only_light_hurt

	if self._unit_prefixes.heavy_swat == "l" then
		self.zeal_swat.speech_prefix_p2 = "d"
		self.zeal_swat.speech_prefix_count = 4
		self.heavy_swat.speech_prefix_p2 = "d"
		self.heavy_swat.speech_prefix_count = 4
		self.fbi_heavy_swat.speech_prefix_p2 = "d"
		self.fbi_heavy_swat.speech_prefix_count = 4
		self.city_heavy_swat.speech_prefix_p2 = "d"
		self.city_heavy_swat.speech_prefix_count = 4
		self.zeal_heavy_swat.speech_prefix_p2 = "d"
		self.zeal_heavy_swat.speech_prefix_count = 4
		self.shield.speech_prefix_p2 = "d"
		self.shield.speech_prefix_count = 4
		self.fbi_shield.speech_prefix_p2 = "d"
		self.fbi_shield.speech_prefix_count = 4
		self.city_shield.speech_prefix_p2 = "d"
		self.city_shield.speech_prefix_count = 4
		self.city_shield_break.speech_prefix_p2 = "d"
		self.city_shield_break.speech_prefix_count = 4
		self.zeal_shield.speech_prefix_p2 = "d"
		self.zeal_shield.speech_prefix_count = 4
	end
end)

CharacterTweakData.team_ai_weapons_mapped = {
	-- Dallas
	["russian"] = {
		primary = {
			["wpn_fps_ass_74_npc"] = 3, -- Used pre-U240.3
			["wpn_fps_lmg_hk21_npc"] = 1, -- Used in PDTH
			["wpn_fps_ass_g36_npc"] = 1, -- Skill tree background
		},
		secondary = {
			["wpn_fps_pis_1911_npc"] = 9, -- Used in PDTH
			["wpn_fps_smg_mac10_npc"] = 3, -- Used in PDTH
			["wpn_fps_pis_beretta_npc"] = 3, -- Freeze trailer
			["wpn_fps_pis_peacemaker_npc"] = 1, -- Keep them hands visible
		},
		melee = {
			["weapon"] = 9,
			["moneybundle"] = 3,
			["freedom"] = 1, -- 'Murica
		},
	},
	-- Wolf
	["german"] = {
		primary = {
			["wpn_fps_shot_r870_npc"] = 3, -- Common portrayal
			["wpn_fps_ass_g36_npc"] = 1, -- Common portrayal 2
			["wpn_fps_ass_akm_npc"] = 1, -- Used in PDTH
		},
		secondary = {
			["wpn_fps_pis_g18c_npc"] = 3, -- Used in PDTH
			["wpn_fps_smg_mp5_npc"] = 2, -- Used pre-Henchmen/skill tree background
			["wpn_fps_smg_m45_npc"] = 1, -- Alesso trailer
		},
		melee = {
			["weapon"] = 2,
			["nin"] = 1,
		},
	},
	-- Chains
	["spanish"] = {
		primary = {
			["wpn_fps_lmg_m249_npc"] = 1, -- Common portrayal
			["wpn_fps_shot_r870_npc"] = 1, -- Used in PDTH/Skill tree background
		},
		secondary = {
			["wpn_fps_pis_rage_npc"] = 3, -- Used in PDTH
			["wpn_fps_smg_mp5_npc"] = 1, -- Used in PDTH
			["wpn_fps_smg_mac10_npc"] = 1, -- Used pre-U240.3
		},
		melee = {
			["weapon"] = 3,
			["x46"] = 1,
		},
	},
	-- Houston
	["american"] = {
		primary = {
			["wpn_fps_ass_m14_npc"] = 2, -- Freeze trailer
			["wpn_fps_ass_74_npc"] = 1, -- Used pre-U240.3
		},
		secondary = {
			["wpn_fps_pis_beretta_npc"] = 6, -- Skill tree background
			["wpn_fps_pis_1911_npc"] = 1, -- PD3 moment
			["wpn_fps_pis_beer_npc"] = 1, -- PD3 moment
		},
		melee = {
			["weapon"] = 3,
			["fists"] = 1, -- Alright little brother, just one.
		},
	},
	-- Wick, based on a quick scan through IMFDB for weapons he ever held in the movies :julespig:
	["jowi"] = {
		primary = {
			["wpn_fps_snp_tti_npc"] = 3, -- Signature
			["wpn_fps_snp_desertfox_npc"] = 1,
			["wpn_fps_sho_ben_npc"] = 1,
			["wpn_fps_sho_ksg_npc"] = 1,
			["wpn_fps_smg_shepheard_npc"] = 1,
			["wpn_fps_sho_sko12_npc"] = 1, -- "TTI Dracarys Gen-12" (liberties taken)
		},
		secondary = {
			["wpn_fps_pis_g26_npc"] = 6, -- Signature
			["wpn_fps_pis_packrat_npc"] = 6, -- Signature
			["wpn_fps_pis_p226_npc"] = 1, -- "P320" (close enough)
			["wpn_fps_pis_1911_npc"] = 1,
			["wpn_fps_pis_czech_npc"] = 1, -- "P-09" (close enough)
			["wpn_fps_pis_g22c_npc"] = 1, -- "Glock 34" (close enough)
			["wpn_fps_pis_g17_npc"] = 1,
			["wpn_fps_pis_peacemaker_npc"] = 1, -- "Remington 1875" (liberties taken)
			["wpn_fps_snp_contender_npc"] = 1,
			["wpn_fps_pis_m1911_npc"] = 1,
			["wpn_fps_pis_model3_npc"] = 1, -- "Webley .455 Mk VI" (liberties taken)
		},
		melee = {
			["weapon"] = 2,
			["fight"] = 2,
			["sword"] = 1,
		},
	},
	-- Hoxton
	["old_hoxton"] = {
		primary = {
			["wpn_fps_sho_spas12_npc"] = 2, -- Signature
			["wpn_fps_ass_m14_npc"] = 1, -- Used in PDTH
		},
		secondary = {
			["wpn_fps_shot_serbu_npc"] = 2, -- Used in PDTH
			["wpn_fps_pis_deagle_npc"] = 1,
		},
		melee = {
			["weapon"] = 1,
			["toothbrush"] = 1,
		},
	},
	-- Clover
	["female_1"] = {
		primary = {
			["wpn_fps_ass_l85a2_npc"] = 6, -- Signature
			["wpn_fps_ass_s552_npc"] = 1, -- Family Matters poster
		},
		secondary = {
			["wpn_fps_pis_ppk_npc"] = 3,
			["wpn_fps_pis_holt_npc"] = 1, -- Silk Road poster
			["wpn_fps_pis_czech_npc"] = 1, -- Cartel Business poster
		},
		melee = "shillelagh",
	},
	-- Dragan
	["dragan"] = {
		primary = {
			["wpn_fps_ass_vhs_npc"] = 9, -- Signature
			["wpn_fps_ass_famas_npc"] = 1, -- Rainy with a chance of French (wrong slot, don't care)
		},
		secondary = "wpn_fps_pis_hs2000_npc", -- Released alongside
		melee = {
			["meat_cleaver"] = 1,
			["boxing_gloves"] = 1,
		},
	},
	-- Jacket
	["jacket"] = {
		primary = {
			["wpn_fps_smg_cobray_npc"] = 3, -- Signature
			["wpn_fps_ass_m16_npc"] = 1, -- Veteran
		},
		secondary = {
			["wpn_fps_smg_scorpion_npc"] = 1, -- Hotline Miami DLC weapon
			["wpn_fps_smg_tec9_npc"] = 1, -- Hotline Miami DLC weapon
			["wpn_fps_smg_uzi_npc"] = 1, -- Hotline Miami DLC weapon
		},
		melee = {
			["hammer"] = 3,
			["briefcase"] = 2,
			["fireaxe"] = 2,
			["bat"] = 2,
			["cleaver"] = 2,
			["macehete"] = 2,
			["fists"] = 1,
		},
	},
	-- Bonnie
	["bonnie"] = {
		primary = {
			["wpn_fps_shot_b682_npc"] = 6, -- Signature
			["wpn_fps_lmg_hk21_npc"] = 1, -- Mountain Master poster
			["wpn_fps_lmg_m249_npc"] = 1, -- Lost In Transit poster
		},
		secondary = "wpn_fps_pis_2006m_npc", -- Ask Miki
		melee = "whiskey",
	},
	-- Sokol
	["sokol"] = {
		primary = {
			["wpn_fps_ass_asval_npc"] = 6, -- Signature
			["wpn_fps_ass_flint_npc"] = 3, -- Silk Road poster
			["wpn_fps_ass_g36_npc"] = 1, -- Family Matters poster
		},
		secondary = "wpn_fps_pis_pl14_npc",
		melee = {
			["hockey"] = 2,
			["oxide"] = 1,
		},
	},
	-- Jiro
	["dragon"] = {
		primary = {
			["wpn_fps_snp_wa2000_npc"] = 1, -- DLC-adjacent
			["wpn_fps_smg_polymer_npc"] = 1, -- DLC-adjacent
		},
		secondary = "wpn_fps_smg_baka_npc", -- Signature
		melee = {
			["sandsteel"] = 4,
			["fight"] = 2,
			["cqc"] = 2,
			["hauteur"] = 1,
		},
	},
	-- Bodhi
	["bodhi"] = {
		primary = "wpn_fps_snp_model70_npc", -- Signature
		secondary = "wpn_fps_pis_sparrow_npc", -- Released alongside
		melee = {
			["boxcutter"] = 2,
			["iceaxe"] = 1,
		},
	},
	-- Jimmy
	["jimmy"] = {
		primary = {
			["wpn_fps_sho_ben_npc"] = 2,
			["wpn_fps_lmg_rpk_npc"] = 1,
		},
		secondary = "wpn_fps_smg_sr2_npc", -- Signature
		melee = "ballistic",
	},
	-- Sydney
	["sydney"] = {
		primary = {
			["wpn_fps_ass_tecci_npc"] = 6, -- Signature
			["wpn_fps_ass_amcar_npc"] = 1, -- Family Matters poster
			["wpn_fps_ass_scar_npc"] = 1, -- Border Crossing poster
		},
		secondary = {
			["wpn_fps_pis_judge_npc"] = 6, -- Anarcho skin (Sydney Safe)
			["wpn_fps_smg_mac10_npc"] = 3, -- Used pre-U240.3
			["wpn_fps_pis_czech_npc"] = 1, -- Cartel Business poster
		},
		melee = "wing",
	},
	-- Rust
	["wild"] = {
		primary = {
			["wpn_fps_sho_boot_npc"] = 9, -- Signature
			["wpn_fps_smg_hajk_npc"] = 3, -- Released alongside
			["wpn_fps_lmg_par_npc"] = 1, -- Black Cat poster
		},
		secondary = "wpn_fps_pis_g22c_npc", -- Spark Plug skin (Biker Safe)
		melee = "road",
	},
	-- Scarface, secondaries are available in Scarface: The World is Yours
	["chico"] = {
		primary = "wpn_fps_ass_contraband_npc", -- Signature
		secondary = {
			["wpn_fps_pis_deagle_npc"] = 1,
			["wpn_fps_pis_m1911_npc"] = 1,
			["wpn_fps_pis_ppk_npc"] = 1,
			["wpn_fps_smg_mac10_npc"] = 1,
			["wpn_fps_smg_baka_npc"] = 1,
		},
		melee = {
			["cs"] = 2, -- Roaring frothing madness
			["brick"] = 1,
		},
	},
	-- Sangres
	["max"] = {
		primary = {
			["wpn_fps_ass_scar_npc"] = 6, -- Cartel Business poster
			["wpn_fps_smg_polymer_npc"] = 1, -- Lost In Transit poster
		},
		secondary = {
			["wpn_fps_pis_chinchilla_npc"] = 6, -- Signature
			["wpn_fps_smg_m45_npc"] = 1, -- Silk Road poster
		},
		melee = {
			["agave"] = 3,
			["chac"] = 1,
		},
	},
	-- Joy
	["joy"] = {
		primary = {
			["wpn_fps_smg_shepheard_npc"] = 3, -- Signature Signature
			["wpn_fps_ass_akm_npc"] = 1, -- PD3 moment
		},
		secondary = "wpn_fps_pis_p226_npc", -- Signature Signature 2
		melee = "happy",
	},
	-- Duke
	["myh"] = {
		primary = {
			["wpn_fps_ass_ching_npc"] = 6, -- Historic
			["wpn_fps_smg_erma_npc"] = 6, -- Historic
			["wpn_fps_lmg_mg42_npc"] = 1, -- Historic
		},
		secondary = {
			["wpn_fps_pis_shrew_npc"] = 6, -- Signature
			["wpn_fps_pis_c96_npc"] = 1, -- Historic
			["wpn_fps_smg_thompson_npc"] = 1, -- Historic
		},
		melee = "sap", -- Fitting name, because if you actually like Duke you're a...
	},
	-- Hila
	["ecp_female"] = {
		primary = {
			["wpn_fps_ass_galil_npc"] = 1,
			["wpn_fps_ass_komodo_npc"] = 1,
		},
		secondary = "wpn_fps_pis_sparrow_npc",
		melee = "meter",
	},
	-- Ethan
	["ecp_male"] = {
		primary = "wpn_fps_ass_komodo_npc",
		secondary = {
			["wpn_fps_pis_holt_npc"] = 1,
			["wpn_fps_pis_maxim9_npc"] = 1,
		},
		melee = "meter",
	},
}

Hooks:PostHook(CharacterTweakData, "_init_team_ai", "eclipse__init_team_ai", function(self)
	for tweak_name, mapping in pairs(self.team_ai_weapons_mapped) do
		if self[tweak_name] then
			if self[tweak_name].weapon then
				local weapons_of_choice = self[tweak_name].weapon.weapons_of_choice

				self[tweak_name].weapon.weapons_of_choice = {
					primary = lorefriendly_team_ai_weapons and weighted_selector(mapping.primary):select()
						or classic_team_ai_weapons and "wpn_fps_ass_amcar_npc"
						or weapons_of_choice and weapons_of_choice.primary
						or "wpn_fps_ass_m4_npc",
					secondary = lorefriendly_team_ai_weapons and weighted_selector(mapping.secondary):select()
						or classic_team_ai_weapons and "wpn_fps_pis_beretta_npc"
						or weapons_of_choice and weapons_of_choice.secondary
						or "wpn_fps_pis_g17_npc",
				}
			end

			self[tweak_name].melee_weapon = lorefriendly_team_ai_weapons and weighted_selector(mapping.melee):select() or "weapon"
		end
	end
end)

-- Add new enemies to the character map
local character_map_original = CharacterTweakData.character_map
function CharacterTweakData:character_map(...)
	local char_map = character_map_original(self, ...)

	local function safe_add(char_map_table, element)
		if char_map_table and char_map_table.list then
			table.insert(char_map_table.list, element)
		end
	end

	safe_add(char_map.basic, "ene_security_1_fat")
	safe_add(char_map.basic, "ene_security_2_fat")
	safe_add(char_map.basic, "ene_security_3_fat")
	safe_add(char_map.basic, "ene_security_female_1")
	safe_add(char_map.basic, "ene_security_female_2")
	safe_add(char_map.basic, "ene_cop_1_fat")
	safe_add(char_map.basic, "ene_cop_2_fat")
	safe_add(char_map.basic, "ene_cop_3_fat")
	safe_add(char_map.basic, "ene_cop_4_fat")
	safe_add(char_map.basic, "ene_cop_female_1")
	safe_add(char_map.basic, "ene_cop_female_2")
	safe_add(char_map.basic, "ene_swat_3")
	safe_add(char_map.basic, "ene_swat_heavy_r870")
	safe_add(char_map.basic, "ene_tazer_r870")
	safe_add(char_map.basic, "ene_fbi_swat_3")
	safe_add(char_map.basic, "ene_sniper_3")
	safe_add(char_map.basic, "ene_city_shield")
	safe_add(char_map.basic, "ene_bulldozer_5")

	safe_add(char_map.dlc1, "ene_gensec_operator_1")
	safe_add(char_map.dlc1, "ene_gensec_operator_2")

	char_map.army = {
		path = "units/pd2_dlc_army/characters/",
		list = {
			"ene_soldier_1",
			"ene_soldier_2",
			"ene_soldier_3",
			"ene_soldier_4",
		},
	}

	safe_add(char_map.drm, "ene_bulldozer_medic_classic")

	safe_add(char_map.rvd, "ene_la_cop_1_fat")
	safe_add(char_map.rvd, "ene_la_cop_2_fat")
	safe_add(char_map.rvd, "ene_la_cop_3_fat")
	safe_add(char_map.rvd, "ene_la_cop_4_fat")

	safe_add(char_map.chas, "ene_male_chas_police_03")
	safe_add(char_map.chas, "ene_male_chas_police_04")
	safe_add(char_map.chas, "ene_male_chas_police_01_fat")
	safe_add(char_map.chas, "ene_male_chas_police_02_fat")
	safe_add(char_map.chas, "ene_male_chas_police_03_fat")
	safe_add(char_map.chas, "ene_male_chas_police_04_fat")

	safe_add(char_map.chca, "ene_coast_guard_1")
	safe_add(char_map.chca, "ene_coast_guard_2")
	safe_add(char_map.chca, "ene_coast_guard_3")
	safe_add(char_map.chca, "ene_coast_guard_4")

	safe_add(char_map.ranc, "ene_male_ranc_ranger_03")
	safe_add(char_map.ranc, "ene_male_ranc_ranger_04")
	safe_add(char_map.ranc, "ene_male_ranc_ranger_01_fat")
	safe_add(char_map.ranc, "ene_male_ranc_ranger_02_fat")
	safe_add(char_map.ranc, "ene_male_ranc_ranger_03_fat")
	safe_add(char_map.ranc, "ene_male_ranc_ranger_04_fat")

	safe_add(char_map.bex, "ene_policia_03")
	safe_add(char_map.bex, "ene_policia_04")
	safe_add(char_map.bex, "ene_policia_agent_01")
	safe_add(char_map.bex, "ene_policia_agent_02")
	safe_add(char_map.bex, "ene_policia_agent_03")

	return char_map
end

-- Add new weapons
Hooks:PostHook(CharacterTweakData, "_create_table_structure", "sh__create_table_structure", function(self)
	table.insert(self.weap_ids, "mp5_tank")
	table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_mp5_bulldozer/wpn_npc_mp5_bulldozer"))

	table.insert(self.weap_ids, "r870_yellow")
	table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_r870_taser/wpn_npc_r870_taser"))

	table.insert(self.weap_ids, "r870_tank")
	table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_r870_bulldozer/wpn_npc_r870_bulldozer"))

	table.insert(self.weap_ids, "usp_tactical")
	table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_usp_tactical/wpn_npc_usp_tactical"))

	table.insert(self.weap_ids, "aa12")
	table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_aa12/wpn_npc_aa12"))

	table.insert(self.weap_ids, "aa12_tank")
	table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_aa12_bulldozer/wpn_npc_aa12_bulldozer"))

	table.insert(self.weap_ids, "m249_tank")
	table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_m249_bulldozer/wpn_npc_m249_bulldozer"))

	table.insert(self.weap_ids, "benelli_tank")
	table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_benelli_bulldozer/wpn_npc_benelli_bulldozer"))

	table.insert(self.weap_ids, "m14")
	table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_m14/wpn_npc_m14"))

	table.insert(self.weap_ids, "flamethrower_tank")
	table.insert(self.weap_unit_names, Idstring("units/pd2_dlc_pent/weapons/wpn_npc_flamethrower_bulldozer/wpn_npc_flamethrower_bulldozer"))

	table.insert(self.weap_ids, "snowthrower_tank")
	table.insert(self.weap_unit_names, Idstring("units/pd2_dlc_cg22/weapons/wpn_npc_snowthrower_bulldozer/wpn_npc_snowthrower_bulldozer"))
end)

local ecm_vuln_swat = 0.6
local ecm_vuln_heavy = 0.4
local ecm_vuln_none = 0

CharacterTweakData.access_health_hs_mul_blacklist = {
	security_fat = true,
	cop_fat = true,
	fbi_office_mex = true,
}

CharacterTweakData.access_health = {
	security = 4,
	cop = 4,
	fbi = 6,
	gangster = 6,
}

CharacterTweakData.access_hs_mul = {
	security = 2.5,
	cop = 2.5,
	gangster = 2.5,
	fbi = 2.5,
}

CharacterTweakData.tweak_table_weapon = {
	bolivian = "gangster",
	bolivian_indoors = "gangster",
	hrt = "fbi",
	fbi_office_mex = "fbi",
	swat = "swat",
	heavy_swat = "swat",
	fbi_swat = "fbi_swat",
	fbi_heavy_swat = "fbi_swat",
	city_swat = "elite_swat",
	city_heavy_swat = "elite_swat",
	zeal_swat = "zeal_swat",
	zeal_heavy_swat = "zeal_swat",
	murky = "murky",
	security_fat = "security_fat",
	security_mcmansion = "security_mcmansion",
	security_army = "soldier",
	marshal_security = "marshal_security",
	cop_fat = "cop_fat",
	soldier = "soldier",
	cobra = "gangster",
	sniper = "sniper",
	shield = "shield",
	fbi_sniper = "fbi_sniper",
	fbi_shield = "fbi_shield",
	city_sniper = "elite_sniper",
	city_shield = "elite_shield",
	city_shield_break = "elite_shield",
	zeal_shield = "zeal_shield",
	medic = "medic",
	tank = "bulldozer",
	tank_medic = "bulldozer",
	snowman_boss = "bulldozer",
	piggydozer = "bulldozer",
	tank_hw = "headless_bulldozer",
	city_tank = "elite_bulldozer",
	mobster_boss = "boss",
	chavez_boss = "boss",
	hector_boss = "boss",
	biker_boss = "boss",
	drug_lord_boss = "boss",
	triad_boss = "boss",
	deep_boss = "boss",
	fbi_boss = "boss",
}

CharacterTweakData.access_weapon = {
	security = "security",
	cop = "cop",
	gangster = "gangster",
	fbi = "fbi",
	taser = "taser",
	spooc = "cloaker",
}

CharacterTweakData.tweak_table_move_speed = {
	cobra = "fast",
	fbi_office_mex = "fast",
	soldier = "fast",
	escort_criminal = "civ_fast",
	heavy_swat = "normal",
	fbi_heavy_swat = "normal",
	city_heavy_swat = "normal",
	city_shield_break = "normal",
	medic = "normal",
	city_sniper = "normal",
	bank_manager = "normal",
	chavez_boss = "normal",
	fbi_boss = "normal",
	mobster_boss = "normal",
	security_fat = "slow",
	cop_fat = "slow",
	escort_undercover = "slow",
	escort_sand = "slow",
	spa_vip_hurt = "slow",
	drug_lord_boss = "slow",
	triad_boss = "slow",
	hector_boss = "very_slow",
	biker_boss = "very_slow",
	deep_boss = "very_slow",
}

CharacterTweakData.access_move_speed = {
	spooc = "lightning",
	shield = "very_fast",
	teamAI1 = "very_fast",
	swat = "fast",
	fbi = "fast",
	gangster = "fast",
	teamAI4 = "fast",
	civ_male = "civ_fast",
	civ_female = "civ_fast",
	tank = "very_slow",
}

CharacterTweakData.tweak_table_ecm_vulnerability = {
	heavy_swat = ecm_vuln_heavy,
	fbi_heavy_swat = ecm_vuln_heavy,
	city_heavy_swat = ecm_vuln_heavy,
	medic = ecm_vuln_heavy,
	city_sniper = ecm_vuln_heavy,
	city_shield_break = ecm_vuln_heavy,
	mobster_boss = ecm_vuln_none,
	chavez_boss = ecm_vuln_none,
	hector_boss = ecm_vuln_none,
	biker_boss = ecm_vuln_none,
	drug_lord_boss = ecm_vuln_none,
	triad_boss = ecm_vuln_none,
	deep_boss = ecm_vuln_none,
	fbi_boss = ecm_vuln_none,
	city_shield = ecm_vuln_none,
}

CharacterTweakData.access_ecm_vulnerability = {
	swat = ecm_vuln_swat,
	shield = ecm_vuln_heavy,
	taser = ecm_vuln_heavy,
	spooc = ecm_vuln_none,
	tank = ecm_vuln_none,
}

CharacterTweakData.access_surrender_blacklist = {
	bolivian = true,
	bolivian_indoors = true,
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
		local char_access = char_preset.access
		local tag_map = type(char_preset.tags) == "table" and table.list_to_set(char_preset.tags) or {}

		local is_boss = name:match("_boss$")
		local is_event_tank = name == "piggydozer" or name == "snowman_boss"
		local is_shadow_spooc = name == "shadow_spooc"

		-- Set health and HS mul based on access
		if not self.access_health_hs_mul_blacklist[name] then
			if not is_boss then
				if self.access_health[char_access] then
					char_preset.HEALTH_INIT = self.access_health[char_access]
				end

				if self.access_hs_mul[char_access] then
					char_preset.headshot_dmg_mul = self.access_hs_mul[char_access]
				end
			end
		end

		-- Set the weapon preset based on the tweak table or access
		local character_weapon = self.tweak_table_weapon[name] or self.access_weapon[char_preset.access] or "base"

		char_preset.weapon = self.presets.weapon[character_weapon]

		-- Set move speed based on the tweak table or access
		local char_move_speed = self.tweak_table_move_speed[name] or self.access_move_speed[char_access] or "normal"

		char_preset.move_speed = self.presets.move_speed[char_move_speed]

		-- Set global ECM hurts and ECM vulnerability based on tweak table or access
		local char_ecm_vuln = self.tweak_table_ecm_vulnerability[name] or self.access_ecm_vulnerability[char_access] or 0.8

		char_preset.ecm_hurts = { ears = 4 }
		char_preset.ecm_vulnerability = char_ecm_vuln

		-- Set surrender break time based on access
		char_preset.surrender_break_time = { 10, 15 }

		-- Set surrender preset based on access
		local surrender_preset = not is_boss and self.access_surrender[char_access] or nil

		if not self.access_surrender_blacklist[name] and surrender_preset then
			char_preset.surrender = self.presets.surrender[surrender_preset]
		end

		-- Remove explosion damage multipliers from most enemies
		if char_preset.damage and char_preset.damage.explosion_damage_mul then
			char_preset.damage.explosion_damage_mul = 1
		end

		-- Set up special units based on tags
		if tag_map.shield then
			char_preset.min_obj_interrupt_dis = 600
			char_preset.no_grenade_anim = char_preset.wall_fwd_offset and true or nil
			char_preset.rotation_speed = char_preset.wall_fwd_offset and 0.4 or nil
		elseif tag_map.tank then
			char_preset.min_obj_interrupt_dis = 600
			char_preset.ignore_melee_headshot = true
			char_preset.move_speed = deep_clone(char_preset.move_speed)
			char_preset.move_speed.stand.run = char_preset.move_speed.stand.walk
			char_preset.can_be_healed = not tag_map.medic and true or false
			char_preset.target_priority = not tag_map.medic and nil or 10
		elseif is_shadow_spooc or tag_map.spooc then
			char_preset.min_obj_interrupt_dis = 800
			char_preset.spooc_attack_use_smoke_chance = 0
			char_preset.spooc_attack_move_speed_mul = 1.75
			char_preset.spooc_attack_dodge_timeout = { 0.5, 1 }
			char_preset.use_animation_on_fire_damage = true
			char_preset.can_be_healed = false
		elseif tag_map.taser then
			char_preset.min_obj_interrupt_dis = 1000
		elseif tag_map.medic then
			char_preset.can_be_healed = false
			char_preset.use_animation_on_fire_damage = true
			char_preset.target_priority = 10
		end

		-- Boss related stuff
		if is_event_tank or is_boss then
			char_preset.HEALTH_INIT = char_preset.HEALTH_INIT * health_mul
			char_preset.player_health_scaling_mul = 1.25
			char_preset.damage.explosion_damage_mul = 0.5
			char_preset.no_headshot_add_mul = true
			char_preset.no_run_start = true
			char_preset.no_run_stop = true
			char_preset.immune_to_knock_down = true
			char_preset.immune_to_concussion = true
			char_preset.use_animation_on_fire_damage = false
			char_preset.can_be_healed = false
		end

		-- Remove damage clamps, they are not a fun or intuitive mechanic
		char_preset.DAMAGE_CLAMP_BULLET = nil
		char_preset.DAMAGE_CLAMP_EXPLOSION = nil
	end

	--Some exceptions
	self.security_undominatable.suppression = nil
	self.security_undominatable.surrender = nil

	self.cop_scared.surrender = self.presets.surrender.always
	self.cop_scared.surrender_break_time = nil

	self.flashbang_multiplier = is_eclipse and 1.4 or is_overkill and 1.2 or 1
	self.concussion_multiplier = 1

	self.shield_health_balance_mul = { 1, 1.25, 1.5, 1.75 }

	self.tase_multiplier = is_eclipse and 1.5 or is_overkill and 1.25 or 1

	self.spooc.spooc_kick_damage = is_eclipse and 0.5 or 0.25
	self.shadow_spooc.spooc_kick_damage = self.spooc.spooc_kick_damage

	self.spooc.spooc_attack_timeout = { diff_lerp(8, 3), diff_lerp(10, 4) }
	self.shadow_spooc.shadow_spooc_attack_timeout = self.spooc.spooc_attack_timeout

	self.medic.medic_healing = {
		cooldown = 3,
		radius = 600,
	}
	self.tank_medic.medic_healing = self.medic.medic_healing

	self.tank.damage.armor_health = is_eclipse and 14 or is_overkill and 12 or 10
	self.tank_medic.damage.armor_health = self.tank.damage.armor_health
	self.tank_hw.damage.armor_health = self.tank.damage.armor_health
	self.city_tank.damage.armor_health = self.tank.damage.armor_health * (4 / 3)
	self.tank_armor_health_balance_mul = { 0.625, 1.25, 1.5, 1.75 }

	-- eclipse exclusive edits
	if is_overkill then
		self:_multiply_all_speeds(1.05, 1.05)
	elseif is_eclipse then
		self:_multiply_all_speeds(1.05, 1.1)

		self.spooc.spooc_sound_events = { detect_stop = nil, detect = "clk_c01x_plu" } -- cloakers whistle to announce their charge
		self.taser.spawn_sound_event = self._prefix_data_p1.taser() .. "_elite" -- regular tasers get elite entrance line
	end
end

CharacterTweakData._set_normal = CharacterTweakData._set_presets
CharacterTweakData._set_hard = CharacterTweakData._set_presets
CharacterTweakData._set_overkill = CharacterTweakData._set_presets
CharacterTweakData._set_overkill_145 = CharacterTweakData._set_presets
CharacterTweakData._set_easy_wish = CharacterTweakData._set_presets
