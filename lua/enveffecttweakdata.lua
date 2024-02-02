EnvEffectTweakData = EnvEffectTweakData or class()

function EnvEffectTweakData:molotov_fire()
	local params = {
		sound_event = "molotov_impact",
		range = 105,
		curve_pow = 3,
		damage = 2,
		fire_alert_radius = 1500,
		alert_radius = 1500,
		sound_event_burning = "burn_loop_gen",
		is_molotov = true,
		player_damage = 2.5,
		sound_event_impact_duration = 4,
		burn_tick_period = 0.2,
		burn_duration = 15,
		effect_name = "effects/payday2/particles/explosions/molotov_grenade",
		dot_data_name = "proj_molotov_groundfire",
	}

	return params
end

function EnvEffectTweakData:incendiary_fire()
	local params = {
		sound_event = "gl_explode",
		range = 75,
		curve_pow = 3,
		damage = 1,
		fire_alert_radius = 1500,
		alert_radius = 1500,
		sound_event_burning = "burn_loop_gen",
		player_damage = 2.5,
		sound_event_impact_duration = 6,
		burn_tick_period = 0.2,
		burn_duration = 4,
		effect_name = "effects/payday2/particles/explosions/molotov_grenade",
		dot_data_name = "proj_launcher_incendiary_groundfire",
	}

	return params
end

function EnvEffectTweakData:incendiary_fire_arbiter()
	local params = {
		sound_event = "gl_explode",
		range = 75,
		curve_pow = 3,
		damage = 1,
		fire_alert_radius = 1500,
		alert_radius = 1500,
		sound_event_burning = "burn_loop_gen",
		player_damage = 2.5,
		sound_event_impact_duration = 6,
		burn_tick_period = 0.2,
		burn_duration = 3,
		effect_name = "effects/payday2/particles/explosions/molotov_grenade",
		dot_data_name = "proj_launcher_incendiary_arbiter_groundfire",
	}

	return params
end
