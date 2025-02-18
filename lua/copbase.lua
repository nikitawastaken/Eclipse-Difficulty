-- Dynamically load throwable if we have one
local unit_ids = Idstring("unit")
Hooks:PostHook(CopBase, "init", "eclipse_init", function(self)
	local throwable = self._char_tweak.throwable
	if not throwable then
		return
	end

	local tweak_entry = tweak_data.blackmarket.projectiles[throwable]
	local unit_name = Idstring(Network:is_client() and tweak_entry.local_unit or tweak_entry.unit)
	local sprint_unit_name = tweak_entry.sprint_unit and Idstring(tweak_entry.sprint_unit)

	if not PackageManager:has(unit_ids, unit_name) then
		Eclipse:log("Loading projectile unit", throwable)
		managers.dyn_resource:load(unit_ids, unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE)
	end

	if sprint_unit_name and not PackageManager:has(unit_ids, sprint_unit_name) then
		Eclipse:log("Loading projectile sprint unit", throwable)
		managers.dyn_resource:load(unit_ids, sprint_unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE)
	end
end)

-- Check for weapon changes
CopBase.unit_weapon_mapping = Eclipse:require("unit_weapons")

if Network:is_client() then
	return
end

local unit_sequence_mapping_clean = Eclipse:require("unit_sequences")
local unit_sequence_mapping = {}

for name, sequence in pairs(unit_sequence_mapping_clean) do
	unit_sequence_mapping[Idstring(name):key()] = sequence
	unit_sequence_mapping[Idstring(name .. "_husk"):key()] = sequence
end

-- Check for weapon changes
Hooks:PreHook(CopBase, "post_init", "eclipse_post_init", function(self)
	local name = self._unit:name():key()
	
	local unit_sequence = unit_sequence_mapping[name]

	if unit_sequence then
		if self._unit:damage() then	
			if self._unit:damage():has_sequence(unit_sequence) then
				self._unit:damage():run_sequence_simple(unit_sequence)
			end
		end
		
		local spawn_manager_ext = self._unit:spawn_manager()

		local damage_ext = self._unit:character_damage()
		local head = damage_ext._head
		
		if spawn_manager_ext then	
			if head then	
				managers.dyn_resource:load(Idstring("unit"), Idstring(head), managers.dyn_resource.DYN_RESOURCES_PACKAGE, nil)
				
				spawn_manager_ext:spawn_and_link_unit("_char_joint_names", "cop_head", head)

				self._head_unit = spawn_manager_ext:get_unit("cop_head")
			end
		end
		
		if alive(self._head_unit) then		
			self._head_unit:set_enabled(self._unit:enabled())
			
			if self._head_unit:damage() and self._head_unit:damage():has_sequence(unit_sequence) then
				self._head_unit:damage():run_sequence_simple(unit_sequence)
			end
		end
	end
	
	local unit_weapon = self.unit_weapon_mapping[name]

	local mapping_type = type(unit_weapon)
	if mapping_type == "table" then
		local selector = WeightedSelector:new()
		for k, v in pairs(unit_weapon) do
			if type(k) == "number" then
				selector:add(v, 1)
			else
				selector:add(k, v)
			end
		end
		self._default_weapon_id = selector:select() or self._default_weapon_id
	elseif mapping_type == "string" then
		self._default_weapon_id = unit_weapon
	end
end)

ContourSwapBase = class()

ContourSwapBase._material_translation_map = {}

local mat_configs = {
  "units/payday2/characters/ene_acc_head/ene_acc_head",
  "units/payday2/characters/ene_acc_head/vars/ene_acc_head_var1",
  "units/payday2/characters/ene_acc_head/vars/ene_acc_head_var2",
}

for _, v in pairs(mat_configs) do
  ContourSwapBase._material_translation_map[tostring(Idstring(v):key())] = Idstring(v .. "_contour")
  ContourSwapBase._material_translation_map[tostring(Idstring(v .. "_contour"):key())] = Idstring(v)
end

ContourSwapBase.swap_material_config = CopBase.swap_material_config
ContourSwapBase.on_material_applied = CopBase.on_material_applied
ContourSwapBase.is_in_original_material = CopBase.is_in_original_material
ContourSwapBase.set_material_state = CopBase.set_material_state

function ContourSwapBase:init(unit)
    UnitBase.init(self, unit, false)

    self._unit = unit
    self._is_in_original_material = true
end
