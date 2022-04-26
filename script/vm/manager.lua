
local files          = require 'files'
local globalManager  = require 'vm.global-manager'

---@alias vm.object parser.object | vm.global | vm.generic

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
        globalManager.dropUri(uri)
        local state = files.getState(uri)
        if state then
            globalManager.compileAst(state.ast)
        end
    end
    if ev == 'remove' then
        globalManager.dropUri(uri)
    end
end)

return m
