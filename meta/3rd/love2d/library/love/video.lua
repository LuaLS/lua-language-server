---@meta

---
---This module is responsible for decoding, controlling, and streaming video files.
---
---It can't draw the videos, see love.graphics.newVideo and Video objects for that.
---
---
---[Open in Browser](https://love2d.org/wiki/love.video)
---
---@class love.video
love.video = {}

---
---Creates a new VideoStream. Currently only Ogg Theora video files are supported. VideoStreams can't draw videos, see love.graphics.newVideo for that.
---
---
---[Open in Browser](https://love2d.org/wiki/love.video.newVideoStream)
---
---@overload fun(file: love.File):love.VideoStream
---@param filename string # The file path to the Ogg Theora video file.
---@return love.VideoStream videostream # A new VideoStream.
function love.video.newVideoStream(filename) end

---
---An object which decodes, streams, and controls Videos.
---
---
---[Open in Browser](https://love2d.org/wiki/love.video)
---
---@class love.VideoStream: love.Object
local VideoStream = {}

---
---Gets the filename of the VideoStream.
---
---
---[Open in Browser](https://love2d.org/wiki/VideoStream:getFilename)
---
---@return string filename # The filename of the VideoStream
function VideoStream:getFilename() end

---
---Gets whether the VideoStream is playing.
---
---
---[Open in Browser](https://love2d.org/wiki/VideoStream:isPlaying)
---
---@return boolean playing # Whether the VideoStream is playing.
function VideoStream:isPlaying() end

---
---Pauses the VideoStream.
---
---
---[Open in Browser](https://love2d.org/wiki/VideoStream:pause)
---
function VideoStream:pause() end

---
---Plays the VideoStream.
---
---
---[Open in Browser](https://love2d.org/wiki/VideoStream:play)
---
function VideoStream:play() end

---
---Rewinds the VideoStream. Synonym to VideoStream:seek(0).
---
---
---[Open in Browser](https://love2d.org/wiki/VideoStream:rewind)
---
function VideoStream:rewind() end

---
---Sets the current playback position of the VideoStream.
---
---
---[Open in Browser](https://love2d.org/wiki/VideoStream:seek)
---
---@param offset number # The time in seconds since the beginning of the VideoStream.
function VideoStream:seek(offset) end

---
---Gets the current playback position of the VideoStream.
---
---
---[Open in Browser](https://love2d.org/wiki/VideoStream:tell)
---
---@return number seconds # The number of seconds sionce the beginning of the VideoStream.
function VideoStream:tell() end
