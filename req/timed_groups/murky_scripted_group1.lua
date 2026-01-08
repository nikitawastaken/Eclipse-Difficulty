return function(timed_tactics, timed_random_tactics, spawn_point_ref)
	return {
		disabled = true,
		timer_data = {
			initial_delay = 30,
			cooldown = { 20, 30 },
			diff_scale = { 1, 1, 1 },
		},
		group_data = {
			murkywater_timed_group = {
				enabled = true,
				team_id = "law1",
				max_nr_simultaneous_groups = 2,
				amount = { 3, 3 },
				disable_timer = nil,
				disable_diff = nil,
				objective = function(spawn_group)
					return {
						attitude = "engage",
						pose = "stand",
						type = "assault_area",
						stance = "hos",
						area = spawn_group.area,
						coarse_path = {
							{
								spawn_group.area.pos_nav_seg,
								spawn_group.area.pos,
							},
						},
					}
				end,
				spawn = {
					{
						amount_max = 2,
						rank = 1,
						freq = 0.5,
						unit = "murkywater",
						tactics = timed_tactics.murky_agg,
						random_tactics = timed_random_tactics.murky_aggressive,
					},
					{
						amount_min = 1,
						rank = 1,
						freq = 1,
						unit = "murkywater",
						tactics = timed_tactics.murky_def,
						random_tactics = timed_random_tactics.murky_defensive,
					},
				},
				spawn_point_chk_ref = table.list_to_set(spawn_point_ref),
			},
		},
	}
end
