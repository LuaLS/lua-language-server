---@meta

---
---This module is responsible for decoding sound files. It can't play the sounds, see love.audio for that.
---
---@class love.sound
love.sound = {}

---
---Attempts to find a decoder for the encoded sound data in the specified file.
---
---@overload fun(filename: string, buffer: number):love.Decoder
---@param file love.File # The file with encoded sound data.
---@param buffer? number # The size of each decoded chunk, in bytes.
---@return love.Decoder decoder # A new Decoder object.
function love.sound.newDecoder(file, buffer) end

---
---Creates new SoundData from a filepath, File, or Decoder. It's also possible to create SoundData with a custom sample rate, channel and bit depth.
---
---The sound data will be decoded to the memory in a raw format. It is recommended to create only short sounds like effects, as a 3 minute song uses 30 MB of memory this way.
---
---@overload fun(file: love.File):love.SoundData
---@overload fun(decoder: love.Decoder):love.SoundData
---@overload fun(samples: number, rate: number, bits: number, channels: number):love.SoundData
---@param filename string # The file name of the file to load.
---@return love.SoundData soundData # A new SoundData object.
function love.sound.newSoundData(filename) end

---
---An object which can gradually decode a sound file.
---
---@class love.Decoder: love.Object
local Decoder = {}

---
---Creates a new copy of current decoder.
---
---The new decoder will start decoding from the beginning of the audio stream.
---
---@return love.Decoder decoder # New copy of the decoder.
function Decoder:clone() end

---
---Returns the number of bits per sample.
---
---@return number bitDepth # Either 8, or 16.
function Decoder:getBitDepth() end

---
---Returns the number of channels in the stream.
---
---@return number channels # 1 for mono, 2 for stereo.
function Decoder:getChannelCount() end

---
---Gets the duration of the sound file. It may not always be sample-accurate, and it may return -1 if the duration cannot be determined at all.
---
---@return number duration # The duration of the sound file in seconds, or -1 if it cannot be determined.
function Decoder:getDuration() end

---
---Returns the sample rate of the Decoder.
---
---@return number rate # Number of samples per second.
function Decoder:getSampleRate() end

---
---Contains raw audio samples.
---
---You can not play SoundData back directly. You must wrap a Source object around it.
---
---@class love.SoundData: love.Data, love.Object
local SoundData = {}

---
---Returns the number of bits per sample.
---
---@return number bitdepth # Either 8, or 16.
function SoundData:getBitDepth() end

---
---Returns the number of channels in the SoundData.
---
---@return number channels # 1 for mono, 2 for stereo.
function SoundData:getChannelCount() end

---
---Gets the duration of the sound data.
---
---@return number duration # The duration of the sound data in seconds.
function SoundData:getDuration() end

---
---Gets the value of the sample-point at the specified position. For stereo SoundData objects, the data from the left and right channels are interleaved in that order.
---
---@overload fun(i: number, channel: number):number
---@param i number # An integer value specifying the position of the sample (starting at 0).
---@return number sample # The normalized samplepoint (range -1.0 to 1.0).
function SoundData:getSample(i) end

---
---Returns the number of samples per channel of the SoundData.
---
---@return number count # Total number of samples.
function SoundData:getSampleCount() end

---
---Returns the sample rate of the SoundData.
---
---@return number rate # Number of samples per second.
function SoundData:getSampleRate() end

---
---Sets the value of the sample-point at the specified position. For stereo SoundData objects, the data from the left and right channels are interleaved in that order.
---
---@overload fun(i: number, channel: number, sample: number)
---@param i number # An integer value specifying the position of the sample (starting at 0).
---@param sample number # The normalized samplepoint (range -1.0 to 1.0).
function SoundData:setSample(i, sample) end
