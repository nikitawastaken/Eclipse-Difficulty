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
		fire_dot_data = {
			dot_trigger_chance = 70,
			dot_damage = 7.5,
			dot_length = 6,
			dot_trigger_max_distance = 3000,
			dot_tick_period = 0.25
		}
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
		fire_dot_data = {
			dot_trigger_chance = 70,
			dot_damage = 7.5,
			dot_length = 6,
			dot_trigger_max_distance = 3000,
			dot_tick_period = 0.25
		}
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
		fire_dot_data = {
			dot_trigger_chance = 70,
			dot_damage = 7.5,
			dot_length = 6,
			dot_trigger_max_distance = 3000,
			dot_tick_period = 0.25
		}
	}

	return params
end