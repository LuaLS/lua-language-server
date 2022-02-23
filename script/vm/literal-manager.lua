local util       = require 'utility'
local guide      = require 'parser.guide'

---@class vm.literal-node
local m = {}
---@type table<uri, parser.object[]>
m.literals = util.multiTable(2)
---@type table<parser.object, table<parser.object, boolean>>
m.literalSubs = util.multiTable(2, function ()
    return setmetatable({}, util.MODE_K)
end)
---@type table<parser.object, boolean>
m.allLiterals = {}

---@param source parser.object
function m.declareLiteral(source)
    if m.allLiterals[source] then
        return
    end
    m.allLiterals[source] = true
    local uri = guide.getUri(source)
    local literals = m.literals[uri]
    literals[#literals+1] = source
end

---@param source parser.object
---@param node   vm.node
function m.subscribeLiteral(source, node)
    if not node then
        return
    end
    if node.type == 'union'
    or node.type == 'cross' then
        node:subscribeLiteral(source)
        return
    end
    if not m.allLiterals[source] then
        return
    end
    m.literalSubs[node][source] = true
end

---@param uri uri
function m.dropUri(uri)
    local literals = m.literals[uri]
    m.literals[uri] = nil
    for _, literal in ipairs(literals) do
        m.allLiterals[literal] = nil
        local literalSubs = m.literalSubs[literal]
        m.literalSubs[literal] = nil
        for source in pairs(literalSubs) do
            source._node = nil
        end
    end
end

return m
