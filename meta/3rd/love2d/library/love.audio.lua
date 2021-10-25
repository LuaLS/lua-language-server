---@meta

---
---Provides an interface to create noise with the user's speakers.
---
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
---@return love.DistanceModel model # The current distance model. The default is 'inverseclamped'.
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
---@return number fx # Forward vector of the listener orientation.
---@return number fy # Forward vector of the listener orientation.
---@return number fz # Forward vector of the listener orientation.
---@return number ux # Up vector of the listener orientation.
---@return number uy # Up vector of the listener orientation.
---@return number uz # Up vector of the listener orientation.
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
---@param buffercount? number # The number of buffers that can be queued up at any given time with Source:queue. Cannot be greater than 64. A sensible default (~8) is chosen if no value is specified.
---@return love.Source source # The new Source usable with Source:queue.
function love.audio.newQueueableSource(samplerate, bitdepth, channels, buffercount) end

---
---Creates a new Source from a filepath, File, Decoder or SoundData.
---
---Sources created from SoundData are always static.
---
---@overload fun(file: love.File, type: love.SourceType):love.Source
---@overload fun(decoder: love.Decoder, type: love.SourceType):love.Source
---@overload fun(data: love.FileData, type: love.SourceType):love.Source
---@overload fun(data: love.SoundData):love.Source
---@param filename string # The filepath to the audio file.
---@param type love.SourceType # Streaming or static source.
---@return love.Source source # A new Source that can play the specified audio.
function love.audio.newSource(filename, type) end

---
---Pauses specific or all currently played Sources.
---
---@overload fun(source: love.Source, ...)
---@overload fun(sources: table)
---@return table Sources # A table containing a list of Sources that were paused by this call.
function love.audio.pause() end

---
---Plays the specified Source.
---
---@overload fun(sources: table)
---@overload fun(source1: love.Source, source2: love.Source, ...)
---@param source love.Source # The Source to play.
function love.audio.play(source) end

---
---Sets the distance attenuation model.
---
---@param model love.DistanceModel # The new distance model.
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
---@overload fun(name: string, enabled: boolean):boolean
---@param name string # The name of the effect.
---@param settings {type: love.EffectType, volume: number} # The settings to use for this effect, with the following fields:
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
---@param fx number # Forward vector of the listener orientation.
---@param fy number # Forward vector of the listener orientation.
---@param fz number # Forward vector of the listener orientation.
---@param ux number # Up vector of the listener orientation.
---@param uy number # Up vector of the listener orientation.
---@param uz number # Up vector of the listener orientation.
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
---@overload fun(source: love.Source)
---@overload fun(source1: love.Source, source2: love.Source, ...)
---@overload fun(sources: table)
function love.audio.stop() end

---
---Represents an audio input device capable of recording sounds.
---
---@class love.RecordingDevice: love.Object
local RecordingDevice = {}

---
---Gets the number of bits per sample in the data currently being recorded.
---
---@return number bits # The number of bits per sample in the data that's currently being recorded.
function RecordingDevice:getBitDepth() end

---
---Gets the number of channels currently being recorded (mono or stereo).
---
---@return number channels # The number of channels being recorded (1 for mono, 2 for stereo).
function RecordingDevice:getChannelCount() end

---
---Gets all recorded audio SoundData stored in the device's internal ring buffer.
---
---The internal ring buffer is cleared when this function is called, so calling it again will only get audio recorded after the previous call. If the device's internal ring buffer completely fills up before getData is called, the oldest data that doesn't fit into the buffer will be lost.
---
---@return love.SoundData data # The recorded audio data, or nil if the device isn't recording.
function RecordingDevice:getData() end

---
---Gets the name of the recording device.
---
---@return string name # The name of the device.
function RecordingDevice:getName() end

---
---Gets the number of currently recorded samples.
---
---@return number samples # The number of samples that have been recorded so far.
function RecordingDevice:getSampleCount() end

---
---Gets the number of samples per second currently being recorded.
---
---@return number rate # The number of samples being recorded per second (sample rate).
function RecordingDevice:getSampleRate() end

---
---Gets whether the device is currently recording.
---
---@return boolean recording # True if the recording, false otherwise.
function RecordingDevice:isRecording() end

---
---Begins recording audio using this device.
---
---@param samplecount number # The maximum number of samples to store in an internal ring buffer when recording. RecordingDevice:getData clears the internal buffer when called.
---@param samplerate? number # The number of samples per second to store when recording.
---@param bitdepth? number # The number of bits per sample.
---@param channels? number # Whether to record in mono or stereo. Most microphones don't support more than 1 channel.
---@return boolean success # True if the device successfully began recording using the specified parameters, false if not.
function RecordingDevice:start(samplecount, samplerate, bitdepth, channels) end

---
---Stops recording audio from this device. Any sound data currently in the device's buffer will be returned.
---
---@return love.SoundData data # The sound data currently in the device's buffer, or nil if the device wasn't recording.
function RecordingDevice:stop() end

---
---A Source represents audio you can play back.
---
---You can do interesting things with Sources, like set the volume, pitch, and its position relative to the listener. Please note that positional audio only works for mono (i.e. non-stereo) sources.
---
---The Source controls (play/pause/stop) act according to the following state table.
---
---@class love.Source: love.Object
local Source = {}

---
---Creates an identical copy of the Source in the stopped state.
---
---Static Sources will use significantly less memory and take much less time to be created if Source:clone is used to create them instead of love.audio.newSource, so this method should be preferred when making multiple Sources which play the same sound.
---
---@return love.Source source # The new identical copy of this Source.
function Source:clone() end

---
---Gets a list of the Source's active effect names.
---
---@return table effects # A list of the source's active effect names.
function Source:getActiveEffects() end

---
---Gets the amount of air absorption applied to the Source.
---
---By default the value is set to 0 which means that air absorption effects are disabled. A value of 1 will apply high frequency attenuation to the Source at a rate of 0.05 dB per meter.
---
---@return number amount # The amount of air absorption applied to the Source.
function Source:getAirAbsorption() end

---
---Gets the reference and maximum attenuation distances of the Source. The values, combined with the current DistanceModel, affect how the Source's volume attenuates based on distance from the listener.
---
---@return number ref # The current reference attenuation distance. If the current DistanceModel is clamped, this is the minimum distance before the Source is no longer attenuated.
---@return number max # The current maximum attenuation distance.
function Source:getAttenuationDistances() end

---
---Gets the number of channels in the Source. Only 1-channel (mono) Sources can use directional and positional effects.
---
---@return number channels # 1 for mono, 2 for stereo.
function Source:getChannelCount() end

---
---Gets the Source's directional volume cones. Together with Source:setDirection, the cone angles allow for the Source's volume to vary depending on its direction.
---
---@return number innerAngle # The inner angle from the Source's direction, in radians. The Source will play at normal volume if the listener is inside the cone defined by this angle.
---@return number outerAngle # The outer angle from the Source's direction, in radians. The Source will play at a volume between the normal and outer volumes, if the listener is in between the cones defined by the inner and outer angles.
---@return number outerVolume # The Source's volume when the listener is outside both the inner and outer cone angles.
function Source:getCone() end

---
---Gets the direction of the Source.
---
---@return number x # The X part of the direction vector.
---@return number y # The Y part of the direction vector.
---@return number z # The Z part of the direction vector.
function Source:getDirection() end

---
---Gets the duration of the Source. For streaming Sources it may not always be sample-accurate, and may return -1 if the duration cannot be determined at all.
---
---@param unit? love.TimeUnit # The time unit for the return value.
---@return number duration # The duration of the Source, or -1 if it cannot be determined.
function Source:getDuration(unit) end

---
---Gets the filter settings associated to a specific effect.
---
---This function returns nil if the effect was applied with no filter settings associated to it.
---
---@param name string # The name of the effect.
---@param filtersettings? table # An optional empty table that will be filled with the filter settings.
---@return {volume: number, highgain: number, lowgain: number} filtersettings # The settings for the filter associated to this effect, or nil if the effect is not present in this Source or has no filter associated. The table has the following fields:
function Source:getEffect(name, filtersettings) end

---
---Gets the filter settings currently applied to the Source.
---
---@return {type: love.FilterType, volume: number, highgain: number, lowgain: number} settings # The filter settings to use for this Source, or nil if the Source has no active filter. The table has the following fields:
function Source:getFilter() end

---
---Gets the number of free buffer slots in a queueable Source. If the queueable Source is playing, this value will increase up to the amount the Source was created with. If the queueable Source is stopped, it will process all of its internal buffers first, in which case this function will always return the amount it was created with.
---
---@return number buffers # How many more SoundData objects can be queued up.
function Source:getFreeBufferCount() end

---
---Gets the current pitch of the Source.
---
---@return number pitch # The pitch, where 1.0 is normal.
function Source:getPitch() end

---
---Gets the position of the Source.
---
---@return number x # The X position of the Source.
---@return number y # The Y position of the Source.
---@return number z # The Z position of the Source.
function Source:getPosition() end

---
---Returns the rolloff factor of the source.
---
---@return number rolloff # The rolloff factor.
function Source:getRolloff() end

---
---Gets the type of the Source.
---
---@return love.SourceType sourcetype # The type of the source.
function Source:getType() end

---
---Gets the velocity of the Source.
---
---@return number x # The X part of the velocity vector.
---@return number y # The Y part of the velocity vector.
---@return number z # The Z part of the velocity vector.
function Source:getVelocity() end

---
---Gets the current volume of the Source.
---
---@return number volume # The volume of the Source, where 1.0 is normal volume.
function Source:getVolume() end

---
---Returns the volume limits of the source.
---
---@return number min # The minimum volume.
---@return number max # The maximum volume.
function Source:getVolumeLimits() end

---
---Returns whether the Source will loop.
---
---@return boolean loop # True if the Source will loop, false otherwise.
function Source:isLooping() end

---
---Returns whether the Source is playing.
---
---@return boolean playing # True if the Source is playing, false otherwise.
function Source:isPlaying() end

---
---Gets whether the Source's position, velocity, direction, and cone angles are relative to the listener.
---
---@return boolean relative # True if the position, velocity, direction and cone angles are relative to the listener, false if they're absolute.
function Source:isRelative() end

---
---Pauses the Source.
---
function Source:pause() end

---
---Starts playing the Source.
---
---@return boolean success # Whether the Source was able to successfully start playing.
function Source:play() end

---
---Queues SoundData for playback in a queueable Source.
---
---This method requires the Source to be created via love.audio.newQueueableSource.
---
---@param sounddata love.SoundData # The data to queue. The SoundData's sample rate, bit depth, and channel count must match the Source's.
---@return boolean success # True if the data was successfully queued for playback, false if there were no available buffers to use for queueing.
function Source:queue(sounddata) end

---
---Sets the currently playing position of the Source.
---
---@param offset number # The position to seek to.
---@param unit? love.TimeUnit # The unit of the position value.
function Source:seek(offset, unit) end

---
---Sets the amount of air absorption applied to the Source.
---
---By default the value is set to 0 which means that air absorption effects are disabled. A value of 1 will apply high frequency attenuation to the Source at a rate of 0.05 dB per meter.
---
---Air absorption can simulate sound transmission through foggy air, dry air, smoky atmosphere, etc. It can be used to simulate different atmospheric conditions within different locations in an area.
---
---@param amount number # The amount of air absorption applied to the Source. Must be between 0 and 10.
function Source:setAirAbsorption(amount) end

---
---Sets the reference and maximum attenuation distances of the Source. The parameters, combined with the current DistanceModel, affect how the Source's volume attenuates based on distance.
---
---Distance attenuation is only applicable to Sources based on mono (rather than stereo) audio.
---
---@param ref number # The new reference attenuation distance. If the current DistanceModel is clamped, this is the minimum attenuation distance.
---@param max number # The new maximum attenuation distance.
function Source:setAttenuationDistances(ref, max) end

---
---Sets the Source's directional volume cones. Together with Source:setDirection, the cone angles allow for the Source's volume to vary depending on its direction.
---
---@param innerAngle number # The inner angle from the Source's direction, in radians. The Source will play at normal volume if the listener is inside the cone defined by this angle.
---@param outerAngle number # The outer angle from the Source's direction, in radians. The Source will play at a volume between the normal and outer volumes, if the listener is in between the cones defined by the inner and outer angles.
---@param outerVolume? number # The Source's volume when the listener is outside both the inner and outer cone angles.
function Source:setCone(innerAngle, outerAngle, outerVolume) end

---
---Sets the direction vector of the Source. A zero vector makes the source non-directional.
---
---@param x number # The X part of the direction vector.
---@param y number # The Y part of the direction vector.
---@param z number # The Z part of the direction vector.
function Source:setDirection(x, y, z) end

---
---Applies an audio effect to the Source.
---
---The effect must have been previously defined using love.audio.setEffect.
---
---@overload fun(name: string, filtersettings: table):boolean
---@param name string # The name of the effect previously set up with love.audio.setEffect.
---@param enable? boolean # If false and the given effect name was previously enabled on this Source, disables the effect.
---@return boolean success # Whether the effect was successfully applied to this Source.
function Source:setEffect(name, enable) end

---
---Sets a low-pass, high-pass, or band-pass filter to apply when playing the Source.
---
---@overload fun()
---@param settings {type: love.FilterType, volume: number, highgain: number, lowgain: number} # The filter settings to use for this Source, with the following fields:
---@return boolean success # Whether the filter was successfully applied to the Source.
function Source:setFilter(settings) end

---
---Sets whether the Source should loop.
---
---@param loop boolean # True if the source should loop, false otherwise.
function Source:setLooping(loop) end

---
---Sets the pitch of the Source.
---
---@param pitch number # Calculated with regard to 1 being the base pitch. Each reduction by 50 percent equals a pitch shift of -12 semitones (one octave reduction). Each doubling equals a pitch shift of 12 semitones (one octave increase). Zero is not a legal value.
function Source:setPitch(pitch) end

---
---Sets the position of the Source. Please note that this only works for mono (i.e. non-stereo) sound files!
---
---@param x number # The X position of the Source.
---@param y number # The Y position of the Source.
---@param z number # The Z position of the Source.
function Source:setPosition(x, y, z) end

---
---Sets whether the Source's position, velocity, direction, and cone angles are relative to the listener, or absolute.
---
---By default, all sources are absolute and therefore relative to the origin of love's coordinate system 0, 0. Only absolute sources are affected by the position of the listener. Please note that positional audio only works for mono (i.e. non-stereo) sources. 
---
---@param enable? boolean # True to make the position, velocity, direction and cone angles relative to the listener, false to make them absolute.
function Source:setRelative(enable) end

---
---Sets the rolloff factor which affects the strength of the used distance attenuation.
---
---Extended information and detailed formulas can be found in the chapter '3.4. Attenuation By Distance' of OpenAL 1.1 specification.
---
---@param rolloff number # The new rolloff factor.
function Source:setRolloff(rolloff) end

---
---Sets the velocity of the Source.
---
---This does '''not''' change the position of the Source, but lets the application know how it has to calculate the doppler effect.
---
---@param x number # The X part of the velocity vector.
---@param y number # The Y part of the velocity vector.
---@param z number # The Z part of the velocity vector.
function Source:setVelocity(x, y, z) end

---
---Sets the current volume of the Source.
---
---@param volume number # The volume for a Source, where 1.0 is normal volume. Volume cannot be raised above 1.0.
function Source:setVolume(volume) end

---
---Sets the volume limits of the source. The limits have to be numbers from 0 to 1.
---
---@param min number # The minimum volume.
---@param max number # The maximum volume.
function Source:setVolumeLimits(min, max) end

---
---Stops a Source.
---
function Source:stop() end

---
---Gets the currently playing position of the Source.
---
---@param unit? love.TimeUnit # The type of unit for the return value.
---@return number position # The currently playing position of the Source.
function Source:tell(unit) end

---
---The different distance models.
---
---Extended information can be found in the chapter "3.4. Attenuation By Distance" of the OpenAL 1.1 specification.
---
---@class love.DistanceModel
---
---Sources do not get attenuated.
---
---@field none integer
---
---Inverse distance attenuation.
---
---@field inverse integer
---
---Inverse distance attenuation. Gain is clamped. In version 0.9.2 and older this is named '''inverse clamped'''.
---
---@field inverseclamped integer
---
---Linear attenuation.
---
---@field linear integer
---
---Linear attenuation. Gain is clamped. In version 0.9.2 and older this is named '''linear clamped'''.
---
---@field linearclamped integer
---
---Exponential attenuation.
---
---@field exponent integer
---
---Exponential attenuation. Gain is clamped. In version 0.9.2 and older this is named '''exponent clamped'''.
---
---@field exponentclamped integer

---
---The different types of effects supported by love.audio.setEffect.
---
---@class love.EffectType
---
---Plays multiple copies of the sound with slight pitch and time variation. Used to make sounds sound "fuller" or "thicker".
---
---@field chorus integer
---
---Decreases the dynamic range of the sound, making the loud and quiet parts closer in volume, producing a more uniform amplitude throughout time.
---
---@field compressor integer
---
---Alters the sound by amplifying it until it clips, shearing off parts of the signal, leading to a compressed and distorted sound.
---
---@field distortion integer
---
---Decaying feedback based effect, on the order of seconds. Also known as delay; causes the sound to repeat at regular intervals at a decreasing volume.
---
---@field echo integer
---
---Adjust the frequency components of the sound using a 4-band (low-shelf, two band-pass and a high-shelf) equalizer.
---
---@field equalizer integer
---
---Plays two copies of the sound; while varying the phase, or equivalently delaying one of them, by amounts on the order of milliseconds, resulting in phasing sounds.
---
---@field flanger integer
---
---Decaying feedback based effect, on the order of milliseconds. Used to simulate the reflection off of the surroundings.
---
---@field reverb integer
---
---An implementation of amplitude modulation; multiplies the source signal with a simple waveform, to produce either volume changes, or inharmonic overtones.
---
---@field ringmodulator integer

---
---The different types of waveforms that can be used with the '''ringmodulator''' EffectType.
---
---@class love.EffectWaveform
---
---A sawtooth wave, also known as a ramp wave. Named for its linear rise, and (near-)instantaneous fall along time.
---
---@field sawtooth integer
---
---A sine wave. Follows a trigonometric sine function.
---
---@field sine integer
---
---A square wave. Switches between high and low states (near-)instantaneously.
---
---@field square integer
---
---A triangle wave. Follows a linear rise and fall that repeats periodically.
---
---@field triangle integer

---
---Types of filters for Sources.
---
---@class love.FilterType
---
---Low-pass filter. High frequency sounds are attenuated.
---
---@field lowpass integer
---
---High-pass filter. Low frequency sounds are attenuated.
---
---@field highpass integer
---
---Band-pass filter. Both high and low frequency sounds are attenuated based on the given parameters.
---
---@field bandpass integer

---
---Types of audio sources.
---
---A good rule of thumb is to use stream for music files and static for all short sound effects. Basically, you want to avoid loading large files into memory at once.
---
---@class love.SourceType
---
---The whole audio is decoded.
---
---@field static integer
---
---The audio is decoded in chunks when needed.
---
---@field stream integer
---
---The audio must be manually queued by the user.
---
---@field queue integer

---
---Units that represent time.
---
---@class love.TimeUnit
---
---Regular seconds.
---
---@field seconds integer
---
---Audio samples.
---
---@field samples integer
