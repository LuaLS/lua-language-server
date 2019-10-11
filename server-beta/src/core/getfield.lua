local guide    = require 'parser.guide'

local m = {}

function m:field(source, key, callback)
    local used = {}
    used[source] = true
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
                        end
                    end)
                end)
            end
        end)
    end)
    self:eachSpecial(function (name, src)
        local call = src.parent
        if name == 'rawset' then
            local t, k = self:callArgOf(call)
            if used[t] and guide.getKeyName(k) == key then
                callback(call, 'set')
            end
        elseif name == 'rawget' then
            local t, k, v = self:callArgOf(call)
            if used[t] and guide.getKeyName(k) == key then
                callback(call, 'get')
                self:eachField(v, key, callback)
            end
        elseif name == 'setmetatable' then
            local t, mt = self:callArgOf(call)
            if mt then
                self:eachField(mt, 's|__index', function (src, mode)
                    if mode == 'set' then
                        -- t.field -> mt.__index.field
                        if used[t] then
                            self:eachValue(src, function (mtvalue)
                                self:eachField(mtvalue, key, callback)
                            end)
                        end
                        -- mt.__index.field -> t.field
                        self:eachDef(src, function (src)
                            if used[src] then
                                self:eachValue(t, function (mtvalue)
                                    self:eachField(mtvalue, key, callback)
                                end)
                                local obj = self:callReturnOf(call)
                                if obj then
                                    self:eachValue(obj, function (mtvalue)
                                        self:eachField(mtvalue, key, callback)
                                    end)
                                end
                            end
                        end)
                    end
                end)
            end
        end
    end)
end

return m
