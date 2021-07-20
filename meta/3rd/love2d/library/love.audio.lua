---@class love.audio
love.audio = {}

---
---Gets a list of the names of the currently enabled effects.
---
---@return table effects # The list of the names of the currently enabled effects.
function love.audio.getActiveEffects() end

---
---Gets the current number of simultaneously playing sources.
---
---@return number count # The current number of simultaneously playing sources.
function love.audio.getActiveSourceCount() end

---
---Returns the distance attenuation model.
---
---@return DistanceModel model # The current distance model. The default is 'inverseclamped'.
function love.audio.getDistanceModel() end

---
---Gets the current global scale factor for velocity-based doppler effects.
---
---@return number scale # The current doppler scale factor.
function love.audio.getDopplerScale() end

---
---Gets the settings associated with an effect.
---
---@param name string # The name of the effect.
---@return table settings # The settings associated with the effect.
function love.audio.getEffect(name) end

---
---Gets the maximum number of active effects supported by the system.
---
---@return number maximum # The maximum number of active effects.
function love.audio.getMaxSceneEffects() end

---
---Gets the maximum number of active Effects in a single Source object, that the system can support.
---
---@return number maximum # The maximum number of active Effects per Source.
function love.audio.getMaxSourceEffects() end

---
---Returns the orientation of the listener.
---
---@return number fx, fy, fz # Forward vector of the listener orientation.
---@return number ux, uy, uz # Up vector of the listener orientation.
function love.audio.getOrientation() end

---
---Returns the position of the listener. Please note that positional audio only works for mono (i.e. non-stereo) sources.
---
---@return number x # The X position of the listener.
---@return number y # The Y position of the listener.
---@return number z # The Z position of the listener.
function love.audio.getPosition() end

---
---Gets a list of RecordingDevices on the system.
---
---The first device in the list is the user's default recording device. The list may be empty if there are no microphones connected to the system.
---
---Audio recording is currently not supported on iOS.
---
---@return table devices # The list of connected recording devices.
function love.audio.getRecordingDevices() end

---
---Gets the current number of simultaneously playing sources.
---
---@return number numSources # The current number of simultaneously playing sources.
function love.audio.getSourceCount() end

---
---Returns the velocity of the listener.
---
---@return number x # The X velocity of the listener.
---@return number y # The Y velocity of the listener.
---@return number z # The Z velocity of the listener.
function love.audio.getVelocity() end

---
---Returns the master volume.
---
---@return number volume # The current master volume
function love.audio.getVolume() end

---
---Gets whether audio effects are supported in the system.
---
---@return boolean supported # True if effects are supported, false otherwise.
function love.audio.isEffectsSupported() end

---
---Creates a new Source usable for real-time generated sound playback with Source:queue.
---
---@param samplerate number # Number of samples per second when playing.
---@param bitdepth number # Bits per sample (8 or 16).
---@param channels number # 1 for mono or 2 for stereo.
---@param buffercount number # The number of buffers that can be queued up at any given time with Source:queue. Cannot be greater than 64. A sensible default (~8) is chosen if no value is specified.
---@return Source source # The new Source usable with Source:queue.
function love.audio.newQueueableSource(samplerate, bitdepth, channels, buffercount) end

---
---Creates a new Source from a filepath, File, Decoder or SoundData.
---
---Sources created from SoundData are always static.
---
---@param filename string # The filepath to the audio file.
---@param type SourceType # Streaming or static source.
---@return Source source # A new Source that can play the specified audio.
function love.audio.newSource(filename, type) end

---
---Pauses specific or all currently played Sources.
---
---@return table Sources # A table containing a list of Sources that were paused by this call.
function love.audio.pause() end

---
---Plays the specified Source.
---
---@param source Source # The Source to play.
function love.audio.play(source) end

---
---Sets the distance attenuation model.
---
---@param model DistanceModel # The new distance model.
function love.audio.setDistanceModel(model) end

---
---Sets a global scale factor for velocity-based doppler effects. The default scale value is 1.
---
---@param scale number # The new doppler scale factor. The scale must be greater than 0.
function love.audio.setDopplerScale(scale) end

---
---Defines an effect that can be applied to a Source.
---
---Not all system supports audio effects. Use love.audio.isEffectsSupported to check.
---
---@param name string # The name of the effect.
---@param settings table # The settings to use for this effect, with the following fields:
---@return boolean success # Whether the effect was successfully created.
function love.audio.setEffect(name, settings) end

---
---Sets whether the system should mix the audio with the system's audio.
---
---@param mix boolean # True to enable mixing, false to disable it.
---@return boolean success # True if the change succeeded, false otherwise.
function love.audio.setMixWithSystem(mix) end

---
---Sets the orientation of the listener.
---
---@param fx, fy, fz number # Forward vector of the listener orientation.
---@param ux, uy, uz number # Up vector of the listener orientation.
function love.audio.setOrientation(fx, fy, fz, ux, uy, uz) end

---
---Sets the position of the listener, which determines how sounds play.
---
---@param x number # The x position of the listener.
---@param y number # The y position of the listener.
---@param z number # The z position of the listener.
function love.audio.setPosition(x, y, z) end

---
---Sets the velocity of the listener.
---
---@param x number # The X velocity of the listener.
---@param y number # The Y velocity of the listener.
---@param z number # The Z velocity of the listener.
function love.audio.setVelocity(x, y, z) end

---
---Sets the master volume.
---
---@param volume number # 1.0 is max and 0.0 is off.
function love.audio.setVolume(volume) end

---
---Stops currently played sources.
---
function love.audio.stop() end
