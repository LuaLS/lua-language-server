local util = require 'utility'

---@class gc
---@field _list table
local mt = {}
mt.__index = mt
mt.type = 'gc'
mt._removed = false

mt._max = 10

local function destroyGCObject(obj)
    local tp = type(obj)
    if tp == 'function' then
        xpcall(obj, log.error)
    elseif tp == 'table' then
        local remove = obj.remove
        if type(remove) == 'function' then
            xpcall(remove, log.error, obj)
        end
    end
end

local function isRemoved(obj)
    local tp = type(obj)
    if tp == 'function' then
        for i = 1, 1000 do
            local n, v = debug.getupvalue(obj, i)
            if not n then
                if i > 1 then
                    log.warn('函数式析构器没有 removed 上值！', util.dump(debug.getinfo(obj)))
                end
                break
            end
            if n == 'removed' then
                if v then
                    return true
                end
                break
            end
        end
    elseif tp == 'table' then
        if obj._removed then
            return true
        end
    end
    return false
end

local function zip(self)
    local list = self._list
    local index = 1
    for i = 1, #list do
        local obj = list[index]
        if not obj then
            break
        end
        if isRemoved(obj) then
            if index == #list then
                list[#list] = nil
                break
            end
            list[index] = list[#list]
        else
            index = index + 1
        end
    end
    self._max = #list * 1.5
    if self._max < 10 then
        self._max = 10
    end
end

function mt:remove()
    if self._removed then
        return
    end
    self._removed = true
    local list = self._list
    for i = 1, #list do
        destroyGCObject(list[i])
    end
end

--- 标记`obj`在buff移除时自动移除。如果`obj`是个`function`,
--- 则直接调用；如果`obj`是个`table`，则调用内部的`remove`方法。
--- 其他情况不做处理
---@param obj any
---@return any
function mt:add(obj)
    if self._removed then
        destroyGCObject(obj)
        return nil
    end
    self._list[#self._list+1] = obj
    if #self._list > self._max then
        zip(self)
    end
    return obj
end

--- 创建一个gc容器，使用 `gc:add(obj)` 将析构器放入gc容器。
---
--- 当gc容器被销毁时，会调用内部的析构器（不保证调用顺序）
---
--- 析构器必须是以下格式中的一种：
--- 1. 一个对象，使用 `obj:remove()` 方法来析构，使用 `obj._removed` 属性来标记已被析构。
--- 2. 一个析构函数，使用上值 `removed` 来标记已被析构。
---
--- ```lua
--- local gc = ac.gc() -- 创建gc容器
--- gc:add(obj1)       -- 将obj1放入gc容器
--- gc:add(obj2)       -- 将obj2放入gc容器
--- gc:remove()        -- 移除gc容器，同时也会移除obj1与obj2
--- ```
return function ()
    return setmetatable({
        _list = {},
    }, mt)
end
