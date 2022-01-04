local scope = require 'workspace.scope'
local ws    = require 'workspace'

local collect    = {}
local subscribed = {}

local m = {}

--- 订阅一个名字
---@param uri uri
---@param name string
---@param value any
function m.subscribe(uri, name, value)
    -- 订阅部分
    local uriSubscribed = subscribed[uri]
    if not uriSubscribed then
        uriSubscribed = {}
        subscribed[uri] = uriSubscribed
    end
    uriSubscribed[name] = true
    -- 收集部分
    local nameCollect = collect[name]
    if not nameCollect then
        nameCollect = {}
        collect[name] = nameCollect
    end
    if value == nil then
        value = true
    end
    nameCollect[uri] = value
end

--- 丢弃掉某个 uri 中收集的所有信息
---@param uri uri
function m.dropUri(uri)
    local uriSubscribed = subscribed[uri]
    if not uriSubscribed then
        return
    end
    subscribed[uri] = nil
    for name in pairs(uriSubscribed) do
        collect[name][uri] = nil
    end
end

--- 是否包含某个名字的订阅
---@param name string
---@return boolean
function m.has(name)
    local nameCollect = collect[name]
    if not nameCollect then
        return false
    end
    if next(nameCollect) == nil then
        collect[name] = nil
        return false
    end
    return true
end

local DUMMY_FUNCTION = function () end

--- 迭代某个名字的订阅
---@param uri  uri
---@param name string
function m.each(uri, name)
    local nameCollect = collect[name]
    if not nameCollect then
        return DUMMY_FUNCTION
    end
    ---@type scope
    local scp = scope.getFolder(uri)
            or  scope.getLinkedScope(uri)
            or  scope.fallback

    local curi, value
    local function getNext()
        curi, value = next(nameCollect, curi)
        if not curi then
            return nil, nil
        end
        if  not scp:isChildUri(curi)
        and not scp:isLinkedUri(curi) then
            return getNext()
        end

        return value, curi
    end
    return getNext
end

--- 迭代某个名字的引用订阅
---@param uri  uri
---@param name string
function m.eachRef(uri, name)
    local nameCollect = collect[name]
    if not nameCollect then
        return DUMMY_FUNCTION
    end
    ---@type scope
    if scope.getFolder(uri) then
        return m.each(uri, name)
    end

    local curi, value
    local function getNext()
        curi, value = next(nameCollect, curi)
        if not curi then
            return nil, nil
        end

        return value, curi
    end
    return getNext
end

return m
