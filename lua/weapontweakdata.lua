Hooks:PostHook(WeaponTweakData, "init", "eclipse_init", function(self)

local SELECTION = {
	SECONDARY = 1,
	PRIMARY = 2,
	UNDERBARREL_SECONDARY = 3,
	UNDERBARREL_PRIMARY = 4
}

-- trip mine buff
self.trip_mines = {
	delay = 0.1,
	damage = 200,
	player_damage = 6,
	damage_size = 300,
	alert_radius = 5000
}


-- ALL OF THE TABLE STUFF


-- falloff tables
local FALLOFF_TEMPLATE = WeaponFalloffTemplate.setup_weapon_falloff_templates()

-- total ammo tables
local total_ammo_tables = {
	sniper = 60,
	secondary_sniper = 25,

	lmg_low = 300,
	lmg_high = 400,

	shot_very_high = 110,
	shot_high = 90,
	shot_mid = 75,
	shot_low = 56,
	shot_very_low = 40,

	ar_high = 270,
	ar_mid = 240,
	ar_low = 180,
	ar_very_low = 150,

	dmr = 90,
	dmr_low = 60,

	smg_high = 180,
	smg_mid = 150,
	smg_low = 120,
	smg_very_low = 90,

	pistol_high = 120,
	pistol_mid = 90,
	pistol_low = 60,
	pistol_very_low = 45,
	revolver = 36,
	revolver_ap = 30,

	akimbo_pis_very_high = 240,
	akimbo_pis_high = 180,
	akimbo_pis_mid = 120,
	akimbo_pis_low = 90,
	akimbo_special = 60
}

-- ammo pickup tables
local pickup_tables = {
	sniper_high = {1, 1.75},
	sniper_mid = {1, 1.375},
	sniper_low = {1, 1.2},
	secondary_sniper = {0.5, 1},

	lmg = {3.5, 5.25},
	minigun = {3.25, 4.25},

	shot_very_high = {1.75, 2.75},
	shot_high = {1.75, 2.5},
	shot_mid = {1, 2},
	shot_low = {1, 1.65},
	shot_very_low = {1, 1.25},
	shot_special = {0.25, 0.45},

	ar_high = {4, 5},
	ar_mid = {3, 4},
	ar_low = {2, 3},
	ar_very_low = {1.5, 2.25},

	dmr = {1, 1.5},
	dmr_low = {0.75, 1.1},

	smg_high = {3.5, 4.5},
	smg_mid = {2.5, 3.5},
	smg_low = {1.5, 2.5},
	smg_very_low = {1, 2},

	pistol_high = {2.5, 3.5},
	pistol_mid = {2.2, 3},
	pistol_low = {1.5, 2.25},
	pistol_very_low = {1.25, 2},
	revolver_high = {1.25, 2},
	revolver = {1, 1.75},

	revolver_ap = {0.25, 0.5},
	pistol_ap = {0.4, 0.5}
}

-- normal kick tables
local kick_tables = {
	sniper_auto = {standing = {3, 3.8, -0.3, 0.3}, crouching = {3, 3.8, -0.3, 0.3}, steelsight = {3, 3.8, -0.3, 0.3}},
	sniper_low = {standing = {4, 4.8, -0.3, 0.3}, crouching = {4, 4.8, -0.3, 0.3}, steelsight = {4, 4.8, -0.3, 0.3}},
	sniper_mid = {standing = {4.5, 5.5, -0.3, 0.3}, crouching = {4.5, 5.5, -0.3, 0.3}, steelsight = {4.5, 5.5, -0.3, 0.3}},

	lmg = {standing = {0.8, 1.2, -1.1, 1.1}, crouching = {0.8, 1.2, -1.1, 1.1}, steelsight = {0.8, 1.2, -1.1, 1.1}},
	lmg_high = {standing = {0.9, 1.2, -1, 1}, crouching = {0.9, 1.2, -1, 1}, steelsight = {0.9, 1.2, -1, 1}},
	mini = {standing = {0.3, 0.4, -0.2, 0.5}, crouching = {0.3, 0.4, -0.2, 0.5}, steelsight = {0.3, 0.4, -0.2, 0.5}},
	micro = {standing = {0.5, 0.7, -0.6, 0.2}, crouching = {0.5, 0.7, -0.6, 0.2}, steelsight = {0.5, 0.7, -0.6, 0.2}},
	hailstorm = {standing = {0.75, 0.9, -0.8, 0.8}, crouching = {0.75, 0.9, -0.8, 0.8}, steelsight = {0.75, 0.9, -0.8, 0.8}},
	hailstorm_volley = {standing = {5, 6, -0.16, 0.16}, crouching = {5, 6, -0.16, 0.16}, steelsight ={0.75, 0.9, -0.8, 0.8}},

	shot_auto = {standing = {2, 2.5, -0.5, 0.5}, crouching = {2, 2.5, -0.5, 0.5}, steelsight = {2, 2.5, -0.5, 0.5}},
	shot_low = {standing = {3, 4, -0.5, 0.5}, crouching = {3, 4, -0.5, 0.5}, steelsight = {3, 4, -0.5, 0.5}},
	shot_high = {standing = {4, 5, -0.5, 0.5}, crouching = {4, 5, -0.5, 0.5}, steelsight = {4, 5, -0.5, 0.5}},

	ar_low = {standing = {1.1, 1.3, -0.95, 0.95}, crouching = {1.1, 1.3, -0.95, 0.95}, steelsight = {1.1, 1.3, -0.95, 0.95}},
	ar_mid = {standing = {1.2, 1.4, -1.15, 1.15}, crouching = {1.3, 1.5, -1.15, 1.15}, steelsight = {1.3, 1.5, -1.15, 1.15}},
	ar_high = {standing = {1.3, 1.5, -1.2, 1.2}, crouching = {1.4, 1.6, -1.2, 1.2}, steelsight = {1.4, 1.6, -1.2, 1.2}},
	ar_very_high = {standing = {1.4, 1.6, -1.25, 1.25}, crouching = {1.4, 1.6, -1.25, 1.25}, steelsight = {1.4, 1.6, -1.25, 1.25}},
	ks12 = {standing = {1.5, 1.8, -1.25, 1.25}, crouching = {1.5, 1.8, -1.25, 1.25}, steelsight = {1.5, 1.8, -1.25, 1.25}},

	dmr_low = {standing = {1.6, 2, -0.45, 0.45}, crouching = {1.6, 2, -0.45, 0.45}, steelsight = {1.6, 2, -0.45, 0.45}},
	dmr_high = {standing = {3.5, 4.5, -0.6, 0.6}, crouching = {3.5, 4.5, -0.6, 0.6}, steelsight = {3.5, 4.5, -0.6, 0.6}},

	revolver_ap = {standing = {2.9, 3, -0.5, 0.5}, crouching = {2.9, 3, -0.5, 0.5}, steelsight = {2.9, 3, -0.5, 0.5}},
	revolver = {standing = {1.8, 2.2, -0.45, 0.45}, crouching = {1.8, 2.2, -0.45, 0.45}, steelsight = {1.8, 2.2, -0.45, 0.45}},
	revolver_low = {standing = {1.3, 1.6, -0.45, 0.45}, crouching = {1.3, 1.6, -0.45, 0.45}, steelsight = {1.3, 1.6, -0.45, 0.45}},

	pistol_auto = {standing = {1.1, 1.3, -0.95, 0.95}, crouching = {1.1, 1.3, -0.95, 0.95}, steelsight = {1.1, 1.3, -0.95, 0.95}},
	pistol_low = {standing = {1.55, 2.05, -0.75, 0.75}, crouching = {1.55, 2.05, -0.75, 0.75}, steelsight = {1.55, 2.05, -0.75, 0.75}},
	pistol_mid = {standing = {1.8, 2.3, -0.8, 0.8}, crouching = {1.8, 2.3, -0.8, 0.8}, steelsight = {1.8, 2.3, -0.8, 0.8}},
	pistol_high = {standing = {2, 2.5, -0.8, 0.8}, crouching = {2, 2.5, -0.8, 0.8}, steelsight = {2, 2.5, -0.8, 0.8}},

	akimbo_pistol_auto = {standing = {0.95, 1.05, -1.1, 1.1}, crouching = {0.95, 1.05, -1.1, 1.1}, steelsight = {0.95, 1.05, -1.1, 1.1}}
}

-- spray pattern tables
local spray_tables = {
	ar_left_low = {
		pattern = {
			{ up = 0.7, down = 0.7, left = -0.04, right = 0.05 },
			{ up = 1.3, down = 1.3, left = -0.15, right = 0.14 },
			{ up = 1.8, down = 1.8, left = 0.15, right = 0.3 },
			{ up = 1.5, down = 1.5, left = -0.3, right = -0.15 },
			{ up = 1.3, down = 1.3, left = 0.15, right = 0.5 },
			{ up = 1.9, down = 1.9, left = 0.14, right = 0.15 },
			{ up = 1.4, down = 1.4, left = -1, right = -1 },
			{ up = 1.1, down = 1.1, left = -0.8, right = -0.8 },
			{ up = 0.45, down = 0.45, left = -1, right = -1 },
			{ up = 0.95, down = 0.95, left = 0.7, right = 0.7 },
			{ up = 0.45, down = 0.45, left = 0.9, right = 1 },
			{ up = 0.35, down = 0.55, left = 1, right = 1.1 },
			{ up = 0.55, down = 0.55, left = 1.1, right = 1.2 },
		},
		persist_pattern = {
			{ up = 0.5, down = 0.75, left = -0.5, right = 1.5 }
		}
	},
	ar_right_low = {
		pattern = {
			{ up = 0.7, down = 0.7, left = -0.05, right = 0.04 },
			{ up = 1.3, down = 1.3, left = -0.15, right = -0.14 },
			{ up = 1.8, down = 1.8, left = -0.15, right = -0.3 },
			{ up = 1.5, down = 1.5, left = 0.3, right = 0.15 },
			{ up = 1.3, down = 1.3, left = -0.15, right = -0.5 },
			{ up = 1.9, down = 1.9, left = -0.14, right = -0.15 },
			{ up = 1.4, down = 1.4, left = 1, right = 1 },
			{ up = 1.1, down = 1.1, left = 0.8, right = 0.8 },
			{ up = 0.45, down = 0.45, left = 1, right = 1 },
			{ up = 0.95, down = 0.95, left = -0.7, right = -0.7 },
			{ up = 0.45, down = 0.45, left = -0.9, right = -1 },
			{ up = 0.35, down = 0.55, left = -1, right = -1.1 },
			{ up = 0.55, down = 0.55, left = -1.1, right = -1.2 },
		},
		persist_pattern = {
			{ up = 0.5, down = 0.75, left = 0.5, right = -1.5 }
		}
	},
	ar_left_mid = {
		pattern = {
			{ up = 0.8, down = 0.8, left = -0.04, right = 0.05 },
			{ up = 1.5, down = 1.5, left = -0.2, right = 0.19 },
			{ up = 2, down = 2, left = 0.25, right = 0.4 },
			{ up = 1.6, down = 1.6, left = -0.4, right = -0.25 },
			{ up = 1.4, down = 1.4, left = 0.3, right = 0.6 },
			{ up = 2, down = 2.1, left = 0.2, right = 0.3 },
			{ up = 1.55, down = 1.55, left = -1.2, right = -1.2 },
			{ up = 1.25, down = 1.25, left = -1, right = -1 },
			{ up = 0.45, down = 0.45, left = -1.3, right = -1.3 },
			{ up = 0.95, down = 0.95, left = 0.9, right = 0.9 },
			{ up = 0.45, down = 0.45, left = 1, right = 1.15 },
			{ up = 0.35, down = 0.55, left = 1.1, right = 1.3 },
			{ up = 0.55, down = 0.55, left = 1.3, right = 1.5 },
		},
		persist_pattern = {
			{ up = 0.5, down = 0.75, left = -0.75, right = 1.75 }
		}
	},
	ar_right_mid = {
		pattern = {
			{ up = 0.8, down = 0.8, left = 0.04, right = -0.05 },
			{ up = 1.5, down = 1.5, left = 0.2, right = -0.19 },
			{ up = 2, down = 2, left = -0.25, right = -0.4 },
			{ up = 1.6, down = 1.6, left = 0.4, right = 0.25 },
			{ up = 1.4, down = 1.4, left = -0.3, right = -0.6 },
			{ up = 2, down = 2.1, left = -0.2, right = -0.3 },
			{ up = 1.55, down = 1.55, left = 1.2, right = 1.2 },
			{ up = 1.25, down = 1.25, left = 1, right = 1 },
			{ up = 0.45, down = 0.45, left = 1.3, right = 1.3 },
			{ up = 0.95, down = 0.95, left = -0.9, right = -0.9 },
			{ up = 0.45, down = 0.45, left = -1, right = -1.15 },
			{ up = 0.35, down = 0.55, left = -1.1, right = -1.3 },
			{ up = 0.55, down = 0.55, left = -1.3, right = -1.5 },
		},
		persist_pattern = {
			{ up = 0.5, down = 0.75, left = 0.75, right = -1.75 }
		}
	},
	ar_left_high = {
		pattern = {
			{ up = 0.8, down = 0.9, left = -0.04, right = 0.05 },
			{ up = 1.6, down = 1.65, left = -0.2, right = 0.19 },
			{ up = 2.1, down = 2.1, left = 0.25, right = 0.4 },
			{ up = 1.75, down = 1.75, left = -0.4, right = -0.25 },
			{ up = 1.55, down = 1.55, left = 0.3, right = 0.6 },
			{ up = 2.1, down = 2.2, left = 0.2, right = 0.3 },
			{ up = 1.6, down = 1.65, left = -1.2, right = -1.2 },
			{ up = 1.3, down = 1.4, left = -1, right = -1 },
			{ up = 0.45, down = 0.45, left = -1.3, right = -1.3 },
			{ up = 0.95, down = 0.95, left = 0.9, right = 0.9 },
			{ up = 0.45, down = 0.45, left = 1, right = 1.15 },
			{ up = 0.35, down = 0.55, left = 1.1, right = 1.3 },
			{ up = 0.55, down = 0.55, left = 1.3, right = 1.5 },
		},
		persist_pattern = {
			{ up = 0.5, down = 0.75, left = -0.75, right = 1.75 }
		}
	},
	ar_right_high = {
		pattern = {
			{ up = 0.8, down = 0.9, left = 0.04, right = -0.05 },
			{ up = 1.6, down = 1.65, left = 0.2, right = -0.19 },
			{ up = 2.1, down = 2.1, left = -0.25, right = -0.4 },
			{ up = 1.75, down = 1.75, left = 0.4, right = 0.25 },
			{ up = 1.55, down = 1.55, left = -0.3, right = -0.6 },
			{ up = 2.1, down = 2.2, left = -0.2, right = -0.3 },
			{ up = 1.6, down = 1.65, left = 1.2, right = 1.2 },
			{ up = 1.3, down = 1.4, left = 1, right = 1 },
			{ up = 0.45, down = 0.45, left = 1.3, right = 1.3 },
			{ up = 0.95, down = 0.95, left = -0.9, right = -0.9 },
			{ up = 0.45, down = 0.45, left = -1, right = -1.15 },
			{ up = 0.35, down = 0.55, left = -1.1, right = -1.3 },
			{ up = 0.55, down = 0.55, left = -1.3, right = -1.5 },
		},
		persist_pattern = {
			{ up = 0.5, down = 0.75, left = 0.75, right = -1.75 }
		}
	},
	sg_auto = {
		pattern = {
			{ up = 3, down = 3, left = 0.5, right = 1 },
			{ up = 3, down = 3, left = -1, right = -0.5 },
			{ up = 2, down = 2.5, left = -1.8, right = -2 },
			{ up = 2, down = 2, left = -2.3, right = -2.5 },
			{ up = 1.25, down = 1.5, left = 1, right = 0.8 },
			{ up = 1.5, down = 1.5, left = 2, right = 2.5 },
			{ up = 1, down = 1.25, left = 2.5, right = 3 },
			{ up = 1.5, down = 1.5, left = 3, right = 3 },
		},
		persist_pattern = {
			{ up = 2, down = 3, left = -3, right = 1 },
		}
	},
	lmg_right = {
		pattern = {
			{ up = 0.2, down = 0.2, left = 0.8, right = 0.8 },
			{ up = 0.5, down = 0.8, left = 0.8, right = 0.8 },
			{ up = 0.8, down = 0.8, left = 0.6, right = 0.6 },
			{ up = 0.9, down = 1, left = 0.6, right = 0.6 },
			{ up = 1, down = 1.1, left = 0.6, right = 0.6 },
			{ up = 1.1, down = 1.2, left = 0.6, right = 0.6 },
			{ up = 1.2, down = 1.3, left = 0.4, right = 0.4 },
			{ up = 1.2, down = 1.4, left = 0.2, right = 0.3 },
			{ up = 0.8, down = 0.8, left = -0.2, right = -0.3 },
			{ up = 0.8, down = 0.8, left = -0.4, right = -0.8 },
			{ up = 1, down = 1, left = -0.8, right = -1 },
			{ up = 1, down = 1.1, left = -1, right = -1 },
			{ up = 1.1, down = 1.3, left = -0.8, right = -1 },
			{ up = 1.3, down = 1.3, left = -0.7, right = -0.7 },
			{ up = 1.1, down = 1.1, left = -0.3, right = -0.2 },
			{ up = 1, down = 1.2, left = 0.3, right = 0.4 },
		},
		persist_pattern = {
			{ up = 0.8, down = 1.1, left = -1, right = 2 }
		}
	},
	lmg_left = {
		pattern = {
			{ up = 0.2, down = 0.2, left = -0.8, right = -0.8 },
			{ up = 0.5, down = 0.8, left = -0.8, right = -0.8 },
			{ up = 0.8, down = 0.8, left = -0.6, right = -0.6 },
			{ up = 0.9, down = 1, left = -0.6, right = -0.6 },
			{ up = 1, down = 1.1, left = -0.6, right = -0.6 },
			{ up = 1.1, down = 1.2, left = -0.6, right = -0.6 },
			{ up = 1.2, down = 1.3, left = -0.4, right = -0.4 },
			{ up = 1.2, down = 1.4, left = 0.2, right = 0.3 },
			{ up = 0.8, down = 0.8, left = 0.2, right = 0.3 },
			{ up = 0.8, down = 0.8, left = 0.4, right = 0.8 },
			{ up = 1, down = 1, left = 0.8, right = 1 },
			{ up = 1, down = 1.1, left = 1, right = 1 },
			{ up = 1.1, down = 1.3, left = 0.8, right = 1 },
			{ up = 1.3, down = 1.3, left = 0.7, right = 0.7 },
			{ up = 1.1, down = 1.1, left = 0.3, right = 0.2 },
			{ up = 1, down = 1.2, left = -0.3, right = -0.4 },
		},
		persist_pattern = {
			{ up = 0.8, down = 1.1, left = -2, right = 1 }
		}
	},
	mini = {
		pattern = {
			{ up = 0.4, down = 0.5, left = -0.1, right = -0.3 },
			{ up = 0.5, down = 0.6, left = -0.1, right = -0.3 },
			{ up = 0.6, down = 0.7, left = -0.1, right = -0.3 },
			{ up = 0.6, down = 0.7, left = -0.1, right = -0.3 },
			{ up = 0.6, down = 0.7, left = -0.1, right = -0.3 },
			{ up = 0.6, down = 0.7, left = -0.1, right = -0.3 },
			{ up = 0.6, down = 0.7, left = 0.1, right = 0.3 },
			{ up = 0.6, down = 0.7, left = 0.1, right = 0.3 },
			{ up = 0.6, down = 0.7, left = 0.1, right = 0.3 },
			{ up = 0.6, down = 0.7, left = 0.1, right = 0.3 },
			{ up = 0.6, down = 0.7, left = 0.1, right = 0.35 },
			{ up = 0.6, down = 0.7, left = 0.1, right = 0.35 },
			{ up = 0.6, down = 0.7, left = 0.1, right = 0.35 },
			{ up = 0.6, down = 0.7, left = 0.1, right = 0.35 },
			{ up = 0.6, down = 0.7, left = -0.15, right = 0.12 },
			{ up = 0.6, down = 0.7, left = -0.15, right = 0.12 },
			{ up = 0.6, down = 0.7, left = -0.15, right = 0.12 },
			{ up = 0.6, down = 0.7, left = -0.15, right = 0.12 },
			{ up = 0.6, down = 0.7, left = -0.15, right = 0.12 },
			{ up = 0.6, down = 0.7, left = -0.15, right = 0.12 },
			{ up = 0.6, down = 0.7, left = -0.15, right = 0.12 },
			{ up = 0.6, down = 0.7, left = -0.15, right = 0.12 },
			{ up = 0.5, down = 0.5, left = -0.15, right = 0.12 },
			{ up = 0.5, down = 0.5, left = -0.15, right = 0.12 },
			{ up = 0.5, down = 0.5, left = -0.15, right = 0.12 },
			{ up = 0.5, down = 0.5, left = -0.15, right = 0.12 },
			{ up = 0.5, down = 0.5, left = -0.15, right = 0.12 },
			{ up = 0.4, down = 0.5, left = -0.15, right = 0.12 },
			{ up = 0.4, down = 0.5, left = -0.15, right = 0.12 },
			{ up = 0.4, down = 0.5, left = -0.15, right = 0.12 },
			{ up = 0.4, down = 0.5, left = -0.15, right = 0.12 },
			{ up = 0.4, down = 0.5, left = -0.15, right = 0.12 },
			{ up = 0.3, down = 0.4, left = -0.15, right = 0.12 },
			{ up = 0.3, down = 0.4, left = -0.15, right = 0.12 },
			{ up = 0.3, down = 0.4, left = -0.15, right = 0.12 },
			{ up = 0.3, down = 0.4, left = -0.15, right = 0.12 },
			{ up = 0.3, down = 0.4, left = -0.15, right = 0.12 },
			{ up = 0.3, down = 0.4, left = -0.15, right = 0.12 },
			{ up = 0.2, down = 0.2, left = -0.15, right = 0.12 },
			{ up = 0.2, down = 0.2, left = -0.15, right = 0.12 },
			{ up = 0.2, down = 0.2, left = -0.15, right = 0.12 },
			{ up = 0.2, down = 0.2, left = -0.15, right = 0.12 },
			{ up = 0.2, down = 0.2, left = -0.15, right = 0.12 },
			{ up = 0.1, down = 0.1, left = -0.15, right = 0.12 },
			{ up = 0.1, down = 0.1, left = -0.15, right = 0.12 },
			{ up = 0.1, down = 0.1, left = -0.15, right = 0.12 },
		},
		persist_pattern = {
			{ up = 0.05, down = 0.1, left = -0.3, right = 0.35 }
		}
	}
}

-- recoil recovery timer tables
local recovery_tables = {
	low = 0.175,
	mid = 0.35,
	high = 0.5
}



-- ACTUAL WEAPON STUFF


-- Sniper Rifles


-- Contractor
self.tti.AMMO_MAX = total_ammo_tables.sniper
self.tti.CLIP_AMMO_MAX = 15
self.tti.stats.concealment = 13
self.tti.stats.damage = 145
self.tti.stats_modifiers = {damage = 2}
self.tti.AMMO_PICKUP = pickup_tables.sniper_high
self.tti.kick = kick_tables.sniper_auto
self.tti.categories = {"snp", "ng"}

-- Grom
self.siltstone.AMMO_MAX = total_ammo_tables.sniper
self.siltstone.stats.damage = 145
self.siltstone.stats_modifiers = {damage = 2}
self.siltstone.stats.concealment = 20
self.siltstone.AMMO_PICKUP = pickup_tables.sniper_high
self.siltstone.kick = kick_tables.sniper_auto
self.siltstone.categories = {"snp", "ng"}

-- Kang Arms
self.qbu88.AMMO_MAX = total_ammo_tables.sniper
self.qbu88.stats.recoil = 7
self.qbu88.stats.damage = 145
self.qbu88.stats_modifiers = {damage = 2}
self.qbu88.AMMO_PICKUP = pickup_tables.sniper_high
self.qbu88.kick = kick_tables.sniper_auto
self.qbu88.categories = {"snp", "ng"}

-- Lebensauger
self.wa2000.AMMO_MAX = total_ammo_tables.sniper
self.wa2000.CLIP_AMMO_MAX = 10
self.wa2000.stats.reload = 13
self.wa2000.stats.damage = 145
self.wa2000.stats_modifiers = {damage = 2}
self.wa2000.AMMO_PICKUP = pickup_tables.sniper_high
self.wa2000.kick = kick_tables.sniper_auto
self.wa2000.categories = {"snp", "ng"}

-- Repeater
self.winchester1874.stats.damage = 155
self.winchester1874.stats_modifiers = {damage = 2}
self.winchester1874.fire_mode_data.fire_rate = 60 / 75
self.winchester1874.AMMO_PICKUP = pickup_tables.sniper_mid
self.winchester1874.AMMO_MAX = total_ammo_tables.sniper
self.winchester1874.kick = kick_tables.sniper_low

-- Rattlesnake
self.msr.stats.damage = 155
self.msr.stats_modifiers = {damage = 2}
self.msr.AMMO_PICKUP = pickup_tables.sniper_mid
self.msr.AMMO_MAX = total_ammo_tables.sniper
self.msr.kick = kick_tables.sniper_low

-- R700
self.r700.stats.damage = 155
self.r700.stats_modifiers = {damage = 2}
self.r700.AMMO_PICKUP = pickup_tables.sniper_mid
self.r700.fire_mode_data.fire_rate = 60 / 60
self.r700.AMMO_MAX = total_ammo_tables.sniper
self.r700.kick = kick_tables.sniper_low

-- Desert Fox
self.desertfox.AMMO_MAX = total_ammo_tables.sniper
self.desertfox.AMMO_PICKUP = pickup_tables.sniper_low
self.desertfox.fire_mode_data.fire_rate = 60 / 50
self.desertfox.kick = kick_tables.sniper_mid

-- Nagant
self.mosin.AMMO_MAX = 30
self.mosin.fire_mode_data.fire_rate = 60 / 70
self.mosin.AMMO_PICKUP = pickup_tables.sniper_low
self.mosin.AMMO_MAX = total_ammo_tables.sniper
self.mosin.kick = kick_tables.sniper_mid

-- R93
self.r93.fire_mode_data.fire_rate = 60 / 55
self.r93.AMMO_PICKUP = pickup_tables.sniper_low
self.r93.AMMO_MAX = total_ammo_tables.sniper
self.r93.kick = kick_tables.sniper_mid

-- Platypus
self.model70.CLIP_AMMO_MAX = 6
self.model70.AMMO_MAX = total_ammo_tables.sniper
self.model70.AMMO_PICKUP = pickup_tables.sniper_low
self.model70.kick = kick_tables.sniper_mid

-- Thanatos
self.m95.stats.damage = 125
self.m95.stats_modifiers = {damage = 8}
self.m95.AMMO_PICKUP = {0.55, 0.65}
self.m95.AMMO_MAX = total_ammo_tables.secondary_sniper
self.m95.kick.standing = {4, 5, -1, 1}
self.m95.kick.crouching = self.m95.kick.standing
self.m95.kick.steelsight = self.m95.kick.standing

-- Rangehitter
self.sbl.use_data.selection_index = SELECTION.SECONDARY
self.sbl.AMMO_MAX = total_ammo_tables.secondary_sniper
self.sbl.CLIP_AMMO_MAX = 10
self.sbl.stats.damage = 145
self.sbl.AMMO_PICKUP = pickup_tables.secondary_sniper
self.sbl.fire_mode_data.fire_rate = 60 / 150
self.sbl.kick = kick_tables.sniper_auto
self.sbl.categories = {"snp", "ng"}

-- Scout
self.scout.stats.damage = 155
self.scout.AMMO_MAX = total_ammo_tables.secondary_sniper
self.scout.AMMO_PICKUP = pickup_tables.secondary_sniper
self.scout.kick = kick_tables.sniper_low

-- North Star
self.victor.AMMO_MAX = total_ammo_tables.secondary_sniper
self.victor.stats.damage = 145
self.victor.stats_modifiers = {damage = 2}
self.victor.AMMO_PICKUP = pickup_tables.secondary_sniper
self.victor.kick = kick_tables.sniper_auto
self.victor.categories = {"snp", "ng"}

-- Aran
self.contender.AMMO_MAX = total_ammo_tables.secondary_sniper
self.contender.stats.damage = 120
self.contender.stats_modifiers = {damage = 4}
self.contender.fire_mode_data.fire_rate = 60 / 70
self.contender.AMMO_PICKUP = pickup_tables.secondary_sniper
self.contender.kick = kick_tables.sniper_mid



-- LMGs and Miniguns

-- KSP
self.m249.stats.damage = 60
self.m249.stats.reload = 9
self.m249.stats.recoil = 6
self.m249.stats.concealment = 0
self.m249.AMMO_MAX = total_ammo_tables.lmg_high
self.m249.AMMO_PICKUP = pickup_tables.lmg
self.m249.kick = kick_tables.lmg
self.m249.spray = spray_tables.lmg_right
self.m249.recoil_recovery_timer = recovery_tables.high

-- KSP 58
self.par.stats.damage = 60
self.par.stats.reload = 9
self.par.stats.recoil = 6
self.par.stats.concealment = 0
self.par.AMMO_MAX = total_ammo_tables.lmg_high
self.par.AMMO_PICKUP = pickup_tables.lmg
self.par.kick = kick_tables.lmg
self.par.spray = spray_tables.lmg_left
self.par.recoil_recovery_timer = recovery_tables.high


-- Buzzsaw
self.mg42.stats.damage = 60
self.mg42.stats.reload = 9
self.mg42.stats.recoil = 6
self.mg42.stats.concealment = 0
self.mg42.AMMO_MAX = total_ammo_tables.lmg_low
self.mg42.AMMO_PICKUP = pickup_tables.lmg
self.mg42.kick = kick_tables.lmg
self.mg42.spray = spray_tables.lmg_left
self.mg42.recoil_recovery_timer = recovery_tables.high


-- RPK
self.rpk.stats.spread = 10
self.rpk.stats.damage = 80
self.rpk.stats.reload = 9
self.rpk.stats.recoil = 2
self.rpk.stats.concealment = 1
self.rpk.AMMO_MAX = total_ammo_tables.lmg_low
self.rpk.AMMO_PICKUP = pickup_tables.lmg
self.rpk.kick = kick_tables.lmg_high
self.rpk.spray = spray_tables.lmg_right
self.rpk.recoil_recovery_timer = recovery_tables.high

-- Brenner
self.hk21.stats.spread = 12
self.hk21.stats.damage = 80
self.hk21.stats.reload = 9
self.hk21.stats.recoil = 2
self.hk21.stats.concealment = 0
self.hk21.AMMO_MAX = total_ammo_tables.lmg_low
self.hk21.AMMO_PICKUP = pickup_tables.lmg
self.hk21.kick = kick_tables.lmg_high
self.hk21.spray = spray_tables.lmg_left
self.hk21.recoil_recovery_timer = recovery_tables.high

-- M60
self.m60.stats.damage = 80
self.m60.stats.reload = 9
self.m60.stats.recoil = 3
self.m60.stats.concealment = 0
self.m60.AMMO_MAX = total_ammo_tables.lmg_low
self.m60.AMMO_PICKUP = pickup_tables.lmg
self.m60.kick = kick_tables.lmg_high
self.m60.spray = spray_tables.lmg_right
self.m60.recoil_recovery_timer = recovery_tables.high

-- Akron
self.hcar.stats.damage = 80
self.hcar.stats.concealment = 0
self.hcar.AMMO_MAX = total_ammo_tables.ar_low
self.hcar.AMMO_PICKUP = pickup_tables.ar_low
self.hcar.kick = kick_tables.lmg_high
self.hcar.spray = spray_tables.lmg_left
self.hcar.recoil_recovery_timer = recovery_tables.high

-- verstchektshscxd
self.hk51b.stats.damage = 75
self.hk51b.stats.reload = 9
self.hk51b.stats.concealment = 10
self.hk51b.AMMO_PICKUP = pickup_tables.ar_mid
self.hk51b.AMMO_MAX = total_ammo_tables.ar_low
self.hk51b.kick = kick_tables.lmg_high
self.hk51b.spray = spray_tables.lmg_left
self.hk51b.recoil_recovery_timer = recovery_tables.high

-- Minigun
self.m134.stats.damage = 40
self.m134.stats.concealment = 0
self.m134.AMMO_PICKUP = pickup_tables.minigun
self.m134.kick = kick_tables.mini
self.m134.spray = spray_tables.mini
self.m134.recoil_recovery_timer = recovery_tables.high

-- Microgun
self.shuno.stats.damage = 60
self.shuno.stats.concealment = 0
self.shuno.stats.recoil = 0
self.shuno.AMMO_PICKUP = pickup_tables.minigun
self.shuno.kick = kick_tables.micro
self.shuno.spray = spray_tables.mini
self.shuno.recoil_recovery_timer = recovery_tables.high

-- Hailstorm
self.hailstorm.stats.concealment = 3
-- self.hailstorm.AMMO_MAX = this one's fine actually
self.hailstorm.AMMO_PICKUP = pickup_tables.minigun
self.hailstorm.kick = kick_tables.hailstorm
self.hailstorm.kick.volley = kick_tables.hailstorm_volley
self.hailstorm.spray = spray_tables.ar_left_mid
self.hailstorm.recoil_recovery_timer = recovery_tables.high
self.hailstorm.fire_mode_data.volley.can_shoot_through_wall = true
self.hailstorm.fire_mode_data.volley.spread_mul = 1
self.hailstorm.fire_mode_data.volley.damage_mul = 15
self.hailstorm.fire_mode_data.volley.rays = 10
self.hailstorm.fire_mode_data.volley.ammo_usage = 120


-- Shotguns

-- Izhma
self.saiga.rays = 8
self.saiga.stats.damage = 80
self.saiga.stats.spread = 12
self.saiga.AMMO_MAX = total_ammo_tables.shot_very_high
self.saiga.AMMO_PICKUP = pickup_tables.shot_very_high
self.saiga.kick = kick_tables.shot_auto
self.saiga.spray = spray_tables.sg_auto
self.saiga.recoil_recovery_timer = recovery_tables.high
self.saiga.damage_falloff = FALLOFF_TEMPLATE.SHOTGUN_FALL_NORMAL

-- Steakout
self.aa12.rays = 8
self.aa12.stats.damage = 80
self.aa12.stats.spread = 12
self.aa12.AMMO_MAX = total_ammo_tables.shot_very_high
self.aa12.AMMO_PICKUP = pickup_tables.shot_very_high
self.aa12.fire_mode_data.fire_rate = 60 / 333
self.aa12.kick = kick_tables.shot_auto
self.aa12.spray = spray_tables.sg_auto
self.aa12.recoil_recovery_timer = recovery_tables.high
self.aa12.damage_falloff = FALLOFF_TEMPLATE.SHOTGUN_FALL_NORMAL

-- VD-12
self.sko12.rays = 8
self.sko12.stats.damage = 110
self.sko12.stats.spread = 12
self.sko12.stats.recoil = 8
self.sko12.stats.reload = 9
self.sko12.stats.concealment = 2
self.sko12.CLIP_AMMO_MAX = 13
self.sko12.AMMO_MAX = total_ammo_tables.shot_high
self.sko12.AMMO_PICKUP = pickup_tables.shot_high
self.sko12.FIRE_MODE = "single"
self.sko12.CAN_TOGGLE_FIREMODE = false
self.sko12.fire_mode_data.fire_rate = 60 / 333
self.sko12.kick = kick_tables.shot_low
self.sko12.damage_falloff = FALLOFF_TEMPLATE.SHOTGUN_FALL_NORMAL

-- M1014
self.benelli.rays = 8
self.benelli.stats.damage = 110
self.benelli.stats.spread = 12
self.benelli.AMMO_MAX = total_ammo_tables.shot_high
self.benelli.AMMO_PICKUP = pickup_tables.shot_high
self.benelli.fire_mode_data.fire_rate = 60 / 383
self.benelli.kick = kick_tables.shot_low
self.benelli.damage_falloff = FALLOFF_TEMPLATE.SHOTGUN_FALL_NORMAL

-- Predator
self.spas12.rays = 8
self.spas12.stats.damage = 110
self.spas12.stats.spread = 12
self.spas12.AMMO_MAX = total_ammo_tables.shot_high
self.spas12.AMMO_PICKUP = pickup_tables.shot_high
self.spas12.fire_mode_data.fire_rate = 60 / 383
self.spas12.kick = kick_tables.shot_low
self.spas12.damage_falloff = FALLOFF_TEMPLATE.SHOTGUN_FALL_NORMAL

-- Raven
self.ksg.rays = 8
self.ksg.stats.damage = 155
self.ksg.stats.concealment = 20
self.ksg.stats.reload = 12
self.ksg.CLIP_AMMO_MAX = 10
self.ksg.AMMO_MAX = total_ammo_tables.shot_mid
self.ksg.AMMO_PICKUP = pickup_tables.shot_mid
self.ksg.fire_mode_data.fire_rate = 0.6
self.ksg.kick = kick_tables.shot_low
self.ksg.damage_falloff = FALLOFF_TEMPLATE.SHOTGUN_FALL_MODERATE

-- Reinfeld 880
self.r870.rays = 8
self.r870.stats.damage = 155
self.r870.CLIP_AMMO_MAX = 8
self.r870.AMMO_MAX = total_ammo_tables.shot_mid
self.r870.AMMO_PICKUP = pickup_tables.shot_mid
self.r870.fire_mode_data.fire_rate = 0.6
self.r870.kick = kick_tables.shot_low
self.r870.damage_falloff = FALLOFF_TEMPLATE.SHOTGUN_FALL_MODERATE

-- Mosconi Tactical
self.m590.rays = 8
self.m590.stats.reload = 11
self.m590.stats.damage = 155
self.m590.stats.concealment = 8
self.m590.AMMO_MAX = total_ammo_tables.shot_mid
self.m590.AMMO_PICKUP = pickup_tables.shot_mid
self.m590.fire_mode_data.fire_rate = 0.6
self.m590.kick = kick_tables.shot_low
self.m590.damage_falloff = FALLOFF_TEMPLATE.SHOTGUN_FALL_MODERATE

-- Breaker
self.boot.rays = 8
self.boot.stats.damage = 135
self.boot.stats_modifiers = {damage = 2}
self.boot.AMMO_MAX = total_ammo_tables.shot_low
self.boot.AMMO_PICKUP = pickup_tables.shot_low
self.boot.fire_mode_data.fire_rate = 0.8
self.boot.kick = kick_tables.shot_high
self.boot.damage_falloff = FALLOFF_TEMPLATE.SHOTGUN_FALL_HIGH

-- Reinfeld 88 (Trench Gun)
self.m1897.rays = 8
self.m1897.stats.damage = 135
self.m1897.stats_modifiers = {damage = 2}
self.m1897.AMMO_MAX = total_ammo_tables.shot_low
self.m1897.AMMO_PICKUP = pickup_tables.shot_low
self.m1897.fire_mode_data.fire_rate = 0.8
self.m1897.kick = kick_tables.shot_high
self.m1897.damage_falloff = FALLOFF_TEMPLATE.SHOTGUN_FALL_HIGH

-- GSPS
self.m37.use_data.selection_index = SELECTION.PRIMARY
self.m37.rays = 8
self.m37.stats.damage = 135
self.m37.stats_modifiers = {damage = 2}
self.m37.AMMO_MAX = total_ammo_tables.shot_low
self.m37.AMMO_PICKUP = pickup_tables.shot_low
self.m37.fire_mode_data.fire_rate = 0.8
self.m37.kick = kick_tables.shot_high
self.m37.damage_falloff = FALLOFF_TEMPLATE.SHOTGUN_FALL_HIGH

-- Mosconi
self.huntsman.rays = 8
self.huntsman.stats.damage = 180
self.huntsman.stats_modifiers = {damage = 2}
self.huntsman.AMMO_MAX = total_ammo_tables.shot_very_low
self.huntsman.AMMO_PICKUP = pickup_tables.shot_very_low
self.huntsman.kick = kick_tables.shot_high
self.huntsman.damage_falloff = FALLOFF_TEMPLATE.SHOTGUN_FALL_VHIGH

-- Joceline
self.b682.rays = 8
self.b682.stats.damage = 180
self.b682.stats_modifiers = {damage = 2}
self.b682.AMMO_MAX = total_ammo_tables.shot_very_low
self.b682.AMMO_PICKUP = pickup_tables.shot_very_low
self.b682.kick = kick_tables.shot_high
self.b682.damage_falloff = FALLOFF_TEMPLATE.SHOTGUN_FALL_VHIGH

-- Claire
self.coach.rays = 8
self.coach.stats.damage = 180
self.coach.stats_modifiers = {damage = 2}
self.coach.AMMO_MAX = total_ammo_tables.shot_very_low
self.coach.AMMO_PICKUP = pickup_tables.shot_special
self.coach.kick = kick_tables.shot_high
self.coach.damage_falloff = FALLOFF_TEMPLATE.SHOTGUN_FALL_VHIGH

-- Judge
self.judge.rays = 8
self.judge.stats.damage = 100
self.judge.stats_modifiers = {damage = 2}
self.judge.AMMO_MAX = total_ammo_tables.shot_very_low
self.judge.AMMO_PICKUP = pickup_tables.shot_special
self.judge.AMMO_MAX = 25
self.judge.kick = kick_tables.shot_low
self.judge.damage_falloff = FALLOFF_TEMPLATE.SHOTGUN_FALL_HIGH

-- Loco
self.serbu.AMMO_MAX = 24
self.serbu.CLIP_AMMO_MAX = 4
self.serbu.rays = 8
self.serbu.stats.damage = 155
self.serbu.AMMO_MAX = total_ammo_tables.shot_mid
self.serbu.AMMO_PICKUP = pickup_tables.shot_mid
self.serbu.fire_mode_data.fire_rate = 0.6
self.serbu.kick = kick_tables.shot_low
self.serbu.damage_falloff = FALLOFF_TEMPLATE.SHOTGUN_FALL_MODERATE

-- Goliath
self.rota.rays = 8
self.rota.stats.damage = 110
self.rota.AMMO_MAX = total_ammo_tables.shot_high
self.rota.AMMO_PICKUP = pickup_tables.shot_high
self.rota.kick = kick_tables.shot_low
self.rota.damage_falloff = FALLOFF_TEMPLATE.SHOTGUN_FALL_NORMAL

-- Sweeper
self.striker.rays = 8
self.striker.stats.damage = 110
self.striker.stats.concealment = 24
self.striker.AMMO_MAX = total_ammo_tables.shot_high
self.striker.AMMO_PICKUP = pickup_tables.shot_high
self.striker.kick = kick_tables.shot_low
self.striker.damage_falloff = FALLOFF_TEMPLATE.SHOTGUN_FALL_NORMAL

-- Grimm
self.basset.rays = 8
self.basset.stats.damage = 75
self.basset.AMMO_MAX = total_ammo_tables.shot_high
self.basset.AMMO_PICKUP = pickup_tables.shot_very_high
self.basset.kick = kick_tables.shot_auto
self.basset.spray = spray_tables.sg_auto
self.basset.recoil_recovery_timer = recovery_tables.high
self.basset.damage_falloff = FALLOFF_TEMPLATE.SHOTGUN_FALL_NORMAL

-- Argos
self.ultima.rays = 8
self.ultima.stats.damage = 155
self.ultima.stats.reload = 10
self.ultima.stats.concealment = 17
self.ultima.AMMO_MAX = total_ammo_tables.shot_mid
self.ultima.AMMO_PICKUP = pickup_tables.shot_mid
self.ultima.kick = kick_tables.shot_low
self.ultima.damage_falloff = FALLOFF_TEMPLATE.SHOTGUN_FALL_MODERATE


-- ARs

-- AMCAR
self.amcar.fire_mode_data = {fire_rate = 60 / 700}
self.amcar.auto = {fire_rate = 60 / 700}
self.amcar.stats.damage = 52
self.amcar.stats.spread = 14
self.amcar.stats.recoil = 16
self.amcar.AMMO_MAX = total_ammo_tables.ar_high
self.amcar.AMMO_PICKUP = pickup_tables.ar_high
self.amcar.kick = kick_tables.ar_low
self.amcar.spray = spray_tables.ar_right_low
self.amcar.recoil_recovery_timer = recovery_tables.low

-- Commando 553
self.s552.stats.spread = 14
self.s552.stats.concealment = 18
self.s552.AMMO_MAX = total_ammo_tables.ar_high
self.s552.AMMO_PICKUP = pickup_tables.ar_high
self.s552.kick = kick_tables.ar_low
self.s552.spray = spray_tables.ar_left_low
self.s552.recoil_recovery_timer = recovery_tables.low

-- Clarion
self.famas.stats.damage = 43
self.famas.stats.recoil = 13
self.famas.AMMO_MAX = total_ammo_tables.ar_high
self.famas.AMMO_PICKUP = pickup_tables.ar_high
self.famas.kick = kick_tables.ar_low
self.famas.spray = spray_tables.ar_left_low
self.famas.recoil_recovery_timer = recovery_tables.low

-- JP36
self.g36.stats.spread = 14
self.g36.AMMO_MAX = total_ammo_tables.ar_high
self.g36.AMMO_PICKUP = pickup_tables.ar_high
self.g36.kick = kick_tables.ar_low
self.g36.spray = spray_tables.ar_right_low
self.g36.recoil_recovery_timer = recovery_tables.low

-- AS Val
self.asval.stats.damage = 46
self.asval.AMMO_MAX = total_ammo_tables.ar_high
self.asval.AMMO_PICKUP = pickup_tables.ar_high
self.asval.kick = kick_tables.ar_low
self.asval.spray = spray_tables.ar_right_low
self.asval.recoil_recovery_timer = recovery_tables.low

-- CAR-4
self.new_m4.fire_mode_data.fire_rate = 60 / 780
self.new_m4.AMMO_MAX = total_ammo_tables.ar_mid
self.new_m4.AMMO_PICKUP = pickup_tables.ar_mid
self.new_m4.kick = kick_tables.ar_mid
self.new_m4.spray = spray_tables.ar_left_mid
self.new_m4.recoil_recovery_timer = recovery_tables.mid

-- AK5
self.ak5.AMMO_MAX = total_ammo_tables.ar_mid
self.ak5.AMMO_PICKUP = pickup_tables.ar_mid
self.ak5.kick = kick_tables.ar_mid
self.ak5.spray = spray_tables.ar_right_mid
self.ak5.recoil_recovery_timer = recovery_tables.mid

-- Union
self.corgi.stats.damage = 62
self.corgi.AMMO_MAX = total_ammo_tables.ar_mid
self.corgi.AMMO_PICKUP = pickup_tables.ar_mid
self.corgi.kick = kick_tables.ar_mid
self.corgi.spray = spray_tables.ar_left_mid
self.corgi.recoil_recovery_timer = recovery_tables.mid

-- UAR
self.aug.AMMO_MAX = total_ammo_tables.ar_mid
self.aug.AMMO_PICKUP = pickup_tables.ar_mid
self.aug.kick = kick_tables.ar_mid
self.aug.spray = spray_tables.ar_left_mid
self.aug.recoil_recovery_timer = recovery_tables.mid

-- Queen's Wrath
self.l85a2.AMMO_MAX = total_ammo_tables.ar_mid
self.l85a2.AMMO_PICKUP = pickup_tables.ar_mid
self.l85a2.kick = kick_tables.ar_mid
self.l85a2.spray = spray_tables.ar_right_mid
self.l85a2.recoil_recovery_timer = recovery_tables.mid

-- Rodion
self.tkb.AMMO_MAX = total_ammo_tables.ar_mid
self.tkb.AMMO_PICKUP = pickup_tables.ar_mid
self.tkb.kick = kick_tables.ar_mid
self.tkb.spray = spray_tables.ar_right_mid
self.tkb.recoil_recovery_timer = recovery_tables.mid
self.tkb.fire_mode_data.volley = {
	spread_mul = 1,
	damage_mul = 1,
	ammo_usage = 3,
	rays = 3,
	can_shoot_through_wall = false,
	can_shoot_through_shield = true,
	can_shoot_through_enemy = true,
	muzzleflash = "effects/payday2/particles/weapons/tkb_muzzle",
	muzzleflash_silenced = "effects/payday2/particles/weapons/tkb_suppressed"
}

-- Tempest
self.komodo.AMMO_MAX = total_ammo_tables.ar_mid
self.komodo.AMMO_PICKUP = pickup_tables.ar_mid
self.komodo.kick = kick_tables.ar_mid
self.komodo.spray = spray_tables.ar_right_mid
self.komodo.recoil_recovery_timer = recovery_tables.mid

-- AK Rifle
self.ak74.stats.damage = 77
self.ak74.stats.concealment = 15
self.ak74.AMMO_MAX = total_ammo_tables.ar_low
self.ak74.AMMO_PICKUP = pickup_tables.ar_low
self.ak74.kick = kick_tables.ar_high
self.komodo.spray = spray_tables.ar_left_mid
self.komodo.recoil_recovery_timer = recovery_tables.high

-- Lion's Roar
self.vhs.stats.damage = 72
self.vhs.stats.concealment = 12
self.vhs.AMMO_MAX = total_ammo_tables.ar_low
self.vhs.AMMO_PICKUP = pickup_tables.ar_low
self.vhs.kick = kick_tables.ar_high
self.komodo.spray = spray_tables.ar_right_mid
self.komodo.recoil_recovery_timer = recovery_tables.high

-- Gecko
self.galil.stats.damage = 72
self.galil.stats.concealment = 12
self.galil.AMMO_MAX = total_ammo_tables.ar_low
self.galil.AMMO_PICKUP = pickup_tables.ar_low
self.galil.kick = kick_tables.ar_high
self.komodo.spray = spray_tables.ar_left_mid
self.komodo.recoil_recovery_timer = recovery_tables.high

-- CR805
self.hajk.categories = {
	"assault_rifle"
}
self.hajk.stats.damage = 80
self.hajk.AMMO_MAX = total_ammo_tables.ar_low
self.hajk.AMMO_PICKUP = pickup_tables.ar_low
self.hajk.kick = kick_tables.ar_high
self.hajk.spray = spray_tables.ar_left_mid
self.hajk.recoil_recovery_timer = recovery_tables.high
self.hajk.use_data.selection_index = SELECTION.PRIMARY

-- Bootleg
self.tecci.stats.spread = 11
self.tecci.stats.reload = 11
self.tecci.stats.damage = 60
self.tecci.stats.concealment = 5
self.tecci.AMMO_MAX = total_ammo_tables.ar_high
self.tecci.AMMO_PICKUP = pickup_tables.ar_high
self.tecci.kick = kick_tables.ar_mid
self.tecci.spray = spray_tables.ar_right_mid
self.tecci.recoil_recovery_timer = recovery_tables.mid

-- Groza
self.groza.AMMO_MAX = total_ammo_tables.ar_very_low
self.groza.AMMO_PICKUP = pickup_tables.ar_very_low
self.groza.kick = kick_tables.ar_very_high
self.groza.spray = spray_tables.ar_right_high
self.groza.recoil_recovery_timer = recovery_tables.high

-- AK 7.62
self.akm.fire_mode_data = {fire_rate = 0.1}
self.akm.auto = {fire_rate = 0.1}
self.akm.stats.concealment = 10
self.akm.AMMO_MAX = total_ammo_tables.ar_very_low
self.akm.AMMO_PICKUP = pickup_tables.ar_very_low
self.akm.kick = kick_tables.ar_very_high
self.akm.spray = spray_tables.ar_right_high
self.akm.recoil_recovery_timer = recovery_tables.high

-- Gold AK 7.62
self.akm_gold.fire_mode_data = {fire_rate = 0.1}
self.akm_gold.auto = {fire_rate = 0.1}
self.akm_gold.stats.concealment = 10
self.akm_gold.AMMO_MAX = total_ammo_tables.ar_very_low
self.akm_gold.AMMO_PICKUP = pickup_tables.ar_very_low
self.akm_gold.kick = kick_tables.ar_very_high
self.groza.spray = spray_tables.ar_right_high
self.groza.recoil_recovery_timer = recovery_tables.high

-- AK17
self.flint.CLIP_AMMO_MAX = 30
self.flint.stats.concealment = 8
self.flint.AMMO_MAX = total_ammo_tables.ar_very_low
self.flint.AMMO_PICKUP = pickup_tables.ar_very_low
self.flint.kick = kick_tables.ar_very_high
self.flint.spray = spray_tables.ar_left_high
self.flint.recoil_recovery_timer = recovery_tables.high

-- AMR
self.m16.stats.concealment = 8
self.m16.AMMO_MAX = total_ammo_tables.ar_very_low
self.m16.AMMO_PICKUP = pickup_tables.ar_very_low
self.m16.kick = kick_tables.ar_very_high
self.m16.spray = spray_tables.ar_left_high
self.m16.recoil_recovery_timer = recovery_tables.high

-- Eagle Heavy
self.scar.stats.concealment = 10
self.scar.stats.reload = 13
self.scar.AMMO_MAX = total_ammo_tables.ar_very_low
self.scar.AMMO_PICKUP = pickup_tables.ar_very_low
self.scar.kick = kick_tables.ar_very_high
self.scar.spray = spray_tables.ar_right_high
self.scar.recoil_recovery_timer = recovery_tables.high

-- Falcon
self.fal.AMMO_MAX = total_ammo_tables.ar_very_low
self.fal.AMMO_PICKUP = pickup_tables.ar_very_low
self.fal.kick = kick_tables.ar_very_high
self.fal.spray = spray_tables.ar_left_high
self.fal.recoil_recovery_timer = recovery_tables.high

-- Gewehr
self.g3.stats.concealment = 9
self.g3.AMMO_MAX = total_ammo_tables.ar_very_low
self.g3.AMMO_PICKUP = pickup_tables.ar_very_low
self.g3.kick = kick_tables.ar_very_high
self.g3.spray = spray_tables.ar_left_high
self.g3.recoil_recovery_timer = recovery_tables.high

-- KS12
self.shak12.stats.damage = 60
self.shak12.stats_modifiers = {damage = 2}
self.shak12.stats.concealment = 10
self.shak12.AMMO_MAX = total_ammo_tables.ar_very_low
self.shak12.AMMO_PICKUP = pickup_tables.ar_very_low
self.shak12.kick = kick_tables.ks12
self.shak12.spray = spray_tables.ar_right_high
self.shak12.recoil_recovery_timer = recovery_tables.high


-- DMRs

-- Little Friend
self.contraband.AMMO_MAX = total_ammo_tables.dmr_low
self.contraband.AMMO_PICKUP = pickup_tables.dmr_low
self.contraband.stats.damage = 182
self.contraband.kick = kick_tables.dmr_high

-- M308
self.new_m14.AMMO_MAX = total_ammo_tables.dmr
self.new_m14.AMMO_PICKUP = pickup_tables.dmr
self.new_m14.stats.damage = 182
self.new_m14.stats.concealment = 5
self.new_m14.kick = kick_tables.dmr_high

-- Cavity
self.sub2000.CLIP_AMMO_MAX = 20
self.sub2000.AMMO_MAX = total_ammo_tables.dmr
self.sub2000.AMMO_PICKUP = pickup_tables.dmr
self.sub2000.stats.damage = 182
self.sub2000.stats.concealment = 18
self.sub2000.kick = kick_tables.dmr_low

-- Galant
self.ching.AMMO_MAX = total_ammo_tables.dmr
self.ching.AMMO_PICKUP = pickup_tables.dmr
self.ching.stats.damage = 182
self.ching.stats.concealment = 10
self.ching.kick = kick_tables.dmr_low


-- SMGs

-- Blaster
self.tec9.AMMO_MAX = total_ammo_tables.smg_high
self.tec9.AMMO_PICKUP = pickup_tables.smg_high
self.tec9.stats.spread = 11
self.tec9.kick = kick_tables.ar_mid
self.tec9.spray = spray_tables.ar_left_low
self.tec9.recoil_recovery_timer = recovery_tables.low

-- CMP
self.mp9.AMMO_MAX = total_ammo_tables.smg_high
self.mp9.AMMO_PICKUP = pickup_tables.smg_high
self.mp9.stats.spread = 11
self.mp9.kick = kick_tables.ar_mid
self.mp9.spray = spray_tables.ar_right_low
self.mp9.recoil_recovery_timer = recovery_tables.low

-- Cobra
self.scorpion.AMMO_MAX = total_ammo_tables.smg_high
self.scorpion.AMMO_PICKUP = pickup_tables.smg_high
self.scorpion.stats.spread = 11
self.scorpion.kick = kick_tables.ar_mid
self.scorpion.spray = spray_tables.ar_left_low
self.scorpion.recoil_recovery_timer = recovery_tables.low

-- Compact-5
self.new_mp5.AMMO_MAX = total_ammo_tables.smg_high
self.new_mp5.AMMO_PICKUP = pickup_tables.smg_high
self.new_mp5.kick = kick_tables.ar_mid
self.new_mp5.spray = spray_tables.ar_right_mid
self.new_mp5.recoil_recovery_timer = recovery_tables.high

-- Micro Uzi
self.baka.AMMO_MAX = total_ammo_tables.smg_high
self.baka.AMMO_PICKUP = pickup_tables.smg_high
self.baka.stats.spread = 11
self.baka.kick = kick_tables.ar_mid
self.baka.spray = spray_tables.ar_left_low
self.baka.recoil_recovery_timer = recovery_tables.low

-- Signature
self.shepheard.AMMO_MAX = total_ammo_tables.smg_mid
self.shepheard.AMMO_PICKUP = pickup_tables.smg_mid
self.shepheard.stats.spread = 14
self.shepheard.fire_mode_data.fire_rate = 60 / 850
self.shepheard.kick = kick_tables.ar_high
self.shepheard.spray = spray_tables.ar_left_mid
self.shepheard.recoil_recovery_timer = recovery_tables.low

-- Thompson
self.m1928.AMMO_MAX = total_ammo_tables.smg_mid
self.m1928.AMMO_PICKUP = pickup_tables.smg_mid
self.m1928.stats.spread = 15
self.m1928.stats.reload = 13
self.m1928.kick = kick_tables.ar_high
self.m1928.spray = spray_tables.ar_right_mid
self.m1928.recoil_recovery_timer = recovery_tables.mid

-- Heather
self.sr2.AMMO_MAX = total_ammo_tables.smg_mid
self.sr2.AMMO_PICKUP = pickup_tables.smg_mid
self.sr2.kick = kick_tables.ar_high
self.sr2.spray = spray_tables.ar_left_mid
self.sr2.recoil_recovery_timer = recovery_tables.mid

-- Jacket's Piece
self.cobray.AMMO_MAX = total_ammo_tables.smg_mid
self.cobray.AMMO_PICKUP = pickup_tables.smg_mid
self.cobray.kick = kick_tables.ar_high
self.cobray.spray = spray_tables.ar_right_mid
self.cobray.recoil_recovery_timer = recovery_tables.mid

-- Kobus
self.p90.AMMO_MAX = total_ammo_tables.smg_mid
self.p90.AMMO_PICKUP = pickup_tables.smg_mid
self.p90.kick = kick_tables.ar_high
self.p90.spray = spray_tables.ar_left_mid
self.p90.recoil_recovery_timer = recovery_tables.mid

-- Vertex
self.polymer.AMMO_MAX = total_ammo_tables.smg_mid
self.polymer.AMMO_PICKUP = pickup_tables.smg_mid
self.polymer.kick = kick_tables.ar_high
self.polymer.spray = spray_tables.ar_left_mid
self.polymer.recoil_recovery_timer = recovery_tables.mid

-- Mark 10
self.mac10.AMMO_MAX = total_ammo_tables.smg_mid
self.mac10.AMMO_PICKUP = pickup_tables.smg_mid
self.mac10.kick = kick_tables.ar_high
self.mac10.spray = spray_tables.ar_right_mid
self.mac10.recoil_recovery_timer = recovery_tables.mid

-- Wasp
self.fmg9.stats.damage = 58
self.fmg9.stats.spread = 14
self.fmg9.AMMO_MAX = total_ammo_tables.smg_mid
self.fmg9.AMMO_PICKUP = pickup_tables.smg_mid
self.fmg9.kick = kick_tables.ar_mid
self.fmg9.spray = spray_tables.ar_left_mid
self.fmg9.recoil_recovery_timer = recovery_tables.mid
self.fmg9.timers.unequip = 1.2

-- Spec Ops
self.mp7.AMMO_MAX = total_ammo_tables.smg_mid
self.mp7.AMMO_PICKUP = pickup_tables.smg_mid
self.mp7.kick = kick_tables.ar_high
self.mp7.spray = spray_tables.ar_left_mid
self.mp7.recoil_recovery_timer = recovery_tables.mid

-- Miyaka
self.pm9.AMMO_MAX = total_ammo_tables.smg_mid
self.pm9.AMMO_PICKUP = pickup_tables.smg_mid
self.pm9.kick = kick_tables.ar_high
self.pm9.spray = spray_tables.ar_right_mid
self.pm9.recoil_recovery_timer = recovery_tables.mid

-- Para
self.olympic.AMMO_MAX = total_ammo_tables.smg_low
self.olympic.AMMO_PICKUP = pickup_tables.smg_low
self.olympic.stats.damage = 80
self.olympic.kick = kick_tables.ar_very_high
self.olympic.spray = spray_tables.ar_right_mid
self.olympic.recoil_recovery_timer = recovery_tables.high

-- Uzi
self.uzi.stats.damage = 80
self.uzi.AMMO_MAX = total_ammo_tables.smg_low
self.uzi.AMMO_PICKUP = pickup_tables.smg_low
self.uzi.fire_mode_data.fire_rate = 60 / 850
self.uzi.kick = kick_tables.ar_very_high
self.uzi.spray = spray_tables.ar_right_mid
self.uzi.recoil_recovery_timer = recovery_tables.high

-- Krinkov
self.akmsu.stats.damage = 80
self.akmsu.AMMO_MAX = total_ammo_tables.smg_low
self.akmsu.AMMO_PICKUP = pickup_tables.smg_low
self.akmsu.kick = kick_tables.ar_very_high
self.akmsu.spray = spray_tables.ar_left_mid
self.akmsu.recoil_recovery_timer = recovery_tables.high

-- AKGEN
self.vityaz.AMMO_MAX = total_ammo_tables.smg_low
self.vityaz.AMMO_PICKUP = pickup_tables.smg_low
self.vityaz.stats.damage = 100
self.vityaz.kick = kick_tables.ar_very_high
self.vityaz.spray = spray_tables.ar_left_high
self.vityaz.recoil_recovery_timer = recovery_tables.high

-- MP40
self.erma.stats.reload = 13
self.erma.AMMO_MAX = total_ammo_tables.smg_very_low
self.erma.AMMO_PICKUP = pickup_tables.smg_very_low
self.erma.kick = kick_tables.ar_very_high
self.erma.spray = spray_tables.ar_right_high
self.erma.recoil_recovery_timer = recovery_tables.high

-- Tatonka
self.coal.stats.concealment = 5
self.coal.AMMO_MAX = total_ammo_tables.smg_very_low
self.coal.AMMO_PICKUP = pickup_tables.smg_very_low
self.coal.kick = kick_tables.ar_very_high
self.coal.spray = spray_tables.ar_left_high
self.coal.recoil_recovery_timer = recovery_tables.high

-- Pattchet
self.sterling.AMMO_MAX = total_ammo_tables.smg_very_low
self.sterling.AMMO_PICKUP = pickup_tables.smg_very_low
self.sterling.kick = kick_tables.ar_very_high
self.sterling.spray = spray_tables.ar_right_high
self.sterling.recoil_recovery_timer = recovery_tables.high

-- Swedish K
self.m45.AMMO_MAX = total_ammo_tables.smg_very_low
self.m45.AMMO_PICKUP = pickup_tables.smg_very_low
self.m45.kick = kick_tables.ar_very_high
self.m45.spray = spray_tables.ar_right_high
self.m45.recoil_recovery_timer = recovery_tables.high

-- Jackal
self.schakal.AMMO_MAX = total_ammo_tables.smg_very_low
self.schakal.AMMO_PICKUP = pickup_tables.smg_very_low
self.schakal.kick = kick_tables.ar_very_high
self.schakal.spray = spray_tables.ar_left_high
self.schakal.recoil_recovery_timer = recovery_tables.high


-- Revolvers

--Peacemaker
self.peacemaker.AMMO_MAX = 24
self.peacemaker.stats.damage = 145
self.peacemaker.stats.reload = 17
self.peacemaker.AMMO_MAX = total_ammo_tables.revolver_ap
self.peacemaker.AMMO_PICKUP = pickup_tables.revolver_ap
self.peacemaker.kick = kick_tables.revolver_ap
self.peacemaker.can_shoot_through_enemy = true
self.peacemaker.can_shoot_through_shield = true
self.peacemaker.can_shoot_through_wall = true
self.peacemaker.armor_piercing_chance = 1
self.peacemaker.has_description = true
self.peacemaker.desc_id = "bm_w_lemming_desc"


-- Angry Tiger
self.rsh12.stats.damage = 145
self.rsh12.stats_modifiers = {damage = 2}
self.rsh12.stats.reload = 13
self.rsh12.AMMO_MAX = total_ammo_tables.revolver_ap
self.rsh12.AMMO_PICKUP = pickup_tables.revolver_ap
self.rsh12.stats_modifiers = {damage = 1}
self.rsh12.kick = kick_tables.revolver_ap

-- Bronco
self.new_raging_bull.stats.damage = 145
self.new_raging_bull.stats_modifiers = {damage = 2}
self.new_raging_bull.AMMO_MAX = total_ammo_tables.revolver
self.new_raging_bull.AMMO_PICKUP = pickup_tables.revolver
self.new_raging_bull.kick = kick_tables.revolver
self.new_raging_bull.stats.reload = 10

-- Matever
self.mateba.stats.damage = 145
self.mateba.stats_modifiers = {damage = 2}
self.mateba.AMMO_MAX = total_ammo_tables.revolver
self.mateba.AMMO_PICKUP = pickup_tables.revolver
self.mateba.kick = kick_tables.revolver_low
self.mateba.stats.reload = 15

-- Castigo
self.chinchilla.stats.damage = 145
self.chinchilla.stats.spread = 21
self.chinchilla.stats_modifiers = {damage = 2}
self.chinchilla.AMMO_MAX = total_ammo_tables.revolver
self.chinchilla.AMMO_PICKUP = pickup_tables.revolver
self.chinchilla.kick = kick_tables.revolver_low
self.chinchilla.stats.reload = 13

-- Kahn
self.korth.stats.damage = 72
self.korth.stats.spread = 21
self.korth.stats_modifiers = {damage = 2}
self.korth.AMMO_MAX = total_ammo_tables.revolver
self.korth.AMMO_PICKUP = pickup_tables.revolver_high
self.korth.kick = kick_tables.revolver

-- Frenchman
self.model3.stats.damage = 180
self.model3.stats.reload = 14
self.model3.AMMO_MAX = total_ammo_tables.revolver
self.model3.AMMO_PICKUP = pickup_tables.revolver_high
self.model3.kick = kick_tables.revolver_low


-- Pistols

-- Chimano 88
self.glock_17.AMMO_MAX = total_ammo_tables.pistol_high
self.glock_17.AMMO_PICKUP = pickup_tables.pistol_high
self.glock_17.kick = kick_tables.pistol_low

-- Chimano Compact
self.g26.AMMO_MAX = total_ammo_tables.pistol_high
self.g26.AMMO_PICKUP = pickup_tables.pistol_high
self.g26.kick = kick_tables.pistol_low

-- Gruber
self.ppk.AMMO_MAX = total_ammo_tables.pistol_high
self.ppk.AMMO_PICKUP = pickup_tables.pistol_high
self.ppk.kick = kick_tables.pistol_low

-- Bernetti 9
self.b92fs.AMMO_MAX = total_ammo_tables.pistol_high
self.b92fs.AMMO_PICKUP = pickup_tables.pistol_high
self.b92fs.kick = kick_tables.pistol_low

-- M13
self.legacy.AMMO_MAX = total_ammo_tables.pistol_high
self.legacy.AMMO_PICKUP = pickup_tables.pistol_high
self.legacy.kick = kick_tables.pistol_low

-- Crosskill Guard
self.shrew.AMMO_MAX = total_ammo_tables.pistol_high
self.shrew.AMMO_PICKUP = pickup_tables.pistol_high
self.shrew.kick = kick_tables.pistol_low

-- Interceptor
self.usp.AMMO_MAX = total_ammo_tables.pistol_mid
self.usp.AMMO_PICKUP = pickup_tables.pistol_mid
self.usp.kick = kick_tables.pistol_mid

-- Signature
self.p226.AMMO_MAX = total_ammo_tables.pistol_mid
self.p226.AMMO_PICKUP = pickup_tables.pistol_mid
self.usp.kick = kick_tables.pistol_mid

-- Crosskill
self.colt_1911.AMMO_MAX = total_ammo_tables.pistol_mid
self.colt_1911.AMMO_PICKUP = pickup_tables.pistol_mid
self.usp.kick = kick_tables.pistol_mid

-- Chimano Custom
self.g22c.AMMO_MAX = total_ammo_tables.pistol_mid
self.g22c.AMMO_PICKUP = pickup_tables.pistol_mid
self.g22c.kick = kick_tables.pistol_mid

-- Broomstick
self.c96.stats.reload = 13
self.c96.AMMO_MAX = total_ammo_tables.pistol_mid
self.c96.AMMO_PICKUP = pickup_tables.pistol_mid
self.c96.kick = kick_tables.pistol_mid

-- Contractor
self.packrat.AMMO_MAX = total_ammo_tables.pistol_mid
self.packrat.AMMO_PICKUP = pickup_tables.pistol_mid
self.packrat.kick = kick_tables.pistol_mid

-- LEO
self.hs2000.AMMO_MAX = total_ammo_tables.pistol_mid
self.hs2000.AMMO_PICKUP = pickup_tables.pistol_mid
self.hs2000.kick = kick_tables.pistol_mid

-- Holt
self.holt.AMMO_MAX = total_ammo_tables.pistol_mid
self.holt.AMMO_PICKUP = pickup_tables.pistol_mid
self.holt.kick = kick_tables.pistol_mid

-- Deagle
self.deagle.stats.damage = 140
self.deagle.AMMO_MAX = total_ammo_tables.pistol_low
self.deagle.AMMO_PICKUP = pickup_tables.pistol_low
self.deagle.kick = kick_tables.pistol_high

-- Beagle
self.sparrow.stats.damage = 140
self.sparrow.AMMO_MAX = total_ammo_tables.pistol_low
self.sparrow.AMMO_PICKUP = pickup_tables.pistol_low
self.sparrow.kick = kick_tables.pistol_high

-- White Streak
self.pl14.stats.damage = 140
self.pl14.AMMO_MAX = total_ammo_tables.pistol_low
self.pl14.AMMO_PICKUP = pickup_tables.pistol_low
self.pl14.kick = kick_tables.pistol_high

-- Chunky Crosskill
self.m1911.stats.damage = 140
self.m1911.AMMO_MAX = total_ammo_tables.pistol_low
self.m1911.AMMO_PICKUP = pickup_tables.pistol_low
self.m1911.kick = kick_tables.pistol_high

-- Gecko M2
self.maxim9.stats.damage = 140
self.maxim9.AMMO_MAX = total_ammo_tables.pistol_low
self.maxim9.AMMO_PICKUP = pickup_tables.pistol_low
self.maxim9.kick = kick_tables.pistol_high

-- Kang Arms
self.type54.AMMO_MAX = total_ammo_tables.pistol_low
self.type54.AMMO_PICKUP = pickup_tables.pistol_low
self.type54.kick = kick_tables.pistol_high

-- Parabellum
self.breech.AMMO_MAX = total_ammo_tables.pistol_very_low
self.breech.AMMO_PICKUP = pickup_tables.pistol_very_low
self.breech.kick = kick_tables.pistol_high

-- Bernetti Auto
self.beer.stats.damage = 38
self.beer.AMMO_MAX = total_ammo_tables.pistol_high
self.beer.AMMO_PICKUP = pickup_tables.pistol_high
self.beer.kick = kick_tables.pistol_auto

-- Stryk
self.glock_18c.stats.damage = 45
self.glock_18c.AMMO_MAX = total_ammo_tables.pistol_mid
self.glock_18c.AMMO_PICKUP = pickup_tables.pistol_mid
self.glock_18c.kick = kick_tables.pistol_auto

-- Czech
self.czech.stats.damage = 45
self.czech.AMMO_MAX = total_ammo_tables.pistol_mid
self.czech.AMMO_PICKUP = pickup_tables.pistol_mid
self.czech.kick = kick_tables.pistol_auto

-- Igor
self.stech.stats.damage = 70
self.stech.AMMO_MAX = total_ammo_tables.pistol_low
self.stech.AMMO_PICKUP = pickup_tables.pistol_low
self.stech.kick = kick_tables.pistol_auto

-- 5/7
self.lemming.AMMO_MAX = total_ammo_tables.pistol_low
self.lemming.AMMO_PICKUP = pickup_tables.pistol_ap
self.lemming.kick = kick_tables.pistol_mid


-- Grenade / Rocket launchers

-- Commando 101
self.ray.use_data.selection_index = SELECTION.PRIMARY
self.ray.categories = {"grenade_launcher", "heavy"}
self.ray.stats.damage = 128
self.ray.stats_modifiers = {damage = 10}
self.ray.stats.reload = 8
self.ray.AMMO_PICKUP = {0.04, 0.04}

-- RPG
self.rpg7.use_data.selection_index = SELECTION.PRIMARY
self.rpg7.categories = {"grenade_launcher", "heavy"}
self.rpg7.stats.damage = 128
self.rpg7.stats_modifiers = {damage = 20}
self.rpg7.stats.reload = 13
self.rpg7.AMMO_PICKUP = {0.04, 0.04}

-- Piglet
self.m32.stats.damage = 50
self.m32.AMMO_PICKUP = {0.084, 0.084}
self.m32.AMMO_MAX = 18
self.m32.stats.reload = 15
self.m32.fire_mode_data.fire_rate = 60 / 120

-- China Puff
self.china.use_data.selection_index = SELECTION.PRIMARY
self.china.stats.damage = 50
self.china.stats.concealment = 16
self.china.AMMO_MAX = 9
self.china.AMMO_PICKUP = {0.067, 0.067}

-- Arbiter
self.arbiter.use_data.selection_index = SELECTION.PRIMARY
self.arbiter.stats.damage = 40
self.arbiter.AMMO_PICKUP = {0.084, 0.084}

-- Basilisk
self.ms3gl.use_data.selection_index = SELECTION.PRIMARY
self.ms3gl.stats.damage = 36
self.ms3gl.AMMO_PICKUP = {0.1, 0.1}

-- GL40
self.gre_m79.use_data.selection_index = SELECTION.SECONDARY
self.gre_m79.stats.damage = 82
self.gre_m79.AMMO_MAX = 7
self.gre_m79.AMMO_PICKUP = {0.067, 0.067}

-- Compact 40
self.slap.stats.damage = 82
self.slap.AMMO_MAX = 7
self.slap.AMMO_PICKUP = {0.067, 0.067}

-- Underbarrel Grenade Launchers
self.contraband_m203.AMMO_PICKUP = {0.067, 0.067}
self.groza_underbarrel.AMMO_PICKUP = {0.067, 0.067}


-- Specials

-- Heavy Crossbow
self.arblast.AMMO_MAX = 45
self.arblast.stats.damage = 10
self.arblast.stats.concealment = 24

-- Light Crossbow
self.frankish.AMMO_MAX = 45
self.frankish.stats.damage = 50
self.frankish.stats.concealment = 25
self.frankish.use_data.selection_index = SELECTION.SECONDARY

-- Pistol Crossbow
self.hunter.AMMO_MAX = 45
self.hunter.stats.concealment = 30

-- Airbow
self.ecp.AMMO_MAX = 45
self.ecp.stats.damage = 25
self.ecp.use_data.selection_index = SELECTION.SECONDARY

-- Plainsrider
self.plainsrider.AMMO_MAX = 45
self.plainsrider.stats.damage = 80
self.plainsrider.stats.concealment = 23
self.plainsrider.use_data.selection_index = SELECTION.SECONDARY


-- Akimbos

-- Stryks
self.x_g18c.AMMO_MAX = total_ammo_tables.akimbo_pis_high
self.x_g18c.AMMO_PICKUP = pickup_tables.pistol_high
self.x_g18c.stats.concealment = 14
self.x_g18c.stats.recoil = 12
self.x_g18c.stats.reload = 8
self.x_g18c.stats.damage = 45
self.x_g18c.kick = kick_tables.akimbo_pistol_auto
self.x_g18c.spray = spray_tables.ar_left_low
self.x_g18c.recoil_recovery_timer = recovery_tables.high

-- Czechs
self.x_czech.AMMO_MAX = total_ammo_tables.akimbo_pis_high
self.x_czech.AMMO_PICKUP = pickup_tables.pistol_high
self.x_czech.stats.concealment = 14
self.x_czech.stats.recoil = 11
self.x_czech.stats.spread = 15
self.x_czech.stats.reload = 8
self.x_czech.stats.damage = 45
self.x_czech.kick = kick_tables.akimbo_pistol_auto
self.x_g18c.spray = spray_tables.ar_right_low
self.x_g18c.recoil_recovery_timer = recovery_tables.high

-- Chimano Compacts
self.jowi.AMMO_MAX = total_ammo_tables.akimbo_pis_mid
self.jowi.AMMO_PICKUP = pickup_tables.pistol_mid
self.jowi.kick = kick_tables.pistol_low

-- Bernetti 9s
self.x_b92fs.AMMO_MAX = total_ammo_tables.akimbo_pis_mid
self.x_b92fs.AMMO_PICKUP = pickup_tables.pistol_mid
self.x_b92fs.kick = kick_tables.pistol_low

-- Chimano 88s
self.x_g17.AMMO_MAX = total_ammo_tables.akimbo_pis_mid
self.x_g17.AMMO_PICKUP = pickup_tables.pistol_mid
self.x_g17.kick = kick_tables.pistol_low

-- Crosskills
self.x_1911.AMMO_MAX = total_ammo_tables.akimbo_pis_low
self.x_1911.AMMO_PICKUP = pickup_tables.pistol_low
self.x_1911.kick = kick_tables.pistol_mid

-- Chimano Customs
self.x_g22c.AMMO_MAX = total_ammo_tables.akimbo_pis_low
self.x_g22c.AMMO_PICKUP = pickup_tables.pistol_low
self.x_g22c.kick = kick_tables.pistol_mid

-- Interceptors
self.x_usp.AMMO_MAX = total_ammo_tables.akimbo_pis_low
self.x_usp.AMMO_PICKUP = pickup_tables.pistol_low
self.x_usp.kick = kick_tables.pistol_mid

-- Contractors
self.x_packrat.AMMO_MAX = total_ammo_tables.akimbo_pis_low
self.x_packrat.AMMO_PICKUP = pickup_tables.pistol_low
self.x_packrat.kick = kick_tables.pistol_mid

-- Deagles
self.x_deagle.stats.damage = 140
self.x_deagle.AMMO_MAX = total_ammo_tables.akimbo_pis_low
self.x_deagle.AMMO_PICKUP = pickup_tables.pistol_low
self.x_deagle.kick = kick_tables.pistol_high

-- Castigos
self.x_chinchilla.stats.damage = 120
self.x_chinchilla.stats.spread = 21
self.x_chinchilla.stats_modifiers = {damage = 2}
self.x_chinchilla.AMMO_MAX = total_ammo_tables.akimbo_special
self.x_chinchilla.AMMO_PICKUP = pickup_tables.revolver
self.x_chinchilla.kick = kick_tables.revolver_low

-- Judges
self.x_judge.rays = 8
self.x_judge.stats.damage = 115
self.x_judge.stats_modifiers = {damage = 2}
self.x_judge.kick = kick_tables.shot_low
self.x_judge.AMMO_MAX = total_ammo_tables.akimbo_special
self.x_judge.AMMO_PICKUP = pickup_tables.shot_special
self.x_judge.damage_falloff = FALLOFF_TEMPLATE.SHOTGUN_FALL_HIGH


-- Flamethrowers

-- mk2
self.flamethrower_mk2.stats.damage = 25
self.flamethrower_mk2.fire_dot_data = {
	dot_trigger_chance = 50,
	dot_damage = 7.5,
	dot_length = 1.1,
	dot_trigger_max_distance = 3000,
	dot_tick_period = 0.5
}
self.flamethrower_mk2.AMMO_PICKUP = {2.65, 3.5}



-- removed shit
self.x_akmsu.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_sr2.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_mp5.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.elastic.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.long.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_sko12.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_korth.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_basset.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_rota.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_coal.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_baka.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_cobray.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_erma.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_hajk.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_m45.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_m1928.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_mac10.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_mp7.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_mp9.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_olympic.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_polymer.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_schakal.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_scorpion.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_sterling.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_tec9.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_uzi.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_2006m.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_breech.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_c96.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_hs2000.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_p226.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_pl14.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_ppk.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_rage.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_sparrow.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_maxim9.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_shrew.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_model3.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_beer.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_stech.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_holt.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_m1911.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_type54.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_legacy.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_p90.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_vityaz.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_type54.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_pm9.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.x_shepheard.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
self.system.use_data.selection_index = SELECTION.UNDERBARREL_PRIMARY
end)



Hooks:PostHook(WeaponTweakData, "_set_overkill_290", "eclipse__set_overkill_290", function(self)
	-- NPC weapon edits
	self.m4_npc.DAMAGE = 1
	self.m4_npc.auto.fire_rate = 0.225
	self.m4_yellow_npc.DAMAGE = 1
	self.m4_yellow_npc.auto.fire_rate = 0.3
	self.g36_npc.DAMAGE = 1
	self.g36_npc.auto.fire_rate = 0.25

	self.r870_npc.DAMAGE = 1
	self.r870_npc.CLIP_AMMO_MAX = 8
	self.benelli_npc.DAMAGE = 1
	self.benelli_npc.CLIP_AMMO_MAX = 8

	self.m249_npc.DAMAGE = 1
	self.m249_npc.auto.fire_rate = 0.15
	self.saiga_npc.DAMAGE = 1
	self.saiga_npc.auto.fire_rate = 0.33
	self.saiga_npc.CLIP_AMMO_MAX = 20

	self.ump_npc.auto.fire_rate = 0.25
	self.mp9_npc.auto.fire_rate = 0.275
	self.mp5_npc.auto.fire_rate = 0.25

	self.mac11_npc.auto.fire_rate = 0.2
	self.raging_bull_npc.DAMAGE = 1
	self.ak47_ass_npc.DAMAGE = 1
	self.ak47_ass_npc.auto.fire_rate = 0.2
	self.ak47_npc.DAMAGE = 1
	self.ak47_npc.auto.fire_rate = 0.2
	self.scar_npc.DAMAGE = 1
	self.scar_npc.auto.fire_rate = 0.2


	-- Misc
	self.m249_npc.usage = "is_lmg"
	self.flamethrower_npc.flame_max_range = 800 -- wow 15m is retarded lmao
	self.benelli_npc.sounds.prefix = "benelli_m4_npc" -- Give it a proper sound
	self.beretta92_npc.has_suppressor = "suppressed_b" -- suppressed
	self.m14_sniper_npc.trail = "effects/particles/weapons/sniper_trail_marshal"
end)

local _set_overkill_290_orig = WeaponTweakData._set_overkill_290
function WeaponTweakData:_set_sm_wish()
	_set_overkill_290_orig(self)
end

