---@meta

---
---This module is responsible for decoding, controlling, and streaming video files.
---
---It can't draw the videos, see love.graphics.newVideo and Video objects for that.
---
---@class love.video
love.video = {}

---
---Creates a new VideoStream. Currently only Ogg Theora video files are supported. VideoStreams can't draw videos, see love.graphics.newVideo for that.
---
---@overload fun(file: love.File):love.VideoStream
---@param filename string # The file path to the Ogg Theora video file.
---@return love.VideoStream videostream # A new VideoStream.
function love.video.newVideoStream(filename) end

---
---An object which decodes, streams, and controls Videos.
---
---@class love.VideoStream: love.Object
local VideoStream = {}

---
---Gets the filename of the VideoStream.
---
---@return string filename # The filename of the VideoStream
function VideoStream:getFilename() end

---
---Gets whether the VideoStream is playing.
---
---@return boolean playing # Whether the VideoStream is playing.
function VideoStream:isPlaying() end

---
---Pauses the VideoStream.
---
function VideoStream:pause() end

---
---Plays the VideoStream.
---
function VideoStream:play() end

---
---Rewinds the VideoStream. Synonym to VideoStream:seek(0).
---
function VideoStream:rewind() end

---
---Sets the current playback position of the VideoStream.
---
---@param offset number # The time in seconds since the beginning of the VideoStream.
function VideoStream:seek(offset) end

---
---Gets the current playback position of the VideoStream.
---
---@return number seconds # The number of seconds sionce the beginning of the VideoStream.
function VideoStream:tell() end
