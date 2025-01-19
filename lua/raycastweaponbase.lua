local init_original = RaycastWeaponBase.init
function RaycastWeaponBase:init(...)
	init_original(self, ...)

	-- Friendly Fire
	if Global.game_settings and Global.game_settings.one_down then
		self._bullet_slotmask = self._bullet_slotmask + 3
	else
		self._bullet_slotmask = managers.mutators:modify_value("RaycastWeaponBase:setup:weapon_slot_mask", self._bullet_slotmask)
	end
end

-- No aim assist (shc)
Hooks:PostHook(RaycastWeaponBase, "init", "eclipse_init", function(self)
	if self._autohit_data then
		self._autohit_current = 0
		self._autohit_data.INIT_RATIO = 0
		self._autohit_data.MIN_RATIO = 0
		self._autohit_data.MAX_RATIO = 0
	end
end)

function RaycastWeaponBase:exit_run_speed_multiplier()
	local weapon_tweak = tweak_data.weapon[self._name_id]
	local multiplier = 0.4 / (weapon_tweak.sprint_exit_time or 0.4)

	multiplier = multiplier * (weapon_tweak.exit_run_speed_multiplier or 1)

	for _, category in ipairs(self:weapon_tweak_data().categories) do
		multiplier = multiplier * managers.player:upgrade_value(category, "exit_run_speed_multiplier", 1)
	end

	multiplier = multiplier * managers.player:upgrade_value(self._name_id, "exit_run_speed_multiplier", 1)

	return multiplier
end

-- no elite shield pen
function RaycastWeaponBase.collect_hits(from, to, setup_data)
	setup_data = setup_data or {}
	local ray_hits = nil
	local hit_enemy = false
	local ignore_unit = setup_data.ignore_units or {}
	local enemy_mask = setup_data.enemy_mask
	local bullet_slotmask = setup_data.bullet_slotmask or managers.slot:get_mask("bullet_impact_targets")

	if setup_data.stop_on_impact then
		ray_hits = {}
		local hit = World:raycast("ray", from, to, "slot_mask", bullet_slotmask, "ignore_unit", ignore_unit)

		if hit then
			table.insert(ray_hits, hit)

			hit_enemy = hit.unit:in_slot(enemy_mask)
		end

		return ray_hits, hit_enemy, hit_enemy and {
			[hit.unit:key()] = hit.unit,
		} or nil
	end

	local can_shoot_through_wall = setup_data.can_shoot_through_wall
	local can_shoot_through_shield = setup_data.can_shoot_through_shield
	local can_shoot_through_enemy = setup_data.can_shoot_through_enemy
	local wall_mask = setup_data.wall_mask
	local shield_mask = setup_data.shield_mask
	local ai_vision_ids = Idstring("ai_vision")
	local bulletproof_ids = Idstring("bulletproof")

	if can_shoot_through_wall then
		ray_hits = World:raycast_wall("ray", from, to, "slot_mask", bullet_slotmask, "ignore_unit", ignore_unit, "thickness", 40, "thickness_mask", wall_mask)
	else
		ray_hits = World:raycast_all("ray", from, to, "slot_mask", bullet_slotmask, "ignore_unit", ignore_unit)
	end

	local unique_hits = {}
	local enemies_hit = {}
	local unit, u_key, is_enemy = nil
	local units_hit = {}
	local in_slot_func = Unit.in_slot
	local has_ray_type_func = Body.has_ray_type

	for i, hit in ipairs(ray_hits) do
		unit = hit.unit
		u_key = unit:key()

		if not units_hit[u_key] then
			units_hit[u_key] = true
			unique_hits[#unique_hits + 1] = hit
			hit.hit_position = hit.position
			is_enemy = in_slot_func(unit, enemy_mask)

			if is_enemy then
				enemies_hit[u_key] = unit
				hit_enemy = true
			end

			if not can_shoot_through_enemy and is_enemy then
				break
			elseif not can_shoot_through_shield and in_slot_func(unit, shield_mask) then
				break
			elseif not can_shoot_through_wall and in_slot_func(unit, wall_mask) and (has_ray_type_func(hit.body, ai_vision_ids) or has_ray_type_func(hit.body, bulletproof_ids)) then
				break
			elseif hit.unit:in_slot(shield_mask) and (hit.unit:name():key() == "af254947f0288a6c" or hit.unit:name():key() == "15cbabccf0841ff8") then -- hi thanks resmod if you're reading this :)
				break
			end
		end
	end

	return unique_hits, hit_enemy, hit_enemy and enemies_hit or nil
end

-- dragon's breath doesn't own shields anymore
function FlameBulletBase:bullet_slotmask()
	return managers.slot:get_mask("bullet_impact_targets")
end

-- Auto Fire Sound Fix
-- Thanks offyerrocker
_G.AutoFireSoundFixBlacklist = {
	["saw"] = true,
	["saw_secondary"] = true,
	["flamethrower_mk2"] = true,
	["m134"] = true,
	["mg42"] = true,
	["shuno"] = true,
	["system"] = true,
	["par"] = true,
}

Hooks:Register("AFSF2_OnWriteBlacklist")
Hooks:Add("BaseNetworkSessionOnLoadComplete", "AFSF2_OnLoadComplete", function()
	Hooks:Call("AFSF2_OnWriteBlacklist", AutoFireSoundFixBlacklist)
end)

--Check for if AFSF's fix code should apply to this particular weapon
function RaycastWeaponBase:_soundfix_should_play_normal()
	local name_id = self:get_name_id() or "xX69dank420blazermachineXx"
	if not self._setup.user_unit == managers.player:player_unit() then
		return true
	elseif tweak_data.weapon[name_id].use_fix ~= nil then
		return tweak_data.weapon[name_id].use_fix
	elseif AutoFireSoundFixBlacklist[name_id] then
		return true
	elseif not self:weapon_tweak_data().sounds.fire_single then
		return true
	end
	return false
end

--Prevent playing sounds except for blacklisted weapons
local orig_fire_sound = RaycastWeaponBase._fire_sound
function RaycastWeaponBase:_fire_sound(...)
	if self:_soundfix_should_play_normal() then
		return orig_fire_sound(self, ...)
	end
end

--Play sounds here instead for fix-applicable weapons; or else if blacklisted, use original function and don't play the fixed single-fire sound
--U200: there goes AFSF2's compatibility with other mods
Hooks:PreHook(RaycastWeaponBase, "fire", "autofiresoundfix2_raycastweaponbase_fire", function(self, ...)
	if not self:_soundfix_should_play_normal() then
		self._bullets_fired = 0
		self:play_tweak_data_sound(self:weapon_tweak_data().sounds.fire_single, "fire_single")
	end
end)

--stop_shooting is only used for fire sound loops, so playing individual single-fire sounds means it doesn't need to be called
local orig_stop_shooting = RaycastWeaponBase.stop_shooting
function RaycastWeaponBase:stop_shooting(...)
	if self:_soundfix_should_play_normal() then
		return orig_stop_shooting(self, ...)
	end
end
