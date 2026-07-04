-- Don't stop moving as long no enemy is any closer than a player
function CivilianLogicEscort.too_scared_to_move(data)
	local min_dis_sq = 1000 ^ 2
	local closest_criminal_dis_sq = math.huge

	for _, c_data in pairs(managers.groupai:state():all_char_criminals()) do
		local dis_sq = mvector3.distance_sq(c_data.m_pos, data.m_pos)
		if dis_sq < min_dis_sq and dis_sq < closest_criminal_dis_sq then
			closest_criminal_dis_sq = dis_sq
		end
	end

	if min_dis_sq < closest_criminal_dis_sq then
		return "abandoned"
	end

	local player_team_id = tweak_data.levels:get_default_team_ID("player")
	for _, e_data in pairs(managers.enemy:all_enemies()) do
		local anim_data = e_data.unit:anim_data()
		local surrendered = anim_data.hands_back or anim_data.surrender or anim_data.hands_tied or e_data.unit:brain()._current_logic_name == "trade"
		if not surrendered and e_data.unit:movement():team().foes[player_team_id] and math.abs(e_data.m_pos.z - data.m_pos.z) < 250 then
			local dis_sq = mvector3.distance_sq(e_data.m_pos, data.m_pos)
			if dis_sq < closest_criminal_dis_sq then
				return "pigs"
			end
		end
	end
end
