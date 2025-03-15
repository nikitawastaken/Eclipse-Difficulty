Hooks:PostHook(TradeMananger, "init", "eclipse_init", function(self)
    self._downs_to_restore = 0
end)

function TradeManager:get_downs_to_restore()
    local downs_to_restore = 0

    for _, criminal in pairs(managers.groupai:state():all_player_criminals()) do
        local max_criminal_revives = criminal.unit:character_damage():get_revives_max()
        local current_criminal_revives = criminal.unit:character_damage():get_revives()

        downs_to_restore = max_criminal_revives - math.min(max_criminal_revives, current_criminal_revives)
    end

    return downs_to_restore
end

function TradeManager:is_trading()
	return (self._trading_hostage or self._hostage_trade_clbk or self._speaker_snd_event) and self._downs_to_restore > 0
end

function TradeManager:is_trade_allowed()
	return Network:is_server() and not self._trading_hostage and not self._hostage_trade_clbk and self._downs_to_restore > 0 and not managers.groupai:state():whisper_mode() and not self._speaker_snd_event and managers.groupai:state():hostage_count() > 0
end

function TradeManager:update(t, dt)
	self._t = t

	if not managers.criminals or not managers.hud then
		return
	end

	if managers.skirmish and managers.skirmish:is_skirmish() then
		return
	end

    self._downs_to_restore = self:get_downs_to_restore()
	local is_trade_allowed = self:is_trade_allowed()

	if not self._hostage_remind_t or self._hostage_remind_t < t then
		if not self._trading_hostage and not self._hostage_trade_clbk and self._downs_to_restore > 0 and managers.groupai:state():hostage_count() <= 0 and managers.groupai:state():bain_state() then
			local cable_tie_data = managers.player:has_special_equipment("cable_tie")

			if cable_tie_data and Application:digest_value(cable_tie_data.amount, false) > 0 then
				managers.dialog:queue_narrator_dialog("h01x", {})
			end
		end

		self._hostage_remind_t = t + math.random(60, 120)
	end

	self._pause_t = math.max(0, self._pause_t - dt)

	if (self._trade_countdown) and is_trade_allowed and self._pause_t <= 0 and not managers.player:_is_all_in_custody() then
		print("so ")

        self:_increment_trade_index()

        print("so far so good")

        local respawn_t = self._t + math.random(2, 5)
        self._hostage_trade_clbk = "TradeManager"

        managers.enemy:add_delayed_clbk(self._hostage_trade_clbk, callback(self, self, "clbk_begin_hostage_trade_dialog", 1), respawn_t)
	end
end

function TradeManager:clbk_begin_hostage_trade_dialog(i)
	self._hostage_trade_clbk = nil

	if i == 1 then
		self._megaphone_sound_source = self:_get_megaphone_sound_source()
		self._speaker_snd_event = self._megaphone_sound_source:post_event("mga_t01a_con_plu", callback(self, self, "clbk_vo_end_begin_hostage_trade_dialog", {
			i = 2,
			hostage_trade_index = self._hostage_trade_index
		}), nil, "end_of_event")

		if not self._speaker_snd_event then
			self:clbk_begin_hostage_trade_dialog(2)
			print("Megaphone fail")
		end
	else

		local respawn_t = self._t + self.TRADE_DELAY
		self._hostage_trade_clbk = "TradeManager"

		managers.enemy:add_delayed_clbk(self._hostage_trade_clbk, callback(self, self, "clbk_begin_hostage_trade"), respawn_t)
	end
end

function TradeManager:clbk_begin_hostage_trade()
	self._hostage_trade_clbk = nil

    local possible_criminals, is_instant_trade = self:get_possible_criminals()
    local rescuing_criminal = possible_criminals[math.random(1, #possible_criminals)]
    rescuing_criminal = managers.groupai:state():all_criminals()[rescuing_criminal]
    local rescuing_criminal_pos = nil

    if rescuing_criminal then
        rescuing_criminal_pos = rescuing_criminal.unit:position()
    else
        managers.groupai:state():check_gameover_conditions()
        managers.enemy:add_delayed_clbk(self._hostage_trade_clbk, callback(self, self, "clbk_begin_hostage_trade"), self._t + 5)

        return
    end

    local rot = rescuing_criminal.unit:rotation()
    local best_hostage = self:get_best_hostage(rescuing_criminal_pos)

    self:begin_hostage_trade(rescuing_criminal_pos, rot, best_hostage, is_instant_trade)
end

function TradeManager:begin_hostage_trade(position, rotation, hostage, is_instant_trade, skip_free_criminal, skip_hint, skip_init)
	if hostage then
		local clbk_key = "TradeManager"
		self._trading_hostage = true
		self._hostage_to_trade = hostage

		hostage.unit:brain():set_logic("trade", {
			skip_hint = skip_hint or false
		})

		if not hostage.initialized then
			self._hostage_to_trade.death_clbk_key = clbk_key
			self._hostage_to_trade.destroyed_clbk_key = clbk_key

			hostage.unit:character_damage():add_listener(clbk_key, {
				"death"
			}, callback(self, self, "clbk_hostage_died"))
			hostage.unit:base():add_destroy_listener(clbk_key, callback(self, self, "clbk_hostage_destroyed"))

			hostage.initialized = true
		end
	else
		self:cancel_trade()
	end
end

function TradeManager:on_hostage_traded(pos, rotation)
	print("RC: Traded hostage!!")

	if self._trade_in_progress then
		return
	end

	self._hostage_to_trade = nil
	self._trade_in_progress = true

    self:trade_restore_lives()
end

function TradeManager:trade_restore_lives()
    for u_key, u_data in pairs(managers.groupai:state():all_player_criminals()) do
        u_data.unit:character_damage():restore_lives(1)
        Eclipse:log("Hostage traded, restoring a down")
    end
end