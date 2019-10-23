local guide    = require 'parser.guide'

local m = {}

function m:eachDef(source, callback)
    local node = source.parent.node
    local key = guide.getKeyName(source)
    self:eachField(node, key, function (info)
        if info.mode == 'set' then
            callback(info)
        end
    end)
end

function m:eachRef(source, callback)
    local node = source.parent.node
    local key = guide.getKeyName(source)
    self:eachField(node, key, function (info)
        if info.mode == 'set' or info.mode == 'get' then
            callback(info)
        end
    end)
end

function m:eachField(source, key, callback)
    self:eachField(source.parent, key, callback)
end

function m:eachValue(source, callback)
    self:eachValue(source.parent, callback)
end

return m
