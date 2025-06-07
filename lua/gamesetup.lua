local level_id = Eclipse.utils.level_id()

Hooks:PostHook(GameSetup, "load_packages", "eclipse_load_packages", function(self)
	local fbi_heists = {
		["watchdogs_1"] = true,
		["watchdogs_1_night"] = true,
		["watchdogs_2"] = true,
		["watchdogs_2_day"] = true,
		["firestarter_1"] = true,
		["firestarter_2"] = true,
		["firestarter_3"] = true,
		["alex_3"] = true,
		["hox_2"] = true,
		["hox_3"] = true,
		["man"] = true,
	}
	local female_bikers = {
		["welcome_to_the_jungle_1"] = true,
		["welcome_to_the_jungle_1_night"] = true,
		["cane"] = true,
		["mex"] = true,
	}
	local us_army = {
		["arm_for"] = true,
		["roberts"] = true,
		["crojob2"] = true,
		["crojob3"] = true,
		["jolly"] = true,
		["peta2"] = true,
		["trai"] = true,
	}

	local lapd = {
		--["rvd1"] = true, -- They're already loaded here
		--["rvd2"] = true,
		["kenaz"] = true,
		["jolly"] = true,
		["pal"] = true,
		["friend"] = true,
	}

	local coast_guard = {
		["chca"] = true,
		["deep"] = true,
	}

	local texas_rangers = {
		--["ranc"] = true, -- They're already loaded here
		["trai"] = true,
		--["corp"] = true,
	}

	local security_deep = {
		["corp"] = true,
		--["deep"] = true,
	}

	if level_id then
		if fbi_heists[level_id] and not PackageManager:loaded("packages/security_mcmansion") then
			Eclipse:log_console("Loading FBI security package...")
			table.insert(self._loaded_diff_packages, "packages/security_mcmansion")
			PackageManager:load("packages/security_mcmansion")
		end

		if female_bikers[level_id] and not PackageManager:loaded("packages/female_bikers") then
			Eclipse:log_console("Loading female biker package...")
			table.insert(self._loaded_diff_packages, "packages/female_bikers")
			PackageManager:load("packages/female_bikers")
		end

		if us_army[level_id] and not PackageManager:loaded("packages/us_army") then
			Eclipse:log_console("Loading US army package...")
			table.insert(self._loaded_diff_packages, "packages/us_army")
			PackageManager:load("packages/us_army")
		end

		if lapd[level_id] and not PackageManager:loaded("packages/lapd") then
			Eclipse:log_console("Loading LAPD package...")
			table.insert(self._loaded_diff_packages, "packages/lapd")
			PackageManager:load("packages/lapd")
		end

		if coast_guard[level_id] and not PackageManager:loaded("packages/coast_guard") then
			Eclipse:log_console("Loading Coast Guard package...")
			table.insert(self._loaded_diff_packages, "packages/coast_guard")
			PackageManager:load("packages/coast_guard")
		end

		if texas_rangers[level_id] and not PackageManager:loaded("packages/texas_rangers") then
			Eclipse:log_console("Loading Texas Rangers package...")
			table.insert(self._loaded_diff_packages, "packages/texas_rangers")
			PackageManager:load("packages/texas_rangers")
		end

		if security_deep[level_id] and not PackageManager:loaded("packages/security_deep") then
			Eclipse:log_console("Loading Bellmead Security package...")
			table.insert(self._loaded_diff_packages, "packages/security_deep")
			PackageManager:load("packages/security_deep")
		end
	end
end)
