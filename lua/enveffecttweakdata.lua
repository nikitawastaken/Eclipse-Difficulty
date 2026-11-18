EnvEffectTweakData = EnvEffectTweakData or class()

Hooks:PostHook(EnvEffectTweakData, "init", "enveffect_init", function(self, tweak_data)
	self.lightning = {}
	self.lightning.event_name = "thunder_struck"
	self.lightning.min_interval = 5
	self.lightning.rnd_interval = 30
	self.lightning_storm = {}
	self.lightning_storm.event_name = "thunder_struck"
	self.lightning_storm.min_interval = 5
	self.lightning_storm.rnd_interval = 5
	self.rain_no_ripples = {}
	self.rain_no_ripples.effect_name = Idstring("effects/particles/rain/rain_01_a")
	self.rain_no_ripples.ripples = false
	self.foggy = {}
	self.foggy.effect_name = Idstring("effects/envsmod/night_time/fog_very_faint_bright_white")
	self.foggy.ripples = false
end)

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
		effect_name = "effects/payday2/particles/explosions/molotov_grenade",
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
		burn_duration = 10,
		dot_data_name = "proj_launcher_incendiary_arbiter_groundfire",
		effect_name = "effects/payday2/particles/explosions/molotov_grenade",
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
		burn_duration = 10,
		dot_data_name = "proj_launcher_incendiary_arbiter_groundfire",
		effect_name = "effects/payday2/particles/explosions/molotov_grenade",
	}

	return params
end
