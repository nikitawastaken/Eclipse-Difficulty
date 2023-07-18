if not Network:is_server() then
	return
end

-- Make team AI weapons alert enemies (oversight from when bots got the ability to use player weapons)
Hooks:PostHook(NewNPCRaycastWeaponBase, "set_user_is_team_ai", "sh_set_user_is_team_ai", function(self)
	if not self._setup or not alive(self._setup.user_unit) then
		return
	end

	self._setup.alert_AI = true
	self._setup.alert_filter = self._setup.user_unit:brain():SO_access()
	self._alert_events = {}
end)

-- This should not set ammo data for NPCs
function NewNPCRaycastWeaponBase:_update_stats_values(...)
	local can_shoot_through_shield = self._can_shoot_through_shield
	local can_shoot_through_enemy = self._can_shoot_through_enemy
	local can_shoot_through_wall = self._can_shoot_through_wall
	local bullet_class = self._bullet_class
	local bullet_slotmask = self._bullet_slotmask
	local blank_slotmask = self._blank_slotmask

	NewRaycastWeaponBase._update_stats_values(self, ...)

	self._can_shoot_through_shield = can_shoot_through_shield
	self._can_shoot_through_enemy = can_shoot_through_enemy
	self._can_shoot_through_wall = can_shoot_through_wall
	self._bullet_class = bullet_class
	self._bullet_slotmask = bullet_slotmask
	self._blank_slotmask = blank_slotmask
end

-- Disable player skills affecting NPC weapons
function NewNPCRaycastWeaponBase:get_add_head_shot_mul() end

function NewNPCRaycastWeaponBase:is_stagger() end
