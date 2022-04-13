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

---@param source parser.object
function mt:subscribeLocal(source)
    -- TODO: need delete
    for _, c in ipairs(self) do
        localMgr.subscribeLocal(source, c)
    end
end

---@return vm.node
function mt:addOptional()
    if self:isOptional() then
        return self
    end
    self.optional = true
    return self
end

---@return vm.node
function mt:removeOptional()
    self.optional = nil
    if not self:isOptional() then
        return self
    end
    local newNode = vm.createNode()
    for _, n in ipairs(self) do
        if n.type == 'nil' then
            goto CONTINUE
        end
        if n.type == 'boolean' and n[1] == false then
            goto CONTINUE
        end
        if n.type == 'doc.type.boolean' and n[1] == false then
            goto CONTINUE
        end
        if n.type == 'false' then
            goto CONTINUE
        end
        newNode[#newNode+1] = n
        ::CONTINUE::
    end
    newNode.optional = false
    return newNode
end

---@return boolean
function mt:isOptional()
    if self.optional ~= nil then
        return self.optional
    end
    for _, c in ipairs(self) do
        if c.type == 'nil' then
            self.optional = true
            return true
        end
        if c.type == 'boolean' then
            if c[1] == false then
                self.optional = true
                return true
            end
        end
        if c.type == 'false' then
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
