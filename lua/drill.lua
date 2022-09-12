-- Make autorepair reroll everytime the drill is jammed and fix swapped values
Hooks:PreHook(Drill, "set_jammed", "shc_set_jammed", function (self, jammed)

	if Network:is_server() and jammed and not self._jammed then
		local current_auto_repair_level_1 = self._skill_upgrades.auto_repair_level_1 or 0
		local current_auto_repair_level_2 = self._skill_upgrades.auto_repair_level_2 or 0
		local drill_autorepair_chance = 0

		if current_auto_repair_level_1 > 0 then
			drill_autorepair_chance = drill_autorepair_chance + tweak_data.upgrades.values.player.drill_autorepair_1[1]
		end
		if current_auto_repair_level_2 > 0 then
			drill_autorepair_chance = drill_autorepair_chance + tweak_data.upgrades.values.player.drill_autorepair_2[1]
		end

		self:set_autorepair(math.random() < drill_autorepair_chance, true)
	end
end)

-- Reduce time it takes for autorepair to kick in
function Drill:set_autorepair(state, jammed)
	self._autorepair = state

	if self._autorepair_clbk_id then
		managers.enemy:remove_delayed_clbk(self._autorepair_clbk_id)
		self._autorepair_clbk_id = nil
	end

	if state and (self._jammed or jammed) then
		self._autorepair_clbk_id = "Drill_autorepair" .. tostring(self._unit:key())
		managers.enemy:add_delayed_clbk(self._autorepair_clbk_id, callback(self, self, "clbk_autorepair"), TimerManager:game():time() + 5 + 5 * math.random())
	end
end