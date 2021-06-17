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
---@param name string
function m.each(name)
    local nameCollect = collect[name]
    if not nameCollect then
        return DUMMY_FUNCTION
    end
    local uri, value
    return function ()
        uri, value = next(nameCollect, uri)
        return value, uri
    end
end

return m
