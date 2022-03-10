local localMgr = require 'vm.local-manager'

---@class vm.node.union
local mt = {}
mt.__index   = mt
mt.type      = 'union'
mt.optional  = nil
mt.lastViews = nil

---@param me   parser.object
---@param node vm.node
---@return vm.node.union
local function createUnion(me, node)
    local union = setmetatable({}, mt)
    union:merge(me)
    union:merge(node)
    return union
end

---@param node vm.node
function mt:merge(node)
    if not node then
        return
    end
    if node.type == 'union' then
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

---@param source parser.object
function mt:subscribeLocal(source)
    for _, c in ipairs(self) do
        localMgr.subscribeLocal(source, c)
    end
end

function mt:eachNode()
    local i = 0
    return function ()
        i = i + 1
        return self[i]
    end
end

---@return vm.node.union
function mt:addOptional()
    if self:isOptional() then
        return self
    end
    self.optional = true
    return self
end

---@return vm.node.union
function mt:removeOptional()
    self.optional = nil
    if not self:isOptional() then
        return self
    end
    -- copy union
    local newUnion = createUnion()
    for _, n in ipairs(self) do
        if n.type == 'nil' then
            goto CONTINUE
        end
        if n.type == 'boolean' then
            if n[1] == false then
                goto CONTINUE
            end
        end
        if n.type == 'false' then
            goto CONTINUE
        end
        newUnion[#newUnion+1] = n
        ::CONTINUE::
    end
    newUnion.optional = false
    return newUnion
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

return createUnion
