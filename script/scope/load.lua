local beefw       = require 'bee.filewatch'
local bfs         = require 'bee.filesystem'
local metaBuilder = require 'scope.meta-builder'

---@class Scope
local Scope = Class 'Scope'

---@class Scope.Root
---@field uriSet table<Uri, true>
---@field private _watcher bee.filewatch.watch?
local M = Class 'Scope.Root'

---@param scope Scope
---@param kind 'workspace' | 'library'
---@param uri Uri
---@param fs FileSystem
---@param config Config
function M:__init(scope, kind, uri, fs, config)
    self.scope   = scope
    self.kind    = kind
    self.uri     = uri
    self.fs      = fs
    self.config  = config
    self.uriSet  = ls.fs.newMap()
    self._watcher = nil
end

---@param options Scope.Load.Options
function M:initGlob(options)
    if self.glob then
        return
    end
    local ignores = {}
    if options.ignores then
        ls.util.arrayMerge(ignores, options.ignores)
    end
    ignores[#ignores+1] = '.git'
    ignores[#ignores+1] = '.svn'
    ignores[#ignores+1] = '.hg'
    ignores[#ignores+1] = '.DS_Store'
    self.glob = ls.glob.gitignore(ignores)
    self.glob:setOption('root', self.uri)
    self.glob:setOption('ignoreCase', ls.env.IGNORE_CASE)
    self.glob:setInterface('type', function (uri)
        return self.fs.getType(uri)
    end)
    self.glob:setInterface('list', function (uri)
        do -- 顺便加载该目录下的 `.luarc.json` 配置文件
            local rcUri = uri / '.luarc.json'
            self.config:loadRC(rcUri)
        end
        return self.fs.getChilds(uri)
    end)
    self.glob:setInterface('patterns', function (uri)
        local patterns = {}
        do -- 忽略配置 `Lua.workspace.ignoreDir` 中定义的文件
            local ignoreDirs = self.config:getRaw(uri, 'Lua.workspace.ignoreDir')
            if ignoreDirs then
                ls.util.arrayMerge(patterns, ignoreDirs)
            end
        end
        -- 应用 .gitignore 中定义的规则
        if self.config:get(uri, 'Lua.workspace.useGitIgnore') then
            local ignoreUri = uri / '.gitignore'
            local content = self.fs.read(ignoreUri)
            if content then
                for line in ls.util.eachLine(content) do
                    local path = ls.util.trim(line)
                    if  #path > 0
                    and not ls.util.stringStartWith(path, '#') then
                        patterns[#patterns+1] = path
                    end
                end
            end
        end
        -- 忽略子模块
        if self.config:get(uri, 'Lua.workspace.ignoreSubmodules') then
            local submoduleUri = uri / '.gitmodules'
            local content = self.fs.read(submoduleUri)
            if content then
                for line in ls.util.eachLine(content) do
                    local trimmedLine = ls.util.trim(line)
                    if ls.util.stringStartWith(trimmedLine, 'path = ') then
                        local path = trimmedLine:sub(8)
                        if #path > 0 then
                            patterns[#patterns+1] = path
                        end
                    end
                end
            end
        end
        return patterns
    end)
end

---@alias Scope.Load.Event
---| 'start'
---| 'scanning'
---| 'finding'
---| 'found'
---| 'loading'
---| 'loaded'
---| 'indexing'
---| 'indexed'
---| 'finish'

---@class Scope.Load.Status
---@field scanned integer
---@field found integer
---@field loaded integer
---@field indexed integer
---@field uris Uri[]

---@class Scope.Load.Options
---@field ignores? string[]

---@package
---@async
---@param uri Uri
---@param options Scope.Load.Options
---@param callback fun(event: Scope.Load.Event, status: Scope.Load.Status, uri?: Uri)
---@return Scope.Load.Status
function M:load(uri, options, callback)
    self:initGlob(options)

    ---@type Scope.Load.Status
    local status = {
        scanned = 0,
        found = 0,
        loaded = 0,
        indexed = 0,
        uris = {},
    }

    xpcall(callback, log.error, 'start', status)

    ---@async
    ls.util.withDuration(function ()
        self:loadFiles(uri, callback, status)
    end, function (duration)
        log.info('Load files for "{}:{}" in {%.2f} seconds.' % { self.scope.name, self.kind, duration })
    end)

    xpcall(callback, log.error, 'finish', status)

    return status
end

---@package
---@async
---@param targetUri Uri
---@param callback fun(event: Scope.Load.Event, status: Scope.Load.Status, uri?: Uri)
---@param status Scope.Load.Status
function M:loadFiles(targetUri, callback, status)
    self.glob:scan(targetUri, function (uri)
        status.scanned = status.scanned + 1
        xpcall(callback, log.error, 'scanning', status, uri)
        if self.scope:isValidUri(uri) then
            status.uris[#status.uris+1] = uri
            self.uriSet[uri] = true
            status.found = status.found + 1
            xpcall(callback, log.error, 'finding', status, uri)
        end
    end)
    xpcall(callback, log.error, 'found', status)

    local loadTasks = {}

    for _, uri in ipairs(status.uris) do
        ---@async
        loadTasks[#loadTasks+1] = function ()
            local content = self.fs.read(uri)
            if content then
                ls.file.setServerText(uri, content)
            end
            status.loaded = status.loaded + 1

            xpcall(callback, log.error, 'loading', status, uri)

            if status.loaded == status.found then
                xpcall(callback, log.error, 'loaded', status)
            end

            ls.await.sleep(0)

            self.scope.vm:awaitIndexFile(uri)
            status.indexed = status.indexed + 1

            xpcall(callback, log.error, 'indexing', status, uri)
        end
    end

    ls.await.waitAll(loadTasks)

    xpcall(callback, log.error, 'indexed', status)
end

--- 全局待轮询 Root 列表
---@type Scope.Root[]
local watchRoots = {}

---启动文件监控，在 load 完成后调用
---@package
function M:startWatch()
    if self._watcher then
        return
    end
    local nativePath = ls.uri.decode(self.uri)
    local watcher = beefw.create()
    watcher:set_recursive(true)
    watcher:set_follow_symlinks(false)
    watcher:add(nativePath)
    self._watcher = watcher
    watchRoots[#watchRoots+1] = self
end

---停止文件监控
---@package
function M:stopWatch()
    if not self._watcher then
        return
    end
    for i = #watchRoots, 1, -1 do
        if watchRoots[i] == self then
            table.remove(watchRoots, i)
            break
        end
    end
    self._watcher = nil
end

---轮询一次底层 watcher 事件
---@package
function M:pollWatch()
    if not self._watcher then
        return
    end
    while true do
        local eventType, nativePath = self._watcher:select()
        if not eventType then
            break
        end
        ---@cast nativePath -?
        self:_onWatchEvent(eventType, nativePath)
    end
end

---处理单条 bee.filewatch 原始事件
---@package
---@param eventType string
---@param nativePath string
function M:_onWatchEvent(eventType, nativePath)
    local uri = ls.uri.encode(nativePath)

    if eventType == 'modify' then
        if self.uriSet[uri] then
            local content = self.fs.read(uri)
            if content then
                ls.file.setServerText(uri, content)
            end
        end
        return
    end

    -- 'rename' 事件：通过 exists + is_directory 区分四种情况
    local bPath = bfs.path(nativePath)
    if bfs.exists(bPath) then
        -- 出现了：目录 → 扫描新文件；文件 → 直接创建
        if bfs.is_directory(bPath) then
            self:_expandDirCreate(uri)
        elseif not self.uriSet[uri] and self.scope:isValidUri(uri) then
            self:_onFileCreate(uri)
        end
    else
        -- 消失了：已知文件 → 删除；未知路径 → 尝试目录展开
        if self.uriSet[uri] then
            self:_onFileDelete(uri)
        else
            self:_expandDirDelete(uri)
        end
    end
end

---目录消失：遍历 uriSet 找前缀匹配的所有已知文件并删除
---@package
---@param dirUri Uri
function M:_expandDirDelete(dirUri)
    local toDelete = {}
    for uri in pairs(self.uriSet) do
        if ls.uri.relativePath(uri, dirUri) then
            toDelete[#toDelete+1] = uri
        end
    end
    for _, uri in ipairs(toDelete) do
        self:_onFileDelete(uri)
    end
end

---目录出现：用 glob 扫描新目录，将尚未记录的文件加入
---@package
---@param dirUri Uri
function M:_expandDirCreate(dirUri)
    if not self.glob then
        return
    end
    self.glob:scan(dirUri, function (uri)
        if self.scope:isValidUri(uri) and not self.uriSet[uri] then
            self:_onFileCreate(uri)
        end
    end)
end

---文件出现：写入 ls.file 并记录到 uriSet
---@package
---@param uri Uri
function M:_onFileCreate(uri)
    self.uriSet[uri] = true
    local content = self.fs.read(uri)
    if content then
        ls.file.setServerText(uri, content)
    end
end

---文件消失：从 uriSet 移除并通知 ls.file
---@package
---@param uri Uri
function M:_onFileDelete(uri)
    self.uriSet[uri] = nil
    local file = ls.file.get(uri)
    if file then
        file:removeByServer()
    end
end

---轮询所有活跃 Root 的 watcher（供 event loop 调用）
function ls.scope.pollWatchers()
    for _, root in ipairs(watchRoots) do
        root:pollWatch()
    end
end

---@param path string
---@return Uri?
function Scope:resolveLibraryUri(path)
    if path == '' then
        return nil
    end
    if ls.uri.isFile(path) then
        return ls.uri.normalize(path)
    end
    if path:find('^%a+://') then
        return nil
    end
    if  path:find('^%a:[/\\]')
    or  path:find('^[/\\][/\\]')
    or  path:sub(1, 1) == '/' then
        return ls.uri.encode(path)
    end
    if not self.uri then
        return nil
    end
    return ls.uri.normalize(self.uri / path)
end

---@async
---@param options Scope.Load.Options
function Scope:buildRoots(options)
    self.roots = {}
    self.includeUris = {}

    if self.uri then
        self.roots[#self.roots+1] = New 'Scope.Root' (self, 'workspace', self.uri, self.fs, self.config)
    end

    do
        local metaUri = metaBuilder.compile('Lua 5.5', 'en-us', 'utf-8')
        self.roots[#self.roots+1] = New 'Scope.Root' (self, 'meta', metaUri, self.fs, self.config)
    end

    local libraries = self.config:get(self.uri, 'Lua.workspace.library')
    if type(libraries) ~= 'table' then
        return
    end

    local seen = {}

    for _, path in ipairs(libraries) do
        if type(path) == 'string' then
            local libUri = self:resolveLibraryUri(path)
            if libUri
            and (not self.uri or not ls.uri.relativePath(libUri, self.uri)) then
                if seen[libUri] then
                    goto CONTINUE
                end
                local ftype = self.fs.getType(libUri)
                if ftype == 'directory' then
                    seen[libUri] = true
                    self.roots[#self.roots+1] = New 'Scope.Root' (self, 'library', libUri, self.fs, self.config)
                    self.includeUris[#self.includeUris+1] = libUri
                else
                    log.warn('[Scope] Ignore library path: {} ({})' % { path, ftype or 'not found' })
                end
            end
        end
        ::CONTINUE::
    end
end

---@async
---@param options Scope.Load.Options
---@param callback fun(event: Scope.Load.Event, status: Scope.Load.Status, uri?: Uri)
---@return Scope.Load.Status
function Scope:load(options, callback)
    if #self.roots == 0 then
        if self.uri then
            self.config:loadRC(self.uri / '.luarc.json')
        end
        self:buildRoots(options)
    end

    ---@type Scope.Load.Status
    local status = {
        scanned = 0,
        found = 0,
        loaded = 0,
        indexed = 0,
        uris = {},
    }

    xpcall(callback, log.error, 'start', status)

    for _, root in ipairs(self.roots) do
        root:load(root.uri, options, function (event, _, uri)
            if event == 'start' or event == 'finish' then
                return
            end
            if event == 'scanning' then
                status.scanned = status.scanned + 1
            elseif event == 'finding' then
                status.found = status.found + 1
                status.uris[#status.uris+1] = uri
            elseif event == 'loading' then
                status.loaded = status.loaded + 1
            elseif event == 'indexing' then
                status.indexed = status.indexed + 1
            end
            xpcall(callback, log.error, event, status, uri)
        end)
        root:startWatch()
    end

    xpcall(callback, log.error, 'finish', status)

    return status
end
