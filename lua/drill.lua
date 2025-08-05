local level_id = Eclipse.utils.level_id()

Drill.forbid_sabotage_SO_by_unit = {
	[("units/payday2/equipment/gen_interactable_lance_huge/gen_interactable_lance_huge"):key()] = true, -- The Beast
	[("units/payday2/equipment/gen_interactable_lance_large/gen_interactable_lance_large"):key()] = level_id == "red2" or nil, -- Ordinary thermal lance
}
Drill.no_automatic_drill_reenforce = {
	["arm_fac"] = true,
	["arm_par"] = true,
	["arm_hcm"] = true,
	["arm_und"] = true,
	["arm_cro"] = true,
	["arm_for"] = true,
	["glace"] = true,
}

Hooks:PostHook(Drill, "init", "eclipse_init", function(self, unit)
	self._sabotage_SO_forbidden = self.forbid_sabotage_SO_by_unit[unit:name():key()] or nil
end)

Hooks:PostHook(Drill, "start", "eclipse_start", function(self)
	if not self.no_automatic_drill_reenforce[level_id] then
		managers.groupai:state():set_area_min_police_force(self._unit:key(), 2, self._unit:position())
	end
end)

Hooks:PostHook(Drill, "done", "eclipse_done", function(self)
	managers.groupai:state():set_area_min_police_force(self._unit:key())
end)

local _register_sabotage_SO_original = Drill._register_sabotage_SO
function Drill:_register_sabotage_SO(...)
	if not self._sabotage_SO_forbidden then
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
			electrocuting_drill = player_skill.has_skill("player", "electrocuting_drill", player)
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
		electrocuting_drill = electrocuting_drill
	}
end

function Drill:on_sabotage_SO_started(saboteur)
	if not self._saboteur or self._saboteur:key() ~= saboteur:key() then
		debug_pause_unit(self._unit, "[Drill:on_sabotage_SO_started] wrong saboteur", self._unit, saboteur, self._saboteur)
	end

	local can_stun = self._skill_upgrades.electrocuting_drill

	if can_stun then
		local pos = saboteur:position()
		local normal = math.UP
		local range = 500
		local slot_mask = managers.slot:get_mask("explosion_targets")

		local hit_units, splinters = managers.explosion:detect_and_tase({
			player_damage = 0,
			tase_strength = "heavy",
			hit_pos = pos,
			range = range,
			collision_slotmask = slot_mask,
			curve_pow = 3,
			damage = 10,
			ignore_unit = self._unit,
			alert_radius = 1
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