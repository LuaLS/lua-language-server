local util = require 'utility'

---@class vm.node.global
---@field links table<uri, { gets: table, sets: table }>
---@field setsCache parser.guide.object[]
---@field getsCache parser.guide.object[]
local mt = {}
mt.__index = mt
mt.type = 'global'
mt.name = ''

function mt:addSet(uri, source)
    local link = self.links[uri]
    link.sets[#link.sets+1] = source
end

function mt:addGet(uri, source)
    local link = self.links[uri]
    link.gets[#link.gets+1] = source
end

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

function mt:dropUri(uri)
    self.links[uri] = nil
    self.setsCache = nil
    self.getsCache = nil
end

---@return vm.node.global
return function (name)
    local global = setmetatable({
        name  = name,
        links = util.defaultTable(function ()
            return {
                sets = {},
                gets = {},
            }
        end),
    }, mt)
    return global
end
