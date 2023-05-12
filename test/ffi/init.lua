local lclient = require 'lclient'
local ws = require 'workspace'
local furi = require 'file-uri'
local files = require 'files'

--TODO how to changed the runtime version?
local template = require 'config.template'

template['Lua.runtime.version'].default = 'LuaJIT'


---@async
local function TestBuilder()
    local builder = require 'plugins.ffi'.initBuilder()
    files.setText(TESTURI, [[
        local ffi = require 'ffi'
        ffi.cdef 'void test();'
    ]])

    builder(TESTURI)
end

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
    TestBuilder()
end)
