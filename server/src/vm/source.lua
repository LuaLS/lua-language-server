local mt = {}
mt.__index = mt
mt._hasInstant = true

function mt:bindLocal(loc, action)
    if loc then
        self._bindLocal = loc
        self._bindValue = loc:getValue()
        self._action = action
        loc:addInfo(action, self)
    else
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

function mt:bindCall(func, args)
    if func then
        self._bindCall = func
        self._bindCallArgs = args
    else
        return self._bindCall, self._bindCallArgs
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

function mt:setVM()
    self.vm = vm
end

function mt:isRemoved()
    if not self.vm then
        return true
    end
    if self.vm._removed then
        self.vm = nil
        return true
    end
    return false
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

return function (vm, source)
    if source._hasInstant then
        return false
    end
    source.vm = vm
    setmetatable(source, mt)
    return true
end
