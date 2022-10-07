-- uppers cooldown
PlayerDamage._UPPERS_COOLDOWN = 60

-- Pro-Job adds bleedout time and revive health scaling (as well as friendly fire)
Hooks:PreHook(PlayerDamage, "replenish", "eclipse_replenish", function(self)
    if Global.game_settings.one_down then
        self._lives_init = 4
        tweak_data.player.damage.DOWNED_TIME = 25
		tweak_data.player.damage.DOWNED_TIME_DEC = 10
		tweak_data.player.damage.DOWNED_TIME_MIN = 1
		tweak_data.player.damage.REVIVE_HEALTH_STEPS = {0.6, 0.35, 0.1}
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

	if Global.game_settings and Global.game_settings.one_down and unit:base() and unit:base().is_husk_player then
		friendly_fire = false
	else
		local friendly_fire = attacker_team and not attacker_team.foes[my_team.id]
		friendly_fire = managers.mutators:modify_value("PlayerDamage:FriendlyFire", friendly_fire)
	end

	return friendly_fire
end

-- The entirety of the code here is done by Hoppip, thanks again if you're reading this
-- Grace period protects no matter the new potential damage but is shorter in general
function PlayerDamage:_chk_dmg_too_soon()
	local next_allowed_dmg_t = type(self._next_allowed_dmg_t) == "number" and self._next_allowed_dmg_t or Application:digest_value(self._next_allowed_dmg_t, false)
	return managers.player:player_timer():time() < next_allowed_dmg_t
end

-- Add slightly longer grace period on dodge (repurposing Anarchist/Armorer damage timer)
Hooks:PostHook(PlayerDamage, "_send_damage_drama", "sh__send_damage_drama", function (self, attack_data, health_subtracted)
	if health_subtracted == 0 and self._can_take_dmg_timer and self._can_take_dmg_timer <= 0 then
		self._can_take_dmg_timer = self._dmg_interval + 0.2
	end
end)

-- Add significantly longer grace period on armor break (repurposing Anarchist/Armorer damage timer)
local _calc_armor_damage_original = PlayerDamage._calc_armor_damage
function PlayerDamage:_calc_armor_damage(...)
	local had_armor = self:get_real_armor() > 0

	local health_subtracted = _calc_armor_damage_original(self, ...)

	if health_subtracted > 0 and had_armor and self:get_real_armor() <= 0 and self._can_take_dmg_timer <= 0 then
		self._can_take_dmg_timer = self._dmg_interval + 0.3
	end

	return health_subtracted
end

-- make healing fixed instead of % of max health
function PlayerDamage:restore_health(health_restored, is_static, chk_health_ratio)
	if chk_health_ratio and managers.player:is_damage_health_ratio_active(self:health_ratio()) then
		return false
	end

	if is_static then
		return self:change_health(health_restored * self._healing_reduction)
	else
		return self:change_health(health_restored * self._healing_reduction)
	end
end

-- add an upgrade that gives increased bleedout timer
Hooks:PostHook(PlayerDamage, "_regenerated", "eclipse__regenerated", function(self)
	self._down_time = tweak_data.player.damage.DOWNED_TIME + managers.player:upgrade_value("player", "increased_bleedout_timer", 0)
end)

-- lower the on-kill godmode length for leech
function PlayerDamage:on_copr_killshot()
	self._next_allowed_dmg_t = Application:digest_value(managers.player:player_timer():time() + 0.45, true)
	self._last_received_dmg = self:_max_health()
end

-- bring back decreasing bleedout timer based on the amount of downs
Hooks:PreHook(PlayerDamage, "revive", "eclipse_revive", function(self)
	if not self:arrested() then
	  self._down_time = math.max(tweak_data.player.damage.DOWNED_TIME_MIN, self._down_time - tweak_data.player.damage.DOWNED_TIME_DEC)
	end
end)

