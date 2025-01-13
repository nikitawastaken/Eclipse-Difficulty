-- Fix flash grenade timer
Hooks:PreHook(QuickFlashGrenade, "init", "sh_init", function()
	QuickFlashGrenade.States[3][2] = QuickFlashGrenade.States[3][2] or tweak_data.group_ai.flash_grenade.timer
end)
