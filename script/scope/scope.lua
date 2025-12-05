require 'file'

---@class Scope
local M = Class 'Scope'

M.ready = false

---@param name string
---@param uri? Uri
---@param fs? FileSystem
function M:__init(name, uri, fs)
    self.name = name
    self.uri = uri
    self.fs  = fs or ls.fs
    table.insert(ls.scope.all, self)

    ---@type Uri[]
    self.includeUris = {}
    ---@type Config
    self.config = ls.config.create(self.uri)

    self.rt = ls.node.createRuntime(self)
    self.rt:reset()

    ---@type table<Uri, Document?>
    self.documents = {}

    self.vm = ls.vm.create(self)
end

function M:__del()
    ls.util.arrayRemove(ls.scope.all, self)
end

function M:__close()
    self:remove()
end

function M:start()
    -- TODO: 需要先读配置文件
    ---@async
    ls.await.call(function ()
        self:load(function (event, status, uri)
            if event == 'start' then
                log.info('[Scope] Start loading: {}' % { self.name })
                return
            end
            if event == 'finding' then
                log.debug('[Scope]({}) Found file({}): {}' % { self.name, status.found, uri })
                return
            end
            if event == 'found' then
                log.info('[Scope]({}) Found {} files.' % { self.name, status.found })
                return
            end
            if event == 'loading' then
                log.debug('[Scope]({}) Loading file({}/{}): {}' % { self.name, status.loaded, status.found, uri })
                return
            end
            if event == 'loaded' then
                log.info('[Scope]({}) Loaded {} files.' % { self.name, status.loaded })
                return
            end
            if event == 'indexing' then
                log.debug('[Scope]({}) Indexing file({}/{}): {}' % { self.name, status.indexed, status.loaded, uri })
                return
            end
            if event == 'indexed' then
                log.info('[Scope]({}) Indexed {} files.' % { self.name, status.indexed })
                return
            end
            if event == 'finish' then
                log.info('[Scope] Finished loading: {}' % { self.name })
                return
            end
        end)
    end)

    self.ready = true
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
        ---@type Document
        document = New 'Document' (file)
        self.documents[file.uri] = document
        document:bindGC(function ()
            self.documents[file.uri] = nil
        end)
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

---@param encoding Encoder.Encoding
---@return Scope.LSPConverter
function M:makeLSPConverter(encoding)
    return New 'Scope.LSPConverter' (self, encoding)
end

function M:remove()
    Delete(self)
end

---@package
---@type Scope[]
ls.scope.all = {}

---@param name string
---@param uri? Uri
---@param fs? FileSystem
---@return Scope
function ls.scope.create(name, uri, fs)
    return New 'Scope' (name, uri, fs)
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

---@param uri Uri
---@return Document?
---@return Scope?
function ls.scope.findDocument(uri)
    local scope = ls.scope.find(uri)
    if not scope then
        return nil
    end
    local doc = scope:getDocument(uri)
    if not doc then
        return nil
    end
    return doc, scope
end

---@param uri Uri
---@param offset integer
---@param accepts? table<string, true>
---@return LuaParser.Node.Base[]?
---@return Scope?
---@return Document?
function ls.scope.findSources(uri, offset, accepts)
    local scope = ls.scope.find(uri)
    if not scope then
        return nil
    end
    local doc = scope:getDocument(uri)
    if not doc then
        return nil
    end
    local sources = doc:findSources(offset, accepts)
    if #sources == 0 then
        return nil
    end
    return sources, scope, doc
end

function ls.scope.watchFiles()
    ls.file.onDidChange:on(function (uri)
        local scope = ls.scope.find(uri)
        if not scope then
            return
        end
        ---@async
        ls.await.call(function ()
            scope.vm:awaitIndexFile(uri)
        end)
    end)

    ls.file.onDidRemove:on(function (uri)
        local scope = ls.scope.find(uri)
        if not scope then
            return
        end
        scope.vm:removeFile(uri)
    end)
end
