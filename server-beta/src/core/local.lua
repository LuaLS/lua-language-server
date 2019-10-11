local guide = require 'parser.guide'

local m = {}

function m:def(source, callback)
    if source.tag ~= 'self' then
        callback(source, 'local')
    end
    if source.ref then
        for _, ref in ipairs(source.ref) do
            if ref.type == 'setlocal' then
                callback(ref, 'set')
            end
        end
    end
    if source.tag == 'self' then
        local method = source.method
        local node = method.node
        self:eachDef(node, callback)
    end
end

function m:ref(source, callback)
    if source.tag ~= 'self' then
        callback(source, 'local')
    end
    if source.ref then
        for _, ref in ipairs(source.ref) do
            if ref.type == 'setlocal' then
                callback(ref, 'set')
            elseif ref.type == 'getlocal' then
                callback(ref, 'get')
            end
        end
    end
    if source.tag == 'self' then
        local method = source.method
        local node = method.node
        self:eachRef(node, callback)
    end
end

function m:field(source, key, callback)
    local used = {}
    used[source] = true
    local refs = source.ref
    if refs then
        for i = 1, #refs do
            local ref = refs[i]
            if ref.type == 'getlocal' then
                used[ref] = true
                local parent = ref.parent
                if key == guide.getKeyName(parent) then
                    self:childRef(parent, callback)
                end
            elseif ref.type == 'getglobal' then
                used[ref] = true
                if key == guide.getKeyName(ref) then
                    -- _ENV.XXX
                    callback(ref, 'get')
                end
            elseif ref.type == 'setglobal' then
                used[ref] = true
                -- _ENV.XXX = XXX
                if key == guide.getKeyName(ref) then
                    callback(ref, 'set')
                end
            end
        end
    end
    if source.tag == 'self' then
        local method = source.method
        local node = method.node
        self:eachField(node, key, callback)
    end
    self:eachValue(source, function (src)
        if source ~= src then
            self:eachField(src, key, callback)
        end
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
    end)
end

function m:value(source, callback)
    callback(source)
    local refs = source.ref
    if refs then
        for i = 1, #refs do
            local ref = refs[i]
            if ref.type == 'setlocal' then
                self:eachValue(ref.value, callback)
            end
        end
    end
    if source.value then
        self:eachValue(source.value, callback)
    end
end

return m
