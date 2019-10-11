local guide = require 'parser.guide'

local m = {}

function m:def(source, callback)
    local parent = source.parent
    if parent.type == 'setfield' or parent.type == 'getfield' then
        local node = parent.node
        local key = guide.getKeyName(source)
        self:eachField(node, key, function (src, mode)
            if mode == 'set' then
                callback(src, mode)
            end
        end)
    elseif parent.type == 'tablefield' then
        self:eachDef(parent.value, callback)
    end
end

function m:ref(source, callback)
    local parent = source.parent
    if parent.type == 'setfield' or parent.type == 'getfield' then
        local node = parent.node
        local key = guide.getKeyName(source)
        self:eachField(node, key, function (src, mode)
            if mode == 'set' or mode == 'get' then
                callback(src, mode)
            end
        end)
    elseif parent.type == 'tablefield' then
        self:eachDef(parent.value, callback)
    end
end

function m:value(source, callback)
    local parent = source.parent
    if parent.type == 'setfield'
    or parent.type == 'tablefield' then
        if parent.value then
            self:eachValue(parent.value, callback)
        end
    end
end

return m
