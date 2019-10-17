local guide    = require 'parser.guide'
local checkSMT = require 'core.setmetatable'

local m = {}

function m:field(source, key, callback)
    local used = {}
    local found = false
    used[source] = true

    local node = source.node
    used[node] = true

    local myKey = guide.getKeyName(source)
    if key == myKey then
        callback(source, 'set')
    end

    self:eachField(node, myKey, function (src, mode)
        self:eachField(src, key, function (src, mode)
            if used[src] then
                return
            end
            used[src] = true
            if mode == 'set' then
                callback(src, mode)
                found = true
            end
        end)
    end)

    self:eachValue(node, function (src)
        self:eachField(src, key, function (src, mode)
            if used[src] then
                return
            end
            used[src] = true
            if mode == 'set' then
                callback(src, mode)
                found = true
            end
        end)
    end)

    checkSMT(self, key, used, found, callback)
end

return m
