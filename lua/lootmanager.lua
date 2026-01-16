function LootManager:get_real_value(carry_id, multiplier)
	local mul_value = 1

	if not tweak_data.carry.small_loot[carry_id] then
	end

	return managers.money:get_bag_value(carry_id, multiplier)
end

function LootManager:get_secured_mandatory_bags_value(is_vehicle)
	local mandatory_bags_amount = self._global.mandatory_bags.amount or 0
	local value = 0

	for _, data in ipairs(self._global.secured) do
		if not tweak_data.carry.small_loot[data.carry_id] and not tweak_data.carry[data.carry_id].is_vehicle == not is_vehicle and mandatory_bags_amount > 0 and (self._global.mandatory_bags.carry_id == "none" or self._global.mandatory_bags.carry_id == data.carry_id) then
			mandatory_bags_amount = mandatory_bags_amount - 1
			value = value + managers.money:get_bag_value(data.carry_id, data.multiplier)
		end
	end

	return value
end