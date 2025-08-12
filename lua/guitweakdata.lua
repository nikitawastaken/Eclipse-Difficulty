Hooks:PostHook(GuiTweakData, "init", "eclipse_init", function(self)
	self.armor_damage_shake_base = 1
	self.buy_weapon_categories = {
		primaries = {
			{
				"assault_rifle",
			},
			{
				"dmr",
			},
			{
				"smg",
			},
			{
				"shotgun",
			},
			{
				"lmg",
			},
			{
				"snp",
			},
			{
				"akimbo",
			},
			{
				"wpn_special",
			},
		},
		secondaries = {
			{
				"pistol",
			},
			{
				"revolver",
			},
			{
				"assault_rifle",
			},
			{
				"smg",
			},
			{
				"shotgun",
			},
			{
				"snp",
			},
			{
				"wpn_special",
			},
		},
	}
	self.blackscreen_risk_textures = {
		easy_wish = "guis/textures/pd2/risklevel_deathwish_sm_blackscreen",
		overkill_145 = "guis/textures/pd2/risklevel_deathwish_blackscreen",
		overkill = "guis/textures/pd2/risklevel_deathwish_easywish_blackscreen",
	}
end)
