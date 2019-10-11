local guide    = require 'parser.guide'
local checkSMT = require 'core.setmetatable'

local m = {}

function m:field(source, key, callback)
    local used = {}
    used[source] = true
    local found = false
    local node = source.node
    local myKey = guide.getKeyName(source)
    self:eachValue(node, function (src)
        self:eachField(src, myKey, function (src, mode)
            if mode == 'set' then
                self:eachValue(src, function (src)
                    self:eachField(src, key, function (src, mode)
                        if key == guide.getKeyName(src) then
                            used[src] = true
                            callback(src, mode)
                            if mode == 'set' then
                                found = true
                            end
                        end
                    end)
                end)
            end
        end)
    end)
    checkSMT(self, key, used, found, callback)
end

return m
