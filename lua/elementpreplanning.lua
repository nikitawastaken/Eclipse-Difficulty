ElementPrePlanning.police_delay_types = table.list_to_set({
	"delay_police_10",
	"delay_police_10_no_pos",
	"delay_police_20",
	"delay_police_30",
	"delay_police_30_no_pos",
	"delay_police_60",
})

Hooks:PostHook(ElementPrePlanning, "on_executed", "eclipse_on_executed", function(self)
	local values = self._values

	if not values.allowed_types then
		return
	end

	-- Create a list of preplanning asset types and look for Silent Alarms
	local allowed_types = clone(self._values.allowed_types)
	for _, allowed_type in pairs(allowed_types) do
		if self.police_delay_types[allowed_type] then
			managers.groupai:state():_set_silent_alarm(true, allowed_type)
		end
	end

	Utils.PrintTable(allowed_types)
end)
