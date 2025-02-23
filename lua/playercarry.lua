function PlayerCarry:_perform_jump(jump_vec)
	mvector3.multiply(jump_vec, tweak_data.carry.types[self._tweak_data_name].jump_modifier)

	PlayerCarry.super._perform_jump(self, jump_vec)
end

function PlayerCarry:_get_max_walk_speed(...)
	local multiplier = tweak_data.carry.types[self._tweak_data_name].move_speed_modifier

	--[[ if managers.player:has_category_upgrade("carry", "movement_penalty_nullifier") then
		multiplier = 1
	else ]]
	multiplier = math.clamp(multiplier * managers.player:upgrade_value("carry", "movement_speed_multiplier", 1), 0, 1)
	multiplier = math.clamp(multiplier * managers.player:upgrade_value("player", "mrwi_carry_speed_multiplier", 1), 0, 1)
	-- end

	if managers.player:has_category_upgrade("player", "armor_carry_bonus") then
		local base_max_armor = armor_init + managers.player:body_armor_value("armor") + managers.player:body_armor_skill_addend()
		local mul = managers.player:upgrade_value("player", "armor_carry_bonus", 1)

		for i = 1, base_max_armor do
			multiplier = multiplier * mul
		end

		multiplier = math.clamp(multiplier, 0, 1)
	end

	local mutator = nil

	if managers.mutators:is_mutator_active(MutatorCG22) then
		mutator = managers.mutators:get_mutator(MutatorCG22)
	elseif managers.mutators:is_mutator_active(MutatorPiggyRevenge) then
		mutator = managers.mutators:get_mutator(MutatorPiggyRevenge)
	end

	if mutator and mutator.get_bag_speed_increase_multiplier then
		multiplier = multiplier * mutator:get_bag_speed_increase_multiplier()
	end

	return PlayerCarry.super._get_max_walk_speed(self, ...) * multiplier
end

function PlayerCarry:_check_use_item(t, input)
	local new_action = nil
	local action_wanted = input.btn_use_item_release and self._throw_time and t and t < self._throw_time

	if input.btn_use_item_press then
		self._throw_down = true
		self._second_press = false
		self._throw_time = t + PlayerCarry.throw_limit_t
	end

	if action_wanted then
		managers.player:drop_carry()
		new_action = true
	end

	if self._throw_down then
		if input.btn_use_item_release then
			self._throw_down = false
			self._second_press = false

			return PlayerCarry.super._check_use_item(self, t, input)
		elseif self._throw_time < t then
			if not self._second_press then
				input.btn_use_item_press = true
				self._second_press = true
			end

			return PlayerCarry.super._check_use_item(self, t, input)
		end
	end

	return new_action
end
