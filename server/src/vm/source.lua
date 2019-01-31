local mt = {}
mt.__index = mt

function mt:bindLocal(loc)
    if loc then
        self._bindLocal = loc
    else
        return self._bindLocal
    end
end

function mt:setUri(uri)
    self._uri = uri
end

return function (source)
    return setmetatable(source, mt)
end
