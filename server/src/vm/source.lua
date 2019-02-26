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

function mt:bindLabel(label)
    if label then
        self._bindLabel = label
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
        value:addInfo(action, self)
    else
        return self._bindValue
    end
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
