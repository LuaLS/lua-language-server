local M = { _NAME = "uri.rtspu" }
local Util = require "uri._util"
local RtspURI = require "uri.rtsp"
Util.subclass_of(M, RtspURI)

return M
-- vi:ts=4 sw=4 expandtab
