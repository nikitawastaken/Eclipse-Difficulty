-- Set up logics and needed data
CopBrain._logic_variants.mobster_boss = CopBrain._logic_variants.triad_boss
CopBrain._logic_variants.chavez_boss = CopBrain._logic_variants.triad_boss
CopBrain._logic_variants.hector_boss = CopBrain._logic_variants.triad_boss
CopBrain._logic_variants.drug_lord_boss = CopBrain._logic_variants.triad_boss
CopBrain._logic_variants.biker_boss = CopBrain._logic_variants.triad_boss
CopBrain._logic_variants.fbi_boss = CopBrain._logic_variants.triad_boss
CopBrain._logic_variants.cobra = CopBrain._logic_variants.gangster
CopBrain._logic_variants.tank_elite = CopBrain._logic_variants.tank
CopBrain._logic_variants.murky = CopBrain._logic_variants.swat
CopBrain._logic_variants.security_fat = CopBrain._logic_variants.swat
CopBrain._logic_variants.security_mcmansion = CopBrain._logic_variants.swat
CopBrain._logic_variants.security_army = CopBrain._logic_variants.swat
CopBrain._logic_variants.cop_fat = CopBrain._logic_variants.swat
CopBrain._logic_variants.fbi_office = CopBrain._logic_variants.swat
CopBrain._logic_variants.soldier = CopBrain._logic_variants.swat
CopBrain._logic_variants.fbi_sniper = clone(CopBrain._logic_variants.sniper)
CopBrain._logic_variants.fbi_shield = clone(CopBrain._logic_variants.shield)
CopBrain._logic_variants.medic = clone(CopBrain._logic_variants.swat)
CopBrain._logic_variants.medic.attack = MedicLogicAttack
CopBrain._logic_variants.city_heavy_swat = CopBrain._logic_variants.swat
CopBrain._logic_variants.city_sniper = clone(CopBrain._logic_variants.swat)
CopBrain._logic_variants.city_sniper.attack = MarshalLogicAttack
CopBrain._logic_variants.city_shield = clone(CopBrain._logic_variants.shield)
CopBrain._logic_variants.city_shield_break = CopBrain._logic_variants.swat
CopBrain._logic_variants.marshal_marksman = clone(CopBrain._logic_variants.sniper)
CopBrain._logic_variants.marshal_gunner = CopBrain._logic_variants.swat
CopBrain._logic_variants.marshal_security = CopBrain._logic_variants.swat
CopBrain._logic_variants.zeal_swat = CopBrain._logic_variants.swat
CopBrain._logic_variants.zeal_heavy_swat = CopBrain._logic_variants.swat
CopBrain._logic_variants.zeal_medic = CopBrain._logic_variants.city_swat
CopBrain._logic_variants.zeal_taser = CopBrain._logic_variants.taser
CopBrain._logic_variants.zeal_shield = clone(CopBrain._logic_variants.shield)
CopBrain._logic_variants.zeal_medic = clone(CopBrain._logic_variants.swat)
CopBrain._logic_variants.zeal_medic.attack = MedicLogicAttack

CopBrain._next_cover_grenade_chk_t = 0
CopBrain._next_logic_upd_t = 0
CopBrain._logic_upd_interval = 1 / 30

-- Fix spamming of grenades by units that dodge with grenades (Cloaker)
local _chk_use_cover_grenade_original = CopBrain._chk_use_cover_grenade
function CopBrain:_chk_use_cover_grenade(...)
	if self._next_cover_grenade_chk_t < TimerManager:game():time() then
		return _chk_use_cover_grenade_original(self, ...)
	end
end

-- Don't trigger damage callback from dot damage as it would make enemies go into shoot action
-- when they stand inside a poison cloud or molotov, regardless of any targets being visible or not
local clbk_damage_original = CopBrain.clbk_damage
function CopBrain:clbk_damage(my_unit, damage_info, ...)
	if damage_info.variant ~= "poison" and not damage_info.is_fire_dot_damage and not damage_info.is_molotov then
		return clbk_damage_original(self, my_unit, damage_info, ...)
	end
end

-- Set Joker owner to keep follow objective correct
Hooks:PreHook(CopBrain, "convert_to_criminal", "sh_convert_to_criminal", function(self, mastermind_criminal)
	self._logic_data.minion_owner = mastermind_criminal or managers.player:local_player()
	self._logic_data.combat_chatter_cooldown_t = self._logic_data.t + math.rand(30, 90)
end)

-- Make surrender window slightly shorter and less random
Hooks:OverrideFunction(CopBrain, "on_surrender_chance", function(self)
	local t = TimerManager:game():time()

	if self._logic_data.surrender_window then
		self._logic_data.surrender_window.expire_t = t + self._logic_data.surrender_window.timeout_duration
		self._logic_data.surrender_window.chance_mul = self._logic_data.surrender_window.chance_mul ^ 0.8
		managers.enemy:reschedule_delayed_clbk(self._logic_data.surrender_window.expire_clbk_id, self._logic_data.surrender_window.expire_t)
		return
	end

	-- Give between 2 and 3 extra shout interactions after the first
	local window_duration = tweak_data.player.movement_state.interaction_delay * math.rand(2.5, 3.5)
	local timeout_duration = math.rand(4, 8)
	local expire_clbk_id = "CopBrain_sur_op" .. tostring(self._unit:key())
	self._logic_data.surrender_window = {
		chance_mul = 0.05,
		expire_clbk_id = expire_clbk_id,
		window_expire_t = t + window_duration,
		expire_t = t + window_duration + timeout_duration,
		window_duration = window_duration,
		timeout_duration = timeout_duration,
	}

	managers.enemy:add_delayed_clbk(expire_clbk_id, callback(self, self, "clbk_surrender_chance_expired"), self._logic_data.surrender_window.expire_t)
end)

-- Handle suppressed chatter in logic
Hooks:OverrideFunction(CopBrain, "on_suppressed", function(self, state)
	self._logic_data.is_suppressed = state or nil

	if state == "panic" then
		self._unit:sound():say(math.random() < 0.5 and "lk3a" or "lk3b", true)
	elseif state and self._logic_data.char_tweak.chatter and self._logic_data.char_tweak.chatter.suppress then
		managers.groupai:state():chk_say_enemy_chatter(self._unit, self._logic_data.m_pos, "suppress")
	end

	if self._current_logic.on_suppressed_state then
		self._current_logic.on_suppressed_state(self._logic_data)
	end
end)

-- Limit logic updates, there's no need to update it every frame
local update_original = CopBrain.update
function CopBrain:update(unit, t, ...)
	if self._next_logic_upd_t <= t then
		self._next_logic_upd_t = t + self._logic_upd_interval
		return update_original(self, unit, t, ...)
	end
end

-- Additional is_custody_trade argument
function CopBrain:on_trade(pos, rotation, free_criminal, is_custody_trade)
	return self._current_logic.on_trade(self._logic_data, pos, rotation, free_criminal, is_custody_trade)
end

function CopBrain:on_trade_cancel()
	return self._current_logic.on_trade(self._logic_data)
end

-- "Converted enemy has additional target priority" upgrade
function CopBrain:convert_to_criminal(mastermind_criminal)
	self._logic_data.is_converted = true
	self._logic_data.group = nil
	local mover_col_body = self._unit:body("mover_blocker")

	mover_col_body:set_enabled(false)

	local attention_preset = PlayerMovement._create_attention_setting_from_descriptor(self, tweak_data.attention.settings.team_enemy_cbt, "team_enemy_cbt")

	local health_multiplier = 1
	local damage_multiplier = 1

	if alive(mastermind_criminal) then
		health_multiplier = health_multiplier * (mastermind_criminal:base():upgrade_value("player", "convert_enemies_health_multiplier") or 1)
		health_multiplier = health_multiplier * (mastermind_criminal:base():upgrade_value("player", "passive_convert_enemies_health_multiplier") or 1)
		damage_multiplier = damage_multiplier * (mastermind_criminal:base():upgrade_value("player", "convert_enemies_damage_multiplier") or 1)
		damage_multiplier = damage_multiplier * (mastermind_criminal:base():upgrade_value("player", "passive_convert_enemies_damage_multiplier") or 1)
		attention_preset.weight_mul = (attention_preset.weight_mul or 1) * (mastermind_criminal:base():upgrade_value("player", "convert_camouflage_mul") or 1)
	else
		health_multiplier = health_multiplier * managers.player:upgrade_value("player", "convert_enemies_health_multiplier", 1)
		health_multiplier = health_multiplier * managers.player:upgrade_value("player", "passive_convert_enemies_health_multiplier", 1)
		damage_multiplier = damage_multiplier * managers.player:upgrade_value("player", "convert_enemies_damage_multiplier", 1)
		damage_multiplier = damage_multiplier * managers.player:upgrade_value("player", "passive_convert_enemies_damage_multiplier", 1)
		attention_preset.weight_mul = (attention_preset.weight_mul or 1) * managers.player:upgrade_value("player", "convert_camouflage_mul", 1)
	end

	self._attention_handler:override_attention("enemy_team_cbt", attention_preset)

	self._unit:character_damage():convert_to_criminal(health_multiplier)

	self._logic_data.attention_obj = nil

	CopLogicBase._destroy_all_detected_attention_object_data(self._logic_data)

	self._SO_access = managers.navigation:convert_access_flag(tweak_data.character.russian.access)
	self._logic_data.SO_access = self._SO_access
	self._logic_data.SO_access_str = tweak_data.character.russian.access
	self._slotmask_enemies = managers.slot:get_mask("enemies")
	self._logic_data.enemy_slotmask = self._slotmask_enemies
	local equipped_w_selection = self._unit:inventory():equipped_selection()

	if equipped_w_selection then
		self._unit:inventory():remove_selection(equipped_w_selection, true)
	end

	local weap_name = self._unit:base():default_weapon_name()

	TeamAIInventory.add_unit_by_name(self._unit:inventory(), weap_name, true)

	local weapon_unit = self._unit:inventory():equipped_unit()

	weapon_unit:base():add_damage_multiplier(damage_multiplier)
	self:set_objective(nil)
	self:set_logic("idle", nil)

	self._logic_data.objective_complete_clbk = callback(managers.groupai:state(), managers.groupai:state(), "on_criminal_objective_complete")
	self._logic_data.objective_failed_clbk = callback(managers.groupai:state(), managers.groupai:state(), "on_criminal_objective_failed")

	managers.groupai:state():on_criminal_jobless(self._unit)
	self._unit:base():set_slot(self._unit, 16)
	self._unit:movement():set_stance("hos")

	local action_data = {
		clamp_to_graph = true,
		type = "act",
		body_part = 1,
		variant = "attached_collar_enter",
		blocks = {
			heavy_hurt = -1,
			hurt = -1,
			action = -1,
			light_hurt = -1,
			walk = -1,
		},
	}

	self._unit:brain():action_request(action_data)
	self._unit:sound():say("cn1", true, nil)
end

-- If Iter is installed and streamlined path option is used, don't make any further changes
if Iter and Iter.settings and Iter.settings.streamline_path then
	return
end

-- Call pathing results callback in logic if it exists
Hooks:PostHook(CopBrain, "clbk_pathing_results", "sh_clbk_pathing_results", function(self)
	local current_logic = self._current_logic
	if current_logic.on_pathing_results then
		current_logic.on_pathing_results(self._logic_data)
	end
end)
