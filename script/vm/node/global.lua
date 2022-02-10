local util = require 'utility'

---@class vm.node.global
---@field links table<uri, { gets: table, sets: table }>
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

function mt:dropUri(uri)
    self.links[uri] = nil
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
