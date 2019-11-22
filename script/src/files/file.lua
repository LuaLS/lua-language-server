---@class file
local mt = {}
mt.__index = mt
mt.type = 'file'
mt._uri = ''
mt._oldText = ''
mt._text = ''
mt._version = -1
mt._vmCost = 0.0
mt._lineCost = 0.0

---@param buf string
function mt:setText(buf)
    self._oldText = self._text
    self._text = buf
end

---@return string
function mt:getText()
    return self._text
end

---@return string
function mt:getOldText()
    return self._oldText
end

function mt:clearOldText()
    self._oldText = nil
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

---@return boolean
function mt:isRemoved()
    return self._removed == true
end

---@param vm VM
---@param version integer
---@param cost number
function mt:saveVM(vm, version, cost)
    if self._vm then
        self._vm:remove()
    end
    self._vm = vm
    if vm then
        vm:setVersion(version)
    end
    self._vmCost = cost
end

---@return VM
function mt:getVM()
    return self._vm
end

---@return number
function mt:getVMCost()
    return self._vmCost
end

function mt:removeVM()
    if not self._vm then
        return
    end
    self._vm:remove()
    self._vm = nil
end

---@param lines table
---@param cost number
function mt:saveLines(lines, cost)
    self._lines = lines
    self._lineCost = cost
end

---@return table
function mt:getLines()
    return self._lines
end

function mt:getComments()
    return self.comments
end

---@return file
function mt:getParent()
    return self._parent
end

---@param uri uri
function mt:addChild(uri)
    self._child[uri] = true
end

---@param uri uri
function mt:removeChild(uri)
    self._child[uri] = nil
end

---@param uri uri
function mt:addParent(uri)
    self._parent[uri] = true
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

---@param err table
function mt:setAstErr(err)
    self._astErr = err
end

---@return table
function mt:getAstErr()
    return self._astErr
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
