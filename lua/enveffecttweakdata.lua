EnvEffectTweakData = EnvEffectTweakData or class()

function EnvEffectTweakData:molotov_fire()
	local params = {
		sound_event = "molotov_impact",
		range = 105,
		curve_pow = 3,
		damage = 1,
		fire_alert_radius = 1500,
		sound_event_burning_stop = "burn_loop_gen_stop_fade",
		alert_radius = 1500,
		sound_event_burning = "no_sound",
		is_molotov = true,
		player_damage = 2,
		sound_event_impact_duration = 0,
		burn_tick_period = 0.5,
		burn_duration = 15,
		dot_data_name = "proj_molotov_groundfire",
		effect_name = "effects/payday2/particles/explosions/molotov_grenade"
	}

	return params
end

function EnvEffectTweakData:incendiary_fire()
	local params = {
		sound_event = "no_sound",
		range = 75,
		curve_pow = 3,
		damage = 1,
		fire_alert_radius = 1500,
		sound_event_burning_stop = "burn_loop_gen_stop_fade",
		alert_radius = 1500,
		sound_event_burning = "burn_loop_gen",
		player_damage = 2,
		sound_event_impact_duration = 0,
		burn_tick_period = 0.5,
		burn_duration = 6,
		dot_data_name = "proj_launcher_incendiary_arbiter_groundfire",
		effect_name = "effects/payday2/particles/explosions/molotov_grenade"
	}

	return params
end

function EnvEffectTweakData:incendiary_fire_arbiter()
	local params = {
		sound_event = "no_sound",
		range = 75,
		curve_pow = 3,
		damage = 1,
		fire_alert_radius = 1500,
		sound_event_burning_stop = "burn_loop_gen_stop_fade",
		alert_radius = 1500,
		sound_event_burning = "burn_loop_gen",
		player_damage = 2,
		sound_event_impact_duration = 0,
		burn_tick_period = 0.5,
		burn_duration = 4,
		dot_data_name = "proj_launcher_incendiary_arbiter_groundfire",
		effect_name = "effects/payday2/particles/explosions/molotov_grenade"
	}

	return params
end
