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
MutatorNoOutlines.has_options = true
MutatorNoOutlines.categories = { "gameplay" }

MutatorNoOutlines.icon_coords = {
	5,
	1,
}

function MutatorNoOutlines:register_values(mutator_manager)
	self:register_value("no_outlines_teammate_panel", false, "notp")
end

function MutatorNoOutlines:get_no_outlines_teammate_panel()
	return self:value("no_outlines_teammate_panel")
end

function MutatorNoOutlines:modify_value(id, value)
	if id == "CoreEnvironmentControllerManager:NoOutlines" or id == "HUDManager:NoOutlines" or id == "ElementWaypoint:NoOutlines" then
		return true
	end
	if id == "HUDTeammate:NoOutlines" and self:get_no_outlines_teammate_panel() then
		return true
	end
	return value
end

function MutatorNoOutlines:setup_options_gui(node)
	local params = {
		name = "no_outlines_teammate_panel_toggle",
		callback = "_update_mutator_value",
		text_id = "menu_mutator_no_outlines_teammate_panel_toggle",
		update_callback = callback(self, self, "_toggle_no_outlines_teammate_panel"),
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

	new_item:set_value(self:get_no_outlines_teammate_panel() and "on" or "off")
	node:add_item(new_item)

	self._node = node

	return new_item
end

function MutatorNoOutlines:_toggle_no_outlines_teammate_panel(item)
	self:set_value("no_outlines_teammate_panel", item:value() == "on")
end

function MutatorNoOutlines:reset_to_default()
	self:clear_values()

	if self._node then
		local toggle = self._node:item("no_outlines_teammate_panel_toggle")

		if toggle then
			toggle:set_value(self:get_no_outlines_teammate_panel() and "on" or "off")
		end
	end
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

-- Tear Gas Modifiers
MutatorTearGas = MutatorTearGas or class(BaseMutator)
MutatorTearGas._type = "MutatorTearGas"
MutatorTearGas.name_id = "mutator_tear_gas"
MutatorTearGas.desc_id = "mutator_tear_gas_desc"
MutatorTearGas.has_options = true
MutatorTearGas.categories = { "gameplay" }
MutatorTearGas.icon_coords = {
	7,
	1,
}

function MutatorTearGas:register_values(mutator_manager)
	self:register_value("tear_gas_min_chance_times_mul", 1, "ft")
	self:register_value("tear_gas_max_chance_times_mul", 1, "ft")
	self:register_value("tear_gas_lifetime_mul", 1, "ft")
	self:register_value("tear_gas_replace_flashbangs", false, "ftda")
	self:register_value("tear_gas_collateral_damage", false, "ftda")
end

function MutatorTearGas:modify_value(id, value)
	if id == "GroupAIStateBesiege:TearGasReplacesFlashbangs" and self:get_tear_gas_replace_flashbangs() then
		return true
	elseif id == "GroupAIStateBesiege:TearGasCollateralDamage" and self:get_tear_gas_collateral_damage() then
		return true
	end

	return value
end

function MutatorTearGas:setup(data)
	local min_chance_times_mul = self:get_tear_gas_min_chance_times_mul()
	local max_chance_times_mul = self:get_tear_gas_max_chance_times_mul()
	local lifetime_mul = self:get_tear_gas_lifetime_mul()

	-- Value 1: Time it takes for Tear Gas chance to begin scaling
	-- Value 2: Time it takes for a Tear Gas grenade to be guaranteed
	tweak_data.group_ai.cs_grenade_chance_times[1] = tweak_data.group_ai.cs_grenade_chance_times[1] * min_chance_times_mul
	tweak_data.group_ai.cs_grenade_chance_times[2] = math.max(tweak_data.group_ai.cs_grenade_chance_times[2] * max_chance_times_mul, tweak_data.group_ai.cs_grenade_chance_times[1]) -- Make sure maximum cs_grenade_chance_times are no shorter than minimum cs_grenade_chance_times
	tweak_data.group_ai.cs_grenade_lifetime = tweak_data.group_ai.cs_grenade_lifetime * lifetime_mul
end

function MutatorTearGas:name()
	local name = MutatorTearGas.super.name(self)

	if self:_mutate_name("tear_gas_min_chance_times_mul") then
		return string.format("%s - %.2f", name, tonumber(self:value("tear_gas_min_chance_times_mul")))
	elseif self:_mutate_name("tear_gas_max_chance_times_mul") then
		return string.format("%s - %.2f", name, tonumber(self:value("tear_gas_max_chance_times_mul")))
	elseif self:_mutate_name("tear_gas_lifetime_mul") then
		return string.format("%s - %.2f", name, tonumber(self:value("tear_gas_lifetime_mul")))
	else
		return name
	end
end

function MutatorTearGas:get_tear_gas_min_chance_times_mul()
	return self:value("tear_gas_min_chance_times_mul")
end

function MutatorTearGas:get_tear_gas_max_chance_times_mul()
	return self:value("tear_gas_max_chance_times_mul")
end

function MutatorTearGas:get_tear_gas_lifetime_mul()
	return self:value("tear_gas_lifetime_mul")
end

function MutatorTearGas:get_tear_gas_replace_flashbangs()
	return self:value("tear_gas_replace_flashbangs")
end

function MutatorTearGas:get_tear_gas_collateral_damage()
	return self:value("tear_gas_collateral_damage")
end

function MutatorTearGas:_min_tear_gas_min_chance_times_mul()
	return 0
end

function MutatorTearGas:_max_tear_gas_min_chance_times_mul()
	return 1
end

function MutatorTearGas:_min_tear_gas_max_chance_times_mul()
	return 0
end

function MutatorTearGas:_max_tear_gas_max_chance_times_mul()
	return 1
end

function MutatorTearGas:_min_tear_gas_lifetime_mul()
	return 1
end

function MutatorTearGas:_max_tear_gas_lifetime_mul()
	return 3
end

function MutatorTearGas:setup_options_gui(node)
	local params = {}
	local data_node = {}

	params = {
		name = "tear_gas_min_chance_times_mul_slider",
		callback = "_update_mutator_value",
		text_id = "menu_mutator_tear_gas_min_chance_times_mul_slider",
		update_callback = callback(self, self, "_update_tear_gas_min_chance_times_mul"),
	}
	data_node = {
		show_value = true,
		step = 0.05,
		type = "CoreMenuItemSlider.ItemSlider",
		decimal_count = 2,
		min = self:_min_tear_gas_min_chance_times_mul(),
		max = self:_max_tear_gas_min_chance_times_mul(),
	}
	local slider1 = node:create_item(data_node, params)

	slider1:set_value(self:get_tear_gas_min_chance_times_mul())
	node:add_item(slider1)

	params = {
		name = "tear_gas_max_chance_times_mul_slider",
		callback = "_update_mutator_value",
		text_id = "menu_mutator_tear_gas_max_chance_times_mul_slider",
		update_callback = callback(self, self, "_update_tear_gas_max_chance_times_mul"),
	}
	data_node = {
		show_value = true,
		step = 0.05,
		type = "CoreMenuItemSlider.ItemSlider",
		decimal_count = 2,
		min = self:_min_tear_gas_max_chance_times_mul(),
		max = self:_max_tear_gas_max_chance_times_mul(),
	}
	local slider2 = node:create_item(data_node, params)

	slider2:set_value(self:get_tear_gas_max_chance_times_mul())
	node:add_item(slider2)

	params = {
		name = "tear_gas_lifetime_mul_slider",
		callback = "_update_mutator_value",
		text_id = "menu_mutator_tear_gas_lifetime_mul_slider",
		update_callback = callback(self, self, "_update_tear_gas_lifetime_mul"),
	}
	data_node = {
		show_value = true,
		step = 0.05,
		type = "CoreMenuItemSlider.ItemSlider",
		decimal_count = 2,
		min = self:_min_tear_gas_lifetime_mul(),
		max = self:_max_tear_gas_lifetime_mul(),
	}
	local slider3 = node:create_item(data_node, params)

	slider3:set_value(self:get_tear_gas_lifetime_mul())
	node:add_item(slider3)

	params = {
		name = "tear_gas_replace_flashbangs_toggle",
		callback = "_update_mutator_value",
		text_id = "menu_mutator_tear_gas_replace_flashbangs_toggle",
		update_callback = callback(self, self, "_toggle_tear_gas_replace_flashbangs"),
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

	toggle1:set_value(self:get_tear_gas_replace_flashbangs() and "on" or "off")
	node:add_item(toggle1)

	params = {
		name = "tear_gas_collateral_damage_toggle",
		callback = "_update_mutator_value",
		text_id = "menu_mutator_tear_gas_collateral_damage_toggle",
		update_callback = callback(self, self, "_toggle_tear_gas_collateral_damage"),
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

	toggle2:set_value(self:get_tear_gas_collateral_damage() and "on" or "off")
	node:add_item(toggle2)

	self._node = node

	return new_item
end

function MutatorTearGas:_update_tear_gas_min_chance_times_mul(item)
	self:set_value("tear_gas_min_chance_times_mul", item:value())
end

function MutatorTearGas:_update_tear_gas_max_chance_times_mul(item)
	self:set_value("tear_gas_max_chance_times_mul", item:value())
end

function MutatorTearGas:_update_tear_gas_lifetime_mul(item)
	self:set_value("tear_gas_lifetime_mul", item:value())
end

function MutatorTearGas:_toggle_tear_gas_replace_flashbangs(item)
	self:set_value("tear_gas_replace_flashbangs", item:value() == "on")
end

function MutatorTearGas:_toggle_tear_gas_collateral_damage(item)
	self:set_value("tear_gas_collateral_damage", item:value() == "on")
end

function MutatorTearGas:reset_to_default()
	self:clear_values()

	if self._node then
		local slider1 = self._node:item("tear_gas_min_chance_times_mul")
		if slider1 then
			slider1:set_value(self:get_tear_gas_min_chance_times_mul())
		end

		local slider2 = self._node:item("tear_gas_max_chance_times_mul")
		if slider2 then
			slider2:set_value(self:get_tear_gas_max_chance_times_mul())
		end

		local slider3 = self._node:item("tear_gas_lifetime_mul")
		if slider3 then
			slider3:set_value(self:get_tear_gas_lifetime_mul())
		end

		local toggle1 = self._node:item("tear_gas_replace_flashbangs")
		if toggle1 then
			toggle1:set_value(self:get_tear_gas_replace_flashbangs())
		end

		local toggle2 = self._node:item("tear_gas_collateral_damage")
		if toggle2 then
			toggle2:set_value(self:get_tear_gas_collateral_damage())
		end
	end
end

function MutatorTearGas:options_fill()
	if self:get_tear_gas_min_chance_times_mul() then
		return self:_get_percentage_fill(self:_min_tear_gas_min_chance_times_mul(), self:_max_tear_gas_min_chance_times_mul(), self:get_tear_gas_min_chance_times_mul())
	elseif self:get_tear_gas_max_chance_times_mul() then
		return self:_get_percentage_fill(self:_min_tear_gas_max_chance_times_mul(), self:_max_tear_gas_max_chance_times_mul(), self:get_tear_gas_max_chance_times_mul())
	elseif self:get_tear_gas_lifetime_mul() then
		return self:_get_percentage_fill(self:_min_tear_gas_lifetime_mul(), self:_max_tear_gas_lifetime_mul(), self:get_tear_gas_lifetime_mul())
	end
end

--Taser Modifiers
MutatorTaser = MutatorTaser or class(BaseMutator)
MutatorTaser._type = "MutatorTaser"
MutatorTaser.name_id = "mutator_taser"
MutatorTaser.desc_id = "mutator_taser_desc"
MutatorTaser.has_options = true
MutatorTaser.categories = { "gameplay" }
MutatorTaser.icon_coords = {
	8,
	1,
}

function MutatorTaser:register_values(mutator_manager)
	self:register_value("taser_camera_spin_limit", 50, "ft")
	self:register_value("taser_camera_pitch_limit", 30, "ft")
	self:register_value("taser_incapacitation_time", 10, "ft")
	self:register_value("taser_full_stun_shocks", 3, "ft")
	self:register_value("taser_full_stun", false, "ftda")
end

function MutatorTaser:modify_value(id, value)
	if id == "PlayerTased:TaserFullStun" and self:get_taser_full_stun() then
		return true
	end

	return value
end

function MutatorTaser:setup(data)
	local cam_spin_limit = self:get_taser_camera_spin_limit()
	local cam_pitch_limit = self:get_taser_camera_pitch_limit()
	local full_stun_shocks = self:get_taser_full_stun_shocks()
	local incap_time = self:get_taser_incapacitation_time()

	local tased_camera_limit = clone(tweak_data.character.tased_camera_limit)

	tweak_data.character.tased_camera_limit[1] = math.min(tased_camera_limit[1], cam_spin_limit)
	tweak_data.character.tased_camera_limit[2] = math.min(tased_camera_limit[2], cam_pitch_limit)
	tweak_data.character.tased_full_stun_shocks = full_stun_shocks

	local old_tased_time = tweak_data.player.damage.TASED_TIME
	tweak_data.player.damage.TASED_TIME = math.min(incap_time, old_tased_time)
end

function MutatorTaser:name()
	local name = MutatorTaser.super.name(self)

	if self:_mutate_name("taser_camera_spin_limit") then
		return string.format("%s - %.2f", name, tonumber(self:value("taser_camera_spin_limit")))
	elseif self:_mutate_name("taser_camera_pitch_limit") then
		return string.format("%s - %.2f", name, tonumber(self:value("taser_camera_pitch_limit")))
	elseif self:_mutate_name("taser_incapacitation_time") then
		return string.format("%s - %.2f", name, tonumber(self:value("taser_incapacitation_time")))
	elseif self:_mutate_name("taser_full_stun_shocks") then
		return string.format("%s - %.2f", name, tonumber(self:value("taser_full_stun_shocks")))
	else
		return name
	end
end

function MutatorTaser:get_taser_camera_spin_limit()
	return self:value("taser_camera_spin_limit")
end

function MutatorTaser:get_taser_camera_pitch_limit()
	return self:value("taser_camera_pitch_limit")
end

function MutatorTaser:get_taser_incapacitation_time()
	return self:value("taser_incapacitation_time")
end

function MutatorTaser:get_taser_full_stun_shocks()
	return self:value("taser_full_stun_shocks")
end

function MutatorTaser:get_taser_full_stun()
	return self:value("taser_full_stun")
end

function MutatorTaser:_min_taser_camera_spin_limit()
	return 1
end

function MutatorTaser:_max_taser_camera_spin_limit()
	return 80
end

function MutatorTaser:_min_taser_camera_pitch_limit()
	return 1
end

function MutatorTaser:_max_taser_camera_pitch_limit()
	return 50
end

function MutatorTaser:_min_taser_incapacitation_time()
	return 1
end

function MutatorTaser:_max_taser_incapacitation_time()
	return 10
end

function MutatorTaser:_min_taser_full_stun_shocks()
	return 0
end

function MutatorTaser:_max_taser_full_stun_shocks()
	return 5
end

function MutatorTaser:setup_options_gui(node)
	local params = {}
	local data_node = {}

	params = {
		name = "taser_camera_spin_limit_slider",
		callback = "_update_mutator_value",
		text_id = "menu_mutator_taser_camera_spin_limit_slider",
		update_callback = callback(self, self, "_update_taser_camera_spin_limit"),
	}
	data_node = {
		show_value = true,
		step = 1,
		type = "CoreMenuItemSlider.ItemSlider",
		decimal_count = 0,
		min = self:_min_taser_camera_spin_limit(),
		max = self:_max_taser_camera_spin_limit(),
	}
	local slider1 = node:create_item(data_node, params)

	slider1:set_value(self:get_taser_camera_spin_limit())
	node:add_item(slider1)

	params = {
		name = "taser_camera_pitch_limit_slider",
		callback = "_update_mutator_value",
		text_id = "menu_mutator_taser_camera_pitch_limit_slider",
		update_callback = callback(self, self, "_update_taser_camera_pitch_limit"),
	}
	data_node = {
		show_value = true,
		step = 1,
		type = "CoreMenuItemSlider.ItemSlider",
		decimal_count = 0,
		min = self:_min_taser_camera_pitch_limit(),
		max = self:_max_taser_camera_pitch_limit(),
	}
	local slider2 = node:create_item(data_node, params)

	slider2:set_value(self:get_taser_camera_pitch_limit())
	node:add_item(slider2)

	params = {
		name = "taser_incapacitation_time_slider",
		callback = "_update_mutator_value",
		text_id = "menu_mutator_taser_incapacitation_time_slider",
		update_callback = callback(self, self, "_update_taser_incapacitation_time"),
	}
	data_node = {
		show_value = true,
		step = 0.5,
		type = "CoreMenuItemSlider.ItemSlider",
		decimal_count = 1,
		min = self:_min_taser_incapacitation_time(),
		max = self:_max_taser_incapacitation_time(),
	}
	local slider3 = node:create_item(data_node, params)

	slider3:set_value(self:get_taser_incapacitation_time())
	node:add_item(slider3)

	params = {
		name = "taser_full_stun_shocks_slider",
		callback = "_update_mutator_value",
		text_id = "menu_mutator_taser_full_stun_shocks_slider",
		update_callback = callback(self, self, "_update_taser_full_stun_shocks"),
	}
	data_node = {
		show_value = true,
		step = 1,
		type = "CoreMenuItemSlider.ItemSlider",
		decimal_count = 0,
		min = self:_min_taser_full_stun_shocks(),
		max = self:_max_taser_full_stun_shocks(),
	}
	local slider4 = node:create_item(data_node, params)

	slider4:set_value(self:get_taser_full_stun_shocks())
	node:add_item(slider4)

	params = {
		name = "taser_full_stun_toggle",
		callback = "_update_mutator_value",
		text_id = "menu_mutator_taser_full_stun_toggle",
		update_callback = callback(self, self, "_toggle_taser_full_stun"),
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

	toggle1:set_value(self:get_taser_full_stun() and "on" or "off")
	node:add_item(toggle1)

	return new_item
end

function MutatorTaser:_update_taser_camera_spin_limit(item)
	self:set_value("taser_camera_spin_limit", item:value())
end

function MutatorTaser:_update_taser_camera_pitch_limit(item)
	self:set_value("taser_camera_pitch_limit", item:value())
end

function MutatorTaser:_update_taser_incapacitation_time(item)
	self:set_value("taser_incapacitation_time", item:value())
end

function MutatorTaser:_update_taser_full_stun_shocks(item)
	self:set_value("taser_full_stun_shocks", item:value())
end

function MutatorTaser:_toggle_taser_full_stun(item)
	self:set_value("taser_full_stun", item:value() == "on")
end

function MutatorTaser:reset_to_default()
	self:clear_values()

	if self._node then
		local slider1 = self._node:item("taser_camera_spin_limit")
		if slider1 then
			slider1:set_value(self:get_taser_camera_spin_limit())
		end

		local slider2 = self._node:item("taser_camera_pitch_limit")
		if slider2 then
			slider2:set_value(self:get_taser_camera_pitch_limit())
		end

		local slider3 = self._node:item("taser_incapacitation_time")
		if slider3 then
			slider3:set_value(self:get_taser_incapacitation_time())
		end

		local slider4 = self._node:item("taser_full_stun_shocks")
		if slider4 then
			slider4:set_value(self:get_taser_full_stun_shocks())
		end

		local toggle1 = self._node:item("taser_full_stun")
		if toggle1 then
			toggle1:set_value(self:get_taser_full_stun())
		end
	end
end

function MutatorTaser:options_fill()
	if self:get_taser_camera_spin_limit() then
		return self:_get_percentage_fill(self:_min_taser_camera_spin_limit(), self:_max_taser_camera_spin_limit(), self:get_taser_camera_spin_limit())
	elseif self:get_taser_camera_pitch_limit() then
		return self:_get_percentage_fill(self:_min_taser_camera_pitch_limit(), self:_max_taser_camera_pitch_limit(), self:get_taser_camera_pitch_limit())
	elseif self:get_taser_incapacitation_time() then
		return self:_get_percentage_fill(self:_min_taser_incapacitation_time(), self:_max_taser_incapacitation_time(), self:get_taser_incapacitation_time())
	elseif self:get_taser_full_stun_shocks() then
		return self:_get_percentage_fill(self:_min_taser_full_stun_shocks(), self:_max_taser_full_stun_shocks(), self:get_taser_full_stun_shocks())
	end
end

-- No Auto-Reload --
MutatorManualReload = MutatorManualReload or class(BaseMutator)
MutatorManualReload._type = "MutatorManualReload"
MutatorManualReload.name_id = "mutator_manualreload"
MutatorManualReload.desc_id = "mutator_manualreload_desc"
MutatorManualReload.categories = { "gameplay" }

MutatorManualReload.icon_coords = {
	0,
	0,
}

function MutatorManualReload:setup(data)
	--	tweak_data.weapon.weapon_settings.no_autoreload = true
end

-- Jerome Mode
MutatorJerome = MutatorJerome or class(BaseMutator)
MutatorJerome._type = "MutatorJerome"
MutatorJerome.name_id = "mutator_jerome"
MutatorJerome.desc_id = "mutator_jerome_desc"
MutatorJerome.categories = { "enemies" }
MutatorJerome.icon_coords = {
	5,
	2,
}

function MutatorJerome:modify_value(id, value)
	if id == "CopBase:Jerome" then
		return true
	end
	return value
end