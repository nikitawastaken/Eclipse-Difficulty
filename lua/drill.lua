local level_id = Eclipse.utils.level_id()
local drill_unit_overrides = Eclipse:require("drill_unit_overrides")

Hooks:PostHook(Drill, "init", "eclipse_init", function(self, unit)
	local unit_override = drill_unit_overrides[level_id] and drill_unit_overrides[level_id][unit:name():key()]

	if unit_override then
		self._forbid_reenforce = unit_override.forbid_reenforce or nil
		self._forbid_sabotage = unit_override.forbid_sabotage or nil
	end
end)

-- Mark drills for reinforce groups
Hooks:PostHook(Drill, "start", "eclipse_start", function(self)
	if not self._forbid_reenforce then
		managers.groupai:state():set_area_min_police_force(self._unit:key(), 2, self._unit:position())
	else
		Eclipse:log_console("No reinforce point created, drill reinforce is disabled for " .. level_id)
	end
end)

Hooks:PostHook(Drill, "done", "eclipse_done", function(self)
	managers.groupai:state():set_area_min_police_force(self._unit:key())
end)

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

Hooks:PostHook(Drill, "on_sabotage_SO_completed", "RR_on_sabotage_SO_completed", function(self, saboteur)
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
		else
			self:_register_sabotage_SO()
		end
	end
end

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
