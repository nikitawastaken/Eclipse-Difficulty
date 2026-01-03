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
			type_items = "colors",
			item_entry = "red_black",
			amount = 1
		},
		{
			type_items = "textures",
			item_entry = "fan",
			amount = 1
		},
		{
			type_items = "masks",
			item_entry = "skull",
			amount = 1
		},
		{
			type_items = "weapon_mods",
			item_entry = "wpn_fps_upg_o_aimpoint_2",
			amount = 1
		}
	}

	table.delete(self.preorder.content.upgrades, "player_crime_net_deal")
	table.delete(self.cce.content.upgrades, "player_crime_net_deal_2")

	-- don't give a bunch of stuff by default at level 0
	self.armored_transport.content.upgrades = nil
	self.pd2_clan_lgl.content.upgrades = nil
	self.pd2_clan2.content.upgrades = nil
	self.gage_pack.content.upgrades = nil
	self.gage_pack_lmg.content.upgrades = nil
	self.starter_kit.content.upgrades = nil
	self.mxm_upgrades.content.upgrades = { "grenade_crate" }
	self.sawp_grenade.content.upgrades = nil
end)