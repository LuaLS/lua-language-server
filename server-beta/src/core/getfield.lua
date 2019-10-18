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
        local child, mode = self:childMode(src)
        if child then
            if key == guide.getKeyName(child) then
                callback(child, mode)
            end
            return
        end
        if src.type == 'getglobal' then
            local parent = src.parent
            child, mode = self:childMode(parent)
            if child then
                if key == guide.getKeyName(child) then
                    callback(child, mode)
                end
            end
        elseif src.type == 'setglobal' then
            local parent = src.parent
            child, mode = self:childMode(parent)
            if child then
                if key == guide.getKeyName(child) then
                    callback(child, mode)
                end
            end
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
