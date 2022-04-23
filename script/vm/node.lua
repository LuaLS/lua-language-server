local files    = require 'files'
---@class vm
local vm       = require 'vm.vm'
local ws       = require 'workspace.workspace'

---@type table<vm.object, vm.node>
vm.nodeCache = {}

---@class vm.node
---@field [integer] vm.object
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
    self:remove 'nil'
end

---@return boolean
function mt:isOptional()
    return self.optional == true
end

---@return boolean
function mt:hasFalsy()
    if self.optional then
        return true
    end
    for _, c in ipairs(self) do
        if c.type == 'nil'
        or (c.type == 'global' and c.cate == 'type' and c.name == 'nil')
        or (c.type == 'boolean' and c[1] == false)
        or (c.type == 'doc.type.boolean' and c[1] == false) then
            return true
        end
    end
    return false
end

---@return boolean
function mt:isNullable()
    if self.optional then
        return true
    end
    if #self == 0 then
        return true
    end
    for _, c in ipairs(self) do
        if c.type == 'nil'
        or (c.type == 'global' and c.cate == 'type' and c.name == 'nil')
        or (c.type == 'global' and c.cate == 'type' and c.name == 'any') then
            return true
        end
    end
    return false
end

---@return vm.node
function mt:setTruthy()
    if self.optional == true then
        self.optional = nil
    end
    local hasBoolean
    for index = #self, 1, -1 do
        local c = self[index]
        if c.type == 'nil'
        or (c.type == 'boolean' and c[1] == false)
        or (c.type == 'doc.type.boolean' and c[1] == false) then
            table.remove(self, index)
            self[c] = nil
            goto CONTINUE
        end
        if (c.type == 'global' and c.cate == 'type' and c.name == 'boolean')
        or (c.type == 'boolean' or c.type == 'doc.type.boolean') then
            hasBoolean = true
            table.remove(self, index)
            self[c] = nil
            goto CONTINUE
        end
        ::CONTINUE::
    end
    if hasBoolean then
        self[#self+1] = {
            type = 'doc.type.boolean',
            [1]  = true,
        }
    end
end

---@return vm.node
function mt:setFalsy()
    if self.optional == false then
        self.optional = nil
    end
    local hasBoolean
    for index = #self, 1, -1 do
        local c = self[index]
        if c.type == 'nil'
        or (c.type == 'boolean' and c[1] == true)
        or (c.type == 'doc.type.boolean' and c[1] == true) then
            goto CONTINUE
        end
        if (c.type == 'global' and c.cate == 'type' and c.name == 'boolean')
        or (c.type == 'boolean' or c.type == 'doc.type.boolean') then
            hasBoolean = true
            goto CONTINUE
        end
        table.remove(self, index)
        self[c] = nil
        ::CONTINUE::
    end
    if hasBoolean then
        self[#self+1] = {
            type = 'doc.type.boolean',
            [1]  = false,
        }
    end
end

---@param name string
function mt:remove(name)
    if name == 'nil' and self.optional == true then
        self.optional = nil
    end
    for index = #self, 1, -1 do
        local c = self[index]
        if (c.type == 'global' and c.cate == 'type' and c.name == name)
        or (c.type == name)
        or (c.type == 'doc.type.integer'  and (name == 'number' or name == 'integer'))
        or (c.type == 'doc.type.boolean'  and name == 'boolean')
        or (c.type == 'doc.type.table'    and name == 'table')
        or (c.type == 'doc.type.array'    and name == 'table')
        or (c.type == 'doc.type.function' and name == 'function') then
            table.remove(self, index)
            self[c] = nil
        end
    end
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
        if TEST then
            error('Can not set nil node')
        else
            log.error('Can not set nil node')
        end
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
            vm.nodeCache[source] = node:copy()
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
