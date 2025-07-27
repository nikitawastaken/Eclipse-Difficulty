--ElementDifficulty
Hooks:OverrideFunction(ElementDifficulty, "on_executed", function(...)
    ElementDifficulty.super.on_executed(...)
end)
