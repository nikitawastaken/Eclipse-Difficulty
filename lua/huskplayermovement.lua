-- Logic to update how equipment appears on third-person models
function HuskPlayerMovement:check_visual_equipment()
	local peer_id = managers.network:session():peer_by_unit(self._unit):id()
	local deploy_data = managers.player:get_synced_deployable_equipment(peer_id)

	if deploy_data then
		self:set_visual_deployable_equipment(deploy_data.deployable, deploy_data.amount)
	end

	local carry_data = managers.player:get_synced_carry(peer_id)

	if carry_data and #carry_data > 0 then
		self:set_visual_carry(carry_data[#carry_data].carry_id)
	end
end

function HuskPlayerMovement:set_visual_carry(carry_id)
	self._carry_id = carry_id

	if carry_id then
		if tweak_data.carry[carry_id].visual_unit_name then
			self:_create_carry_unit(tweak_data.carry[carry_id].visual_unit_name)

			return
		end

		local object_name = tweak_data.carry[carry_id].visual_object or "g_lootbag"
		self._current_visual_carry_object = self._unit:get_object(Idstring(object_name))

		self._current_visual_carry_object:set_visibility(true)
	elseif alive(self._current_visual_carry_object) then
		self._current_visual_carry_object:set_visibility(false)

		self._current_visual_carry_object = nil
	else
		self:_destroy_current_carry_unit()
	end
end

-- disable gadgets making players aim up permanently
function HuskPlayerMovement:set_cbt_permanent() end

-- Transparency loud target priority multiplier
function HuskPlayerMovement:_apply_attention_setting_modifications(setting)
	setting.detection = self._unit:base():detection_settings()
	local weight_mul = self._unit:base():upgrade_value("player", "camouflage_bonus") or 1
	weight_mul = weight_mul * (self._unit:base():upgrade_value("player", "camouflage_multiplier") or 1)
	weight_mul = weight_mul * (self._unit:base():upgrade_value("player", "uncover_multiplier") or 1)

	local transparency_upgrade = self._unit:base():upgrade_value("player", "detection_risk_transparency") or nil

	if transparency_upgrade then
		local peer = managers.network:session():peer_by_unit(self._unit)
		local detection_risk = managers.blackmarket:get_suspicion_offset_of_peer(peer, tweak_data.player.SUSPICION_OFFSET_LERP or 0.75)
		local transparency_value = self._unit:base():get_value_from_risk_upgrade(transparency_upgrade, detection_risk) or 0

		weight_mul = weight_mul * (1 - (0.05 * transparency_value))
	end

	if weight_mul and weight_mul ~= 1 then
		setting.weight_mul = (setting.weight_mul or 1) * weight_mul
	end
end

-- Security Camera Rework by Hoppip
local on_uncovered_original = HuskPlayerMovement.on_uncovered
function HuskPlayerMovement:on_uncovered(enemy_unit, ...)
	local enemy_base = alive(enemy_unit) and enemy_unit:base()
	if not enemy_base or not enemy_base._get_operator or not enemy_base:_get_operator() then
		return on_uncovered_original(self, enemy_unit, ...)
	end
end

if UsefulBots then
	return
end

if not Network:is_server() then
	return
end

-- Fix assistance SO so bots return to their hold position when done
Hooks:OverrideFunction(HuskPlayerMovement, "set_need_assistance", function (self, need_assistance)
	if self._need_assistance == need_assistance then
		return
	end

	self._need_assistance = need_assistance

	if need_assistance and not self._assist_SO_id then
		self._assist_SO_id = "PlayerHusk_assistance" .. tostring(self._unit:key())
		managers.groupai:state():add_special_objective(self._assist_SO_id, Eclipse.utils.team_ai_get_assist_SO(self._unit))
	elseif not need_assistance and self._assist_SO_id then
		managers.groupai:state():remove_special_objective(self._assist_SO_id)
		Eclipse.utils.team_ai_stop_assist_objective(self._unit)
		self._assist_SO_id = nil
	end
end)
