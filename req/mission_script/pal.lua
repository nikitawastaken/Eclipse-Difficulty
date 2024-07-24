local difficulty = tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or "normal")
local pro_job = Global.game_settings and Global.game_settings.one_down
local cop_sg = "units/payday2/characters/ene_cop_3/ene_cop_3"
local titan_shield = (difficulty == 6 and pro_job and "units/pd2_dlc_vip/characters/ene_phalanx_1/ene_phalanx_1")

local tshield = {
	values = {
        enemy = titan_shield
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
            enemy = cop_sg
		}
	},
	--Disable the 2nd police crusier if the cops are already alerted
	[103034] = {
		on_executed = {
            {id = 400015, delay = 0}
		}
	},
	--delay the next anim by few more seconds to let the previous anim end (fix for Wilson's SWAT van)
	[101647] = {
		on_executed = {
            {id = 101648, delay = 10.5}
		}
	},
	--Spawn custom PDTH styled snipers at the start of 2nd assault
	--Bain warns about them
	[102082] = {
		on_executed = {
            {id = 400001, delay = 5},
			{id = 400002, delay = 5},
			{id = 400003, delay = 5},
			{id = 400004, delay = 5},
			{id = 400005, delay = 5},
			{id = 400016, delay = 3.5}
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
	[100036] = tshield,
	[100039] = tshield,
	[100044] = tshield,
	[101848] = tshield,
	[101908] = tshield,
	[101911] = tshield,
	[100642] = tshield,
	[100777] = tshield,
	[100795] = tshield,
	[101804] = tshield,
	[101883] = tshield,
	[102098] = tshield
}