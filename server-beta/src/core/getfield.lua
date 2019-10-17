local guide    = require 'parser.guide'
local checkSMT = require 'core.setmetatable'

local m = {}

function m:field(source, key, callback)
    local used = {}
    local found = false
    used[source] = true

    local node = source.node
    local myKey = guide.getKeyName(node)

    if myKey == key then
        callback(source)
    end

    self:eachDef(node, function (src)
        if myKey ~= key then
            return
        end
        used[src] = true
        if     node.type == 'setfield'
        or     node.type == 'setindex'
        or     node.type == 'setmethod' then
            callback(src, 'set')
        elseif node.type == 'getfield'
        or     node.type == 'getindex'
        or     node.type == 'getmethod' then
            callback(src, 'get')
        end
    end)
    self:eachValue(node, function (src)
        self:eachField(src, key, function (src, mode)
            if used[src] then
                return
            end
            used[src] = true
            if mode == 'set' then
                callback(src, mode)
                found = true
            end
        end)
    end)

    checkSMT(self, key, used, found, callback)
end

function m:value(source, callback)
    if source.value then
        self:eachValue(source.value, callback)
    end
end

return m
