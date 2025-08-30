return function(timed_tactics)
	return {
		disabled = true,
		timer_data = {
			initial_delay = 30,
			cooldown = { 15, 25 },
			diff_scale = { 1, 1, 1 },
		},
		group_data = {
			murkywater_timed_group = {
				enabled = true,
				team_id = "law1",
				max_nr_simultaneous_groups = 3,
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
						amount_min = 1,
						rank = 1,
						freq = 1,
						unit = "murkywater",
						tactics = timed_tactics.murky_def,
					},
					{
						amount_max = 2,
						rank = 2,
						freq = 0.5,
						unit = "murkywater",
						tactics = timed_tactics.murky_agg,
					},
					{
						amount_max = 2,
						rank = 2,
						freq = 0.5,
						unit = "murkywater",
						tactics = timed_tactics.murky_snk,
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
