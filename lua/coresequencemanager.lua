local function load_environment(level_tweak, environment_name)
	local environment_data = Eclipse:require("envsmod/" .. environment_name)

	if not environment_data then
		return
	end

	local new_color_grading = type(environment_data.color_grading) == "table" and table.random(environment_data.color_grading) or environment_data.color_grading

	if new_color_grading then
		level_tweak.env_params.color_grading = new_color_grading
	end

	if environment_data.flashlights_on ~= nil then
		level_tweak.flashlights_on = environment_data.flashlights_on
	end

	if environment_data.environment_override then
		for k, v in pairs(environment_data.environment_override) do
			BeardLib:ReplaceScriptData(v, "custom_xml", k, "environment")
		end
	end

	if environment_data.sounds_override then
		for k, v in pairs(environment_data.sounds_override) do
			BeardLib:ReplaceScriptData(v, "custom_xml", k, "world_sounds")
		end
	end
end

Hooks:Add("BeardLibCreateScriptDataMods", "TODCallBeardLibSequenceFuncs", function()
	if not Global.load_level then
		return
	end

	local level_id = Eclipse.utils.level_id()
	local level_tweak = tweak_data.levels[level_id]

	if not level_tweak then
		return
	end

	if not level_tweak.random_environments then
		return
	end

	if NetworkHelper:IsHost() then
		local weighted_selector = Eclipse.utils.weighted_selector
		Eclipse.current_environment = weighted_selector(level_tweak.random_environments):select()
	end

	if Eclipse.current_environment == "default" or not Eclipse.current_environment then
		return
	end

	load_environment(level_tweak, Eclipse.current_environment)
end)

local ids_scene = Idstring("scene")

Hooks:Add("BeardLibPreProcessScriptData", "CreateEnvironment", function(PackManager, path, raw_data)
	if managers.dyn_resource then
		local skies = {
			"sky_1930_twillight",
			"sky_1930_sunset_heavy_clouds",
			"sky_1846_low_sun_nice_clouds",
			"sky_0902_overcast",
			"sky_1530_low_sun_clouds",
			"sky_1945_sunset",
			"sky_1945_sunset_clouds",
			"sky_1224_clear_sky",
			"sky_1830_low_sun_clouds",
			"sky_0902_overcast_dark",
			"sky_1931_low_sun",
			"sky_1345_clear_sky",
			"sky_0200_night_moon_stars",
			"sky_2000_twilight_mad",
			"sky_2100_moon",
			"sky_1008_cloudy",
			"sky_0927_whispy_clouds",
			"sky_2335_night_moon",
			"sky_2100_moon",
			"sky_2003_sunrise",
			"sky_city_clear",
			"sky_dah_night",
			"sky_1313_cloudy_dark",
			"sky_2003_dusk_blue",
			"sky_2003_dusk_blue_high_color_scale",
			"sky_279_dusk",
		}
		for _, sky in ipairs(skies) do
			if not managers.dyn_resource:has_resource(ids_scene, Idstring("core/environments/skies/" .. sky .. "/" .. sky), managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
				managers.dyn_resource:load(ids_scene, Idstring("core/environments/skies/" .. sky .. "/" .. sky), managers.dyn_resource.DYN_RESOURCES_PACKAGE, nil)
			end
		end
	end
end)

core:module("CoreSequenceManager")

function MaterialConfigElement.load(unit, data)
	if not unit:base() or not unit:base()._block_seq_manager_material_load then
		managers.dyn_resource:change_material_config(data.material, unit)
	end
end
