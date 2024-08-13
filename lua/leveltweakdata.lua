 --add packages that include missing SF/Texas beat cops
Hooks:PostHook(LevelsTweakData, "init", "sh_init", function (self)
    --SFPD
	self.chca.package = {"packages/job_chca", "packages/job_chas"}
    --Texas
    self.dinner.package = {"packages/narr_dinner", "packages/job_ranc"}
	self.trai.package = {"packages/job_trai", "packages/job_ranc"}
    self.deep.package = {"packages/job_deep", "packages/job_ranc"}
end)