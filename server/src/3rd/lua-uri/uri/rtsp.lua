local M = { _NAME = "uri.rtsp" }
local Util = require "uri._util"
local HttpURI = require "uri.http"
Util.subclass_of(M, HttpURI)

function M.default_port () return 554 end

return M
-- vi:ts=4 sw=4 expandtab
