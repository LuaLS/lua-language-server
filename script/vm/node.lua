local files    = require 'files'
local localMgr = require 'vm.local-manager'
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
---@type vm.node[]
mt._childs    = nil
mt._locked    = false

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
        if node._locked then
            if not self._childs then
                self._childs = {}
            end
            if not self._childs[node] then
                self._childs[#self._childs+1] = node
                self._childs[node] = true
            end
        else
            for _, obj in ipairs(node) do
                if not self[obj] then
                    self[obj]     = true
                    self[#self+1] = obj
                end
            end
        end
    else
        if not self[node] then
            self[node]    = true
            self[#self+1] = node
        end
    end
end

function mt:_each(mark, callback)
    if mark[self] then
        return
    end
    mark[self] = true
    for i = 1, #self do
        callback(self[i])
    end
    local childs = self._childs
    if not childs then
        return
    end
    for i = 1, #childs do
        local child = childs[i]
        if not child:isLocked() then
            child:_each(mark, callback)
        end
    end
end

function mt:_expand()
    local childs = self._childs
    if not childs then
        return
    end
    self._childs = nil

    local mark = {}
    mark[self] = true

    local function insert(obj)
        if not self[obj] then
            self[obj]     = true
            self[#self+1] = obj
        end
    end

    for i = 1, #childs do
        local child = childs[i]
        if child:isLocked() then
            if not self._childs then
                self._childs = {}
            end
            if not self._childs[child] then
                self._childs[#self._childs+1] = child
                self._childs[child] = true
            end
        else
            child:_each(mark, insert)
        end
    end
end

---@return boolean
function mt:isEmpty()
    self:_expand()
    return #self == 0
end

---@param n integer
---@return vm.object?
function mt:get(n)
    self:_expand()
    return self[n]
end

function mt:lock()
    self._locked = true
end

function mt:unlock()
    self._locked = false
end

function mt:isLocked()
    return self._locked == true
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
    if self:isOptional() then
        return self
    end
    self.optional = true
end

function mt:removeOptional()
    if not self:isOptional() then
        return self
    end
    self:_expand()
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
    self:_expand()
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
    self:_expand()
    local i = 0
    return function ()
        i = i + 1
        return self[i]
    end
end

---@param source parser.object | vm.generic
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
