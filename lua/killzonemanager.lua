function KillzoneManager:_deal_gas_damage(unit)
	unit:character_damage():damage_killzone({
		variant = "teargas",
		damage = 3,
		col_ray = {
			ray = math.UP,
		},
	})
end
