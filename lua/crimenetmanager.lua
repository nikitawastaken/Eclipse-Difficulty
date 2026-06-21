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

-- Fix difficulty filter abuse
function CrimeNetManager:_setup()
	if self._presets then
		return
	end

	self._presets = {}
	local plvl = managers.experience:current_level()
	local player_stars = math.clamp(math.ceil((plvl + 1) / 10), 1, 10)
	local stars = player_stars
	local jc = math.lerp(0, 100, stars / 10)
	local jcs = tweak_data.narrative.STARS[stars].jcs
	local no_jcs = #jcs
	local chance_curve = tweak_data.narrative.STARS_CURVES[player_stars]
	local start_chance = tweak_data.narrative.JC_CHANCE
	local jobs_by_jc = self:_get_jobs_by_jc()
	local no_picks = self:_number_of_jobs(jcs, jobs_by_jc)
	local j = 0
	local tests = 0

	while j < no_picks do
		for i = 1, no_jcs do
			local chance = nil

			if no_jcs - 1 == 0 then
				chance = 1
			else
				chance = math.lerp(start_chance, 1, math.pow((i - 1) / (no_jcs - 1), chance_curve))
			end

			if not jobs_by_jc[jcs[i]] then
				-- Nothing
			elseif #jobs_by_jc[jcs[i]] ~= 0 then
				local job_data = nil

				if self._debug_mass_spawning then
					job_data = jobs_by_jc[jcs[i]][math.random(#jobs_by_jc[jcs[i]])]
				else
					job_data = table.remove(jobs_by_jc[jcs[i]], math.random(#jobs_by_jc[jcs[i]]))
				end

				local job_tweak = tweak_data.narrative:job_data(job_data.job_id)
				local chance_multiplier = job_tweak and job_tweak.spawn_chance_multiplier or 1
				job_data.chance = chance * chance_multiplier

				table.insert(self._presets, job_data)

				j = j + 1

				break
			end
		end

		tests = tests + 1

		if self._debug_mass_spawning then
			if tweak_data.gui.crime_net.debug_options.mass_spawn_limit <= tests then
				break
			end
		elseif no_picks <= tests then
			break
		end
	end

	local old_presets = self._presets
	self._presets = {}

	while #old_presets > 0 do
		table.insert(self._presets, table.remove(old_presets, math.random(#old_presets)))
	end
end

function CrimeNetManager:update_difficulty_filter()
	if self._presets then
		self._presets = nil

		self:_setup()
	end
end

-- Random contracts popups with Pro Job modifier
function CrimeNetManager:_get_jobs_by_jc()
	local t = {}
	local plvl = managers.experience:current_level()
	local prank = managers.experience:current_rank()

	for _, job_id in ipairs(tweak_data.narrative:get_jobs_index()) do
		local is_cooldown_ok = managers.job:check_ok_with_cooldown(job_id)
		local is_not_wrapped = not tweak_data.narrative.jobs[job_id].wrapped_to_job
		local dlc = tweak_data.narrative:job_data(job_id).dlc
		local is_not_dlc_or_got = not dlc or managers.dlc:is_dlc_unlocked(dlc)
		local pass_all_tests = is_cooldown_ok and is_not_wrapped and is_not_dlc_or_got
		pass_all_tests = pass_all_tests and not tweak_data.narrative:is_job_locked(job_id)

		if pass_all_tests then
			local job_data = tweak_data.narrative:job_data(job_id)
			local start_difficulty = plvl >= 80 and 2 or plvl >= 40 and 1 or 0
			local num_difficulties = 4

			for i = start_difficulty, num_difficulties do
				local job_jc = math.clamp(job_data.jc + i * 10, 0, 100)
				local difficulty_id = 2 + i
				local difficulty = tweak_data:index_to_difficulty(difficulty_id)
				local one_down_active = math.random() <= 0.2 and difficulty ~= "normal" and 1 or 0
				local level_lock = tweak_data.difficulty_level_locks[difficulty_id] or 0
				local is_not_level_locked = prank >= 1 or level_lock <= plvl

				if is_not_level_locked then
					t[job_jc] = t[job_jc] or {}
					-- Pro Job popup chance
					table.insert(t[job_jc], {
						job_id = job_id,
						difficulty_id = difficulty_id,
						difficulty = difficulty,
						marker_dot_color = job_data.marker_dot_color or nil,
						color_lerp = job_data.color_lerp or nil,
						one_down = one_down_active,
					})
				end
			end
		else
			-- Nothing
		end
	end

	return t
end
