local level_id = Eclipse.utils.level_id()
local drill_unit_overrides = Eclipse:require("drill_unit_overrides")

Hooks:PostHook(Drill, "init", "eclipse_init", function(self, unit)
	local unit_override = drill_unit_overrides[level_id] and drill_unit_overrides[level_id][unit:name():key()]

	if unit_override then
		self._forbid_reenforce = unit_override.forbid_reenforce or nil
		self._forbid_sabotage = unit_override.forbid_sabotage or nil
	end
end)

function Drill:_set_area_min_police_force(state)
	if self._min_force_clbk_id then
		managers.enemy:remove_delayed_clbk(self._min_force_clbk_id)
		self._min_force_clbk_id = nil
	end

	if state then
		managers.groupai:state():set_area_min_police_force(self._unit:key(), 2, self._unit:position())
	else
		managers.groupai:state():set_area_min_police_force(self._unit:key())
	end
end

-- Mark drills for reinforce groups
-- Silent drills don't get noticed immediately
Hooks:PostHook(Drill, "start", "eclipse_start", function(self)
	if not self._set_area_min_police_force or self._forbid_reenforce then
		-- Nothing
	elseif self._skill_upgrades.silent_drill or self._skill_upgrades.reduced_alert then
		self._min_force_clbk_id = "Drill_min_force" .. tostring(self._unit:key())
		local delay = TimerManager:game():time() + math.rand(unpack(tweak_data.upgrades.silent_drill_min_force_delay or { 0, 60 }))
		managers.enemy:add_delayed_clbk(self._min_force_clbk_id, callback(self, self, "_set_area_min_police_force", true), delay)
	else
		self:_set_area_min_police_force(true)
	end
end)

local function unregister_area_min_police_force(self)
	self:_set_area_min_police_force()
end
Hooks:PreHook(Drill, "destroy", "eclipse_destroy", unregister_area_min_police_force)
Hooks:PostHook(Drill, "done", "eclipse_done", unregister_area_min_police_force)

local _register_sabotage_SO_original = Drill._register_sabotage_SO
function Drill:_register_sabotage_SO(...)
	if not self._forbid_sabotage then
		return _register_sabotage_SO_original(self, ...)
	end
end

-- Tactician's drills electrocute enemies
function Drill.get_upgrades(drill_unit, player)
	local is_drill = drill_unit:base() and drill_unit:base().is_drill
	local is_saw = drill_unit:base() and drill_unit:base().is_saw
	local upgrades = nil

	if is_drill or is_saw then
		local player_skill = PlayerSkill
		upgrades = {
			auto_repair_level_1 = player_skill.skill_level("player", "drill_autorepair_1", 0, player),
			auto_repair_level_2 = player_skill.skill_level("player", "drill_autorepair_2", 0, player),
			speed_upgrade_level = player_skill.skill_level("player", "drill_speed_multiplier", 0, player),
			silent_drill = player_skill.has_skill("player", "silent_drill", player),
			reduced_alert = player_skill.has_skill("player", "drill_alert_rad", player),
			electrocuting_drill = player_skill.has_skill("player", "electrocuting_drill", player),
		}
	end

	return upgrades
end

function Drill.create_upgrades(auto_repair_level_1, auto_repair_level_2, speed_upgrade_level, silent_drill, reduced_alert, electrocuting_drill)
	return {
		auto_repair_level_1 = auto_repair_level_1,
		auto_repair_level_2 = auto_repair_level_2,
		speed_upgrade_level = speed_upgrade_level,
		silent_drill = silent_drill,
		reduced_alert = reduced_alert,
		electrocuting_drill = electrocuting_drill,
	}
end

function Drill:on_sabotage_SO_started(saboteur)
	if not self._saboteur or self._saboteur:key() ~= saboteur:key() then
		debug_pause_unit(self._unit, "[Drill:on_sabotage_SO_started] wrong saboteur", self._unit, saboteur, self._saboteur)
	end

	local can_stun = self._skill_upgrades.electrocuting_drill

	if can_stun and math.random() < tweak_data.upgrades.drill_electrocution_chance then
		local pos = saboteur:position()
		local range = 50
		local slot_mask = managers.slot:get_mask("explosion_targets")

		managers.explosion:tase_area({
			player_damage = 0,
			tase_strength = "heavy",
			hit_pos = pos,
			range = range,
			collision_slotmask = slot_mask,
			curve_pow = 3,
			damage = 10,
			ignore_unit = self._unit,
			unit = self._unit,
			alert_radius = 1,
		})

		saboteur:sound():play("gl_electric_explode", nil, true)

		managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "base", GrenadeBase.EVENT_IDS.detonate)

		self._saboteur = nil

		self:_register_sabotage_SO()
	else
		self._saboteur = nil

		self._unit:timer_gui():set_jammed(true)

		if self.is_drill and not self._bain_report_sabotage_clbk_id then
			self._bain_report_sabotage_clbk_id = "Drill_bain_report_sabotage" .. tostring(self._unit:key())

			managers.enemy:add_delayed_clbk(self._bain_report_sabotage_clbk_id, callback(self, self, "clbk_bain_report_sabotage"), TimerManager:game():time() + 2 + 4 * math.random())
		end
	end
end

Hooks:PostHook(Drill, "on_sabotage_SO_administered", "eclipse_on_sabotage_SO_administered", function(self)
	self._saboteur:sound():say(self.is_drill and "e01" or self.is_hacking_device and "e02" or "e04", true)
end)

Hooks:PostHook(Drill, "on_sabotage_SO_completed", "eclipse_on_sabotage_SO_completed", function(self, saboteur)
	saboteur:sound():say(self.is_drill and "e05" or "e06", true)
end)

-- Drill autorestarter is guaranteed and rolls after a specific amount of time, instead of a random delay
function Drill:set_jammed(jammed)
	jammed = jammed and true or false

	if self._jammed == jammed then
		return
	end

	self._jammed = jammed

	if self._jammed then
		self._jammed_count = self._jammed_count + 1
		self._melee_hit_count = 0 -- init or reinit to prevent (if for whatever reason a player decides to) storing for kickstarter aced

		self:_kill_drill_effect()

		if self._use_effect then
			local params = {
				effect = Idstring("effects/payday2/environment/drill_jammed"),
				parent = self._unit:get_object(Idstring("e_drill_particles")),
			}
			self._jammed_effect = World:effect_manager():spawn(params)
		end

		self:_reset_melee_autorepair()

		-- get rid of math random so it's a guaranteed autorestarter
		if self._autorepair_chance and not self._autorepair_clbk_id then
			self._autorepair_clbk_id = "Drill_autorepair" .. tostring(self._unit:key())

			-- no random delay
			managers.enemy:add_delayed_clbk(self._autorepair_clbk_id, callback(self, self, "clbk_autorepair"), TimerManager:game():time() + tweak_data.upgrades.drill_time_to_autorepair)
		end
	elseif self._jammed_effect then
		self:_kill_jammed_effect()
		self:_start_drill_effect()

		if not self.is_hacking_device and not self.is_saw and not managers.groupai:state():whisper_mode() then
			managers.groupai:state():teammate_comment(nil, "g22", self._unit:position(), true, 500, false)
		end

		if self._autorepair_clbk_id then
			managers.enemy:remove_delayed_clbk(self._autorepair_clbk_id)

			self._autorepair_clbk_id = nil
		end

		if self._bain_report_sabotage_clbk_id then
			managers.enemy:remove_delayed_clbk(self._bain_report_sabotage_clbk_id)

			self._bain_report_sabotage_clbk_id = nil
		end
	end

	self:_change_num_jammed_drills(self._jammed and 1 or -1)

	if Network:is_server() then
		if jammed then
			self:_unregister_sabotage_SO()

			if not self._jammed_bot_so_id then
				self:_register_fix_SO()
			end
		else
			self:_unregister_fix_SO()
			self:_register_sabotage_SO()
		end
	end
end

Hooks:PreHook(Drill, "set_skill_upgrades", "eclipse_set_skill_upgrades", function(self)
	local unit_override = self._unit:timer_gui().get_drill_unit_override and self._unit:timer_gui():get_drill_unit_override()
	if unit_override and unit_override.disable_upgrades ~= nil then
		self._disable_upgrades = unit_override.disable_upgrades
	end
end)

-- Melee autorestarter gets triggered after a certain amount of hits instead of a random chance
function Drill:on_melee_hit(peer_id)
	if self._disable_upgrades or not self._jammed then
		return
	end

	local unit = self._unit
	local session = managers.network:session()
	local local_peer = session:local_peer()

	if local_peer:id() == peer_id then
		local peer_unit = local_peer and local_peer:unit()

		if not alive(peer_unit) or not unit:interaction():can_interact(peer_unit) then
			return
		end
	end

	local registered_peers = self._peer_ids
	registered_peers[#registered_peers + 1] = peer_id

	if Network:is_client() then
		session:send_to_host("sync_unit_event_id_16", unit, "base", Drill.EVENT_IDS.melee_restart_client)

		return
	end

	-- counter
	self._melee_hit_count = self._melee_hit_count + 1

	-- Eclipse:log_chat("melee hit count: " .. tostring(self._melee_hit_count) .. "/" .. tostring(tweak_data.upgrades.drill_hits_to_restart or "N/A"))

	if self._melee_hit_count >= tweak_data.upgrades.drill_hits_to_restart then
		self._melee_hit_count = 0
		self:on_melee_hit_success()
	end
end

-- Team AI drill repair ability
if not Network:is_server() then
	return
end

function Drill:_verify_fix_SO(unit)
	if not managers.player:has_category_upgrade("team", "crew_ai_fix_drill") then
		return
	end

	local brain = alive(unit) and unit:brain()
	if not brain or not brain:is_available_for_assignment() or brain._logic_data.internal_data and brain._logic_data.internal_data.called then
		return
	end

	local objective = brain:objective()
	if objective and (objective.type == "act" or objective.called) then
		return
	end

	local logic_data = brain._logic_data
	local focus_enemy = logic_data.attention_obj
	if not focus_enemy or focus_enemy.reaction < AIAttentionObject.REACT_SHOOT or not focus_enemy.verified or focus_enemy.dis > 3000 then
		return true
	end
end

function Drill:_fix_SO_administered(unit)
	self._jammed_bot_so_id = nil
	self._fixer_unit = unit
end

function Drill:_fix_SO_started(unit)
	local int = alive(self._unit) and self._unit:interaction()
	if not int or not int:active() then
		unit:brain():set_objective(nil)
	end
end

function Drill:_fix_SO_completed(unit)
	self._fixer_unit = nil
	local int = alive(self._unit) and self._unit:interaction()
	if int and int:active() then
		int:interact(unit)
	end
end

function Drill:_fix_SO_failed(unit)
	self._fixer_unit = nil
	unit:movement():play_redirect("up_idle")
	self:_register_fix_SO()
end

function Drill:_register_fix_SO()
	local int = alive(self._unit) and self._unit:interaction()
	if not int or not int:active() then
		return
	end

	if int._tweak_data.special_equipment then
		return
	end

	local objective_pos = self._nav_tracker:field_position()
	local objective_rot = Rotation((self._unit:position() - objective_pos):with_z(0):normalized(), math.UP)
	local objective_nav = self._nav_tracker:nav_segment()
	local height = self._unit:position().z - self._nav_tracker:field_z()

	local blocks = {
		light_hurt = -1,
		hurt = -1,
		action = -1,
		heavy_hurt = -1,
		aim = -1,
		walk = -1,
		turn = -1,
		act = -1,
		idle = -1,
		shoot = -1,
	}

	local objective = {
		type = "act",
		nav_seg = objective_nav,
		pos = objective_pos,
		rot = objective_rot,
		fail_clbk = callback(self, self, "_register_fix_SO"),
		action_duration = 0.1,
		action = {
			align_sync = true,
			type = height > 80 and "stand" or "crouch",
			body_part = 4,
			blocks = clone(blocks),
		},
		followup_objective = {
			type = "act",
			fail_clbk = callback(self, self, "_fix_SO_failed"),
			action_start_clbk = callback(self, self, "_fix_SO_started"),
			complete_clbk = callback(self, self, "_fix_SO_completed"),
			action_duration = self._unit:interaction()._tweak_data.timer or 3,
			action = {
				type = "act",
				body_part = 3,
				variant = "interact_enter",
				blocks = clone(blocks),
			},
			followup_objective = {
				type = "act",
				action_duration = 0.5,
				action = {
					body_part = 3,
					type = "act",
					variant = "interact_exit",
					blocks = clone(blocks),
				},
			},
		},
	}

	local so_descriptor = {
		interval = 3,
		AI_group = "friendlies",
		base_chance = 1,
		chance_inc = 0,
		usage_amount = 1,
		search_pos = objective_pos,
		search_dis_sq = 1000 ^ 2,
		admin_clbk = callback(self, self, "_fix_SO_administered"),
		verification_clbk = callback(self, self, "_verify_fix_SO"),
		objective = objective,
	}

	self._jammed_bot_so_id = "botfixdrill" .. tostring(self._unit:key())

	managers.groupai:state():add_special_objective(self._jammed_bot_so_id, so_descriptor)
end

function Drill:_unregister_fix_SO()
	if alive(self._fixer_unit) then
		self._fixer_unit:brain():set_objective(nil)
	end

	if not self._jammed_bot_so_id then
		return
	end

	managers.groupai:state():remove_special_objective(self._jammed_bot_so_id)
	self._jammed_bot_so_id = nil
end
