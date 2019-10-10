local guide    = require 'parser.guide'

local m = {}

function m:def(source, callback)
    -- _ENV
    local key = guide.getKeyName(source)
    self:eachField(source.node, key, function (src, mode)
        if mode == 'set' then
            callback(src, mode)
        end
    end)
end

function m:ref(source, callback)
    -- _ENV
    local key = guide.getKeyName(source)
    self:eachField(source.node, key, function (src, mode)
        if mode == 'set' or mode == 'get' then
            callback(src, mode)
        end
    end)
end

function m:field(source, callback)
    self:search(source, 'getglobal', 'ref', function (src)
        local parent = src.parent
        local tp     = parent.type
        if tp == 'setfield'
        or tp == 'getfield'
        or tp == 'setmethod'
        or tp == 'getmethod'
        or tp == 'setindex'
        or tp == 'getindex' then
            callback(parent)
        end
    end)
end

return m
