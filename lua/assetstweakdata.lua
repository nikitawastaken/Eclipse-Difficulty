Hooks:PostHook(AssetsTweakData, "_init_risk_assets", "eclipse_init_risk_assets", function(self, tweak_data)
	local non_america_faction_heists = {
		-- Vanilla exclude_stages list
		"safehouse",
		"chill",
		"crojob1",
		"haunted",
		"cage",
		"kosugi",
		"dark",
		"mad",
		"fish",
		-- New heists to exclude_stages
		"tag", -- In vanilla Breakin Feds have risk assets :xdd:
		-- Akan mercs
		"pines",
		-- Murkywater
		"shoutout_raid",
		"wwh",
		-- Mexico
		"bex",
		"fex",
		"pex",
		-- Zombies
		"hvh",
		"nail",
		"help",
	}
	
	self.risk_pd.exclude_stages = non_america_faction_heists	
	self.risk_swat.exclude_stages = non_america_faction_heists
	self.risk_fbi.exclude_stages = non_america_faction_heists
	self.risk_death_squad.exclude_stages = non_america_faction_heists
	self.risk_easy_wish.exclude_stages = non_america_faction_heists
	-- Technically vanilla DW and DS diffs are not available but doing this just in case
	self.risk_death_wish.exclude_stages = non_america_faction_heists
	self.risk_sm_wish.exclude_stages = non_america_faction_heists

	-- Ru mercs assets to White Xmas
	table.insert(self.mad_russian_merc_cameras.stages, "pines")
end)