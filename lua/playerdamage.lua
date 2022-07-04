-- uppers cooldown
PlayerDamage._UPPERS_COOLDOWN = 60

-- Reduce the bleedout timer on od and increase down counter to 2
Hooks:PreHook(PlayerDamage, "replenish", "eclipse__replenish", function(self)
    if Global.game_settings.one_down then
        self._lives_init = 3
        tweak_data.player.damage.DOWNED_TIME = 20
    end
end)

-- The entirety of the code here is done by Hoppip, thanks again if you're reading this
-- Grace period protects no matter the new potential damage but is shorter in general
function PlayerDamage:_chk_dmg_too_soon()
	local next_allowed_dmg_t = type(self._next_allowed_dmg_t) == "number" and self._next_allowed_dmg_t or Application:digest_value(self._next_allowed_dmg_t, false)
	return managers.player:player_timer():time() < next_allowed_dmg_t
end

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
