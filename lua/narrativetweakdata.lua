Hooks:PostHook(NarrativeTweakData, "init", "eclipse_qol_fixes", function(self)
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

	--Halloween heists gets Stonecold's (PDTH Alpha) menu movie (mysterious)
	self.jobs.haunted.crimenet_videos = { "menu" }
	self.jobs.nail.crimenet_videos = { "menu" }
	self.jobs.help.crimenet_videos = { "menu" }
	self.jobs.hvh.crimenet_videos = { "menu" }

	--fix Ukrainian Prisoner using Vlad's codex for some reason
	self.jobs.sand.crimenet_videos = { "codex/jiufeng1" }
end)
