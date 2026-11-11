core:import("CoreEnvironmentEffectsManager")

EnvironmentEffectsManager = EnvironmentEffectsManager or class(CoreEnvironmentEffectsManager.EnvironmentEffectsManager)

function EnvironmentEffectsManager:init()
	EnvironmentEffectsManager.super.init(self)
	self:add_effect("rain", RainEffect:new(tweak_data.env_effect.rain))
	self:add_effect("rain_only", RainEffect:new(tweak_data.env_effect.rain_only))
	self:add_effect("snow", RainEffect:new(tweak_data.env_effect.snow))
	self:add_effect("snow_slow", RainEffect:new(tweak_data.env_effect.snow_slow))

	if not _G.IS_VR then
		self:add_effect("raindrop_screen", RainDropScreenEffect:new())
		self:add_effect("snowdrop_screen", SnowDropScreenEffect:new())
	end

	self:add_effect("lightning", LightningEffect:new(tweak_data.env_effect.lightning))
	self:add_effect("lightning_tag", LightningEffect:new(tweak_data.env_effect.lightning_tag))

	self._camera_position = Vector3()
	self._camera_rotation = Rotation()
end

function LightningEffect:start()
	if not Underlay:loaded() then
		self.update = self._update_wait_start

		return
	end

	print("[LightningEffect] Start")

	self._started = true
	self.update = self._update
	self._sky_material = Underlay:material(Idstring("sky"))
	self._original_color0 = self._sky_material:get_variable(Idstring("color0"))
	self._original_color2 = self._sky_material:get_variable(Idstring("color2"))
	self._original_light_color = Global._global_light:color()
	self._original_sun_horizontal = Underlay:time(Idstring("sun_horizontal"))
	self._min_interval = self._effect_data.min_interval or 2
	self._rnd_interval = self._effect_data.rnd_interval or 10
	self._sound_source = SoundDevice:create_source("thunder")

	self:_set_next_timer()
end

function LightningEffect:_set_original_values()
	if alive(self._sky_material) then
		self._sky_material:set_variable(Idstring("color0"), self._original_color0)
		self._sky_material:set_variable(Idstring("color2"), self._original_color2)
	end

	if self._original_light_color then
		Global._global_light:set_color(self._original_light_color)
	end

	if self._original_sun_horizontal then
		Underlay:set_time(Idstring("sun_horizontal"), self._original_sun_horizontal)
	end
end

function LightningEffect:_set_lightning_values()
	self._original_color0 = self._sky_material:get_variable(Idstring("color0")) -- sky top
	self._original_color2 = self._sky_material:get_variable(Idstring("color2")) -- sky bottom
	self._original_light_color = Global._global_light:color()
	self._original_sun_horizontal = Underlay:time(Idstring("sun_horizontal"))
	self._first_flash_time = 0.1
	self._pause_flash_time = 0.1
	self._second_flash_time = 0.3
	self._flash_roll = math.rand(360)
	self._flash_dir = Rotation(0, 0, self._flash_roll):y()
	self._flash_anim_time = math.rand(0, 1)
	self._distance = math.rand(1)
	self._intensity_value_white = math.lerp(Vector3(0.5, 0.55, 0.6), Vector3(0.8, 0.85, 0.9), self._distance)
	self._intensity_value_flash = math.lerp(Vector3(0.24, 0.37, 0.62), Vector3(1.57, 1.73, 2), self._distance)
	self._intensity_value = math.lerp(Vector3(1.67, 1.84, 2), Vector3(1.72, 1.90, 2), self._distance)
	self._intensity_value_2 = math.lerp(Vector3(0.34, 0.52, 0.80), Vector3(0.40, 0.60, 0.80), self._distance)

	local c_pos = managers.environment_effects:camera_position()

	if c_pos then
		local sound_speed = 30000

		self._sound_delay = self._distance * 2

		if self._sound_source then
			self._sound_source:set_rtpc("lightning_distance", self._distance * 4000)
		end
	end
end

function LightningEffect:_make_lightning()
	if alive(self._sky_material) then
		self._sky_material:set_variable(Idstring("color2"), self._intensity_value_2)
		self._sky_material:set_variable(Idstring("color0"), self._intensity_value_white) --color0
	end

	Global._global_light:set_color(self._intensity_value_flash)
	Underlay:set_time(Idstring("sun_horizontal"), self._flash_anim_time)

	if self._effect_data.event_name then
		self._sound_source:post_event(self._effect_data.event_name)
	end
end

SnowDropEffect = SnowDropEffect or class(EnvironmentEffect)

function SnowDropEffect:init()
	EnvironmentEffect.init(self)

	self._under_roof = false
	self._slotmask = managers.slot:get_mask("statics")
end

function SnowDropEffect:load_effects()
	if is_editor then
		CoreEngineAccess._editor_load(Idstring("effect"), self._effect_name)
	end
end

function SnowDropEffect:update(t, dt)
	return
end

function SnowDropEffect:start()
	local t = {
		effect = self._effect_name,
		position = Vector3(),
		rotation = Rotation(),
	}

	self._raindrops = World:effect_manager():spawn(t)
end

function SnowDropEffect:stop()
	if self._raindrops then
		World:effect_manager():fade_kill(self._raindrops)

		self._raindrops = nil
	end
end

SnowDropScreenEffect = SnowDropScreenEffect or class(SnowDropEffect)

function SnowDropScreenEffect:init()
	SnowDropEffect.init(self)

	self._effect_name = Idstring("effects/particles/snow/snowflake_screen")
end

CoreClass.override_class(CoreEnvironmentEffectsManager.EnvironmentEffectsManager, EnvironmentEffectsManager)
