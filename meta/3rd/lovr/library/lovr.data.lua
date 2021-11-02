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
---@param contents? any # A Blob containing raw audio samples to use as the initial contents, 'stream' to create an audio stream, or `nil` to leave the data initialized to zero.
---@return lovr.Sound sound # Sounds good.
function lovr.data.newSound(frames, format, channels, sampleRate, contents) end

---
---A Blob is an object that holds binary data.  It can be passed to most functions that take filename arguments, like `lovr.graphics.newModel` or `lovr.audio.newSource`.  Blobs aren't usually necessary for simple projects, but they can be really helpful if:
---
---- You need to work with low level binary data, potentially using the LuaJIT FFI for increased
---  performance.
---- You are working with data that isn't stored as a file, such as programmatically generated data
---  or a string from a network request.
---- You want to load data from a file once and then use it to create many different objects.
---
---A Blob's size cannot be changed once it is created.
---
---@class lovr.Blob
local Blob = {}

---
---Returns the filename the Blob was loaded from, or the custom name given to it when it was created.  This label is also used in error messages.
---
---@return string name # The name of the Blob.
function Blob:getName() end

---
---Returns a raw pointer to the Blob's data.  This can be used to interface with other C libraries using the LuaJIT FFI.  Use this only if you know what you're doing!
---
---@return userdata pointer # A pointer to the data.
function Blob:getPointer() end

---
---Returns the size of the Blob's contents, in bytes.
---
---@return number bytes # The size of the Blob, in bytes.
function Blob:getSize() end

---
---Returns a binary string containing the Blob's data.
---
---@return string data # The Blob's data.
function Blob:getString() end

---
---An Image stores raw 2D pixel info for `Texture`s.  It has a width, height, and format.  The Image can be initialized with the contents of an image file or it can be created with uninitialized contents.  The supported image formats are `png`, `jpg`, `hdr`, `dds`, `ktx`, and `astc`.
---
---Usually you can just use Textures, but Image can be useful if you want to manipulate individual pixels, load Textures in a background thread, or use the FFI to efficiently access the raw image data.
---
---@class lovr.Image
local Image = {}

---
---Encodes the Image to an uncompressed png.  This intended mainly for debugging.
---
---@return lovr.Blob blob # A new Blob containing the PNG image data.
function Image:encode() end

---
---Returns a Blob containing the raw bytes of the Image.
---
---@return lovr.Blob blob # The Blob instance containing the bytes for the `Image`.
function Image:getBlob() end

---
---Returns the dimensions of the Image, in pixels.
---
---@return number width # The width of the Image, in pixels.
---@return number height # The height of the Image, in pixels.
function Image:getDimensions() end

---
---Returns the format of the Image.
---
---@return lovr.TextureFormat format # The format of the pixels in the Image.
function Image:getFormat() end

---
---Returns the height of the Image, in pixels.
---
---@return number height # The height of the Image, in pixels.
function Image:getHeight() end

---
---Returns the value of a pixel of the Image.
---
---@param x number # The x coordinate of the pixel to get (0-indexed).
---@param y number # The y coordinate of the pixel to get (0-indexed).
---@return number r # The red component of the pixel, from 0.0 to 1.0.
---@return number g # The green component of the pixel, from 0.0 to 1.0.
---@return number b # The blue component of the pixel, from 0.0 to 1.0.
---@return number a # The alpha component of the pixel, from 0.0 to 1.0.
function Image:getPixel(x, y) end

---
---Returns the width of the Image, in pixels.
---
---@return number width # The width of the Image, in pixels.
function Image:getWidth() end

---
---Copies a rectangle of pixels from one Image to this one.
---
---@param source lovr.Image # The Image to copy pixels from.
---@param x? number # The x coordinate to paste to (0-indexed).
---@param y? number # The y coordinate to paste to (0-indexed).
---@param fromX? number # The x coordinate in the source to paste from (0-indexed).
---@param fromY? number # The y coordinate in the source to paste from (0-indexed).
---@param width? number # The width of the region to copy.
---@param height? number # The height of the region to copy.
function Image:paste(source, x, y, fromX, fromY, width, height) end

---
---Sets the value of a pixel of the Image.
---
---@param x number # The x coordinate of the pixel to set (0-indexed).
---@param y number # The y coordinate of the pixel to set (0-indexed).
---@param r number # The red component of the pixel, from 0.0 to 1.0.
---@param g number # The green component of the pixel, from 0.0 to 1.0.
---@param b number # The blue component of the pixel, from 0.0 to 1.0.
---@param a? number # The alpha component of the pixel, from 0.0 to 1.0.
function Image:setPixel(x, y, r, g, b, a) end

---
---A ModelData is a container object that loads and holds data contained in 3D model files.  This can include a variety of things like the node structure of the asset, the vertex data it contains, contains, the `Image` and `Material` properties, and any included animations.
---
---The current supported formats are OBJ, glTF, and STL.
---
---Usually you can just load a `Model` directly, but using a `ModelData` can be helpful if you want to load models in a thread or access more low-level information about the Model.
---
---@class lovr.ModelData
local ModelData = {}

---
---A Rasterizer is an object that parses a TTF file, decoding and rendering glyphs from it.
---
---Usually you can just use `Font` objects.
---
---@class lovr.Rasterizer
local Rasterizer = {}

---
---Returns the advance metric of the font, in pixels.  The advance is how many pixels the font advances horizontally after each glyph is rendered.  This does not include kerning.
---
---@return number advance # The advance of the font, in pixels.
function Rasterizer:getAdvance() end

---
---Returns the ascent metric of the font, in pixels.  The ascent represents how far any glyph of the font ascends above the baseline.
---
---@return number ascent # The ascent of the font, in pixels.
function Rasterizer:getAscent() end

---
---Returns the descent metric of the font, in pixels.  The descent represents how far any glyph of the font descends below the baseline.
---
---@return number descent # The descent of the font, in pixels.
function Rasterizer:getDescent() end

---
---Returns the number of glyphs stored in the font file.
---
---@return number count # The number of glyphs stored in the font file.
function Rasterizer:getGlyphCount() end

---
---Returns the height metric of the font, in pixels.
---
---@return number height # The height of the font, in pixels.
function Rasterizer:getHeight() end

---
---Returns the line height metric of the font, in pixels.  This is how far apart lines are.
---
---@return number height # The line height of the font, in pixels.
function Rasterizer:getLineHeight() end

---
---Check if the Rasterizer can rasterize a set of glyphs.
---
---@return boolean hasGlyphs # true if the Rasterizer can rasterize all of the supplied characters, false otherwise.
function Rasterizer:hasGlyphs() end

---
---A Sound stores the data for a sound.  The supported sound formats are OGG, WAV, and MP3.  Sounds cannot be played directly.  Instead, there are `Source` objects in `lovr.audio` that are used for audio playback.  All Source objects are backed by one of these Sounds, and multiple Sources can share a single Sound to reduce memory usage.
---
---Metadata
------
---
---Sounds hold a fixed number of frames.  Each frame contains one audio sample for each channel. The `SampleFormat` of the Sound is the data type used for each sample (floating point, integer, etc.).  The Sound has a `ChannelLayout`, representing the number of audio channels and how they map to speakers (mono, stereo, etc.).  The sample rate of the Sound indicates how many frames should be played per second.  The duration of the sound (in seconds) is the number of frames divided by the sample rate.
---
---Compression
------
---
---Sounds can be compressed.  Compressed sounds are stored compressed in memory and are decoded as they are played.  This uses a lot less memory but increases CPU usage during playback.  OGG and MP3 are compressed audio formats.  When creating a sound from a compressed format, there is an option to immediately decode it, storing it uncompressed in memory.  It can be a good idea to decode short sound effects, since they won't use very much memory even when uncompressed and it will improve CPU usage.  Compressed sounds can not be written to using `Sound:setFrames`.
---
---Streams
------
---
---Sounds can be created as a stream by passing `'stream'` as their contents when creating them. Audio frames can be written to the end of the stream, and read from the beginning.  This works well for situations where data is being generated in real time or streamed in from some other data source.
---
---Sources can be backed by a stream and they'll just play whatever audio is pushed to the stream. The audio module also lets you use a stream as a "sink" for an audio device.  For playback devices, this works like loopback, so the mixed audio from all playing Sources will get written to the stream.  For capture devices, all the microphone input will get written to the stream. Conversion between sample formats, channel layouts, and sample rates will happen automatically.
---
---Keep in mind that streams can still only hold a fixed number of frames.  If too much data is written before it is read, older frames will start to get overwritten.  Similary, it's possible to read too much data without writing fast enough.
---
---Ambisonics
------
---
---Ambisonic sounds can be imported from WAVs, but can not yet be played.  Sounds with a `ChannelLayout` of `ambisonic` are stored as first-order full-sphere ambisonics using the AmbiX format (ACN channel ordering and SN3D channel normalization).  The AMB format is supported for import and will automatically get converted to AmbiX.  See `lovr.data.newSound` for more info.
---
---@class lovr.Sound
local Sound = {}

---
---Returns a Blob containing the raw bytes of the Sound.
---
---@return lovr.Blob blob # The Blob instance containing the bytes for the `Sound`.
function Sound:getBlob() end

---
---Returns the number of channels in the Sound.  Mono sounds have 1 channel, stereo sounds have 2 channels, and ambisonic sounds have 4 channels.
---
---@return number channels # The number of channels in the sound.
function Sound:getChannelCount() end

---
---Returns the channel layout of the Sound.
---
---@return lovr.ChannelLayout channels # The channel layout.
function Sound:getChannelLayout() end

---
---Returns the duration of the Sound, in seconds.
---
---@return number duration # The duration of the Sound, in seconds.
function Sound:getDuration() end

---
---Returns the sample format of the Sound.
---
---@return lovr.SampleFormat format # The data type of each sample.
function Sound:getFormat() end

---
---Returns the number of frames in the Sound.  A frame stores one sample for each channel.
---
---@return number frames # The number of frames in the Sound.
function Sound:getFrameCount() end

---
---Reads frames from the Sound into a table, Blob, or another Sound.
---
---@overload fun(t: table, count: number, srcOffset: number, dstOffset: number):table, number
---@overload fun(blob: lovr.Blob, count: number, srcOffset: number, dstOffset: number):number
---@overload fun(sound: lovr.Sound, count: number, srcOffset: number, dstOffset: number):number
---@param count? number # The number of frames to read.  If nil, reads as many frames as possible.

Compressed sounds will automatically be decoded.

Reading from a stream will ignore the source offset and read the oldest frames.
---@param srcOffset? number # A frame offset to apply to the sound when reading frames.
---@return table t # A table containing audio frames.
---@return number count # The number of frames read.
function Sound:getFrames(count, srcOffset) end

---
---Returns the total number of samples in the Sound.
---
---@return number samples # The total number of samples in the Sound.
function Sound:getSampleCount() end

---
---Returns the sample rate of the Sound, in Hz.  This is the number of frames that are played every second.  It's usually a high number like 48000.
---
---@return number frequency # The number of frames per second in the Sound.
function Sound:getSampleRate() end

---
---Returns whether the Sound is compressed.  Compressed sounds are loaded from compressed audio formats like MP3 and OGG.  They use a lot less memory but require some extra CPU work during playback.  Compressed sounds can not be modified using `Sound:setFrames`.
---
---@return boolean compressed # Whether the Sound is compressed.
function Sound:isCompressed() end

---
---Returns whether the Sound is a stream.
---
---@return boolean stream # Whether the Sound is a stream.
function Sound:isStream() end

---
---Writes frames to the Sound.
---
---@overload fun(blob: lovr.Blob, count: number, dstOffset: number, srcOffset: number):number
---@overload fun(sound: lovr.Sound, count: number, dstOffset: number, srcOffset: number):number
---@param t table # A table containing frames to write.
---@param count? number # How many frames to write.  If nil, writes as many as possible.
---@param dstOffset? number # A frame offset to apply when writing the frames.
---@param srcOffset? number # A frame, byte, or index offset to apply when reading frames from the source.
---@return number count # The number of frames written.
function Sound:setFrames(t, count, dstOffset, srcOffset) end

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
