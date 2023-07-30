
function GroupAIManager:set_state(name)
	if name == "empty" then
		self._state = GroupAIStateEmpty:new()
	elseif name == "street" then
		self._state = GroupAIStateStreet:new()
	elseif name == "besiege" or name == "airport" or name == "zombie_apocalypse" then
		local level_tweak = managers.job:current_level_data()
		self._state = GroupAIStateBesiege:new(level_tweak and level_tweak.group_ai_state or "besiege")
    elseif name == "ponr" then
        self._state = GroupAIStatePonr:new("ponr", self._state)
	else
		Application:error("[GroupAIManager:set_state] inexistent state name", name)

		return
	end

	self._state_name = name
end

function GroupAIManager:state_names()
	return {
		"empty",
		"airport",
		"besiege",
		"street",
		"zombie_apocalypse",
        "ponr",
	}
end