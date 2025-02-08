CopMovement._action_variants.fbi_shield = CopMovement._action_variants.shield
CopMovement._action_variants.tank_elite = CopMovement._action_variants.tank
CopMovement._action_variants.phalanx_minion_break = CopMovement._action_variants.city_swat
CopMovement._action_variants.murky = CopMovement._action_variants.swat
CopMovement._action_variants.zeal_swat = CopMovement._action_variants.city_swat
CopMovement._action_variants.zeal_heavy_swat = CopMovement._action_variants.city_swat
CopMovement._action_variants.zeal_medic = CopMovement._action_variants.city_swat
CopMovement._action_variants.zeal_shield = CopMovement._action_variants.shield
CopMovement._action_variants.zeal_taser = CopMovement._action_variants.taser

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

-- Fix enemies playing the suppressed stand-to-crouch animation when shot even if they are already crouching
local play_redirect_original = CopMovement.play_redirect
function CopMovement:play_redirect(redirect_name, ...)
	local result = play_redirect_original(self, redirect_name, ...)
	if result and redirect_name == "suppressed_reaction" and self._ext_anim.crouch then
		self._machine:set_parameter(result, "from_stand", 0)
	end
	return result
end

-- counterstrike stuff
Hooks:OverrideFunction(CopMovement, "damage_clbk", function(self, my_unit, damage_info)
	local hurt_type = damage_info.result.type
	-- If it's a dozer and the hurt type is expl_hurt, use the medium hurt preset instead
	local is_tank = self._unit:base()._tweak_table == "tank" or self._unit:base()._tweak_table == "tank_elite"
	if is_tank and hurt_type == "expl_hurt" then
		hurt_type = "hurt"
	end

	-- Original code
	if hurt_type == "stagger" then
		hurt_type = "heavy_hurt"
	end

	hurt_type = managers.modifiers:modify_value("CopMovement:HurtType", hurt_type)
	local block_type = hurt_type

	if hurt_type == "knock_down" or hurt_type == "expl_hurt" or hurt_type == "fire_hurt" or hurt_type == "poison_hurt" or hurt_type == "taser_tased" then
		block_type = "heavy_hurt"
	end

	if hurt_type == "death" and self._queued_actions then
		self._queued_actions = {}
	end

	if not hurt_type or Network:is_server() and self:chk_action_forbidden(block_type) then
		if hurt_type == "death" then
			debug_pause_unit(self._unit, "[CopMovement:damage_clbk] Death action skipped!!!", self._unit)
			Application:draw_cylinder(self._m_pos, self._m_pos + math.UP * 5000, 30, 1, 0, 0)

			for body_part, action in ipairs(self._active_actions) do
				if action then
					print(body_part, action:type(), inspect(action._blocks))
				end
			end
		end

		return
	end

	if damage_info.variant == "stun" and alive(self._ext_inventory and self._ext_inventory._shield_unit) then
		hurt_type = "shield_knock"
		block_type = "shield_knock"
		damage_info.variant = "melee"
		damage_info.result = {
			variant = "melee",
			type = "shield_knock",
		}
		damage_info.shield_knock = true
	end

	if hurt_type == "death" then
		if self._rope then
			self._rope:base():retract()

			self._rope = nil
			self._rope_death = true

			if self._unit:sound().anim_clbk_play_sound then
				self._unit:sound():anim_clbk_play_sound(self._unit, "repel_end")
			end
		end

		if Network:is_server() then
			self:set_attention()
		else
			self:synch_attention()
		end
	end

	local attack_dir = damage_info.col_ray and damage_info.col_ray.ray or damage_info.attack_dir
	local hit_pos = damage_info.col_ray and damage_info.col_ray.position or damage_info.pos
	local lgt_hurt = hurt_type == "light_hurt"
	local body_part = lgt_hurt and 4 or 1
	local blocks = nil

	if not lgt_hurt then
		blocks = {
			act = -1,
			aim = -1,
			action = -1,
			tase = -1,
			walk = -1,
		}

		if hurt_type == "bleedout" then
			blocks.bleedout = -1
			blocks.hurt = -1
			blocks.heavy_hurt = -1
			blocks.hurt_sick = -1
			blocks.concussion = -1
		end
	end

	if damage_info.variant == "tase" then
		block_type = "bleedout"
	elseif hurt_type == "expl_hurt" or hurt_type == "fire_hurt" or hurt_type == "poison_hurt" or hurt_type == "taser_tased" then
		block_type = "heavy_hurt"
	else
		block_type = hurt_type
	end

	local client_interrupt = nil

	if
		Network:is_client()
		and (
			hurt_type == "light_hurt"
			or hurt_type == "hurt" and damage_info.variant ~= "tase"
			or hurt_type == "heavy_hurt"
			or hurt_type == "expl_hurt"
			or hurt_type == "shield_knock"
			or hurt_type == "counter_tased"
			or hurt_type == "taser_tased"
			or hurt_type == "counter_spooc"
			or hurt_type == "death"
			or hurt_type == "hurt_sick"
			or hurt_type == "fire_hurt"
			or hurt_type == "poison_hurt"
			or hurt_type == "concussion"
		)
	then
		client_interrupt = true
	end

	local tweak = self._tweak_data
	local action_data = nil

	if hurt_type == "healed" then
		if Network:is_client() then
			client_interrupt = true
		end

		action_data = {
			body_part = 3,
			type = "healed",
			client_interrupt = client_interrupt,
		}
	else
		action_data = {
			type = "hurt",
			block_type = block_type,
			hurt_type = hurt_type,
			variant = damage_info.variant,
			direction_vec = attack_dir,
			hit_pos = hit_pos,
			body_part = body_part,
			blocks = blocks,
			client_interrupt = client_interrupt,
			weapon_unit = damage_info.weapon_unit,
			attacker_unit = damage_info.attacker_unit,
			death_type = tweak.damage.death_severity and (tweak.damage.death_severity < damage_info.damage / tweak.HEALTH_INIT and "heavy" or "normal") or "normal",
			ignite_character = damage_info.ignite_character,
			start_dot_damage_roll = damage_info.start_dot_damage_roll,
			is_fire_dot_damage = damage_info.is_fire_dot_damage,
			fire_dot_data = damage_info.fire_dot_data,
		}
	end

	local request_action = Network:is_server() or not self:chk_action_forbidden(action_data)

	if damage_info.is_synced and (hurt_type == "knock_down" or hurt_type == "heavy_hurt") then
		request_action = false
	end

	if request_action then
		self:action_request(action_data)

		if hurt_type == "death" and self._queued_actions then
			self._queued_actions = {}
		end
	end
end)

-- Fix head position update on suppression
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
	end

	return damage_clbk_original(self, my_unit, damage_info)
end
