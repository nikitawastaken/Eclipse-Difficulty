-- Handle grenade case as a percentage based deployable
-- currently crashes because the entire asset part needs to be redone for this, alongside a new unit file with no dependency on another unit file and yada yada
-- honestly just make a separate folder at this point and model the contents after the ammobag deployable

local dec_mul = 10000

function GrenadeCrateBase.spawn(pos, rot, grenade_upgrade_lvl, peer_id)
	local unit_name = "units/payday2/equipment/gen_equipment_grenade_case/gen_equipment_grenade_case"
	local unit = World:spawn_unit(Idstring(unit_name), pos, rot)

	managers.network:session():send_to_peers_synched("sync_equipment_setup", unit, grenade_upgrade_lvl or 0, peer_id or 0)
	unit:base():setup(grenade_upgrade_lvl)

	return unit
end

function GrenadeCrateBase:set_server_information(peer_id)
	self._server_information = {
		owner_peer_id = peer_id,
	}

	managers.network:session():peer(peer_id):set_used_deployable(true)
end

function GrenadeCrateBase:init(unit)
	UnitBase.init(self, unit, false)

	self._unit = unit
	self._is_attachable = true
	self._max_grenade_amount = tweak_data.upgrades.grenade_crate_base + managers.player:upgrade_value_by_level("grenade_case", "amount_increase", 1)

	self._unit:sound_source():post_event("ammo_bag_drop")

	if Network:is_client() then
		self._validate_clbk_id = "grenade_case_validate" .. tostring(unit:key())

		managers.enemy:add_delayed_clbk(self._validate_clbk_id, callback(self, self, "_clbk_validate"), Application:time() + 60)
	end
end

function GrenadeCrateBase:get_name_id()
	return "grenade_case"
end

function GrenadeCrateBase:_clbk_validate()
	self._validate_clbk_id = nil

	if not self._was_dropin then
		local peer = managers.network:session():server_peer()

		peer:mark_cheater(VoteManager.REASON.many_assets)
	end
end

function GrenadeCrateBase:setup(grenade_upgrade_lvl)
	self._grenade_amount = tweak_data.upgrades.grenade_crate_base + managers.player:upgrade_value_by_level("grenade_case", "amount_increase", grenade_upgrade_lvl)
	self._empty = false

	self:_set_visual_stage()

	if Network:is_server() and self._is_attachable then
		local from_pos = self._unit:position() + self._unit:rotation():z() * 10
		local to_pos = self._unit:position() + self._unit:rotation():z() * -10
		local ray = self._unit:raycast("ray", from_pos, to_pos, "slot_mask", managers.slot:get_mask("world_geometry"))

		if ray then
			self._attached_data = {
				body = ray.body,
				position = ray.body:position(),
				rotation = ray.body:rotation(),
				index = 1,
				max_index = 3,
			}

			self._unit:set_extension_update_enabled(Idstring("base"), true)
		end
	end
end

function GrenadeCrateBase:sync_setup(grenade_upgrade_lvl, peer_id)
	if self._validate_clbk_id then
		managers.enemy:remove_delayed_clbk(self._validate_clbk_id)

		self._validate_clbk_id = nil
	end

	managers.player:verify_equipment(peer_id, "grenade_case")
	self:setup(grenade_upgrade_lvl)
end

function GrenadeCrateBase:round_value(val)
	return math.floor(val * dec_mul) / dec_mul
end

function GrenadeCrateBase:_set_visual_stage()
	local percentage = self._grenade_amount / self._max_grenade_amount

	if alive(self._unit) and self._unit:damage() then
		local state = "state_" .. math.ceil(percentage * 6)

		if self._unit:damage():has_sequence(state) then
			self._unit:damage():run_sequence_simple(state)
		end
	end
end

function GrenadeCrateBase:sync_grenade_taken(amount)
	amount = self:round_value(amount)
	self._grenade_amount = self:round_value(self._grenade_amount - amount)
	--Eclipse:log_chat("taken: " .. amount .. "\ncapacity left: " .. self._grenade_amount)

	if self._grenade_amount <= 0 then
		self:_set_empty()
	else
		self:_set_visual_stage()
	end
end

function GrenadeCrateBase:take_grenade(unit)
	if self._empty or managers.player:got_max_grenades() then
		return
	end

	local taken = self:_take_grenades()
	--Eclipse:log_chat("taken: " .. taken .. "\ncapacity left: " .. self._grenade_amount)

	if taken > 0 then
		unit:sound():play("pickup_ammo")
		managers.network:session():send_to_peers_synched("sync_grenade_crate_grenade_taken", self._unit, taken)
		managers.player:register_grenade(managers.network:session():local_peer():id())
	end

	if self._grenade_amount <= 0 then
		self:_set_empty()
	else
		self:_set_visual_stage()
	end
end

function GrenadeCrateBase:_take_grenades()
	local taken = 0

	local took = self:round_value(managers.player:add_grenade_from_bag(self._grenade_amount, true))
	taken = taken + took
	self._grenade_amount = self:round_value(self._grenade_amount - took)

	if self._grenade_amount <= 0 then
		return taken
	end

	return taken
end

function GrenadeCrateBase:_set_empty()
	self._empty = true
	self._ammo_amount = 0
	local unit = self._unit

	if Network:is_server() or unit:id() == -1 then
		unit:set_slot(0)
	else
		unit:set_visible(false)

		local int_ext = unit:interaction()

		if int_ext then
			int_ext:set_active(false)
		end

		unit:set_enabled(false)
	end
end

-- Ordnance bag behaves as a reskin to the grenade case
function GrenadeCrateDeployableBase.spawn(pos, rot, grenade_upgrade_lvl, peer_id)
	local unit_name = "units/pd2_dlc_mxm/equipment/gen_equipment_grenade_crate/gen_equipment_grenade_crate"
	local unit = World:spawn_unit(Idstring(unit_name), pos, rot)

	managers.network:session():send_to_peers_synched("sync_equipment_setup", unit, grenade_upgrade_lvl, peer_id or 0)
	unit:base():setup(grenade_upgrade_lvl)

	return unit
end

function GrenadeCrateDeployableBase:init(unit)
	UnitBase.init(self, unit, false)

	self._unit = unit
	self._is_attachable = true
	self._max_grenade_amount = tweak_data.upgrades.grenade_crate_base + managers.player:upgrade_value_by_level("grenade_crate", "amount_increase", 1)

	self._unit:sound_source():post_event("ammo_bag_drop")

	if Network:is_client() then
		self._validate_clbk_id = "grenade_case_validate" .. tostring(unit:key())

		managers.enemy:add_delayed_clbk(self._validate_clbk_id, callback(self, self, "_clbk_validate"), Application:time() + 60)
	end
end

function GrenadeCrateDeployableBase:get_name_id()
	return "grenade_case"
end

function GrenadeCrateDeployableBase:_clbk_validate()
	self._validate_clbk_id = nil

	if not self._was_dropin then
		local peer = managers.network:session():server_peer()

		peer:mark_cheater(VoteManager.REASON.many_assets)
	end
end

function GrenadeCrateDeployableBase:setup(grenade_upgrade_lvl)
	self._grenade_amount = tweak_data.upgrades.grenade_crate_base + managers.player:upgrade_value_by_level("grenade_crate", "amount_increase", grenade_upgrade_lvl)
	self._empty = false

	self:_set_visual_stage()

	if Network:is_server() and self._is_attachable then
		local from_pos = self._unit:position() + self._unit:rotation():z() * 10
		local to_pos = self._unit:position() + self._unit:rotation():z() * -10
		local ray = self._unit:raycast("ray", from_pos, to_pos, "slot_mask", managers.slot:get_mask("world_geometry"))

		if ray then
			self._attached_data = {
				body = ray.body,
				position = ray.body:position(),
				rotation = ray.body:rotation(),
				index = 1,
				max_index = 3,
			}

			self._unit:set_extension_update_enabled(Idstring("base"), true)
		end
	end
end

function GrenadeCrateDeployableBase:sync_setup(grenade_upgrade_lvl, peer_id)
	if self._validate_clbk_id then
		managers.enemy:remove_delayed_clbk(self._validate_clbk_id)

		self._validate_clbk_id = nil
	end

	managers.player:verify_equipment(peer_id, "grenade_crate")
	self:setup(grenade_upgrade_lvl)
end

function GrenadeCrateDeployableBase:round_value(val)
	return math.floor(val * dec_mul) / dec_mul
end

function GrenadeCrateDeployableBase:_set_visual_stage()
	local percentage = self._grenade_amount / self._max_grenade_amount

	if alive(self._unit) and self._unit:damage() then
		local state = "state_" .. math.ceil(percentage * 6)

		if self._unit:damage():has_sequence(state) then
			self._unit:damage():run_sequence_simple(state)
		end
	end
end

function GrenadeCrateDeployableBase:sync_grenade_taken(amount)
	amount = self:round_value(amount)
	self._grenade_amount = self:round_value(self._grenade_amount - amount)

	if self._grenade_amount <= 0 then
		self:_set_empty()
	else
		self:_set_visual_stage()
	end
end

function GrenadeCrateDeployableBase:take_grenade(unit)
	if self._empty or managers.player:got_max_grenades() then
		return
	end

	local taken = self:_take_grenades()
	--Eclipse:log_chat("taken: " .. taken .. "\ngrenade amount: " .. self._grenade_amount)

	if taken > 0 then
		unit:sound():play("pickup_ammo")
		managers.network:session():send_to_peers_synched("sync_grenade_crate_grenade_taken", self._unit, taken)
		managers.player:register_grenade(managers.network:session():local_peer():id())
	end

	if self._grenade_amount <= 0 then
		self:_set_empty()
	else
		self:_set_visual_stage()
	end
end

function GrenadeCrateDeployableBase:_take_grenades()
	local taken = 0

	local took = self:round_value(managers.player:add_grenade_from_bag(self._grenade_amount, true))
	taken = taken + took
	self._grenade_amount = self:round_value(self._grenade_amount - took)

	if self._grenade_amount <= 0 then
		return taken
	end

	return taken
end

function GrenadeCrateDeployableBase:_set_empty()
	self._empty = true
	self._ammo_amount = 0
	local unit = self._unit

	if Network:is_server() or unit:id() == -1 then
		unit:set_slot(0)
	else
		unit:set_visible(false)

		local int_ext = unit:interaction()

		if int_ext then
			int_ext:set_active(false)
		end

		unit:set_enabled(false)
	end
end
