Hooks:PostHook(FireTweakData, "_init_dot_entries_fire", "eclipse__init_dot_entries_fire", function(self, fire_entries)
    -- incendiary
    fire_entries.proj_fire_com.dot_damage = 30
    fire_entries.proj_fire_com.dot_length = 5

    -- flamer dot (might just rework later)
	fire_entries.weapon_flamethrower_mk2 = {
        dot_trigger_chance = 50,
        dot_damage = 7.5,
        dot_length = 1.1,
        dot_tick_period = 0.5,
        dot_trigger_max_distance = false
	}
	fire_entries.ammo_flamethrower_mk2_rare = deep_clone(fire_entries.weapon_flamethrower_mk2)
	fire_entries.ammo_flamethrower_mk2_welldone = deep_clone(fire_entries.weapon_flamethrower_mk2)

    -- db dot (might rework too)
	fire_entries.ammo_dragons_breath = {
		dot_trigger_chance = 1,
		dot_damage = 3,
		dot_length = 4,
		dot_trigger_max_distance = 1500,
        dot_tick_period = 0.25
	}
end)