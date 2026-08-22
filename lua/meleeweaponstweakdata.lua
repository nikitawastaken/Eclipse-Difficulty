-- Rebalance melee weapons based on their range, concealment, speed, and type
Hooks:PostHook(BlackMarketTweakData, "_init_melee_weapons", "eclipse_init_melee_weapons", function(self, tweak_data)
	self.melee_weapons.iceaxe.stats.min_damage = 2
	self.melee_weapons.iceaxe.stats.max_damage = 8

	-- Change a few weapons' damage type
	self.melee_weapons.buck.stats.weapon_type = "blunt"
	self.melee_weapons.tiger.stats.weapon_type = "sharp"
	self.melee_weapons.cs.stats.weapon_type = "sharp"
	self.melee_weapons.push.stats.weapon_type = "sharp"
	self.melee_weapons.poker.stats.weapon_type = "sharp"
	self.melee_weapons.meter.stats.weapon_type = "blunt"
	self.melee_weapons.hockey.stats.weapon_type = "blunt"
	self.melee_weapons.croupier_rake.stats.weapon_type = "blunt"
	self.melee_weapons.slot_lever.stats.weapon_type = "blunt"
	self.melee_weapons.barbedwire.stats.weapon_type = "blunt"
	self.melee_weapons.baseballbat.stats.weapon_type = "blunt"
	self.melee_weapons.briefcase.stats.weapon_type = "blunt"
	self.melee_weapons.model24.stats.weapon_type = "blunt"
	self.melee_weapons.swagger.stats.weapon_type = "blunt"
	self.melee_weapons.shillelagh.stats.weapon_type = "blunt"
	self.melee_weapons.detector.stats.weapon_type = "blunt"
	self.melee_weapons.microphone.stats.weapon_type = "blunt"
	self.melee_weapons.micstand.stats.weapon_type = "blunt"
	self.melee_weapons.oldbaton.stats.weapon_type = "blunt"
	self.melee_weapons.branding_iron.stats.weapon_type = "blunt"
	self.melee_weapons.morning.stats.weapon_type = "blunt"

	-- Change some melee weapons' animations for better ones
	self.melee_weapons.fireaxe.anim_global_param = "melee_pickaxe"
	self.melee_weapons.fireaxe.align_objects = { "a_weapon_left" }
	self.melee_weapons.fireaxe.melee_damage_delay = 0.08
	self.melee_weapons.fireaxe.expire_t = 1.1
	self.melee_weapons.fireaxe.repeat_expire_t = 0.8

	self.melee_weapons.beardy.anim_global_param = "melee_pickaxe"
	self.melee_weapons.beardy.align_objects = { "a_weapon_left" }
	self.melee_weapons.beardy.melee_damage_delay = 0.08
	self.melee_weapons.beardy.expire_t = 1.1
	self.melee_weapons.beardy.repeat_expire_t = 0.9
	self.melee_weapons.beardy.sounds = {
		equip = "beardy_equip",
		hit_air = "fire_axe_hit_air",
		hit_gen = "beardy_hit_gen",
		hit_body = "beardy_hit_body",
		charge = "knife_charge",
	}

	self.melee_weapons.dingdong.anim_global_param = "melee_pickaxe"
	self.melee_weapons.dingdong.align_objects = { "a_weapon_left" }
	self.melee_weapons.dingdong.melee_damage_delay = 0.1
	self.melee_weapons.dingdong.expire_t = 1.1
	self.melee_weapons.dingdong.repeat_expire_t = 0.8

	self.melee_weapons.alien_maul.anim_global_param = "melee_pickaxe"
	self.melee_weapons.alien_maul.align_objects = { "a_weapon_left" }
	self.melee_weapons.alien_maul.melee_damage_delay = 0.1
	self.melee_weapons.alien_maul.expire_t = 1.1
	self.melee_weapons.alien_maul.repeat_expire_t = 0.8

	self.melee_weapons.baseballbat.anim_global_param = "melee_sandsteel"
	self.melee_weapons.baseballbat.align_objects = { "a_weapon_right" }
	self.melee_weapons.baseballbat.repeat_expire_t = 1
	self.melee_weapons.baseballbat.expire_t = 1.25
	self.melee_weapons.baseballbat.melee_damage_delay = 0.1

	self.melee_weapons.great.anim_global_param = "melee_sandsteel"
	self.melee_weapons.great.align_objects = { "a_weapon_right" }
	self.melee_weapons.great.repeat_expire_t = 1.025
	self.melee_weapons.great.expire_t = 1.35
	self.melee_weapons.great.melee_damage_delay = 0.1

	self.melee_weapons.barbedwire.anim_global_param = "melee_sandsteel"
	self.melee_weapons.barbedwire.align_objects = { "a_weapon_right" }
	self.melee_weapons.barbedwire.repeat_expire_t = 1
	self.melee_weapons.barbedwire.expire_t = 1.25
	self.melee_weapons.barbedwire.melee_damage_delay = 0.1

	local min_conceal, max_conceal = 30, 0
	local min_range, max_range = 300, 0
	local min_expire, max_expire = 10, 0
	for id, data in pairs(self.melee_weapons) do
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

	for id, data in pairs(self.melee_weapons) do
		data.melee_charge_shaker = "" -- Hacky way to disable the shaker effect while charging a melee weapon

		local is_blunt = data.stats.weapon_type == "blunt"
		local is_sharp = data.stats.weapon_type == "sharp"
		local golden_spoon = id == "spoon_gold"
		local expire = (data.expire_t + data.repeat_expire_t) * 0.5
		local range = math.map_range(data.stats.range, min_range, max_range, 1, 0)
		local conceal = math.map_range(data.stats.concealment or 30, min_conceal, max_conceal, 1, 0)
		local charge_t = data.stats.charge_time or 0
		local damage_mul = (golden_spoon and 1 or (data.tase_data or data.dot_data_name) and 0.4 or 1) * (is_blunt and 3 / 4 or 1)
		local effect_mul = (golden_spoon and 1 or (data.tase_data or data.dot_data_name) and 0 or 1) * (is_sharp and 2 / 3 or 1)

		local min, max = get_damage(expire, range, conceal, charge_t)
		data.stats.min_damage = math.round(min * damage_mul, 0.5)
		data.stats.max_damage = math.round(max * damage_mul, 0.5)
		data.stats.min_damage_effect = math.round((math.map_range(expire, min_expire, max_expire, 30, 350) + (data.melee_damage_delay or 0) * 350) * effect_mul, 10)
		data.stats.max_damage_effect = data.stats.min_damage_effect
		data.stats.charge_time = data.stats.charge_time and data.stats.charge_time * 0.5
		data.stats.headshot_damage_mul = data.tase_data and 0 or is_blunt and 4 / 3 or 1
		data.stats.remove_weapon_movement_penalty = nil
	end
end)
