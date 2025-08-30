return function(timed_tactics, difficulty_index)
	return {
		timer_data = {
			initial_delay = 180, -- 3 minutes
			cooldown = { 15, 20 },
			diff_scale = { 2, 1.5, 1 },
		},
		group_data = {
			army_timed_group = {
				enabled = true,
				team_id = "law1",
				max_nr_simultaneous_groups = 3,
				amount = { 2, 3 },
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
						amount_min = 1,
						rank = 2,
						freq = 1,
						unit = "army_soldier_2",
						tactics = timed_tactics.army_def,
					},
					{
						amount_max = 2,
						rank = 3,
						freq = 0.5,
						unit = "army_soldier_3",
						tactics = timed_tactics.army_agg,
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
				spawn_point_chk_ref = table.list_to_set({
					"cs_swats",
					"cs_heavies",
				}),
			},
		},
	}
end
