Hooks:PostHook(GameSetup, "load_packages", "sh_load_packages", function(self)
	local difficulty = Global.game_settings and Global.game_settings.difficulty or "normal"
	local difficulty_index = tweak_data:difficulty_to_index(difficulty)
	if difficulty_index == 6 and not PackageManager:loaded("packages/sm_wish") then
		StreamHeist:log("Loading ZEAL package")
		table.insert(self._loaded_diff_packages, "packages/sm_wish")
		PackageManager:load("packages/sm_wish")
	end

	--For Elite/ZEAL shield's Terminator styled BANG BANG BANG spawn sound
	if difficulty_index == 6 and not PackageManager:loaded("soundbanks/sfx_hos") then
		PackageManager:load("soundbanks/sfx_hos")
	elseif difficulty_index ~= 6 and PackageManager:loaded("soundbanks/sfx_hos") then
		PackageManager:unload("soundbanks/sfx_hos")
	end	

end)
