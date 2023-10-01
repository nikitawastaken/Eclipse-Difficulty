-- Limit logic updates, there's no need to update it every frame
local update_original = CivilianBrain.update
function CivilianBrain:update(unit, t, ...)
	if self._next_logic_upd_t <= t then
		self._next_logic_upd_t = t + 1 / 30
		return update_original(self, unit, t, ...)
	end
end

function CivilianBrain:init(unit)
	self._unit = unit
	self._timer = TimerManager:game()

	self:set_update_enabled_state(false)

	self._current_logic = nil
	self._current_logic_name = nil
	self._active = true
	self._SO_access = managers.navigation:convert_access_flag(tweak_data.character[unit:base()._tweak_table].access)
	self._slotmask_enemies = managers.slot:get_mask("criminals")
	CopBrain._reload_clbks[unit:key()] = callback(self, self, "on_reload")

	if unit:base().add_tweak_data_changed_listener then
		unit:base():add_tweak_data_changed_listener("CivilianBrainTweakDataChange" .. tostring(unit:key()), callback(self, self, "_clbk_tweak_data_changed"))
	end

	local extra_hostages = managers.player:has_category_upgrade("player", "extra_hostages")
	if extra_hostages then
		tweak_data.player.max_nr_following_hostages = 5 -- i don't like this way of doing it but i don't care enough to investigate why the addend upgrade is being cringe here
	end
end