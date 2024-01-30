-- remove vr dmg resistance
Hooks:PostHook(TweakDataVR, "init", "eclipse_init", function(self)
	self.long_range_damage_reduction = { 0, 0 }
end)

-- remove perk deck dash bonuses cause those just trivialize the game half the time
TweakDataVR.init_specializations = function(self, tweak_data) end

-- remove most of the skill tree dash bonuses
-- mostly cause they either feel unimpactful or are too much, like the vanilla close-by one
-- keep the sprinter one cause otherwise you get no dodge for movement if you use dashing
TweakDataVR.init_skills = function(self, tweak_data)
	self.post_warp = {
		min = 1,
		max = 5,
	}
	self.steelsight_stamina_regen = 0.02

	if _G.IS_VR then
		table.insert(tweak_data.skilltree.skills.optic_illusions[2].upgrades, "player_run_dodge_chance_vr")
	end

	local stamina_regen_macro = tostring(self.steelsight_stamina_regen * 100) .. "%"
	self.skill_descs_addons = {
		optic_illusions = {
			text_id = "menu_vr_addon_sprinter",
			macros = {
				min = self.post_warp.min,
				max = self.post_warp.max,
			},
		},
	}
end
