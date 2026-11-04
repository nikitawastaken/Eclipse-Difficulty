Hooks:PostHook(DLCTweakData, "init", "eclipse_init", function(self)
	self.eclipse = {
		free = true,
		content = {},
	}
	self.eclipse.content.loot_global_value = "normal"
	self.eclipse.content.loot_drops = {
		{
			type_items = "weapon_mods",
			item_entry = "wpn_fps_upg_charm_eclipse",
		},
	}

	self.preorder.content.loot_drops = {
		{
			type_items = "materials",
			item_entry = "solid_flat_red",
			amount = 1,
		},
		{
			type_items = "materials",
			item_entry = "solid_flat_black",
			amount = 1,
		},
		{
			type_items = "textures",
			item_entry = "fan",
			amount = 1,
		},
		{
			type_items = "masks",
			item_entry = "skull",
			amount = 1,
		},
		{
			type_items = "weapon_mods",
			item_entry = "wpn_fps_upg_o_aimpoint_2",
			amount = 1,
		},
	}

	-- weapon color slop
	self.shl_bundle.content.loot_drops = {
		{
			amount = 1,
			item_entry = "color_red_crust",
			type_items = "weapon_skins",
		},
		{
			amount = 1,
			item_entry = "color_blue_deluxe",
			type_items = "weapon_skins",
		},
		{
			amount = 1,
			item_entry = "color_purple_song",
			type_items = "weapon_skins",
		},
		{
			amount = 1,
			item_entry = "color_blue_teal",
			type_items = "weapon_skins",
		},
		{
			amount = 1,
			item_entry = "color_green_mellow",
			type_items = "weapon_skins",
		},
		{
			amount = 1,
			item_entry = "color_blue_deep",
			type_items = "weapon_skins",
		},
		{
			amount = 1,
			item_entry = "color_blue_ice",
			type_items = "weapon_skins",
		},
		{
			amount = 1,
			item_entry = "color_orange_mellow",
			type_items = "weapon_skins",
		},
		{
			amount = 1,
			item_entry = "color_green_deluxe",
			type_items = "weapon_skins",
		},
		{
			amount = 1,
			item_entry = "color_pink_cat",
			type_items = "weapon_skins",
		},
	}

	self.anv_bundle.content.loot_drops = {
		{
			amount = 1,
			item_entry = "continental",
			type_items = "player_styles",
		},
		{
			amount = 1,
			item_entry = "continental",
			type_items = "gloves",
		},
		{
			amount = 1,
			item_entry = "color_anv_01",
			type_items = "weapon_skins",
		},
		{
			amount = 1,
			item_entry = "color_anv_02",
			type_items = "weapon_skins",
		},
		{
			amount = 1,
			item_entry = "color_anv_03",
			type_items = "weapon_skins",
		},
		{
			amount = 1,
			item_entry = "color_anv_04",
			type_items = "weapon_skins",
		},
		{
			amount = 1,
			item_entry = "color_anv_05",
			type_items = "weapon_skins",
		},
	}

	self.ach_wcc_pex_11.free = true
	self.ach_wcc_pex_9.free = true
	self.ach_wcs_bex_11.free = true
	self.ach_wcs_bex_10.free = true

	-- give crime spree armor skins for being a part of the pd2 community
	self.pd2_clan7 = {}
	self.pd2_clan7.content = {}
	self.pd2_clan7.dlc = "has_pd2_clan"
	self.pd2_clan7.content.loot_global_value = "pd2_clan"
	self.pd2_clan7.content.loot_drops = {
		{
			amount = 1,
			item_entry = "cvc_green",
			type_items = "armor_skins",
		},
		{
			amount = 1,
			item_entry = "cvc_black",
			type_items = "armor_skins",
		},
		{
			amount = 1,
			item_entry = "cvc_grey",
			type_items = "armor_skins",
		},
		{
			amount = 1,
			item_entry = "cvc_tan",
			type_items = "armor_skins",
		},
		{
			amount = 1,
			item_entry = "cvc_navy_blue",
			type_items = "armor_skins",
		},
		{
			amount = 1,
			item_entry = "drm_tree_stump",
			type_items = "armor_skins",
		},
		{
			amount = 1,
			item_entry = "drm_gray_raider",
			type_items = "armor_skins",
		},
		{
			amount = 1,
			item_entry = "drm_desert_twilight",
			type_items = "armor_skins",
		},
		{
			amount = 1,
			item_entry = "drm_navy_breeze",
			type_items = "armor_skins",
		},
		{
			amount = 1,
			item_entry = "drm_woodland_tech",
			type_items = "armor_skins",
		},
		{
			amount = 1,
			item_entry = "drm_khaki_eclipse",
			type_items = "armor_skins",
		},
		{
			amount = 1,
			item_entry = "drm_desert_tech",
			type_items = "armor_skins",
		},
		{
			amount = 1,
			item_entry = "drm_misted_grey",
			type_items = "armor_skins",
		},
		{
			amount = 1,
			item_entry = "drm_khaki_regular",
			type_items = "armor_skins",
		},
		{
			amount = 1,
			item_entry = "drm_somber_woodland",
			type_items = "armor_skins",
		},
	}

	-- Gloves and other cosmetics locked behind achievements
	self.ach_hnd_dah_1.free = true
	self.ach_trd_dah_1.free = true
	self.ach_trd_nmh_1.free = true
	self.ach_trd_glace_1.free = true
	self.ach_trd_sah_1.free = true
	self.ach_trd_wwh_1.free = true
	self.ach_trd_mex_9.free = true
	self.ach_trk_cou_0.free = true
	self.ach_trd_sus_1.free = true
	self.ach_trd_bex_1.free = true
	self.ach_trd_bex_2.free = true
	self.ach_trd_bex_3.free = true
	self.ach_trd_bex_4.free = true
	self.ach_trd_bex_5.free = true
	self.ach_trd_pent_11.free = true
	self.ach_deep_10.free = true
	self.ach_hnd_mex_9.free = true
	self.ach_hnd_bex_1.free = true
	self.ach_wcc_fex_4.free = true
	self.ach_lrfo_1.free = true

	-- Fix Hoxton being unavailable
	self.freed_old_hoxton.free = true

	-- remove viper gas achievement unlock
	self.ach_pxp1_01.content.upgrades = nil

	-- don't give a bunch of stuff by default at level 0
	self.armored_transport.content.upgrades = nil
	self.pd2_clan_lgl.content.upgrades = nil
	self.pd2_clan2.content.upgrades = nil
	self.gage_pack.content.upgrades = nil
	self.preorder.content.upgrades = nil
	self.cce.content.upgrades = nil
	self.gage_pack_lmg.content.upgrades = nil
	self.starter_kit.content.upgrades = nil
	self.mxm_upgrades.content.upgrades = { "grenade_crate" }
	self.sawp_grenade.content.upgrades = nil
end)
