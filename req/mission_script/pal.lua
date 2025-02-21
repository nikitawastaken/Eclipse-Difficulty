local scripted_enemy = Eclipse.scripted_enemy
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_eclipse()
local is_eclipse_pro = is_eclipse and is_pro_job

local cop_smg = scripted_enemy.cop_3
local shield = scripted_enemy.shield
local elite_shield = scripted_enemy.elite_shield

local shield_spawn = {
	values = {
		enemy = is_eclipse_pro and elite_shield or shield,
	},
}
local disabled = {
	values = {
		enabled = false,
	},
}

return {
	--Water from the hose fills the safe much slower like in PDTH
	[101229] = {
		values = {
			timer = 240,
		},
	},
	[101237] = {
		values = {
			time = 200,
		},
	},
	[101236] = {
		values = {
			time = 140,
		},
	},
	[101235] = {
		values = {
			time = 60,
		},
	},
	[100897] = {
		values = {
			time = 30,
		},
	},
	--Reinforce Spots
	[100031] = {
		reinforce = {
			{
				name = "protect_the_BBQ",
				force = 3,
				position = Vector3(-3680, 1926, 26.700),
			},
			{
				name = "Mitchell_house_1",
				force = 3,
				position = Vector3(-2286, 2640, 78.789),
			},
			{
				name = "Mitchell_house_2",
				force = 3,
				position = Vector3(-2556, 3836, 75.500),
			},
			{
				name = "Wilson_house_1",
				force = 3,
				position = Vector3(-2080, 39, 28.970),
			},
			{
				name = "Wilson_house_2",
				force = 3,
				position = Vector3(-2980, 1441, -324.500),
			},
		},
	},
	--Disable vanilla's reinforce points
	[100218] = disabled,
	[101635] = disabled,
	[101636] = disabled,
	--Replace 2nd bronco cop with smg cop to match with PDTH style (even if he doesn't carry a shotgun)
	[100725] = {
		values = {
			enemy = cop_smg,
		},
	},
	--Disable the 2nd police crusier if the cops are already alerted
	[103034] = {
		on_executed = {
			{ id = 400015, delay = 0 },
		},
	},
	--delay the next anim by few more seconds to let the previous anim end (fix for Wilson's SWAT van)
	[101647] = {
		on_executed = {
			{ id = 101648, delay = 10.5 },
		},
	},
	--Spawn custom PDTH styled snipers at the start of 2nd assault
	--Bain warns about them
	[102082] = {
		on_executed = {
			{ id = 400001, delay = 5 },
			{ id = 400002, delay = 5 },
			{ id = 400003, delay = 5 },
			{ id = 400004, delay = 5 },
			{ id = 400005, delay = 5 },
			{ id = 400016, delay = 3.5 },
		},
	},
	--disable vanilla snipers
	[102941] = disabled,
	--Add the missing sniper access
	[102399] = {
		pre_func = function(self)
			if not self._values.SO_access_original then
				self._values.SO_access_original = self._values.SO_access
				self._values.SO_access = managers.navigation:convert_access_filter_to_number({ "cop", "swat", "fbi", "taser", "sniper", "spooc" })
			end
		end,
	},
	-- spawn two extra tasers with blockade shields on Eclipse (193+ throwback)
	[103336] = {
		on_executed = {
			{ id = 400017, delay = 0 },
			{ id = 400018, delay = 0 },
		},
	},
	[101803] = {
		on_executed = {
			{ id = 400019, delay = 0 },
			{ id = 400020, delay = 0 },
		},
	},
	--Elite Shields replaces FBI ones that cover the manhole on Eclipse (PJ only)
	[100036] = shield_spawn,
	[100039] = shield_spawn,
	[100044] = shield_spawn,
	[101848] = shield_spawn,
	[101908] = shield_spawn,
	[101911] = shield_spawn,
	[100642] = shield_spawn,
	[100777] = shield_spawn,
	[100795] = shield_spawn,
	[101804] = shield_spawn,
	[101883] = shield_spawn,
	[102098] = shield_spawn,
}
