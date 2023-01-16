---@meta

---
---The `lovr.audio` module is responsible for playing sound effects and music.
---
---To play a sound, create a `Source` object and call `Source:play` on it.
---
---Currently ogg, wav, and mp3 audio formats are supported.
---
---@class lovr.audio
lovr.audio = {}

---
---Returns the global air absorption coefficients for the medium.
---
---This affects Sources that have the `absorption` effect enabled, causing audio volume to drop off with distance as it is absorbed by the medium it's traveling through (air, water, etc.).
---
---The difference between absorption and the attenuation effect is that absorption is more subtle and is frequency-dependent, so higher-frequency bands can get absorbed more quickly than lower ones. This can be used to apply "underwater" effects and stuff.
---
---
---### NOTE:
---Absorption is currently only supported by the phonon spatializer.
---
---The frequency bands correspond to `400Hz`, `2.5KHz`, and `15KHz`.
---
---The default coefficients are `.0002`, `.0017`, and `.0182` for low, mid, and high.
---
---@return number low # The absorption coefficient for the low frequency band.
---@return number mid # The absorption coefficient for the mid frequency band.
---@return number high # The absorption coefficient for the high frequency band.
function lovr.audio.getAbsorption() end

---
---Returns a list of playback or capture devices.
---
---Each device has an `id`, `name`, and a `default` flag indicating whether it's the default device.
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
---Returns the sample rate used by the playback device.
---
---This can be changed using `lovr.conf`.
---
---@return number rate # The sample rate of the playback device, in Hz.
function lovr.audio.getSampleRate() end

---
---Returns the name of the active spatializer (`simple`, `oculus`, or `phonon`).
---
---The `t.audio.spatializer` setting in `lovr.conf` can be used to express a preference for a particular spatializer.
---
---If it's `nil`, all spatializers will be tried in the following order: `phonon`, `oculus`, `simple`.
---
---
---### NOTE:
---Using a feature or effect that is not supported by the current spatializer will not error, it just won't do anything.
---
---<table>
---  <thead>
---    <tr>
---      <td>Feature</td>
---      <td>simple</td>
---      <td>phonon</td>
---      <td>oculus</td>
---    </tr>
---  </thead>
---  <tbody>
---    <tr>
---      <td>Effect: Spatialization</td>
---      <td>x</td>
---      <td>x</td>
---      <td>x</td>
---    </tr>
---    <tr>
---      <td>Effect: Attenuation</td>
---      <td>x</td>
---      <td>x</td>
---      <td>x</td>
---    </tr>
---    <tr>
---      <td>Effect: Absorption</td>
---      <td></td>
---      <td>x</td>
---      <td></td>
---    </tr>
---    <tr>
---      <td>Effect: Occlusion</td>
---      <td></td>
---      <td>x</td>
---      <td></td>
---    </tr>
---    <tr>
---      <td>Effect: Transmission</td>
---      <td></td>
---      <td>x</td>
---      <td></td>
---    </tr>
---    <tr>
---      <td>Effect: Reverb</td>
---      <td></td>
---      <td>x</td>
---      <td></td>
---    </tr>
---    <tr>
---      <td>lovr.audio.setGeometry</td>
---      <td></td>
---      <td>x</td>
---      <td></td>
---    </tr>
---    <tr>
---      <td>Source:setDirectivity</td>
---      <td>x</td>
---      <td>x</td>
---      <td></td>
---    </tr>
---    <tr>
---      <td>Source:setRadius</td>
---      <td></td>
---      <td>x</td>
---      <td></td>
---    </tr>
---  </tbody> </table>
---
---@return string spatializer # The name of the active spatializer.
function lovr.audio.getSpatializer() end

---
---Returns the master volume.
---
---All audio sent to the playback device has its volume multiplied by this factor.
---
---
---### NOTE:
---The default volume is 1.0 (0 dB).
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
---@overload fun(blob: lovr.Blob, options?: table):lovr.Source
---@overload fun(sound: lovr.Sound, options?: table):lovr.Source
---@param filename string # The filename of the sound to load.
---@param options? {decode: boolean, pitchable: boolean, spatial: boolean, effects: table} # Optional options.
---@return lovr.Source source # The new Source.
function lovr.audio.newSource(filename, options) end

---
---Sets the global air absorption coefficients for the medium.
---
---This affects Sources that have the `absorption` effect enabled, causing audio volume to drop off with distance as it is absorbed by the medium it's traveling through (air, water, etc.).
---
---The difference between absorption and the attenuation effect is that absorption is more subtle and is frequency-dependent, so higher-frequency bands can get absorbed more quickly than lower ones.
---
---This can be used to apply "underwater" effects and stuff.
---
---
---### NOTE:
---Absorption is currently only supported by the phonon spatializer.
---
---The frequency bands correspond to `400Hz`, `2.5KHz`, and `15KHz`.
---
---The default coefficients are `.0002`, `.0017`, and `.0182` for low, mid, and high.
---
---@param low number # The absorption coefficient for the low frequency band.
---@param mid number # The absorption coefficient for the mid frequency band.
---@param high number # The absorption coefficient for the high frequency band.
function lovr.audio.setAbsorption(low, mid, high) end

---
---Switches either the playback or capture device to a new one.
---
---If a device for the given type is already active, it will be stopped and destroyed.
---
---The new device will not be started automatically, use `lovr.audio.start` to start it.
---
---A device id (previously retrieved using `lovr.audio.getDevices`) can be given to use a specific audio device, or `nil` can be used for the id to use the default audio device.
---
---A sink can be also be provided when changing the device.
---
---A sink is an audio stream (`Sound` object with a `stream` type) that will receive all audio samples played (for playback) or all audio samples captured (for capture).
---
---When an audio device with a sink is started, be sure to periodically call `Sound:read` on the sink to read audio samples from it, otherwise it will overflow and discard old data.
---
---The sink can have any format, data will be converted as needed. Using a sink for the playback device will reduce performance, but this isn't the case for capture devices.
---
---Audio devices can be started in `shared` or `exclusive` mode.
---
---Exclusive devices may have lower latency than shared devices, but there's a higher chance that requesting exclusive access to an audio device will fail (either because it isn't supported or allowed).
---
---One strategy is to first try the device in exclusive mode, switching to shared if it doesn't work.
---
---@param type? lovr.AudioType # The device to switch.
---@param id? userdata # The id of the device to use, or `nil` to use the default device.
---@param sink? lovr.Sound # An optional audio stream to use as a sink for the device.
---@param mode? lovr.AudioShareMode # The sharing mode for the device.
---@return boolean success # Whether creating the audio device succeeded.
function lovr.audio.setDevice(type, id, sink, mode) end

---
---Sets a mesh of triangles to use for modeling audio effects, using a table of vertices or a Model.
---
---When the appropriate effects are enabled, audio from `Source` objects will correctly be occluded by walls and bounce around to create realistic reverb.
---
---An optional `AudioMaterial` may be provided to specify the acoustic properties of the geometry.
---
---
---### NOTE:
---This is currently only supported/used by the `phonon` spatializer.
---
---The `Effect`s that use geometry are:
---
---- `occlusion`
---- `reverb`
---- `transmission`
---
---If an existing geometry has been set, this function will replace it.
---
---The triangles must use counterclockwise winding.
---
---@overload fun(model: lovr.Model, material?: lovr.AudioMaterial):boolean
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
---Sets the master volume.
---
---All audio sent to the playback device has its volume multiplied by this factor.
---
---
---### NOTE:
---The volume will be clamped to a 0-1 range (0 dB).
---
---@param volume number # The master volume.
---@param units? lovr.VolumeUnit # The units of the value.
function lovr.audio.setVolume(volume, units) end

---
---Starts the active playback or capture device.
---
---By default the playback device is initialized and started, but this can be controlled using the `t.audio.start` flag in `lovr.conf`.
---
---
---### NOTE:
---Starting an audio device may fail if:
---
---- The device is already started
---- No device was initialized with `lovr.audio.setDevice`
---- Lack of `audiocapture` permission on Android (see `lovr.system.requestPermission`)
---- Some other problem accessing the audio device
---
---@param type? lovr.AudioType # The type of device to start.
---@return boolean started # Whether the device was successfully started.
function lovr.audio.start(type) end

---
---Stops the active playback or capture device.
---
---This may fail if:
---
---- The device is not started
---- No device was initialized with `lovr.audio.setDevice`
---
---
---### NOTE:
---Switching devices with `lovr.audio.setDevice` will stop the existing one.
---
---@param type? lovr.AudioType # The type of device to stop.
---@return boolean stopped # Whether the device was successfully stopped.
function lovr.audio.stop(type) end

---
---A Source is an object representing a single sound.
---
---Currently ogg, wav, and mp3 formats are supported.
---
---When a Source is playing, it will send audio to the speakers.
---
---Sources do not play automatically when they are created.
---
---Instead, the `play`, `pause`, and `stop` functions can be used to control when they should play.
---
---`Source:seek` and `Source:tell` can be used to control the playback position of the Source.
---
---A Source can be set to loop when it reaches the end using `Source:setLooping`.
---
---@class lovr.Source
local Source = {}

---
---Creates a copy of the Source, referencing the same `Sound` object and inheriting all of the settings of this Source.
---
---However, it will be created in the stopped state and will be rewound to the beginning.
---
---
---### NOTE:
---This is a good way to create multiple Sources that play the same sound, since the audio data won't be loaded multiple times and can just be reused.
---
---You can also create multiple `Source` objects and pass in the same `Sound` object for each one, which will have the same effect.
---
---@return lovr.Source source # A genetically identical copy of the Source.
function Source:clone() end

---
---Returns the directivity settings for the Source.
---
---The directivity is controlled by two parameters: the weight and the power.
---
---The weight is a number between 0 and 1 controlling the general "shape" of the sound emitted. 0.0 results in a completely omnidirectional sound that can be heard from all directions.
---
---1.0 results in a full dipole shape that can be heard only from the front and back.
---
---0.5 results in a cardioid shape that can only be heard from one direction.
---
---Numbers in between will smoothly transition between these.
---
---The power is a number that controls how "focused" or sharp the shape is.
---
---Lower power values can be heard from a wider set of angles.
---
---It is an exponent, so it can get arbitrarily large.
---
---Note that a power of zero will still result in an omnidirectional source, regardless of the weight.
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
---Returns the pitch of the Source.
---
---
---### NOTE:
---The default pitch is 1.
---
---Every doubling/halving of the pitch will raise/lower the pitch by one octave.
---
---Changing the pitch also changes the playback speed.
---
---@return number pitch # The pitch.
function Source:getPitch() end

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
---Returns the position of the Source, in meters.
---
---Setting the position will cause the Source to be distorted and attenuated based on its position relative to the listener.
---
---@return number x # The x coordinate.
---@return number y # The y coordinate.
---@return number z # The z coordinate.
function Source:getPosition() end

---
---Returns the radius of the Source, in meters.
---
---This does not control falloff or attenuation.
---
---It is only used for smoothing out occlusion.
---
---If a Source doesn't have a radius, then when it becomes occluded by a wall its volume will instantly drop.
---
---Giving the Source a radius that approximates its emitter's size will result in a smooth transition between audible and occluded, improving realism.
---
---@return number radius # The radius of the Source, in meters.
function Source:getRadius() end

---
---Returns the `Sound` object backing the Source.
---
---Multiple Sources can share one Sound, allowing its data to only be loaded once.
---
---An easy way to do this sharing is by using `Source:clone`.
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
---
---### NOTE:
---The active spatializer will determine which effects are supported.
---
---If an unsupported effect is enabled on a Source, no error will be reported.
---
---Instead, it will be silently ignored.
---
---See `lovr.audio.getSpatializer` for a table showing the effects supported by each spatializer.
---
---Calling this function on a non-spatial Source will always return false.
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
---Returns whether the Source was created with the `spatial` flag.
---
---Non-spatial sources are routed directly to the speakers and can not use effects.
---
---@return boolean spatial # Whether the source is spatial.
function Source:isSpatial() end

---
---Pauses the source.
---
---It can be resumed with `Source:resume` or `Source:play`. If a paused source is rewound, it will remain paused.
---
function Source:pause() end

---
---Plays the Source.
---
---This doesn't do anything if the Source is already playing.
---
---
---### NOTE:
---There is a maximum of 64 Sources that can be playing at once.
---
---If 64 Sources are already playing, this function will return `false`.
---
---@return boolean success # Whether the Source successfully started playing.
function Source:play() end

---
---Seeks the Source to the specified position.
---
---
---### NOTE:
---Seeking a Source backed by a stream `Sound` has no meaningful effect.
---
---@param position number # The position to seek to.
---@param unit? lovr.TimeUnit # The units for the seek position.
function Source:seek(position, unit) end

---
---Sets the directivity settings for the Source.
---
---The directivity is controlled by two parameters: the weight and the power.
---
---The weight is a number between 0 and 1 controlling the general "shape" of the sound emitted. 0.0 results in a completely omnidirectional sound that can be heard from all directions.
---
---1.0 results in a full dipole shape that can be heard only from the front and back.
---
---0.5 results in a cardioid shape that can only be heard from one direction.
---
---Numbers in between will smoothly transition between these.
---
---The power is a number that controls how "focused" or sharp the shape is.
---
---Lower power values can be heard from a wider set of angles.
---
---It is an exponent, so it can get arbitrarily large.
---
---Note that a power of zero will still result in an omnidirectional source, regardless of the weight.
---
---@param weight number # The dipole weight.  0.0 is omnidirectional, 1.0 is a dipole, 0.5 is cardioid.
---@param power number # The dipole power, controlling how focused the directivity shape is.
function Source:setDirectivity(weight, power) end

---
---Enables or disables an effect on the Source.
---
---
---### NOTE:
---The active spatializer will determine which effects are supported.
---
---If an unsupported effect is enabled on a Source, no error will be reported.
---
---Instead, it will be silently ignored.
---
---See `lovr.audio.getSpatializer` for a table showing the effects supported by each spatializer.
---
---Calling this function on a non-spatial Source will throw an error.
---
---@param effect lovr.Effect # The effect.
---@param enable boolean # Whether the effect should be enabled.
function Source:setEffectEnabled(effect, enable) end

---
---Sets whether or not the Source loops.
---
---
---### NOTE:
---Attempting to loop a Source backed by a stream `Sound` will cause an error.
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
---Sets the pitch of the Source.
---
---
---### NOTE:
---The default pitch is 1.
---
---Every doubling/halving of the pitch will raise/lower the pitch by one octave.
---
---Changing the pitch also changes the playback speed.
---
---@param pitch number # The new pitch.
function Source:setPitch(pitch) end

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
---Sets the position of the Source, in meters.
---
---Setting the position will cause the Source to be distorted and attenuated based on its position relative to the listener.
---
---Only mono sources can be positioned.
---
---Setting the position of a stereo Source will cause an error.
---
---@param x number # The x coordinate.
---@param y number # The y coordinate.
---@param z number # The z coordinate.
function Source:setPosition(x, y, z) end

---
---Sets the radius of the Source, in meters.
---
---This does not control falloff or attenuation.
---
---It is only used for smoothing out occlusion.
---
---If a Source doesn't have a radius, then when it becomes occluded by a wall its volume will instantly drop.
---
---Giving the Source a radius that approximates its emitter's size will result in a smooth transition between audible and occluded, improving realism.
---
---@param radius number # The new radius of the Source, in meters.
function Source:setRadius(radius) end

---
---Sets the current volume factor for the Source.
---
---
---### NOTE:
---The volume will be clamped to a 0-1 range (0 dB).
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
---
---### NOTE:
---The return value for Sources backed by a stream `Sound` has no meaning.
---
---@param unit? lovr.TimeUnit # The unit to return.
---@return number position # The current playback position.
function Source:tell(unit) end

---
---Different types of audio material presets, for use with `lovr.audio.setGeometry`.
---
---@alias lovr.AudioMaterial
---
---Generic default audio material.
---
---| "generic"
---
---Brick.
---
---| "brick"
---
---Carpet.
---
---| "carpet"
---
---Ceramic.
---
---| "ceramic"
---
---Concrete.
---
---| "concrete"
---
---Glass.
---
---| "glass"
---
---Gravel.
---
---| "gravel"
---
---Metal.
---
---| "metal"
---
---Plaster.
---
---| "plaster"
---
---Rock.
---
---| "rock"
---
---Wood.
---
---| "wood"

---
---Audio devices can be created in shared mode or exclusive mode.
---
---In exclusive mode, the audio device is the only one active on the system, which gives better performance and lower latency. However, exclusive devices aren't always supported and might not be allowed, so there is a higher chance that creating one will fail.
---
---@alias lovr.AudioShareMode
---
---Shared mode.
---
---| "shared"
---
---Exclusive mode.
---
---| "exclusive"

---
---When referencing audio devices, this indicates whether it's the playback or capture device.
---
---@alias lovr.AudioType
---
---The playback device (speakers, headphones).
---
---| "playback"
---
---The capture device (microphone).
---
---| "capture"

---
---Different types of effects that can be applied with `Source:setEffectEnabled`.
---
---
---### NOTE:
---The active spatializer will determine which effects are supported.
---
---If an unsupported effect is enabled on a Source, no error will be reported.
---
---Instead, it will be silently ignored.
---
---See `lovr.audio.getSpatializer` for a table of the supported effects for each spatializer.
---
---@alias lovr.Effect
---
---Models absorption as sound travels through the air, water, etc.
---
---| "absorption"
---
---Decreases audio volume with distance (1 / max(distance, 1)).
---
---| "attenuation"
---
---Causes audio to drop off when the Source is occluded by geometry.
---
---| "occlusion"
---
---Models reverb caused by audio bouncing off of geometry.
---
---| "reverb"
---
---Spatializes the Source using either simple panning or an HRTF.
---
---| "spatialization"
---
---Causes audio to be heard through walls when occluded, based on audio materials.
---
---| "transmission"

---
---When figuring out how long a Source is or seeking to a specific position in the sound file, units can be expressed in terms of seconds or in terms of frames.
---
---A frame is one set of samples for each channel (one sample for mono, two samples for stereo).
---
---@alias lovr.TimeUnit
---
---Seconds.
---
---| "seconds"
---
---Frames.
---
---| "frames"

---
---When accessing the volume of Sources or the audio listener, this can be done in linear units with a 0 to 1 range, or in decibels with a range of -∞ to 0.
---
---@alias lovr.VolumeUnit
---
---Linear volume range.
---
---| "linear"
---
---Decibels.
---
---| "db"
