-- Scale gained drama with player count
function GroupAIStateBase:criminal_hurt_drama(unit, attacker, dmg_percent)
	self._drama_data.drama_bal_mul = tweak_data.drama.drama_balance_mul
	local drama_data = self._drama_data
	local drama_player_mul = self:_get_balancing_multiplier(self._drama_data.drama_bal_mul)
	local drama_amount = drama_data.actions.criminal_hurt * dmg_percent * drama_player_mul

	if alive(attacker) then
		local max_dis = drama_data.max_dis
		local dis_lerp = math.min(1, mvector3.distance(attacker:movement():m_pos(), unit:movement():m_pos()) / drama_data.max_dis)
		dis_lerp = math.lerp(1, drama_data.dis_mul, dis_lerp)
		drama_amount = drama_amount * dis_lerp
	end

	self:_add_drama(drama_amount)
end

local _update_whitelist = {
	"hox_1",
	"hox_2",
	"red2",
	"spa",
	"pal",
	"flat",
	"rvd2"
}

local function check_whitelist(id)
    for _, level in pairs(_update_whitelist) do
        if level == id then
            return true
        end
    end

    return false
end

-- Code from Dr. Newbie
local _old_update_point_of_no_return = GroupAIStateBase._update_point_of_no_return

function GroupAIStateBase:_update_point_of_no_return(t, dt)
    local get_mission_script_element = function(id)
        for name, script in pairs(managers.mission:scripts()) do
            if script:element(id) then
                return script:element(id)
            end
        end
    end

    local level_id = managers.job:has_active_job() and managers.job:current_level_id() or ""

    if check_whitelist(level_id) then
        self._point_of_no_return_timer = self._point_of_no_return_timer - dt
    end

    if not self._point_of_no_return_id or not get_mission_script_element(self._point_of_no_return_id) then
        if self._point_of_no_return_timer <= 0 then
            managers.network:session():send_to_peers("mission_ended", false, 0)
            game_state_machine:change_state_by_name("gameoverscreen")
        else
            managers.hud:feed_point_of_no_return_timer(self._point_of_no_return_timer)
        end
    else
        _old_update_point_of_no_return(self, t, dt)
    end
end
-- End code from Dr. Newbie


-- Set up needed variables
Hooks:PostHook(GroupAIStateBase, "init", "sh_init", function (self)
	self._next_police_upd_task = 0
	self._next_group_spawn_t = {}
end)


-- Make elite dozers register as specials
local function register_special_types(gstate)
	gstate._special_unit_types.tank_elite = true
	gstate._special_unit_mappings = {
		tank_elite = { "tank" }
	}
end

Hooks:PostHook(GroupAIStateBase, "_init_misc_data", "sh__init_misc_data", register_special_types)
Hooks:PostHook(GroupAIStateBase, "on_simulation_started", "sh_on_simulation_started", register_special_types)

local register_special_unit_original = GroupAIStateBase.register_special_unit
function GroupAIStateBase:register_special_unit(u_key, category_name, ...)
	local mapping = self._special_unit_mappings[category_name]
	if mapping then
		for _, v in pairs(mapping) do
			register_special_unit_original(self, u_key, v, ...)
		end
	else
		register_special_unit_original(self, u_key, category_name, ...)
	end
end

local unregister_special_unit_original = GroupAIStateBase.unregister_special_unit
function GroupAIStateBase:unregister_special_unit(u_key, category_name, ...)
	local mapping = self._special_unit_mappings[category_name]
	if mapping then
		for _, v in pairs(mapping) do
			unregister_special_unit_original(self, u_key, v, ...)
		end
	else
		unregister_special_unit_original(self, u_key, category_name, ...)
	end
end


-- Restore scripted cloaker spawn noise
local _process_recurring_grp_SO_original = GroupAIStateBase._process_recurring_grp_SO
function GroupAIStateBase:_process_recurring_grp_SO(...)
	if _process_recurring_grp_SO_original(self, ...) then
		managers.network:session():send_to_peers_synched("group_ai_event", self:get_sync_event_id("cloaker_spawned"), 0)
		managers.hud:post_event("cloaker_spawn")
		return true
	end
end

-- Log time when criminals enter an area to use for the teargas check
Hooks:PreHook(GroupAIStateBase, "on_criminal_nav_seg_change", "sh_on_criminal_nav_seg_change", function (self, unit, nav_seg_id)
	local u_sighting = self._criminals[unit:key()]
	if not u_sighting or u_sighting.ai then
		return
	end

	local prev_area = u_sighting.area
	local area = self:get_area_from_nav_seg_id(nav_seg_id)
	if prev_area and prev_area ~= area then
		if table.count(prev_area.criminal.units, function (c_data) return not c_data.ai end) <= 1 then
			prev_area.criminal_left_t = self._t
			prev_area.old_criminal_entered_t = prev_area.criminal_entered_t
			prev_area.criminal_entered_t = nil
		end
		if not area.criminal_entered_t then
			if area.criminal_left_t and area.old_criminal_entered_t then
				area.criminal_entered_t = math.lerp(area.old_criminal_entered_t, self._t, math.min((self._t - area.criminal_left_t) / 20, 1))
			else
				area.criminal_entered_t = self._t
			end
		end
	end
end)


-- Register Winters and minions as soon as they spawn, not just after they reach their objective or take damage
-- This fixes instances of Winters not leaving the map because the phalanx is broken up before he is registered
Hooks:PostHook(GroupAIStateBase, "on_enemy_registered", "sh_on_enemy_registered", function (self, unit)
	if self._phalanx_spawn_group and not self._phalanx_spawn_group.has_spawned then
		local logics = unit:brain()._logics
		if logics == CopBrain._logic_variants.phalanx_minion then
			self:register_phalanx_minion(unit)
		elseif logics == CopBrain._logic_variants.phalanx_vip then
			self:register_phalanx_vip(unit)
		end
	end
end)


-- Delay spawn points when enemies die close to them
Hooks:PostHook(GroupAIStateBase, "on_enemy_unregistered", "sh_on_enemy_unregistered", function (self, unit)
	if not Network:is_server() or not unit:character_damage():dead() then
		return
	end

	local e_data = self._police[unit:key()]
	if not e_data.group or not e_data.group.has_spawned then
		return
	end

	local spawn_point = unit:unit_data().mission_element
	if not spawn_point then
		return
	end

	local u_pos = e_data.m_pos
	local spawn_pos = spawn_point:value("position")
	local dist_sq = mvector3.distance_sq(spawn_pos, u_pos)
	local max_dist_sq = 1000000
	if dist_sq > max_dist_sq then
		return
	end

	for _, area in pairs(self._area_data) do
		if area.spawn_groups then
			for _, group in pairs(area.spawn_groups) do
				if group.spawn_pts then
					for _, point in pairs(group.spawn_pts) do
						if point.mission_element == spawn_point then
							local delay_t = self._t + math.lerp(8, 0, dist_sq / max_dist_sq)
							group.delay_t = math.max(group.delay_t, delay_t)
							return
						end
					end
				end
			end
		end
	end
end)


-- Fix this function doing nothing
function GroupAIStateBase:_merge_coarse_path_by_area(coarse_path)
	local i_nav_seg = #coarse_path
	local area, last_area
	while i_nav_seg > 0 and #coarse_path > 2 do
		area = self:get_area_from_nav_seg_id(coarse_path[i_nav_seg][1])
		if last_area and last_area == area then
			table.remove(coarse_path, i_nav_seg)
		else
			last_area = area
		end
		i_nav_seg = i_nav_seg - 1
	end
end


-- Check nav segment safety directly instead of area safety
function GroupAIStateBase:is_nav_seg_safe(nav_seg)
	for _, u_data in pairs(self._criminals) do
		if u_data.tracker:nav_segment() == nav_seg then
			return
		end
	end

	return true
end


-- Don't count recon as assault force and vice versa
function GroupAIStateBase:_count_police_force(task_name)
	local amount = 0
	local objective_type = task_name .. "_area"
	for _, group in pairs(self._groups) do
		if group.objective.type == objective_type then
			amount = amount + (group.has_spawned and group.size or group.initial_size)
		end
	end
	return amount
end


-- Set accurate criminal position
Hooks:PostHook(GroupAIStateBase, "criminal_spotted", "sh_criminal_spotted", function (self, unit)
	local u_sighting = self._criminals[unit:key()]
	mvector3.set(u_sighting.pos, u_sighting.m_det_pos)
end)

Hooks:PostHook(GroupAIStateBase, "on_criminal_nav_seg_change", "sh_on_criminal_nav_seg_change", function (self, unit)
	local u_sighting = self._criminals[unit:key()]
	if u_sighting then
		mvector3.set(u_sighting.pos, u_sighting.m_det_pos)
	end
end)


-- Make jokers follow their actual owner instead of the closest player
local _determine_objective_for_criminal_AI_original = GroupAIStateBase._determine_objective_for_criminal_AI
function GroupAIStateBase:_determine_objective_for_criminal_AI(unit, ...)
	local logic_data = unit:brain()._logic_data
	if logic_data.is_converted and alive(logic_data.minion_owner) then
		return {
			type = "follow",
			scan = true,
			follow_unit = logic_data.minion_owner
		}
	end

	return _determine_objective_for_criminal_AI_original(self, unit, ...)
end
