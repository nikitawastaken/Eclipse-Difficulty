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
