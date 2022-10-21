local old_upgrade_value = PlayerManager.upgrade_value

function PlayerManager:upgrade_value(category, upgrade, ...)
	local _upgrade_value = old_upgrade_value(self, category, upgrade, ...)
	if category == "player" and upgrade == "pick_up_ammo_multiplier" and self:has_category_upgrade("player", "addition_ammo_eclipse") then
		_upgrade_value = _upgrade_value + self:upgrade_value("player", "addition_ammo_eclipse", 0)
	end
	return _upgrade_value
end


-- hostage taker min hostages count
Hooks:OverrideFunction(PlayerManager, "get_hostage_bonus_addend", function(self, category)
	local hostages = managers.groupai and managers.groupai:state():hostage_count() or 0
	local minions = self:num_local_minions() or 0
	local addend = 0
	local hostage_max_num = tweak_data:get_raw_value("upgrades", "hostage_max_num", category)
	local hostage_min_sum = 0

	addend = addend + self:team_upgrade_value(category, "hostage_addend", 0)
	addend = addend + self:team_upgrade_value(category, "passive_hostage_addend", 0)
	addend = addend + self:upgrade_value("player", "passive_hostage_" .. category .. "_addend", 0)
	local local_player = self:local_player()

	if self:has_category_upgrade("player", "close_to_hostage_boost") and self._is_local_close_to_hostage then
		addend = addend * tweak_data.upgrades.hostage_near_player_multiplier
	end

	if self:has_category_upgrade("player", "joker_counts_for_hostage_boost") then
	hostages = hostages + minions
	end

	hostage_min_sum = hostage_min_sum + self:upgrade_value("player", "hostage_min_sum_taker", 0)
	if hostages >= hostage_min_sum then
		addend = addend + self:upgrade_value("player", "hostage_" .. category .. "_addend", 0)
	end

	if hostage_max_num then
		hostages = math.min(hostages, hostage_max_num)
	end

	return addend * hostages
end)


-- shotgun panic stuff
local on_killshot_old = PlayerManager.on_killshot
function PlayerManager:on_killshot(killed_unit, variant, headshot, weapon_id)
    on_killshot_old(self, killed_unit, variant, headshot, weapon_id)

    local has_shotgun_panic = managers.player:has_enabled_cooldown_upgrade("cooldown", "shotgun_panic_on_kill")
    if has_shotgun_panic and variant ~= "melee" then
        local equipped_unit = self:get_current_state()._equipped_unit:base()

        if equipped_unit:is_category("shotgun") then
            local pos = managers.player:player_unit():position()
            local skill = tweak_data.upgrades.values.shotgun.panic[1]

            if skill then
                local area = skill.area
                local chance = skill.chance
                local amount = skill.amount
                local enemies = World:find_units_quick("sphere", pos, area, managers.slot:get_mask("enemies"))

                for i, unit in ipairs(enemies) do
                    if unit:character_damage() then
                        unit:character_damage():build_suppression(amount, chance)
                    end
                end
            end

        managers.player:disable_cooldown_upgrade("cooldown", "shotgun_panic_on_kill")
        end
    end
end