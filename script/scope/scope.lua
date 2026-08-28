local time = require 'bee.time'
require 'file'

---@class Scope: Node.RefModule
local M = Class 'Scope'

Extends('Scope', 'Node.RefModule')

M.ready = false

---@type Feature.Diagnostic.Scope?
M.diagnostic = nil

---@param name string
---@param uri Uri
---@param fs? FileSystem
function M:__init(name, uri, fs)
    self.name = name
    self.uri = uri
    self.fs  = fs or ls.fs
    self.scope = self
    table.insert(ls.scope.all, self)

    ---@type Uri[]
    self.includeUris = {}
    ---@type Scope.Root[]
    self.roots = {}
    ---@type Config
    self.config = ls.config.create(self.uri)

    self.rt = ls.node.createRuntime(self)
    self.rt:reset()

    ---@type Uri[]
    self.uris = {}
    ---@type table<Uri, Document?>
    self.documents = {}

    self.wordIndex = New 'Scope.WordIndex' (self)

    self.vm = ls.vm.create(self)
end

function M:__del()
    ls.util.arrayRemove(ls.scope.all, self)
end

function M:__close()
    self:remove()
end

---@param options Scope.Load.Options
function M:reload(options)
    self.ready = false
    ---@async
    ls.await.call(function ()
        if self.uri then
            self.config:loadRC(self.uri / '.luarc.json')
        end
        self:buildRoots(options)

        local startTime = time.monotonic()
        local prog <close> = ls.progress.create(self.uri, ('正在加载工作区: %s'):format(self.name), 0.5)
        local scanFinished = 0
        local result = self:load(options, function (event, status, uri)
            if event == 'start' then
                log.info('[Scope] Start loading: {}' % { self.name })
                return
            end
            if event == 'finding' then
                log.debug('[Scope]({}) Found file({}): {}' % { self.name, status.found, uri })
                return
            end
            if event == 'found' then
                log.info('[Scope]({}) Found {} files in {%.3f} seconds.' % { self.name, status.found, (time.monotonic() - startTime) / 1000 })
                scanFinished = scanFinished + 1
                return
            end
            if event == 'loading' then
                log.debug('[Scope]({}) Loading file({}/{}): {}' % { self.name, status.loaded, status.found, uri })
                return
            end
            if event == 'loaded' then
                log.info('[Scope]({}) Loaded {} files in {%.3f} seconds.' % { self.name, status.loaded, (time.monotonic() - startTime) / 1000 })
                return
            end
            if event == 'indexing' then
                log.debug('[Scope]({}) Indexing file({}/{}): {}' % { self.name, status.indexed, status.loaded, uri })
                if scanFinished >= #self.roots and status.found > 0 then
                    prog:setMessage(('%d/%d'):format(status.indexed, status.found))
                    prog:setPercentage(status.indexed / status.found * 100)
                end
                return
            end
            if event == 'indexed' then
                log.info('[Scope]({}) Indexed {} files in {%.3f} seconds.' % { self.name, status.indexed, (time.monotonic() - startTime) / 1000 })
                return
            end
            if event == 'finish' then
                log.info('[Scope] Finished loading: {} in {%.3f} seconds.' % { self.name, (time.monotonic() - startTime) / 1000 })
                return
            end
        end)
        self.uris = result.uris
        self.ready = true
        ls.scope.onDidLoad:fire(self)
    end)
end

---@param uri Uri
---@return 'workspace' | 'include' | nil
function M:testUri(uri)
    for _, root in ipairs(self.roots) do
        if root.uri == uri or ls.uri.relativePath(uri, root.uri) then
            if root.kind == 'workspace' then
                return 'workspace'
            end
            return 'include'
        end
    end
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
---@return string?
function M:getRelativePath(uri)
    if not self.uri then
        return nil
    end
    return ls.uri.relativePath(uri, self.uri)
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
        document = New 'Document' (file, self)
        self.documents[file.uri] = document
        document:bindGC(function ()
            self.documents[file.uri] = nil
        end)
    end
    return document
end

--- 文件根 return 的第一个返回值
---@param uri Uri
---@return Node?
function M:getMainReturn(uri)
    local vfile = self.vm:indexFile(uri)
    if not vfile then
        return nil
    end
    return vfile:getMainReturn()
end

--- 根据配置构建 parser 编译选项
---@param uri Uri
---@return LuaParser.CompileOptions?
function M:makeCompileOptions(uri)
    local options = {}

    local version = self.config:get(uri, 'Lua.runtime.version')
    if version == 'LuaJIT' then
        options.version = 'Lua 5.1'
        options.jit = true
    elseif version and version ~= 'Lua 5.4' then
        options.version = version
    end

    if self.config:get(uri, 'Lua.runtime.unicodeName') then
        options.unicodeName = true
    end

    local symbols = self.config:get(uri, 'Lua.runtime.nonstandardSymbol')
    if type(symbols) == 'table' and #symbols > 0 then
        options.nonestandardSymbols = symbols
    end

    if not next(options) then
        return nil
    end
    return options
end

---@async
---@param uri Uri
---@return boolean
function M:isIgnored(uri)
    for _, root in ipairs(self.roots) do
        if root.uri == uri or ls.uri.relativePath(uri, root.uri) then
            if not root.glob then
                return false
            end
            return root.glob:check(uri)
        end
    end
    return false
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

---@type Scope[]
ls.scope.all = {}

---@param name string
---@param uri Uri
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
---@return VM.Vfile?
function ls.scope.findVfile(uri)
    local scope = ls.scope.find(uri)
    if not scope then
        return nil
    end
    return scope.vm:getFile(uri)
end

---@async
---@param uri Uri
function ls.scope.waitIndexing(uri)
    local scope = ls.scope.find(uri)
    if not scope then
        return
    end
    if #scope.vm.indexingFiles == 0 then
        return
    end
    ls.await.yield(function (resume)
        scope.vm.onDidIndex:on(function ()
            if #scope.vm.indexingFiles == 0 then
                resume()
            end
        end)
    end)
end

---@async
---@param uri Uri
function ls.scope.waitReady(uri)
    local scope = ls.scope.find(uri)
    if not scope or scope.ready then
        return
    end
    ls.await.yield(function (resume)
        local unsubscribe
        unsubscribe = ls.scope.onDidLoad:on(function (s)
            if s == scope then
                unsubscribe()
                resume()
            end
        end)
    end)
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
    ls.eventLoop.addTask(ls.scope.pollWatchers)

    ls.file.onDidChange:on(function (uri)
        local scope = ls.scope.find(uri)
        if not scope then
            return
        end
        scope.wordIndex:markDirty(uri)
        ---@async
        ls.await.call(function ()
            ls.scope.waitReady(uri)
            scope.vm:awaitIndexFile(uri)
        end)
    end)

    ls.file.onDidRemove:on(function (uri)
        local scope = ls.scope.find(uri)
        if not scope then
            return
        end
        scope.wordIndex:markRemoved(uri)
        scope.vm:removeFile(uri)
    end)
end
