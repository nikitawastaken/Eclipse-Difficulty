function MoneyManager:get_secured_bonus_bags_money()
	local job_id = managers.job:current_job_id()
	local stars = managers.job:has_active_job() and managers.job:current_difficulty_stars() or 0
	local money_multiplier = self:get_contract_difficulty_multiplier(stars)
	local total_stages = job_id and #tweak_data.narrative:job_chain(job_id) or 1
	local bag_skill_bonus = managers.player:upgrade_value("player", "secured_bags_money_multiplier", 1)
	local bonus_bags = managers.loot:get_secured_bonus_bags_value(managers.job:current_level_id()) + managers.loot:get_secured_bonus_bags_value(managers.job:current_level_id(), true)
	local bag_value = bonus_bags
	local bag_risk = math.round(bag_value * money_multiplier)

	-- return math.round((bag_value + bag_risk) * bag_skill_bonus / self:get_tweak_value("money_manager", "offshore_rate"))
	return bag_value
end

function MoneyManager:get_secured_mandatory_bags_money()
	local mandatory_value = managers.loot:get_secured_mandatory_bags_value()
	local bag_skill_bonus = managers.player:upgrade_value("player", "secured_bags_money_multiplier", 1)

	return mandatory_value
end

function MoneyManager:get_secured_bonus_bag_value(carry_id, multiplier)
	local carry_value = managers.money:get_bag_value(carry_id, multiplier)
	local bag_value = 0
	local bag_risk = 0
	local bag_skill_bonus = managers.player:upgrade_value("player", "secured_bags_money_multiplier", 1)

	if managers.loot:is_bonus_bag(carry_id) then
		local job_id = managers.job:current_job_id()
		local stars = managers.job:has_active_job() and managers.job:current_difficulty_stars() or 0
		local money_multiplier = self:get_contract_difficulty_multiplier(stars)
		local total_stages = job_id and #tweak_data.narrative:job_chain(job_id) or 1
		bag_value = carry_value
		bag_risk = math.round(bag_value * money_multiplier)
	else
		bag_value = carry_value
	end

	-- return math.round((bag_value + bag_risk) * bag_skill_bonus / self:get_tweak_value("money_manager", "offshore_rate"))
	return bag_value
end

function MoneyManager:get_job_bag_value() end

function MoneyManager:get_bag_value(carry_id, multiplier)
	local value = tweak_data.carry.small_loot[carry_id]

	if value then
		value = value
	else
		local bag_value_id = tweak_data.carry[carry_id].bag_value or "default"
		value = self:get_tweak_value("money_manager", "bag_values", bag_value_id)
	end

	return value
end

function MoneyManager:_add_to_total(amount, params, reason)
	local no_offshore = params and params.no_offshore
	local offshore = math.round(no_offshore and 0 or amount * (1 - 0.3)) -- currently default offshore rate is 0.04
	local spending_cash = math.round(no_offshore and amount or amount * 0.3)
	local rounding_error = math.round(amount - (offshore + spending_cash))
	spending_cash = spending_cash + rounding_error
	local total_cash = self:total() + spending_cash
	local total_collected_cash = self:total_collected() + math.round(amount)
	local offshore_cash = self:offshore() + offshore

	self:_set_total(total_cash)
	self:_set_total_collected(total_collected_cash)
	self:_set_offshore(offshore_cash)
	self:_on_total_changed(amount, spending_cash, offshore)

	reason = reason or "generic"

	-- Telemetry:send_on_player_economy_event(reason, "cash", amount, "earn")

	if managers.challenge then
		managers.challenge:award_progress("earn_cash", math.max(spending_cash, 0))
		managers.challenge:award_progress("earn_offshore_cash", math.max(offshore, 0))
	end
end

function MoneyManager:get_contract_difficulty_multiplier(stars)
	return self:get_tweak_value("money_manager", "difficulty_multiplier", stars)
end

function MoneyManager:get_money_by_params(params)
	local is_pro_job = Eclipse.utils.is_pro_job()
	local pro_mul = 1
	if is_pro_job then pro_mul = 1.2 else pro_mul = 1 end
	local job_id = params.job_id
	local job_stars = params.job_stars or 0
	local difficulty_stars = params.difficulty_stars or params.risk_stars or 0
	local job_and_difficulty_stars = job_stars + difficulty_stars
	local success = params.success
	local num_winners = params.num_winners or 1
	local on_last_stage = params.on_last_stage
	local current_job_stage = params.current_stage or 1
	local total_stages = job_id and #tweak_data.narrative:job_chain(job_id) or 1
	local player_stars = params.player_stars or managers.experience:level_to_stars() or 0
	local total_stars = math.min(job_stars, player_stars)
	local total_difficulty_stars = difficulty_stars
	local money_multiplier = self:get_contract_difficulty_multiplier(total_difficulty_stars)
	local contract_money_multiplier = money_multiplier
	local small_loot_multiplier = managers.money:get_small_loot_difficulty_multiplier(total_difficulty_stars) or 0
	local cash_skill_bonus, bag_skill_bonus = managers.player:get_skill_money_multiplier(managers.groupai and managers.groupai:state():whisper_mode())
	local bonus_bags = params.bonus_bags_value or managers.loot:get_secured_bonus_bags_value(params.level_id)
	local mandatory_bags = params.mandatory_bags_value or managers.loot:get_secured_mandatory_bags_value()
	local real_small_value = params.small_value or math.round(managers.loot:get_real_total_small_loot_value())
	local bonus_vehicles = params.vehicle_value or math.round(managers.loot:get_secured_bonus_bags_value(nil, true))
	local offshore_rate = self:get_tweak_value("money_manager", "offshore_rate")
	local total_payout = 0
	local stage_value = 0
	local job_value = 0
	local bag_value = 0
	local vehicle_value = 0
	local small_value = 0
	local crew_value = 0
	local stage_risk = 0
	local job_risk = 0
	local bag_risk = 0
	local vehicle_risk = 0
	local small_risk = 0
	local static_value, base_static_value, risk_static_value = self:get_money_by_job(job_id, difficulty_stars + 1)
	static_value = static_value * cash_skill_bonus
	base_static_value = static_value - risk_static_value

	if static_value then
		small_value = real_small_value + managers.loot:get_real_total_postponed_small_loot_value()

		if tweak_data:get_value("money_manager", "max_small_loot_value") < small_value then
			print("[MoneyManager:get_money_by_params] - Small Loot drop was too much", small_value, tweak_data.carry.max_small_loot_value)

			small_value = tweak_data:get_value("money_manager", "max_small_loot_value")
		end

		if on_last_stage then
			bag_value = bonus_bags
			bag_risk = math.round(bag_value * money_multiplier * bag_skill_bonus)
			bag_value = (bag_value + mandatory_bags) * bag_skill_bonus
			vehicle_value = bonus_vehicles
			total_payout = math.max(0, math.round((static_value + bag_value + vehicle_value + small_value)))
			stage_value = 0
			crew_value = total_payout
			total_payout = math.max(0, math.round(total_payout * self:get_tweak_value("money_manager", "alive_humans_multiplier", num_winners)))
			crew_value = total_payout - crew_value
		else
			total_payout = small_value
		end

		local limited_bonus = self:get_tweak_value("money_manager", "limited_bonus_multiplier") or 1

		if limited_bonus > 1 then
			stage_value = stage_value * limited_bonus
			stage_risk = stage_risk * limited_bonus
			bag_value = bag_value * limited_bonus
			bag_risk = bag_risk * limited_bonus
			vehicle_value = vehicle_value * limited_bonus
			vehicle_risk = vehicle_risk * limited_bonus
			small_value = small_value * limited_bonus
			small_risk = small_risk * limited_bonus
			crew_value = crew_value * limited_bonus
			total_payout = total_payout * limited_bonus
		end

		if on_last_stage then
			local tweakdata_job = tweak_data.narrative:job_data(job_id)
			local difficulty_index = tweak_data:difficulty_to_index(Global.game_settings.difficulty)
			job_risk = (pro_mul * (((tweakdata_job.payout[1] / 2) + tweakdata_job.payout[difficulty_index]) * money_multiplier)) or 0 -- tweakdata_job.payout[total_difficulty_stars] or 0 -- math.max(0, math.round(risk_static_value / offshore_rate))
			job_value = (pro_mul * (tweakdata_job.payout[1])) or 0 -- tweakdata_job.payout[1] or 0 -- math.max(0, math.round(static_value / offshore_rate) - job_risk)
		end

		if managers.skirmish:is_skirmish() then
			local skirmish_payout = managers.skirmish:current_ransom_amount()
			total_payout = math.max(0, math.round(total_payout + skirmish_payout))
		end
	else
		stage_value = self:get_stage_payout_by_stars(total_stars) or 0
		local mandatory_bag_value = 0
		local bonus_bag_value = 0
		small_value = real_small_value + managers.loot:get_real_total_postponed_small_loot_value()

		if on_last_stage then
			job_value = self:get_job_payout_by_stars(total_stars) or 0
			bonus_bag_value = bonus_bags
			mandatory_bag_value = mandatory_bags
		end

		bag_risk = math.round(bonus_bag_value * money_multiplier)
		small_risk = math.round(small_value * small_loot_multiplier)
		total_payout = stage_value + (job_value + job_risk) + bonus_bag_value + vehicle_value + mandatory_bag_value + small_value
		crew_value = math.round(total_payout)
		total_payout = math.round(total_payout * (self:get_tweak_value("money_manager", "alive_humans_multiplier", num_winners) or 1))
		crew_value = math.round(total_payout - crew_value)

		if not static_value then
			if on_last_stage then
			job_risk = (pro_mul * (((tweakdata_job.payout[1] / 2) + tweakdata_job.payout[difficulty_index]) * money_multiplier)) or 0 -- tweakdata_job.payout[total_difficulty_stars] or 0 -- math.max(0, math.round(risk_static_value / offshore_rate))
			job_value = (pro_mul * (tweakdata_job.payout[1])) or 0 -- tweakdata_job.payout[1] or 0 -- math.max(0, math.round(static_value / offshore_rate) - job_risk)
			end
		end
	end

	local mutators_multiplier = managers.mutators:get_cash_multiplier()
	local original_total_payout = total_payout
	total_payout = total_payout * mutators_multiplier
	stage_value = stage_value * mutators_multiplier
	job_value = job_value * mutators_multiplier
	bag_value = bag_value * mutators_multiplier
	vehicle_value = vehicle_value * mutators_multiplier
	small_value = small_value * mutators_multiplier
	crew_value = crew_value * mutators_multiplier
	stage_risk = stage_risk * mutators_multiplier
	job_risk = job_risk * mutators_multiplier
	bag_risk = bag_risk * mutators_multiplier
	vehicle_risk = vehicle_risk * mutators_multiplier
	small_risk = small_risk * mutators_multiplier
	local mutators_reduction = original_total_payout - total_payout
	local ret = {
		stage_value,
		job_value,
		bag_value,
		vehicle_value,
		small_value,
		crew_value,
		total_payout,
		{
			stage_risk = stage_risk,
			job_risk = job_risk,
			bag_risk = bag_risk,
			vehicle_risk = vehicle_risk,
			small_risk = small_risk,
		},
		{
			job_base_payout = base_static_value,
			job_risk_payout = risk_static_value,
		},
		mutators_reduction,
	}

	return unpack(ret)
end

function MoneyManager:on_mission_completed(num_winners)
	if managers.crime_spree:is_active() then
		managers.loot:clear_postponed_small_loot()

		return
	end

	if managers.job:skip_money() then
		managers.loot:set_postponed_small_loot()

		return
	end

	local stage_value, job_value, bag_value, vehicle_value, small_value, crew_value, total_payout, risk_table, payout_table, mutators_reduction = self:get_real_job_money_values(num_winners)

	managers.loot:clear_postponed_small_loot()
	self:_set_stage_payout(stage_value)
	self:_set_job_payout(job_value + risk_table.job_risk)
	self:_set_bag_payout(bag_value)
	self:_set_vehicle_payout(vehicle_value)
	self:_set_small_loot_payout(small_value)
	self:_set_crew_payout(crew_value)

	self._mutators_reduction = mutators_reduction

	-- Telemetry:set_mission_payout(total_payout)
	self:_add_to_total(total_payout, nil, TelemetryConst.economy_origin.mission_complete_reward)
end