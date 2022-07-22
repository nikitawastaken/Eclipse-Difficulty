-- Prevent hurt and knockdown animations stacking, once one plays it needs to finish for another one to trigger
local hurt_blocks = {
	heavy_hurt = true,
	hurt = true,
	hurt_sick = true,
	knock_down = true,
	poison_hurt = true,
	shield_knock = true,
	stagger = true
}
Hooks:OverrideFunction(CopActionHurt, "chk_block", function (self, action_type, t)
	if self._hurt_type == "death" then
		return true
	elseif hurt_blocks[action_type] and not self._ext_anim.hurt_exit then
		return true
	elseif action_type == "turn" then
		return true
	elseif action_type == "death" then
		return false
	end

	return CopActionAct.chk_block(self, action_type, t)
end)