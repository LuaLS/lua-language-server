
local files       = require 'files'
local globalNode  = require 'vm.global-node'
local literalNode = require 'vm.literal-node'

---@class vm.state
local m = {}
for uri in files.eachFile() do
    local state = files.getState(uri)
    if state then
        globalNode.compileAst(state.ast)
    end
end

files.watch(function (ev, uri)
    if ev == 'update' then
        local state = files.getState(uri)
        if state then
            globalNode.compileAst(state.ast)
        end
    end
    if ev == 'remove' then
        globalNode.dropUri(uri)
        literalNode.dropUri(uri)
    end
end)


return m
