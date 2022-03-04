local util       = require 'utility'
local guide      = require 'parser.guide'

---@class vm.local-node
local m = {}
---@type table<uri, parser.object[]>
m.locals = util.multiTable(2)
---@type table<parser.object, table<parser.object, boolean>>
m.localSubs = util.multiTable(2, function ()
    return setmetatable({}, util.MODE_K)
end)
---@type table<parser.object, boolean>
m.allLocals = {}

---@param source parser.object
function m.declareLocal(source)
    if m.allLocals[source] then
        return
    end
    m.allLocals[source] = true
    local uri = guide.getUri(source)
    local locals = m.locals[uri]
    locals[#locals+1] = source
end

---@param source parser.object
---@param node   vm.node
function m.subscribeLocal(source, node)
    if not node then
        return
    end
    if node.type == 'union' then
        node:subscribeLocal(source)
        return
    end
    if not m.allLocals[node] then
        return
    end
    m.localSubs[node][source] = true
end

---@param uri uri
function m.dropUri(uri)
    local locals = m.locals[uri]
    m.locals[uri] = nil
    for _, loc in ipairs(locals) do
        m.allLocals[loc] = nil
        local localSubs = m.localSubs[loc]
        m.localSubs[loc] = nil
        for source in pairs(localSubs) do
            source._node = nil
        end
    end
end

return m
