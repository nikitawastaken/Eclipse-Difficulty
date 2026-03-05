--A big ass dump for new mutators

--Customazible damage grace--
MutatorGraceTroll = MutatorGraceTroll or class(BaseMutator)
MutatorGraceTroll._type = "MutatorGraceTroll"
MutatorGraceTroll.name_id = "mutator_gracetroll"
MutatorGraceTroll.desc_id = "mutator_gracetroll_desc"
MutatorGraceTroll.has_options = true
MutatorGraceTroll.reductions = {
	money = 0,
	exp = 0,
}
MutatorGraceTroll.categories = { "gameplay" }
MutatorGraceTroll.icon_coords = {
	4,
	2,
}

function MutatorGraceTroll:register_values(mutator_manager)
	self:register_value("gracetroll", 0.15, "ft")
	self:register_value("gracetroll_disablearmor", false, "ftda")
	self:register_value("gracetroll_reducediframedamage", false, "ftrifd")
end

function MutatorGraceTroll:modify_value(id, value)
	if id == "PlayerDamage:DisableArmorGrace" and self:get_grace_troll_disable_armor_grace() then
		return true
	elseif id == "PlayerDamage:ReducedIFrameDamage" and self:get_grace_troll_reduced_iframe_damage() then
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
