local scope = require 'workspace.scope'

---@class SubMgr.Link
---@overload fun():self
---@field sets parser.object[]
---@field gets parser.object[]
local SubMgrLink = Class 'SubMgr.Link'

function SubMgrLink:__call()
    self.sets = {}
    self.gets = {}
    return self
end

---@class SubMgr
---@overload fun():self
---@field private links table<uri, SubMgr.Link>
---@field private setsCache? table<uri, parser.object[]>
local SubMgr = Class 'SubMgr'

function SubMgr:__call()
    self.links = LS.util.multiTable(2, function ()
        return New 'GlobalLink' ()
    end)
    return self
end

-- 向订阅管理器中添加一个订阅者，类型为赋值
---@param uri uri
---@param obj parser.object
function SubMgr:addSet(uri, obj)
    local link = self.links[uri]
    table.insert(link.sets, obj)
    self:clearCache()
end

-- 向订阅管理器中添加一个订阅者，类型为获取
---@param uri uri
---@param obj parser.object
function SubMgr:addGet(uri, obj)
    local link = self.links[uri]
    table.insert(link.gets, obj)
end

---@private
function SubMgr:clearCache()
    self.setsCache = nil
end

---@private
---@param token string
---@return boolean hasCached
---@return parser.object[]
function SubMgr:getSetsCache(token)
    if not self.setsCache then
        self.setsCache = {}
    end
    local cache = self.setsCache[token]
    if cache then
        return true, cache
    end
    if not cache then
        cache = {}
        self.setsCache[token] = cache
    end
    return false, cache
end

-- 获取订阅管理器的所有赋值（基于可见性）
---@param suri uri
---@return parser.object[]
function SubMgr:getSets(suri)
    local scp = scope.getScope(suri)
    local token = scp.uri or '<callback>'
    local hasCached, cache = self:getSetsCache(token)
    if hasCached then
        return cache
    end
    for uri, link in pairs(self.links) do
        if link.sets then
            if scp:isVisible(uri) then
                for _, source in ipairs(link.sets) do
                    cache[#cache+1] = source
                end
            end
        end
    end
    return cache
end

-- 获取订阅管理器的所有赋值
---@return parser.object[]
function SubMgr:getAllSets()
    local hasCached, cache = self:getSetsCache('*')
    if hasCached then
        return cache
    end
    for _, link in pairs(self.links) do
        if link.sets then
            for _, source in ipairs(link.sets) do
                cache[#cache+1] = source
            end
        end
    end
    return cache
end

-- 清空每个路径下的所有订阅者
---@param uri uri
function SubMgr:dropUri(uri)
    self.links[uri] = nil
    self:clearCache()
end

-- 检查是否还有任何订阅者
---@return boolean
function SubMgr:hasAnyLink()
    return next(self.links) ~= nil
end
