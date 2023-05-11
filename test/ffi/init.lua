local lclient  = require 'lclient'
local ws       = require 'workspace'
local furi     = require 'file-uri'

--TODO how to changed the runtime version?
local template = require 'config.template'
template['Lua.runtime.version'].default = 'LuaJIT'

---@async
lclient():start(function (languageClient)
    languageClient:registerFakers()
    local rootUri = furi.encode '/'
    languageClient:initialize {
        rootUri = rootUri,
    }

    ws.awaitReady(rootUri)

    require 'ffi.cdef'
    require 'ffi.parser'
    require 'ffi.builder'
end)
