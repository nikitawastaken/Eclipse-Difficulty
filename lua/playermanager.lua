Eclipse:require_lua("sidearmlamentricochet")

Hooks:PostHook(PlayerManager, "init", "eclipse_init", function(self)
	self._consecutive_headshots = 0
	self._charged_shot_allowed = false
	self._standstill_damage_reduction_active = false
	self._eclipse_bags_carried = 0
end)

-- Helper fuctions
function PlayerManager:get_bags_carried()
	return self._eclipse_bags_carried
end

function PlayerManager:subtract_bags_carried()
	self._eclipse_bags_carried = self._eclipse_bags_carried - 1
end

function PlayerManager:add_bags_carried()
	self._eclipse_bags_carried = self._eclipse_bags_carried + 1
end

function PlayerManager:charged_shot_allowed(is_allowed)
	self._charged_shot_allowed = is_allowed
end

function PlayerManager:is_charged_shot_allowed()
	return self._charged_shot_allowed
end

function PlayerManager:standstill_resistance_active(is_allowed)
	self._standstill_damage_reduction_active = is_allowed
end

function PlayerManager:is_standstill_resistance_active()
	return self._standstill_damage_reduction_active
end

function PlayerManager:is_lament_ricochet_allowed()
	return self:has_category_upgrade("player", "sidearm_ricochet_damage")
		and self:has_activate_temporary_upgrade("temporary", "sidearm_reload_damage_multiplier")
		and self:equipped_weapon_unit():base():is_category("revolver", "pistol")
end

function PlayerManager:is_wearing_a_ballistic_vest()
	local equipped_armor = managers.blackmarket:equipped_armor(true, true)
	return equipped_armor == "level_2" or equipped_armor == "level_3" or equipped_armor == "level_4"
end

function PlayerManager:max_following_hostages()
	return tweak_data.player.max_nr_following_hostages + self:upgrade_value("player", "extra_hostages", 0) + self:upgrade_value("player", "extra_hostages_chief", 0)
end

-- vanilla funcs needed to not crash
local function make_double_hud_string(a, b)
	return string.format("%01d|%01d", a, b)
end

local function add_hud_item(amount, icon)
	if #amount > 1 then
		managers.hud:add_item_from_string({
			amount_str = make_double_hud_string(amount[1], amount[2]),
			amount = amount,
			icon = icon,
		})
	else
		managers.hud:add_item({
			amount = amount[1],
			icon = icon,
		})
	end
end
-- end

Hooks:PostHook(PlayerManager, "update", "eclipse_update", function(self, t)
	local local_player = self:local_player()

	if self:has_category_upgrade("player", "near_teammate_damage_multiplier") and (not self._hostage_close_to_local_t or self._hostage_close_to_local_t <= t) then
		if self:has_category_upgrade("player", "near_teammate_damage_multiplier") then
			local near_teammate_distance = self:upgrade_value("player", "near_teammate_damage_multiplier", nil).range or 0
			self._is_local_close_to_criminal = alive(local_player) and managers.groupai and managers.groupai:state():is_a_criminal_within(local_player:movement():m_pos(), near_teammate_distance)
		end

		self._hostage_close_to_local_t = t + tweak_data.upgrades.hostage_near_player_check_t
	end
end)

-- Additional skills
Hooks:PostHook(PlayerManager, "check_skills", "eclipse_check_skills", function(self)
	-- Point Blank BASIC
	if self:has_category_upgrade("player", "speed_stack_on_kill") then
		self._message_system:register(Message.OnEnemyKilled, "playercqb", callback(self, self, "_on_enter_playercqb_event"))
	else
		self._message_system:unregister(Message.OnEnemyKilled, "playercqb")
	end

	-- Headshot Fury BASIC
	if self:has_category_upgrade("snp", "consecutive_headshots") then
		self:register_message(Message.OnWeaponFired, "consecutive_headshots", callback(self, self, "_on_enter_consecutive_headshots_event"))
	else
		self:unregister_message(Message.OnWeaponFired, "consecutive_headshots")
	end

	-- Hitman headshot killchain
	if self:has_category_upgrade("player", "chain_headshot_kills") then
		self:register_message(Message.OnLethalHeadShot, "chain_headshot_kills", callback(self, self, "_on_enter_chain_headshot_kills_event"))
	else
		self:unregister_message(Message.OnLethalHeadShot, "chain_headshot_kills")
	end

	-- Second Wind ACED
	if self:has_category_upgrade("cooldown", "dodge_replenish_armor") then
		self:register_message(Message.OnPlayerDodge, "dodge_replenish_armor", callback(self, self, "_dodge_replenish_armor"))
	else
		self:unregister_message(Message.OnPlayerDodge, "dodge_replenish_armor")
	end

	-- Sidearm Savvy ACED
	if self:has_category_upgrade("player", "sidearms_reload_primary") then
		self._message_system:register(Message.OnEnemyKilled, "sidearms_reload_primary", callback(self, self, "_on_sidearms_reload_primary_event"))
	else
		self._message_system:register(Message.OnEnemyKilled, "sidearms_reload_primary")
	end

	-- Trigger Overdrive BASIC
	if self:has_category_upgrade("pistol", "stacked_reload_bonus") then
		self:register_message(Message.OnEnemyShot, "stacked_reload_bonus", callback(self, self, "_on_expert_handling_reload_event"))
	else
		self:unregister_message(Message.OnEnemyShot, "stacked_reload_bonus")
	end

	-- Deadeye BASIC
	if self:has_category_upgrade("revolver", "headshot_chain_instant_reload") then
		self._deadeye_reload = self:upgrade_value("revolver", "headshot_chain_instant_reload", nil)

		self._message_system:register(Message.OnHeadShot, "deadeye_reload", callback(self, self, "_on_enter_deadeye_reload_event"))
	else
		self._deadeye_reload = nil

		self._message_system:unregister(Message.OnHeadShot, "deadeye_reload")
	end

	-- Deadeye ACED
	if self:has_category_upgrade("revolver", "headshot_chain_ammo_restore") then
		self._deadeye_ammo_restore = self:upgrade_value("revolver", "headshot_chain_ammo_restore", nil)

		self._message_system:register(Message.OnLethalHeadShot, "deadeye_ammo_restore", callback(self, self, "_on_enter_deadeye_ammo_restore_event"))
	else
		self._deadeye_ammo_restore = nil

		self._message_system:unregister(Message.OnLethalHeadShot, "deadeye_ammo_restore")
	end

	-- Peacemaker's Lament ACED
	if self:has_category_upgrade("player", "sidearm_ricochet_damage") then
		self:register_message(Message.OnWeaponFired, "sidearmlamentricochet", callback(SidearmLamentRicochet, SidearmLamentRicochet, "on_weapon_fired"))
	else
		self:unregister_message(Message.OnWeaponFired, "sidearmlamentricochet")
	end

	self:set_property("pistols_reload_primary_kills", 0)
end)

function PlayerManager:get_hostage_bonus_addend(category)
	local hostages = managers.groupai and managers.groupai:state():hostage_count() or 0
	local minions = self:num_local_minions() or 0
	local addend = 0
	local hostage_max_num = tweak_data:get_raw_value("upgrades", "hostage_max_num", category)
	local current_team_size = managers.groupai:state():_get_balancing_multiplier({ 1, 2, 3, 4 })

	-- "Converts count for hostage boosts" upgrade
	if self:has_category_upgrade("player", "convert_counts_as_hostage") then
		hostages = hostages + minions
	end

	if hostage_max_num then
		hostages = math.min(hostages, hostage_max_num)
	end

	if category ~= "health_regen" then
		addend = addend + self:team_upgrade_value(category, "hostage_addend", 0)
		addend = addend + self:team_upgrade_value(category, "passive_hostage_addend", 0)
		addend = addend + self:upgrade_value("player", "hostage_" .. category .. "_addend", 0)
		addend = addend + self:upgrade_value("player", "passive_hostage_" .. category .. "_addend", 0)
	else -- Hostage Taker rework
		hostages = math.min(hostages, current_team_size)
		addend = addend + self:upgrade_value("player", "hostage_health_regen_addend", 0) / current_team_size * hostages

		if self:has_category_upgrade("player", "close_to_hostage_boost") and self._is_local_close_to_hostage then
			addend = addend * tweak_data.upgrades.hostage_near_player_multiplier
		end
	end

	return addend * hostages
end

function PlayerManager:get_hostage_bonus_multiplier(category)
	local hostages = managers.groupai and managers.groupai:state():hostage_count() or 0
	local minions = self:num_local_minions() or 0
	local multiplier = 0
	hostages = hostages + minions
	local hostage_max_num = tweak_data:get_raw_value("upgrades", "hostage_max_num", category)

	if hostage_max_num then
		hostages = math.min(hostages, hostage_max_num)
	end

	if self:has_category_upgrade("player", "convert_counts_as_hostage") then
		hostages = hostages + minions
	end

	multiplier = multiplier + self:team_upgrade_value(category, "hostage_multiplier", 1) - 1
	multiplier = multiplier + self:team_upgrade_value(category, "passive_hostage_multiplier", 1) - 1
	multiplier = multiplier + self:upgrade_value("player", "hostage_" .. category .. "_multiplier", 1) - 1
	multiplier = multiplier + self:upgrade_value("player", "passive_hostage_" .. category .. "_multiplier", 1) - 1

	-- if self:has_category_upgrade("player", "close_to_hostage_boost") and self._is_local_close_to_hostage then
	-- 	multiplier = multiplier * tweak_data.upgrades.hostage_near_player_multiplier
	-- end

	return 1 + multiplier * hostages
end

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
	local player_unit = self:player_unit()

	if not player_unit then
		return
	end

	self._message_system:notify(Message.OnHeadShot, nil, nil)

	-- Anarchist on-headshot armor regen
	if managers.player:has_category_upgrade("player", "headshot_to_armor") then
		local headshot_to_armor_data = managers.player:upgrade_value("player", "headshot_to_armor", nil)
		local armor_data = tweak_data.blackmarket.armors[managers.blackmarket:equipped_armor(true, true)]

		if headshot_to_armor_data and armor_data then
			local idx = armor_data.upgrade_level
			self._damage_to_armor = {
				armor_value = headshot_to_armor_data[idx][1],
				target_tick = headshot_to_armor_data[idx][2],
				elapsed = 0,
			}
		end
	end

	local damage_ext = player_unit:character_damage()
	local has_headshot_regen_health = self:has_enabled_cooldown_upgrade("cooldown", "headshot_regen_health_bonus")
	local regen_health_bonus = tweak_data.upgrades.values.player.headshot_regen_health_bonus[1]

	if damage_ext and has_headshot_regen_health then
		damage_ext:restore_health(regen_health_bonus, true)
		self:disable_cooldown_upgrade("cooldown", "headshot_regen_health_bonus")
	end

	-- snp_charged_shot has to be put here because check_skills() is only called once at the initialization
	if self:has_category_upgrade("snp", "charged_shot") and self._charged_shot_allowed then
		self:register_message(Message.OnWeaponFired, "graze_damage", callback(SniperGrazeDamage, SniperGrazeDamage, "on_weapon_fired"))
	else
		self:unregister_message(Message.OnWeaponFired, "graze_damage")
	end
end

-- Ammo Efficiency rework (doesn't work on smgs, aced refunds straight into mag)
PlayerAction.AmmoEfficiency = {
	Priority = 1,
	Function = function(player_manager, target_headshots, bullet_refund, target_time)
		local co = coroutine.running()
		local time = Application:time()
		local headshots = 1

		local function on_weapon_fired(weapon_unit, result)
			if not result or not result.hit_enemy then
				time = target_time

				return
			end

			if result.rays then
				for _, hit in ipairs(result.rays) do
					local is_turret = hit.unit:in_slot(sentry_mask)
					local is_ally = hit.unit:in_slot(ally_mask)

					local result_hit = hit.damage_result
					local attack_data = result_hit and result_hit.attack_data
					if attack_data and attack_data.headshot and not is_turret and not is_ally then
						headshots = headshots + 1

						break
					else
						time = target_time

						return
					end
				end
			end

			if headshots >= target_headshots then
				player_manager:on_ammo_increase(bullet_refund)

				if player_manager:has_category_upgrade("player", "head_shot_ammo_return_straight_to_mag") then
					player_manager:on_ammo_increase_mag(bullet_refund)
				end

				time = target_time
			end
		end

		player_manager:register_message(Message.OnWeaponFired, co, on_weapon_fired)

		while time < target_time do
			time = Application:time()
			local weapon_unit = player_manager:equipped_weapon_unit()

			if weapon_unit and (weapon_unit:base():fire_mode() ~= "single" or not weapon_unit:base():is_category("dmr", "assault_rifle", "snp")) then
				break
			end

			coroutine.yield(co)
		end

		player_manager:unregister_message(Message.OnWeaponFired, co)
	end,
}

function PlayerManager:on_ammo_increase_mag(ammo)
	local equipped_unit = self:get_current_state()._equipped_unit:base()
	local equipped_selection = self:get_current_state()._ext_inventory:equipped_selection()

	if equipped_unit and equipped_unit:can_reload() then
		local index = self:equipped_weapon_index()

		equipped_unit:add_ammo_to_mag(ammo, index)
	end
end

function PlayerManager:_on_enter_ammo_efficiency_event()
	if not self._coroutine_mgr:is_running("ammo_efficiency") then
		local weapon_unit = self:equipped_weapon_unit()

		if weapon_unit and weapon_unit:base():fire_mode() == "single" and weapon_unit:base():is_category("dmr", "assault_rifle", "snp") then
			self._coroutine_mgr:add_coroutine(
				"ammo_efficiency",
				PlayerAction.AmmoEfficiency,
				self,
				self._ammo_efficiency.headshots,
				self._ammo_efficiency.ammo,
				Application:time() + self._ammo_efficiency.time
			)
		end
	end
end

-- Kilmer does not work on SMGs anymore
function PlayerManager:_on_activate_aggressive_reload_event(attack_data)
	if attack_data and attack_data.variant ~= "projectile" then
		local weapon_unit = self:equipped_weapon_unit()

		if weapon_unit then
			local weapon = weapon_unit:base()

			if weapon and weapon:fire_mode() == "single" and weapon:is_category("dmr", "assault_rifle", "snp") then
				self:activate_temporary_upgrade("temporary", "single_shot_fast_reload")
			end
		end
	end
end

-- sleight of hand check for weapon category
function PlayerManager:_on_enter_shock_and_awe_event()
	local equipped_unit = self:get_current_state()._equipped_unit
	if not equipped_unit:base():is_category("smg", "lmg", "minigun", "flamethrower", "bow") then
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

-- Killshot skills
local on_killshot_old = PlayerManager.on_killshot
function PlayerManager:on_killshot(killed_unit, variant, headshot, weapon_id)
	on_killshot_old(self, killed_unit, variant, headshot, weapon_id)
	local equipped_unit = self:get_current_state()._equipped_unit:base()

	-- Shotgun panic
	local has_shotgun_panic = self:has_enabled_cooldown_upgrade("cooldown", "shotgun_panic_on_kill")
	if has_shotgun_panic and variant ~= "melee" then
		if equipped_unit:is_category("shotgun") then
			local pos = self:player_unit():position()
			local skill = tweak_data.upgrades.values.shotgun.panic[1]

			if skill then
				local area = skill.area
				local chance = skill.chance
				local amount = skill.amount
				local enemies = World:find_units_quick("sphere", pos, area, managers.slot:get_mask("enemies"))

				for _, unit in ipairs(enemies) do
					if unit:character_damage() then
						unit:character_damage():build_suppression(amount, chance)
					end
				end
			end

			self:disable_cooldown_upgrade("cooldown", "shotgun_panic_on_kill")
		end
	end

	local has_socio_melee_armor = self:has_enabled_cooldown_upgrade("cooldown", "melee_kill_armor_leech")
	if variant == "melee" and has_socio_melee_armor then
		local damage_ext = self:player_unit():character_damage()
		local skill = tweak_data.upgrades.values.player.melee_kill_armor_regen[1] or 0

		if damage_ext and skill > 0 then
			damage_ext:restore_armor(skill)
		end

		self:disable_cooldown_upgrade("cooldown", "melee_kill_armor_leech")
	end
end

-- On-kill player speed-up
PlayerAction.PlayerCQB = {
	Priority = 1,
	Function = function(player_manager, speed_bonus, max_stacks, max_time)
		local co = coroutine.running()
		local current_time = Application:time()
		local current_stacks = 1

		local function on_kill(weapon_unit, variant)
			if variant == "bullet" then
				current_stacks = current_stacks + 1

				if current_stacks <= max_stacks then
					player_manager:add_to_property("playercqb", speed_bonus)
				end
			end
		end

		player_manager:add_to_property("playercqb", speed_bonus)
		player_manager:register_message(Message.OnEnemyKilled, co, on_kill)

		while current_time < max_time do
			current_time = Application:time()
			coroutine.yield(co)
		end

		player_manager:remove_property("playercqb")
		player_manager:unregister_message(Message.OnEnemyKilled, co)
	end,
}

function PlayerManager:_on_enter_playercqb_event(weapon_unit, variant)
	if variant == "bullet" and not self._coroutine_mgr:is_running("playercqb") then
		local data = self:upgrade_value("player", "speed_stack_on_kill", 0)

		if data ~= 0 then
			self._coroutine_mgr:add_coroutine("playercqb", PlayerAction.PlayerCQB, self, data.speed_bonus, data.max_stacks, Application:time() + data.max_time)
		end
	end
end

-- Hitman headshot kills chain
PlayerAction.JohnWickKillChain = {
	Priority = 1,
	Function = function(player_manager, target_kills, target_time)
		local co = coroutine.running()
		local time = Application:time()
		local kills = 1
		local has_chain_dodge = player_manager:has_category_upgrade("temporary", "chain_headshot_dodge")
		local cheat_death_upgrade_value = player_manager:upgrade_value("player", "cheat_death_inc", 0)

		local function on_lethal_headshot(attack_data)
			local attacker_unit = attack_data.attacker_unit
			local variant = attack_data.variant

			if attacker_unit == player_manager:player_unit() and variant == "bullet" then
				kills = kills + 1

				if kills == target_kills then
					if has_chain_dodge then
						player_manager:activate_temporary_upgrade("temporary", "chain_headshot_dodge")
					end

					if cheat_death_upgrade_value ~= 0 then
						player_manager:add_to_property("chain_headshot_cheat_death", cheat_death_upgrade_value)
					end

					time = target_time
				end
			end
		end

		player_manager:register_message(Message.OnLethalHeadShot, co, on_lethal_headshot)

		while time < target_time do
			time = Application:time()

			coroutine.yield(co)
		end

		player_manager:unregister_message(Message.OnLethalHeadShot, co)
	end,
}

function PlayerManager:_on_enter_chain_headshot_kills_event(attack_data)
	local attacker_unit = attack_data.attacker_unit
	local variant = attack_data.variant

	if attacker_unit == self:player_unit() and variant == "bullet" and not self._coroutine_mgr:is_running("johnwick_kill_chain") then
		local data = self:upgrade_value("player", "chain_headshot_kills", 0)

		if data ~= 0 then
			self._coroutine_mgr:add_coroutine("johnwick_kill_chain", PlayerAction.JohnWickKillChain, self, data.headshot_kills, Application:time() + data.max_time)
		end
	end
end

-- Sniper Rifle headshot chain damage multiplier
function PlayerManager:_on_enter_consecutive_headshots_event(weapon_unit, result)
	local upgrade_value = self:upgrade_value("snp", "consecutive_headshots")

	if not alive(weapon_unit) or weapon_unit ~= self:equipped_weapon_unit() then
		return
	end

	local player_unit = self:player_unit()
	if not player_unit then
		return
	end

	if not weapon_unit:base():is_category("snp") or not result.hit_enemy then
		self._consecutive_headshots = 0
		self:remove_property("snp_consecutive_headshots_mul")
		return
	end

	if self._consecutive_headshots < upgrade_value.max_headshots then
		self:add_to_property("snp_consecutive_headshots_mul", upgrade_value.damage_mul_addend)
	end

	--[[
	Eclipse:log_chat("dmg mul - x" .. (1 + self:get_property("snp_consecutive_headshots_mul", 0)))
	Eclipse:log_chat("headshot #" .. self._consecutive_headshots)
	]]

	local sentry_mask = managers.slot:get_mask("sentry_gun")
	local ally_mask = managers.slot:get_mask("all_criminals")

	for _, hit in ipairs(result.rays) do
		local is_turret = hit.unit:in_slot(sentry_mask)
		local is_ally = hit.unit:in_slot(ally_mask)

		local result_hit = hit.damage_result
		local attack_data = result_hit and result_hit.attack_data
		if attack_data and attack_data.headshot and not is_turret and not is_ally then
			self._consecutive_headshots = self._consecutive_headshots + 1
			break
		else
			self._consecutive_headshots = 0
			self:remove_property("snp_consecutive_headshots_mul")
		end
	end
end

function PlayerManager:on_enter_custody(_player, already_dead)
	local player = _player or self:player_unit()

	if not player then
		Application:error("[PlayerManager:on_enter_custody] Unable to get player")

		return
	end

	if player == self:player_unit() then
		local equipped_grenade = managers.blackmarket:equipped_grenade()

		if equipped_grenade and tweak_data.blackmarket.projectiles[equipped_grenade] and tweak_data.blackmarket.projectiles[equipped_grenade].ability then
			self:reset_ability_hud()
		end

		self:set_property("copr_risen_cooldown_added", nil)
	end

	managers.mission:call_global_event("player_in_custody")

	local peer_id = managers.network:session():local_peer():id()

	if self._super_syndrome_count and self._super_syndrome_count > 0 and not self._action_mgr:is_running("stockholm_syndrome_trade") then
		self._action_mgr:add_action("stockholm_syndrome_trade", StockholmSyndromeTradeAction:new(player:position(), peer_id))
	end

	-- For some reason we can't use posthook here just to add these 2 lines, it just doesn't work
	self._consecutive_headshots = 0
	self:remove_property("snp_consecutive_headshots_mul")

	self:force_drop_carry()
	managers.statistics:downed({
		death = true,
	})

	if not already_dead then
		player:network():send("sync_player_movement_state", "dead", player:character_damage():down_time(), player:id())
		managers.groupai:state():on_player_criminal_death(peer_id)
	end

	self._listener_holder:call(self._custody_state, player)
	game_state_machine:change_state_by_name("ingame_waiting_for_respawn")
	player:character_damage():set_invulnerable(true)
	player:character_damage():set_health(0)
	player:base():_unregister()
	World:delete_unit(player)
	managers.hud:remove_interact()
end

-- Put dodge armor replenish on cooldown
function PlayerManager:_dodge_replenish_armor()
	local has_dodge_armor_replenish = self:has_enabled_cooldown_upgrade("cooldown", "dodge_replenish_armor")
	local player_dmg = self:player_unit():character_damage()
	local armor_broken = player_dmg:_max_armor() > 0 and player_dmg:get_real_armor() <= 0

	if has_dodge_armor_replenish and armor_broken then
		player_dmg:_regenerate_armor()

		self:disable_cooldown_upgrade("cooldown", "dodge_replenish_armor")
	end
end

local old_speed_multiplier = PlayerManager.movement_speed_multiplier
function PlayerManager:movement_speed_multiplier(...)
	local multi = old_speed_multiplier(self, ...)
	multi = multi * (1 + managers.player:get_property("playercqb", 0))
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

	dodge = dodge + self:temporary_upgrade_value("temporary", "chain_headshot_dodge", 0)
	dodge = dodge + self:temporary_upgrade_value("temporary", "dodge_outnumbered", 0)
	dodge = dodge + self:temporary_upgrade_value("temporary", "unseen_dodge", 0)

	for _, smoke_screen in ipairs(self._smoke_screen_effects or {}) do
		if smoke_screen:is_in_smoke(self:player_unit()) then
			dodge = dodge + (smoke_screen:dodge_bonus() and self:upgrade_value("player", "smoke_screen_dodge_add", 0))
		end
	end

	return dodge
end

local old_skill_armor_regen = PlayerManager.body_armor_regen_multiplier
function PlayerManager:body_armor_regen_multiplier(...)
	local armor_regen = old_skill_armor_regen(self, ...)

	for _, smoke_screen in ipairs(self._smoke_screen_effects or {}) do
		if smoke_screen:is_in_smoke(self:player_unit()) then
			armor_regen = armor_regen * (smoke_screen:armor_bonus() and self:upgrade_value("player", "smoke_screen_armor_regen_mul", 1) or 1)
		end
	end

	return armor_regen
end

-- Sicario smoke bomb buffs
function PlayerManager:spawn_smoke_screen(position, normal, grenade_unit, has_armor_bonus, has_dodge_bonus, linger_bonus)
	local time = tweak_data.projectiles.smoke_screen_grenade.duration
	self._smoke_screen_effects = self._smoke_screen_effects or {}

	table.insert(self._smoke_screen_effects, SmokeScreenEffect:new(position, normal, time, has_armor_bonus, has_dodge_bonus, linger_bonus, grenade_unit))

	if alive(self._smoke_grenade) and Network:is_server() then
		self._smoke_grenade:set_slot(0)
	end

	self._smoke_grenade = grenade_unit
end

-- Damage reduction skills
local damage_reduction_skill_multiplier_original = PlayerManager.damage_reduction_skill_multiplier
function PlayerManager:damage_reduction_skill_multiplier(damage_type)
	local multiplier = damage_reduction_skill_multiplier_original(self, damage_type)

	-- Reduce damage taken while inside of vehicles
	local player = self:player_unit()
	if player and player:movement()._current_state_name == "driving" then
		multiplier = multiplier * 0.33
	end

	-- crook ballistic vest hp dmg reduction
	if self:has_category_upgrade("player", "bv_health_damage_reduction") and self:is_wearing_a_ballistic_vest() and player:character_damage():get_real_armor() <= 0 then
		multiplier = multiplier * self:upgrade_value("player", "bv_health_damage_reduction", 1)
	end

	-- armorer full armor dmg reduction
	if self:has_category_upgrade("player", "armor_threshold_damage_multiplier") then
		local skill = self:upgrade_value("player", "armor_threshold_damage_multiplier", 0)

		if skill ~= 0 and player:character_damage():armor_ratio() >= skill.armor_threshold then
			multiplier = multiplier * skill.damage_multiplier
		end
	end

	-- tactician standing near teammate dmg reduction
	if self:has_category_upgrade("player", "near_teammate_damage_multiplier") and self._is_local_close_to_criminal then
		local skill = self:upgrade_value("player", "near_teammate_damage_multiplier", nil)

		multiplier = multiplier * (skill.mul or 1)
	end

	-- blast shield explosive dmg reduction
	if self:has_category_upgrade("player", "explosive_damage_multiplier") and damage_type == "explosion" then
		multiplier = multiplier * self:upgrade_value("player", "explosive_damage_multiplier", 1)
	end

	-- impact padding standstill dmg reduction
	if self:is_standstill_resistance_active() and self:has_category_upgrade("player", "stationary_damage_multiplier") then
		multiplier = multiplier * self:upgrade_value("player", "stationary_damage_multiplier", 1)
	end

	-- impact padding armor regen dmg reduction
	if self:has_activate_temporary_upgrade("temporary", "armor_regen_damage_multiplier") then
		multiplier = multiplier * self:temporary_upgrade_value("temporary", "armor_regen_damage_multiplier", 1)
	end

	-- stockholm syndrome per-hostage dmg reduction
	if self:has_category_upgrade("player", "hostage_damage_reduction_addend") then
		multiplier = multiplier * (1 - self:get_hostage_bonus_addend("damage_reduction"))
		--Eclipse:log_chat(1 - self:get_hostage_bonus_addend("damage_reduction"))
	end

	return multiplier
end

-- Carry stacker start
function PlayerManager:drop_carry(zipline_unit)
	local carry_list = self:get_my_carry_data()
	if not carry_list or #carry_list < 1 then
		return
	end

	local carry_data = carry_list[#carry_list]

	self._carry_blocked_cooldown_t = Application:time() + 1.2 + math.rand(0.3)
	local player = self:player_unit()

	if player then
		player:sound():play("Play_bag_generic_throw", nil, false)
		player:movement():current_state():remove_tweak_data(tweak_data.carry[carry_data.carry_id].type)
	end

	local camera_ext = player:camera()
	local dye_initiated = carry_data.dye_initiated
	local has_dye_pack = carry_data.has_dye_pack
	local dye_value_multiplier = carry_data.dye_value_multiplier
	local throw_distance_multiplier_upgrade_level = managers.player:upgrade_level("carry", "throw_distance_multiplier", 0)
	local position = camera_ext:position()
	local rotation = camera_ext:rotation()
	local forward = player:camera():forward()

	if _G.IS_VR then
		local active_hand = player:hand():get_active_hand("bag")

		if active_hand then
			position = active_hand:position()
			rotation = active_hand:rotation()
			forward = rotation:y()
		end
	end

	local state = self:player_unit():movement():current_state()
	local penalty = 0.5
	local movement_z = state._is_jumping and (state._last_sent_jump_vec * penalty) or Vector3(0, 0, 0)
	local movement_xy = state._last_velocity_xy * penalty
	local movement = movement_z + movement_xy

	if Network:is_client() then
		managers.network:session():send_to_host(
			"server_drop_carry",
			carry_data.carry_id,
			carry_data.multiplier,
			dye_initiated,
			has_dye_pack,
			dye_value_multiplier,
			position,
			rotation,
			forward,
			throw_distance_multiplier_upgrade_level,
			zipline_unit,
			movement
		)
	else
		self:server_drop_carry(
			carry_data.carry_id,
			carry_data.multiplier,
			dye_initiated,
			has_dye_pack,
			dye_value_multiplier,
			position,
			rotation,
			forward,
			throw_distance_multiplier_upgrade_level,
			zipline_unit,
			movement,
			managers.network:session():local_peer()
		)
	end

	self:subtract_bags_carried()
	if self._eclipse_bags_carried < 1 then
		managers.hud:remove_teammate_carry_info(HUDManager.PLAYER_PANEL)
		managers.hud:temp_hide_carry_bag()

		if self._current_state == "carry" then
			managers.player:set_player_state("standard")
		end
	end

	self:update_removed_synced_carry_to_peers()
end

function PlayerManager:set_synced_carry(peer, carry_id, multiplier, dye_initiated, has_dye_pack, dye_value_multiplier)
	local peer_id = peer:id()
	self._global.synced_carry[peer_id] = self._global.synced_carry[peer_id] or {}
	table.insert(self._global.synced_carry[peer_id], {
		carry_id = carry_id,
		multiplier = multiplier,
		dye_initiated = dye_initiated,
		has_dye_pack = has_dye_pack,
		dye_value_multiplier = dye_value_multiplier,
	})

	local character_data = managers.criminals:character_data_by_peer_id(peer_id)

	if character_data and character_data.panel_id then
		managers.hud:set_teammate_carry_info(character_data.panel_id, carry_id, managers.loot:get_real_value(carry_id, multiplier))
	end

	managers.hud:set_name_label_carry_info(peer_id, carry_id, managers.loot:get_real_value(carry_id, multiplier))

	local local_peer_id = managers.network:session():local_peer():id()

	if peer_id ~= local_peer_id then
		local unit = peer:unit()

		if alive(unit) then
			unit:movement():set_visual_carry(carry_id)
		end
	end
end

function PlayerManager:remove_synced_carry(peer)
	local peer_id = peer:id()

	if not self._global.synced_carry[peer_id] or #self._global.synced_carry[peer_id] < 1 then
		return
	end

	-- remove most recently added bag
	table.remove(self._global.synced_carry[peer_id], #self._global.synced_carry[peer_id])

	local no_bags_carried = self._global.synced_carry[peer_id] and #self._global.synced_carry[peer_id] < 1
	local character_data = managers.criminals:character_data_by_peer_id(peer_id)

	if character_data and character_data.panel_id and no_bags_carried then
		managers.hud:remove_teammate_carry_info(character_data.panel_id)
	end

	if no_bags_carried then
		managers.hud:remove_name_label_carry_info(peer_id)

		local local_peer_id = managers.network:session():local_peer():id()

		if peer_id ~= local_peer_id then
			local unit = peer:unit()

			if alive(unit) then
				unit:movement():set_visual_carry(nil)
			end
		end
	else
		local local_peer_id = managers.network:session():local_peer():id()

		local next_carry_id = self._global.synced_carry[peer_id][1] and self._global.synced_carry[peer_id][1].carry_id
		if peer_id ~= local_peer_id and alive(peer:unit()) then
			peer:unit():movement():set_visual_carry(next_carry_id)
		end
	end
end

function PlayerManager:update_carry_to_peer(peer)
	local peer_id = managers.network:session():local_peer():id()

	local carry_idx = self._global.synced_carry[peer_id] and #self._global.synced_carry[peer_id]
	if carry_idx and self._global.synced_carry[peer_id][carry_idx] then
		local carry_id = self._global.synced_carry[peer_id][carry_idx].carry_id
		local multiplier = self._global.synced_carry[peer_id][carry_idx].multiplier
		local dye_initiated = self._global.synced_carry[peer_id][carry_idx].dye_initiated
		local has_dye_pack = self._global.synced_carry[peer_id][carry_idx].has_dye_pack
		local dye_value_multiplier = self._global.synced_carry[peer_id][carry_idx].dye_value_multiplier

		peer:send_queued_sync("sync_carry", carry_id, multiplier, dye_initiated, has_dye_pack, dye_value_multiplier)
	end
end

function PlayerManager:server_drop_carry(
	carry_id,
	carry_multiplier,
	dye_initiated,
	has_dye_pack,
	dye_value_multiplier,
	position,
	rotation,
	dir,
	throw_distance_multiplier_upgrade_level,
	zipline_unit,
	movement,
	peer
)
	if not self:verify_carry(peer, carry_id) then
		return
	end

	local unit_name = tweak_data.carry[carry_id].unit or "units/payday2/pickups/gen_pku_lootbag/gen_pku_lootbag"
	local unit = World:spawn_unit(Idstring(unit_name), position, rotation)
	movement = movement or Vector(0, 0, 0)

	managers.network:session():send_to_peers_synched(
		"sync_carry_data",
		unit,
		carry_id,
		carry_multiplier,
		dye_initiated,
		has_dye_pack,
		dye_value_multiplier,
		position,
		dir,
		throw_distance_multiplier_upgrade_level,
		zipline_unit,
		movement,
		peer and peer:id() or 0
	)
	self:sync_carry_data(
		unit,
		carry_id,
		carry_multiplier,
		dye_initiated,
		has_dye_pack,
		dye_value_multiplier,
		position,
		dir,
		throw_distance_multiplier_upgrade_level,
		zipline_unit,
		movement,
		peer and peer:id() or 0
	)

	if unit:carry_data()._global_event then
		managers.mission:call_global_event(unit:carry_data()._global_event)
	end

	return unit
end

function PlayerManager:sync_carry_data(
	unit,
	carry_id,
	carry_multiplier,
	dye_initiated,
	has_dye_pack,
	dye_value_multiplier,
	position,
	dir,
	throw_distance_multiplier_upgrade_level,
	zipline_unit,
	movement,
	peer_id
)
	local throw_distance_multiplier = self:upgrade_value_by_level("carry", "throw_distance_multiplier", throw_distance_multiplier_upgrade_level, 1)
	local carry_type = tweak_data.carry[carry_id].type
	throw_distance_multiplier = throw_distance_multiplier * tweak_data.carry.types[carry_type].throw_distance_multiplier
	local mutator = nil

	if managers.mutators:is_mutator_active(MutatorPiggyRevenge) then
		mutator = managers.mutators:get_mutator(MutatorPiggyRevenge)
	end

	if mutator and mutator.get_bag_throw_multiplier then
		throw_distance_multiplier = throw_distance_multiplier * mutator:get_bag_throw_multiplier(carry_id)
	end

	unit:carry_data():set_carry_id(carry_id)
	unit:carry_data():set_multiplier(carry_multiplier)
	unit:carry_data():set_value(managers.money:get_bag_value(carry_id, carry_multiplier))
	unit:carry_data():set_dye_pack_data(dye_initiated, has_dye_pack, dye_value_multiplier)
	unit:carry_data():set_latest_peer_id(peer_id)

	if alive(zipline_unit) then
		zipline_unit:zipline():attach_bag(unit)
	else
		movement = movement or Vector(0, 0, 0)
		unit:push(100, dir * 600 * throw_distance_multiplier + movement)
	end

	unit:interaction():register_collision_callbacks()
end

function PlayerManager:peer_dropped_out(peer)
	local peer_id = peer:id()
	local peer_unit = peer:unit()

	if Network:is_server() then
		self:transfer_special_equipment(peer_id, true, true)

		if self._global.synced_carry[peer_id] and self._global.synced_carry[peer_id].approved then
			for _, data in ipairs(self._global.synced_carry[peer_id]) do
				local carry_id = data.carry_id
				local carry_multiplier = data.multiplier
				local dye_initiated = data.dye_initiated
				local has_dye_pack = data.has_dye_pack
				local dye_value_multiplier = data.dye_value_multiplier
				local position = Vector3()

				if alive(peer_unit) then
					if peer_unit:movement():zipline_unit() then
						position = peer_unit:movement():zipline_unit():position()
					else
						position = peer_unit:position()
					end
				end

				local dir = Vector3(0, 0, 0)

				self:server_drop_carry(carry_id, carry_multiplier, dye_initiated, has_dye_pack, dye_value_multiplier, position, Rotation(), dir, 0, nil, peer)
			end
		end

		local turret_unit = self:get_player_turret_for_peer(peer_id)

		if turret_unit then
			self:server_player_turret_action(PlayerTurretBase.INTERACT_EXIT, turret_unit, peer_id, peer_unit)
		end
	end

	self._global.synced_equipment_possession[peer_id] = nil
	self._global.synced_equipment_possession_waiting[peer_id] = nil
	self._global.synced_deployables[peer_id] = nil
	self._global.synced_cable_ties[peer_id] = nil
	self._global.synced_grenades[peer_id] = nil
	self._global.synced_ammo_info[peer_id] = nil
	self._global.synced_carry[peer_id] = {}
	self._global.synced_team_upgrades[peer_id] = nil
	self._global.synced_bipod[peer_id] = nil
	self._global.synced_cocaine_stacks[peer_id] = nil

	self:update_cocaine_hud()
	self:remove_from_player_list(peer_unit)
	managers.vehicle:remove_player_from_all_vehicles(peer_unit)
end

function PlayerManager:bank_carry(carry_data)
	if not carry_data then
		local carry_list = self:get_my_carry_data()
		carry_data = carry_list[#carry_list]
	end
	local peer_id = managers.network:session() and managers.network:session():local_peer():id()

	managers.loot:secure(carry_data.carry_id, carry_data.multiplier, nil, peer_id)
	managers.hud:remove_teammate_carry_info(HUDManager.PLAYER_PANEL)
	managers.hud:temp_hide_carry_bag()
	self:update_removed_synced_carry_to_peers()
	managers.player:set_player_state("standard")
end

function PlayerManager:force_drop_carry()
	local carry_list = self:get_my_carry_data()
	local carry_data = carry_list and carry_list[#carry_list]

	if not carry_data then
		return
	end

	local player = self:player_unit()

	if not alive(player) then
		print("COULDN'T FORCE DROP! DIDN'T HAVE A UNIT")

		return
	end

	local dye_initiated = carry_data.dye_initiated
	local has_dye_pack = carry_data.has_dye_pack
	local dye_value_multiplier = carry_data.dye_value_multiplier
	local camera_ext = player:camera()

	if Network:is_client() then
		managers.network:session():send_to_host(
			"server_drop_carry",
			carry_data.carry_id,
			carry_data.multiplier,
			dye_initiated,
			has_dye_pack,
			dye_value_multiplier,
			camera_ext:position(),
			camera_ext:rotation(),
			Vector3(0, 0, 0),
			0,
			nil
		)
	else
		self:server_drop_carry(
			carry_data.carry_id,
			carry_data.multiplier,
			dye_initiated,
			has_dye_pack,
			dye_value_multiplier,
			camera_ext:position(),
			camera_ext:rotation(),
			Vector3(0, 0, 0),
			0,
			nil,
			managers.network:session():local_peer()
		)
	end

	managers.hud:remove_teammate_carry_info(HUDManager.PLAYER_PANEL)
	managers.hud:temp_hide_carry_bag()
	self:update_removed_synced_carry_to_peers()
end

function PlayerManager:clear_carry(soft_reset)
	local carry_list = self:get_my_carry_data()
	local carry_data = carry_list and carry_list[#carry_list]

	if not carry_data then
		return
	end

	local player = self:player_unit()

	if not soft_reset and not alive(player) then
		print("COULDN'T FORCE DROP! DIDN'T HAVE A UNIT")

		return
	end

	managers.hud:remove_teammate_carry_info(HUDManager.PLAYER_PANEL)
	managers.hud:temp_hide_carry_bag()
	self:update_removed_synced_carry_to_peers()
	self:subtract_bags_carried()

	if self._current_state == "carry" then
		managers.player:set_player_state("standard")
	end
end

function PlayerManager:is_carrying()
	return self:get_my_carry_data() and (#self:get_my_carry_data() > 0) or false
end

function PlayerManager:current_carry_id()
	local my_carry_data = self:get_my_carry_data()
	local id_list = {}

	if not my_carry_data then
		return
	end

	if my_carry_data[1] then
		table.insert(id_list, my_carry_data[1].carry_id)
	end
	if my_carry_data[2] then
		table.insert(id_list, my_carry_data[2].carry_id)
	end

	return id_list
end

-- If the dye pack feature gets used, modify this
-- attack_data
function PlayerManager:check_damage_carry()
	local carry_list = self:get_my_carry_data()

	local carry_data = carry_list and carry_list[1]
	if carry_data then
		local carry_id = carry_data.carry_id
		local type = tweak_data.carry[carry_id].type

		if tweak_data.carry.types[type].looses_value then
			local dye_initiated = carry_data.dye_initiated
			local has_dye_pack = carry_data.has_dye_pack
			local dye_value_multiplier = carry_data.dye_value_multiplier

			self:update_synced_carry_to_peers(carry_id, carry_data.multiplier, dye_initiated, has_dye_pack, dye_value_multiplier)
			managers.hud:set_teammate_carry_info(HUDManager.PLAYER_PANEL, carry_id, managers.loot:get_real_value(carry_id, carry_data.multiplier))
		end
	end

	carry_data = carry_list and carry_list[2]
	if carry_data then
		local carry_id = carry_data.carry_id
		local type = tweak_data.carry[carry_id].type

		if tweak_data.carry.types[type].looses_value then
			local dye_initiated = carry_data.dye_initiated
			local has_dye_pack = carry_data.has_dye_pack
			local dye_value_multiplier = carry_data.dye_value_multiplier

			self:update_synced_carry_to_peers(carry_id, carry_data.multiplier, dye_initiated, has_dye_pack, dye_value_multiplier)
			managers.hud:set_teammate_carry_info(HUDManager.PLAYER_PANEL, carry_id, managers.loot:get_real_value(carry_id, carry_data.multiplier))
		end
	end
end

function PlayerManager:_enter_vehicle(vehicle, peer_id, player, seat_name)
	if not alive(player) or not alive(vehicle) then
		return
	end

	self._global.synced_vehicle_data[peer_id] = {
		vehicle_unit = vehicle,
		seat = seat_name,
	}
	local vehicle_ext = vehicle:vehicle_driving()

	vehicle_ext:place_player_on_seat(player, seat_name)
	player:kill_mover()

	local seat = vehicle_ext:find_seat_for_player(player)
	local rot = seat.object:rotation()

	player:set_rotation(rot)

	vehicle:link(Idstring(VehicleDrivingExt.SEAT_PREFIX .. seat_name), player)

	if self:local_player() == player then
		if self:is_carrying() then
			vehicle_ext = vehicle:vehicle_driving()
			local secure_carry_on_enter = vehicle_ext and vehicle_ext.secure_carry_on_enter

			local carry_list = self:get_my_carry_data()
			local carry_data = carry_list and carry_list[1]
			if carry_data then
				local carry_tweak_data = tweak_data.carry[carry_data.carry_id]
				local skip_exit_secure = carry_tweak_data and carry_tweak_data.skip_exit_secure

				if secure_carry_on_enter and not skip_exit_secure then
					self:bank_carry(carry_data)
				end
			end

			carry_list = self:get_my_carry_data()
			carry_data = carry_list and carry_list[2]
			if carry_data then
				local carry_tweak_data = tweak_data.carry[carry_data.carry_id]
				local skip_exit_secure = carry_tweak_data and carry_tweak_data.skip_exit_secure

				if secure_carry_on_enter and not skip_exit_secure then
					self:bank_carry(carry_data)
				end
			end
		end

		self:set_player_state("driving")
	end

	managers.hud:update_vehicle_label_by_id(vehicle:unit_data().name_label_id, vehicle_ext:_number_in_the_vehicle())
	managers.vehicle:on_player_entered_vehicle(vehicle, player)
end

Hooks:PostHook(PlayerManager, "set_carry", "eclipse_pm_set_carry", function(self, carry_id)
	local player = self:player_unit()

	if not player then
		return
	end

	self:add_bags_carried()
	local carry_data = tweak_data.carry[carry_id]
	local carry_type = carry_data.type
	player:movement():current_state():add_tweak_data(carry_type)
end)

Hooks:PostHook(PlayerManager, "set_player_state", "eclipse_pm_set_player_state", function(self, state)
	state = state or self._current_state
	if state == "standard" and self._eclipse_bags_carried > 0 then
		state = "carry"
	end

	if state ~= self._current_state then
		self._current_state = state
		self:_change_player_state()
	end
end)
-- Carry stacker end

-- Adapt a call for new params
function PlayerManager:clbk_super_syndrome_respawn(data)
	local trade_manager = managers.trade
	self._clbk_super_syndrome_respawn = nil
	local best_hostage = trade_manager:get_best_hostage(data.pos, true)
	local criminal = trade_manager:get_criminal_by_peer(data.peer_id)

	if criminal and best_hostage then
		local pos = best_hostage.unit:position()
		local rot = best_hostage.unit:rotation()

		trade_manager:criminal_respawn(pos, rot, criminal)
		trade_manager:begin_hostage_trade(pos, rot, best_hostage, true, true, true, true)
	end
end

-- Players receive penalties when leaving custody
Hooks:PostHook(PlayerManager, "_internal_load", "hits_internal_load", function(self)
	if self._respawn then
		local player_unit = managers.player:player_unit()
		local ammo_confiscated = tweak_data.player.damage.custody_ammo_confiscated
		local health_drained = player_unit:character_damage():_max_health() * (1 - tweak_data.player.damage.custody_health_drained)

		if player_unit then
			if ammo_confiscated then
				local first_base_ext = player_unit:inventory():unit_by_selection(1):base()
				local second_base_ext = player_unit:inventory():unit_by_selection(2):base()

				first_base_ext:remove_ammo_from_pool(ammo_confiscated)
				second_base_ext:remove_ammo_from_pool(ammo_confiscated)
			end

			if health_drained then
				player_unit:character_damage():change_health(-health_drained)
			end
		end
	end
end)

-- Anarchist armor multipliers
function PlayerManager:body_armor_skill_multiplier(override_armor)
	local multiplier = 1
	multiplier = multiplier + self:upgrade_value("player", "tier_armor_multiplier", 1) - 1
	multiplier = multiplier + self:upgrade_value("player", "passive_armor_multiplier", 1) - 1
	multiplier = multiplier + self:upgrade_value("player", "armor_multiplier", 1) - 1
	multiplier = multiplier + self:team_upgrade_value("armor", "multiplier", 1) - 1
	multiplier = multiplier + self:get_hostage_bonus_multiplier("armor") - 1
	multiplier = multiplier + self:upgrade_value("player", "perk_armor_loss_multiplier", 1) - 1
	multiplier = multiplier + self:upgrade_value("player", tostring(override_armor or managers.blackmarket:equipped_armor(true, true)) .. "_armor_multiplier", 1) - 1
	multiplier = multiplier + self:upgrade_value("player", "chico_armor_multiplier", 1) - 1
	multiplier = multiplier + self:upgrade_value("player", "mrwi_armor_multiplier", 1) - 1
	multiplier = multiplier + self:upgrade_value("player", tostring(override_armor or managers.blackmarket:equipped_armor(true, true)) .. "_anarchist_armor_multiplier", 1) - 1

	return multiplier
end

-- Grinder extra health multiplier
function PlayerManager:health_skill_multiplier()
	local multiplier = 1
	multiplier = multiplier + self:upgrade_value("player", "health_multiplier", 1) - 1
	multiplier = multiplier + self:upgrade_value("player", "passive_health_multiplier", 1) - 1
	multiplier = multiplier + self:upgrade_value("player", "extra_health_multiplier", 1) - 1
	multiplier = multiplier + self:team_upgrade_value("health", "passive_multiplier", 1) - 1
	multiplier = multiplier + self:get_hostage_bonus_multiplier("health") - 1
	multiplier = multiplier - self:upgrade_value("player", "health_decrease", 0)
	multiplier = multiplier + self:upgrade_value("player", "mrwi_health_multiplier", 1) - 1

	if self:num_local_minions() > 0 then
		multiplier = multiplier + self:upgrade_value("player", "minion_master_health_multiplier", 1) - 1
	end

	return multiplier
end

-- Wildcard money multiplier
local get_skill_money_multiplier_orig = PlayerManager.get_skill_money_multiplier
function PlayerManager:get_skill_money_multiplier(whisper_mode)
	local cash_skill_mulitplier, bag_skill_mulitplier = get_skill_money_multiplier_orig(whisper_mode)
	cash_skill_mulitplier = cash_skill_mulitplier * self:upgrade_value("player", "passive_cash_multiplier", 1)
	bag_skill_mulitplier = bag_skill_mulitplier * self:upgrade_value("player", "passive_cash_multiplier", 1)

	return cash_skill_mulitplier, bag_skill_mulitplier
end

-- Grenade refund requires a specific amount of pickups instead of being chance based
local function on_ammo_pickup(unit, current_pickups, required_pickups)
	local gained_throwable = false
	local pickups = current_pickups

	if unit == managers.player:player_unit() then
		if required_pickups <= pickups then
			gained_throwable = true

			managers.player:add_grenade_amount(1, true)
		else
			pickups = pickups + 1
		end
	end

	return gained_throwable, pickups
end

PlayerAction.FullyLoaded = {
	Priority = 1,
	Function = function(player_manager, required_pickups)
		local co = coroutine.running()
		local gained_throwable = false
		local current_pickups = 1

		local function on_ammo_pickup_message(unit)
			gained_throwable, current_pickups = on_ammo_pickup(unit, current_pickups, required_pickups)
			-- Eclipse:log_chat("current pickups: " .. current_pickups)
		end

		player_manager:register_message(Message.OnAmmoPickup, co, on_ammo_pickup_message)
		player_manager:register_message(Message.OnAmmoPickup, co, on_ammo_pickup)

		while not gained_throwable do
			coroutine.yield(co)
		end

		player_manager:unregister_message(Message.OnAmmoPickup, co)
	end,
	Function_Force_Remove = function(co)
		managers.player:unregister_message(Message.OnAmmoPickup, co)
	end,
}

-- Unseen dodge for Rogue
PlayerAction.UnseenStrike = {
	Priority = 1,
	-- max_duration, crit_chance
	Function = function(player_manager, min_time, _, _)
		local co = coroutine.running()
		local current_time = Application:time()
		local target_time = Application:time() + min_time
		local can_activate = true
		local has_unseen_dodge = player_manager:has_category_upgrade("temporary", "unseen_dodge")
		local has_unseen_strike = player_manager:has_category_upgrade("temporary", "unseen_strike")

		local function on_damage_taken()
			if not (player_manager:has_activate_temporary_upgrade("temporary", "unseen_strike") or player_manager:has_activate_temporary_upgrade("temporary", "unseen_dodge")) then
				target_time = Application:time() + min_time
				can_activate = true
			end
		end

		player_manager:register_message(Message.OnPlayerDamage, co, on_damage_taken)

		while true do
			current_time = Application:time()

			if target_time <= current_time and can_activate then
				if has_unseen_dodge then
					player_manager:activate_temporary_upgrade("temporary", "unseen_dodge")
				end

				if has_unseen_strike then
					player_manager:activate_temporary_upgrade("temporary", "unseen_strike")
				end

				can_activate = false
			end

			coroutine.yield(co)
		end
	end,
}

-- Sidearm killchain reloads primary
PlayerAction.SidearmReloadPrimary = {
	Priority = 1,
	Function = function(player_manager, target_kills, target_time)
		local co = coroutine.running()
		local time = Application:time()
		local kills = 1
		local player_unit = player_manager:player_unit()

		local function on_kill()
			kills = kills + 1

			if kills == target_kills then
				local primary_unit = player_unit:inventory():unit_by_selection(2)
				local primary_base = alive(primary_unit) and primary_unit:base()
				local can_reload = primary_base and primary_base.can_reload and primary_base:can_reload()

				if can_reload then
					primary_base:on_reload()
					managers.statistics:reloaded()
					managers.hud:set_ammo_amount(primary_base:selection_index(), primary_base:ammo_info())
					player_unit:sound():play("pickup_ammo_health_boost")
				end

				time = target_time
			end
		end

		player_manager:register_message(Message.OnEnemyKilled, co, on_kill)

		while time < target_time do
			time = Application:time()
			local weapon_unit_base = player_manager:equipped_weapon_unit():base()
			local selection_index = weapon_unit_base and weapon_unit_base:selection_index() or 0

			if weapon_unit_base and not weapon_unit_base:is_category("pistol", "revolver") or not selection_index == 1 then
				break
			end

			coroutine.yield(co)
		end

		player_manager:unregister_message(Message.OnEnemyKilled, co)
	end,
}

-- Automatic primary reload with sidearms
function PlayerManager:_on_sidearms_reload_primary_event(weapon_unit, variant)
	if variant == "bullet" and not self._coroutine_mgr:is_running("sidearm_reloads_primary") and weapon_unit:base():is_category("revolver", "pistol") then
		local data = self:upgrade_value("player", "sidearms_reload_primary", 0)
		if data ~= 0 then
			self._coroutine_mgr:add_coroutine("sidearm_reloads_primary", PlayerAction.SidearmReloadPrimary, self, data.kills, Application:time() + data.max_time)
		end
	end
end

-- Pistol on-hit reload speed stacking
-- Handled in a separate playeraction due to stacking at a different rate, as well as having a different max time
PlayerAction.ExpertHandlingReload = {
	Priority = 1,
	Function = function(player_manager, reload_bonus, max_stacks, max_time)
		local co = coroutine.running()
		local current_time = Application:time()
		local current_stacks = 0

		local function on_hit()
			current_stacks = current_stacks + 1

			if current_stacks <= max_stacks then
				player_manager:add_to_property("desperado_reload", reload_bonus)
			end
		end

		on_hit()
		player_manager:register_message(Message.OnEnemyShot, co, on_hit)

		while current_time < max_time do
			current_time = Application:time()

			if not player_manager:is_current_weapon_of_category("pistol") then
				break
			end

			coroutine.yield(co)
		end

		player_manager:remove_property("desperado_reload")
		player_manager:unregister_message(Message.OnEnemyShot, co)
	end,
}

-- unit
function PlayerManager:_on_expert_handling_reload_event(_, attack_data)
	local attacker_unit = attack_data.attacker_unit
	local variant = attack_data.variant

	if attacker_unit == self:player_unit() and self:is_current_weapon_of_category("pistol") and variant == "bullet" and not self._coroutine_mgr:is_running(PlayerAction.ExpertHandlingReload) then
		local data = self:upgrade_value("pistol", "stacked_reload_bonus", nil)

		if data and type(data) ~= "number" then
			self._coroutine_mgr:add_coroutine(PlayerAction.ExpertHandlingReload, PlayerAction.ExpertHandlingReload, self, data.reload_bonus, data.max_stacks, Application:time() + data.max_time)
		end
	end
end

-- Pistol on-hit accuracy stacks additively instead
PlayerAction.ExpertHandling = {
	Priority = 1,
	Function = function(player_manager, accuracy_bonus, max_stacks, max_time)
		local co = coroutine.running()
		local current_time = Application:time()
		local current_stacks = 0

		local function on_hit()
			current_stacks = current_stacks + 1

			if current_stacks <= max_stacks then
				player_manager:add_to_property("desperado", accuracy_bonus)
			end
		end

		on_hit()
		player_manager:register_message(Message.OnEnemyShot, co, on_hit)

		while current_time < max_time do
			current_time = Application:time()

			if not player_manager:is_current_weapon_of_category("pistol") then
				break
			end

			coroutine.yield(co)
		end

		player_manager:remove_property("desperado")
		player_manager:unregister_message(Message.OnEnemyShot, co)
	end,
}

-- Deadeye instant reload event
PlayerAction.DeadeyeReload = {
	Priority = 1,
	Function = function(player_manager, target_headshots)
		local co = coroutine.running()
		local running = true
		local headshots = 1
		local player_unit = player_manager:player_unit()

		local function on_shot_fired(weapon_unit, result)
			if not weapon_unit:base():is_category("revolver") or not result.hit_enemy then
				running = false
				return
			end

			for _, hit in ipairs(result.rays) do
				local is_turret = hit.unit:in_slot(sentry_mask)
				local is_ally = hit.unit:in_slot(ally_mask)

				local result_hit = hit.damage_result
				local attack_data = result_hit and result_hit.attack_data
				if attack_data and attack_data.headshot and not is_turret and not is_ally then
					headshots = headshots + 1
					break
				else
					running = false
					return
				end
			end

			if headshots == target_headshots then
				weapon_unit:base():on_reload()
				managers.statistics:reloaded()
				managers.hud:set_ammo_amount(weapon_unit:base():selection_index(), weapon_unit:base():ammo_info())
				player_unit:sound():play("pickup_ammo_health_boost")

				running = false
			end
		end

		player_manager:register_message(Message.OnWeaponFired, co, on_shot_fired)

		while running do
			coroutine.yield(co)
		end

		player_manager:unregister_message(Message.OnWeaponFired, co)
	end,
}

function PlayerManager:_on_enter_deadeye_reload_event()
	if not self._coroutine_mgr:is_running("deadeye_reload") then
		local weapon_unit = self:equipped_weapon_unit()

		if weapon_unit and weapon_unit:base():is_category("revolver") then
			self._coroutine_mgr:add_coroutine("deadeye_reload", PlayerAction.DeadeyeReload, self, self._deadeye_reload.headshots)
		end
	end
end

-- Deadeye ammo restore event
PlayerAction.DeadeyeAmmoRestore = {
	Priority = 1,
	Function = function(player_manager, target_headshots, target_time, ammo_restore_percentage)
		local co = coroutine.running()
		local time = Application:time()
		local headshots = 1
		local weapon_unit = player_manager:equipped_weapon_unit()
		local player_unit = player_manager:player_unit()

		local function on_headshot()
			headshots = headshots + 1

			if headshots == target_headshots then
				local total_ammo = weapon_unit:base():get_ammo_max()
				player_manager:on_ammo_increase(math.ceil(ammo_restore_percentage * total_ammo))
				player_unit:sound():play("pickup_ammo_health_boost")

				time = target_time
			end
		end

		player_manager:register_message(Message.OnLethalHeadShot, co, on_headshot)

		while time < target_time do
			time = Application:time()

			if weapon_unit and not weapon_unit:base():is_category("revolver") then
				break
			end

			coroutine.yield(co)
		end

		player_manager:unregister_message(Message.OnLethalHeadShot, co)
	end,
}

function PlayerManager:_on_enter_deadeye_ammo_restore_event()
	if not self._coroutine_mgr:is_running("deadeye_ammo_restore") then
		local weapon_unit = self:equipped_weapon_unit()

		if weapon_unit and weapon_unit:base():is_category("revolver") then
			self._coroutine_mgr:add_coroutine(
				"deadeye_ammo_restore",
				PlayerAction.DeadeyeAmmoRestore,
				self,
				self._deadeye_ammo_restore.headshots,
				Application:time() + self._deadeye_ammo_restore.max_time,
				self._deadeye_ammo_restore.ammo_restore_percentage
			)
		end
	end
end

-- Upgrade to remove secondary deployable quantity penalty
function PlayerManager:_add_equipment(params)
	if self:has_equipment(params.equipment) then
		print("Allready have equipment", params.equipment)

		return
	end

	local equipment = params.equipment
	local tweak_data = tweak_data.equipments[equipment]
	local amount = {}
	local amount_digest = {}
	local quantity = tweak_data.quantity

	for i = 1, #quantity do
		local equipment_name = equipment

		if tweak_data.upgrade_name then
			equipment_name = tweak_data.upgrade_name[i]
		end

		local amt = (quantity[i] or 0) + self:equiptment_upgrade_value(equipment_name, "quantity")
		amt = managers.modifiers:modify_value("PlayerManager:GetEquipmentMaxAmount", amt, params)

		table.insert(amount, amt)
		table.insert(amount_digest, Application:digest_value(0, true))
	end

	local icon = params.icon or tweak_data and tweak_data.icon
	local use_function_name = params.use_function_name or tweak_data and tweak_data.use_function_name
	local use_function = use_function_name or nil

	if not self:has_category_upgrade("player", "no_secondary_deployable_penalty") and params.slot and params.slot > 1 then
		for i = 1, #quantity do
			amount[i] = math.ceil(amount[i] / 2)
		end
	end

	table.insert(self._equipment.selections, {
		equipment = equipment,
		amount = amount_digest,
		use_function = use_function,
		action_timer = tweak_data.action_timer,
		icon = icon,
		unit = tweak_data.unit,
		on_use_callback = tweak_data.on_use_callback,
	})

	self._equipment.selected_index = self._equipment.selected_index or 1

	add_hud_item(amount, icon)

	for i = 1, #amount do
		self:add_equipment_amount(equipment, amount[i], i)
	end
end

-- TODO: remove this when there's no more need for debugging
function PlayerManager:_is_all_in_custody(ignored_peer_id)
	if not Utils:IsInGameState() or not Utils:IsInHeist() or not managers.network:session() then
		return true
	end

	for _, peer in pairs(managers.network:session():all_peers()) do
		if peer and alive(peer:unit()) and peer:id() ~= ignored_peer_id then
			return false
		end
	end

	for _, ai in pairs(managers.groupai:state():all_AI_criminals()) do
		if ai and alive(ai.unit) then
			return false
		end
	end

	return true
end

-- handle grenade case and ordnance bag as percentage based deployables
function PlayerManager:add_grenade_from_bag(available, sync)
	local peer_id = managers.network:session():local_peer():id()
	local grenade = self._global.synced_grenades[peer_id].grenade
	local icon = tweak_data.blackmarket.projectiles[grenade].icon
	local max_nades = self:get_max_grenades_by_peer_id(peer_id)
	local total_nades = Application:digest_value(self._global.synced_grenades[peer_id].amount, false)

	local function process_grenades(amount_available)
		if self:get_max_grenades_by_peer_id(peer_id) == self._global.synced_grenades[peer_id].amount then
			return 0
		end

		local wanted = 1 - total_nades / max_nades
		local can_have = math.min(wanted, amount_available)

		total_nades = math.min(max_nades, total_nades + math.ceil(can_have * max_nades))

		return can_have
	end

	local can_have = process_grenades(available)

	managers.hud:set_teammate_grenades_amount(HUDManager.PLAYER_PANEL, {
		icon = icon,
		amount = total_nades,
	})
	self:update_grenades_amount_to_peers(grenade, total_nades, sync and peer_id)

	return can_have
end

-- add grenadecase to valid shape placement checks
function PlayerManager:check_equipment_placement_valid(player, equipment)
	local equipment_data = managers.player:equipment_data_by_name(equipment)

	if not equipment_data then
		return false
	end

	if equipment_data.equipment == "trip_mine" or equipment_data.equipment == "ecm_jammer" then
		return player:equipment():valid_look_at_placement(tweak_data.equipments[equipment_data.equipment]) and true or false
	elseif
		equipment_data.equipment == "sentry_gun"
		or equipment_data.equipment == "ammo_bag"
		or equipment_data.equipment == "sentry_gun_silent"
		or equipment_data.equipment == "doctor_bag"
		or equipment_data.equipment == "first_aid_kit"
		or equipment_data.equipment == "bodybags_bag"
		or equipment_data.equipment == "grenade_crate"
		or equipment_data.equipment == "grenade_case"
	then
		return player:equipment():valid_shape_placement(equipment_data.equipment, tweak_data.equipments[equipment_data.equipment]) and true or false
	elseif equipment_data.equipment == "armor_kit" then
		return true
	end

	return player:equipment():valid_placement(tweak_data.equipments[equipment_data.equipment]) and true or false
end

function PlayerManager:_on_spawn_extra_ammo_event(killed_unit)
	local has_extra_dmg_double_drop = self:has_category_upgrade("player", "double_drop_extra_damage")

	if Network:is_client() then
		if killed_unit:id() ~= -1 then
			managers.network:session():send_to_host("sync_spawn_extra_ammo", killed_unit, has_extra_dmg_double_drop)
		else
			Application:error("[PlayerManager:_on_spawn_extra_ammo_event] Killed unit was already detached? Can't sync extra drop request to the host.")
		end
	else
		self:spawn_extra_ammo(killed_unit, nil, has_extra_dmg_double_drop)
	end
end

-- Extra damage on ammobox pickup upgrade
function PlayerManager:spawn_extra_ammo(killed_unit, requesting_peer, has_extra_dmg_double_drop)
	if alive(killed_unit) and killed_unit:character_damage() and killed_unit:character_damage().drop_pickup then
		killed_unit:character_damage():drop_pickup(true, has_extra_dmg_double_drop)
	elseif requesting_peer then
		local peer_unit = requesting_peer:unit()

		if alive(peer_unit) then
			local mov_ext = peer_unit:movement()
			local tracker = mov_ext and mov_ext:nav_tracker()
			local position = tracker and (tracker:lost() and tracker:field_position() or tracker:position()) or mov_ext and mov_ext:m_pos() or peer_unit:position()
			local rotation = mov_ext and mov_ext:m_rot() or peer_unit:rotation()

			managers.game_play_central:spawn_pickup({
				name = "ammo",
				position = position,
				rotation = rotation,
				has_extra_dmg_double_drop = has_extra_dmg_double_drop,
			})
		end
	end
end

function PlayerManager:_check_damage_to_hot(t, unit, damage_info)
	local player_unit = self:player_unit()

	if not self:has_category_upgrade("player", "damage_to_hot") then
		return
	end

	if not alive(player_unit) or player_unit:character_damage():need_revive() or player_unit:character_damage():dead() then
		return
	end

	if not alive(unit) or not unit:base() or not damage_info then
		return
	end

	local data = tweak_data.upgrades.damage_to_hot_data

	if not data then
		return
	end

	if self._next_allowed_doh_t and t < self._next_allowed_doh_t then
		return
	end

	local add_stack_sources = data.add_stack_sources or {}

	if not add_stack_sources.swat_van and unit:base().sentry_gun then
		return
	elseif not add_stack_sources.civilian and CopDamage.is_civilian(unit:base()._tweak_table) then
		return
	end

	if damage_info.attacker_unit:base().sentry_gun and not add_stack_sources.sentry_gun then
		return
	end

	if not add_stack_sources[damage_info.variant] then
		return
	end

	if not unit:brain():is_hostile() then
		return
	end

	local player_armor = managers.blackmarket:equipped_armor(data.works_with_armor_kit, true)

	if not table.contains(data.armors_allowed or {}, player_armor) then
		return
	end

	player_unit:character_damage():add_damage_to_hot()

	self._next_allowed_doh_t = t + data.stacking_cooldown
end

-- Tag Team: tagged player will hear activation sound
Hooks:PostHook(PlayerManager, "sync_tag_team", "sync_tag_team_sound_effect", function(self, tagged, owner, end_time)
	if tagged == self:local_player() then
		self:local_player():sound():play(tweak_data.blackmarket.projectiles.tag_team.sounds.activate)
	end
end)
