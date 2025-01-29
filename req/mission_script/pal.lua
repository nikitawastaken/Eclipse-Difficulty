local scripted_enemy = Eclipse.scripted_enemy
local is_eclipse = Eclipse.utils.is_eclipse()
local is_pro_job = Eclipse.utils.is_eclipse()
local is_eclipse_pro = is_eclipse and is_pro_job

local cop_smg = scripted_enemy.cop_3
local shield = scripted_enemy.shield
local elite_shield = scripted_enemy.elite_shield

local shield = {
	values = {
        enemy = is_eclipse_pro and elite_shield or shield
	}
}
local disabled = {
	values = {
        enabled = false
	}
}

return {
	--Water from the hose fills the safe much slower like in PDTH
	[101229] = {
		values = {
            timer = 240
		}
	},
	[101237] = {
		values = {
            time = 200
		}
	},
	[101236] = {
		values = {
            time = 140
		}
	},
	[101235] = {
		values = {
            time = 60
		}
	},
	[100897] = {
		values = {
            time = 30
		}
	},
	--Replace 2nd bronco cop with shotgun cop to match with PDTH style
	[100725] = {
		values = {
            enemy = cop_smg
		}
	},
	--Disable the 2nd police crusier if the cops are already alerted
	[103034] = {
		on_executed = {
            { id = 400015, delay = 0 }
		}
	},
	--delay the next anim by few more seconds to let the previous anim end (fix for Wilson's SWAT van)
	[101647] = {
		on_executed = {
            { id = 101648, delay = 10.5 }
		}
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
			{ id = 400016, delay = 3.5 }
		}
	},
	--disable vanilla snipers
	[102941] = disabled,
	--Add the missing sniper access
	[102399] = {
		pre_func = function (self)
			if not self._values.SO_access_original then
				self._values.SO_access_original = self._values.SO_access
				self._values.SO_access = managers.navigation:convert_access_filter_to_number({"cop", "swat", "fbi", "taser", "sniper", "spooc"})
			end
		end
	},
	--Elite Shields replaces FBI ones that cover the manhole on Eclipse (PJ only) 
	[100036] = shield,
	[100039] = shield,
	[100044] = shield,
	[101848] = shield,
	[101908] = shield,
	[101911] = shield,
	[100642] = shield,
	[100777] = shield,
	[100795] = shield,
	[101804] = shield,
	[101883] = shield,
	[102098] = shield
}