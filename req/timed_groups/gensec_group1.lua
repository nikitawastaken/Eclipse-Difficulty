return function(timed_tactics, timed_random_tactics, spawn_point_ref, group_diff_scale)
	return {
		timer_data = {
			initial_delay = 0,
			cooldown = { 20, 30 },
			diff_scale = { 1, 1.5, 2 },
		},
		group_data = {
			gensec_timed_group = {
				enabled = true,
				team_id = "law1",
				max_nr_simultaneous_groups = 2,
				amount = { 2, 3 },
				disable_timer = nil,
				disable_diff = 0.75,
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
						amount_min = 1,
						freq = 1,
						unit = "gensec_tacteam",
						tactics = timed_tactics.fbi_def,
						random_tactics = timed_random_tactics.fbi_readyteam,
					},
					{
						freq = 1,
						freq_by_diff = {
							6 / group_diff_scale,
							3 / group_diff_scale,
							0,
						},
						amount_max = 1,
						rank = 1,
						unit = "gensec_security",
						tactics = timed_tactics.fbi_spt,
					},
				},
				spawn_point_chk_ref = table.list_to_set(spawn_point_ref),
			},
		},
	}
end
