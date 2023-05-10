local template = require 'config.template'
local lclient = require 'lclient'
local ws      = require 'workspace'
local furi    = require 'file-uri'

template['Lua.runtime.version'].default = 'LuaJIT'


---@async
lclient():start(function (client)
    client:registerFakers()
    local rootUri = furi.encode '/'
    client:initialize {
        rootUri = rootUri,
    }

    ws.awaitReady(rootUri)

    require 'ffi.cdef'
    require 'ffi.parser'
end)
