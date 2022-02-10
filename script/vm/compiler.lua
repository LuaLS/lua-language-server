local files = require 'files'

---@class vm.compiler
local m = {}

for uri in files.eachFile() do
    local state = files.getState(uri)
    if state then
        --m.compileGlobalNodes(state.ast)
    end
end

files.watch(function (ev, uri)
    if ev == 'update' then
        local state = files.getState(uri)
        if state then
            --m.compileGlobalNodes(state.ast)
        end
    end
    if ev == 'remove' then
        --collector:dropUri(uri)
    end
end)

return m
