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
				10
			}
		},
		{
			jcs = {
				40,
				30,
				20,
				10
			}
		},
		{
			jcs = {
				50,
				40,
				30,
				20,
				10
			}
		},
		{
			jcs = {
				60,
				50,
				40,
				30,
				20,
				10
			}
		},
		{
			jcs = {
				70,
				60,
				50,
				40,
				30,
				20,
				10
			}
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
				10
			}
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
				10
			}
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
				10
			}
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
				10
			}
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
				10
			}
		}
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

	-- Contract pay changes to prevent you from gaining a lot of money and XP at same time
	-- If you want money, you stay and get additional loot- otherwise all you get is mainly XP
	self.jobs.jewelry_store.payout = { 12000, 12000, 30000, 50000, 60000, 60000, 60000 }
	self.jobs.gallery.payout = { 20000, 21000, 23000, 25000, 30000, 30000, 30000 }
	self.jobs.four_stores.payout = { 9000, 12000, 15000, 18000, 20000, 22000, 25000 }
	self.jobs.mallcrasher.payout = { 9000, 12000, 15000, 18000, 20000, 22000, 25000 }
	self.jobs.ukrainian_job.payout = { 20000, 21000, 23000, 25000, 30000, 30000, 30000 }
	self.jobs.nightclub.payout = { 20000, 22500, 40000, 60000, 80000, 80000, 80000 }
	self.jobs.branchbank.payout = { 10000, 15000, 40000, 60000, 75000, 75000, 75000 }
	self.jobs.branchbank_prof.payout = { 10000, 15000, 40000, 60000, 75000, 75000, 75000 }
	self.jobs.branchbank_deposit.payout = { 10000, 15000, 40000, 60000, 75000, 75000, 75000 }
	self.jobs.branchbank_cash.payout = { 10000, 15000, 40000, 60000, 75000, 75000, 75000 }
	self.jobs.branchbank_gold.payout = { 10000, 15000, 40000, 60000, 75000, 75000, 75000 }
	self.jobs.branchbank_gold_prof.payout = { 10000, 15000, 40000, 60000, 75000, 75000, 75000 }
	self.jobs.election_day.payout = { 20000, 25000, 40000, 60000, 90000, 90000, 90000 }
	self.jobs.rat.payout = { 90000, 135000, 150000, 175000, 200000, 380000, 380000 }
	self.jobs.alex.payout = { 90000, 135000, 150000, 175000, 200000, 380000, 380000 }
	self.jobs.family.payout = { 20000, 21000, 23000, 25000, 30000, 30000, 30000 }
	self.jobs.big.payout = { 120000, 135000, 180000, 310000, 380000, 380000, 380000 }
	self.jobs.roberts.payout = { 50000, 25000, 50000, 70000, 95000, 100000, 100000 }
	self.jobs.hox.payout = { 250000, 500000, 750000, 1000000, 1250000, 1250000, 1250000 }
	self.jobs.hox_3.payout = { 8000, 16000, 40000, 80000, 100000, 100000, 100000 }
	self.jobs.crojob1.payout = { 8000, 16000, 40000, 80000, 100000, 100000, 100000 }
	self.jobs.crojob_wrapper.payout = { 8000, 16000, 40000, 80000, 100000, 100000, 100000 }
	self.jobs.shoutout_raid.payout = { 26000, 37000, 81000, 101000, 202000, 202000, 202000 }
	self.jobs.arena.payout = { 15000, 30000, 45000, 60000, 75000, 90000, 105000 }
	self.jobs.kenaz.payout = { 200000, 40000, 45000, 60000, 75000, 90000, 105000 }
	self.jobs.jolly.payout = { 2500, 5000, 7500, 10000, 10000, 20000, 30000 }
	self.jobs.red2.payout = { 100000, 15000, 20000, 25000, 30000, 35000, 40000 }
	self.jobs.dinner.payout = { 10000, 15000, 20000, 25000, 30000, 35000, 40000 }
	self.jobs.pbr.payout = { 25000, 30000, 45000, 50000, 55000, 60000, 65000 }
	self.jobs.pbr2.payout = { 115000, 230000, 575000, 1150000, 1500000, 1500000, 1500000 }
	self.jobs.pal.payout = { 10000, 15000, 20000, 25000, 30000, 35000, 40000 }
	self.jobs.cane.payout = { 26000, 37000, 81000, 101000, 202000, 202000, 202000 }
	self.jobs.nail.payout = { 6000, 12000, 30000, 50000, 60000, 60000, 60000 }
	self.jobs.peta.payout = { 25000, 50000, 75000, 100000, 100000, 100000, 100000 }
	self.jobs.man.payout = { 500000, 250000, 500000, 750000, 1000000, 1500000, 250000 }
	self.jobs.dark.payout = { 10000, 20000, 30000, 40000, 80000, 80000, 80000 }
	self.jobs.mad.payout = { 20000, 25000, 50000, 70000, 95000, 100000, 100000 }
	self.jobs.mus.payout = { 20000, 25000, 50000, 70000, 95000, 100000, 100000 }
	self.jobs.mia.payout = { 20000, 25000, 50000, 70000, 95000, 100000, 100000 }
	self.jobs.born.payout = { 26000, 37000, 81000, 101000, 202000, 202000, 202000 } -- finished here
	self.jobs.friend.payout = { 180000, 270000, 360000, 620000, 380000, 380000, 380000 }
	self.jobs.moon.payout = { 20000, 21000, 23000, 25000, 30000, 30000, 30000 }
	self.jobs.spa.payout = { 124000, 248000, 620000, 1150000, 1600000, 1600000, 1600000 }
	self.jobs.fish.payout = { 70000, 95000, 125000, 200000, 250000, 250000, 250000 }
	self.jobs.flat.payout = { 118000, 236000, 826000, 1180000, 1357000, 1534000, 1652000 }
	self.jobs.help.payout = { 6000, 12000, 30000, 50000, 60000, 60000, 60000 }
	self.jobs.run.payout = { 110000, 220000, 550000, 1100000, 1265000, 1430000, 1540000 }
	self.jobs.glace.payout = { 115000, 225000, 555000, 1150000, 1266000, 1435000, 1545000 }
	self.jobs.haunted.payout = { 20000, 30000, 40000, 70000, 80000, 90000, 100000 }
	self.jobs.dah.payout = { 100000, 15000, 20000, 25000, 30000, 35000, 40000 }
	self.jobs.rvd.payout = { 20000, 30000, 40000, 70000, 80000, 80000, 80000 }
	self.jobs.brb.payout = { 8000, 16000, 40000, 80000, 100000, 100000, 100000 }
	self.jobs.hvh.payout = { 20000, 30000, 40000, 70000, 80000, 80000, 80000 }
	self.jobs.wwh.payout = { 60000, 150000, 300000, 600000, 750000, 750000, 750000 }
	self.jobs.tag.payout = { 20000, 30000, 40000, 70000, 80000, 80000, 80000 }
	self.jobs.des.payout = { 50000, 125000, 250000, 550000, 700000, 700000, 700000 }
	self.jobs.vit.payout = { 118000, 236000, 826000, 1180000, 1357000, 1534000, 1652000 }
	self.jobs.bph.payout = { 60000, 150000, 300000, 600000, 750000, 750000, 750000 }
	self.jobs.mex.payout = { 50000, 125000, 250000, 550000, 700000, 700000, 700000 }
	self.jobs.mex_cooking.payout = { 50000, 125000, 250000, 550000, 700000, 700000, 700000 }
	self.jobs.bex.payout = { 50000, 125000, 250000, 550000, 700000, 700000, 700000 }
	self.jobs.pex.payout = { 50000, 125000, 250000, 550000, 700000, 700000, 700000 }
	self.jobs.fex.payout = { 50000, 125000, 250000, 550000, 700000, 700000, 700000 }
	self.jobs.chas.payout = { 50000, 125000, 250000, 550000, 700000, 700000, 700000 }
	self.jobs.sand.payout = { 50000, 125000, 250000, 550000, 700000, 700000, 700000 }
	self.jobs.chca.payout = { 50000, 125000, 250000, 550000, 700000, 700000, 700000 }
	self.jobs.pent.payout = { 50000, 125000, 250000, 550000, 700000, 700000, 700000 }
	self.jobs.ranc.payout = { 50000, 125000, 250000, 550000, 700000, 700000, 700000 }
	self.jobs.trai.payout = { 50000, 125000, 250000, 550000, 700000, 700000, 700000 }
	self.jobs.corp.payout = { 50000, 125000, 250000, 550000, 700000, 700000, 700000 }
	self.jobs.deep.payout = { 50000, 125000, 250000, 550000, 700000, 700000, 700000 }
	self.jobs.boss.payout = { 50000, 125000, 250000, 550000, 700000, 700000, 700000 }
	self.jobs.nmh.payout = { 60000, 74000, 125000, 185000, 260000, 260000, 260000 }
	self.jobs.sah.payout = { 100000, 0, 0, 0, 0, 0, 0 }

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
