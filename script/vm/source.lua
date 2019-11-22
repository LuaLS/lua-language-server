local listMgr = require 'vm.list'

---@class source
local mt = {}
mt.__index = mt
mt.type = 'source'
mt.uri = ''
mt.start = 0
mt.finish = 0
mt.id = 0

local Watch = setmetatable({}, {__mode = 'k'})

function mt:bindLocal(loc, action)
    if loc then
        self._bindLocal = loc
        self._bindValue = loc:getValue()
        self._action = action
        loc:addInfo(action, self)
    else
        if not self._bindLocal then
            return nil
        end
        if not self._bindLocal:getSource() then
            self._bindLocal = nil
            return nil
        end
        return self._bindLocal
    end
end

function mt:bindLabel(label, action)
    if label then
        self._bindLabel = label
        self._action = action
        label:addInfo(action, self)
    else
        return self._bindLabel
    end
end

function mt:bindFunction(func)
    if func then
        self._bindFunction = func
    else
        return self._bindFunction
    end
end

function mt:bindValue(value, action)
    if value then
        self._bindValue = value
        self._action = action
        value:addInfo(action, self)
    else
        return self._bindValue
    end
end

function mt:bindCall(args)
    if args then
        self._bindCallArgs = args
    else
        return self._bindCallArgs
    end
end

function mt:bindMetatable(meta)
    if meta then
        self._bindMetatable = meta
    else
        return self._bindMetatable
    end
end

function mt:action()
    return self._action
end

function mt:setUri(uri)
    self.uri = uri
end

function mt:getUri()
    return self.uri
end

function mt:set(name, v)
    if not self._flag then
        self._flag = {}
    end
    self._flag[name] = v
end

function mt:get(name)
    if not self._flag then
        return nil
    end
    return self._flag[name]
end

function mt:getName()
    return self[1]
end

function mt:kill()
    self._dead = true
    listMgr.clear(self.id)
end

function mt:isDead()
    return self._dead
end

function mt:findValue()
    local value = self:bindValue()
    if not value then
        return nil
    end
    if not value:isGlobal() then
        return value
    end
    if self.type ~= 'name' then
        return value
    end
    local parent = self:get 'parent'
    if not parent then
        return value
    end
    local name = self[1]
    if type(name) ~= 'string' then
        return value
    end
    return parent:getChild(name) or value
end

function mt:findCallFunction()
    local simple = self:get 'simple'
    if not simple then
        return nil
    end
    local source
    for i = 1, #simple do
        if simple[i] == self then
            source = simple[i-1]
        end
    end
    if not source then
        return nil
    end
    local value = source:bindValue()
    if value and value:getFunction() then
        return value
    end
    value = source:findValue()
    if value and value:getFunction() then
        return value
    end
    return nil
end

local function instant(source)
    if source.id then
        return false
    end
    local id = listMgr.add(source)
    source.id = id
    Watch[source] = id
    setmetatable(source, mt)
    return true
end

local function dummy()
    local src = {}
    instant(src)
    return src
end

return {
    instant = instant,
    watch = Watch,
    dummy = dummy,
}
