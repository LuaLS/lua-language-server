local files    = require 'files'
---@class vm
local vm       = require 'vm.vm'
local ws       = require 'workspace.workspace'

---@type table<vm.object, vm.node>
vm.nodeCache = {}

---@class vm.node
local mt = {}
mt.__index    = mt
mt.type       = 'vm.node'
mt.optional   = nil
mt.lastInfer  = nil
mt.data       = nil

---@param node vm.node | vm.object
function mt:merge(node)
    if not node then
        return
    end
    if node.type == 'vm.node' then
        if node == self then
            return
        end
        if node:isOptional() then
            self.optional = true
        end
        for _, obj in ipairs(node) do
            if not self[obj] then
                self[obj]     = true
                self[#self+1] = obj
            end
        end
    else
        if not self[node] then
            self[node]    = true
            self[#self+1] = node
        end
    end
end

---@return boolean
function mt:isEmpty()
    return #self == 0
end

---@param n integer
---@return vm.object?
function mt:get(n)
    return self[n]
end

function mt:setData(k, v)
    if not self.data then
        self.data = {}
    end
    self.data[k] = v
end

function mt:getData(k)
    if not self.data then
        return nil
    end
    return self.data[k]
end

function mt:addOptional()
    self.optional = true
end

function mt:removeOptional()
    self.optional = false
end

---@return boolean
function mt:isOptional()
    return self.optional == true
end

---@return boolean
function mt:isFalsy()
    if self.optional then
        return true
    end
    for _, c in ipairs(self) do
        if c.type == 'nil'
        or (c.type == 'boolean' and c[1] == false)
        or (c.type == 'doc.type.boolean' and c[1] == false) then
            return true
        end
    end
    return false
end

function mt:removeFalsy()
    
end

---@return fun():vm.object
function mt:eachObject()
    local i = 0
    return function ()
        i = i + 1
        return self[i]
    end
end

---@return vm.node
function mt:copy()
    return vm.createNode(self)
end

---@param source vm.object
---@param node vm.node | vm.object
---@param cover? boolean
function vm.setNode(source, node, cover)
    if not node then
        error('Can not set nil node')
    end
    if source.type == 'global' then
        error('Can not set node to global')
    end
    if cover then
        vm.nodeCache[source] = node
        return
    end
    local me = vm.nodeCache[source]
    if me then
        me:merge(node)
    else
        if node.type == 'vm.node' then
            vm.nodeCache[source] = node
        else
            vm.nodeCache[source] = vm.createNode(node)
        end
    end
end

---@param source vm.object
---@return vm.node?
function vm.getNode(source)
    return vm.nodeCache[source]
end

---@param source vm.object
function vm.removeNode(source)
    vm.nodeCache[source] = nil
end

local lockCount = 0
local needClearCache = false
function vm.lockCache()
    lockCount = lockCount + 1
end

function vm.unlockCache()
    lockCount = lockCount - 1
    if needClearCache then
        needClearCache = false
        vm.clearNodeCache()
    end
end

function vm.clearNodeCache()
    if lockCount > 0 then
        needClearCache = true
        return
    end
    log.debug('clearNodeCache')
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
        if ws.isReady(uri) then
            vm.clearNodeCache()
        end
    end
end)
