---@class Scope
local M = Class 'Scope'

---@param uri? Uri
---@param fs? FileSystem
function M:__init(uri, fs)
    self.uri = uri
    self.fs  = fs or ls.fs
    table.insert(ls.scope.all, self)

    ---@type Uri[]
    self.includeUris = {}
    ---@type Config
    self.config = ls.config.create(self.uri)

    self.node = ls.node.createManager(self)
    self.node:reset()

    ---@type table<Uri, Document>
    self.documents = setmetatable({}, ls.util.MODE_V)

    self.vm = ls.vm.create(self)
end

function M:__del()
    ls.util.arrayRemove(ls.scope.all, self)
end

---@param uri Uri
---@return 'workspace' | 'include' | nil
function M:testUri(uri)
    if self.uri then
        if self.uri == uri or ls.uri.relativePath(uri, self.uri) then
            return 'workspace'
        end
    end
    for _, iuri in ipairs(self.includeUris) do
        if iuri == uri or ls.uri.relativePath(uri, iuri) then
            return 'include'
        end
    end
    return nil
end

---@param uri Uri
---@return Document?
function M:getDocument(uri)
    local file = ls.file.get(uri)
    if not file then
        return nil
    end
    local document = self.documents[file.uri]
    if not document then
        document = New 'Document' (file)
        self.documents[file.uri] = document
    end
    return document
end

---@async
---@param uri Uri
---@return boolean
function M:isIgnored(uri)
    self:initGlob()
    return self.glob:check(uri)
end

---@param uri Uri
---@return boolean
function M:isValidUri(uri)
    for _, ext in ipairs { '.lua' } do
        if ls.util.stringEndWith(uri, ext) then
            return true
        end
    end
    return false
end

function M:remove()
    Delete(self)
end

---@package
---@type Scope[]
ls.scope.all = {}

---@param uri? Uri
---@param fs? FileSystem
---@return Scope
function ls.scope.create(uri, fs)
    return New 'Scope' (uri, fs)
end

---@param uri Uri
---@return Scope?
function ls.scope.find(uri)
    for _, scope in ipairs(ls.scope.all) do
        if scope:testUri(uri) then
            return scope
        end
    end
    return nil
end
