local level_id = Eclipse.utils.clean_level_id()

Hooks:PostHook(InteractionTweakData, "init", "eclipse_init", function(self)
	self.revive.timer = 4.5
	self.drill_upgrade.timer = 0
	self.lance_upgrade.timer = 0
	self.gen_int_saw_upgrade.timer = 0
	self.gage_assignment.timer = 0
	self.hostage_move.timer = self.hostage_move.timer / 2
	self.hostage_stay.timer = 0

	--PEOC Pardons insta-pickup
	self.take_pardons.timer = 0

	-- Reduce armored transport truck deposit box lockpick time
	self.pick_lock_deposit_transport.timer = 10

	if level_id == "haunted" then
		self.pick_lock_hard.timer = 666 -- Dallas, my friend, the devil.
	end

	-- Bagging sfx tweaks
	self.money_wrap.sound_done = "bar_bag_pour_money_finished"
	self.money_wrap.sound_start = "bar_bag_pour_money"
	self.money_wrap.sound_interupt = "bar_bag_pour_money_cancel"
	self.money_wrap_axis.sound_done = "bar_bag_pour_money_finished"
	self.money_wrap_axis.sound_start = "bar_bag_pour_money"
	self.money_wrap_axis.sound_interupt = "bar_bag_pour_money_cancel"
	self.money_wrap_updating_directional.sound_done = "bar_bag_pour_money_finished"
	self.money_wrap_updating_directional.sound_start = "bar_bag_pour_money"
	self.money_wrap_updating_directional.sound_interupt = "bar_bag_pour_money_cancel"
	self.gen_pku_jewelry.sound_start = "bar_bag_jewelry"
	self.gen_pku_jewelry.sound_interupt = "bar_bag_jewelry_cancel"
	self.gen_pku_jewelry.sound_done = "bar_bag_jewelry_finished"
	self.diamonds_pickup_full.sound_start = "bar_bag_jewelry"
	self.diamonds_pickup_full.sound_interupt = "bar_bag_jewelry_cancel"
	self.diamonds_pickup_full.sound_done = "bar_bag_jewelry_finished"
	self.diamonds_pickup.sound_interupt = "bar_bag_jewelry_cancel"
	self.diamonds_pickup.sound_start = "bar_bag_jewelry"
	self.diamonds_pickup.sound_done = "bar_bag_jewelry_finished"
	self.diamond_pickup_3sec.sound_interupt = "bar_bag_jewelry_cancel"
	self.diamond_pickup_3sec.sound_start = "bar_bag_jewelry"
	self.diamond_pickup_3sec.sound_done = "bar_bag_jewelry_finished"
	self.money_wrap_single_bundle.sound_done = "bar_bag_pour_money_finished"
	self.money_wrap_single_bundle.sound_start = "bar_bag_pour_money"
	self.money_wrap_single_bundle.sound_interupt = "bar_bag_pour_money_cancel"
	self.money_wrap_active.sound_done = "bar_bag_pour_money_finished"
	self.money_wrap_active.sound_start = "bar_bag_pour_money"
	self.money_wrap_active.sound_interupt = "bar_bag_pour_money_cancel"
	self.money_wrap_single_bundle_dyn.sound_done = "bar_bag_pour_money_finished"
	self.money_wrap_single_bundle_dyn.sound_start = "bar_bag_pour_money"
	self.money_wrap_single_bundle_dyn.sound_interupt = "bar_bag_pour_money_cancel"
	self.suburbia_money_wrap.sound_done = "bar_bag_pour_money_finished"
	self.suburbia_money_wrap.sound_start = "bar_bag_pour_money"
	self.suburbia_money_wrap.sound_interupt = "bar_bag_pour_money_cancel"
	self.hold_grab_goat.sound_start = "goat_says_meh"
	self.hold_grab_goat.sound_interupt = "goat_lick"
	self.hold_grab_goat.sound_done = "goat_says_meh"
	self.cas_take_usb_key.sound_event = "money_grab"
	self.pour_spiked_drink.sound_event = "liquid_pour"
	self.hold_unlock_car.sound_start = "bar_unlock_grate_door"
	self.hold_unlock_car.sound_interupt = "bar_unlock_grate_door_cancel"
	self.hold_unlock_car.sound_done = "bar_unlock_grate_door_finished"
	self.gen_pku_cocaine.sound_start = "bar_bag_money"
	self.gen_pku_cocaine.sound_interupt = "bar_bag_money_cancel"
	self.gen_pku_cocaine.sound_done = "bar_bag_pour_money_finished"
	self.gen_pku_cocaine_pure.sound_start = "bar_bag_money"
	self.gen_pku_cocaine_pure.sound_interupt = "bar_bag_money_cancel"
	self.gen_pku_cocaine_pure.sound_done = "bar_bag_pour_money_finished"
	self.gen_pku_cocaine_directional.sound_start = "bar_bag_money"
	self.gen_pku_cocaine_directional.sound_interupt = "bar_bag_money_cancel"
	self.gen_pku_cocaine_directional.sound_done = "bar_bag_pour_money_finished"
	self.gen_pku_sandwich.sound_start = "santa_hoho"
	self.gen_pku_sandwich.sound_interupt = "bar_bag_money_cancel"
	self.gen_pku_sandwich.sound_done = "bar_bag_pour_money_finished"
	self.set_off_alarm.sound_start = "bar_car_tap"
	self.set_off_alarm.sound_interupt = "bar_car_tap_cancel"
	self.set_off_alarm.sound_done = "bar_car_tap_finished"
	self.weapon_case.sound_start = "bar_open_warhead_box"
	self.weapon_case.sound_interupt = "bar_open_warhead_box_cancel"
	self.weapon_case.sound_done = "bar_open_warhead_box_finished"
	self.money_briefcase.sound_done = "bar_open_warhead_box_finished"
	self.taking_meth.sound_done = "bar_bag_pour_money_finished"
	self.taking_meth_huge.sound_done = "bar_bag_pour_money_finished"
	self.c4_diffusible.sound_start = "bar_disarm_c4_loop_start"
	self.c4_diffusible.sound_interupt = "bar_disarm_c4_loop_cancel"
	self.c4_diffusible.sound_done = "bar_disarm_c4_loop_finished"
	self.hold_take_painting.sound_done = "bar_bag_pour_money_finished"
	self.gen_pku_fusion_reactor.sound_done = "bar_bag_pour_money_finished"
	self.gen_pku_artifact_statue.sound_done = "bar_bag_pour_money_finished"
	self.gen_pku_artifact.sound_done = "bar_bag_pour_money_finished"
	self.gen_pku_artifact_painting.sound_done = "bar_bag_pour_money_finished"
	self.gen_pku_jewelry.sound_done = "bar_bag_pour_money_finished"
	self.taking_meth.sound_done = "bar_bag_pour_money_finished"
	self.gen_pku_evidence_bag.sound_done = "bar_bag_pour_money_finished"
	self.take_weapons.sound_start = "bar_bag_generic"
	self.take_weapons.sound_interupt = "bar_bag_generic_cancel"
	self.take_weapons.sound_done = "bar_bag_pour_money_finished"
	self.steal_methbag.sound_start = "bar_bag_generic"
	self.steal_methbag.sound_interupt = "bar_bag_generic_cancel"
	self.steal_methbag.sound_done = "ammo_bag_drop"
	self.hold_place_gps_tracker.sound_start = "bar_disarm_c4_loop_start"
	self.hold_place_gps_tracker.sound_interupt = "bar_disarm_c4_loop_cancel"
	self.hold_place_gps_tracker.sound_done = "bar_disarm_c4_loop_finished"
	self.burning_money.sound_start = "bar_thermal_lance_fix"
	self.burning_money.sound_interupt = "bar_thermal_lance_fix_cancel"
	self.burning_money.sound_done = "bar_thermal_lance_fix_finished"
	self.gold_pile.sound_start = "bar_bag_money"
	self.gold_pile.sound_interupt = "bar_bag_money_cancel"
	self.gold_pile.sound_done = "bar_bag_pour_money_finished"
	self.chas_tea_set.sound_start = "bar_bag_money"
	self.chas_tea_set.sound_interupt = "bar_bag_money_cancel"
	self.chas_tea_set.sound_done = "bar_bag_pour_money_finished"
	self.hold_take_shoes.sound_done = "bar_bag_pour_money_finished"
	self.hold_take_toy.sound_done = "bar_pick_up_tin_boy_finish"
	self.hold_take_expensive_wine.sound_done = "bar_pick_up_box_wine_finish"
	self.hold_take_diamond_necklace.sound_done = "bar_pick_up_box_finish"
	self.hold_take_vr_headset.sound_done = "bar_pick_up_box_finish"
	self.mex_pickup_meth_bag.sound_start = "bar_bag_generic"
	self.mex_pickup_meth_bag.sound_interupt = "bar_bag_generic_cancel"
	self.mex_pickup_meth_bag.sound_done = "ammo_bag_drop"
	self.take_pardons.sound_event = "money_grab"
	self.hostage_trade.sound_start = "bar_untie_hostage"
	self.hostage_trade.sound_interupt = "bar_untie_hostage_cancel"
	self.hostage_trade.sound_done = "bar_untie_hostage_finished"

	self.hostage_trade.contour_preset = "hostage_trade_uncustody"
	self.hostage_trade.contour_flash_interval = 0.5
	self.hostage_trade_resources = deep_clone(self.hostage_trade)
	self.hostage_trade_resources.contour_preset = "hostage_trade_resources"
	self.hostage_trade_resources.text_id = "debug_interact_trade_resources"

	self.grenade_crate.timer = 3.5
	self.grenade_crate.upgrade_timer_multiplier = {
		upgrade = "deploy_interact_faster",
		category = "player",
	}

	-- Faster hacking interactions
	self.hack_ipad.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.hack_ipad_jammed.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.hack_suburbia.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.hack_suburbia_outline.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.hack_suburbia_jammed.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.hack_suburbia_jammed_y.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.hack_suburbia_jammed_axis.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.hack_suburbia_axis.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.security_station.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.security_station_keyboard.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.big_computer_hackable.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.big_computer_not_hackable.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.big_computer_server.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.security_station_jammed.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.hack_numpad.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.votingmachine2.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.votingmachine2_jammed.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.sc_tape_loop.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.hack_electric_box.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.hack_ship_control.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.timelock_hack.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.mcm_laptop.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.hack_skylight_barrier.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.drk_hold_hack_computer.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.hold_start_scan.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.hold_new_hack.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.hold_type_in_password.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
	self.hold_hack_server_room.upgrade_timer_multiplier = {
		upgrade = "hack_interaction_speed_multiplier",
		category = "player",
	}
end)
