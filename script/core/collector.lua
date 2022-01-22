local scope = require 'workspace.scope'

---@class collector
---@field subscribed table<uri, table<string, any>>
---@field collect table<string, table<uri, any>>
local mt = {}
mt.__index = mt

--- 订阅一个名字
---@param uri uri
---@param name string
---@param value any
function mt:subscribe(uri, name, value)
    uri = uri or '<fallback>'
    -- 订阅部分
    local uriSubscribed = self.subscribed[uri]
    if not uriSubscribed then
        uriSubscribed = {}
        self.subscribed[uri] = uriSubscribed
    end
    uriSubscribed[name] = true
    -- 收集部分
    local nameCollect = self.collect[name]
    if not nameCollect then
        nameCollect = {}
        self.collect[name] = nameCollect
    end
    if value == nil then
        value = true
    end
    nameCollect[uri] = value
end

--- 丢弃掉某个 uri 中收集的所有信息
---@param uri uri
function mt:dropUri(uri)
    uri = uri or '<fallback>'
    local uriSubscribed = self.subscribed[uri]
    if not uriSubscribed then
        return
    end
    self.subscribed[uri] = nil
    for name in pairs(uriSubscribed) do
        self.collect[name][uri] = nil
        if not next(self.collect[name]) then
            self.collect[name] = nil
        end
    end
end

function mt:dropAll()
    self.subscribed = {}
    self.collect    = {}
end

--- 是否包含某个名字的订阅
---@param uri uri
---@param name string
---@return boolean
function mt:has(uri, name)
    if self:each(uri, name)() then
        return true
    else
        return false
    end
end

local DUMMY_FUNCTION = function () end

---@param scp scope
local function eachOfFolder(nameCollect, scp)
    local curi, value

    local function getNext()
        curi, value = next(nameCollect, curi)
        if not curi then
            return nil, nil
        end
        if scp:isChildUri(curi)
        or scp:isLinkedUri(curi) then
            return value, curi
        end
        return getNext()
    end

    return getNext
end

---@param scp scope
local function eachOfLinked(nameCollect, scp)
    local curi, value

    local function getNext()
        curi, value = next(nameCollect, curi)
        if not curi then
            return nil, nil
        end
        if  scp:isChildUri(curi)
        and scp:isLinkedUri(curi) then
            return value, curi
        end

        local cscp =   scope.getFolder(curi)
                    or scope.getLinkedScope(curi)
                    or scope.fallback

        if cscp == scp
        or cscp:isChildUri(scp.uri)
        or cscp:isLinkedUri(scp.uri) then
            return value, curi
        end

        return getNext()
    end

    return getNext
end

---@param scp scope
local function eachOfFallback(nameCollect, scp)
    local curi, value

    local function getNext()
        curi, value = next(nameCollect, curi)
        if not curi then
            return nil, nil
        end
        if scp:isLinkedUri(curi) then
            return value, curi
        end

        local cscp =   scope.getFolder(curi)
                    or scope.getLinkedScope(curi)
                    or scope.fallback

        if cscp == scp then
            return value, curi
        end

        return getNext()
    end

    return getNext
end

--- 迭代某个名字的订阅
---@param uri  uri
---@param name string
function mt:each(uri, name)
    uri = uri or '<fallback>'
    local nameCollect = self.collect[name]
    if not nameCollect then
        return DUMMY_FUNCTION
    end

    local scp = scope.getFolder(uri)

    if scp then
        return eachOfFolder(nameCollect, scp)
    end

    scp = scope.getLinkedScope(uri)

    if scp then
        return eachOfLinked(nameCollect, scp)
    end

    return eachOfFallback(nameCollect, scope.fallback)
end

local collectors = {}

local function new()
    return setmetatable({
        collect    = {},
        subscribed = {},
    }, mt)
end

---@return collector
return function (name)
    if name then
        collectors[name] = collectors[name] or new()
        return collectors[name]
    else
        return new()
    end
end
