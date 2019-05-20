local mt = {}
mt.__index = mt
mt.type = 'file'
mt._uri = ''
mt._text = ''
mt._open = false

function mt:setText(buf)
    self._text = buf
end

function mt:getText()
    return self._text
end

function mt:open()
    self._open = true
end

function mt:close()
    self._open = false
end

function mt:isOpen()
    return self._open
end

return function (uri)
    local self = setmetatable({
        _uri = uri,
    }, mt)
    return self
end
