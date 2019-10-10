local guide = require 'parser.guide'

local m = {}

function m:def(source, callback)
    local node = source.parent.node
    local key = guide.getKeyName(source)
    self:eachField(node, key, 'def', callback)
end

function m:ref(source, callback)
    local node = source.parent.node
    local key = guide.getKeyName(source)
    self:eachField(node, key, 'ref', callback)
end

function m:field(source, callback)
    local node = source.parent.node
    local key = guide.getKeyName(source)
    self:eachField(node, key, 'field', callback)
end

return m
