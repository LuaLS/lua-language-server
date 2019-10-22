local guide    = require 'parser.guide'
local checkSMT = require 'seacher.setmetatable'

local m = {}

function m:eachDef(source, callback)
    local parent = source.parent
    local key = guide.getKeyName(source)
    self:eachField(parent, key, function (src, mode)
        if mode == 'set' then
            callback(src, mode)
        end
    end)
end

function m:eachRef(source, callback)
    local parent = source.parent
    local key = guide.getKeyName(source)
    self:eachField(parent, key, function (src, mode)
        if mode == 'set' or mode == 'set' then
            callback(src, mode)
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
