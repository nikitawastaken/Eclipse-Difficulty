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

local old_cd_link_to = CarryData.link_to
function CarryData:link_to(parent_unit)
	if not self._link_body then
		return
	end
	local old_links = CarryData.carry_links[parent_unit:key()]

	old_cd_link_to(self, parent_unit)
	CarryData.carry_links[parent_unit:key()] = old_links and old_links + 1 or 1
end

---fuckass function refuses to be shadowed with sane behavior
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

local old_cd_destroy = CarryData.destroy
function CarryData:destroy()
	local old_links
	if alive(self._linked_to) then
		old_links = CarryData.carry_links[self._linked_to:key()]
	end

	old_cd_destroy(self)
	if old_links and alive(self._linked_to) then
		CarryData.carry_links[self._linked_to:key()] = old_links - 1
	end
end
