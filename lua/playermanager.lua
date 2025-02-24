Hooks:PostHook(PlayerManager, "init", "eclipse_init", function(self)
	self._consecutive_headshots = 0
	self._charged_shot_allowed = false
	self._eclipse_bags_carried = 0
end)

-- Carry stacker helper functions
function PlayerManager:get_bags_carried()
	return self._eclipse_bags_carried
end

function PlayerManager:subtract_bags_carried()
	self._eclipse_bags_carried = self._eclipse_bags_carried - 1
end

function PlayerManager:add_bags_carried()
	self._eclipse_bags_carried = self._eclipse_bags_carried + 1
end
-- end

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

function PlayerManager:charged_shot_allowed(is_allowed)
	self._charged_shot_allowed = is_allowed
end

function PlayerManager:is_charged_shot_allowed()
	return self._charged_shot_allowed
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

	-- snp_charged_shot has to be put here because check_skills() is only called once at the initialization
	if self:has_category_upgrade("snp", "charged_shot") and self._charged_shot_allowed then
		self:register_message(Message.OnWeaponFired, "graze_damage", callback(SniperGrazeDamage, SniperGrazeDamage, "on_weapon_fired"))
	else
		self:unregister_message(Message.OnWeaponFired, "graze_damage")
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
					player_manager:add_to_property("shotguncqb", speed_bonus)
				end
			end
		end

		player_manager:add_to_property("shotguncqb", speed_bonus)
		player_manager:register_message(Message.OnEnemyKilled, co, on_hit)

		while current_time < max_time do
			current_time = Application:time()
			coroutine.yield(co)
		end

		player_manager:remove_property("shotguncqb")
		player_manager:unregister_message(Message.OnEnemyKilled, co)
	end,
}

Hooks:PostHook(PlayerManager, "check_skills", "eclipse_check_skills", function(self)
	if self:has_category_upgrade("shotgun", "speed_stack_on_kill") then
		self._message_system:register(Message.OnEnemyKilled, "shotguncqb", callback(self, self, "_on_enter_shotguncqb_event"))
	else
		self._message_system:unregister(Message.OnEnemyKilled, "shotguncqb")
	end

	if self:has_category_upgrade("snp", "consecutive_headshots") then
		self:register_message(Message.OnWeaponFired, "consecutive_headshots", callback(self, self, "_on_enter_consecutive_headshots_event"))
	else
		self:unregister_message(Message.OnWeaponFired, "consecutive_headshots")
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

-- Carry stacker start
-- TODO: fixup sync functions, add skill check
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
			zipline_unit
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

	local no_bags_carried = self:get_bags_carried() < 1
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
		if peer_id ~= local_peer_id then
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
	peer
)
	if not self:verify_carry(peer, carry_id) then
		return
	end

	local unit_name = tweak_data.carry[carry_id].unit or "units/payday2/pickups/gen_pku_lootbag/gen_pku_lootbag"
	local unit = World:spawn_unit(Idstring(unit_name), position, rotation)

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
		peer and peer:id() or 0
	)

	if unit:carry_data()._global_event then
		managers.mission:call_global_event(unit:carry_data()._global_event)
	end

	return unit
end

-- TODO: Add carry stacker interactions for disposing corpses

function PlayerManager:peer_dropped_out(peer)
	local peer_id = peer:id()
	local peer_unit = peer:unit()

	if Network:is_server() then
		self:transfer_special_equipment(peer_id, true, true)

		if self._global.synced_carry[peer_id] and self._global.synced_carry[peer_id].approved then
			for i, data in ipairs(self._global.synced_carry[peer_id]) do
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

-- If the dye pack feature gets used, add
-- PlayerManager:check_damage_carry(...)

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
	local pos = seat.object:position()

	player:set_rotation(rot)

	local pos = seat.object:position() + VehicleDrivingExt.PLAYER_CAPSULE_OFFSET

	vehicle:link(Idstring(VehicleDrivingExt.SEAT_PREFIX .. seat_name), player)

	if self:local_player() == player then
		if self:is_carrying() then
			local vehicle_ext = vehicle:vehicle_driving()
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

Hooks:PostHook(PlayerManager, "set_carry", "eclipse_pm_set_carry", function(self)
	self:add_bags_carried()
end)

Hooks:PostHook(PlayerManager, "set_player_state", "eclipse_pm_set_player_state", function(self, state)
	state = state or self._current_state
	if state == "standard" and self._eclipse_bags_carried > 0 then
		state = "carry"
	end

	if state ~= self._current_state then
		Eclipse:log_chat(state .. " " .. self._current_state)
		self:_change_player_state()
	end
end)
-- Carry stacker end
