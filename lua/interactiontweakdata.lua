Hooks:PostHook(InteractionTweakData, "init", "eclipse_init", function(self)
	self.revive.timer = 4.5
	self.drill_upgrade.timer = 0
	self.lance_upgrade.timer = 0
	self.gen_int_saw_upgrade.timer = 0
	self.gage_assignment.timer = 0
	self.hostage_move.timer = self.hostage_move.timer / 2
	self.hostage_stay.timer = 0

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
			category = "player"
		}
	self.hack_ipad_jammed.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.hack_suburbia.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.hack_suburbia_outline.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.hack_suburbia_jammed.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.hack_suburbia_jammed_y.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.hack_suburbia_jammed_axis.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.hack_suburbia_axis.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.security_station.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.security_station_keyboard.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.big_computer_hackable.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.big_computer_not_hackable.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.big_computer_server.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.security_station_jammed.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.hack_numpad.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.votingmachine2.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.votingmachine2_jammed.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.sc_tape_loop.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.hack_electric_box.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.hack_ship_control.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.timelock_hack.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.mcm_laptop.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.hack_skylight_barrier.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.drk_hold_hack_computer.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.hold_start_scan.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.hold_new_hack.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.hold_type_in_password.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
	self.hold_hack_server_room.upgrade_timer_multiplier = {
			upgrade = "hack_interaction_speed_multiplier",
			category = "player"
		}
end)
