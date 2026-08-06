-- Since vanilla doesn't keep track of the original IDs...
function CoreWorldInstanceManager:convert_id(instance_name, id)
	local instance_data = self:get_instance_data_by_name(instance_name)
	if not instance_data or not instance_data.start_index then
		return
	end

	local continent_data = managers.worlddefinition._continents[instance_data.continent]
	if not continent_data or not continent_data.base_id then
		return
	end

	local converted = continent_data.base_id + self:_get_mod_id(id) + self:start_offset_index() + instance_data.start_index
	return converted
end

if Network:is_client() or Global.editor_mode then
	return
end

local instance_script_patches = Eclipse:instance_script_patches()

if not instance_script_patches then
	return
end

Hooks:PostHook(CoreWorldInstanceManager, "_get_instance_mission_data", "eclipse_init", function(self, path)
	local func = instance_script_patches[path]

	if func then
		local result = Hooks:GetReturn()

		func(result)

		return result
	end
end)
