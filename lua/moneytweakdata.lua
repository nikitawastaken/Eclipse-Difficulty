function MoneyTweakData:init(tweak_data)
	local difficulty = Global.game_settings and Global.game_settings.difficulty or "normal"
	local difficulty_index = tweak_data:difficulty_to_index(difficulty)
	local level_id = Global.game_settings and Global.game_settings.level_id
	self.biggest_score = 4000000
	self.biggest_cashout = 800000
	self.offshore_rate = self.biggest_cashout / self.biggest_score
	self.alive_players_max = 1.1
	self.cashout_without_player_alive = self.biggest_cashout / self.alive_players_max
	self.cut_difficulty = 8 -- 4
	self.max_mission_bags = 6
	self.cut_lootbag_bonus = self.cashout_without_player_alive * 0.3
	self.cut_lootbag_bonus = (self.cut_lootbag_bonus / self.max_mission_bags) / self.cut_difficulty
	self.max_days = 3
	self.cut_stage_complete = self.cashout_without_player_alive * 0.55
	self.cut_stage_complete = self.cut_stage_complete / self.cut_difficulty * 0.7
	self.cut_job_complete = self.cashout_without_player_alive * 0.15
	self.cut_job_complete = self.cut_job_complete / self.cut_difficulty
	self.bag_values = {}
	self.bag_values.default = 15000 -- 15.000 $
	self.bag_values.money = 45000 -- 45.000 $
	self.bag_values.gold = 75000 -- 75.000 $
	self.bag_values.goat = 125000-- 125.000 $
	self.bag_values.diamonds = 25000 -- 25.000 $
	self.bag_values.diamonds_dah = 250000 -- 250.000 $
	self.bag_values.coke = 80000 -- 80.000 $
	self.bag_values.coke_pure = 95000 -- 95.000 $
	self.bag_values.meth = 120000 -- 120.000 $
	self.bag_values.meth_half = 60000 -- 60.000 $
	self.bag_values.weapon = 30000 -- 62.000 $
	self.bag_values.weapons = 62000
	self.bag_values.painting = 75000
	self.bag_values.samurai_suit = 250000 -- 250.000 $
	self.bag_values.artifact_statue = 1000000
	self.bag_values.mus_artifact_bag = 100000
	self.bag_values.circuit = 10000
	self.bag_values.shells = 100000
	self.bag_values.turret = 500000 -- 500.000 $
	self.bag_values.sandwich = 500000
	self.bag_values.cro_loot = 5000000 -- 500.000 $
	self.bag_values.hope_diamond = 3000000 -- 3.000.000 $
	self.bag_values.evidence_bag = 150000 -- 150.000 $
	self.bag_values.vehicle_falcogini = 750000 -- 750.000 $
	self.bag_values.warhead = 1750000 -- 1.750.000 $
	self.bag_values.unknown = 50000
	self.bag_values.safe = 250000 -- 250.000 $
	self.bag_values.prototype = 1000000
	self.bag_values.faberge_egg = 500000
	self.bag_values.treasure = 320000
	self.bag_values.counterfeit_money = 100000
	self.bag_values.box_unknown = 10000
	self.bag_values.black_tablet = 1000000
	self.bag_values.masterpiece_painting = 250000
	self.bag_values.master_server = 720000
	self.bag_values.lost_artifact = 420000
	self.bag_values.present = 100000
	self.bag_values.mad_master_server_value_1 = 250000 -- 250.000 $
	self.bag_values.mad_master_server_value_2 = 500000 -- 500.000 $
	self.bag_values.mad_master_server_value_3 = 750000 -- 750.000 $
	self.bag_values.mad_master_server_value_4 = 1000000 -- 1.000.000 $
	self.bag_values.weapon_glock = 25000
	self.bag_values.weapon_scar = 50000
	self.bag_values.drk_bomb_part = 300000
	self.bag_values.drone_control_helmet = 1800000
	self.bag_values.toothbrush = 18000
	self.bag_values.cloaker_gold = 75000
	self.bag_values.cloaker_money = 45000
	self.bag_values.cloaker_cocaine = 80000
	self.bag_values.diamond_necklace = 65000
	self.bag_values.vr_headset = 30000
	self.bag_values.women_shoes = 25000
	self.bag_values.expensive_vine = 45000
	self.bag_values.ordinary_wine = 25000
	self.bag_values.robot_toy = 15000
	self.bag_values.rubies = 52500
	self.bag_values.red_diamond = 10000
	self.bag_values.old_wine = 75000
	self.bag_values.garden_gnome = 69
	self.bag_values.ranc_weapon = 36000
	self.bag_values.turret_part = 25000
	self.bag_values.corp_papers = 30000
	self.bag_values.corp_prototype = 500000
	
	self.bag_value_multiplier = 1
	self.stage_completion = self._create_value_table(self.cut_stage_complete / 7 / self.offshore_rate, self.cut_stage_complete / self.offshore_rate, 7, true, 1)
	self.job_completion = self._create_value_table(self.cut_job_complete / 7 / self.offshore_rate, self.cut_job_complete / self.offshore_rate, 7, true, 1)
	self.flat_stage_completion = math.round(10000 / self.offshore_rate)
	self.flat_job_completion = 0
	self.level_limit = {
		low_cap_level = -1,
		low_cap_multiplier = 0.75,
		pc_difference_multipliers = {
			1,
			0.9,
			0.8,
			0.7,
			0.6,
			0.5,
			0.4,
			0.3,
			0.2,
			0.1
		}
	}
	self.stage_failed_multiplier = 0.1
	self.difficulty_multiplier = {
		1,
		1.25,
		1.5,
		1.75,
		2,
		2.25,
		2.5
	}
	self.difficulty_multiplier_payout = {
		1,
		1.28,
		1.56,
		1.79,
		2.03,
		2.27,
		2.53
	}
	self.small_loot_difficulty_multiplier = self._create_value_table(0, 0, 6, false, 1)
	self.alive_humans_multiplier = self._create_value_table(1, self.alive_players_max, tweak_data.max_players, false, 1)
	self.alive_humans_multiplier[0] = 1
	self.limited_bonus_multiplier = 1
	self.sell_weapon_multiplier = 0.25
	self.sell_mask_multiplier = 0.25
	self.killing_civilian_deduction = self._create_value_table(10000, 50000, 10, true, 2) --self.killing_civilian_deduction = self._create_value_table(2000, 50000, 10, true, 2)
	self.buy_premium_multiplier = {
		hard = 0,
		overkill = 0,
		overkill_145 = 0,
		normal = 0,
		easy_wish = 0,
		overkill_290 = 0,
		sm_wish = 0,
		easy = 0
	}
	self.buy_premium_static_fee = {
		hard = 0,
		overkill = 0,
		overkill_145 = 0,
		normal = 0,
		easy_wish = 0,
		overkill_290 = 0,
		sm_wish = 0,
		easy = 0
	}
	self.global_value_multipliers = {
		normal = 1,
		superior = 1,
		exceptional = 1,
		infamous = 5,
		infamy = 0,
		preorder = 1,
		overkill = 0.01,
		pd2_clan = 1,
		halloween = 1,
		xmas = 1,
		armored_transport = 1.2,
		big_bank = 0.8,
		gage_pack = 1.4,
		gage_pack_lmg = 1.8,
		gage_pack_jobs = 0,
		gage_pack_snp = 0.8,
		gage_pack_shotgun = 1,
		gage_pack_assault = 1,
		gage_pack_historical = 1,
		xmas_soundtrack = 1,
		sweettooth = 1,
		legendary = 1,
		poetry_soundtrack = 0,
		twitch_pack = 0,
		humble_pack2 = 0,
		humble_pack3 = 0,
		humble_pack4 = 0,
		e3_s15a = 0,
		e3_s15b = 0,
		e3_s15c = 0,
		e3_s15d = 0,
		hl_miami = 1,
		hlm_game = 1,
		alienware_alpha = 1,
		alienware_alpha_promo = 1,
		character_pack_clover = 1,
		hope_diamond = 1,
		goty_weapon_bundle_2014 = 1,
		goty_heist_bundle_2014 = 1,
		goty_dlc_bundle_2014 = 1,
		character_pack_dragan = 1,
		the_bomb = 1,
		bbq = 1,
		akm4_pack = 1,
		overkill_pack = 1,
		complete_overkill_pack = 1,
		hlm2 = 1,
		hlm2_deluxe = 1,
		butch_pack_free = 1,
		speedrunners = 1,
		west = 1,
		arena = 1,
		character_pack_sokol = 1,
		kenaz = 1,
		turtles = 1,
		bobblehead = 1,
		dragon = 1,
		pdcon_2015 = 1,
		pdcon_2016 = 1,
		steel = 1,
		berry = 1,
		peta = 1,
		pal = 1,
		coco = 1,
		dbd_clan = 1,
		dbd_deluxe = 1,
		solus_clan = 1,
		wild = 1,
		born = 1,
		sparkle = 0,
		rota = 1,
		pim = 1,
		tango = 1,
		friend = 1,
		chico = 1,
		rvd = 1,
		swm_bundle = 1,
		spa = 1,
		sha = 1,
		grv = 1,
		amp = 1,
		mp2 = 1,
		ant = 1,
		ant_free = 1,
		pn2 = 0,
		max = 1,
		dgm = 1,
		joy = 1,
		raidww2_clan = 1,
		fdm = 0,
		eng = 1,
		pbm = 0
	}
	self.global_value_bonus_multiplier = {
		normal = 0,
		superior = 0.1,
		exceptional = 0.2,
		infamous = 1,
		infamy = 1,
		preorder = 0,
		overkill = 20,
		pd2_clan = 0,
		halloween = 0,
		xmas = 0,
		armored_transport = 0.5,
		big_bank = 0.4,
		gage_pack = 0.5,
		gage_pack_lmg = 0.5,
		gage_pack_jobs = 0,
		gage_pack_snp = 0.2,
		gage_pack_shotgun = 0.2,
		gage_pack_assault = 0.2,
		gage_pack_historical = 0.2,
		xmas_soundtrack = 0,
		sweettooth = 0,
		legendary = 0,
		poetry_soundtrack = 0,
		twitch_pack = 0,
		humble_pack2 = 0,
		humble_pack3 = 0,
		humble_pack4 = 0,
		e3_s15a = 0,
		e3_s15b = 0,
		e3_s15c = 0,
		e3_s15d = 0,
		hl_miami = 0.2,
		hlm_game = 0.2,
		alienware_alpha = 0.2,
		alienware_alpha_promo = 0.2,
		character_pack_clover = 0.2,
		hope_diamond = 0.2,
		goty_weapon_bundle_2014 = 0.2,
		goty_heist_bundle_2014 = 0.2,
		goty_dlc_bundle_2014 = 0.2,
		character_pack_dragan = 0.2,
		the_bomb = 0.2,
		bbq = 0.2,
		akm4_pack = 0.2,
		overkill_pack = 0.2,
		complete_overkill_pack = 0.3,
		hlm2 = 0.2,
		hlm2_deluxe = 0.5,
		butch_pack_free = 0.2,
		speedrunners = 0,
		west = 0.2,
		arena = 0.2,
		character_pack_sokol = 0.2,
		kenaz = 0.2,
		turtles = 0.2,
		bobblehead = 0.2,
		dragon = 0.2,
		pdcon_2015 = 0.2,
		pdcon_2016 = 0.2,
		steel = 0.2,
		berry = 0.2,
		peta = 0.2,
		pal = 0.2,
		coco = 0.2,
		dbd_clan = 0,
		dbd_deluxe = 0.5,
		solus_clan = 0,
		wild = 0.2,
		born = 0.2,
		sparkle = 0,
		rota = 1,
		pim = 1,
		tango = 1,
		friend = 1,
		chico = 1,
		swm_bundle = 1,
		spa = 1,
		sha = 1,
		grv = 1,
		amp = 1,
		mp2 = 1,
		ant = 1,
		ant_free = 1,
		pn2 = 0,
		max = 1,
		dgm = 1,
		joy = 1,
		raidww2_clan = 1,
		fdm = 1,
		eng = 1,
		pbm = 1
	}
	local smallest_cashout = (2500 + 2500) * (0.2)	-- (self.stage_completion[1] + self.job_completion[1]) * self.offshore_rate
	local smallest_cashout_mod = (2500 + 2500) * (0.28)
	local biggest_mask_cost = 250000 * 40
	local biggest_mask_cost_deinfamous = math.round(biggest_mask_cost / self.global_value_multipliers.infamous)
	local biggest_mask_part_cost = math.round(smallest_cashout * 20)
	local smallest_mask_part_cost = math.round(smallest_cashout * 1.9)
	local biggest_weapon_cost = math.round(250000 * 4) -- (og value - 2.5) highest price 1,000,000$ at level 100, change table_size value to change cost peak level
	local smallest_weapon_cost = math.round(smallest_cashout * 25) -- lowest price 25,000 at level 0, change curve value to change the price difference between levels (lower value = higher difference)
	local biggest_weapon_mod_cost = math.round(250000 * 0.45) -- peak cost reached at level 10 (?)
	local smallest_weapon_mod_cost = math.round(smallest_cashout_mod * 13)
	self.weapon_cost = self._create_value_table(smallest_weapon_cost, biggest_weapon_cost, 100, true, 1.35)  -- (min, max, table_size, round, curve)
	self.modify_weapon_cost = self._create_value_table(smallest_weapon_mod_cost, biggest_weapon_mod_cost, 10, true, 0.6)
	self.remove_weapon_mod_cost_multiplier = self._create_value_table(1, 1, 10, true, 1)
	self.masks = {
		mask_value = self._create_value_table(smallest_mask_part_cost, smallest_mask_part_cost * 2, 10, true, 2),
		material_value = self._create_value_table(smallest_mask_part_cost * 0.5, biggest_mask_part_cost, 10, true, 1.2),
		pattern_value = self._create_value_table(smallest_mask_part_cost * 0.4, biggest_mask_part_cost, 10, true, 1.1),
		color_value = self._create_value_table(smallest_mask_part_cost * 0.3, biggest_mask_part_cost, 10, true, 1)
	}

	local function millions(value)
		return value * 1000000
	end

	self.skill_switch_cost = {
		{
			spending = 0,
			offshore = millions(0)
		},
		{
			spending = 0,
			offshore = millions(0)
		},
		{
			spending = 0,
			offshore = millions(0)
		},
		{
			spending = 0,
			offshore = millions(1)
		},
		{
			spending = 0,
			offshore = millions(10)
		},
		{
			spending = 0,
			offshore = millions(10)
		},
		{
			spending = 0,
			offshore = millions(10)
		},
		{
			spending = 0,
			offshore = millions(20)
		},
		{
			spending = 0,
			offshore = millions(20)
		},
		{
			spending = 0,
			offshore = millions(20)
		},
		{
			spending = 0,
			offshore = millions(25)
		},
		{
			spending = 0,
			offshore = millions(25)
		},
		{
			spending = 0,
			offshore = millions(25)
		},
		{
			spending = 0,
			offshore = millions(25)
		},
		{
			spending = 0,
			offshore = millions(25)
		},
		{
			spending = 0,
			offshore = millions(30)
		},
		{
			spending = 0,
			offshore = millions(30)
		},
		{
			spending = 0,
			offshore = millions(30)
		},
		{
			spending = 0,
			offshore = millions(30)
		},
		{
			spending = 0,
			offshore = millions(30)
		},
		{
			spending = 0,
			offshore = millions(35)
		},
		{
			spending = 0,
			offshore = millions(35)
		},
		{
			spending = 0,
			offshore = millions(35)
		},
		{
			spending = 0,
			offshore = millions(35)
		},
		{
			spending = 0,
			offshore = millions(35)
		},
		{
			spending = 0,
			offshore = millions(40)
		},
		{
			spending = 0,
			offshore = millions(40)
		},
		{
			spending = 0,
			offshore = millions(40)
		},
		{
			spending = 0,
			offshore = millions(40)
		},
		{
			spending = 0,
			offshore = millions(40)
		}
	}
	self.old_skill_switch_cost = {
		{
			offshore = 0,
			spending = 0
		},
		{
			offshore = 0,
			spending = 0
		},
		{
			offshore = 1000000,
			spending = 0
		},
		{
			offshore = 10000000,
			spending = 0
		},
		{
			offshore = 25000000,
			spending = 0
		},
		{
			offshore = 25000000,
			spending = 0
		},
		{
			offshore = 25000000,
			spending = 0
		},
		{
			offshore = 25000000,
			spending = 0
		},
		{
			offshore = 25000000,
			spending = 0
		},
		{
			offshore = 30000000,
			spending = 0
		},
		{
			offshore = 30000000,
			spending = 0
		},
		{
			offshore = 30000000,
			spending = 0
		},
		{
			offshore = 30000000,
			spending = 0
		},
		{
			offshore = 30000000,
			spending = 0
		},
		{
			offshore = 20000000,
			spending = 0
		}
	}

	-- mission asset cost calculation is in 
	-- MoneyManager:get_mission_asset_cost_by_id
	-- value = value + value * pc_multiplier + value * risk_multiplier
	-- risk_multiplier = difficulty_stars > 0 and self:get_tweak_value("money_manager", "mission_asset_cost_multiplier_by_risk", difficulty_stars) or 0
	self.mission_asset_cost_by_pc = self._create_value_table(1, 1, 10, true, 1)
	self.mission_asset_cost_multiplier_by_pc = {
		0,
		0,
		0,
		0,
		0,
		0,
		1
	}
	self.mission_asset_cost_multiplier_by_risk = {
		5,
		6,
		7,
		8,
		9,
		10,
		11
	}
	self.mission_asset_cost_small = self._create_value_table(2500, 15000, 10, true, 1)
	self.mission_asset_cost_medium = self._create_value_table(10000, 45000, 10, true, 1)
	self.mission_asset_cost_large = self._create_value_table(55000, 400000, 10, true, 1)
	self.preplaning_asset_cost_multiplier_by_risk = {
		5,
		6,
		7,
		8,
		9,
		10,
		11
	}
	-- calculation of preplanning asset costs is in 
	-- MoneyManager:get_preplanning_type_cost
	-- cost = cost * (self:get_tweak_value("money_manager", "preplaning_asset_cost_multiplier_by_risk", difficulty_stars) or 1)
	self.preplaning_asset_cost_thermite = 15000
	self.preplaning_asset_cost_escapebig = 10000
	self.preplaning_asset_cost_spycam = 6000
	self.preplaning_asset_cost_delay10 = 4000
	self.preplaning_asset_cost_delay20 = 6000
	self.preplaning_asset_cost_delay30 = 8000
	self.preplaning_asset_cost_timelock60 = 2000
	self.preplaning_asset_cost_cake = 3000
	self.preplaning_asset_cost_extracameras = 5000
	self.preplaning_asset_cost_accesscameras = 10000
	self.preplaning_asset_cost_drillparts = 3000
	self.preplaning_asset_cost_deaddropbag = 1600
	self.preplaning_asset_cost_unlocked_door = 1000
	self.preplaning_asset_cost_unlocked_window = 1000
	self.preplaning_asset_cost_zipline = 2000
	self.preplaning_asset_cost_highlight_keybox = 1000
	self.preplaning_asset_cost_keycard = 2000
	self.preplaning_asset_cost_disable_alarm_button = 2000
	self.preplaning_asset_cost_safe_escape = 2000
	self.preplaning_asset_cost_sniper_spot = 10000
	self.preplaning_asset_cost_framing_frame_1_truck = 1000
	self.preplaning_asset_cost_framing_frame_1_entry_point = 1000
	self.preplaning_asset_cost_bag_shortcut = 2000
	self.preplaning_asset_cost_bag_zipline = 2000
	self.preplaning_asset_cost_loot_drop_off = 3000
	self.preplaning_asset_cost_thermal_paste = 3000
	self.preplaning_asset_cost_branchbank_vault_key = 3000
	self.preplaning_mia_cost_sniper = 10000
	self.preplaning_mia_cost_delayed_police = 6000
	self.preplaning_mia_cost_reduce_mobsters = 8000
	self.preplaning_asset_cost_glass_cutter = 1000
	self.preplaning_thebomb_cost_spotter = 4000
	self.preplaning_thebomb_cost_crowbar = 1000
	self.preplaning_thebomb_cost_ladder = 1000
	self.preplaning_thebomb_cost_hacker = 3000
	self.preplaning_thebomb_cost_manifest = 2000
	self.preplaning_thebomb_cost_pilot = 3000
	self.preplaning_thebomb_cost_escape_mid = 6000
	self.preplaning_thebomb_cost_escape_close = 10000
	self.preplaning_thebomb_cost_demolition = 500
	self.preplaning_asset_cost_roof_access = 2000
	self.preplaning_asset_cost_upper_floor_access = 1000
	self.preplaning_asset_cost_crowbar_single = 1000
	self.preplaning_asset_cost_mex_keys = 2000
	self.preplanning_asset_cost_bex_car_pull = 2000
	self.preplanning_asset_cost_bex_drunk_mariachi = 2000
	self.preplanning_asset_cost_bex_garbage_truck = 2000
	self.preplanning_asset_cost_bex_zipline = 2000
	self.preplanning_asset_cost_pex_parked_car = 2000
	self.preplanning_asset_cost_pex_spiked_churro = 2000
	self.preplanning_asset_cost_pex_camera_access = 2000
	self.preplanning_asset_cost_pex_open_window = 2000
	self.preplanning_asset_cost_fex_stealth_entry_with_boat = 2000
	self.preplanning_asset_cost_fex_loud_escape_with_heli = 2000
	self.preplanning_asset_cost_fex_stealth_semi_open_garage_door = 2000
	self.preplanning_asset_cost_kenaz_zeppelin_escape = 0
	self.preplanning_asset_cost_kenaz_van_escape = 0
	self.preplanning_asset_cost_kenaz_loud_entry_with_c4 = 0
	self.preplanning_asset_cost_kenaz_wrecking_ball_escape = 0
	self.preplanning_asset_cost_kenaz_drill_better_plasma_cutter = 0
	self.preplanning_asset_cost_kenaz_drill_improved_cooling_system = 0
	self.preplanning_asset_cost_kenaz_drill_engine_optimization = 0
	self.preplanning_asset_cost_kenaz_drill_engine_additional_power = 0
	self.preplanning_asset_cost_kenaz_drill_extra_battery = 0
	self.preplanning_asset_cost_kenaz_drill_water_level_indicator = 0
	self.preplanning_asset_cost_kenaz_drill_timer_addon = 0
	self.preplanning_asset_cost_kenaz_drill_toolbox = 0
	self.preplanning_asset_cost_kenaz_drill_medkit = 0
	self.preplanning_asset_cost_kenaz_drill_ammobox = 0
	self.preplanning_asset_cost_kenaz_ace_pilot = 0
	self.preplanning_asset_cost_kenaz_faster_blimp = 0
	self.preplanning_asset_cost_kenaz_rig_slotmachine = 0
	self.preplanning_asset_cost_kenaz_sabotage_skylight_barrier = 0
	self.preplanning_asset_cost_kenaz_customer_data_USB = 0
	self.preplanning_asset_cost_kenaz_unlocked_cages = 0
	self.preplanning_asset_cost_kenaz_unlocked_doors = 0
	self.preplanning_asset_cost_kenaz_guitar_case_position = 0
	self.preplanning_asset_cost_kenaz_disable_metal_detectors = 0
	self.preplanning_asset_cost_kenaz_celebrity_visit = 0
	self.preplanning_asset_cost_kenaz_vault_gate_key = 0
	self.preplanning_asset_cost_chas_tram = 5000
	
	-- heist and difficulty-based small-loot values to actually make it worth it to take the small loot, go for deposits, play jewelry store etc.
	local get_difficulty_specific_value = Eclipse.utils.get_difficulty_specific_value
	local money_mul = get_difficulty_specific_value({
		1,
		1.1,
		1.2,
		1.3,
		1.4,
	})
	self.small_loot = {}
	if level_id == "big" then
		self.small_loot.money_bundle = ( money_mul * 1000 )
		self.small_loot.money_bundle_value = ( money_mul * 10000 )
		self.small_loot.value_gold = ( money_mul * 1000 )
		self.small_loot.gen_atm = ( money_mul * 72000 )
		self.small_loot.vault_loot_chest = ( money_mul * 10000 )
		self.small_loot.vault_loot_diamond_chest = ( money_mul * 20000 )
		self.small_loot.vault_loot_banknotes = ( money_mul * 9000 )
		self.small_loot.vault_loot_silver = ( money_mul * 7600 )
		self.small_loot.vault_loot_diamond_collection = ( money_mul * 13000 )
		self.small_loot.vault_loot_trophy = ( money_mul * 5000 )
		self.small_loot.vault_loot_gold = ( money_mul * 22500 )
		self.small_loot.vault_loot_cash = ( money_mul * 2500 )
		self.small_loot.vault_loot_coins = ( money_mul * 1800 )
		self.small_loot.vault_loot_ring = ( money_mul * 6000 )
		self.small_loot.vault_loot_jewels = ( money_mul * 1400 )
	elseif level_id == "family" or level_id == "jewelry_store" or level_id == "ukrainian_job" then
		self.small_loot.money_bundle = ( money_mul * 1000 )
		self.small_loot.diamondheist_vault_bust = ( money_mul * 3000 )
		self.small_loot.diamondheist_vault_diamond = ( money_mul * 5750 )
		self.small_loot.diamondheist_big_diamond = ( money_mul * 7250 )
		self.small_loot.gen_atm = ( money_mul * 76000 )
		self.small_loot.vault_loot_gold =( money_mul * 2500 )
		self.small_loot.vault_loot_cash = ( money_mul * 1200 )
		self.small_loot.vault_loot_coins = ( money_mul * 800 )
		self.small_loot.vault_loot_ring = ( money_mul * 300 )
		self.small_loot.vault_loot_jewels = ( money_mul * 600 )
		self.bag_values.diamonds = 12500 -- 12,500$
	elseif level_id == "watchdogs_2" or level_id == "watchdogs_2_day" then
		self.small_loot.money_bundle = ( money_mul * 50000 )
	elseif level_id == "four_stores" then
		self.small_loot.money_bundle = ( money_mul * 750 )
		self.small_loot.vault_loot_gold = ( money_mul * 10000 )
		self.small_loot.vault_loot_cash = ( money_mul * 2000 )
		self.small_loot.vault_loot_coins = ( money_mul * 1000 )
		self.small_loot.vault_loot_ring = ( money_mul * 4000 )
		self.small_loot.vault_loot_jewels = ( money_mul * 1800 )
	elseif level_id == "dah" then
		self.small_loot.diamondheist_vault_bust = ( money_mul * 50000 )
		self.small_loot.diamondheist_vault_diamond = ( money_mul * 15000 )
		self.small_loot.diamondheist_big_diamond = ( money_mul * 25000 )
	elseif level_id == "red2" then
		self.bag_values.money = 90000 -- 90,000$
	elseif level_id == "dinner" then
		self.bag_values.gold = 350000 -- 350,000$
	else
		self.small_loot.money_bundle = ( money_mul * 1250 )
		self.small_loot.money_bundle_value = ( money_mul * 10000 )
		self.small_loot.ring_band = 1954
		self.small_loot.diamondheist_vault_bust = ( money_mul * 5750 )
		self.small_loot.diamondheist_vault_diamond = ( money_mul * 7250 )
		self.small_loot.diamondheist_big_diamond = ( money_mul * 10000 )
		self.small_loot.mus_small_artifact = ( money_mul * 700 )
		self.small_loot.value_gold = ( money_mul * 3000 )
		self.small_loot.gen_atm = ( money_mul * 76000 )
		self.small_loot.special_deposit_box = ( money_mul * 3500 )
		self.small_loot.slot_machine_payout = ( money_mul * 25000 )
		self.small_loot.vault_loot_chest = ( money_mul * 10000 )
		self.small_loot.vault_loot_diamond_chest = ( money_mul * 20000 )
		self.small_loot.vault_loot_banknotes = ( money_mul * 9000 )
		self.small_loot.vault_loot_silver = ( money_mul * 12250 )
		self.small_loot.vault_loot_diamond_collection = ( money_mul * 13000 )
		self.small_loot.vault_loot_trophy = ( money_mul * 15000 )
		self.small_loot.money_wrap_single_bundle_vscaled = ( money_mul * 385 )
		self.small_loot.spawn_bucket_of_money = ( money_mul * 20000 )
		self.small_loot.vault_loot_gold = ( money_mul * 22500 )
		self.small_loot.vault_loot_cash = ( money_mul * 2500 )
		self.small_loot.vault_loot_coins = ( money_mul * 1800 )
		self.small_loot.vault_loot_ring = ( money_mul * 6000 )
		self.small_loot.vault_loot_jewels = ( money_mul * 1400 )
		self.small_loot.vault_loot_macka = 1
		self.small_loot.federali_medal = 769
	end

	self.max_small_loot_value = 20000000
	self.skilltree = {
		respec = {}
	}
	self.skilltree.respec.base_cost = 200
	self.skilltree.respec.profile_cost_increaser_multiplier = {
		1,
		1,
		1,
		1,
		1,
		1,
		1,
		1,
		1,
		1
	}
	self.skilltree.respec.tier_cost = {
		1500,
		2000,
		10000,
		40000,
		100000,
		400000
	}
	self.skilltree.respec.base_point_cost = 500
	self.skilltree.respec.point_tier_cost = self._create_value_table(4000, self.biggest_cashout * 0.18, 6, true, 1.1)
	self.skilltree.respec.respec_refund_multiplier = 0.6
	self.skilltree.respec.point_cost = 0
	self.skilltree.respec.point_multiplier_cost = 1
	local loot_drop_value = 10000
	self.loot_drop_cash = {
		cash10 = loot_drop_value * 2,
		cash20 = loot_drop_value * 4,
		cash30 = loot_drop_value * 6,
		cash40 = loot_drop_value * 8,
		cash50 = loot_drop_value * 9,
		cash60 = loot_drop_value * 10,
		cash70 = loot_drop_value * 11,
		cash80 = loot_drop_value * 12,
		cash90 = loot_drop_value * 13,
		cash100 = loot_drop_value * 14,
		cash_preorder = self.biggest_cashout / 10
	}

	if SystemInfo:platform() == Idstring("XB1") then
		self.loot_drop_cash.xone_bonus = 5000000
	end

	self.unlock_new_mask_slot_value = 250000
	self.unlock_new_weapon_slot_value = 375000
	self.moneythrower = {
		max_kills_per_session = 100,
		kill_to_offshore_multiplier = 1000
	}
end
