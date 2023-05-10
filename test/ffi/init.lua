local lclient = require 'lclient'
local ws      = require 'workspace'
local furi    = require 'file-uri'
local config  = require 'config'

---@async
lclient():start(function (client)
    client:registerFakers()
    local rootUri = furi.encode '/'
    config.set(rootUri, 'Lua.runtime.version', 'LuaJIT')
    client:initialize {
        rootUri = rootUri,
    }

    ws.awaitReady(rootUri)

    require 'ffi.cdef'
    require 'ffi.parser'
end)
