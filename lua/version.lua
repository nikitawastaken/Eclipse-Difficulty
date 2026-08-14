Hooks:PostHook(_G, "pd2_version", "eclipse_pd2_version", function()
	return Hooks:GetReturn() .. "_eclipse_dev_v" .. Eclipse.mod_instance:GetVersion()
end)
