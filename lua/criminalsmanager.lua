local is_pro_job = Eclipse.utils.is_pro_job()

if is_pro_job then
	CriminalsManager.MAX_NR_TEAM_AI = 1
else
	CriminalsManager.MAX_NR_TEAM_AI = 2
end
