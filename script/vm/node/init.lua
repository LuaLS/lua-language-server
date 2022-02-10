local files    = require 'files'
local compiler = require 'vm.node.compiler'
local vmState  = require 'vm.state'

for uri in files.eachFile() do
    local state = files.getState(uri)
    if state then
        compiler.compileGlobals(state.ast)
    end
end

files.watch(function (ev, uri)
    if ev == 'update' then
        local state = files.getState(uri)
        if state then
            compiler.compileGlobals(state.ast)
        end
    end
    if ev == 'remove' then
        vmState.dropUri(uri)
    end
end)
