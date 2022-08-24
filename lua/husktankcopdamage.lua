-- Make shotgun pellets prioritize dozer's faceplate and visor (from the fixes)
local origfunc = HuskTankCopDamage and HuskTankCopDamage.is_head or nil
function HuskTankCopDamage:is_head(body, ...)
	local head = origfunc and origfunc(self, body, ...) or HuskTankCopDamage.super.is_head(self, body, ...)
	
	if not head and body
		and (not TheFixes or TheFixes.shotgun_dozer_face)
	then
		local bn = body:name():key()
		if bn == 'f46eb16d189339da'
			or bn == 'f260d73afd0c74fe'
		then
			head = true
		end
	end
	
	return head
end