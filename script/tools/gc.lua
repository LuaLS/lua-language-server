---@class GCHost
---@field private _gccontainer GC
local GCHost = Class 'GCHost'

function GCHost:__del()
    if not self._gccontainer then
        return
    end
    self._gccontainer:remove()
end

-- 将一个对象的生命周期与自己绑定，
-- 当自己被移除时，也会移除该对象。
-- 如果调用此方法时自己已经被移除，
-- 则会立即移除该对象并返回 `nil`，
-- 否则会返回该对象。
---@generic T: table
---@param obj T | function
---@return T
function GCHost:bindGC(obj)
    if not self._gccontainer then
        if not IsValid(self) then
            if type(obj) == 'table' then
                Delete(obj)
            end
            return nil
        end
        ---@private
        self._gccontainer = New 'GC' ()
    end
    if type(obj) == 'function' then
        obj = New 'GCNode' (obj)
    end
    return self._gccontainer:add(obj)
end

---@class GC
---@field private objects table[]
---@field private removed boolean
---@overload fun(): self
local GC = Class 'GC'

---@private
GC.max = 10

---@return self
function GC:__init()
    self.objects = {}
    return self
end

function GC:__del()
    for _, obj in ipairs(self.objects) do
        Delete(obj)
    end
end

function GC:remove()
    Delete(self)
end

---@generic T: table
---@param obj T
---@return T
function GC:add(obj)
    -- TODO 插件BUG
    ---@cast obj table
    if not IsValid(obj) or not IsValid(self) then
        Delete(obj)
        return nil
    end
    self.objects[#self.objects+1] = obj
    if #self.objects > self.max then
        self:zip()
    end
    return obj
end

function GC:zip()
    local objects = self.objects
    local index = 1
    for _ = 1, #objects do
        local obj = objects[index]
        if not obj then
            break
        end
        if not IsValid(obj) then
            if index == #objects then
                objects[#objects] = nil
                break
            end
            objects[index] = objects[#objects]
        else
            index = index + 1
        end
    end
    self.max = math.max(#objects * 1.5, 10)
end

---@class GCNode
---@overload fun(onDel: function): self
local GCNode = Class 'GCNode'

function GCNode:__init(onDel)
    self.onDel = onDel
end

function GCNode:__del()
    self.onDel()
end

function GCNode:__close()
    Delete(self)
end

local API = {}

---@return GCHost
function API.host()
    return New 'GCHost' ()
end

---@param onDel function
---@return GCNode
function API.node(onDel)
    return New 'GCNode' (onDel)
end

return API
