local missing_taser_access_fix = {
	so_access_filter = { "cop", "swat", "tank", "shield", "taser" },
}
return {
	-- fix one of the ai_hunt SOs not having taser access
	[100675] = missing_taser_access_fix,
}
