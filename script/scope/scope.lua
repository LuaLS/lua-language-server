---@class Scope
local M = Class 'Scope'

---@param uri? Uri
function M:__init(uri)
    self.node = ls.node.createAPIs(self)
    self.node:fillPresets()

    self.uri = uri
    ---@type Uri[]
    self.includeUris = {}

    self.documents = ls.pathTable.create(false, true)

    table.insert(ls.scope.all, self)
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
function M:makeDocument(uri)
    local file = ls.file.get(uri)
    if not file then
        return nil
    end
    local path = { file.uri, file.serverVersion }
    local document = self.documents:get(path)
    if not document then
        document = New 'Document' (file)
        self.documents:set(path, document)
    end
    return document
end

function M:remove()
    Delete(self)
end

---@package
---@type Scope[]
ls.scope.all = {}

---@param uri? Uri
---@return Scope
function ls.scope.create(uri)
    return New 'Scope' (uri)
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
