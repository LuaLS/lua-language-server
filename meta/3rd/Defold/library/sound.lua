---Sound API documentation
---Sound API documentation
---@class sound
sound = {}
---Get mixer group gain
--- Note that gain is in linear scale, between 0 and 1.
---To get the dB value from the gain, use the formula 20 * log(gain).
---Inversely, to find the linear value from a dB value, use the formula
---10db/20.
---@param group string|hash # group name
---@return number # gain in linear scale
function sound.get_group_gain(group) end

---Get a mixer group name as a string.
--- This function is to be used for debugging and
---development tooling only. The function does a reverse hash lookup, which does not
---return a proper string value when the game is built in release mode.
---@param group string|hash # group name
---@return string # group name
function sound.get_group_name(group) end

---Get a table of all mixer group names (hashes).
---@return table # table of mixer group names
function sound.get_groups() end

---Get peak value from mixer group.
--- Note that gain is in linear scale, between 0 and 1.
---To get the dB value from the gain, use the formula 20 * log(gain).
---Inversely, to find the linear value from a dB value, use the formula
---10db/20.
---Also note that the returned value might be an approximation and in particular
---the effective window might be larger than specified.
---@param group string|hash # group name
---@param window number # window length in seconds
---@return number # peak value for left channel
---@return number # peak value for right channel
function sound.get_peak(group, window) end

---Get RMS (Root Mean Square) value from mixer group. This value is the
---square root of the mean (average) value of the squared function of
---the instantaneous values.
---For instance: for a sinewave signal with a peak gain of -1.94 dB (0.8 linear),
---the RMS is 0.8 ? 1/sqrt(2) which is about 0.566.
--- Note the returned value might be an approximation and in particular
---the effective window might be larger than specified.
---@param group string|hash # group name
---@param window number # window length in seconds
---@return number # RMS value for left channel
---@return number # RMS value for right channel
function sound.get_rms(group, window) end

---Checks if background music is playing, e.g. from iTunes.
--- On non mobile platforms,
---this function always return false.
--- On Android you can only get a correct reading
---of this state if your game is not playing any sounds itself. This is a limitation
---in the Android SDK. If your game is playing any sounds, even with a gain of zero, this
---function will return false.
---The best time to call this function is:
---
---
--- * In the init function of your main collection script before any sounds are triggered
---
--- * In a window listener callback when the window.WINDOW_EVENT_FOCUS_GAINED event is received
---
---Both those times will give you a correct reading of the state even when your application is
---swapped out and in while playing sounds and it works equally well on Android and iOS.
---@return boolean # true if music is playing, otherwise false.
function sound.is_music_playing() end

---Checks if a phone call is active. If there is an active phone call all
---other sounds will be muted until the phone call is finished.
--- On non mobile platforms,
---this function always return false.
---@return boolean # true if there is an active phone call, false otherwise.
function sound.is_phone_call_active() end

---Pause all active voices
---@param url string|hash|url # the sound that should pause
---@param pause bool # true if the sound should pause
function sound.pause(url, pause) end

---Make the sound component play its sound. Multiple voices are supported. The limit is set to 32 voices per sound component.
--- Note that gain is in linear scale, between 0 and 1.
---To get the dB value from the gain, use the formula 20 * log(gain).
---Inversely, to find the linear value from a dB value, use the formula
---10db/20.
--- A sound will continue to play even if the game object the sound component belonged to is deleted. You can call sound.stop() to stop the sound.
---@param url string|hash|url # the sound that should play
---@param play_properties table? # 
---@param complete_function (fun(self: object, message_id: hash, message: table, sender: number))? # function to call when the sound has finished playing.
---@return number # The identifier for the sound voice
function sound.play(url, play_properties, complete_function) end

---Set gain on all active playing voices of a sound.
--- Note that gain is in linear scale, between 0 and 1.
---To get the dB value from the gain, use the formula 20 * log(gain).
---Inversely, to find the linear value from a dB value, use the formula
---10db/20.
---@param url string|hash|url # the sound to set the gain of
---@param gain number? # sound gain between 0 and 1. The final gain of the sound will be a combination of this gain, the group gain and the master gain.
function sound.set_gain(url, gain) end

---Set mixer group gain
--- Note that gain is in linear scale, between 0 and 1.
---To get the dB value from the gain, use the formula 20 * log(gain).
---Inversely, to find the linear value from a dB value, use the formula
---10db/20.
---@param group string|hash # group name
---@param gain number # gain in linear scale
function sound.set_group_gain(group, gain) end

---Set panning on all active playing voices of a sound.
---The valid range is from -1.0 to 1.0, representing -45 degrees left, to +45 degrees right.
---@param url string|hash|url # the sound to set the panning value to
---@param pan number? # sound panning between -1.0 and 1.0
function sound.set_pan(url, pan) end

---Stop playing all active voices
---@param url string|hash|url # the sound that should stop
function sound.stop(url) end




return sound