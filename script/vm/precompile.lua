local files    = require 'files'
local global   = require 'vm.global'
local variable = require 'vm.variable'

---@async
files.watch(function (ev, uri)
    if ev == 'update' then
        global.dropUri(uri)
    end
    if ev == 'remove' then
        global.dropUri(uri)
    end
    if ev == 'compile' then
        local state = files.getLastState(uri)
        if state then
            global.compileAst(state.ast)
            variable.compileAst(state.ast)
        end
    end
end)
