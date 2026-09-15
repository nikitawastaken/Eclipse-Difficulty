Hooks:Add("BeardLibCreateScriptDataMods", "TODCallBeardLibSequenceFuncs", function()
	if not Global.load_level then
		return
	end

	if NetworkHelper:IsHost() then
		local level_id = Eclipse.utils.level_id()
		local level_tweak = tweak_data.levels[level_id]

		if not level_tweak then
			return
		end

		if not level_tweak.random_environments then
			return
		end

		local weighted_selector = Eclipse.utils.weighted_selector
		Eclipse.current_environment = weighted_selector(level_tweak.random_environments):select()

		if Eclipse.current_environment == "default" or not Eclipse.current_environment then
			return
		end

		Eclipse.utils.load_environment(level_tweak, Eclipse.current_environment)
	end
end)

local ids_scene = Idstring("scene")

Hooks:Add("BeardLibPreProcessScriptData", "CreateEnvironment", function(PackManager, path, raw_data)
	if managers.dyn_resource then
		local skies = {
			"core/environments/skies/sky_1930_twillight/sky_1930_twillight",
			"core/environments/skies/sky_1930_sunset_heavy_clouds/sky_1930_sunset_heavy_clouds",
			"core/environments/skies/sky_1846_low_sun_nice_clouds/sky_1846_low_sun_nice_clouds",
			"core/environments/skies/sky_0902_overcast/sky_0902_overcast",
			"core/environments/skies/sky_1530_low_sun_clouds/sky_1530_low_sun_clouds",
			"core/environments/skies/sky_1945_sunset/sky_1945_sunset",
			"core/environments/skies/sky_1945_sunset_clouds/sky_1945_sunset_clouds",
			"core/environments/skies/sky_1224_clear_sky/sky_1224_clear_sky",
			"core/environments/skies/sky_1830_low_sun_clouds/sky_1830_low_sun_clouds",
			"core/environments/skies/sky_0902_overcast_dark/sky_0902_overcast_dark",
			"core/environments/skies/sky_1931_low_sun/sky_1931_low_sun",
			"core/environments/skies/sky_1345_clear_sky/sky_1345_clear_sky",
			"core/environments/skies/sky_0200_night_moon_stars/sky_0200_night_moon_stars",
			"core/environments/skies/sky_2000_twilight_mad/sky_2000_twilight_mad",
			"core/environments/skies/sky_2100_moon/sky_2100_moon",
			"core/environments/skies/sky_1008_cloudy/sky_1008_cloudy",
			"core/environments/skies/sky_0927_whispy_clouds/sky_0927_whispy_clouds",
			"core/environments/skies/sky_2335_night_moon/sky_2335_night_moon",
			"core/environments/skies/sky_2100_moon/sky_2100_moon",
			"core/environments/skies/sky_2003_sunrise/sky_2003_sunrise",
			"core/environments/skies/sky_city_clear/sky_city_clear",
			"core/environments/skies/sky_dah_night/sky_dah_night",
			"core/environments/skies/sky_1313_cloudy_dark/sky_1313_cloudy_dark",
			"core/environments/skies/sky_2003_dusk_blue/sky_2003_dusk_blue",
			"core/environments/skies/sky_2003_dusk_blue_high_color_scale/sky_2003_dusk_blue_high_color_scale",
			"core/environments/skies/sky_279_dusk/sky_279_dusk",
			"core/environments/skies/sky_v2_030_sun_low/sky_v2_030_sun_low",
			"core/environments/skies/sky_cloudy_blue/sky_cloudy_blue",
			"units/pd2_dlc_rvd/environments/sky_rvd_la_afternoon/sky_rvd_la_afternoon",
			"units/pd2_dlc_pent/architecture/cubemaps/sky_pent_dusk_0065/sky_pent_dusk_0065",
			"units/pd2_dlc_corp/cubemaps/sky_corp_deep_blue/sky_corp_deep_blue",
			"units/pd2_dlc_vit/environments/sky_vit_thunderstorm/sky_vit_thunderstorm",
		}
		for _, sky in ipairs(skies) do
			if not managers.dyn_resource:has_resource(ids_scene, Idstring(sky), managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
				managers.dyn_resource:load(ids_scene, Idstring(sky), managers.dyn_resource.DYN_RESOURCES_PACKAGE, nil)
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
