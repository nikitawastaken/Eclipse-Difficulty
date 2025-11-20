-- Tweak bag stealing conditions
function CarryData:clbk_pickup_SO_verification(unit)
	if not self._steal_SO_data or not self._steal_SO_data.SO_id then
		return false
	end

	if unit:movement():cool() then
		return false
	end

	if not unit:base():char_tweak().steal_loot then
		return false
	end

	local objective = unit:brain():objective()
	if objective and objective.grp_objective and objective.grp_objective.type == "reenforce_area" then
		return false
	end

	local logic_data = unit:brain()._logic_data
	if not logic_data or not logic_data.tactics or logic_data.tactics.rescue then
		return true
	end
end

-- Make enemies run with stolen bags instead of crouchwalking
Hooks:PostHook(CarryData, "_chk_register_steal_SO", "sh__chk_register_steal_SO", function(self)
	if self._steal_SO_data and self._steal_SO_data.pickup_objective and self._steal_SO_data.pickup_objective.followup_objective then
		self._steal_SO_data.pickup_objective.followup_objective.pose = "stand"
	end
end)

-- Bot carrystacker required overrides...
function CarryData:_update_throw_link(unit, t, dt)
	if self._linked_to or not self._spawn_time or t > self._spawn_time + 1 or not self._link_obj or not self._link_obj:visibility() then
		return false
	end

	local bag_center = self._link_obj:oobb():center()
	local links = CarryData.carry_links
	local oobb_mod = self._oobb_mod

	for u_key, entry in pairs(managers.groupai:state():all_AI_criminals()) do
		---Check if we're carrying 1 bag and have carrystacker
		---Check if we're not carrying any bags
		---Check if bag carry table is nil
		if (links[u_key] == 1 and managers.player:has_category_upgrade("team", "crew_ai_carry_stacker")) or (links[u_key] == 0) or not links[u_key] then
			local mov_ext = entry.unit:movement()

			if not mov_ext.vehicle_unit and not mov_ext:cool() and not mov_ext:downed() then
				local body_oobb = entry.unit:oobb()

				body_oobb:grow(oobb_mod)

				if body_oobb:point_inside(bag_center) then
					body_oobb:shrink(oobb_mod)
					entry.unit:sound():say("r03x_sin", true)
					self:link_to(entry.unit)

					return false
				end

				body_oobb:shrink(oobb_mod)
			end
		end
	end

	return true
end

function CarryData:link_to(parent_unit)
	if not self._link_body then
		Application:error("[CarryData:link_to] No available link body carry unit. ", self._unit)

		return
	end

	if CarryData.carry_links[parent_unit:key()] then
		debug_pause_unit(parent_unit, "[CarryData:link_to] Parent unit was already carrying something?. ", parent_unit)
	end

	-- ugly line but it gets the job done
	CarryData.carry_links[parent_unit:key()] = CarryData.carry_links[parent_unit:key()] and CarryData.carry_links[parent_unit:key()] + 1 or 1

	if self._linked_to then
		local linked_mov_ext = self._linked_to:movement()

		if linked_mov_ext and linked_mov_ext.set_carrying_bag then
			linked_mov_ext:set_carrying_bag(nil)
		end

		self._unit:unlink()
	end

	self._link_body:set_keyframed()

	local int_ext = self._unit:interaction()

	if int_ext then
		int_ext._has_modified_timer = true
		int_ext._air_start_time = TimerManager:game():time()
	end

	local body_active_clbk = self._has_body_activation_clbk
	body_active_clbk = body_active_clbk and body_active_clbk[self._link_body:key()]

	if self._has_body_activation_clbk and self._has_body_activation_clbk[self._link_body:key()] then
		self._unit:remove_body_activation_callback(self._has_body_activation_clbk[self._link_body:key()])
		self._link_body:set_activate_tag(Idstring(""))
		self._link_body:set_deactivate_tag(Idstring(""))

		self._has_body_activation_clbk = nil
	end

	if self._steal_SO_data and (not self._steal_SO_data.picked_up or parent_unit ~= self._steal_SO_data.thief) then
		self:_unregister_steal_SO()
	end

	if self._register_out_of_world_clbk_id then
		managers.enemy:remove_delayed_clbk(self._register_out_of_world_clbk_id)

		self._register_out_of_world_clbk_id = nil
	end

	if self._register_steal_SO_clbk_id then
		managers.enemy:remove_delayed_clbk(self._register_steal_SO_clbk_id)

		self._register_steal_SO_clbk_id = nil
	end

	call_on_next_update(function()
		if not alive(self._unit) or not alive(parent_unit) then
			return
		end

		local parent_obj_name = Idstring("Neck")
		local parent_obj = parent_unit:get_object(parent_obj_name)

		if not parent_obj then
			parent_obj = parent_unit:orientation_object()
			parent_obj_name = parent_obj:name()
		end

		parent_unit:link(parent_obj_name, self._unit)

		local parent_obj_rot = parent_obj:rotation()
		local world_pos = parent_obj:position() - parent_obj_rot:z() * 30 - parent_obj_rot:y() * 10

		self._unit:set_position(world_pos)
		self._unit:set_velocity(Vector3(0, 0, 0))

		local world_rot = Rotation(parent_obj_rot:x(), -parent_obj_rot:z())

		self._unit:set_rotation(world_rot)
	end)
	self:_remove_collisions()

	self._linked_to = parent_unit
	local linked_mov_ext = parent_unit:movement()

	if linked_mov_ext and linked_mov_ext.set_carrying_bag then
		linked_mov_ext:set_carrying_bag(self._unit)
	end

	self:_set_expire_enabled(false)

	if Network:is_server() then
		managers.network:session():send_to_peers_synched("loot_link", self._unit, parent_unit)
	end
end

function CarryData:unlink()
	if not self._link_body or not self._linked_to then
		return
	end

	local linked_to = self._linked_to
	self._linked_to = nil
	CarryData.carry_links[linked_to:key()] = CarryData.carry_links[linked_to:key()] - 1
	local linked_mov_ext = linked_to:movement()

	if linked_mov_ext and linked_mov_ext.set_carrying_bag then
		linked_mov_ext:set_carrying_bag(nil)
	end

	self._unit:unlink()
	self._link_body:set_dynamic()
	self:_restore_collisions()

	local int_ext = self._unit:interaction()

	if int_ext then
		int_ext:register_collision_callbacks()
	end

	self:_set_expire_enabled(true)

	if Network:is_server() then
		managers.network:session():send_to_peers_synched("loot_link", self._unit, self._unit)
	end

	if not self._register_steal_SO_clbk_id then
		self._register_steal_SO_clbk_id = "carrydata_registerSO" .. tostring(self._unit:key())

		managers.enemy:add_delayed_clbk(self._register_steal_SO_clbk_id, callback(self, self, "clbk_register_steal_SO"), 0)
	end
end

function CarryData:destroy()
	if self._dye_pack_smoke then
		World:effect_manager():fade_kill(self._dye_pack_smoke)

		self._dye_pack_smoke = nil
	end

	if self._remove_dye_smoke_clbk_id then
		managers.enemy:remove_delayed_clbk(self._remove_dye_smoke_clbk_id)

		self._remove_dye_smoke_clbk_id = nil
	end

	if self._delayed_explode_clbk_id then
		managers.enemy:remove_delayed_clbk(self._delayed_explode_clbk_id)

		self._delayed_explode_clbk_id = nil
	end

	if self._register_out_of_world_clbk_id then
		managers.enemy:remove_delayed_clbk(self._register_out_of_world_clbk_id)

		self._register_out_of_world_clbk_id = nil
	end

	if self._register_out_of_world_dynamic_clbk_id then
		managers.enemy:remove_delayed_clbk(self._register_out_of_world_dynamic_clbk_id)

		self._register_out_of_world_dynamic_clbk_id = nil
	end

	self:_unregister_steal_SO()

	if self._register_steal_SO_clbk_id then
		managers.enemy:remove_delayed_clbk(self._register_steal_SO_clbk_id)

		self._register_steal_SO_clbk_id = nil
	end

	if alive(self._linked_to) then
		local linked_mov_ext = self._linked_to:movement()

		if linked_mov_ext and linked_mov_ext.set_carrying_bag then
			linked_mov_ext:set_carrying_bag(nil)
		end

		self._unit:unlink()

		CarryData.carry_links[self._linked_to:key()] = CarryData.carry_links[self._linked_to:key()] - 1
	end

	self._linked_to = nil

	CarryData._unregister_remove_on_weapons_hot(self._unit)
end
