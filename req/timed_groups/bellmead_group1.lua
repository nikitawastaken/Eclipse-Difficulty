return function(timed_tactics)
	return {
		timer_data = {
			initial_delay = 0,
			cooldown = { 10, 15 },
			diff_scale = { 1, 2, 3 },
		},
		group_data = {
			bellmead_timed_group = {
				enabled = true,
				team_id = "law1",
				max_nr_simultaneous_groups = 2,
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
						freq = 2,
						unit = "bellmead_security",
						tactics = timed_tactics.bellmead_def,
					},
					{
						amount_max = 2,
						rank = 2,
						freq = 1,
						unit = "bellmead_security",
						tactics = timed_tactics.bellmead_agg,
					},
					{
						amount_max = 2,
						rank = 2,
						freq = 1,
						unit = "bellmead_security",
						tactics = timed_tactics.bellmead_snk,
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
