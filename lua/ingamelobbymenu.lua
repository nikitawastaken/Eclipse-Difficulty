-- remove the functionality of pro job failures instantly booting you out of the game
function IngameLobbyMenuState:at_enter()
	managers.music:stop()
	managers.platform:set_presence("Mission_end")
	managers.platform:set_rich_presence_state(Global.game_settings.single_player and "SPEnd" or "MPEnd")
	managers.hud:remove_updator("point_of_no_return")
	print("[IngameLobbyMenuState:at_enter()]")

	if managers.network:session() and Network:is_server() then
		managers.network.matchmake:set_server_state("in_lobby")
		managers.network:session():set_state("in_lobby")
	end

	managers.mission:pre_destroy()

	self._continue_block_timer = Application:time() + 0.5

	managers.menu:close_menu("pause_menu")

	if managers.job:stage_success() then
		managers.job:next_stage()
	end

	if managers.job:is_job_finished() then
		self:load_loothud(true)
		self:open_lootscreen()
		self:make_lootdrop()
	elseif Network:is_client() then
		self:load_loothud(false)
		self:open_lootscreen()
	end

	if (Network:is_server() or managers.dlc:is_trial()) and not managers.job:is_job_finished() then
		if managers.network:session() and Network:is_server() then
			managers.network.matchmake:set_server_joinable(true)
		end

		if not managers.job:stage_success() then
			-- if managers.job:is_current_job_professional() then
			-- 	MenuCallbackHandler:load_start_menu_lobby()
			-- else
				managers.game_play_central:restart_the_game()
			-- end
		else
			MenuCallbackHandler:on_stage_success()
			MenuCallbackHandler:start_the_game()
		end
	end
end