--ElementDifficulty
Hooks:OverrideFunction(ElementDifficulty, "on_executed", function(...)
	Eclipse:log_chat("Blocked element from setting diff.")

	ElementDifficulty.super.on_executed(...)
end)
