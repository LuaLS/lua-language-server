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
