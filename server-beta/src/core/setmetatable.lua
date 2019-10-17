local guide    = require 'parser.guide'

return function (self, key, used, found, callback)
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
        elseif name == 'setmetatable' and not found then
            -- 如果已经找到值，则不检查meta表
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
                        self:eachValue(src, function (src)
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
