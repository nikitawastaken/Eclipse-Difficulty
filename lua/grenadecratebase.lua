-- Handle grenade case as a percentage based deployable
-- todo: fix any potential rounding errors, test syncing, fix cheater tag, fix visuals, apply to ordnance

local dec_mul = 10000

function GrenadeCrateBase:round_value(val)
	return math.floor(val * dec_mul) / dec_mul
end

function GrenadeCrateBase:_set_visual_stage()
	local percentage = self._grenade_amount / self._max_grenade_amount

	if alive(self._unit) and self._unit:damage() then
		local state = "state_" .. tostring(math.ceil(percentage * 6))

		if self._unit:damage():has_sequence(state) then
			self._unit:damage():run_sequence_simple(state)
		end
	end
end

function GrenadeCrateBase:sync_grenade_taken(amount)
	amount = self:round_value(amount)
	self._grenade_amount = self:round_value(self._grenade_amount - amount)

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
	Eclipse:log_chat("taken: " .. taken .. "\ngrenade amount: " .. self._grenade_amount)

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