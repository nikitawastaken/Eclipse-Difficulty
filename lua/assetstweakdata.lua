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
		"pbr",
		"shoutout_raid",
		"bph",
		"des",
		"wwh",
		"mex",
		"mex_cooking",
		-- Mexico
		"bex",
		"fex",
		"pex",
		-- Zombies
		"hvh",
		"nail",
		"help",
	}

	local murkywater_heists = {
		"pbr",
		"shoutout_raid",
		"bph",
		"des",
		"wwh",
		"mex",
		"mex_cooking",
	}

	local reapers_heists = {
		"mad",
		"pines",
	}

	local federales_heists = {
		"bex",
		"fex",
		"pex",
	}
	
	local army_presence_heists = {
		"arm_for",
		"roberts",
		"crojob1",
		"crojob2",
		"jolly",
		"peta_2",
		"vit",
	}
	
	self.risk_pd.exclude_stages = non_america_faction_heists
	self.risk_swat.exclude_stages = non_america_faction_heists
	self.risk_fbi.exclude_stages = non_america_faction_heists
	self.risk_death_squad.exclude_stages = non_america_faction_heists
	self.risk_easy_wish.exclude_stages = non_america_faction_heists
	-- Technically vanilla DW and DS diffs are not available but doing this just in case
	self.risk_death_wish.exclude_stages = non_america_faction_heists
	self.risk_sm_wish.exclude_stages = non_america_faction_heists

	-- Murkywater risk assets setup
	self.risk_murkywater_pd = {
		name_id = "menu_asset_risklevel_0",
		texture = "guis/textures/pd2/mission_briefing/assets/assets_risklevel_0_murkywater",
		stages = murkywater_heists,
		risk_lock = 0,
	}
	self.risk_murkywater_swat = {
		name_id = "menu_asset_risklevel_1",
		texture = "guis/textures/pd2/mission_briefing/assets/assets_risklevel_1_murkywater",
		stages = murkywater_heists,
		risk_lock = 1,
	}
	self.risk_murkywater_fbi = {
		name_id = "menu_asset_risklevel_2",
		texture = "guis/textures/pd2/mission_briefing/assets/assets_risklevel_2_murkywater",
		stages = murkywater_heists,
		risk_lock = 2,
	}
	self.risk_murkywater_death_squad = {
		name_id = "menu_asset_risklevel_3",
		texture = "guis/textures/pd2/mission_briefing/assets/assets_risklevel_3_murkywater",
		stages = murkywater_heists,
		risk_lock = 3,
	}
	self.risk_murkywater_easy_wish = {
		name_id = "menu_asset_risklevel_4",
		texture = "guis/textures/pd2/mission_briefing/assets/assets_risklevel_4_murkywater",
		stages = murkywater_heists,
		risk_lock = 4,
	}

	-- Reapers risk assets setup
	self.risk_reapers_pd = {
		name_id = "menu_asset_risklevel_0",
		texture = "guis/textures/pd2/mission_briefing/assets/assets_risklevel_0_reapers",
		stages = reapers_heists,
		risk_lock = 0,
	}
	self.risk_reapers_swat = {
		name_id = "menu_asset_risklevel_1",
		texture = "guis/textures/pd2/mission_briefing/assets/assets_risklevel_1_reapers",
		stages = reapers_heists,
		risk_lock = 1,
	}
	self.risk_reapers_fbi = {
		name_id = "menu_asset_risklevel_2",
		texture = "guis/textures/pd2/mission_briefing/assets/assets_risklevel_2_reapers",
		stages = reapers_heists,
		risk_lock = 2,
	}
	self.risk_reapers_death_squad = {
		name_id = "menu_asset_risklevel_3",
		texture = "guis/textures/pd2/mission_briefing/assets/assets_risklevel_3_reapers",
		stages = reapers_heists,
		risk_lock = 3,
	}
	self.risk_reapers_easy_wish = {
		name_id = "menu_asset_risklevel_4",
		texture = "guis/textures/pd2/mission_briefing/assets/assets_risklevel_4_reapers",
		stages = reapers_heists,
		risk_lock = 4,
	}

	-- Federales risk assets setup
	self.risk_federales_pd = {
		name_id = "menu_asset_risklevel_0",
		texture = "guis/textures/pd2/mission_briefing/assets/assets_risklevel_0_federales",
		stages = federales_heists,
		risk_lock = 0,
	}
	self.risk_federales_swat = {
		name_id = "menu_asset_risklevel_1",
		texture = "guis/textures/pd2/mission_briefing/assets/assets_risklevel_1_federales",
		stages = federales_heists,
		risk_lock = 1,
	}
	self.risk_federales_fbi = {
		name_id = "menu_asset_risklevel_2",
		texture = "guis/textures/pd2/mission_briefing/assets/assets_risklevel_2_federales",
		stages = federales_heists,
		risk_lock = 2,
	}
	self.risk_federales_death_squad = {
		name_id = "menu_asset_risklevel_3",
		texture = "guis/textures/pd2/mission_briefing/assets/assets_risklevel_3_federales",
		stages = federales_heists,
		risk_lock = 3,
	}
	self.risk_federales_easy_wish = {
		name_id = "menu_asset_risklevel_4",
		texture = "guis/textures/pd2/mission_briefing/assets/assets_risklevel_4_federales",
		stages = federales_heists,
		risk_lock = 4,
	}
	
	-- Army units asset
	self.army_info = {
		name_id = "menu_asset_army_info",
		texture = "guis/textures/pd2/mission_briefing/assets/army",
		stages = army_presence_heists,
	}

	-- Remove the 'Expert Pilot' asset on Rats Day 3
	self.rat_3_pilot.stages = {}

	-- Remove vanilla Reapers assets from Boiling Point
	self.mad_russian_merc_cameras.stages = {}
end)
