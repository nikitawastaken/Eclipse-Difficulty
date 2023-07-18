-- remove vr dmg resistance
Hooks:PostHook(TweakDataVR, "init", "eclipse_init", function(self)
	self.long_range_damage_reduction = { 0, 0 }
end)
