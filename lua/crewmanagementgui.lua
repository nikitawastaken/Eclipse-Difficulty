-- guh
local crew_abilities = {
	"crew_interact",
	"crew_inspire",
	"crew_scavenge",
	"crew_ai_ap_ammo",
	"crew_ai_carry_stacker",
}

function CrewManagementGui:previous_ability(henchman_index)
	local loadout = managers.blackmarket:henchman_loadout(henchman_index)
	local ability = loadout.ability
	local ability_index = ability and table.get_vector_index(crew_abilities, ability) or #crew_abilities + 1
	local map = self:_create_member_loadout_map("ability")
	local name = nil

	for index = ability_index - 1, 1, -1 do
		name = crew_abilities[index]

		if managers.blackmarket:is_crew_item_unlocked(name) and not map[name] then
			loadout.ability = name

			return self:reload()
		end
	end

	loadout.ability = nil

	return self:reload()
end

function CrewManagementGui:next_ability(henchman_index)
	local loadout = managers.blackmarket:henchman_loadout(henchman_index)
	local ability = loadout.ability
	local ability_index = ability and table.get_vector_index(crew_abilities, ability) or 0
	local map = self:_create_member_loadout_map("ability")
	local name = nil

	for index = ability_index + 1, #crew_abilities do
		name = crew_abilities[index]

		if managers.blackmarket:is_crew_item_unlocked(name) and not map[name] then
			loadout.ability = name

			return self:reload()
		end
	end

	loadout.ability = nil

	return self:reload()
end

function CrewManagementGui:populate_ability(henchman_index, data, gui)
	self:populate_custom("ability", henchman_index, tweak_data.upgrades.crew_ability_definitions, crew_abilities, data, gui)
end
