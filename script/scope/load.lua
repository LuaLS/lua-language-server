---@class Scope
local Scope = Class 'Scope'

---@class Scope.Root
local M = Class 'Scope.Root'

---@param scope Scope
---@param kind 'workspace' | 'library'
---@param uri Uri
---@param fs FileSystem
---@param config Config
function M:__init(scope, kind, uri, fs, config)
    self.scope  = scope
    self.kind   = kind
    self.uri    = uri
    self.fs     = fs
    self.config = config
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

---@param options Scope.Load.Options
function Scope:buildRoots(options)
    self.roots = {}
    self.includeUris = {}

    if self.uri then
        self.roots[#self.roots+1] = New 'Scope.Root' (self, 'workspace', self.uri, self.fs, self.config)
    end

    if not self.uri then
        return
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
    end

    xpcall(callback, log.error, 'finish', status)

    return status
end
