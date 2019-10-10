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

function m:field(source, key, callback)
    local global = guide.getKeyName(source)
    self:eachField(source.node, global, function (src, mode)
        if mode == 'get' then
            local parent = src.parent
            if key == guide.getKeyName(parent) then
                local tp = parent.type
                if     tp == 'getfield' then
                    callback(parent.field, 'get')
                elseif tp == 'getmethod' then
                    callback(parent.method, 'get')
                elseif tp == 'getindex' then
                    callback(parent.index, 'get')
                elseif tp == 'setfield' then
                    callback(parent.field, 'set')
                elseif tp == 'setmethod' then
                    callback(parent.method, 'set')
                elseif tp == 'setindex' then
                    callback(parent.index, 'set')
                end
            end
        end
    end)
end

return m
