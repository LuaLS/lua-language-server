local lclient = require 'lclient'
local ws = require 'workspace'
local furi = require 'file-uri'
local files = require 'files'

--TODO how to changed the runtime version?
local template = require 'config.template'

template['Lua.runtime.version'].default = 'LuaJIT'

---@async
local function TestBuilder()
    local builder = require 'core.command.reloadFFIMeta'
    files.setText(TESTURI, [[
        local ffi = require 'ffi'
        ffi.cdef 'void test();'
    ]])
    local uri = ws.getFirstScope().uri
    builder(uri)
end

---@async
lclient():start(function (languageClient)
    languageClient:registerFakers()
    local rootUri = furi.encode '/'
    languageClient:initialize {
        rootUri = rootUri,
    }

    ws.awaitReady(rootUri)

    require 'plugins.ffi.cdef'
    require 'plugins.ffi.parser'
    require 'plugins.ffi.builder'
    TestBuilder()
end)
