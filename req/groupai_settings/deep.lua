local generate_big_lobby_balance_muls = Eclipse.utils.generate_big_lobby_balance_muls
return {
	task_data_mod = {
		{
			groupai_state = "all",
			value = { "assault", "force_balance_mul" },
			tweak = {
				mode = "replace",
				modifier = generate_big_lobby_balance_muls({
					{ 0.4, 1 },
					{ 0.6, 2 },
					{ 0.8, 3 },
					{ 1, 4 },
					{ 1.5, 10 },
					{ 2, 16 },
					{ 3, 22 },
				}, 0.025),
			},
		},
	},
}
