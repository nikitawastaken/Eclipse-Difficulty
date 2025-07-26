function KillzoneManager:_deal_gas_damage(unit)
	unit:character_damage():damage_killzone({
		variant = "teargas",
		damage = 1.5,
		col_ray = {
			ray = math.UP,
		},
	})
end

function KillzoneManager:_deal_fire_damage(unit)
	local attack_data = {
		variant = "fire",
		damage = 1,
		col_ray = {
			ray = math.UP
		}
	}

	unit:character_damage():damage_killzone(attack_data)
end
