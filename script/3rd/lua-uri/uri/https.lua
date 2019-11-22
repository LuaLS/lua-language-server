local M = { _NAME = "uri.https" }
local Util = require "uri._util"
local Http = require "uri.http"
Util.subclass_of(M, Http)

function M.default_port () return 443 end

return M
-- vi:ts=4 sw=4 expandtab
