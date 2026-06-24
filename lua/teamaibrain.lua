-- Adjust slotmask to allow attacking turrets
Hooks:PostHook(TeamAIBrain, "_reset_logic_data", "eclipse__reset_logic_data", function (self)
	self._logic_data.is_team_ai = true
	self._logic_data.secure_bag_data = {}
	self._logic_data.enemy_slotmask = self._logic_data.enemy_slotmask + World:make_slot_mask(25)
end)
