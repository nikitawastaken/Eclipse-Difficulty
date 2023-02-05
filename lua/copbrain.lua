-- Set up boss logics
CopBrain._logic_variants.mobster_boss = CopBrain._logic_variants.triad_boss
CopBrain._logic_variants.chavez_boss = CopBrain._logic_variants.triad_boss
CopBrain._logic_variants.hector_boss = CopBrain._logic_variants.triad_boss
CopBrain._logic_variants.drug_lord_boss = CopBrain._logic_variants.triad_boss
CopBrain._logic_variants.biker_boss = CopBrain._logic_variants.triad_boss
CopBrain._logic_variants.tank_elite = CopBrain._logic_variants.tank


-- Fix spamming of grenades by units that dodge with grenades (Cloaker)
local _chk_use_cover_grenade_original = CopBrain._chk_use_cover_grenade
function CopBrain:_chk_use_cover_grenade(...)
	if not self._next_cover_grenade_chk_t or self._next_cover_grenade_chk_t < TimerManager:game():time() then
		return _chk_use_cover_grenade_original(self, ...)
	end
end


-- Don't trigger damage callback from dot damage as it would make enemies go into shoot action
-- when they stand inside a poison cloud or molotov, regardless of any targets being visible or not
local clbk_damage_original = CopBrain.clbk_damage
function CopBrain:clbk_damage(my_unit, damage_info, ...)
	if damage_info.variant ~= "poison" and not damage_info.is_fire_dot_damage and not damage_info.is_molotov then
		return clbk_damage_original(self, my_unit, damage_info, ...)
	end
end


-- Set Joker owner to keep follow objective correct
Hooks:PreHook(CopBrain, "convert_to_criminal", "sh_convert_to_criminal", function (self, mastermind_criminal)
	self._logic_data.minion_owner = mastermind_criminal or managers.player:local_player()
end)


-- If Iter is installed and streamlined path option is used, don't make any further changes
if Iter and Iter.settings and Iter.settings.streamline_path then
	return
end


-- Call pathing results callback in logic if it exists
Hooks:PostHook(CopBrain, "clbk_pathing_results", "sh_clbk_pathing_results", function (self)
	local current_logic = self._current_logic
	if current_logic.on_pathing_results then
		current_logic.on_pathing_results(self._logic_data)
	end
end)
