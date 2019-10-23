local guide    = require 'parser.guide'
local checkSMT = require 'searcher.setmetatable'

local m = {}

function m:eachDef(source, callback)
    local parent = source.parent
    local key = guide.getKeyName(source)
    self:eachField(parent, key, function (info)
        if info.mode == 'set' then
            callback(info)
        end
    end)
end

function m:eachRef(source, callback)
    local parent = source.parent
    local key = guide.getKeyName(source)
    self:eachField(parent, key, function (info)
        if info.mode == 'set' or info.mode == 'set' then
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
