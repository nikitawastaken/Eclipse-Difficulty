-- Nuke CC reward for Safehouse Raid completion
Hooks:PostHook(VictoryState , "init", "safehouse_init", function(self, game_state_machine, setup)
	self._safehouse_raid_rewarded = true
end)