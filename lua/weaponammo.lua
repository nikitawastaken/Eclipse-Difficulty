function WeaponAmmo:calculate_ammo_max_per_clip()
	local ammo = self:weapon_tweak_data().CLIP_AMMO_MAX
	ammo = ammo + managers.player:upgrade_value(self._name_id, "clip_ammo_increase")

	if not self:upgrade_blocked("weapon", "clip_ammo_increase") then
		ammo = math.ceil(ammo * managers.player:upgrade_value("weapon", "clip_ammo_increase", 1))
	end

	for _, category in ipairs(tweak_data.weapon[self._name_id].categories) do
		if not self:upgrade_blocked(category, "clip_ammo_increase") then
			ammo = ammo + managers.player:upgrade_value(category, "clip_ammo_increase", 0)
		end
	end

	return ammo
end
