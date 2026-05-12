Hooks:PostHook(InfamyTweakData, "init", "eclipse_init", function(self)
	self.items.infamy_root.upgrades.skilltree.multiplier = 1
	
	local function digest(value)
		return Application:digest_value(value, true)
	end

	local cost_old = digest(100000000)

	self.offshore_cost = {
		cost_old,
		cost_old,
		cost_old,
		cost_old,
		cost_old,
		cost_old
	}
end)
