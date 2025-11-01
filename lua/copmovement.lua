CopMovement._action_variants.cobra = CopMovement._action_variants.gangster
CopMovement._action_variants.fbi_shield = CopMovement._action_variants.shield
CopMovement._action_variants.city_tank = CopMovement._action_variants.tank
CopMovement._action_variants.hrt = CopMovement._action_variants.swat
CopMovement._action_variants.murky = CopMovement._action_variants.swat
CopMovement._action_variants.security_fat = CopMovement._action_variants.security
CopMovement._action_variants.security_female = CopMovement._action_variants.security
CopMovement._action_variants.security_mcmansion = CopMovement._action_variants.swat
CopMovement._action_variants.security_army = CopMovement._action_variants.swat
CopMovement._action_variants.cop_fat = CopMovement._action_variants.swat
CopMovement._action_variants.fbi_office = CopMovement._action_variants.swat
CopMovement._action_variants.fbi_office_mex = CopMovement._action_variants.swat
CopMovement._action_variants.soldier = CopMovement._action_variants.swat
CopMovement._action_variants.fbi_sniper = CopMovement._action_variants.sniper
CopMovement._action_variants.fbi_shield = CopMovement._action_variants.shield
CopMovement._action_variants.city_heavy_swat = CopMovement._action_variants.swat
CopMovement._action_variants.city_sniper = CopMovement._action_variants.swat
CopMovement._action_variants.city_shield = CopMovement._action_variants.shield
CopMovement._action_variants.city_shield_break = CopMovement._action_variants.swat
CopMovement._action_variants.marshal_security = CopMovement._action_variants.swat
CopMovement._action_variants.zeal_swat = CopMovement._action_variants.swat
CopMovement._action_variants.zeal_heavy_swat = CopMovement._action_variants.swat
CopMovement._action_variants.zeal_medic = CopMovement._action_variants.swat
CopMovement._action_variants.zeal_shield = CopMovement._action_variants.shield
CopMovement._action_variants.zeal_taser = CopMovement._action_variants.taser
CopMovement._action_variants.fbi_boss = CopMovement._action_variants.security

local mvec3_set = mvector3.set
local mvec3_add = mvector3.add
local mvec3_mul = mvector3.multiply
local temp_vec1 = Vector3()
local temp_vec2 = Vector3()
local temp_vec3 = Vector3()

function CopMovement:speed_modifier()
	local final_modifier = 1

	local move_speed_mul = self._tweak_data.move_speed_mul

	-- Enemies can now have additional move speed multipliers independent of their preset
	if self._ext_anim.run then
		final_modifier = final_modifier * (move_speed_mul and move_speed_mul.run or 1)
	else
		final_modifier = final_modifier * (move_speed_mul and move_speed_mul.walk or 1)
	end

	local spooc_action = self._active_actions[1]

	-- Cloakers move faster while charging
	if spooc_action and spooc_action:type() == "spooc" then
		final_modifier = final_modifier * (self._tweak_data.spooc_charge_move_speed_mul or 1.5)
	end

	if self._carry_speed_modifier then
		final_modifier = final_modifier * self._carry_speed_modifier
	end

	if self._hostage_speed_modifier then
		final_modifier = final_modifier * self._hostage_speed_modifier
	end

	return final_modifier ~= 1 and final_modifier
end

-- Toggle flashlights when set to cool or uncool
Hooks:PreHook(CopMovement, "_post_init", "sh__post_init", function(self)
	local equipped_weapon = self._ext_inventory:equipped_unit()
	if alive(equipped_weapon) then
		equipped_weapon:base():set_flashlight_enabled(false)
	end
end)

function CopMovement:_chk_flashlight_state()
	local equipped_weapon = self._ext_inventory:equipped_unit()
	if not alive(equipped_weapon) then
		return
	end

	local flashlight_on = not self:cool() and not self._ext_inventory:shield_unit() and managers.game_play_central:flashlights_on()
	if flashlight_on then
		local lights = self._unit:get_objects_by_type(Idstring("light"))
		if #lights > 0 and lights[1]:enable() then
			flashlight_on = false
		end
	end

	equipped_weapon:base():set_flashlight_enabled(flashlight_on)
end

Hooks:PostHook(CopMovement, "set_cool", "sh_set_cool", CopMovement._chk_flashlight_state)

function CopMovement:sync_equip_weapon()
	self:_chk_flashlight_state()
end

-- Fix enemies playing the suppressed stand-to-crouch animation when shot even if they are already crouching
local play_redirect_original = CopMovement.play_redirect
function CopMovement:play_redirect(redirect_name, ...)
	local result = play_redirect_original(self, redirect_name, ...)
	if result and redirect_name == "suppressed_reaction" and self._ext_anim.crouch then
		self._machine:set_parameter(result, "from_stand", 0)
	end
	return result
end

-- Fix head position update on suppression
-- selene: allow(if_same_then_else)
Hooks:PreHook(CopMovement, "_upd_stance", "sh__upd_stance", function(self, t)
	if self._stance.transition and self._stance.transition.next_upd_t < t then
		self._force_head_upd = true
	elseif self._suppression.transition and self._suppression.transition.next_upd_t < t then
		self._force_head_upd = true
	end
end)

Hooks:PostHook(CopMovement, "_change_stance", "sh__change_stance", function(self)
	self._force_head_upd = true
end)

function CopMovement:on_suppressed(state)
	local suppression = self._suppression
	local end_value = state and 1 or 0
	local vis_state = self._ext_base:lod_stage()

	if vis_state == 1 and end_value ~= suppression.value then
		local t = TimerManager:game():time()
		local duration = 0.5 * math.abs(end_value - suppression.value)
		suppression.transition = {
			end_val = end_value,
			start_val = suppression.value,
			duration = duration,
			start_t = t,
			next_upd_t = t + 0.07
		}
	else
		suppression.transition = nil
		suppression.value = end_value

		self._machine:set_global("sup", end_value)
	end

	self._action_common_data.is_suppressed = state and true or nil

	if Network:is_server() then
		if state and not self:chk_action_forbidden("walk") then
			if state == "panic" and not self:chk_action_forbidden("act") then
				if not self._ext_anim.crouch and self._ext_anim.run and self._ext_anim.move_fwd then
					local action_desc = {
						clamp_to_graph = true,
						type = "act",
						body_part = 1,
						variant = "suppressed_fumble_fwd_run",
						blocks = {
							action = -1,
							walk = -1
						}
					}

					self:action_request(action_desc)
				else
					local vec_from = temp_vec1
					local vec_to = temp_vec2
					local ray_params = {
						allow_entry = false,
						trace = true,
						tracker_from = self:nav_tracker(),
						pos_from = vec_from,
						pos_to = vec_to
					}
					local allowed_fumbles = {
						"suppressed_fumble_still"
					}
					local allow = nil

					mvec3_set(vec_from, self:m_pos())
					mvec3_set(vec_to, self:m_rot():y())
					mvec3_mul(vec_to, -100)
					mvec3_add(vec_to, self:m_pos())

					allow = not managers.navigation:raycast(ray_params)

					if allow then
						table.insert(allowed_fumbles, "suppressed_fumble_bwd")
					end

					mvec3_set(vec_from, self:m_pos())
					mvec3_set(vec_to, self:m_rot():x())
					mvec3_mul(vec_to, 200)
					mvec3_add(vec_to, self:m_pos())

					allow = not managers.navigation:raycast(ray_params)

					if allow then
						table.insert(allowed_fumbles, "suppressed_fumble_r")
					end

					mvec3_set(vec_from, self:m_pos())
					mvec3_set(vec_to, self:m_rot():x())
					mvec3_mul(vec_to, -200)
					mvec3_add(vec_to, self:m_pos())

					allow = not managers.navigation:raycast(ray_params)

					if allow then
						table.insert(allowed_fumbles, "suppressed_fumble_l")
					end

					local action_desc = {
						clamp_to_graph = true,
						type = "act",
						body_part = 1,
						variant = allowed_fumbles[#allowed_fumbles > 1 and math.random(#allowed_fumbles) or 1],
						blocks = {
							action = -1,
							walk = -1
						}
					}

					self:action_request(action_desc)
				end
			elseif not self._ext_anim.crouching and (not self._tweak_data.allowed_poses or self._tweak_data.allowed_poses.crouch) and not self:chk_action_forbidden("crouch") then
				local vec_from = temp_vec1
				local vec_to = temp_vec2
				local ray_params = {
					allow_entry = false,
					trace = true,
					tracker_from = self:nav_tracker(),
					pos_from = vec_from,
					pos_to = vec_to
				}
					
				mvec3_set(vec_from, self:m_pos())
				mvec3_set(vec_to, self:m_rot():x())
				mvec3_mul(vec_to, 380)
				mvec3_add(vec_to, self:m_pos())

				local allow_slide = not managers.navigation:raycast(ray_params) and math.random() < (self._tweak_data and self._tweak_data.dodge and self._tweak_data.dodge.slide_chance or 0)

				if not self._ext_anim.crouch and self._ext_anim.run and self._ext_anim.move_fwd and allow_slide then
					local action_desc = {
						clamp_to_graph = true,
						type = "act",
						body_part = 1,
						variant = "e_nl_slide_fwd_4m",
						blocks = {
							action = -1,
							walk = -1
						}
					}

					self:action_request(action_desc)					
				elseif self._ext_anim.idle and (not self._active_actions[2] or self._active_actions[2]:type() == "idle") then
					local action_desc = {
						variant = "suppressed_reaction",
						body_part = 2,
						type = "act",
						blocks = {
							walk = -1
						}
					}

					self:action_request(action_desc)
				elseif not self._ext_anim.crouch and (not self._ext_anim.move or self._tweak_data.crouch_move) then
					local action_desc = {
						body_part = 4,
						type = "crouch"
					}

					self:action_request(action_desc)
				end
			end
		end

		managers.network:session():send_to_peers_synched("suppressed_state", self._unit, state and true or false)
	end

	self:enable_update()
end

Hooks:PostHook(CopMovement, "on_suppressed", "sh_on_suppressed", function(self)
	self._force_head_upd = true
end)

-- Skip damage actions on units that are already in a death action
-- Redirect stun animations for Bulldozers and Shields
local damage_clbk_original = CopMovement.damage_clbk
function CopMovement:damage_clbk(my_unit, damage_info)
	if self._active_actions[1] and self._active_actions[1]._hurt_type == "death" then
		return
	end

	if damage_info.variant == "stun" then
		if self._unit:base():has_tag("tank") then
			damage_info.variant = "hurt"
			damage_info.result = {
				variant = "hurt",
				type = "expl_hurt",
			}
		elseif self._unit:base():has_tag("shield") then
			damage_info.variant = "hurt"
			damage_info.result = {
				variant = "hurt",
				type = "concussion",
			}
		end
	elseif damage_info.result.type == "light_hurt" and self._ext_inventory._shield_unit and self._ext_anim.hurt then
		return
	end

	return damage_clbk_original(self, my_unit, damage_info)
end
