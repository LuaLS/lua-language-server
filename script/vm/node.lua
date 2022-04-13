local files    = require 'files'
local localMgr = require 'vm.local-manager'
---@class vm
local vm       = require 'vm.vm'

---@type table<vm.object, vm.node>
vm.nodeCache = {}

---@class vm.node
local mt = {}
mt.__index   = mt
mt.type      = 'vm.node'
mt.optional  = nil
mt.lastInfer = nil

---@param node vm.node | vm.object
function mt:merge(node)
    if not node then
        return
    end
    if node.type == 'vm.node' then
        for _, c in ipairs(node) do
            if not self[c] then
                self[c]       = true
                self[#self+1] = c
            end
        end
        if node:isOptional() then
            self.optional = true
        end
    else
        if not self[node] then
            self[node]    = true
            self[#self+1] = node
        end
    end
end

---@return vm.node
function mt:copy()
    return vm.createNode(self)
end

---@return boolean
function mt:isEmpty()
    return #self == 0
end

function mt:addOptional()
    if self:isOptional() then
        return self
    end
    self.optional = true
end

function mt:removeOptional()
    if not self:isOptional() then
        return self
    end
    for i = #self, 1, -1 do
        local n = self[i]
        if n.type == 'nil'
        or (n.type == 'boolean' and n[1] == false)
        or (n.type == 'doc.type.boolean' and n[1] == false) then
            self[i] = self[#self]
            self[#self] = nil
        end
    end
end

---@return boolean
function mt:isOptional()
    if self.optional ~= nil then
        return self.optional
    end
    for _, c in ipairs(self) do
        if c.type == 'nil'
        or (c.type == 'boolean' and c[1] == false)
        or (c.type == 'doc.type.boolean' and c[1] == false) then
            self.optional = true
            return true
        end
    end
    self.optional = false
    return false
end

---@return fun():vm.object
function mt:eachObject()
    local i = 0
    return function ()
        i = i + 1
        return self[i]
    end
end

---@param source vm.object
---@param node vm.node | vm.object
---@param cover? boolean
function vm.setNode(source, node, cover)
    if not node then
        error('Can not set nil node')
    end
    if cover then
        vm.nodeCache[source] = node
        return
    end
    local me = vm.nodeCache[source]
    if not me then
        if node.type == 'vm.node' then
            vm.nodeCache[source] = node
        else
            vm.nodeCache[source] = vm.createNode(node)
        end
        return
    end
    vm.nodeCache[source] = vm.createNode(me, node)
end

---@return vm.node?
function vm.getNode(source)
    return vm.nodeCache[source]
end

function vm.clearNodeCache()
    vm.nodeCache = {}
end

---@param a? vm.node | vm.object
---@param b? vm.node | vm.object
---@return vm.node
function vm.createNode(a, b)
    local node = setmetatable({}, mt)
    if a then
        node:merge(a)
    end
    if b then
        node:merge(b)
    end
    return node
end

files.watch(function (ev, uri)
    if ev == 'version' then
        vm.clearNodeCache()
    end
end)
