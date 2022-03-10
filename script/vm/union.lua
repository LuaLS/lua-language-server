local localMgr = require 'vm.local-manager'

---@class vm.node.union
local mt = {}
mt.__index   = mt
mt.type      = 'union'
mt.falsy     = nil
mt.lastViews = nil

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
        if node:isFalsy() then
            self:setFalsy()
        else
            self.falsy = nil
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

function mt:setFalsy()
    self.falsy = true
end

function mt:setTruthy()
    self.falsy = false
end

function mt:checkFalsy()
    if self.falsy ~= nil then
        return
    end
    for _, c in ipairs(self) do
        if c.type == 'nil' then
            self:setFalsy()
            return
        end
        if c.type == 'boolean' then
            if c[1] == false then
                self:setFalsy()
                return
            end
        end
    end
end

function mt:isFalsy()
    self:checkFalsy()
    return self.falsy == true
end

function mt:isTruthy()
    self:checkFalsy()
    return self.falsy == false
end

---@param me   parser.object
---@param node vm.node
---@return vm.node.union
return function (me, node)
    local union = setmetatable({}, mt)
    union:merge(me)
    union:merge(node)
    return union
end
