local guide    = require 'parser.guide'

local function checkIndex(info, key, t, used, call, callback)
    if info.mode ~= 'set' then
        return
    end
    local src = info.source
    -- t.field -> mt.__index.field
    if used[t] then
        info.searcher:eachValue(src, function (info)
            info.searcher:eachField(info.source, key, callback)
        end)
    end
    -- mt.__index.field -> t.field
    info.searcher:eachValue(src, function (info)
        local value = info.source
        if used[value] then
            info.searcher:eachValue(t, function (info)
                info.searcher:eachField(info.source, key, callback)
            end)
            local obj = info.searcher:callReturnOf(call)
            if obj then
                info.searcher:eachValue(obj, function (info)
                    info.searcher:eachField(info.source, key, callback)
                end)
            end
        end
    end)
end

return function (self, key, used, found, callback)
    self:eachSpecial(function (name, src)
        local call = src.parent
        if name == 'rawset' then
            local t, k = self:callArgOf(call)
            if used[t] and guide.getKeyName(k) == key then
                callback {
                    source = call,
                    uri    = self.uri,
                    mode   = 'set',
                }
            end
        elseif name == 'rawget' then
            local t, k, v = self:callArgOf(call)
            if used[t] and guide.getKeyName(k) == key then
                callback {
                    source = call,
                    uri    = self.uri,
                    mode   = 'get',
                }
                self:eachField(v, key, callback)
            end
        elseif name == 'setmetatable' and not found then
            -- 如果已经找到值，则不检查meta表
            local t, mt = self:callArgOf(call)
            if mt then
                self:eachField(mt, 's|__index', function (info)
                    checkIndex(info, key, t, used, call, callback)
                end)
            end
        end
    end)
end
