--A big ass dump for new mutators

--Customazible damage grace--
MutatorGraceTroll = MutatorGraceTroll or class(BaseMutator)
MutatorGraceTroll._type = "MutatorGraceTroll"
MutatorGraceTroll.name_id = "mutator_gracetroll"
MutatorGraceTroll.desc_id = "mutator_gracetroll_desc"
MutatorGraceTroll.has_options = true
MutatorGraceTroll.categories = { "gameplay" }
MutatorGraceTroll.icon_coords = {
	1, --2
	1,
}

function MutatorGraceTroll:register_values(mutator_manager)
	self:register_value("gracetroll", 0.15, "ft")
	self:register_value("gracetroll_disablearmor", false, "ftda")
	self:register_value("gracetroll_reducediframedamage", false, "ftrifd")
end

function MutatorGraceTroll:modify_value(id, value)
	if id == "PlayerDamage:DisableArmorGrace" and self:get_grace_troll_disable_armor_grace() then
		return true
	elseif id == "PlayerDamage:VanillaGracePiercing" and self:get_grace_troll_reduced_iframe_damage() then
		return true
	end

	return value
end

function MutatorGraceTroll:setup(data)
	-- Set mutator grace period value only if this value lower than difficulty based grace period
	local new_grace = self:get_gracetroll()
	local old_grace = tweak_data.player.damage.MIN_DAMAGE_INTERVAL
	if new_grace < old_grace then
		tweak_data.player.damage.MIN_DAMAGE_INTERVAL = new_grace
		tweak_data.character.presets.gang_member_damage.MIN_DAMAGE_INTERVAL = new_grace
	end
end

function MutatorGraceTroll:name()
	local name = MutatorGraceTroll.super.name(self)

	if self:_mutate_name("gracetroll") then
		return string.format("%s - %.2f", name, tonumber(self:value("gracetroll")))
	else
		return name
	end
end

function MutatorGraceTroll:get_gracetroll()
	return self:value("gracetroll")
end

function MutatorGraceTroll:get_grace_troll_disable_armor_grace()
	return self:value("gracetroll_disablearmor")
end

function MutatorGraceTroll:get_grace_troll_reduced_iframe_damage()
	return self:value("gracetroll_reducediframedamage")
end

function MutatorGraceTroll:_min_grace()
	return 0
end

function MutatorGraceTroll:_max_grace()
	return 0.35
end

function MutatorGraceTroll:setup_options_gui(node)
	local params = {
		name = "gracetroll_slider",
		callback = "_update_mutator_value",
		text_id = "menu_mutator_gracetroll_slider",
		update_callback = callback(self, self, "_update_gracetroll"),
	}
	local data_node = {
		show_value = true,
		step = 0.05,
		type = "CoreMenuItemSlider.ItemSlider",
		decimal_count = 2,
		min = self:_min_grace(),
		max = self:_max_grace(),
	}
	local slider = node:create_item(data_node, params)

	slider:set_value(self:get_gracetroll())
	node:add_item(slider)

	params = {
		name = "grace_troll_disable_armor_grace_toggle",
		callback = "_update_mutator_value",
		text_id = "menu_mutator_grace_troll_disable_armor_grace_toggle",
		update_callback = callback(self, self, "_toggle_grace_troll_disable_armor_grace"),
	}
	data_node = {
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "on",
			s_w = 24,
			s_h = 24,
			s_x = 24,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 24,
			s_icon = "guis/textures/menu_tickbox",
		},
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "off",
			s_w = 24,
			s_h = 24,
			s_x = 0,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 0,
			s_icon = "guis/textures/menu_tickbox",
		},
		type = "CoreMenuItemToggle.ItemToggle",
	}
	local toggle1 = node:create_item(data_node, params)

	toggle1:set_value(self:get_grace_troll_disable_armor_grace() and "on" or "off")
	node:add_item(toggle1)

	params = {
		name = "grace_troll_reduced_iframe_damage_toggle",
		callback = "_update_mutator_value",
		text_id = "menu_mutator_grace_troll_reduced_iframe_damage_toggle",
		update_callback = callback(self, self, "_toggle_grace_troll_reduced_iframe_damage"),
	}
	data_node = {
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "on",
			s_w = 24,
			s_h = 24,
			s_x = 24,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 24,
			s_icon = "guis/textures/menu_tickbox",
		},
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "off",
			s_w = 24,
			s_h = 24,
			s_x = 0,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 0,
			s_icon = "guis/textures/menu_tickbox",
		},
		type = "CoreMenuItemToggle.ItemToggle",
	}
	local toggle2 = node:create_item(data_node, params)

	toggle2:set_value(self:get_grace_troll_reduced_iframe_damage() and "on" or "off")
	node:add_item(toggle2)

	self._node = node

	return new_item
end

function MutatorGraceTroll:_update_gracetroll(item)
	self:set_value("gracetroll", item:value())
end

function MutatorGraceTroll:_toggle_grace_troll_disable_armor_grace(item)
	self:set_value("gracetroll_disablearmor", item:value() == "on")
end

function MutatorGraceTroll:_toggle_grace_troll_reduced_iframe_damage(item)
	self:set_value("gracetroll_reducediframedamage", item:value() == "on")
end

function MutatorGraceTroll:reset_to_default()
	self:clear_values()

	if self._node then
		local slider = self._node:item("gracetroll_slider")

		if slider then
			slider:set_value(self:get_gracetroll())
		end

		local toggle1 = self._node:item("grace_troll_disable_armor_grace_toggle")

		if toggle1 then
			toggle1:set_value(self:get_grace_troll_disable_armor_grace())
		end

		local toggle2 = self._node:item("grace_troll_reduced_iframe_damage_toggle")

		if toggle2 then
			toggle2:set_value(self:get_grace_troll_reduced_iframe_damage())
		end
	end
end

function MutatorGraceTroll:options_fill()
	return self:_get_percentage_fill(self:_min_grace(), self:_max_grace(), self:get_gracetroll())
end

--Medic Dozers--
MutatorMedicDozers = MutatorMedicDozers or class(BaseMutator)
MutatorMedicDozers._type = "MutatorMedicDozers"
MutatorMedicDozers.name_id = "mutator_medicdozers"
MutatorMedicDozers.desc_id = "mutator_medicdozers_desc"
MutatorMedicDozers.has_options = true
MutatorMedicDozers.categories = { "enemies" }
MutatorMedicDozers.icon_coords = {
	2,
	3,
}

function MutatorMedicDozers:register_values(mutator_manager)
	self:register_value("medic_dozer_replace_elites", false, "mdre")
end

function MutatorMedicDozers:get_medic_dozer_replace_elites()
	return self:value("medic_dozer_replace_elites")
end

function MutatorMedicDozers:setup(data)
	local dozer_type = tweak_data.group_ai.unit_categories.bulldozer.unit_types
	local dozer_type_1 = tweak_data.group_ai.unit_categories.bulldozer_1.unit_types
	local dozer_type_2 = tweak_data.group_ai.unit_categories.bulldozer_2.unit_types

	local america_medic_dozer = Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_medic_classic/ene_bulldozer_medic_classic")
	local russia_medic_dozer = Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_medic/ene_akan_fbi_tank_medic")
	local zombie_medic_dozer = Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_medic_hvh/ene_bulldozer_medic_hvh")
	local federales_medic_dozer = Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_medic_policia_federale/ene_swat_dozer_medic_policia_federale")
	local murkywater_medic_dozer = Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_medic/ene_murkywater_bulldozer_medic")

	table.insert(dozer_type.america, america_medic_dozer)
	table.insert(dozer_type.russia, russia_medic_dozer)
	table.insert(dozer_type.zombie, zombie_medic_dozer)
	table.insert(dozer_type.federales, federales_medic_dozer)
	table.insert(dozer_type.murkywater, murkywater_medic_dozer)

	table.insert(dozer_type_1.america, america_medic_dozer)
	table.insert(dozer_type_1.russia, russia_medic_dozer)
	table.insert(dozer_type_1.zombie, zombie_medic_dozer)
	table.insert(dozer_type_1.federales, federales_medic_dozer)
	table.insert(dozer_type_1.murkywater, murkywater_medic_dozer)

	table.insert(dozer_type_2.america, america_medic_dozer)
	table.insert(dozer_type_2.russia, russia_medic_dozer)
	table.insert(dozer_type_2.zombie, zombie_medic_dozer)
	table.insert(dozer_type_2.federales, federales_medic_dozer)
	table.insert(dozer_type_2.murkywater, murkywater_medic_dozer)

	-- Toggle for replacing elite dozers
	if self:get_medic_dozer_replace_elites() then
		local dozer_type_elite = tweak_data.group_ai.unit_categories.elite_bulldozer.unit_types
		local dozer_type_elite_1 = tweak_data.group_ai.unit_categories.elite_bulldozer_1.unit_types
		local dozer_type_elite_2 = tweak_data.group_ai.unit_categories.elite_bulldozer_2.unit_types

		table.insert(dozer_type_elite.america, america_medic_dozer)
		table.insert(dozer_type_elite.russia, russia_medic_dozer)
		table.insert(dozer_type_elite.zombie, zombie_medic_dozer)
		table.insert(dozer_type_elite.federales, federales_medic_dozer)
		table.insert(dozer_type_elite.murkywater, murkywater_medic_dozer)

		table.insert(dozer_type_elite_1.america, america_medic_dozer)
		table.insert(dozer_type_elite_1.russia, russia_medic_dozer)
		table.insert(dozer_type_elite_1.zombie, zombie_medic_dozer)
		table.insert(dozer_type_elite_1.federales, federales_medic_dozer)
		table.insert(dozer_type_elite_1.murkywater, murkywater_medic_dozer)

		table.insert(dozer_type_elite_2.america, america_medic_dozer)
		table.insert(dozer_type_elite_2.russia, russia_medic_dozer)
		table.insert(dozer_type_elite_2.zombie, zombie_medic_dozer)
		table.insert(dozer_type_elite_2.federales, federales_medic_dozer)
		table.insert(dozer_type_elite_2.murkywater, murkywater_medic_dozer)
	end
end

function MutatorMedicDozers:setup_options_gui(node)
	local params = {
		name = "medic_dozer_replace_elites_toggle",
		callback = "_update_mutator_value",
		text_id = "menu_mutator_medic_dozer_replace_elites_toggle",
		update_callback = callback(self, self, "_toggle_medic_dozer_replace_elites"),
	}
	local data_node = {
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "on",
			s_w = 24,
			s_h = 24,
			s_x = 24,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 24,
			s_icon = "guis/textures/menu_tickbox",
		},
		{
			w = 24,
			y = 0,
			h = 24,
			s_y = 24,
			value = "off",
			s_w = 24,
			s_h = 24,
			s_x = 0,
			_meta = "option",
			icon = "guis/textures/menu_tickbox",
			x = 0,
			s_icon = "guis/textures/menu_tickbox",
		},
		type = "CoreMenuItemToggle.ItemToggle",
	}
	local new_item = node:create_item(data_node, params)

	new_item:set_value(self:get_medic_dozer_replace_elites() and "on" or "off")
	node:add_item(new_item)

	self._node = node

	return new_item
end

function MutatorMedicDozers:_toggle_medic_dozer_replace_elites(item)
	self:set_value("medic_dozer_replace_elites", item:value() == "on")
end

function MutatorMedicDozers:reset_to_default()
	self:clear_values()

	if self._node then
		local toggle = self._node:item("medic_dozer_replace_elites_toggle")

		if toggle then
			toggle:set_value(self:get_medic_dozer_replace_elites() and "on" or "off")
		end
	end
end

function MutatorMedicDozers:options_fill()
	if self:get_medic_dozer_replace_elites() then
		return 1
	else
		return 0
	end
end

-- Max difficulty --
MutatorMaxDiff = MutatorMaxDiff or class(BaseMutator)
MutatorMaxDiff._type = "MutatorMaxDiff"
MutatorMaxDiff.name_id = "mutator_maxdiff"
MutatorMaxDiff.desc_id = "mutator_maxdiff_desc"
MutatorMaxDiff.categories = { "gameplay" }

MutatorMaxDiff.icon_coords = {
	3,
	2,
}

function MutatorMaxDiff:modify_value(id, value)
	if id == "GroupAIStateBase:MaxDiff" then
		return true
	end
	return value
end

-- No outlines --
MutatorNoOutlines = MutatorNoOutlines or class(BaseMutator)
MutatorNoOutlines._type = "MutatorNoOutlines"
MutatorNoOutlines.name_id = "mutator_nooutlines"
MutatorNoOutlines.desc_id = "mutator_nooutlines_desc"
MutatorNoOutlines.categories = { "gameplay" }

MutatorNoOutlines.icon_coords = {
	5,
	1,
}

function MutatorNoOutlines:modify_value(id, value)
	if id == "CoreEnvironmentControllerManager:NoOutlines" or id == "HUDManager:NoOutlines" or id == "ElementWaypoint:NoOutlines" then
		return true
	end
	return value
end

-- One Down --
MutatorOneDown = MutatorOneDown or class(BaseMutator)
MutatorOneDown._type = "MutatorOneDown"
MutatorOneDown.name_id = "mutator_onedown"
MutatorOneDown.desc_id = "mutator_onedown_desc"
MutatorOneDown.categories = { "gameplay" }
MutatorOneDown.icon_coords = {
	4,
	1,
}

function MutatorOneDown:modify_value(id, value)
	if id == "PlayerDamage:OneDown" or id == "HuskPlayerDamage:OneDown" then
		return true
	end
	return value
end

-- Instant flashbang detonation
MutatorBoFlashbang = MutatorBoFlashbang or class(BaseMutator)
MutatorBoFlashbang._type = "MutatorBoFlashbang"
MutatorBoFlashbang.name_id = "mutator_bo_flashbang"
MutatorBoFlashbang.desc_id = "mutator_bo_flashbang_desc"
MutatorBoFlashbang.categories = { "gameplay" }
MutatorBoFlashbang.icon_coords = {
	6,
	1,
}

function MutatorBoFlashbang:setup(data)
	tweak_data.group_ai.flash_grenade.timer = 0
end
