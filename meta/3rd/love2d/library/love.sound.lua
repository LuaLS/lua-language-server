---@class love.sound
love.sound = {}

---
---Attempts to find a decoder for the encoded sound data in the specified file.
---
---@param file File # The file with encoded sound data.
---@param buffer number # The size of each decoded chunk, in bytes.
---@return Decoder decoder # A new Decoder object.
function love.sound.newDecoder(file, buffer) end

---
---Creates new SoundData from a filepath, File, or Decoder. It's also possible to create SoundData with a custom sample rate, channel and bit depth.
---
---The sound data will be decoded to the memory in a raw format. It is recommended to create only short sounds like effects, as a 3 minute song uses 30 MB of memory this way.
---
---@param filename string # The file name of the file to load.
---@return SoundData soundData # A new SoundData object.
function love.sound.newSoundData(filename) end
