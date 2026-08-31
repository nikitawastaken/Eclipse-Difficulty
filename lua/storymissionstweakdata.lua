function StoryMissionsTweakData:_init_missions(tweak_data)
	local default_reward = { { "safehouse_coins", 3 } }
	local default_pre_coins = { { type_items = "cash", item_entry = "cash80" }, { type_items = "xp", item_entry = "xp10" } }
	local default_pre_coins_halved = { { type_items = "cash", item_entry = "cash40" }, { type_items = "xp", item_entry = "xp10" } }

	self.sm_2_skillpoints = 999

	self.missions = {
		-- Act 1, Vlad, Gage, Elephant and Hector are introduced
		self:_mission("eclipse_sm_act_1", {
			rewarded = true,
			completed = true,
			is_header = true,
			objectives = {},
		}),

		-- Safehouse intro
		self:_mission("eclipse_sm_first_safehouse", {
			reward_id = "menu_sm_pre_coin_reward",
			voice_line = "Play_pln_stq_29",
			custom_check = "_sm_first_safehouse_check",
			hide_progress = true,
			objectives = { { self:_progress("story_first_safehouse", 1, { name_id = "menu_sm_first_safehouse" }) } },
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_m4_uupg_b_long",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_m4_uupg_fg_lr300",
					amount = 1,
				},
				{
					type_items = "xp",
					item_entry = "xp10",
				},
			},
		}),

		-- Turf War campaign from alpha
		self:_mission("eclipse_sm_2", {
			reward_id = "menu_sm_pre_coin_reward",
			voice_line = "Play_pln_stq_07",
			objectives = {
				{
					self:_level_progress("story_four_stores", 1, {
						name_id = "menu_sm_four_stores",
					}),
					self:_level_progress("story_mallcrasher", 1, {
						name_id = "menu_sm_mallcrasher",
					}),
					self:_level_progress("story_ukrainian_job", 1, {
						name_id = "menu_sm_ukrainian_job",
					}),
					self:_level_progress("story_nightclub", 1, {
						name_id = "menu_sm_nightclub",
					}),
				},
			},
			rewards = {
				{
					type_items = "cash",
					item_entry = "cash80",
				},
				{
					type_items = "masks",
					item_entry = "tiara",
					amount = 1,
				},
			},
		}),

		-- Bank Heist & Diamond Store
		self:_mission("eclipse_sm_3", {
			reward_id = "menu_sm_pre_coin_reward",
			objectives = {
				{
					self:_level_progress("story_bank_heist", 1, {
						name_id = "menu_sm_bank_heist",
					}),
					self:_level_progress("story_diamond_store", 1, {
						name_id = "menu_sm_diamond_store",
					}),
				},
			},
			rewards = {
				{
					type_items = "cash",
					item_entry = "cash80",
				},
				{
					type_items = "masks",
					item_entry = "outlandish_c",
					amount = 1,
				},
			},
		}),

		-- 3 Armored Transport heists
		self:_mission("eclipse_sm_4", {
			reward_id = "menu_sm_pre_coin_reward",
			objectives = {
				{
					self:_level_progress("story_transport_mult", 3, {
						name_id = "menu_sm_transport_mult",
						levels = {
							"arm_cro",
							"arm_hcm",
							"arm_fac",
							"arm_par",
							"arm_und",
						},
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_ass_s552_body_standard_black",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_ass_s552_fg_railed",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_pis_ppk_b_long",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_o_cmore",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "hockey",
					amount = 1,
				},
			},
		}),

		-- Introduce Gage and Shadow Raid
		self:_mission("eclipse_sm_5", {
			reward_id = "menu_sm_pre_coin_reward",
			voice_line = "Play_pln_stq_04",
			objectives = {
				{
					self:_level_progress("story_shadow_raid", 1, {
						name_id = "menu_sm_shadow_raid",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_snp_wa2000_b_suppressed",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_ns_pis_jungle",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_smg_p90_b_ninja",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "gage_blade",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "oni",
					amount = 1,
				},
			},
		}),

		-- Filler
		self:_mission("eclipse_sm_6", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_05",
			objectives = {
				{
					self:_level_progress("story_gobank", 1, {
						name_id = "menu_sm_gobank",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_fl_pis_tlr1",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "santa_mad",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "santa_surprise",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "santa_drunk",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "santa_happy",
					amount = 1,
				},
			},
		}),

		-- Filler 2 with Car Shop
		self:_mission("eclipse_sm_7", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_36",
			objectives = {
				{
					self:_level_progress("story_car_shop", 1, {
						name_id = "menu_sm_car_shop",
					}),
				},
			},
			rewards = {
				{
					type_items = "xp",
					item_entry = "xp15",
				},
			},
		}),

		-- Favors for Vlad and Hector introduction
		self:_mission("eclipse_sm_8", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_12",
			objectives = {
				{
					self:_level_progress("story_stealing_xmas", 1, {
						name_id = "menu_sm_stealing_xmas",
					}),
					self:_level_progress("story_white_xmas", 1, {
						name_id = "menu_sm_white_xmas",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_upg_ak_fg_combo3",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_upg_ak_s_folding",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "rudeolph",
					amount = 1,
				},
			},
		}),

		-- Hector heists
		self:_mission("eclipse_sm_9", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_14",
			objectives = {
				{
					self:_level_progress("story_watchdogs", 1, {
						name_id = "menu_sm_watchdogs",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_m4_m_drum",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_upg_ak_m_drum",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "dawg",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_10", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_15",
			objectives = {
				{
					self:_level_progress("story_firestarter", 1, {
						name_id = "menu_sm_firestarter",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_lmg_hk21_fg_short",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_lmg_m249_fg_mk46",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_lmg_rpk_fg_standard",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "bullet",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_11", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_16",
			objectives = {
				{
					self:_level_progress("story_rats", 1, {
						name_id = "menu_sm_rats",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_shot_huntsman_b_short",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_ass_m14_body_ebr",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_upg_ak_fg_combo2",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "monkeybiss",
					amount = 1,
				},
			},
		}),

		-- Intermission until level 25
		self:_mission("eclipse_sm_moving_up", {
			reward_id = "menu_sm_moving_up_reward",
			custom_check = "_sm_moving_up_check",
			voice_line = "Play_pln_stq_30",
			objectives = {
				{
					self:_progress("story_chill_level", 1, {
						name_id = "menu_sm_chill_level",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_fl_pis_tlr1",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_ns_ass_smg_medium",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "irondoom",
					amount = 1,
				},
			},
		}),

		-- Introduce Elephant and Big Oil
		self:_mission("eclipse_sm_12", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_17",
			objectives = {
				{
					self:_level_progress("story_big_oil", 1, {
						name_id = "menu_sm_big_oil",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_fl_ass_smg_sho_peqbox",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_m4_g_sniper",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "mr_sinister",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_13", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_18",
			objectives = {
				{
					self:_level_progress("story_framing_frame", 1, {
						name_id = "menu_sm_framing_frame",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_smg_mp5_fg_m5k",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_smg_mp5_s_adjust",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "troll",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_14", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_19",
			objectives = {
				{
					self:_level_progress("story_election_day", 1, {
						name_id = "menu_sm_election_day",
					}),
				},
			},
			rewards = {
				{
					type_items = "cash",
					item_entry = "cash100",
				},
				{
					type_items = "masks",
					item_entry = "pirate_skull",
					amount = 1,
				},
			},
		}),

		-- Act 2 begins, The Dentist helps break out Hoxton; The Diamond; Butcher is introduced; Hector dies; No Mercy, Alesso; ends with Golden Grin Casino
		self:_mission("eclipse_sm_act_2", {
			rewarded = true,
			completed = true,
			is_header = true,
			objectives = {},
		}),

		self:_mission("eclipse_sm_15", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_20",
			objectives = {
				{
					self:_level_progress("story_big_bank", 1, {
						name_id = "menu_sm_big_bank",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_ass_fal_fg_04",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_ass_fal_m_01",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_o_specter",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "lincoln",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "grant",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "washington",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "franklin",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_16", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_21",
			objectives = {
				{
					self:_level_progress("story_hotline_miami", 1, {
						name_id = "menu_sm_hotline_miami",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_smg_scorpion_s_unfolded",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_smg_tec9_ns_ext",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_smg_uzi_fg_rail",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_smg_cobray_ns_barrelextension",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "hog",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "unicorn",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "bear",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_17", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_22",
			objectives = {
				{
					self:_level_progress("story_hoxton_breakout", 1, {
						name_id = "menu_sm_hoxton_breakout",
					}),
				},
			},
			rewards = {
				{
					type_items = "player_styles",
					item_entry = "jail_pd2_clan",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_hoxton_revenge", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_23",
			objectives = {
				{
					self:_level_progress("story_hoxton_revenge", 1, {
						name_id = "menu_sm_hoxton_revenge",
					}),
				},
			},
			rewards = {
				{
					type_items = "xp",
					item_entry = "xp30",
				},
			},
		}),

		self:_mission("eclipse_sm_18", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_24",
			objectives = {
				{
					self:_level_progress("story_diamond", 1, {
						name_id = "menu_sm_diamond",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_ass_l85a2_b_long",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_ass_l85a2_fg_short",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_ass_l85a2_m_emag",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "medusa",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "cursed_crown",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_19", {
			reward_id = "menu_sm_default_reward",
			objectives = {
				{
					self:_level_progress("story_nmh", 1, {
						name_id = "menu_sm_nmh",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_smg_cobray_ns_silencer",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_smg_mac10_m_extended",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_ns_pis_medium_slim",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_pis_beretta_body_modern",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "doctor",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_20", {
			reward_id = "menu_sm_default_reward",
			objectives = {
				{
					self:_level_progress("story_alesso", 1, {
						name_id = "menu_sm_alesso",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_pis_2006m_b_long",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_pis_2006m_g_bling",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "concert_female",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "concert_male",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_21", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_25",
			objectives = {
				{
					self:_level_progress("story_golden_grin", 1, {
						name_id = "menu_sm_golden_grin",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_ass_sub2000_fg_gen2",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_ns_ass_smg_large",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_ass_asval_s_solid",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_22", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_26",
			objectives = {
				{
					self:_level_progress("story_bombheists_mult_2", 1, {
						name_id = "menu_sm_bombheists_mult_2",
						levels = {
							"crojob1",
							"crojob2",
						},
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_ak_s_solidstock",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_ns_ass_pbs1",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_m4_m_l5",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_smg_olympic_fg_lr300",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "tech_lion",
					amount = 1,
				},
			},
		}),

		-- Act 3 begins, Aftershock from skin update, Goat Simulator to put salt on the wound from the last heist and Santa's Workshop; Meltdown, Slaughterhouse, Murky Station and Boiling Point to put pressure on Murkywater
		self:_mission("eclipse_sm_act_3", {
			rewarded = true,
			completed = true,
			is_header = true,
			objectives = {},
		}),

		self:_mission("eclipse_sm_23", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_08",
			objectives = {
				{
					self:_level_progress("story_aftershock", 1, {
						name_id = "menu_sm_aftershock",
					}),
				},
			},
			rewards = {
				{
					type_items = "masks",
					item_entry = "rus_hat",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "glasses_tinted_love",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "sputnik",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_24", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_35",
			objectives = {
				{
					self:_level_progress("story_goat_sim", 1, {
						name_id = "menu_sm_goat_sim",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_ns_shot_shark",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_shot_m37_b_short",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "goat_goat",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_25", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_09",
			objectives = {
				{
					self:_level_progress("story_meltdown", 1, {
						name_id = "menu_sm_meltdown",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_o_leupold",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_snp_msr_b_long",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_snp_r93_b_suppressed",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "grendel",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_26", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_42",
			objectives = {
				{
					self:_level_progress("story_slaughterhouse", 1, {
						name_id = "menu_sm_slaughterhouse",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_o_eotech_xps",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_o_docter",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_fl_ass_smg_sho_surefire",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "butcher",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "lady_butcher",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_27", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_33",
			objectives = {
				{
					self:_level_progress("story_murky_station", 1, {
						name_id = "menu_sm_murky_station",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_m4_uupg_b_sd",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_ns_shot_thick",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_smg_schakal_ns_silencer",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_smg_mp5_fg_mp5sd",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "mad_goggles",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_28", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_34",
			objectives = {
				{
					self:_level_progress("story_boiling_point", 1, {
						name_id = "menu_sm_boiling_point",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_upg_saiga_m_20rnd",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_pis_pl14_m_extended",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_upg_ak_m_drum",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_sho_ben_b_long",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "pim_russian_ballistic",
					amount = 1,
				},
			},
		}),

		-- Act 4 begins, Murkywater puts PAYDAY Gang on their radar, but Locke is greedy, resulting in Birth of Sky and Beneath The Mountain; Search for Kento begins with Heat Street; Biker Heist and Scarface Mansion; Green Bridge
		self:_mission("eclipse_sm_act_4", {
			rewarded = true,
			completed = true,
			is_header = true,
			objectives = {},
		}),

		self:_mission("eclipse_sm_29", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_43",
			objectives = {
				{
					self:_level_progress("story_beneath_the_mountain", 1, {
						name_id = "menu_sm_beneath_the_mountain",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_smg_p90_b_long",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_ass_g36_s_sl8",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_aug_b_short",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_ass_galil_fg_sniper",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_30", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_44",
			objectives = {
				{
					self:_level_progress("story_birth_of_sky", 1, {
						name_id = "menu_sm_birth_of_sky",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_fl_pis_laser",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_ns_pis_meatgrinder",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_snp_msr_body_msr",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_snp_m95_barrel_short",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_31", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_45",
			objectives = {
				{
					self:_level_progress("story_heat_street", 1, {
						name_id = "menu_sm_heat_street",
					}),
				},
			},
			rewards = {
				{
					"safehouse_coins",
					12,
				},
			},
		}),

		self:_mission("eclipse_sm_32", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_37",
			objectives = {
				{
					self:_level_progress("story_biker_heist", 1, {
						name_id = "menu_sm_biker_heist",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_smg_hajk_b_medium",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_ns_ass_smg_firepig",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_sho_boot_s_long",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_sho_boot_b_long",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_33", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_27",
			objectives = {
				{
					self:_level_progress("story_scarface", 1, {
						name_id = "menu_sm_scarface",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_sho_s_spas12_folded",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_lmg_m60_fg_tropical",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_lmg_m60_b_short",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_o_t1micro",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_34", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_46",
			objectives = {
				{
					self:_level_progress("story_green_bridge", 1, {
						name_id = "menu_sm_green_bridge",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_pis_beretta_sl_brigadie",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_ns_pis_large_kac",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_ass_ns_surefire",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_o_eotech",
					amount = 1,
				},
			},
		}),

		-- Act 5 begins, First World Bank, Undercover, Panic Room, Diamond Heist and Counterfeit as filler heists (altho fwb is important); Continental Heists; Alaskan Deal;
		self:_mission("eclipse_sm_act_5", {
			rewarded = true,
			completed = true,
			is_header = true,
			objectives = {},
		}),

		self:_mission("eclipse_sm_35", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_32",
			objectives = {
				{
					self:_level_progress("story_first_world_bank", 1, {
						name_id = "menu_sm_first_world_bank",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_pis_1911_co_1",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_pis_1911_g_bling",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_shot_r870_s_folding",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_ns_shot_shark",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "nixon",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_36", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_41",
			objectives = {
				{
					self:_level_progress("story_undercover", 1, {
						name_id = "menu_sm_undercover",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_ass_m14_body_jae",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_o_cs",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_gre_m79_barrel_short",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_gre_m79_stock_short",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "clinton",
				},
			},
		}),

		self:_mission("eclipse_sm_37", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_38",
			objectives = {
				{
					self:_level_progress("story_panic_room", 1, {
						name_id = "menu_sm_panic_room",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_pis_g18c_m_mag_33rnd",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_pis_g26_g_gripforce",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_fg_midwest",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_o_cmore",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "obama",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_38", {
			reward_id = "menu_sm_default_reward",
			objectives = {
				{
					self:_level_progress("story_counterfeit", 1, {
						name_id = "menu_sm_counterfeit",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_pis_rage_body_smooth",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_pis_rage_b_long",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_smg_mp5_fg_mp5a5",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_smg_mp5_m_straight",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "bush",
					amount = 1,
				},
				{
					type_items = "player_styles",
					item_entry = "cable_guy",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_39", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_39",
			objectives = {
				{
					self:_level_progress("story_brooklyn_10_10", 1, {
						name_id = "menu_sm_brooklyn_10_10",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_snp_desertfox_b_long",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_snp_tti_ns_hex",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_pis_packrat_ns_wick",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "pim_dog",
					amount = 1,
				},
				{
					"safehouse_coins",
					12,
				},
			},
		}),

		self:_mission("eclipse_sm_40", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_40",
			objectives = {
				{
					self:_level_progress("story_yacht", 1, {
						name_id = "menu_sm_yacht",
					}),
				},
			},
			rewards = {
				{
					"safehouse_coins",
					12,
				},
			},
		}),

		self:_mission("eclipse_sm_41", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_47",
			objectives = {
				{
					self:_level_progress("story_alaskan_deal", 1, {
						name_id = "menu_sm_alaskan_deal",
					}),
				},
			},
			rewards = {
				{
					type_items = "xp",
					item_entry = "xp80",
				},
			},
		}),

		self:_mission("eclipse_sm_42", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_48",
			objectives = {
				{
					self:_level_progress("story_diamond_heist", 1, {
						name_id = "menu_sm_diamond_heist",
					}),
				},
			},
			rewards = {
				{
					"safehouse_coins",
					3,
				},
			},
		}),

		-- Act 6 begins, Reservoir Dogs, Brooklyn Bank+Border Crossing, Breakin' Feds+San Martin Bank, Henry's Rock+Breakfast in Tijuana, Shacklethorne Auction, Hell's Island, The White House
		self:_mission("eclipse_sm_act_6", {
			rewarded = true,
			completed = true,
			is_header = true,
			objectives = {},
		}),

		self:_mission("eclipse_sm_43", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_pln_stq_49",
			objectives = {
				{
					self:_level_progress("story_reservoir_dogs", 1, {
						name_id = "menu_sm_reservoir_dogs",
					}),
				},
			},
			rewards = {
				{
					type_items = "masks",
					item_entry = "rvd_03",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "rvd_02",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "rvd_01",
					amount = 1,
				},
			},
		}),
		self:_mission("eclipse_sm_44", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_loc_stq_01",
			objectives = {
				{
					self:_level_progress("story_brooklyn_bank", 1, {
						name_id = "menu_sm_brooklyn_bank",
					}),
				},
			},
			rewards = {
				{
					"safehouse_coins",
					3,
				},
			},
		}),
		self:_mission("eclipse_sm_45", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_loc_stq_02",
			objectives = {
				{
					self:_level_progress("story_breakin_feds", 1, {
						name_id = "menu_sm_breakin_feds",
					}),
				},
			},
			rewards = {
				{
					"safehouse_coins",
					3,
				},
			},
		}),
		self:_mission("eclipse_sm_46", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_loc_stq_03",
			objectives = {
				{
					self:_level_progress("story_henrys_rock", 1, {
						name_id = "menu_sm_henrys_rock",
					}),
				},
			},
			rewards = {
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_ass_scar_b_short",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_ass_scar_fg_railext",
					amount = 1,
				},
				{
					type_items = "weapon_mods",
					item_entry = "wpn_fps_upg_o_acog",
					amount = 1,
				},
			},
		}),
		self:_mission("eclipse_sm_47", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_loc_stq_04",
			objectives = {
				{
					self:_level_progress("story_shacklethorne", 1, {
						name_id = "menu_sm_sah",
					}),
				},
			},
			rewards = {
				{
					"safehouse_coins",
					3,
				},
			},
		}),
		self:_mission("eclipse_sm_48", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_loc_stq_05",
			objectives = {
				{
					self:_level_progress("story_hells_island", 1, {
						name_id = "menu_sm_bph",
					}),
				},
			},
			rewards = {
				{
					"safehouse_coins",
					6,
				},
			},
		}),
		self:_mission("eclipse_sm_49", {
			reward_id = "menu_sm_default_reward",
			voice_line = "Play_loc_stq_07",
			objectives = {
				{
					self:_level_progress("story_white_house", 1, {
						name_id = "menu_sm_vit",
					}),
				},
			},
			rewards = {
				{
					type_items = "masks",
					item_entry = "win_donald_mega",
					amount = 1,
				},
				{
					type_items = "gloves",
					item_entry = "postmoto",
					amount = 1,
				},
				{
					type_items = "weapon_skins",
					item_entry = "color_in32_03",
					amount = 1,
				},
				{
					type_items = "xp",
					item_entry = "xp_pda9_1",
				},
			},
		}),

		-- Campaigns after White House excluding Texas
		self:_mission("eclipse_sm_act_7", {
			rewarded = true,
			completed = true,
			is_header = true,
			objectives = {},
		}),

		self:_mission("eclipse_sm_50", {
			reward_id = "menu_sm_pre_coin_reward",
			objectives = {
				{
					self:_level_progress("story_mex", 1, {
						name_id = "menu_sm_mex",
					}),
				},
			},
			rewards = {
				{
					type_items = "armor",
					item_entry = "cvc_tan",
					amount = 1,
				},
				{
					type_items = "armor",
					item_entry = "drm_desert_twilight",
					amount = 1,
				},
				{
					type_items = "armor",
					item_entry = "drm_khaki_eclipse",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "skm_07",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "smo_05",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_51", {
			reward_id = "menu_sm_pre_coin_reward",
			objectives = {
				{
					self:_level_progress("story_bex", 1, {
						name_id = "menu_sm_bex",
					}),
				},
			},
			rewards = {
				{
					type_items = "armor",
					item_entry = "drm_desert_tech",
					amount = 1,
				},
				{
					type_items = "armor",
					item_entry = "drm_khaki_regular",
					amount = 1,
				},
				{
					type_items = "armor",
					item_entry = "cvc_black",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "smo_06",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "smo_05",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_52", {
			reward_id = "menu_sm_pre_coin_reward",
			objectives = {
				{
					self:_level_progress("story_pex", 1, {
						name_id = "menu_sm_pex",
					}),
				},
			},
			rewards = {
				{
					type_items = "armor",
					item_entry = "cvc_navy_blue",
					amount = 1,
				},
				{
					type_items = "armor",
					item_entry = "drm_navy_breeze",
					amount = 1,
				},
				{
					type_items = "armor",
					item_entry = "drm_misted_grey",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "smo_09",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "smo_12",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_53", {
			reward_id = "menu_sm_pre_coin_reward",
			objectives = {
				{
					self:_level_progress("story_fex", 1, {
						name_id = "menu_sm_fex",
					}),
				},
			},
			rewards = {
				{
					type_items = "armor",
					item_entry = "cvc_grey",
					amount = 1,
				},
				{
					type_items = "armor",
					item_entry = "drm_tree_stump",
					amount = 1,
				},
				{
					type_items = "armor",
					item_entry = "drm_gray_raider",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "smo_10",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "skm_08",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_54", {
			reward_id = "menu_sm_pre_coin_reward",
			objectives = {
				{
					self:_level_progress("story_chas", 1, {
						name_id = "menu_sm_chas",
					}),
				},
			},
			rewards = {
				{
					type_items = "armor",
					item_entry = "drm_somber_woodland",
					amount = 1,
				},
				{
					type_items = "armor",
					item_entry = "drm_woodland_tech",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "skm_02",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "skm_06",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_55", {
			reward_id = "menu_sm_pre_coin_reward",
			objectives = {
				{
					self:_level_progress("story_sand", 1, {
						name_id = "menu_sm_sand",
					}),
				},
			},
			rewards = {
				{
					type_items = "masks",
					item_entry = "skm_02",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "skm_05",
					amount = 1,
				},
				{
					type_items = "masks",
					item_entry = "skm_08",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_56", {
			reward_id = "menu_sm_pre_coin_reward",
			objectives = {
				{
					self:_level_progress("story_chca", 1, {
						name_id = "menu_sm_chca",
					}),
				},
			},
			rewards = {
				{
					type_items = "masks",
					item_entry = "smo_07",
					amount = 1,
				},
			},
		}),

		self:_mission("eclipse_sm_57", {
			reward_id = "menu_sm_pre_coin_reward",
			objectives = {
				{
					self:_level_progress("story_pent", 1, {
						name_id = "menu_sm_pent",
					}),
				},
			},
			rewards = {
				{
					"safehouse_coins",
					3,
				},
			},
		}),

		self:_mission("eclipse_sm_end", {
			rewarded = true,
			completed = true,
			last_mission = true,
			objectives = {},
		}),
	}
end
