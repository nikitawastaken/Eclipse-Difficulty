-- uppers cooldown
PlayerDamage._UPPERS_COOLDOWN = 120

-- Pro-Job adds bleedout time and revive health scaling (as well as friendly fire)
Hooks:PreHook(PlayerDamage, "replenish", "eclipse_replenish", function(self)
	if Global.game_settings and Global.game_settings.one_down then
		self._lives_init = 4
		tweak_data.player.damage.DOWNED_TIME = 25
		tweak_data.player.damage.DOWNED_TIME_DEC = 10
		tweak_data.player.damage.DOWNED_TIME_MIN = 1
		tweak_data.player.damage.REVIVE_HEALTH_STEPS = { 0.4, 0.2, 0.1 }
	end
end)

-- armor regen time depends on the armor you're wearing
function PlayerDamage:set_regenerate_timer_to_max()
	local mul = managers.player:body_armor_regen_multiplier(alive(self._unit) and self._unit:movement():current_state()._moving, self:health_ratio())
	self._regenerate_timer = managers.player:body_armor_value("regen_timer") * mul
	self._regenerate_timer = self._regenerate_timer * managers.player:upgrade_value("player", "armor_regen_time_mul", 1)
	self._regenerate_speed = self._regenerate_speed or 1
	self._current_state = self._update_regenerate_timer
end

-- Aimpunch
Hooks:PreHook(PlayerDamage, "damage_bullet", "hits_damage_bullet", function (self, attack_data)
	if not attack_data or not attack_data.damage then
		return
	end

	local shake_armor_multiplier = 1
	
	if alive(self._unit) and self._unit:movement() and self._unit:movement()._current_state and self._unit:movement()._current_state:in_steelsight() then
		shake_armor_multiplier = shake_armor_multiplier * managers.player:upgrade_value("player", "steelsight_shake_multiplier", 1)
	end
	
	self._unit:camera()._damage_bullet_shake_multiplier = math.clamp(attack_data.damage, 0, 16) * shake_armor_multiplier
end)

-- Grace period protects no matter the new potential damage but is shorter in general (sh)
function PlayerDamage:_chk_dmg_too_soon()
	local next_allowed_dmg_t = type(self._next_allowed_dmg_t) == "number" and self._next_allowed_dmg_t or Application:digest_value(self._next_allowed_dmg_t, false)
	return managers.player:player_timer():time() < next_allowed_dmg_t
end

-- Add slightly longer grace period on armor break (repurposing Anarchist/Armorer damage timer) / Add a skill that causes nearby enemies to panic when armor is broken
local _calc_armor_damage_original = PlayerDamage._calc_armor_damage
function PlayerDamage:_calc_armor_damage(...)
	local had_armor = self:get_real_armor() > 0

	local health_subtracted = _calc_armor_damage_original(self, ...)

	local has_armor_panic = managers.player:has_enabled_cooldown_upgrade("cooldown", "panic_on_armor_break")

	if had_armor and self:get_real_armor() <= 0 then
		if has_armor_panic then
			local pos = managers.player:player_unit():position()
			local skill = tweak_data.upgrades.values.player.armor_panic[1]

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

			managers.player:disable_cooldown_upgrade("cooldown", "panic_on_armor_break")
		end

		if health_subtracted > 0 and self._can_take_dmg_timer <= 0 then
			self._can_take_dmg_timer = self._dmg_interval + (tweak_data.player.damage.ARMOR_BREAK_MIN_DAMAGE_INTERVAL or 0.15)
		end
	end

	return health_subtracted
end

function PlayerDamage:_calc_health_damage(attack_data)
	if managers.player:has_activate_temporary_upgrade("temporary", "mrwi_health_invulnerable") then
		return 0
	end

	local health_subtracted = 0
	health_subtracted = self:get_real_health()

	self:change_health(-attack_data.damage)

	health_subtracted = health_subtracted - self:get_real_health()

	if managers.player:has_activate_temporary_upgrade("temporary", "copr_ability") and health_subtracted > 0 then
		local teammate_heal_level = managers.player:upgrade_level_nil("player", "copr_teammate_heal")

		if teammate_heal_level and self:get_real_health() > 0 then
			self._unit:network():send("copr_teammate_heal", teammate_heal_level)
		end
	end

	if self._has_mrwi_health_invulnerable then
		local health_threshold = self._mrwi_health_invulnerable_threshold or 0.5
		local is_cooling_down = managers.player:get_temporary_property("mrwi_health_invulnerable", false)

		-- Make <50%hp invuln upgrade not proc on armor hits
		if self:health_ratio() <= health_threshold and health_subtracted > 0 and not is_cooling_down then -- was it so hard to just add one more check, overkill?
			local cooldown_time = self._mrwi_health_invulnerable_cooldown or 10

			managers.player:activate_temporary_upgrade("temporary", "mrwi_health_invulnerable")
			managers.player:activate_temporary_property("mrwi_health_invulnerable", cooldown_time, true)
		end
	end

	local trigger_skills = table.contains({
		"bullet",
		"explosion",
		"melee",
		"delayed_tick",
	}, attack_data.variant)

	if self:get_real_health() == 0 and trigger_skills then
		self:_chk_cheat_death()
	end

	self:_damage_screen()
	self:_check_bleed_out(trigger_skills)
	managers.hud:set_player_health({
		current = self:get_real_health(),
		total = self:_max_health(),
		revives = Application:digest_value(self._revives, false),
	})
	self:_send_set_health()
	self:_set_health_effect()
	managers.statistics:health_subtracted(health_subtracted)

	return health_subtracted
end

-- add an upgrade that gives increased bleedout timer
Hooks:PostHook(PlayerDamage, "_regenerated", "sh__regenerated", function(self)
	self._down_time_i = 0
	self._down_time = tweak_data.player.damage.DOWNED_TIME + managers.player:upgrade_value("player", "increased_bleedout_timer", 0)
end)

--Fix fake downs progressing revive health and down timer steps
local revive_original = PlayerDamage.revive
function PlayerDamage:revive(...)
	local was_bleedout = self._bleed_out

	revive_original(self, ...)

	if was_bleedout then
		self._down_time_i = self._down_time_i + 1
	else
		self._revive_health_i = math.max(self._revive_health_i - 1, 1)
	end

	local player_damage_tweak = tweak_data.player.damage
	self._down_time = math.max(player_damage_tweak.DOWNED_TIME_MIN, player_damage_tweak.DOWNED_TIME - player_damage_tweak.DOWNED_TIME_DEC * self._down_time_i)
end

-- make healing fixed instead of % of max health
function PlayerDamage:restore_health(health_restored, is_static, chk_health_ratio)
	if chk_health_ratio and managers.player:is_damage_health_ratio_active(self:health_ratio()) then
		return false
	end

	return self:change_health(health_restored * self._healing_reduction)
end

-- lower the on-kill godmode length for leech
function PlayerDamage:on_copr_killshot()
	self._next_allowed_dmg_t = Application:digest_value(managers.player:player_timer():time() + 0.45, true)
	self._last_received_dmg = self:_max_health()
end

-- faks only heal a small portion but then heal you over time
function PlayerDamage:band_aid_health(hot_regen)
	if managers.platform:presence() == "Playing" and (self:arrested() or self:need_revive()) then
		return
	end

	self:restore_health(tweak_data.upgrades.values.first_aid_kit.heal_amount)
	if hot_regen then
		managers.player:activate_temporary_upgrade("temporary", "first_aid_health_regen")
	end

	self._said_hurt = false
end

-- Fix Anarchist regen not triggering HUD armor update for clients
Hooks:PostHook(PlayerDamage, "change_armor", "eclipse_change_armor", function(self, change)
	if change > 0 and self:armor_ratio() < 1 then
		self:_send_set_armor()
	end
end)

-- Friendly Fire
function PlayerDamage:is_friendly_fire(unit)
	local attacker_mov_ext = alive(unit) and unit:movement()

	if not attacker_mov_ext or not attacker_mov_ext.team or not attacker_mov_ext.friendly_fire then
		return false
	end

	local my_team = self._unit:movement():team()
	local attacker_team = attacker_mov_ext:team()

	if attacker_team ~= my_team and attacker_mov_ext:friendly_fire() then
		return false
	end
	local pro_job_enabled = Global.game_settings and Global.game_settings.one_down
	local attacked_by_foe = attacker_team and my_team and my_team.foes[attacker_team.id]
	local friendly_fire_mutator_active = managers.mutators:modify_value("PlayerDamage:FriendlyFire", friendly_fire_mutator_active) == false
	if not attacked_by_foe then
		if pro_job_enabled or friendly_fire_mutator_active then
			return false
		end
		return true
	end
	return false
end
