function NewFlamethrowerBase:setup_default()
    self:kill_effects()

    local unit = self._unit
    local nozzle_obj = unit:get_object(Idstring("fire"))
    self._nozzle_obj = nozzle_obj
    local name_id = self._name_id
    local weap_tweak = tweak_data.weapon[name_id]
    local flame_effect_range = weap_tweak.flame_max_range
    self._range = flame_effect_range
    self._flame_max_range = flame_effect_range
    self._flame_radius = weap_tweak.flame_radius or 40
    local flame_effect = weap_tweak.flame_effect

    if flame_effect then
        self._last_effect_t = -100
        self._flame_effect_collection = {}
        self._flame_effect_ids = Idstring(flame_effect)
        self._flame_max_range_sq = flame_effect_range * flame_effect_range
        local effect_duration = weap_tweak.single_flame_effect_duration
        self._single_flame_effect_duration = effect_duration
        self._single_flame_effect_cooldown = effect_duration * 0.1
    else
        self._last_effect_t = nil
        self._flame_effect_collection = nil
        self._flame_effect_ids = nil
        self._flame_max_range_sq = nil
        self._single_flame_effect_duration = nil
        self._single_flame_effect_cooldown = nil

        print("[NewFlamethrowerBase:setup_default] No flame effect defined for tweak data ID ", name_id)
    end

    local effect_manager = self._effect_manager
    local pilot_effect = weap_tweak.pilot_effect

    if pilot_effect then
        local parent_obj = nil
        local parent_name = weap_tweak.pilot_parent_name

        if parent_name then
            parent_obj = unit:get_object(Idstring(parent_name))

            if not parent_obj then
                print("[NewFlamethrowerBase:setup_default] No pilot parent object found with name ", parent_name, "in unit ", unit)
            end
        end

        parent_obj = parent_obj or nozzle_obj
        local force_synch = self.is_npc and not self:is_npc()
        local pilot_offset = weap_tweak.pilot_offset or nil
        local normal = weap_tweak.pilot_normal or Vector3(0, 0, 1)
        local pilot_effect_id = effect_manager:spawn({
            effect = Idstring(pilot_effect),
            parent = parent_obj,
            force_synch = force_synch,
            position = pilot_offset,
            normal = normal
        })
        self._pilot_effect = pilot_effect_id
        local state = (not self._enabled or not self._visible) and true or false

        effect_manager:set_hidden(pilot_effect_id, state)
        effect_manager:set_frozen(pilot_effect_id, state)
    else
        self._pilot_effect = nil
    end

    local nozzle_effect = weap_tweak.nozzle_effect

    if nozzle_effect then
        self._last_fire_t = -100
        self._nozzle_expire_t = weap_tweak.nozzle_expire_time or 0.2
        local force_synch = self.is_npc and not self:is_npc()
        local normal = weap_tweak.nozzle_normal or Vector3(0, 1, 0)
        local nozzle_effect_id = effect_manager:spawn({
            effect = Idstring(nozzle_effect),
            parent = nozzle_obj,
            force_synch = force_synch,
            normal = normal
        })
        self._nozzle_effect = nozzle_effect_id

        effect_manager:set_hidden(nozzle_effect_id, true)
        effect_manager:set_frozen(nozzle_effect_id, true)

        self._showing_nozzle_effect = false
    else
        self._last_fire_t = nil
        self._nozzle_expire_t = nil
        self._nozzle_effect = nil
        self._showing_nozzle_effect = nil
    end

    local bullet_class = weap_tweak.bullet_class

    if bullet_class ~= nil then
        bullet_class = CoreSerialize.string_to_classtable(bullet_class)

        if not bullet_class then
            print("[NewFlamethrowerBase:setup_default] Unexisting class for bullet_class string ", weap_tweak.bullet_class, "defined for tweak data ID ", name_id)

            bullet_class = FlameBulletBase
        end
    else
        bullet_class = FlameBulletBase
    end

    self._bullet_class = bullet_class
    self._bullet_slotmask = bullet_class:bullet_slotmask()
    if Global.game_settings and Global.game_settings.one_down then self._bullet_slotmask = self._bullet_slotmask + 3 end
    self._blank_slotmask = bullet_class:blank_slotmask()
end