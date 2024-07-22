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

-- add fak health regen
function PlayerManager:health_regen()
	local health_regen = tweak_data.player.damage.HEALTH_REGEN
	health_regen = health_regen + self:temporary_upgrade_value("temporary", "wolverine_health_regen", 0)
	health_regen = health_regen + self:get_hostage_bonus_addend("health_regen")
	health_regen = health_regen + self:upgrade_value("player", "passive_health_regen", 0)
	health_regen = health_regen + self:temporary_upgrade_value("temporary", "first_aid_health_regen", 0)

	return health_regen
end

function PlayerManager:on_headshot_dealt()
	local t = Application:time()
	local player_unit = self:player_unit()
	local damage_ext = player_unit:character_damage()
	local has_hitman_ammo_refund = managers.player:has_enabled_cooldown_upgrade("cooldown", "hitman_ammo_refund")
	local weapon_unit = self:equipped_weapon_unit()
	local weapon = weapon_unit:base()
	local regen_armor_bonus = managers.player:upgrade_value("player", "headshot_regen_armor_bonus", 0)
	local meets_bullseye_conditions = weapon and weapon:is_category("snp") and regen_armor_bonus > 0

	if not player_unit then
		return
	end

	self._message_system:notify(Message.OnHeadShot, nil, nil)

	-- hitman refunds ammo on headshots
	if has_hitman_ammo_refund and variant ~= "melee" then
		managers.player:on_ammo_increase(1)
		managers.player:disable_cooldown_upgrade("cooldown", "hitman_ammo_refund")
	end

	-- make bullseye only work with sniper rifles, also make it work with non max armor
	if meets_bullseye_conditions then
		if damage_ext and damage_ext:armor_ratio() == 1 then
			self._on_headshot_dealt_t = 0
		else
			if self._on_headshot_dealt_t and t < self._on_headshot_dealt_t then
				return
			end
			self._on_headshot_dealt_t = t + (tweak_data.upgrades.on_headshot_dealt_cooldown or 0)
		end

		if damage_ext then
			damage_ext:restore_armor(regen_armor_bonus)
		end
	end
end

-- sleight of hand check for weapon category
function PlayerManager:_on_enter_shock_and_awe_event()
	local equipped_unit = self:get_current_state()._equipped_unit
	if
		not (
			equipped_unit:base():is_category("smg")
			or equipped_unit:base():is_category("lmg")
			or equipped_unit:base():is_category("minigun")
			or equipped_unit:base():is_category("flamethrower")
			or equipped_unit:base():is_category("bow")
		)
	then
		return
	end

	if not self._coroutine_mgr:is_running("automatic_faster_reload") then
		local data = self:upgrade_value("player", "automatic_faster_reload", nil)
		local is_grenade_launcher = equipped_unit:base():is_category("grenade_launcher")

		if data and equipped_unit and not is_grenade_launcher and (equipped_unit:base():fire_mode() == "auto" or equipped_unit:base():is_category("bow", "flamethrower")) then
			self._coroutine_mgr:add_and_run_coroutine(
				"automatic_faster_reload",
				PlayerAction.ShockAndAwe,
				self,
				data.target_enemies,
				data.max_reload_increase,
				data.min_reload_increase,
				data.penalty,
				data.min_bullets,
				equipped_unit
			)
		end
	end
end

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

-- Shotgun CQB
PlayerAction.ShotgunCQB = {
	Priority = 1,
	Function = function(player_manager, speed_bonus, max_stacks, max_time)
		local co = coroutine.running()
		local current_time = Application:time()
		local current_stacks = 1

		local function on_hit(unit, attack_data)
			local attacker_unit = attack_data.attacker_unit
			local variant = attack_data.variant

			if attacker_unit == player_manager:player_unit() and variant == "bullet" then
				current_stacks = current_stacks + 1

				if current_stacks <= max_stacks then
					player_manager:mul_to_property("shotguncqb", speed_bonus)
				end
			end
		end

		player_manager:mul_to_property("shotguncqb", speed_bonus)
		player_manager:register_message(Message.OnEnemyShot, co, on_hit)

		while current_time < max_time do
			current_time = Application:time()
			coroutine.yield(co)
		end

		player_manager:remove_property("shotguncqb")
		player_manager:unregister_message(Message.OnEnemyShot, co)
	end,
}

Hooks:PostHook(PlayerManager, "check_skills", "eclipse_check_skills", function(self)
	if self:has_category_upgrade("shotgun", "speed_stack_on_kill") then
		self._message_system:register(Message.OnEnemyShot, "shotguncqb", callback(self, self, "_on_enter_shotguncqb_event"))
	else
		self._message_system:unregister(Message.OnEnemyShot, "shotguncqb")
	end
end)

function PlayerManager:_on_enter_shotguncqb_event(unit, attack_data)
	local attacker_unit = attack_data.attacker_unit
	local variant = attack_data.variant

	if attacker_unit == self:player_unit() and variant == "bullet" and not self._coroutine_mgr:is_running("shotguncqb") and self:is_current_weapon_of_category("shotgun") then
		local data = self:upgrade_value("shotgun", "speed_stack_on_kill", 0)

		if data ~= 0 then
			self._coroutine_mgr:add_coroutine("shotguncqb", PlayerAction.ShotgunCQB, self, data.speed_bonus, data.max_stacks, Application:time() + data.max_time)
		end
	end
end

local old_speed_multiplier = PlayerManager.movement_speed_multiplier
function PlayerManager:movement_speed_multiplier(...)
	local multi = old_speed_multiplier(self, ...)
	multi = multi * managers.player:get_property("shotguncqb", 1)
	return multi
end

local old_skill_dodge = PlayerManager.skill_dodge_chance

function PlayerManager:skill_dodge_chance(...)
	local dodge = old_skill_dodge(self, ...)

	if self:player_unit() and self:has_category_upgrade("player", "dodge_health_ratio_multiplier") then
		local health_ratio = self:player_unit():character_damage():health_ratio() / 2
		local damage_health_ratio = self:get_damage_health_ratio(health_ratio, "dodge")

		dodge = dodge + self:upgrade_value("player", "dodge_health_ratio_multiplier", 0) * damage_health_ratio
	end

	return dodge
end

-- Reduce damage taken while inside of vehicles
local damage_reduction_skill_multiplier_original = PlayerManager.damage_reduction_skill_multiplier
function PlayerManager:damage_reduction_skill_multiplier(...)
	local dmg_reduction = damage_reduction_skill_multiplier_original(self, ...)

	local player = self:player_unit()
	if player and player:movement()._current_state_name == "driving" then
		dmg_reduction = dmg_reduction * 0.33
	end

	return dmg_reduction
end
