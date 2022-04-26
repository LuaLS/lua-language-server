local gc = require 'gc'

---@class scope.manager
local m = {}

---@alias scope.type '"override"'|'"folder"'|'"fallback"'

---@class scope
---@field type   scope.type
---@field uri?   uri
---@field _links table<uri, boolean>
---@field _data  table<string, any>
---@field _gc    gc
local mt = {}
mt.__index = mt

function mt:__tostring()
    if self.uri then
        return ('{scope|%s|%s}'):format(self.type, self.uri)
    else
        return ('{scope|%s}'):format(self.type)
    end
end

---@param uri uri
function mt:addLink(uri)
    self._links[uri] = true
end

---@param uri uri
function mt:removeLink(uri)
    self._links[uri] = nil
end

function mt:removeAllLinks()
    self._links = {}
end

---@param uri uri
---@return boolean
function mt:isChildUri(uri)
    if not uri then
        return false
    end
    if not self.uri then
        return false
    end
    return uri:sub(1, #self.uri) == self.uri
end

---@param uri uri
---@return boolean
function mt:isLinkedUri(uri)
    if not uri then
        return false
    end
    for linkUri in pairs(self._links) do
        if uri:sub(1, #linkUri) == linkUri then
            return true
        end
    end
    return false
end

---@param uri uri
---@return boolean
function mt:isVisible(uri)
    return self:isChildUri(uri)
        or self:isLinkedUri(uri)
        or self == m.getScope(uri)
end

---@param uri uri
---@return uri?
function mt:getLinkedUri(uri)
    if not uri then
        return nil
    end
    for linkUri in pairs(self._links) do
        if uri:sub(1, #linkUri) == linkUri then
            return linkUri
        end
    end
    return nil
end

---@param uri uri
---@return uri
function mt:getRootUri(uri)
    if self:isChildUri(uri) then
        return self.uri
    end
    return self:getLinkedUri(uri)
end

---@param k string
---@param v any
function mt:set(k, v)
    self._data[k] = v
    return v
end

---@param k string
---@return any
function mt:get(k)
    return self._data[k]
end

---@return string
function mt:getName()
    return self.uri or ('<' .. self.type .. '>')
end

function mt:gc(obj)
    self._gc:add(obj)
end

function mt:flushGC()
    self._gc:remove()
    self._gc = gc()
end

---@param scopeType scope.type
---@return scope
local function createScope(scopeType)
    local scope = setmetatable({
        type   = scopeType,
        _links = {},
        _data  = {},
        _gc    = gc(),
    }, mt)

    return scope
end

function m.reset()
    ---@type scope[]
    m.folders  = {}
    m.override = createScope 'override'
    m.fallback = createScope 'fallback'
end

m.reset()

---@param uri uri
---@return scope
function m.createFolder(uri)
    local scope = createScope 'folder'
    scope.uri = uri

    local inserted = false
    for i, otherScope in ipairs(m.folders) do
        if #uri > #otherScope.uri then
            table.insert(m.folders, i, scope)
            inserted = true
            break
        end
    end
    if not inserted then
        table.insert(m.folders, scope)
    end

    return scope
end

---@param uri uri
---@return scope
function m.getFolder(uri)
    for _, scope in ipairs(m.folders) do
        if scope:isChildUri(uri) then
            return scope
        end
    end
    return nil
end

---@param uri uri
---@return scope
function m.getLinkedScope(uri)
    if m.override and m.override:isLinkedUri(uri) then
        return m.override
    end
    for _, scope in ipairs(m.folders) do
        if scope:isLinkedUri(uri) then
            return scope
        end
    end
    if m.fallback:isLinkedUri(uri) then
        return m.fallback
    end
end

---@param uri uri
---@return scope
function m.getScope(uri)
    return m.getFolder(uri)
        or m.getLinkedScope(uri)
        or m.fallback
end

return m
