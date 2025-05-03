core:module("CoreSequenceManager")

function MaterialConfigElement.load(unit, data)
	if not unit:base() or not unit:base()._block_seq_manager_material_load then
		managers.dyn_resource:change_material_config(data.material, unit)
	end
end
