local files    = require 'files'
local globalModule = require 'vm.global'
local variable = require 'vm.variable'

---@async
files.watch(function (ev, uri)
    if ev == 'update' then
        globalModule.dropUri(uri)
    end
    if ev == 'remove' then
        globalModule.dropUri(uri)
    end
    if ev == 'compile' then
        local state = files.getLastState(uri)
        if state then
            globalModule.compileAst(state.ast)
            variable.compileAst(state.ast)
        end
    end
end)
