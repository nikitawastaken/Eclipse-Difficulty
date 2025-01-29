Hooks:PostHook(GameSetup, "load_packages", "sh_load_packages", function(self)
	local level = Global.level_data and Global.level_data.level_id or ""
	local difficulty = Global.game_settings and Global.game_settings.difficulty or "normal"
	local difficulty_index = tweak_data:difficulty_to_index(difficulty)
	if difficulty_index == 6 and not PackageManager:loaded("packages/sm_wish") then
		Eclipse:log("Loading ZEAL package")
		table.insert(self._loaded_diff_packages, "packages/sm_wish")
		PackageManager:load("packages/sm_wish")
	end
end)
