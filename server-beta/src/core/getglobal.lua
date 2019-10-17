local guide    = require 'parser.guide'
local checkSMT = require 'core.setmetatable'

local m = {}

function m:def(source, callback)
    -- _ENV
    local key = guide.getKeyName(source)
    self:eachField(source.node, key, function (src, mode)
        if mode == 'set' then
            callback(src, mode)
        end
    end)
    self:eachSpecial(function (name, src)
        if name == '_G' then
            local parent = src.parent
            if guide.getKeyName(parent) == key then
                callback(parent, 'set')
            end
        elseif name == 'rawset' then
            local t, k = self:callArgOf(src.parent)
            if self:getSpecialName(t) == '_G'
            and guide.getKeyName(k) == key then
                callback(src.parent, 'set')
            end
        end
    end)
end

function m:ref(source, callback)
    -- _ENV
    local key = guide.getKeyName(source)
    self:eachField(source.node, key, function (src, mode)
        if mode == 'set' or mode == 'get' then
            callback(src, mode)
        end
    end)
    self:eachSpecial(function (name, src)
        if name == '_G' then
            local parent = src.parent
            if guide.getKeyName(parent) == key then
                if parent.type:sub(1, 3) == 'set' then
                    callback(parent, 'set')
                else
                    callback(parent, 'get')
                end
            end
        elseif name == 'rawset' then
            local t, k = self:callArgOf(src.parent)
            if self:getSpecialName(t) == '_G'
            and guide.getKeyName(k) == key then
                callback(src.parent, 'set')
            end
        elseif name == 'rawget' then
            local t, k = self:callArgOf(src.parent)
            if self:getSpecialName(t) == '_G'
            and guide.getKeyName(k) == key then
                callback(src.parent, 'get')
            end
        end
    end)
end

function m:field(source, key, callback)
    local used = {}
    local found = false
    used[source] = true

    local parent = source.parent
    self:eachField(parent, key, callback)

    local node = source.node
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

function m:value(source, callback)
    callback(source)
end

return m
