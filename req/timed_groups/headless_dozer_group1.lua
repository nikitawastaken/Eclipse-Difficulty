local diff_i = Eclipse.utils.difficulty_index()

return function(timed_tactics, timed_random_tactics, spawn_point_ref)
	return {
		timer_data = {
			initial_delay = 300,
			cooldown = { 300, 360 },
			diff_scale = { 1, 1.5, 2 },
		},
		group_data = {
			headless_dozer_timed_group = {
				enabled = diff_i >= 4 and true or false,
				team_id = "law1",
				max_nr_simultaneous_groups = 1,
				amount = { 1, 1 },
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
						rank = 1,
						freq = 1,
						unit = "headless_dozers",
						tactics = timed_tactics.bulldozer_def,
						random_tactics = timed_random_tactics.headless_dozers,
					},
				},
				spawn_point_chk_ref = table.list_to_set(spawn_point_ref),
			},
		},
	}
end
