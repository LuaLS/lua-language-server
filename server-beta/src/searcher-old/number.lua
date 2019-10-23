local guide    = require 'parser.guide'

local m = {}

function m:eachDef(source, callback)
    local parent = source.parent
    if not parent then
        return
    end
    if parent.type ~= 'setindex' and parent.type ~= 'getindex' then
        return
    end
    local node = parent.node
    local key = guide.getKeyName(source)
    self:eachField(node, key, function (info)
        if info.mode == 'set' then
            callback(info)
        end
    end)
end

function m:eachRef(source, callback)
    local parent = source.parent
    if not parent then
        return
    end
    if parent.type ~= 'setindex' and parent.type ~= 'getindex' then
        return
    end
    local node = parent.node
    local key = guide.getKeyName(source)
    self:eachField(node, key, function (info)
        if info.mode == 'set' or info.mode == 'get' then
            callback(info)
        end
    end)
end

function m:getValue(source)
    return source
end

return m
