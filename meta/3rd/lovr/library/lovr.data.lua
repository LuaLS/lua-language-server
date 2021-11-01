---@meta

---
---The `lovr.data` module provides functions for accessing underlying data representations for several LÖVR objects.
---
---@class lovr.data
lovr.data = {}

---
---Creates a new Blob.
---
---@overload fun(contents: string, name: string):lovr.Blob
---@overload fun(source: lovr.Blob, name: string):lovr.Blob
---@param size number # The amount of data to allocate for the Blob, in bytes.  All of the bytes will be filled with zeroes.
---@param name? string # A name for the Blob (used in error messages)
---@return lovr.Blob blob # The new Blob.
function lovr.data.newBlob(size, name) end

---
---Creates a new Image.  Image data can be loaded and decoded from an image file, or a raw block of pixels with a specified width, height, and format can be created.
---
---@overload fun(width: number, height: number, format: lovr.TextureFormat, data: lovr.Blob):lovr.Image
---@overload fun(source: lovr.Image):lovr.Image
---@overload fun(blob: lovr.Blob, flip: boolean):lovr.Image
---@param filename string # The filename of the image to load.
---@param flip? boolean # Whether to vertically flip the image on load.  This should be true for normal textures, and false for textures that are going to be used in a cubemap.
---@return lovr.Image image # The new Image.
function lovr.data.newImage(filename, flip) end

---
---Loads a 3D model from a file.  The supported 3D file formats are OBJ and glTF.
---
---@overload fun(blob: lovr.Blob):lovr.ModelData
---@param filename string # The filename of the model to load.
---@return lovr.ModelData modelData # The new ModelData.
function lovr.data.newModelData(filename) end

---
---Creates a new Rasterizer from a TTF file.
---
---@overload fun(filename: string, size: number):lovr.Rasterizer
---@overload fun(blob: lovr.Blob, size: number):lovr.Rasterizer
---@param size? number # The resolution to render the fonts at, in pixels.  Higher resolutions use more memory and processing power but may provide better quality results for some fonts/situations.
---@return lovr.Rasterizer rasterizer # The new Rasterizer.
function lovr.data.newRasterizer(size) end

---
---Creates a new Sound.  A sound can be loaded from an audio file, or it can be created empty with capacity for a certain number of audio frames.
---
---When loading audio from a file, use the `decode` option to control whether compressed audio should remain compressed or immediately get decoded to raw samples.
---
---When creating an empty sound, the `contents` parameter can be set to `'stream'` to create an audio stream.  On streams, `Sound:setFrames` will always write to the end of the stream, and `Sound:getFrames` will always read the oldest samples from the beginning.  The number of frames in the sound is the total capacity of the stream's buffer.
---
---@overload fun(filename: string, decode: boolean):lovr.Sound
---@overload fun(blob: lovr.Blob, decode: boolean):lovr.Sound
---@param frames number # The number of frames the Sound can hold.
---@param format? lovr.SampleFormat # The sample data type.
---@param channels? lovr.ChannelLayout # The channel layout.
---@param sampleRate? number # The sample rate, in Hz.
---@param contents? lovr.* # A Blob containing raw audio samples to use as the initial contents, 'stream' to create an audio stream, or `nil` to leave the data initialized to zero.
---@return lovr.Sound sound # Sounds good.
function lovr.data.newSound(frames, format, channels, sampleRate, contents) end

---
---Sounds can have different numbers of channels, and those channels can map to various speaker layouts.
---
---@class lovr.ChannelLayout
---
---1 channel.
---
---@field mono integer
---
---2 channels.  The first channel is for the left speaker and the second is for the right.
---
---@field stereo integer
---
---4 channels.  Ambisonic channels don't map directly to speakers but instead represent directions in 3D space, sort of like the images of a skybox.  Currently, ambisonic sounds can only be loaded, not played.
---
---@field ambisonic integer

---
---Sounds can store audio samples as 16 bit integers or 32 bit floats.
---
---@class lovr.SampleFormat
---
---32 bit floating point samples (between -1.0 and 1.0).
---
---@field f32 integer
---
---16 bit integer samples (between -32768 and 32767).
---
---@field i16 integer
