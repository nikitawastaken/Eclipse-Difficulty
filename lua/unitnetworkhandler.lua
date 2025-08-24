local is_pro_job = Eclipse.utils.is_pro_job()

-- Friendly Fire
function UnitNetworkHandler:sync_friendly_fire_damage(peer_id, unit, damage, variant, sender)
	if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not self._verify_sender(sender) then
		return
	end

	if managers.network:session():local_peer():id() == peer_id then
		local player_unit = managers.player:player_unit()

		if alive(player_unit) and alive(unit) then
			local attack_info = {
				ignore_suppression = true,
				range = 1000,
				attacker_unit = unit,
				damage = damage,
				armor_piercing = true,
				variant = variant,
				col_ray = {
					position = unit:position(),
				},
				push_vel = Vector3(),
			}

			if variant == "bullet" or variant == "projectile" then
				player_unit:character_damage():damage_bullet(attack_info)
			elseif variant == "melee" then
				player_unit:character_damage():damage_melee(attack_info)
			elseif variant == "fire" then
				player_unit:character_damage():damage_fire(attack_info)
			end
		end
	end

	if not is_pro_job then
		managers.job:set_memory("trophy_flawless", true, false)
	end
end

-- Properly sync reload
function UnitNetworkHandler:reload_weapon_cop(cop, sender)
	if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not self._verify_character_and_sender(cop, sender) then
		return
	end

	if not alive(cop) then
		return
	end

	local current_action = cop:movement():get_action(3)
	if current_action and current_action:type() == "shoot" then
		-- If we are currently in shoot action, set the mag to empty
		cop:inventory():equipped_unit():base():ammo_base():set_ammo_remaining_in_clip(0)
	else
		-- Otherwise request an actual reload action
		cop:movement():action_request({
			body_part = 3,
			type = "reload",
		})
	end
end

-- Additional is_custody_trade argument
function UnitNetworkHandler:unit_traded(unit, position, rotation, is_custody_trade)
	if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not self._verify_character(unit) then
		return
	end

	unit:brain():on_trade(position, rotation, true, is_custody_trade)
end

function UnitNetworkHandler:hostage_trade(unit, enable, trade_success, skip_hint, is_custody_trade)
	if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not self._verify_character(unit) then
		return
	end

	CopLogicTrade.hostage_trade(unit, enable, trade_success, skip_hint, is_custody_trade)
end

-- Extra drill upgrades
function UnitNetworkHandler:sync_drill_upgrades(unit, autorepair_level_1, autorepair_level_2, drill_speed_level, silent, reduced_alert, sender_rpc, electrocuting_drill)
	if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not self._verify_sender(sender_rpc) then
		return
	end

	local base_ext = alive(unit) and unit:base()

	if base_ext and base_ext.set_skill_upgrades then
		base_ext:set_skill_upgrades(Drill.create_upgrades(autorepair_level_1, autorepair_level_2, drill_speed_level, silent, reduced_alert, electrocuting_drill))
	end
end

-- Grenade Case upgrade Setup
function UnitNetworkHandler:sync_grenade_case_setup(unit, upgrade_lvl, peer_id)
	if not alive(unit) or not self._verify_gamestate(self._gamestate_filter.any_ingame) then
		return
	end

	unit:base():sync_setup(upgrade_lvl, peer_id)
end
