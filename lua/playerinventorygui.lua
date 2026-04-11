-- Fix melee weapon knockdown stat display
Hooks:PreHook(PlayerInventoryGui, "set_melee_stats", "shc_set_melee_stats", function(self, _, data)
	for _, v in pairs(data) do
		if v.name == "damage_effect" then
			v.multiple_of = nil
			return
		end
	end
end)

Hooks:PostHook(PlayerInventoryGui, "_update_stats", "eclipse__update_stats", function(self, name)
	if name == "primary" or name == "secondary" then
		local stats = {
			{
				round_value = true,
				name = "magazine",
				stat_name = "extra_ammo",
			},
			{
				round_value = true,
				name = "totalammo",
				stat_name = "total_ammo_mod",
			},
			{
				name = "pickup",
			},
			{
				inverted = true,
				name = "reload",
			},
			{
				round_value = true,
				name = "fire_rate",
			},
			{
				name = "damage",
			},
			{
				percent = true,
				name = "spread",
				offset = true,
				revert = true,
			},
			{
				percent = true,
				name = "recoil",
				offset = true,
				revert = true,
			},
			{
				index = true,
				name = "concealment",
			},
			{
				percent = false,
				name = "suppression",
				offset = true,
			},
		}
		self:set_weapon_stats(self._info_panel, stats)
		self:_update_info_weapon(name)
	elseif name == "melee" then
		self:set_melee_stats(self._info_panel, {
			{
				range = true,
				name = "damage",
			},
			{
				range = true,
				name = "damage_effect",
				multiple_of = "damage",
			},
			{
				inverse = true,
				name = "charge_time",
				num_decimals = 1,
				suffix = managers.localization:text("menu_seconds_suffix_short"),
			},
			{
				inverse = true,
				name = "swing_time",
				num_decimals = 1,
				suffix = managers.localization:text("menu_seconds_suffix_short"),
			},
			{
				inverse = true,
				name = "reswing_time",
				num_decimals = 1,
				suffix = managers.localization:text("menu_seconds_suffix_short"),
			},
			{
				range = true,
				name = "range",
			},
			{
				index = true,
				name = "concealment",
			},
			{
				name = "type",
				round_value = "string",
			},
		})
		self:_update_info_melee(name)
	end
end)

local function get_pellets_from_blueprint(name, blueprint, category, slot)
	local new_rays = WeaponDescription._get_custom_pellet_stats(name, category, slot, blueprint)
	if table.contains(tweak_data.weapon[name].categories, "grenade_launcher") then
		-- Grenade launchers have a base rays stat of 8 even though
		-- the stat is only used when sting grenades are equipped...
		return 1, tweak_data.weapon[name].rays
	else
		return tweak_data.weapon[name].rays, new_rays
	end
end

local function format_round(val, round_value)
	if round_value == true then
		return round_value and tostring(math.round(val))
	elseif round_value == 2 then
		return string.format("%.2f", val):gsub("0.00", "0")
	elseif round_value == "string" then
		return val
	else
		return string.format("%.1f", val):gsub("%.?0+$", "")
	end
end

Hooks:PostHook(PlayerInventoryGui, "_update_info_weapon", "eclipse_playerinventorygui_update_info_weapon", function(self, name)
	local category = name == "primary" and "primaries" or "secondaries"
	-- Shotgun check
	local equipped_name
	if category == "primaries" then
		equipped_name = managers.blackmarket:equipped_primary().weapon_id
	else
		equipped_name = managers.blackmarket:equipped_secondary().weapon_id
	end

	local weapon_tweak = tweak_data.weapon[equipped_name]
	if not weapon_tweak then
		return
	end

	local shotgun = table.contains(weapon_tweak.categories, "shotgun")

	-- Maybe there's a less verbose way to get your equipped
	-- weapon's mods and filter them but I'm not sure
	local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(equipped_name)
	local equipped_item = managers.blackmarket:equipped_item(category)
	local equipped_slot = managers.blackmarket:equipped_weapon_slot(category)
	local equipped_blueprint = managers.blackmarket:get_weapon_blueprint(category, equipped_slot)
	local ammo_mods = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk("ammo", factory_id, equipped_blueprint)
	local sting = false
	for _, id in ipairs(ammo_mods) do
		local part = managers.weapon_factory:_part_data(id, factory_id)
		if part.sub_type and part.sub_type == "ammo_hornet" then
			sting = true
		end
	end
	if not shotgun and not sting then
		return
	end

	-- Preliminary number calcs
	local base_stats, mods_stats, skill_stats = WeaponDescription._get_stats(equipped_item.weapon_id, category, equipped_slot)
	local total_damage = math.max(base_stats.damage.value + mods_stats.damage.value + skill_stats.damage.value, 0)
	local base_damage = base_stats.damage.value

	local base_rays, rays = get_pellets_from_blueprint(equipped_name, equipped_blueprint, category, equipped_slot)

	self._stats_texts.damage.total:set_text(total_damage .. "x" .. (rays or base_rays))
	if shotgun then
		-- Only shotguns actually use their base pellet stat
		-- GLs have a base pellet stat that's only used for
		-- sting grenades for some reason...
		self._stats_texts.damage.base:set_text(base_damage .. "x" .. base_rays)
	else
		self._stats_texts.damage.base:set_text(base_damage)
	end

	local value = math.max(base_stats.damage.value + mods_stats.damage.value + skill_stats.damage.value, 0) * (rays or 1)
	local base = base_stats.damage.value * (base_rays or 1)
	if base < value then
		self._stats_texts.damage.total:set_color(tweak_data.screen_colors.stats_positive)
	elseif value < base then
		self._stats_texts.damage.total:set_color(tweak_data.screen_colors.stats_negative)
	else
		self._stats_texts.damage.total:set_color(tweak_data.screen_colors.text)
	end
end)

-- Not really a pretty way to get melee stats to show properly, unfortunately
local old_mweapon_stats = PlayerInventoryGui._get_melee_weapon_stats
function PlayerInventoryGui:_get_melee_weapon_stats(name)
	local base, mod, skill = old_mweapon_stats(self, name)
	if not base or not mod or not skill then
		return
	end

	local stats = managers.blackmarket:get_melee_weapon_stats(name)
	local swing_time = tweak_data.blackmarket.melee_weapons[name].expire_t
	base.swing_time = {
		min_value = swing_time,
		max_value = swing_time,
		value = swing_time,
	}
	skill.swing_time = {
		min_value = 0,
		max_value = 0,
		value = 0,
	}
	base.swing_time.real_value = base.swing_time.value
	skill.swing_time.real_value = skill.swing_time.value
	local reswing_time = tweak_data.blackmarket.melee_weapons[name].expire_t
	local skill_mul = managers.player:upgrade_value("melee", "faster_reswing", 1)
	local skill_addend = (skill_mul < 1) and (reswing_time * skill_mul - reswing_time) or 0
	base.reswing_time = {
		min_value = reswing_time,
		max_value = reswing_time,
		value = reswing_time,
	}
	skill.reswing_time = {
		skill_min = skill_addend,
		skill_max = skill_addend,
		min_value = skill_addend,
		max_value = skill_addend,
		value = skill_addend,
		skill_in_effect = skill_mul < 1,
	}
	base.reswing_time.real_value = base.reswing_time.value
	skill.reswing_time.real_value = skill.reswing_time.value
	local weapon_type = stats.weapon_type
	weapon_type = utf8.to_upper(weapon_type)
	base.type = {
		min_value = weapon_type,
		max_value = weapon_type,
		value = weapon_type,
	}
	skill.type = {
		min_value = 0,
		max_value = 0,
		value = 0,
	}
	base.type.real_value = base.swing_time.value
	skill.type.real_value = skill.swing_time.value
	return base, mod, skill
end

-- name
function PlayerInventoryGui:_update_info_melee(_)
	local player_loadout_data = managers.blackmarket:player_loadout_data()
	local category = "melee_weapons"
	local equipped_item = managers.blackmarket:equipped_item(category)
	local base_stats, mods_stats, skill_stats = self:_get_melee_weapon_stats(equipped_item)
	local text_string = string.format("%s", player_loadout_data.melee_weapon.info_text)

	self:set_info_text(text_string)

	local value, value_min, value_max = nil

	for _, stat in ipairs(self._stats_shown) do
		if stat.range then
			value_min = math.max(base_stats[stat.name].min_value + mods_stats[stat.name].min_value + skill_stats[stat.name].min_value, 0)
			value_max = math.max(base_stats[stat.name].max_value + mods_stats[stat.name].max_value + skill_stats[stat.name].max_value, 0)
		end

		if stat.name == "type" then
			value = base_stats[stat.name].value
		else
			value = math.max(base_stats[stat.name].value + mods_stats[stat.name].value + skill_stats[stat.name].value, 0)
		end
		local base, base_min, base_max, skill_min, skill_max = nil

		if stat.range then
			base_min = base_stats[stat.name].min_value
			base_max = base_stats[stat.name].max_value
			skill_min = skill_stats[stat.name].min_value
			skill_max = skill_stats[stat.name].max_value
		end

		base = base_stats[stat.name].value
		local equip_text = value and format_round(value, stat.round_value)
		local base_text = base and format_round(base, stat.round_value)
		local skill_text = skill_stats[stat.name].value and format_round(skill_stats[stat.name].value, stat.round_value)
		local base_min_text = base_min and format_round(base_min, true)
		local base_max_text = base_max and format_round(base_max, true)
		local value_min_text = value_min and format_round(value_min, true)
		local value_max_text = value_max and format_round(value_max, true)
		local skill_min_text = skill_min and format_round(skill_min, true)
		local skill_max_text = skill_max and format_round(skill_max, true)

		if stat.range then
			if base_min ~= base_max then
				base_text = base_min_text .. " (" .. base_max_text .. ")"
			end

			if value_min ~= value_max then
				equip_text = value_min_text .. " (" .. value_max_text .. ")"
			end

			if skill_min ~= skill_max then
				skill_text = skill_min_text .. " (" .. skill_max_text .. ")"
			end
		end

		if stat.suffix then
			base_text = base_text .. tostring(stat.suffix)
			equip_text = equip_text .. tostring(stat.suffix)
			skill_text = skill_text .. tostring(stat.suffix)
		end

		if stat.prefix then
			base_text = tostring(stat.prefix) .. base_text
			equip_text = tostring(stat.prefix) .. equip_text
			skill_text = tostring(stat.prefix) .. skill_text
		end

		self._stats_texts[stat.name].total:set_alpha(1)
		self._stats_texts[stat.name].total:set_text(equip_text)
		self._stats_texts[stat.name].base:set_text(base_text)
		self._stats_texts[stat.name].skill:set_text(skill_stats[stat.name].skill_in_effect and (skill_stats[stat.name].value > 0 and "+" or "") .. skill_text or "")

		local positive = value ~= 0 and base < value
		local negative = value ~= 0 and value < base

		if stat.inverse then
			local temp = positive
			positive = negative
			negative = temp
		end

		if stat.range then
			if positive then
				self._stats_texts[stat.name].total:set_color(tweak_data.screen_colors.stats_positive)
			elseif negative then
				self._stats_texts[stat.name].total:set_color(tweak_data.screen_colors.stats_negative)
			end
		elseif stat.name == "type" then
			self._stats_texts[stat.name].total:set_color(tweak_data.screen_colors.dlc_color)
			self._stats_texts[stat.name].base:set_text("")
		elseif positive then
			self._stats_texts[stat.name].total:set_color(tweak_data.screen_colors.stats_positive)
		elseif negative then
			self._stats_texts[stat.name].total:set_color(tweak_data.screen_colors.stats_negative)
		else
			self._stats_texts[stat.name].total:set_color(tweak_data.screen_colors.text)
		end
	end
end

-- name
function PlayerInventoryGui:_update_info_deployable(_, slot)
	local deployable_id = managers.blackmarket:equipped_deployable(slot)
	local equipment_data = deployable_id and tweak_data.equipments[deployable_id]
	local deployable_data = deployable_id and tweak_data.blackmarket.deployables[deployable_id]
	local text_string = ""

	if deployable_data and equipment_data then
		local amount = equipment_data.quantity[1] or 1

		if deployable_id == "sentry_gun_silent" then
			deployable_id = "sentry_gun"
		end

		amount = amount + (managers.player:equiptment_upgrade_value(deployable_id, "quantity") or 0)

		if not managers.player:has_category_upgrade("player", "no_secondary_deployable_penalty") and slot and slot > 1 then
			amount = math.ceil(amount / 2)
		end

		text_string = text_string .. managers.localization:text(deployable_data.name_id) .. " (x" .. tostring(amount) .. ")" .. "\n\n"

		if self:_should_show_description() then
			text_string = text_string
				.. managers.localization:text(deployable_data.desc_id, {
					BTN_INTERACT = managers.localization:btn_macro("interact", true),
					BTN_USE_ITEM = managers.localization:btn_macro("use_item", true),
				})
				.. "\n"
		end
	end

	self:set_info_text(text_string)
end
function PlayerInventoryGui:setup_player_stats(panel)
	local data = {
		{
			name = "armor",
		},
		{
			name = "health",
		},
		{
			procent = true,
			name = "movement",
		},
		{
			name = "dodge",
			procent = true,
			revert = true,
		},
		{
			name = "transparency",
		},
		{
			inverted = true,
			name = "armor_regen",
			suffix = managers.localization:text("menu_seconds_suffix_short"),
		},
		{
			name = "crit",
			procent = true,
			revert = true,
		},
		{
			name = "damage_shake",
		},
		{
			name = "stamina",
		},
	}
	local stats_panel = panel:child("stats_panel")

	if alive(stats_panel) then
		panel:remove(stats_panel)

		stats_panel = nil
	end

	stats_panel = panel:panel({
		name = "stats_panel",
	})
	local panel = stats_panel:panel({
		h = 20,
		layer = 1,
		w = stats_panel:w(),
	})
	self._player_stats_shown = data
	self._player_stats_titles = {
		total = stats_panel:text({
			x = 135,
			layer = 2,
			font_size = tweak_data.menu.pd2_small_font_size,
			font = tweak_data.menu.pd2_small_font,
			color = tweak_data.screen_colors.text,
			text = utf8.to_upper(managers.localization:text("bm_menu_stats_total")),
		}),
		base = stats_panel:text({
			alpha = 0.75,
			x = 200,
			layer = 2,
			font_size = tweak_data.menu.pd2_small_font_size,
			font = tweak_data.menu.pd2_small_font,
			color = tweak_data.screen_colors.text,
			text = utf8.to_upper(managers.localization:text("bm_menu_stats_base")),
		}),
		skill = stats_panel:text({
			alpha = 0.75,
			x = 259,
			layer = 2,
			font_size = tweak_data.menu.pd2_small_font_size,
			font = tweak_data.menu.pd2_small_font,
			color = tweak_data.screen_colors.resource,
			text = utf8.to_upper(managers.localization:text("bm_menu_stats_skill")),
		}),
	}
	local x = 0
	local y = 20
	local text_panel = nil
	local text_columns = {
		{
			size = 100,
			name = "name",
		},
		{
			size = 60,
			name = "total",
			align = "right",
		},
		{
			align = "right",
			name = "base",
			blend = "add",
			alpha = 0.75,
			size = 60,
		},
		{
			align = "right",
			name = "skill",
			blend = "add",
			alpha = 0.75,
			size = 60,
			color = tweak_data.screen_colors.resource,
		},
	}
	self._player_stats_texts = {}
	self._player_stats_panel = stats_panel:panel()

	for i, stat in ipairs(data) do
		panel = self._player_stats_panel:panel({
			name = "weapon_stats",
			h = 20,
			x = 0,
			layer = 1,
			y = y,
			w = self._player_stats_panel:w(),
		})

		if math.mod(i, 2) ~= 0 and not panel:child(tostring(i)) then
			panel:rect({
				name = tostring(i),
				color = Color.black:with_alpha(0.4),
			})
		end

		x = 2
		y = y + 20
		self._player_stats_texts[stat.name] = {}

		for _, column in ipairs(text_columns) do
			text_panel = panel:panel({
				layer = 0,
				x = x,
				w = column.size,
				h = panel:h(),
			})
			self._player_stats_texts[stat.name][column.name] = text_panel:text({
				text = "0",
				layer = 1,
				font_size = tweak_data.menu.pd2_small_font_size,
				font = tweak_data.menu.pd2_small_font,
				align = column.align,
				alpha = column.alpha,
				blend_mode = column.blend,
				color = column.color or tweak_data.screen_colors.text,
			})
			x = x + column.size

			if column.name == "name" then
				self._player_stats_texts[stat.name].name:set_text(managers.localization:to_upper_text("bm_menu_" .. stat.name))
			end
		end
	end
end

function PlayerInventoryGui:_update_player_stats()
	local player_loadout_data = managers.blackmarket:player_loadout_data()
	local category = "armors"
	local equipped_item = managers.blackmarket:equipped_item(category)
	local equipped_slot = managers.blackmarket:equipped_armor_slot()
	local temp_stats_shown = self._stats_shown
	self._stats_shown = self._player_stats_shown
	local base_stats, mods_stats, skill_stats = self:_get_armor_stats(equipped_item)
	self._stats_shown = temp_stats_shown

	for _, stat in ipairs(self._player_stats_shown) do
		local value = math.max(base_stats[stat.name].value + mods_stats[stat.name].value + skill_stats[stat.name].value, 0)
		local base = base_stats[stat.name].value

		local base_text = format_round(base, stat.round_value)
		local total_text = format_round(value, stat.round_value)
		local skill_text = skill_stats[stat.name].skill_in_effect and (skill_stats[stat.name].value > 0 and "+" or "") .. format_round(skill_stats[stat.name].value, stat.round_value) or ""

		if stat.suffix then
			base_text = base_text .. tostring(stat.suffix)
			total_text = total_text .. tostring(stat.suffix)
			if skill_text ~= "" then
				skill_text = skill_text .. tostring(stat.suffix)
			end
		end

		self._player_stats_texts[stat.name].total:set_alpha(1)
		self._player_stats_texts[stat.name].total:set_text(total_text)
		self._player_stats_texts[stat.name].base:set_text(base_text)
		self._player_stats_texts[stat.name].skill:set_text(skill_text)

		if value ~= 0 and base < value then
			self._player_stats_texts[stat.name].total:set_color(stat.inverted and tweak_data.screen_colors.stats_negative or tweak_data.screen_colors.stats_positive)
		elseif value ~= 0 and value < base then
			self._player_stats_texts[stat.name].total:set_color(stat.inverted and tweak_data.screen_colors.stats_positive or tweak_data.screen_colors.stats_negative)
		else
			self._player_stats_texts[stat.name].total:set_color(tweak_data.screen_colors.text)
		end
	end
end

function PlayerInventoryGui:_get_armor_stats(name)
	local base_stats = {}
	local mods_stats = {}
	local skill_stats = {}
	local detection_risk = managers.blackmarket:get_suspicion_offset_from_custom_data({
		armors = name,
	}, tweak_data.player.SUSPICION_OFFSET_LERP or 0.75)
	detection_risk = math.round(detection_risk * 100)
	local bm_armor_tweak = tweak_data.blackmarket.armors[name]
	local upgrade_level = bm_armor_tweak.upgrade_level

	for i, stat in ipairs(self._stats_shown) do
		base_stats[stat.name] = {
			value = 0,
		}
		mods_stats[stat.name] = {
			value = 0,
		}
		skill_stats[stat.name] = {
			value = 0,
		}

		if stat.name == "armor" then
			local base = tweak_data.player.damage.ARMOR_INIT
			local mod = managers.player:body_armor_value("armor", upgrade_level)
			base_stats[stat.name] = {
				value = (base + mod) * tweak_data.gui.stats_present_multiplier,
			}
			skill_stats[stat.name] = {
				value = (base_stats[stat.name].value + managers.player:body_armor_skill_addend(name) * tweak_data.gui.stats_present_multiplier) * managers.player:body_armor_skill_multiplier(name)
					- base_stats[stat.name].value,
			}
		elseif stat.name == "health" then
			local base = tweak_data.player.damage.HEALTH_INIT
			local mod = managers.player:health_skill_addend()
			base_stats[stat.name] = {
				value = (base + mod) * tweak_data.gui.stats_present_multiplier,
			}
			skill_stats[stat.name] = {
				value = base_stats[stat.name].value * managers.player:health_skill_multiplier() - base_stats[stat.name].value,
			}
		elseif stat.name == "movement" then
			local base = tweak_data.player.movement_state.standard.movement.speed.STANDARD_MAX / 100 * tweak_data.gui.stats_present_multiplier
			local movement_penalty = managers.player:body_armor_value("movement", upgrade_level)
			local base_value = movement_penalty * base
			base_stats[stat.name] = {
				value = base_value,
			}
			local skill_mod = managers.player:movement_speed_multiplier(false, false, upgrade_level, 1)
			local val = base * skill_mod
			val = Utl.round(val, 2)
			base_value = Utl.round(base_value, 2)
			local skill_value = val - base_value
			skill_stats[stat.name] = {
				value = skill_value,
				skill_in_effect = skill_value > 0,
			}
		elseif stat.name == "dodge" then
			local base = 0
			local mod = managers.player:body_armor_value("dodge", upgrade_level)
			base_stats[stat.name] = {
				value = (base + mod) * 100,
			}
			skill_stats[stat.name] = {
				value = managers.player:skill_dodge_chance(false, false, false, name, detection_risk) * 100,
			}
		elseif stat.name == "crit" then
			local base = 0
			local mod = managers.player:body_armor_value("crit", upgrade_level)
			base_stats[stat.name] = {
				value = (base + mod) * 100,
			}
			skill_stats[stat.name] = {
				value = managers.player:critical_hit_chance(detection_risk) * 100,
			}
		elseif stat.name == "transparency" then
			local base = 0
			local mod = managers.player:body_armor_value("transparency", upgrade_level)
			base_stats[stat.name] = {
				value = (base + mod),
			}
			skill_stats[stat.name] = {
				value = managers.player:transparency_value(detection_risk),
			}
		elseif stat.name == "armor_regen" then
			local base = tweak_data.player.damage.REGENERATE_TIME
			local mul1 = managers.player:body_armor_regen_multiplier(false, 1)
			local mul2 = managers.player:upgrade_value("player", "armor_regen_time_mul", 1)
			base_stats[stat.name] = {
				value = base,
			}

			local armor_grinding_data = managers.player:upgrade_value("player", "armor_grinding", nil)
			if armor_grinding_data and armor_grinding_data ~= 0 then
				local armor_data = tweak_data.blackmarket.armors[managers.blackmarket:equipped_armor(true, true)]
				local idx = armor_data.upgrade_level
				local target_tick = armor_grinding_data[idx][2]
				skill_stats[stat.name] = {
					value = target_tick - base,
				}
			else
				skill_stats[stat.name] = {
					value = base * (mul1 * mul2 - 1),
				}
			end
		elseif stat.name == "damage_shake" then
			local base = tweak_data.gui.armor_damage_shake_base
			local mod = math.max(managers.player:body_armor_value("damage_shake", upgrade_level, nil, 1), 0.01)
			local skill = math.max(managers.player:upgrade_value("player", "damage_shake_multiplier", 1), 0.01)
			local base_value = base
			local mod_value = base / mod - base_value
			local skill_value = base / mod / skill - base_value - mod_value + managers.player:upgrade_value("player", "damage_shake_addend", 0)
			base_stats[stat.name] = {
				value = (base_value + mod_value) * tweak_data.gui.stats_present_multiplier,
			}
			skill_stats[stat.name] = {
				value = skill_value * tweak_data.gui.stats_present_multiplier,
			}
		elseif stat.name == "stamina" then
			local stamina_data = tweak_data.player.movement_state.stamina
			local base = stamina_data.STAMINA_INIT
			local mod = managers.player:body_armor_value("stamina", upgrade_level)
			local skill = managers.player:stamina_multiplier()
			local base_value = base
			local mod_value = base * mod - base_value
			local skill_value = base * mod * skill - base_value - mod_value
			base_stats[stat.name] = {
				value = base_value + mod_value,
			}
			skill_stats[stat.name] = {
				value = skill_value,
			}
		end

		skill_stats[stat.name].skill_in_effect = skill_stats[stat.name].skill_in_effect or skill_stats[stat.name].value ~= 0
	end

	if managers.player:has_category_upgrade("player", "armor_to_health_conversion") then
		local conversion_ratio = managers.player:upgrade_value("player", "armor_to_health_conversion") * 0.01
		local converted_armor = (base_stats.armor.value + skill_stats.armor.value) * conversion_ratio
		local skill_in_effect = converted_armor ~= 0
		skill_stats.armor.value = skill_stats.armor.value - converted_armor
		skill_stats.health.value = skill_stats.health.value + converted_armor
		skill_stats.armor.skill_in_effect = skill_in_effect
		skill_stats.health.skill_in_effect = skill_in_effect
	end

	return base_stats, mods_stats, skill_stats
end
