function WeaponFalloffTemplate.setup_weapon_falloff_templates()
	local weapon_falloff_templates = {}
	weapon_falloff_templates.SHOTGUN_FALL_NORMAL = {
		optimal_distance = 000,
		optimal_range = 1200,
		near_falloff = 0,
		far_falloff = 1500,
		near_multiplier = 1.4,
		far_multiplier = 0.3
	}
	weapon_falloff_templates.SHOTGUN_FALL_MODERATE = {
		optimal_distance = 000,
		optimal_range = 1400,
		near_falloff = 0,
		far_falloff = 2000,
		near_multiplier = 1.4,
		far_multiplier = 0.3
	}
	weapon_falloff_templates.SHOTGUN_FALL_HIGH = {
		optimal_distance = 000,
		optimal_range = 1600,
		near_falloff = 0,
		far_falloff = 2500,
		near_multiplier = 1.4,
		far_multiplier = 0.4
	}
	weapon_falloff_templates.SHOTGUN_FALL_VHIGH = {
		optimal_distance = 000,
		optimal_range = 1800,
		near_falloff = 0,
		far_falloff = 3000,
		near_multiplier = 1.4,
		far_multiplier = 0.5
	}

	return weapon_falloff_templates
end