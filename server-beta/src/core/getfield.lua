local guide    = require 'parser.guide'
local checkSMT = require 'core.setmetatable'

local m = {}

function m:ref(source, callback)
    local key = guide.getKeyName(source)
    self:eachField(source.node, key, function (src, mode)
        if mode == 'set' or mode == 'get' then
            callback(src, mode)
        end
    end)
end

function m:field(source, key, callback)
    local used = {}
    local found = false
    used[source] = true

    self:eachRef(source, function (src)
        used[src] = true
        if     src.type == 'getfield' then
            if guide.getKeyName(src.field) == key then
                callback(src.field, 'get')
            end
        elseif src.type == 'setfield' then
            if guide.getKeyName(src.field) == key then
                callback(src.field, 'set')
            end
        elseif src.type == 'getmethod' then
            if guide.getKeyName(src.method) == key then
                callback(src.method, 'get')
            end
        elseif src.type == 'setmethod' then
            if guide.getKeyName(src.method) == key then
                callback(src.method, 'set')
            end
        elseif src.type == 'getindex' then
            if guide.getKeyName(src.index) == key then
                callback(src.index, 'get')
            end
        elseif src.type == 'setindex' then
            if guide.getKeyName(src.index) == key then
                callback(src.index, 'set')
            end
        elseif src.type == 'getglobal' then
            if guide.getKeyName(src.parent) == key then
                callback(src.parent, 'get')
            end
        elseif src.type == 'setglobal' then
            --if guide.getKeyName(src.parent) == key then
            --    callback(src.parent, 'set')
            --end
        else
            self:eachField(src, key, callback)
        end
    end)

    checkSMT(self, key, used, found, callback)
end

function m:value(source, callback)
    if source.value then
        self:eachValue(source.value, callback)
    end
end

return m
