local json    = require 'json'
local ioWrite = io.write
local osClock = os.clock

_ENV = nil

local TIMEOUT = 600.0
local ID = 0
local Cache = {}

---@class jsonrpc
local m = {}
m.type = 'jsonrpc'

return m
