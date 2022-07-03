local mvec3_dot = mvector3.dot
local mvec3_dir = mvector3.direction
local mvec3_norm = mvector3.normalize
local temp_vec1 = Vector3()
local temp_vec2 = Vector3()


-- Make tasers more consistent by allowing to tase through enemies and ignoring attention when already discharging
function CopActionTase:on_attention(attention)
	if not attention then
		if self._attention then
			if self._tasing_local_unit then
				if self._discharging then
					self._tasing_local_unit:movement():on_tase_ended()
				end
				if self._tasing_player then
					self._tasing_local_unit:movement():on_targetted_for_attack(false, self._unit)
				end
			end

			self._expired = self._expired or Network:is_server()
			self._attention = nil
			self._tasing_local_unit = nil
			self._tasing_player = nil
			self._discharging = nil
			self.update = self._upd_empty
		end
		return
	elseif self._attention then
		return
	end

	local weap_tweak = self._ext_inventory:equipped_unit():base():weapon_tweak_data()
	local weapon_usage_tweak = self._common_data.char_tweak.weapon[weap_tweak.usage]

	self._weap_tweak = weap_tweak
	self._w_usage_tweak = weapon_usage_tweak
	self._falloff = weapon_usage_tweak.FALLOFF
	self._attention = attention
	self._line_of_fire_slotmask = managers.slot:get_mask("bullet_blank_impact_targets")

	local target_pos = attention.handler and attention.handler:get_attention_m_pos() or attention.unit:movement():m_head_pos()
	local target_vec = target_pos - self._ext_movement:m_head_pos()
	local lerp_dis = math.min(1, target_vec:length() / self._w_usage_tweak.tase_distance)
	local aim_delay = weapon_usage_tweak.aim_delay_tase or weapon_usage_tweak.aim_delay
	local shoot_delay = math.lerp(aim_delay[1], aim_delay[2], lerp_dis)

	self._modifier:set_target_y(target_vec)
	self._mod_enable_t = TimerManager:game():time() + shoot_delay
	self._tasing_local_unit = nil
	self._tasing_player = nil

	if Network:is_server() then
		self._common_data.ext_network:send("action_tase_event", 1)
		if not attention.unit:base().is_husk_player then
			self._shoot_t = TimerManager:game():time() + shoot_delay
			self._tasing_local_unit = attention.unit
			self._tasing_player = attention.unit:base().is_local_player
		end
	elseif attention.unit:base().is_local_player then
		self._shoot_t = TimerManager:game():time() + shoot_delay
		self._tasing_local_unit = attention.unit
		self._tasing_player = true
	end

	if self._tasing_local_unit and self._tasing_player then
		self._tasing_local_unit:movement():on_targetted_for_attack(true, self._unit)
	end
end


-- Helper function
function CopActionTase:_obstructed(from, to)
	return self._unit:raycast("ray", from, to, "slot_mask", self._line_of_fire_slotmask, "sphere_cast_radius", self._w_usage_tweak.tase_sphere_cast_radius, "ignore_unit", self._tasing_local_unit, "report")
end


-- Fix some general issues with turning
function CopActionTase:update(t)
	if self._expired then
		return
	end

	local shoot_from_pos = self._ext_movement:m_head_pos()
	local target_vec = temp_vec1
	local target_pos = temp_vec2

	self._attention.unit:character_damage():shoot_pos_mid(target_pos)

	mvec3_dir(target_vec, shoot_from_pos, target_pos)
	local target_vec_flat = target_vec:with_z(0)
	mvec3_norm(target_vec_flat)

	local fwd = self._common_data.fwd
	local fwd_dot = mvec3_dot(fwd, target_vec_flat)
	if fwd_dot > 0.7 then
		if not self._modifier_on then
			self._modifier_on = true
			self._machine:force_modifier(self._modifier_name)
			self._mod_enable_t = t + 0.5
		end

		self._modifier:set_target_y(target_vec)
	else
		if self._modifier_on then
			self._modifier_on = nil
			self._machine:allow_modifier(self._modifier_name)
		end

		-- Similar to CopActionShoot, this originally only executed client side, with the addition of not checking for existing turn actions
		local active_actions = self._common_data.active_actions
		local queued_actions = self._common_data.queued_actions
		if (not active_actions[2] or active_actions[2]:type() == "idle") and (not queued_actions or not queued_actions[1] and not queued_actions[2]) then
			local spin = target_vec_flat:to_polar_with_reference(fwd, math.UP).spin
			if math.abs(spin) > 25 then
				self._ext_movement:action_request({
					type = "turn",
					body_part = 2,
					angle = spin
				})
			end
		end

		target_vec = nil
	end

	if not self._ext_anim.reload and not self._ext_anim.equip then
		if self._discharging then
			if not self._tasing_local_unit:movement():tased() or self:_obstructed(shoot_from_pos, target_pos) then
				if Network:is_server() then
					self._expired = true
				else
					self._tasing_local_unit:movement():on_tase_ended()
					self._attention.unit:movement():on_targetted_for_attack(false, self._unit)

					self._discharging = nil
					self._tasing_player = nil
					self._tasing_local_unit = nil
					self.update = self._upd_empty
				end
			end
		elseif self._shoot_t and target_vec and self._common_data.allow_fire and self._shoot_t < t and self._mod_enable_t < t then
			if self._tase_effect then
				World:effect_manager():fade_kill(self._tase_effect)
			end

			self._tase_effect = World:effect_manager():spawn({
				force_synch = true,
				effect = Idstring("effects/payday2/particles/character/taser_thread"),
				parent = self._ext_inventory:equipped_unit():get_object(Idstring("fire"))
			})

			if self._tasing_local_unit and mvector3.distance(shoot_from_pos, target_pos) < self._w_usage_tweak.tase_distance then
				local record = managers.groupai:state():criminal_record(self._tasing_local_unit:key())
				if not record or record.status or self._tasing_local_unit:movement():chk_action_forbidden("hurt") or self._tasing_local_unit:movement():zipline_unit() then
					self._expired = Network:is_server()
				elseif not self:_obstructed(shoot_from_pos, target_pos) then
					self._common_data.ext_network:send("action_tase_event", 3)

					self._attention.unit:character_damage():damage_tase({ attacker_unit = self._unit })
					CopDamage._notify_listeners("on_criminal_tased", self._unit, self._attention.unit)

					if not self._tasing_local_unit:base().is_local_player then
						self._tasered_sound = self._unit:sound():play("tasered_3rd", nil)
					end
					self._ext_movement:play_redirect("recoil_auto")
					self._shoot_t = nil
					self._discharging = true
				end
			elseif not self._tasing_local_unit then
				self._tasered_sound = self._unit:sound():play("tasered_3rd", nil)
				self._ext_movement:play_redirect("recoil_auto")
				self._shoot_t = nil
			end
		end
	end
end
