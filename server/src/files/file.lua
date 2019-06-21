---@class file
local mt = {}
mt.__index = mt
mt.type = 'file'
mt._uri = ''
mt._text = ''
mt._version = -1

---@param buf string
function mt:setText(buf)
    self._text = buf
end

---@return string
function mt:getText()
    return self._text
end

---@param version integer
function mt:setVersion(version)
    self._version = version
end

---@return integer
function mt:getVersion()
    return self._version
end

function mt:remove()
    if self._removed then
        return
    end
    self._removed = true
    self._text = nil
    self._version = nil
    if self._vm then
        self._vm:remove()
    end
end

---@param vm VM
function mt:saveVM(vm)
    self._vm = vm
end

---@return VM
function mt:getVM()
    return self._vm
end

function mt:removeVM()
    if not self._vm then
        return
    end
    self._vm:remove()
    self._vm = nil
end

---@return file
function mt:getParent()
    return self._parent
end

---@param uri uri
function mt:removeChild(uri)
    self._child[uri] = nil
end

---@param uri uri
function mt:removeParent(uri)
    self._parent[uri] = nil
end

function mt:eachChild()
    return pairs(self._child)
end

function mt:eachParent()
    return pairs(self._parent)
end

---@param uri string
return function (uri)
    local self = setmetatable({
        _uri = uri,
        _parent = {},
        _child = {},
    }, mt)
    return self
end
