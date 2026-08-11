-- Rework this element to support Eclipse's diff system (based on mission script patch functions)
-- A little bloated for functionality, but this has the benefit of full, proper integration into mission scripting
-- Order of operations is `allowed_difficulty_addends` -> `paused_difficulty_addends` -> `difficulty_addends` -> `forced_difficulty`
Hooks:OverrideFunction(ElementDifficulty, "on_executed", function(self, ...)
	if not self._values.enabled then
		return
	end

	if self._values.allowed_difficulty_addends then
		for category, allowed in pairs(self._values.allowed_difficulty_addends) do
			managers.groupai:state():set_difficulty_addend_category_allowed(category, allowed)
		end
	end

	if self._values.paused_difficulty_addends then
		for category, cache_limit in pairs(self._values.paused_difficulty_addends) do
			managers.groupai:state():set_difficulty_addend_category_paused(category, cache_limit)
		end
	end

	if self._values.difficulty_addends then
		if self._values.difficulty_addends[1] then
			for _, addend in pairs(self._values.difficulty_addends) do
				managers.groupai:state():add_difficulty_addend(addend)
			end
		else
			managers.groupai:state():add_difficulty_addend(self._values.difficulty_addends)
		end
	end

	if self._values.forced_difficulty then
		managers.groupai:state():set_forced_difficulty(self._values.forced_difficulty)
	end

	ElementDifficulty.super.on_executed(self, ...)
end)
