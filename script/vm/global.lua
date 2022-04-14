local util = require 'utility'
local scope= require 'workspace.scope'

---@class vm.global.link
---@field gets   parser.object[]
---@field sets   parser.object[]

---@class vm.global
---@field links table<uri, vm.global.link>
---@field setsCache table<uri, parser.object[]>
---@field getsCache table<uri, parser.object[]>
---@field cate vm.global.cate
local mt = {}
mt.__index = mt
mt.type = 'global'
mt.name = ''

local ID_SPLITE = '\x1F'

---@param uri    uri
---@param source parser.object
function mt:addSet(uri, source)
    local link = self.links[uri]
    if not link.sets then
        link.sets = {}
    end
    link.sets[#link.sets+1] = source
    self.setsCache = nil
end

---@param uri    uri
---@param source parser.object
function mt:addGet(uri, source)
    local link = self.links[uri]
    if not link.gets then
        link.gets = {}
    end
    link.gets[#link.gets+1] = source
    self.getsCache = nil
end

---@return parser.object[]
function mt:getSets(suri)
    if not self.setsCache then
        self.setsCache = {}
    end
    local scp = scope.getScope(suri)
    local cacheUri = scp.uri or '<callback>'
    if self.setsCache[cacheUri] then
        return self.setsCache[cacheUri]
    end
    self.setsCache[cacheUri] = {}
    local cache = self.setsCache[cacheUri]
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

---@return parser.object[]
function mt:getGets(suri)
    if not self.getsCache then
        self.getsCache = {}
    end
    local scp = scope.getScope(suri)
    local cacheUri = scp.uri or '<callback>'
    if self.getsCache[cacheUri] then
        return self.getsCache[cacheUri]
    end
    self.getsCache[cacheUri] = {}
    local cache = self.getsCache[cacheUri]
    for uri, link in pairs(self.links) do
        if link.gets then
            if scp:isVisible(uri) then
                for _, source in ipairs(link.gets) do
                    cache[#cache+1] = source
                end
            end
        end
    end
    return cache
end

---@param uri uri
function mt:dropUri(uri)
    self.links[uri] = nil
    self.setsCache = nil
    self.getsCache = nil
end

---@return string
function mt:getName()
    return self.name
end

---@return string
function mt:asKeyName()
    return self.cate .. '|' .. self.name
end

---@return string
function mt:getKeyName()
    return self.name:match('[^' .. ID_SPLITE .. ']+$')
end

---@return boolean
function mt:isAlive()
    return next(self.links) ~= nil
end

---@param cate vm.global.cate
---@return vm.global
return function (name, cate)
    return setmetatable({
        name  = name,
        cate  = cate,
        links = util.multiTable(2),
    }, mt)
end
