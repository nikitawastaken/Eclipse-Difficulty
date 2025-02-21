local no_shields_and_dozers = {
	pre_func = function(self)
		if not self._values.SO_access_original then
			self._values.SO_access_original = self._values.SO_access
			self._values.SO_access = managers.navigation:convert_access_filter_to_number({ "cop", "swat", "fbi", "taser", "spooc" })
		end
	end,
}
return {
	-- Fix power cut SO delay and add some random delay
	[104685] = {
		values = {
			base_delay = 15,
			base_delay_rand = 15,
		},
	},
	-- prevent shields and dozers from disabling the power
	[104699] = no_shields_and_dozers,
	[104700] = no_shields_and_dozers,
	[104701] = no_shields_and_dozers,
	[104702] = no_shields_and_dozers,
	[104703] = no_shields_and_dozers,
	[104704] = no_shields_and_dozers,
	[104705] = no_shields_and_dozers,
	[104706] = no_shields_and_dozers,
	[104707] = no_shields_and_dozers,
	[104708] = no_shields_and_dozers,
}
