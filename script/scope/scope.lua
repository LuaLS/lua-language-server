---@class Scope
local M = Class 'Scope'

---@param uri? Uri
function M:__init(uri)
    self.uri = uri
    table.insert(ls.scope.all, self)

    ---@type Uri[]
    self.includeUris = {}

    self.node = ls.node.createManager(self)
    self.node:reset()

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

function M:initGlob()
    if self.glob then
        return
    end
    self.glob = ls.glob.gitignore()
    self.glob:setInterface('type', function (uri)
        return ls.fs.getType(uri)
    end)
    self.glob:setInterface('list', function (uri)
        return ls.fs.getChilds(uri)
    end)
end

---@return Uri[]
function M:scan()
    self:initGlob()

    local uris = {}
    self.glob:scan(self.uri, function (path)
        if ls.util.stringEndWith(path, '.lua') then
            uris[#uris+1] = ls.uri.encode(path)
        end
    end)

    return uris
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
