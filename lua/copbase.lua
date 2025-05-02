ContourSwapBase = class()
ContourSwapBase._material_translation_map = {}

local paths = table.list_to_set({
	"units/payday2/characters/ene_acc_head/vars/ene_acc_head_var1",
	"units/payday2/characters/ene_acc_head/vars/ene_acc_head_var2",
	"units/payday2/characters/ene_cop_1/vars/ene_security_1",
	"units/payday2/characters/ene_cop_1/vars/ene_security_4",
	"units/payday2/characters/ene_cop_1/vars/ene_fbi_1",
	"units/payday2/characters/ene_cop_1/vars/ene_prisonguard_male_1",
	"units/payday2/characters/ene_cop_1/vars/ene_male_marshal_marksman_1_merc",
	"units/payday2/characters/ene_cop_1/vars/ene_policia_01",
	"units/payday2/characters/ene_cop_1/vars/ene_male_marshal_marksman_1_merc",
	"units/payday2/characters/ene_secret_service_1/vars/ene_secret_service_1_casino",
	"units/payday2/characters/ene_murkywater_1/vars/ene_hoxton_breakout_guard_1",
	"units/pd2_dlc_chas/characters/ene_male_chas_police_01/vars/ene_male_ranc_ranger_01",
	"units/payday2/characters/ene_swat_1/vars/ene_fbi_swat_1",
	"units/payday2/characters/ene_swat_1/vars/ene_city_swat_1",
	"units/payday2/characters/ene_bulldozer_1/vars/ene_bulldozer_2",
	"units/payday2/characters/ene_bulldozer_1/vars/ene_bulldozer_3",
	"units/payday2/characters/ene_bulldozer_1/vars/ene_bulldozer_4",
	"units/payday2/characters/ene_bulldozer_1/vars/ene_bulldozer_minigun_classic",
	"units/payday2/characters/ene_bulldozer_1/vars/ene_bulldozer_medic_classic",
	"units/pd2_dlc_usm1/characters/ene_male_marshal_marksman_1/vars/ene_male_marshal_marksman_1_merc",
})

for path in pairs(paths) do
	local normal_id = Idstring(path)
	local contour_id = Idstring(path .. "_contour")

	ContourSwapBase._material_translation_map[tostring(normal_id:key())] = contour_id
	ContourSwapBase._material_translation_map[tostring(contour_id:key())] = normal_id
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

-- Handle material swaps
for path in pairs(paths) do
	local normal_id = Idstring(path)
	local contour_id = Idstring(path .. "_contour")

	CopBase._material_translation_map[tostring(normal_id:key())] = contour_id
	CopBase._material_translation_map[tostring(contour_id:key())] = normal_id
end

local unit_ids = Idstring("unit")

Hooks:PostHook(CopBase, "init", "eclipse_init", function(self)
	-- Dynamically load throwable if we have one
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

function CopBase:save(save_data)
	local my_save_data = {}

	if self._unit:interaction() and (self._unit:interaction().tweak_data == "hostage_trade" or self._unit:interaction().tweak_data == "hostage_trade_resources") then
		my_save_data.is_hostage_trade = true
	elseif self._unit:interaction() and self._unit:interaction().tweak_data == "hostage_convert" then
		my_save_data.is_hostage_convert = true
	end

	local buffs = {}

	for name, buff_list in pairs(self._buffs) do
		buffs[name] = {
			_total = buff_list._total,
		}
	end

	if next(buffs) then
		my_save_data.buffs = buffs
	end

	if self._tweak_table ~= self._original_tweak_table then
		my_save_data.tweak_name_swap = self._tweak_table
	end

	if self._stats_name ~= self._original_stats_name then
		my_save_data.stats_name_swap = self._stats_name
	end

	if next(my_save_data) then
		save_data.base = my_save_data
	end
end

local unit_sequence_mapping_clean = Eclipse:require("unit_sequences")
local unit_sequence_mapping = {}

-- Handle unit sequences for gear and such
for name, sequence in pairs(unit_sequence_mapping_clean) do
	local normal_id = Idstring(name):key()
	local husk_id = Idstring(name .. "_husk"):key()

	unit_sequence_mapping[normal_id] = sequence
	unit_sequence_mapping[husk_id] = sequence
end

CopBase.unit_sequence_mapping = deep_clone(unit_sequence_mapping)
CopBase.unit_weapon_mapping = Eclipse:require("unit_weapons")

function CopBase:_run_unit_sequences()
	local name = self._unit:name():key()

	local unit_sequence = self.unit_sequence_mapping[name]

	-- Run the initial sequence to enable pouches, helmets etc.
	if unit_sequence then
		local sequence_name = unit_sequence and unit_sequence.name
		local sequence_head = unit_sequence and unit_sequence.head

		if self._unit:damage() then
			if self._unit:damage():has_sequence(sequence_name) then
				self._unit:damage():run_sequence_simple(sequence_name)
			end
		end

		local light_sequence = "enable_light"

		-- Enable a flashlight if the level has flashlights enabled
		if managers.game_play_central and managers.game_play_central:flashlights_on() then
			if self._unit:damage():has_sequence(light_sequence) then
				self._unit:damage():run_sequence_simple(light_sequence)
			end
		end

		local spawn_manager_ext = self._unit:spawn_manager()

		local damage_ext = self._unit:character_damage()
		local head = damage_ext._head

		local head_material = sequence_head and sequence_head.material
		local head_sequences = sequence_head and sequence_head.run_sequence

		-- If the unit had a head defined in its .unit file, spawn and parent it
		if spawn_manager_ext then
			if head then
				managers.dyn_resource:load(Idstring("unit"), Idstring(head), managers.dyn_resource.DYN_RESOURCES_PACKAGE, nil)

				spawn_manager_ext:spawn_and_link_unit("_char_joint_names", "cop_head", head)

				self._head_unit = spawn_manager_ext:get_unit("cop_head")
			end
		end
		-- If the head's sequence manager supports the parent unit, run its initial sequence
		if alive(self._head_unit) then
			self._head_unit:set_enabled(self._unit:enabled())

			if self._head_unit:damage() then
				if type(head_material) == "table" then
					head_material = table.random(head_material)
				end

				local head_material_name = "head_material_var" .. head_material

				if self._head_unit:damage():has_sequence(head_material_name) then
					self._head_unit:damage():run_sequence_simple(head_material_name)
				end

				for _, sequence in pairs(head_sequences) do
					if self._head_unit:damage():has_sequence(sequence) then
						self._head_unit:damage():run_sequence_simple(sequence)
					end
				end
			end
		end
	end
end

-- Check for weapon changes and run unti sequences
Hooks:PreHook(CopBase, "post_init", "eclipse_post_init", function(self)
	self:_run_unit_sequences()

	-- Always glow cloakers (like in PDTH)
	if self._tweak_table == "spooc" then
		self._unit:damage():run_sequence_simple("turn_on_spook_lights")
	end

	if Network:is_client() then
		return
	end

	local unit_weapon = self.unit_weapon_mapping[self._unit:name():key()]
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
