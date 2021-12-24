---@alias scope.type '"override"'|'"folder"'|'"fallback"'

---@class scope
---@field type   scope.type
---@field uri?   uri
---@field _links table<uri, boolean>
---@field _data  table<string, any>
local mt = {}
mt.__index = mt

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
    if not self.uri then
        return true
    end
    return uri:sub(1, #self.uri) == self.uri
end

---@param uri uri
---@return boolean
function mt:isLinkedUri(uri)
    for linkUri in pairs(self._links) do
        if uri:sub(1, #linkUri) == linkUri then
            return true
        end
    end
    return false
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

---@param scopeType scope.type
---@return scope
local function createScope(scopeType)
    local scope = setmetatable({
        type   = scopeType,
        _links = {},
        _data  = {},
    }, mt)

    return scope
end

---@class scope.manager
local m = {}

---@type scope[]
m.folders  = {}
m.override = createScope 'override'
m.fallback = createScope 'fallback'

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
        if not uri or scope:isChildUri(uri) then
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

return m
