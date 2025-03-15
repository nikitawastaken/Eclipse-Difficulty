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
		["jolly"] = true,
		["trai"] = true,
	}

	local sfpd = {
		--["chas"] = true, -- They're already loaded here
		--["sand"] = true,
		["chca"] = true,
		--["pent"] = true,
	}
	
	if level_id then
		if fbi_heists[level_id] and not PackageManager:loaded("packages/security_mcmansion") then
			Eclipse:log("Loading FBI security package...")
			table.insert(self._loaded_diff_packages, "packages/security_mcmansion")
			PackageManager:load("packages/security_mcmansion")
		end

		if female_bikers[level_id] and not PackageManager:loaded("packages/female_bikers") then
			Eclipse:log("Loading female biker package...")
			table.insert(self._loaded_diff_packages, "packages/female_bikers")
			PackageManager:load("packages/female_bikers")
		end

		if us_army[level_id] and not PackageManager:loaded("packages/us_army") then
			Eclipse:log("Loading US army package...")
			table.insert(self._loaded_diff_packages, "packages/us_army")
			PackageManager:load("packages/us_army")
		end

		if sfpd[level_id] and not PackageManager:loaded("packages/sfpd") then
			Eclipse:log("Loading SFPD package...")
			table.insert(self._loaded_diff_packages, "packages/sfpd")
			PackageManager:load("packages/sfpd")
		end
	end
end)
