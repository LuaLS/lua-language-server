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
    self:eachSpecial(function (name, src)
        if name == '_G' then
            local parent = src.parent
            if guide.getKeyName(parent) == key then
                self:childDef(parent, callback)
            end
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
    self:eachSpecial(function (name, src)
        if name == '_G' then
            local parent = src.parent
            if guide.getKeyName(parent) == key then
                self:childRef(parent, callback)
            end
        end
    end)
end

function m:field(source, key, callback)
    local global = guide.getKeyName(source)
    self:eachField(source.node, global, function (src, mode)
        if mode == 'get' then
            local parent = src.parent
            if key == guide.getKeyName(parent) then
                self:childRef(parent)
            end
        end
    end)
end

return m
