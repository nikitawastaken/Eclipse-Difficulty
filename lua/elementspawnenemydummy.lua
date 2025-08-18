local level_id = Eclipse.utils.level_id()
local diff_name = Eclipse.utils.difficulty_name()
local is_testmap = Eclipse.utils.is_testmap()

-- Don't replace spawns on custom enemy spawner map
if Global.editor_mode or is_testmap then
	function ElementSpawnEnemyDummy:chk_used_mapped_names(...) end
	function ElementSpawnEnemyDummy:get_replacement_enemy_name(...) end
	function ElementSpawnEnemyDummy:replace_enemy_name(...) end
	function ElementSpawnEnemyDummy:get_unit_alternative(...) end
	function ElementSpawnEnemyDummy:get_ponr_unit(...) end

	Eclipse:log_console("Editor/Spawner mode is active, spawn group fixes disabled")
	return
end

ElementSpawnEnemyDummy.faction_mapping = Eclipse.faction_mapping
ElementSpawnEnemyDummy.enemy_mapping = Eclipse.enemy_mapping
ElementSpawnEnemyDummy.unit_alternatives = Eclipse.unit_alternatives
ElementSpawnEnemyDummy.ponr_unit_replacements = Eclipse.ponr_unit_replacements

Hooks:PostHook(ElementSpawnEnemyDummy, "init", "eclipse_init", function(self)
	self._enemy_table = self._values.enemy_table
	self._values.enemy_table = nil
end)

function ElementSpawnEnemyDummy:_chk_is_sniper(unit)
	local snipers_but_not_really = {
		[("units/pd2_dlc_spa/characters/ene_sniper_3/ene_sniper_3"):key()] = true,
	}

	if not unit then
		return
	end

	if snipers_but_not_really[unit:name():key()] then
		return
	end

	if unit:base():has_tag("law") and unit:base():char_tweak().access == "sniper" then
		managers.groupai:state():megaphone_announce_snipers()
	end
end

function ElementSpawnEnemyDummy:chk_used_mapped_names(force)
	if not self._used_mapped_names or force then
		self._used_mapped_names = {}

		local function try_add_mapped_name(name, weight)
			local mapped_name = self.enemy_mapping[name:key()]

			if mapped_name then
				self._used_mapped_names[mapped_name] = weight
			end
		end

		if not self._enemy_table then
			try_add_mapped_name(self._enemy_name, 1)
		else
			for k, v in pairs(self._enemy_table) do
				if type(k) == "number" then
					try_add_mapped_name(v, 1)
				else
					try_add_mapped_name(k, v)
				end
			end
		end
	end

	return self._used_mapped_names
end

function ElementSpawnEnemyDummy:get_replacement_enemy_name(tier)
	local level_tweak = tweak_data.levels[level_id]
	local faction = self.faction_mapping[level_tweak and level_tweak.ai_group_type or "america"] and self.faction_mapping[level_tweak and level_tweak.ai_group_type or "america"][tier or managers.groupai:state():_get_scripted_tier()]

	if not faction then
		return nil
	end

	local used_mapped_names = self:chk_used_mapped_names()
	if not used_mapped_names or not next(used_mapped_names) then
		return nil
	end

	local enemy_table = {}
	for mapped, weight in pairs(used_mapped_names) do
		local add = faction[mapped]
		if add then
			enemy_table[add] = weight
		end
	end

	-- nil if none, non-table name if one
	if table.size(enemy_table) < 2 then
		local k, v = next(enemy_table)
		if type(k) == "number" then
			return v
		end
		return k
	end

	return enemy_table
end

function ElementSpawnEnemyDummy:replace_enemy_name(name)
	name = name or self:get_replacement_enemy_name()

	if not name then
		return
	end

	if type(name) == "table" then
		self._enemy_table = name
		self._enemy_name = name[1]
	else
		self._enemy_table = nil
		self._enemy_name = name
	end
end

-- Random unit replacements (used for spawning scripted and non-scripted fat Security and Beat Cops and more)
function ElementSpawnEnemyDummy:get_unit_alternative(name)
	local alternative_data = self.unit_alternatives[name:key()]

	if not alternative_data or not next(alternative_data) then
		return nil
	end

	local alternative_selector = WeightedSelector:new()
	local unit_alternative_types = self.unit_alternative_types
	for alt_name, alt_weight in pairs(alternative_data) do
		alternative_selector:add(alt_name, alt_weight)
	end

	if #alternative_selector._values < 1 then
		Eclipse:warn_console("Unit alternative selector was empty")

		return nil
	end

	return Idstring(alternative_selector:select())
end

-- PONR assault state unit replacements (used for replacing units during Full Force Onslaught)
function ElementSpawnEnemyDummy:get_ponr_unit(name)
	local is_ponr = managers.groupai:state_name() == "ponr"

	if not is_ponr then
		return
	end

	local ponr_unit_data = self.ponr_unit_replacements[diff_name] and self.ponr_unit_replacements[diff_name][name:key()]

	if not ponr_unit_data then
		return nil
	end

	return Idstring(ponr_unit_data)
end

function ElementSpawnEnemyDummy:_process_enemy_tbl(enemy_tbl)
	if type(enemy_tbl) ~= "table" then
		return nil
	end

	local enemy_selector = WeightedSelector:new()
	for enemy_name, enemy_weight in pairs(enemy_tbl) do
		if type(enemy_name) == "number" then
			enemy_selector:add(enemy_weight, 1)
		elseif type(enemy_weight) == "table" then
			Utils.PrintTable(enemy_weight)
			return nil
		else
			enemy_selector:add(enemy_name, enemy_weight)
		end
	end

	-- Idstring on an Idstring crashes
	-- TODO: redo mission script patches to use string enemy names rather than Idstrings
	local new_enemy_name = enemy_selector:select()
	local typ = type(new_enemy_name)
	if typ == "userdata" then
		return new_enemy_name
	elseif typ == "string" then
		return Idstring(new_enemy_name)
	elseif typ == "table" then
		return self:_process_enemy_tbl(new_enemy_name)
	end
end

local access_replacement = {
	cop = "fbi",
}

local produce_original = ElementSpawnEnemyDummy.produce
function ElementSpawnEnemyDummy:produce(params, ...)
	-- give assault-spawned beat cops fbi access to keep them from getting stuck
	if params and params.name then
		params.name = self:get_ponr_unit(params.name) or self:get_unit_alternative(params.name) or params.name

		local unit = produce_original(self, params, ...)
		local u_brain = alive(unit) and unit:brain()
		local logic_data = u_brain and u_brain._logic_data
		local replace_access = access_replacement[logic_data and logic_data.SO_access_str]
		local converted_access = replace_access and managers.navigation:convert_access_flag(replace_access)
		if converted_access then
			u_brain._SO_access = converted_access
			logic_data.SO_access = converted_access
			logic_data.SO_access_str = replace_access
		end

		return unit
	end

	if self._enemy_table then
		self._enemy_name = self:_process_enemy_tbl(self._enemy_table) or self._enemy_name
	end

	local original_enemy_name = self._enemy_name
	self._enemy_name = self:get_ponr_unit(original_enemy_name) or self:get_unit_alternative(original_enemy_name) or original_enemy_name

	local unit = produce_original(self, params, ...)

	self:_chk_is_sniper(unit)

	self._enemy_name = original_enemy_name

	return unit
end
