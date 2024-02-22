local lclient = require 'lclient'
local ws = require 'workspace'
local furi = require 'file-uri'
local files = require 'files'
local diagnostic = require 'provider.diagnostic'

--TODO how to changed the runtime version?
local template = require 'config.template'

template['Lua.runtime.version'].default = 'LuaJIT'

TESTURI = furi.encode(TESTROOT .. 'unittest.ffi.lua')

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
    local rootUri = TESTURI
    languageClient:initialize {
        rootUri = rootUri,
    }

    diagnostic.pause()

    ws.awaitReady(rootUri)

    require 'plugins.ffi.cdef'
    require 'plugins.ffi.parser'
    require 'plugins.ffi.builder'
    TestBuilder()

    diagnostic.resume()
end)
