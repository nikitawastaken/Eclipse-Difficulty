return function(timed_tactics)
	return {
		timer_data = {
			initial_delay = 0,
			cooldown = { 15, 30 },
			diff_scale = { 1, 1.5, 2 },
		},
		group_data = {
			fbi_timed_group = {
				enabled = true,
				team_id = "law1",
				max_nr_simultaneous_groups = 2,
				amount = { 3, 3 },
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
						amount_min = 1,
						rank = 2,
						freq = 1.5,
						unit = "fbi_readyteam",
						tactics = timed_tactics.fbi_def,
					},
					{
						amount_max = 2,
						rank = 2,
						freq = 1,
						unit = "fbi_readyteam",
						tactics = timed_tactics.fbi_snk,
					},
				},
				spawn_point_chk_ref = table.list_to_set({
					"tac_swat_rifle",
					"tac_swat_rifle_flank",
				}),
			},
		},
	}
end
