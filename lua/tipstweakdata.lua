function TipsTweakData:init()
	-- this is the only way i could get it to be a toggleable thing without it crashing
	if not Eclipse.settings.flavor_text_tips then
		local f_tips = io.open(Eclipse.mod_path .. "data/tips.json", "r")
		if f_tips then
			self.tips = json.decode(f_tips:read("*all")).tips
		end
	elseif Eclipse.settings.flavor_text_tips then
		local f_tips = io.open(Eclipse.mod_path .. "data/tips.json", "r")
		if f_tips then
			self.tips = json.decode(f_tips:read("*all")).flavor_tips
		end
	end

	self.category_totals = {}

	for _, tip in ipairs(self.tips) do
		if not self.category_totals[tip.category] or self.category_totals[tip.category] < tip.cat_index then
			self.category_totals[tip.category] = tip.cat_index
		end
	end
end
