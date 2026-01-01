Hooks:PostHook(GameSetup, "load_packages", "eclipse_load_packages", function(self)
	local level_id = Eclipse.utils.level_id()
	if not level_id then
		return
	end

	local custom_packages = {
		["packages/security_mcmansion"] = {
			["watchdogs_1"] = true,
			["watchdogs_1_night"] = true,
			["watchdogs_2"] = true,
			["watchdogs_2_day"] = true,
			["firestarter_1"] = true,
			["firestarter_2"] = true,
			["firestarter_3"] = true,
			["alex_3"] = true,
			["hox_2"] = true,
			-- ["hox_3"] = true, -- They're already loaded here
			["man"] = true,
		},
		["packages/female_bikers"] = {
			["welcome_to_the_jungle_1"] = true,
			["welcome_to_the_jungle_1_night"] = true,
			["cane"] = true,
			["mex"] = true,
		},
		["packages/murkywater"] = {
			--		["brb"] = true,
		},
		["packages/us_army"] = {
			["arm_for"] = true,
			["roberts"] = true,
			["crojob2"] = true,
			["crojob3"] = true,
			["jolly"] = true,
			["peta2"] = true,
			["trai"] = true,
		},
		["packages/gensec_tactical_security"] = {
			["dah"] = true,
			["arena"] = true,
		},
		["packages/lapd"] = {
			-- ["rvd1"] = true, -- They're already loaded here
			-- ["rvd2"] = true, -- They're already loaded here
			["kenaz"] = true,
			["jolly"] = true,
			["pal"] = true,
			["friend"] = true,
		},
		["packages/coast_guard"] = {
			["chca"] = true,
			["deep"] = true,
		},
		["packages/texas_rangers"] = {
			["dinner"] = true,
			-- ["ranc"] = true, -- They're already loaded here
			["trai"] = true,
			-- ["corp"] = true, -- They're already loaded here
		},
		["packages/security_deep"] = {
			["ranc"] = true,
			["corp"] = true,
			-- ["deep"] = true, -- They're already loaded here
		},
	}

	for package_id, package_levels in pairs(custom_packages) do
		if package_levels[level_id] and not PackageManager:loaded(package_id) then
			Eclipse:log_console(string.format('Loading custom package "%s"...', package_id))
			table.insert(self._loaded_diff_packages, package_id)
			PackageManager:load(package_id)
		end
	end
end)
