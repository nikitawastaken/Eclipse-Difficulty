-- Rebalance melee weapons based on their range, concealment and speed
Hooks:PostHook(BlackMarketTweakData, "_init_melee_weapons", "shc__init_melee_weapons", function (self, tweak_data)
	local min_conceal, max_conceal = 30, 0
	local min_range, max_range = 300, 0
	local min_expire, max_expire = 10, 0
	for _, data in pairs(self.melee_weapons) do
		if data.stats.concealment then
			min_conceal = data.stats.concealment < min_conceal and data.stats.concealment or min_conceal
			max_conceal = data.stats.concealment > max_conceal and data.stats.concealment or max_conceal
		end

		if data.stats.range then
			min_range = data.stats.range < min_range and data.stats.range or min_range
			max_range = data.stats.range > max_range and data.stats.range or max_range
		end

		local expire = (data.expire_t + data.repeat_expire_t) * 0.5
		min_expire = expire < min_expire and expire or min_expire
		max_expire = expire > max_expire and expire or max_expire
	end

	local reference = self.melee_weapons.iceaxe
	local ref_dmg_min = reference.stats.min_damage
	local ref_dmg_max = reference.stats.max_damage
	local ref_charge_t = reference.stats.charge_time
	local ref_conceal = math.map_range(reference.stats.concealment, min_conceal, max_conceal, 1, 0)
	local ref_range = math.map_range(reference.stats.range, min_range, max_range, 1, 0)
	local ref_expire = (reference.expire_t + reference.repeat_expire_t) * 0.5

	local x_min = ref_dmg_min / (1 + ref_expire * 3 + ref_conceal + ref_range)
	local x_max = ((ref_dmg_max / ref_dmg_min) - 1) / ref_charge_t

	local function get_damage(expire, range, conceal, charge_t)
		local min = (1 + expire * 3 + conceal + range) * x_min
		local max = min + min * charge_t * x_max
		return min, max
	end

	for _, data in pairs(self.melee_weapons) do
		local expire = (data.expire_t + data.repeat_expire_t) * 0.5
		local range = math.map_range(data.stats.range, min_range, max_range, 1, 0)
		local conceal = math.map_range(data.stats.concealment or 30, min_conceal, max_conceal, 1, 0)
		local charge_t = data.stats.charge_time or 0
		local damage_mul = (data.tase_data or data.dot_data_name) and 0.4 or 1
		local effect_mul = (data.tase_data or data.dot_data_name) and 0.1 or 1
		local min, max = get_damage(expire, range, conceal, charge_t)
		data.stats.min_damage = math.round(min * damage_mul, 0.5)
		data.stats.max_damage = math.round(max * damage_mul, 0.5)
		data.stats.min_damage_effect = math.round((math.map_range(expire, min_expire, max_expire, 30, 350) + (data.melee_damage_delay or 0) * 350) * effect_mul, 10)
		data.stats.max_damage_effect = data.stats.min_damage_effect
		data.stats.remove_weapon_movement_penalty = nil
		data.stats.charge_time = data.stats.charge_time and data.stats.charge_time * 0.5
	end
end)
