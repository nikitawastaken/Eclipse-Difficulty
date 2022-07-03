-- Fix enemies that were in panic state getting stuck
local need_upd_original = CopActionAct.need_upd
function CopActionAct:need_upd(...)
	return self._ext_anim.fumble or need_upd_original(self, ...)
end
