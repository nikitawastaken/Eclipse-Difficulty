NarrativeTweakData.heist_jc_presets = Eclipse:require("progression/heist_jc_presets")
NarrativeTweakData.jc_presets = {
	["very_common"] = 10,
	["slightly_very_common"] = 20,
	["common"] = 30,
	["slightly_rare"] = 40,
	["rare"] = 50,
	["slightly_very_rare"] = 60,
	["very_rare"] = 70,
	["extremely_rare"] = 80,
}

Hooks:PostHook(NarrativeTweakData, "init", "eclipse_init", function(self)
	self.STARS = {
		{
			jcs = {
				30,
				20,
				10,
			},
		},
		{
			jcs = {
				40,
				30,
				20,
				10,
			},
		},
		{
			jcs = {
				50,
				40,
				30,
				20,
				10,
			},
		},
		{
			jcs = {
				60,
				50,
				40,
				30,
				20,
				10,
			},
		},
		{
			jcs = {
				70,
				60,
				50,
				40,
				30,
				20,
				10,
			},
		},
		{
			jcs = {
				80,
				70,
				60,
				50,
				40,
				30,
				20,
				10,
			},
		},
		{
			jcs = {
				90,
				80,
				70,
				60,
				50,
				40,
				30,
				20,
				10,
			},
		},
		{
			jcs = {
				100,
				90,
				80,
				70,
				60,
				50,
				40,
				30,
				20,
				10,
			},
		},
		{
			jcs = {
				100,
				90,
				80,
				70,
				60,
				50,
				40,
				30,
				20,
				10,
			},
		},
		{
			jcs = {
				100,
				90,
				80,
				70,
				60,
				50,
				40,
				30,
				20,
				10,
			},
		},
	}

	--Improve crime.net vids on some of the heists
	--The Dentist's heists
	self.jobs.mia.crimenet_videos = {
		"cn_hlm1",
		"cn_hlm2",
		"cn_hlm3",
	}
	self.jobs.hox.crimenet_videos = {
		"cn_hox1",
		"cn_hox2",
		"cn_hox3",
		"cn_hox4",
	}
	self.jobs.hox_3.crimenet_videos = {
		"cn_hox1",
		"cn_hox2",
		"cn_hox3",
		"cn_hox4",
	}
	self.jobs.mus.crimenet_videos = {
		"cn_big1",
		"cn_big2",
		"cn_big3",
	}
	self.jobs.kenaz.crimenet_videos = {
		"cn_big1",
		"cn_big2",
		"cn_big3",
	}
	--Vlad's heists
	--for some reason these 2 Vlad's last heists have a crimenet_video from codex instead of regular ones
	self.jobs.fex.crimenet_videos = {
		"cn_ukr1",
		"cn_ukr2",
		"cn_ukr3",
		"cn_nightc1",
		"cn_nightc2",
		"cn_nightc3",
	}
	self.jobs.chca.crimenet_videos = {
		"cn_ukr1",
		"cn_ukr2",
		"cn_ukr3",
		"cn_nightc1",
		"cn_nightc2",
		"cn_nightc3",
	}

	-- Safehouse Raid in contract broker
	self.jobs.chill_combat.contact = "bain"
	self.jobs.chill_combat.contract_visuals = {}
	self.jobs.chill_combat.contract_visuals.preview_image = {
		id = "chill_combat",
	}
	self.jobs.chill_combat.marker_dot_color = nil

	-- If you want money, you stay and get additional loot- otherwise all you get is mainly XP
	-- These are base values only, the rest is handled by difficulty_multiplier_payout for now (moneytweakdata)
	self.jobs.jewelry_store.payout = { 2000 }
	self.jobs.gallery.payout = { 4000 }
	self.jobs.four_stores.payout = { 4000 }
	self.jobs.mallcrasher.payout = { 10000 }
	self.jobs.ukrainian_job.payout = { 9000 }
	self.jobs.nightclub.payout = { 9000 }
	self.jobs.branchbank.payout = { 7500 }
	self.jobs.branchbank_prof.payout = { 7500 }
	self.jobs.branchbank_deposit.payout = { 7500 }
	self.jobs.branchbank_cash.payout = { 7500 }
	self.jobs.branchbank_gold.payout = { 7500 }
	self.jobs.branchbank_gold_prof.payout = { 7500 }
	self.jobs.arm_cro.payout = { 12500 }
	self.jobs.arm_und.payout = { 12500 }
	self.jobs.arm_hcm.payout = { 12500 }
	self.jobs.arm_par.payout = { 12500 }
	self.jobs.arm_fac.payout = { 12500 }
	self.jobs.arm_for.payout = { 12500 }
	self.jobs.election_day.payout = { 20000 }
	self.jobs.rat.payout = { 20500 }
	self.jobs.alex.payout = { 20500 }
	self.jobs.firestarter.payout = { 24000 }
	self.jobs.watchdogs.payout = { 18000 }
	self.jobs.watchdogs_wrapper.payout = { 18000 }
	self.jobs.family.payout = { 4000 }
	self.jobs.welcome_to_the_jungle_wrapper_prof.payout = { 75000 }
	self.jobs.welcome_to_the_jungle_wrapper.payout = { 75000 }
	self.jobs.welcome_to_the_jungle.payout = { 75000 }
	self.jobs.framing_frame.payout = { 35000 }
	self.jobs.big.payout = { 24000 }
	self.jobs.roberts.payout = { 12500 }
	self.jobs.hox.payout = { 550000 }
	self.jobs.hox_3.payout = { 175000 }
	self.jobs.crojob1.payout = { 60000 }
	self.jobs.crojob_wrapper.payout = { 60000 }
	self.jobs.crojob2.payout = { 60000 }
	self.jobs.cage.payout = { 18500 }
	self.jobs.shoutout_raid.payout = { 80000 }
	self.jobs.arena.payout = { 45000 }
	self.jobs.kenaz.payout = { 50000 }
	self.jobs.pines.payout = { 15000 }
	self.jobs.jolly.payout = { 2015 }
	self.jobs.red2.payout = { 35000 }
	self.jobs.dinner.payout = { 25000 }
	self.jobs.pbr.payout = { 150000 }
	self.jobs.pbr2.payout = { 1250000 }
	self.jobs.pal.payout = { 125000 }
	self.jobs.cane.payout = { 10000 }
	self.jobs.nail.payout = { 2015 }
	self.jobs.peta.payout = { 2016 }
	self.jobs.man.payout = { 1250000 }
	self.jobs.dark.payout = { 65000 }
	self.jobs.mad.payout = { 50000 }
	self.jobs.mus.payout = { 25000 }
	self.jobs.mia.payout = { 50000 }
	self.jobs.born.payout = { 60000 }
	self.jobs.friend.payout = { 50000 }
	self.jobs.moon.payout = { 12000 }
	self.jobs.spa.payout = { 80000 }
	self.jobs.spa.contract_cost = { 27000, 64000, 93700, 125000, 164000, 190000, 240000 }
	self.jobs.fish.payout = { 40000 }
	self.jobs.flat.payout = { 90000 }
	self.jobs.help.payout = { 2016 }
	self.jobs.run.payout = { 300000 }
	self.jobs.glace.payout = { 750000 }
	self.jobs.haunted.payout = { 2013 }
	self.jobs.dah.payout = { 60000 }
	self.jobs.rvd.payout = { 80000 }
	self.jobs.brb.payout = { 24000 }
	self.jobs.hvh.payout = { 2017 }
	self.jobs.wwh.payout = { 90000 }
	self.jobs.tag.payout = { 125000 }
	self.jobs.des.payout = { 250000 }
	self.jobs.vit.payout = { 500000 }
	self.jobs.bph.payout = { 750000 }
	self.jobs.mex.payout = { 75000 }
	self.jobs.mex_cooking.payout = { 35000 }
	self.jobs.bex.payout = { 90000 }
	self.jobs.pex.payout = { 115000 }
	self.jobs.fex.payout = { 300000 }
	self.jobs.chas.payout = { 45000 }
	self.jobs.sand.payout = { 250000 }
	self.jobs.chca.payout = { 30000 }
	self.jobs.pent.payout = { 50000 }
	self.jobs.ranc.payout = { 75000 }
	self.jobs.trai.payout = { 100000 }
	self.jobs.corp.payout = { 120000 }
	self.jobs.deep.payout = { 270465 }
	self.jobs.boss.payout = { 50000 }
	self.jobs.nmh.payout = { 1155350 }
	self.jobs.sah.payout = { 100000 }
	self.jobs.chill.payout = { 0 }
	self.jobs.chill_combat.payout = { 0 }

	-- Hide contracts from broker (can still appear on CRIME.NET)
	self.contacts.bain_no_variation.hidden = true
	self.jobs.branchbank_deposit.contact = "bain_no_variation"
	self.jobs.branchbank_cash.contact = "bain_no_variation"
	self.jobs.branchbank_prof.contact = "bain_no_variation"
	self.jobs.branchbank_gold_prof.contact = "bain_no_variation"

	-- Disable ability to choose type of Bank Heist in broker
	table.insert(self._jobs_index, "branchbank")
	self.jobs.branchbank.name_id = "heist_branchbank_hl"
	self.jobs.branchbank.contract_visuals.preview_image = { id = "branchbank" }

	--Halloween heists gets Stonecold's (PDTH Alpha) menu movie (mysterious)
	self.jobs.haunted.crimenet_videos = { "menu" }
	self.jobs.nail.crimenet_videos = { "menu" }
	self.jobs.help.crimenet_videos = { "menu" }
	self.jobs.hvh.crimenet_videos = { "menu" }

	--fix Ukrainian Prisoner using Vlad's codex for some reason
	self.jobs.sand.crimenet_videos = { "codex/jiufeng1" }

	for k, v in pairs(self.jobs) do
		local heist_preset = self.heist_jc_presets[k]

		if v.jc and heist_preset then
			v.jc = self.jc_presets[heist_preset] or v.jc
		end
	end
end)
