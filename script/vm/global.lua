local util = require 'utility'

---@class vm.node.global.link
---@field gets   parser.object[]
---@field sets   parser.object[]

---@class vm.node.global
---@field links table<uri, vm.node.global.link>
---@field setsCache parser.object[]
---@field getsCache parser.object[]
---@field cate vm.global.cate
local mt = {}
mt.__index = mt
mt.type = 'global'
mt.name = ''

---@param uri    uri
---@param source parser.object
function mt:addSet(uri, source)
    local link = self.links[uri]
    link.sets[#link.sets+1] = source
    self.setsCache = nil
end

---@param uri    uri
---@param source parser.object
function mt:addGet(uri, source)
    local link = self.links[uri]
    link.gets[#link.gets+1] = source
    self.getsCache = nil
end

---@return parser.object[]
function mt:getSets()
    if not self.setsCache then
        self.setsCache = {}
        for _, link in pairs(self.links) do
            for _, source in ipairs(link.sets) do
                self.setsCache[#self.setsCache+1] = source
            end
        end
    end
    return self.setsCache
end

---@return parser.object[]
function mt:getGets()
    if not self.getsCache then
        self.getsCache = {}
        for _, link in pairs(self.links) do
            for _, source in ipairs(link.gets) do
                self.getsCache[#self.getsCache+1] = source
            end
        end
    end
    return self.getsCache
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

---@return boolean
function mt:isAlive()
    return next(self.links) ~= nil
end

---@param cate vm.global.cate
---@return vm.node.global
return function (name, cate)
    return setmetatable({
        name  = name,
        cate  = cate,
        links = util.defaultTable(function ()
            return {
                sets   = {},
                gets   = {},
            }
        end),
    }, mt)
end
