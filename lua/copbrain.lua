-- Set up logics and needed data
CopBrain._logic_variants.mobster_boss = CopBrain._logic_variants.triad_boss
CopBrain._logic_variants.chavez_boss = CopBrain._logic_variants.triad_boss
CopBrain._logic_variants.hector_boss = CopBrain._logic_variants.triad_boss
CopBrain._logic_variants.drug_lord_boss = CopBrain._logic_variants.triad_boss
CopBrain._logic_variants.biker_boss = CopBrain._logic_variants.triad_boss
CopBrain._logic_variants.tank_elite = CopBrain._logic_variants.tank
CopBrain._logic_variants.phalanx_minion_break = CopBrain._logic_variants.city_swat
CopBrain._logic_variants.zeal_swat = CopBrain._logic_variants.city_swat
CopBrain._logic_variants.zeal_heavy_swat = CopBrain._logic_variants.city_swat
CopBrain._logic_variants.zeal_medic = CopBrain._logic_variants.city_swat
CopBrain._logic_variants.zeal_taser = CopBrain._logic_variants.taser
CopBrain._logic_variants.zeal_shield = clone(CopBrain._logic_variants.shield)
CopBrain._logic_variants.fbi_shield = clone(CopBrain._logic_variants.shield)
CopBrain._logic_variants.medic.attack = MedicLogicAttack
CopBrain._logic_variants.zeal_medic.attack = MedicLogicAttack

CopBrain._next_cover_grenade_chk_t = 0
CopBrain._next_logic_upd_t = 0

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
		self._next_logic_upd_t = t + 1 / 30
		return update_original(self, unit, t, ...)
	end
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
