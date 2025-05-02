local level_id = Eclipse.utils.level_id()

Drill.forbid_sabotage_SO_by_unit = {
	[("units/payday2/equipment/gen_interactable_lance_huge/gen_interactable_lance_huge"):key()] = true, -- The Beast
	[("units/payday2/equipment/gen_interactable_lance_large/gen_interactable_lance_large"):key()] = level_id == "red2" or nil, -- Ordinary thermal lance
}

Hooks:PostHook(Drill, "init", "eclipse_init", function(self, unit)
	self._sabotage_SO_forbidden = self.forbid_sabotage_SO_by_unit[unit:name():key()] or nil
end)

local _register_sabotage_SO_original = Drill._register_sabotage_SO
function Drill:_register_sabotage_SO(...)
	if not self._sabotage_SO_forbidden then
		return _register_sabotage_SO_original(self, ...)
	end
end
