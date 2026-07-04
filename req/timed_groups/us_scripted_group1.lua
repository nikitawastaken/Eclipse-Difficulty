return function(timed_tactics, timed_random_tactics, spawn_point_ref, group_diff_scale)
	return {
		disabled = true,
		timer_data = {
			initial_delay = 0,
			cooldown = { 20, 30 },
			diff_scale = { 1, 1, 1 },
		},
		group_data = {
			army_timed_group = {
				enabled = true,
				team_id = "law1",
				max_nr_simultaneous_groups = 2,
				amount = { 3, 4 },
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
						rank = 2,
						amount_max = 2,
						freq = 0.5,
						unit = "army_soldier_3",
						tactics = timed_tactics.army_agg,
						random_tactics = timed_random_tactics.army_aggressive,
					},
					{
						rank = 2,
						amount_min = 1,
						freq = 1,
						unit = "army_soldier_2",
						tactics = timed_tactics.army_def,
						random_tactics = timed_random_tactics.army_defensive,
					},
					{
						rank = 1,
						freq_by_diff = {
							0,
							group_diff_scale / 60,
							group_diff_scale / 30,
						},
						amount_max = 1,
						unit = "army_soldier_4",
						tactics = timed_tactics.army_spt,
					},
				},
				spawn_point_chk_ref = table.list_to_set(spawn_point_ref),
			},
		},
	}
end
