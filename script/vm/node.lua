local union      = require 'vm.union'
local files      = require 'files'

---@alias vm.node vm.union
---@alias vm.object parser.object | vm.global | vm.generic

---@class vm.node-manager
local m = {}

local DUMMY_FUNCTION = function () end

---@type table<vm.object, vm.node>
m.nodeCache = {}

---@param a vm.node
---@param b vm.node
function m.mergeNode(a, b)
    if not b then
        return a
    end
    if not a then
        return b
    end
    return union(a, b)
end

---@param source vm.object
---@param node vm.node
---@param cover? boolean
function m.setNode(source, node, cover)
    if cover then
        m.nodeCache[source] = node
        return
    end
    if not node then
        return
    end
    local me = m.nodeCache[source]
    if not me then
        if node.type == 'vm.union' then
            m.nodeCache[source] = node
        else
            m.nodeCache[source] = union(node)
        end
        return
    end
    m.nodeCache[source] = union(me, node)
end

---@return vm.node?
function m.getNode(source)
    return m.nodeCache[source]
end

---@param node vm.node?
---@return vm.node
function m.addOptional(node)
    if not node or node.type ~= 'vm.union' then
        node = union(node)
    end
    node = node:addOptional()
    return node
end

---@param node vm.node?
---@return vm.union?
function m.removeOptional(node)
    if not node then
        return node
    end
    if node.type ~= 'vm.union' then
        node = union(node)
    end
    node = node:removeOptional()
    return node
end

---@return fun():vm.object
function m.eachObject(node)
    if not node then
        return DUMMY_FUNCTION
    end
    if node.type == 'vm.union' then
        return node:eachNode()
    end
    local first = true
    return function ()
        if first then
            first = false
            return node
        end
        return nil
    end
end

function m.clearNodeCache()
    m.nodeCache = {}
end

files.watch(function (ev, uri)
    if ev == 'version' then
        m.clearNodeCache()
    end
end)

return m
