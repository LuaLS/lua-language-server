---@meta

---
---The `lovr.audio` module is responsible for playing sound effects and music.  To play a sound, create a `Source` object and call `Source:play` on it.  Currently ogg, wav, and mp3 audio formats are supported.
---
---@class lovr.audio
lovr.audio = {}

---
---Returns the global air absorption coefficients for the medium.  This affects Sources that have the `absorption` effect enabled, causing audio volume to drop off with distance as it is absorbed by the medium it's traveling through (air, water, etc.).  The difference between absorption and falloff is that absorption is more subtle and is frequency-dependent, so higher-frequency bands can get absorbed more quickly than lower ones.  This can be used to apply "underwater" effects and stuff.
---
---@return number low # The absorption coefficient for the low frequency band.
---@return number mid # The absorption coefficient for the mid frequency band.
---@return number high # The absorption coefficient for the high frequency band.
function lovr.audio.getAbsorption() end

---
---Returns a list of playback or capture devices.  Each device has an `id`, `name`, and a `default` flag indicating whether it's the default device.
---
---To use a specific device id for playback or capture, pass it to `lovr.audio.setDevice`.
---
---@param type? lovr.AudioType # The type of devices to query (playback or capture).
---@return {["[].id"]: userdata, ["[].name"]: string, ["[].default"]: boolean} devices # The list of devices.
function lovr.audio.getDevices(type) end

---
---Returns the orientation of the virtual audio listener in angle/axis representation.
---
---@return number angle # The number of radians the listener is rotated around its axis of rotation.
---@return number ax # The x component of the axis of rotation.
---@return number ay # The y component of the axis of rotation.
---@return number az # The z component of the axis of rotation.
function lovr.audio.getOrientation() end

---
---Returns the position and orientation of the virtual audio listener.
---
---@return number x # The x position of the listener, in meters.
---@return number y # The y position of the listener, in meters.
---@return number z # The z position of the listener, in meters.
---@return number angle # The number of radians the listener is rotated around its axis of rotation.
---@return number ax # The x component of the axis of rotation.
---@return number ay # The y component of the axis of rotation.
---@return number az # The z component of the axis of rotation.
function lovr.audio.getPose() end

---
---Returns the position of the virtual audio listener, in meters.
---
---@return number x # The x position of the listener.
---@return number y # The y position of the listener.
---@return number z # The z position of the listener.
function lovr.audio.getPosition() end

---
---Returns the name of the active spatializer (`simple`, `oculus`, or `phonon`).
---
---The `t.audio.spatializer` setting in `lovr.conf` can be used to express a preference for a particular spatializer.  If it's `nil`, all spatializers will be tried in the following order: `phonon`, `oculus`, `simple`.
---
---@return string spatializer # The name of the active spatializer.
function lovr.audio.getSpatializer() end

---
---Returns the master volume.  All audio sent to the playback device has its volume multiplied by this factor.
---
---@param units? lovr.VolumeUnit # The units to return (linear or db).
---@return number volume # The master volume.
function lovr.audio.getVolume(units) end

---
---Returns whether an audio device is started.
---
---@param type? lovr.AudioType # The type of device to check.
---@return boolean started # Whether the device is active.
function lovr.audio.isStarted(type) end

---
---Creates a new Source from an ogg, wav, or mp3 file.
---
---@overload fun(blob: lovr.Blob, options: table):lovr.Source
---@overload fun(sound: lovr.Sound, options: table):lovr.Source
---@param filename string # The filename of the sound to load.
---@param options {decode: boolean, effects: table} # Optional options.
---@return lovr.Source source # The new Source.
function lovr.audio.newSource(filename, options) end

---
---Sets the global air absorption coefficients for the medium.  This affects Sources that have the `absorption` effect enabled, causing audio volume to drop off with distance as it is absorbed by the medium it's traveling through (air, water, etc.).  The difference between absorption and falloff is that absorption is more subtle and is frequency-dependent, so higher-frequency bands can get absorbed more quickly than lower ones.  This can be used to apply "underwater" effects and stuff.
---
---@param low number # The absorption coefficient for the low frequency band.
---@param mid number # The absorption coefficient for the mid frequency band.
---@param high number # The absorption coefficient for the high frequency band.
function lovr.audio.setAbsorption(low, mid, high) end

---
---Switches either the playback or capture device to a new one.
---
---If a device for the given type is already active, it will be stopped and destroyed.  The new device will not be started automatically, use `lovr.audio.start` to start it.
---
---A device id (previously retrieved using `lovr.audio.getDevices`) can be given to use a specific audio device, or `nil` can be used for the id to use the default audio device.
---
---A sink can be also be provided when changing the device.  A sink is an audio stream (`Sound` object with a `stream` type) that will receive all audio samples played (for playback) or all audio samples captured (for capture).  When an audio device with a sink is started, be sure to periodically call `Sound:read` on the sink to read audio samples from it, otherwise it will overflow and discard old data.  The sink can have any format, data will be converted as needed. Using a sink for the playback device will reduce performance, but this isn't the case for capture devices.
---
---Audio devices can be started in `shared` or `exclusive` mode.  Exclusive devices may have lower latency than shared devices, but there's a higher chance that requesting exclusive access to an audio device will fail (either because it isn't supported or allowed).  One strategy is to first try the device in exclusive mode, switching to shared if it doesn't work.
---
---@param type? lovr.AudioType # The device to switch.
---@param id? userdata # The id of the device to use, or `nil` to use the default device.
---@param sink? lovr.Sound # An optional audio stream to use as a sink for the device.
---@param mode? lovr.AudioShareMode # The sharing mode for the device.
---@return boolean success # Whether creating the audio device succeeded.
function lovr.audio.setDevice(type, id, sink, mode) end

---
---Sets a mesh of triangles to use for modeling audio effects, using a table of vertices or a Model.  When the appropriate effects are enabled, audio from `Source` objects will correctly be occluded by walls and bounce around to create realistic reverb.
---
---An optional `AudioMaterial` may be provided to specify the acoustic properties of the geometry.
---
---@overload fun(model: lovr.Model, material: lovr.AudioMaterial):boolean
---@param vertices table # A flat table of vertices.  Each vertex is 3 numbers representing its x, y, and z position. The units used for audio coordinates are up to you, but meters are recommended.
---@param indices table # A list of indices, indicating how the vertices are connected into triangles.  Indices are 1-indexed and are 32 bits (they can be bigger than 65535).
---@param material? lovr.AudioMaterial # The acoustic material to use.
---@return boolean success # Whether audio geometry is supported by the current spatializer and the geometry was loaded successfully.
function lovr.audio.setGeometry(vertices, indices, material) end

---
---Sets the orientation of the virtual audio listener in angle/axis representation.
---
---@param angle number # The number of radians the listener should be rotated around its rotation axis.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
function lovr.audio.setOrientation(angle, ax, ay, az) end

---
---Sets the position and orientation of the virtual audio listener.
---
---@param x number # The x position of the listener, in meters.
---@param y number # The y position of the listener, in meters.
---@param z number # The z position of the listener, in meters.
---@param angle number # The number of radians the listener is rotated around its axis of rotation.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
function lovr.audio.setPose(x, y, z, angle, ax, ay, az) end

---
---Sets the position of the virtual audio listener, in meters.
---
---@param x number # The x position of the listener.
---@param y number # The y position of the listener.
---@param z number # The z position of the listener.
function lovr.audio.setPosition(x, y, z) end

---
---Sets the master volume.  All audio sent to the playback device has its volume multiplied by this factor.
---
---@param volume number # The master volume.
---@param units? lovr.VolumeUnit # The units of the value.
function lovr.audio.setVolume(volume, units) end

---
---Starts the active playback or capture device.  By default the playback device is initialized and started, but this can be controlled using the `t.audio.start` flag in `lovr.conf`.
---
---@param type? lovr.AudioType # The type of device to start.
---@return boolean started # Whether the device was successfully started.
function lovr.audio.start(type) end

---
---Stops the active playback or capture device.  This may fail if:
---
---- The device is not started
---- No device was initialized with `lovr.audio.setDevice`
---
---@param type? lovr.AudioType # The type of device to stop.
---@return boolean stopped # Whether the device was successfully stopped.
function lovr.audio.stop(type) end

---
---A Source is an object representing a single sound.  Currently ogg, wav, and mp3 formats are supported.
---
---When a Source is playing, it will send audio to the speakers.  Sources do not play automatically when they are created.  Instead, the `play`, `pause`, and `stop` functions can be used to control when they should play.
---
---`Source:seek` and `Source:tell` can be used to control the playback position of the Source.  A Source can be set to loop when it reaches the end using `Source:setLooping`.
---
---@class lovr.Source
local Source = {}

---
---Creates a copy of the Source, referencing the same `Sound` object and inheriting all of the settings of this Source.  However, it will be created in the stopped state and will be rewound to the beginning.
---
---@return lovr.Source source # A genetically identical copy of the Source.
function Source:clone() end

---
---Returns the directivity settings for the Source.
---
---The directivity is controlled by two parameters: the weight and the power.
---
---The weight is a number between 0 and 1 controlling the general "shape" of the sound emitted. 0.0 results in a completely omnidirectional sound that can be heard from all directions.  1.0 results in a full dipole shape that can be heard only from the front and back.  0.5 results in a cardioid shape that can only be heard from one direction.  Numbers in between will smoothly transition between these.
---
---The power is a number that controls how "focused" or sharp the shape is.  Lower power values can be heard from a wider set of angles.  It is an exponent, so it can get arbitrarily large.  Note that a power of zero will still result in an omnidirectional source, regardless of the weight.
---
---@return number weight # The dipole weight.  0.0 is omnidirectional, 1.0 is a dipole, 0.5 is cardioid.
---@return number power # The dipole power, controlling how focused the directivity shape is.
function Source:getDirectivity() end

---
---Returns the duration of the Source.
---
---@param unit? lovr.TimeUnit # The unit to return.
---@return number duration # The duration of the Source.
function Source:getDuration(unit) end

---
---Returns the orientation of the Source, in angle/axis representation.
---
---@return number angle # The number of radians the Source is rotated around its axis of rotation.
---@return number ax # The x component of the axis of rotation.
---@return number ay # The y component of the axis of rotation.
---@return number az # The z component of the axis of rotation.
function Source:getOrientation() end

---
---Returns the position and orientation of the Source.
---
---@return number x # The x position of the Source, in meters.
---@return number y # The y position of the Source, in meters.
---@return number z # The z position of the Source, in meters.
---@return number angle # The number of radians the Source is rotated around its axis of rotation.
---@return number ax # The x component of the axis of rotation.
---@return number ay # The y component of the axis of rotation.
---@return number az # The z component of the axis of rotation.
function Source:getPose() end

---
---Returns the position of the Source, in meters.  Setting the position will cause the Source to be distorted and attenuated based on its position relative to the listener.
---
---@return number x # The x coordinate.
---@return number y # The y coordinate.
---@return number z # The z coordinate.
function Source:getPosition() end

---
---Returns the radius of the Source, in meters.
---
---This does not control falloff or attenuation.  It is only used for smoothing out occlusion.  If a Source doesn't have a radius, then when it becomes occluded by a wall its volume will instantly drop.  Giving the Source a radius that approximates its emitter's size will result in a smooth transition between audible and occluded, improving realism.
---
---@return number radius # The radius of the Source, in meters.
function Source:getRadius() end

---
---Returns the `Sound` object backing the Source.  Multiple Sources can share one Sound, allowing its data to only be loaded once.  An easy way to do this sharing is by using `Source:clone`.
---
---@return lovr.Sound sound # The Sound object.
function Source:getSound() end

---
---Returns the current volume factor for the Source.
---
---@param units? lovr.VolumeUnit # The units to return (linear or db).
---@return number volume # The volume of the Source.
function Source:getVolume(units) end

---
---Returns whether a given `Effect` is enabled for the Source.
---
---@param effect lovr.Effect # The effect.
---@return boolean enabled # Whether the effect is enabled.
function Source:isEffectEnabled(effect) end

---
---Returns whether or not the Source will loop when it finishes.
---
---@return boolean looping # Whether or not the Source is looping.
function Source:isLooping() end

---
---Returns whether or not the Source is playing.
---
---@return boolean playing # Whether the Source is playing.
function Source:isPlaying() end

---
---Pauses the source.  It can be resumed with `Source:resume` or `Source:play`. If a paused source is rewound, it will remain paused.
---
function Source:pause() end

---
---Plays the Source.  This doesn't do anything if the Source is already playing.
---
---@return boolean success # Whether the Source successfully started playing.
function Source:play() end

---
---Seeks the Source to the specified position.
---
---@param position number # The position to seek to.
---@param unit? lovr.TimeUnit # The units for the seek position.
function Source:seek(position, unit) end

---
---Sets the directivity settings for the Source.
---
---The directivity is controlled by two parameters: the weight and the power.
---
---The weight is a number between 0 and 1 controlling the general "shape" of the sound emitted. 0.0 results in a completely omnidirectional sound that can be heard from all directions.  1.0 results in a full dipole shape that can be heard only from the front and back.  0.5 results in a cardioid shape that can only be heard from one direction.  Numbers in between will smoothly transition between these.
---
---The power is a number that controls how "focused" or sharp the shape is.  Lower power values can be heard from a wider set of angles.  It is an exponent, so it can get arbitrarily large.  Note that a power of zero will still result in an omnidirectional source, regardless of the weight.
---
---@param weight number # The dipole weight.  0.0 is omnidirectional, 1.0 is a dipole, 0.5 is cardioid.
---@param power number # The dipole power, controlling how focused the directivity shape is.
function Source:setDirectivity(weight, power) end

---
---Enables or disables an effect on the Source.
---
---@param effect lovr.Effect # The effect.
---@param enable boolean # Whether the effect should be enabled.
function Source:setEffectEnabled(effect, enable) end

---
---Sets whether or not the Source loops.
---
---@param loop boolean # Whether or not the Source will loop.
function Source:setLooping(loop) end

---
---Sets the orientation of the Source in angle/axis representation.
---
---@param angle number # The number of radians the Source should be rotated around its rotation axis.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
function Source:setOrientation(angle, ax, ay, az) end

---
---Sets the position and orientation of the Source.
---
---@param x number # The x position of the Source, in meters.
---@param y number # The y position of the Source, in meters.
---@param z number # The z position of the Source, in meters.
---@param angle number # The number of radians the Source is rotated around its axis of rotation.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
function Source:setPose(x, y, z, angle, ax, ay, az) end

---
---Sets the position of the Source, in meters.  Setting the position will cause the Source to be distorted and attenuated based on its position relative to the listener.
---
---Only mono sources can be positioned.  Setting the position of a stereo Source will cause an error.
---
---@param x number # The x coordinate.
---@param y number # The y coordinate.
---@param z number # The z coordinate.
function Source:setPosition(x, y, z) end

---
---Sets the radius of the Source, in meters.
---
---This does not control falloff or attenuation.  It is only used for smoothing out occlusion.  If a Source doesn't have a radius, then when it becomes occluded by a wall its volume will instantly drop.  Giving the Source a radius that approximates its emitter's size will result in a smooth transition between audible and occluded, improving realism.
---
---@param radius number # The new radius of the Source, in meters.
function Source:setRadius(radius) end

---
---Sets the current volume factor for the Source.
---
---@param volume number # The new volume.
---@param units? lovr.VolumeUnit # The units of the value.
function Source:setVolume(volume, units) end

---
---Stops the source, also rewinding it to the beginning.
---
function Source:stop() end

---
---Returns the current playback position of the Source.
---
---@param unit? lovr.TimeUnit # The unit to return.
---@return number position # The current playback position.
function Source:tell(unit) end

---
---Different types of audio material presets, for use with `lovr.audio.setGeometry`.
---
---@class lovr.AudioMaterial
---
---Generic default audio material.
---
---@field generic integer
---
---Brick.
---
---@field brick integer
---
---Carpet.
---
---@field carpet integer
---
---Ceramic.
---
---@field ceramic integer
---
---Concrete.
---
---@field concrete integer
---@field glass integer
---@field gravel integer
---@field metal integer
---@field plaster integer
---@field rock integer
---@field wood integer

---
---Audio devices can be created in shared mode or exclusive mode.  In exclusive mode, the audio device is the only one active on the system, which gives better performance and lower latency. However, exclusive devices aren't always supported and might not be allowed, so there is a higher chance that creating one will fail.
---
---@class lovr.AudioShareMode
---
---Shared mode.
---
---@field shared integer
---
---Exclusive mode.
---
---@field exclusive integer

---
---When referencing audio devices, this indicates whether it's the playback or capture device.
---
---@class lovr.AudioType
---
---The playback device (speakers, headphones).
---
---@field playback integer
---
---The capture device (microphone).
---
---@field capture integer

---
---Different types of effects that can be applied with `Source:setEffectEnabled`.
---
---@class lovr.Effect
---
---Models absorption as sound travels through the air, water, etc.
---
---@field absorption integer
---
---Decreases audio volume with distance (1 / max(distance, 1)).
---
---@field falloff integer
---
---Causes audio to drop off when the Source is occluded by geometry.
---
---@field occlusion integer
---
---Models reverb caused by audio bouncing off of geometry.
---
---@field reverb integer
---
---Spatializes the Source using either simple panning or an HRTF.
---
---@field spatialization integer
---
---Causes audio to be heard through walls when occluded, based on audio materials.
---
---@field transmission integer

---
---When figuring out how long a Source is or seeking to a specific position in the sound file, units can be expressed in terms of seconds or in terms of frames.  A frame is one set of samples for each channel (one sample for mono, two samples for stereo).
---
---@class lovr.TimeUnit
---
---Seconds.
---
---@field seconds integer
---
---Frames.
---
---@field frames integer

---
---When accessing the volume of Sources or the audio listener, this can be done in linear units with a 0 to 1 range, or in decibels with a range of -∞ to 0.
---
---@class lovr.VolumeUnit
---
---Linear volume range.
---
---@field linear integer
---
---Decibels.
---
---@field db integer
