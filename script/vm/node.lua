local files    = require 'files'
---@class vm
local vm       = require 'vm.vm'
local ws       = require 'workspace.workspace'
local guide    = require 'parser.guide'

---@type table<vm.object, vm.node>
vm.nodeCache = {}

---@alias vm.node.object vm.object | vm.global

---@class vm.node
---@field [integer] vm.node.object
---@field [vm.node.object] true
local mt = {}
mt.__index    = mt
mt.id         = 0
mt.type       = 'vm.node'
mt.optional   = nil
mt.data       = nil

---@param node vm.node | vm.node.object
---@return vm.node
function mt:merge(node)
    if not node then
        return self
    end
    if node.type == 'vm.node' then
        if node == self then
            return self
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
        ---@cast node -vm.node
        if not self[node] then
            self[node]    = true
            self[#self+1] = node
        end
    end
    return self
end

---@return boolean
function mt:isEmpty()
    return #self == 0
end

function mt:clear()
    self.optional = nil
    for i, c in ipairs(self) do
        self[i] = nil
        self[c] = nil
    end
end

---@param n integer
---@return vm.node.object?
function mt:get(n)
    return self[n]
end

function mt:setData(k, v)
    if not self.data then
        self.data = {}
    end
    self.data[k] = v
end

---@return any
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
    return self
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
        or (c.type == 'global' and c.cate == 'type' and c.name == 'false')
        or (c.type == 'boolean' and c[1] == false)
        or (c.type == 'doc.type.boolean' and c[1] == false) then
            return true
        end
    end
    return false
end

---@return boolean
function mt:hasKnownType()
    for _, c in ipairs(self) do
        if c.type == 'global' and c.cate == 'type' then
            return true
        end
        if guide.isLiteral(c) then
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
        or (c.type == 'global' and c.cate == 'type' and c.name == 'any')
        or (c.type == 'global' and c.cate == 'type' and c.name == '...') then
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
        or (c.type == 'global' and c.cate == 'type' and c.name == 'nil')
        or (c.type == 'global' and c.cate == 'type' and c.name == 'false')
        or (c.type == 'boolean' and c[1] == false)
        or (c.type == 'doc.type.boolean' and c[1] == false) then
            table.remove(self, index)
            self[c] = nil
            goto CONTINUE
        end
        if c.type == 'global' and c.cate == 'type' and c.name == 'boolean' then
            hasBoolean = true
            table.remove(self, index)
            self[c] = nil
            goto CONTINUE
        end
        if c.type == 'boolean' or c.type == 'doc.type.boolean' then
            if c[1] == false then
                table.remove(self, index)
                self[c] = nil
                goto CONTINUE
            end
        end
        ::CONTINUE::
    end
    if hasBoolean then
        self:merge(vm.declareGlobal('type', 'true'))
    end
    return self
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
        or (c.type == 'global' and c.cate == 'type' and c.name == 'nil')
        or (c.type == 'global' and c.cate == 'type' and c.name == 'false')
        or (c.type == 'boolean' and c[1] == false)
        or (c.type == 'doc.type.boolean' and c[1] == false) then
            goto CONTINUE
        end
        if c.type == 'global' and c.cate == 'type' and c.name == 'boolean' then
            hasBoolean = true
            table.remove(self, index)
            self[c] = nil
            goto CONTINUE
        end
        if c.type == 'boolean' or c.type == 'doc.type.boolean' then
            if c[1] == true then
                table.remove(self, index)
                self[c] = nil
                goto CONTINUE
            end
        end
        if (c.type == 'global' and c.cate == 'type') then
            table.remove(self, index)
            self[c] = nil
            goto CONTINUE
        end
        if guide.isLiteral(c) then
            table.remove(self, index)
            self[c] = nil
            goto CONTINUE
        end
        ::CONTINUE::
    end
    if hasBoolean then
        self:merge(vm.declareGlobal('type', 'false'))
    end
    return self
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
        or (c.type == 'doc.type.boolean'  and name == 'true'  and c[1] == true)
        or (c.type == 'doc.type.boolean'  and name == 'false' and c[1] == false)
        or (c.type == 'doc.type.table'    and name == 'table')
        or (c.type == 'doc.type.array'    and name == 'table')
        or (c.type == 'doc.type.sign'     and name == c.node[1])
        or (c.type == 'doc.type.function' and name == 'function') then
            table.remove(self, index)
            self[c] = nil
        end
    end
    return self
end

---@param name string
function mt:narrow(name)
    if name ~= 'nil' and self.optional == true then
        self.optional = nil
    end
    for index = #self, 1, -1 do
        local c = self[index]
        if (c.type == name)
        or (c.type == 'doc.type.integer'  and (name == 'number' or name == 'integer'))
        or (c.type == 'doc.type.boolean'  and name == 'boolean')
        or (c.type == 'doc.type.table'    and name == 'table')
        or (c.type == 'doc.type.array'    and name == 'table')
        or (c.type == 'doc.type.sign'     and name == c.node[1])
        or (c.type == 'doc.type.function' and name == 'function') then
            goto CONTINUE
        end
        if c.type == 'global' and c.cate == 'type' then
            if (c.name == name)
            or (c.name == 'integer' and name == 'number') then
                goto CONTINUE
            end
        end
        table.remove(self, index)
        self[c] = nil
        ::CONTINUE::
    end
    if #self == 0 then
        self[#self+1] = vm.getGlobal('type', name)
    end
    return self
end

---@param obj vm.object
function mt:removeObject(obj)
    for index, c in ipairs(self) do
        if c == obj then
            table.remove(self, index)
            self[c] = nil
            return
        end
    end
end

---@param node vm.node
function mt:removeNode(node)
    for _, c in ipairs(node) do
        if c.type == 'global' and c.cate == 'type' then
            ---@cast c vm.global
            self:remove(c.name)
        elseif c.type == 'nil' then
            self:remove 'nil'
        elseif c.type == 'boolean'
        or     c.type == 'doc.type.boolean' then
            if c[1] == true then
                self:remove 'true'
            else
                self:remove 'false'
            end
        else
            ---@cast c -vm.global
            self:removeObject(c)
        end
    end
end

---@param name string
---@return boolean
function mt:hasType(name)
    for _, c in ipairs(self) do
        if c.type == 'global' and c.cate == 'type' and c.name == name then
            return true
        end
    end
    return false
end

---@param name string
---@return boolean
function mt:hasName(name)
    if name == 'nil' and self.optional == true then
        return true
    end
    for _, c in ipairs(self) do
        if c.type == 'global' and c.cate == 'type' and c.name == name then
            return true
        end
        if c.type == name then
            return true
        end
        -- TODO
    end
    return false
end

---@return vm.node
function mt:asTable()
    self.optional = nil
    for index = #self, 1, -1 do
        local c = self[index]
        if c.type == 'table'
        or c.type == 'doc.type.table'
        or c.type == 'doc.type.array' then
            goto CONTINUE
        end
        if c.type == 'doc.type.sign' then
            if c.node[1] == 'table'
            or not guide.isBasicType(c.node[1]) then
                goto CONTINUE
            end
        end
        if c.type == 'global' and c.cate == 'type' then
            ---@cast c vm.global
            if c.name == 'table'
            or not guide.isBasicType(c.name) then
                goto CONTINUE
            end
        end
        table.remove(self, index)
        self[c] = nil
        ::CONTINUE::
    end
    return self
end

---@return fun():vm.node.object
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
---@param node vm.node | vm.node.object
---@param cover? boolean
---@return vm.node
function vm.setNode(source, node, cover)
    if not node then
        if TEST then
            error('Can not set nil node')
        else
            log.error('Can not set nil node')
        end
    end
    if cover then
        ---@cast node vm.node
        vm.nodeCache[source] = node
        return node
    end
    local me = vm.nodeCache[source]
    if me then
        me:merge(node)
    else
        if node.type == 'vm.node' then
            me = node:copy()
        else
            me = vm.createNode(node)
        end
        vm.nodeCache[source] = me
    end
    return me
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

local ID = 0

---@param a? vm.node | vm.node.object
---@param b? vm.node | vm.node.object
---@return vm.node
function vm.createNode(a, b)
    ID = ID + 1
    local node = setmetatable({
        id = ID,
    }, mt)
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

ws.watch(function (ev, uri)
    if ev == 'reload' then
        vm.clearNodeCache()
    end
end)
