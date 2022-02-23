
local files          = require 'files'
local globalManager  = require 'vm.global-manager'
local literalManager = require 'vm.literal-manager'

---@class vm.state
local m = {}
for uri in files.eachFile() do
    local state = files.getState(uri)
    if state then
        globalManager.compileAst(state.ast)
    end
end

files.watch(function (ev, uri)
    if ev == 'update' then
        local state = files.getState(uri)
        if state then
            globalManager.compileAst(state.ast)
        end
    end
    if ev == 'remove' then
        globalManager.dropUri(uri)
        literalManager.dropUri(uri)
    end
end)


return m
