-- Fix endless Cloaker beatdown on team AI
Hooks:PostHook(TeamAIMovement, "on_SPOOCed", "sh_on_SPOOCed", function()
	return true
end)
