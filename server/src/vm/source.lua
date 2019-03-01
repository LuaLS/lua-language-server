local mt = {}
mt.__index = mt
mt._hasInstant = true

function mt:bindLocal(loc)
    if loc then
        self._bindLocal = loc
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

function mt:action()
    return self._action
end

function mt:setUri(uri)
    self._uri = uri
end

function mt:getUri()
    return self._uri
end

return function (source)
    if source._hasInstant then
        return false
    end
    setmetatable(source, mt)
    return true
end
