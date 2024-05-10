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
