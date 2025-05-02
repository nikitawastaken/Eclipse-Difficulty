function CrimeNetGui:four_stars(job, inside)
	local stars_panel = job.side_panel:child("stars_panel")

	if inside.job_id then
		stars_panel:child(4):hide() -- thanks james for this
		stars_panel:child(5):hide()
	end
end

local gui = CrimeNetGui._create_job_gui
function CrimeNetGui:_create_job_gui(data, type, fixed_x, fixed_y, fixed_location)
	local gui_data = gui(self, data, type, fixed_x, fixed_y, fixed_location)

	self:four_stars(gui_data, data)

	return gui_data
end
