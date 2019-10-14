local guide    = require 'parser.guide'
local checkSMT = require 'core.setmetatable'

local m = {}

function m:field(source, key, callback)
    local used = {}
    local found = false
    used[source] = true

    local node = source.node
    used[node] = true

    callback(source.field, 'set')
    local myKey = guide.getKeyName(source)
    self:eachField(node, myKey, function (src, mode)
        if used[src] then
            return
        end
        used[src] = true
        self:eachField(src, key, function (src, mode)
            used[src] = true
            if mode == 'set' then
                callback(src, mode)
                found = true
            end
        end)
    end)

    self:eachValue(node, function (src)
        self:eachField(src, myKey, function (src, mode)
            if used[src] then
                return
            end
            used[src] = true
            self:eachField(src, key, function (src, mode)
                used[src] = true
                if mode == 'set' then
                    callback(src, mode)
                    found = true
                end
            end)
        end)
    end)

    checkSMT(self, key, used, found, callback)
end

return m
