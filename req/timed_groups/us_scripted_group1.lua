return function(timed_tactics, timed_random_tactics, difficulty_index, spawn_point_ref)
	return {
		disabled = true,
		timer_data = {
			initial_delay = 30,
			cooldown = { 20, 30 },
			diff_scale = { 1, 1, 1 },
		},
		group_data = {
			army_timed_group = {
				enabled = true,
				team_id = "law1",
				max_nr_simultaneous_groups = 3,
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
						rank = 2,
						freq = 0.5,
						unit = "army_soldier_3",
						tactics = timed_tactics.army_agg,
						random_tactics = timed_random_tactics.army_aggressive,
					},
					{
						amount_min = 1,
						rank = 2,
						freq = 1,
						unit = "army_soldier_2",
						tactics = timed_tactics.army_def,
						random_tactics = timed_random_tactics.army_defensive,
					},
					{
						amount_max = 1,
						rank = 1,
						freq_by_diff = {
							0,
							(difficulty_index ^ 2) / 120,
							(difficulty_index ^ 2) / 60,
						},
						unit = "army_soldier_4",
						tactics = timed_tactics.army_spt,
					},
				},
				spawn_point_chk_ref = table.list_to_set(spawn_point_ref),
			},
		},
	}
end
