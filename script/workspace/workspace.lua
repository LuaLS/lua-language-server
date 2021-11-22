local pub        = require 'pub'
local fs         = require 'bee.filesystem'
local furi       = require 'file-uri'
local files      = require 'files'
local config     = require 'config'
local glob       = require 'glob'
local platform   = require 'bee.platform'
local await      = require 'await'
local proto      = require 'proto.proto'
local lang       = require 'language'
local library    = require 'library'
local progress   = require 'progress'
local define     = require "proto.define"
local client     = require 'client'
local plugin     = require 'plugin'
local util       = require 'utility'
local fw         = require 'filewatch'

local m = {}
m.type = 'workspace'
m.nativeVersion  = -1
m.libraryVersion = -1
m.nativeMatcher  = nil
m.fileLoaded = 0
m.fileFound  = 0
m.waitingReady   = {}
m.requireCache   = {}
m.cache          = {}
m.watchers       = {}
m.matchOption    = {}

--- 初始化工作区
function m.initPath(uri)
    log.info('Workspace inited: ', uri)
    if not uri then
        return
    end
    m.uri  = uri
    m.path = m.normalize(furi.decode(uri))
    plugin.workspace = m.path
    local logPath = fs.path(LOGPATH) / (uri:gsub('[/:]+', '_') .. '.log')
    client.logMessage('Log', 'Log path: ' .. furi.encode(logPath:string()))
    log.info('Log path: ', logPath)
    log.init(ROOT, logPath)

    fw.watch(m.path)
end

local globInteferFace = {
    type = function (path)
        local result
        pcall(function ()
            if fs.is_directory(fs.path(path)) then
                result = 'directory'
            else
                result = 'file'
            end
        end)
        return result
    end,
    list = function (path)
        local fullPath = fs.path(path)
        if not fs.exists(fullPath) then
            return nil
        end
        local paths = {}
        pcall(function ()
            for fullpath in fs.pairs(fullPath) do
                paths[#paths+1] = fullpath:string()
            end
        end)
        return paths
    end
}

--- 创建排除文件匹配器
---@async
function m.getNativeMatcher()
    if not m.path then
        return nil
    end
    if m.nativeMatcher then
        return m.nativeMatcher
    end

    local pattern = {}
    -- config.get 'files.exclude'
    for path, ignore in pairs(config.get 'files.exclude') do
        if ignore then
            log.info('Ignore by exclude:', path)
            pattern[#pattern+1] = path
        end
    end
    -- config.get 'workspace.useGitIgnore'
    if config.get 'Lua.workspace.useGitIgnore' then
        local buf = pub.awaitTask('loadFile', furi.encode(m.path .. '/.gitignore'))
        if buf then
            for line in buf:gmatch '[^\r\n]+' do
                if line:sub(1, 1) ~= '#' then
                    log.info('Ignore by .gitignore:', line)
                    pattern[#pattern+1] = line
                end
            end
        end
        buf = pub.awaitTask('loadFile', furi.encode(m.path .. '/.git/info/exclude'))
        if buf then
            for line in buf:gmatch '[^\r\n]+' do
                if line:sub(1, 1) ~= '#' then
                    log.info('Ignore by .git/info/exclude:', line)
                    pattern[#pattern+1] = line
                end
            end
        end
    end
    -- config.get 'workspace.ignoreSubmodules'
    if config.get 'Lua.workspace.ignoreSubmodules' then
        local buf = pub.awaitTask('loadFile', furi.encode(m.path .. '/.gitmodules'))
        if buf then
            for path in buf:gmatch('path = ([^\r\n]+)') do
                log.info('Ignore by .gitmodules:', path)
                pattern[#pattern+1] = path
            end
        end
    end
    -- config.get 'workspace.library'
    for path in pairs(config.get 'Lua.workspace.library') do
        path = m.getAbsolutePath(path)
        if path then
            log.info('Ignore by library:', path)
            pattern[#pattern+1] = path
        end
    end
    -- config.get 'workspace.ignoreDir'
    for _, path in ipairs(config.get 'Lua.workspace.ignoreDir') do
        log.info('Ignore directory:', path)
        pattern[#pattern+1] = path
    end

    m.nativeMatcher = glob.gitignore(pattern, m.matchOption, globInteferFace)
    m.nativeMatcher:setOption('root', m.path)

    m.nativeVersion = config.get 'version'
    return m.nativeMatcher
end

--- 创建代码库筛选器
function m.getLibraryMatchers()
    if m.libraryMatchers then
        return m.libraryMatchers
    end

    local librarys = {}
    for path in pairs(config.get 'Lua.workspace.library') do
        path = m.getAbsolutePath(path)
        if path then
            librarys[m.normalize(path)] = true
        end
    end
    if library.metaPath then
        librarys[m.normalize(library.metaPath)] = true
    end
    m.libraryMatchers = {}
    for path in pairs(librarys) do
        if fs.exists(fs.path(path)) then
            local nPath = fs.absolute(fs.path(path)):string()
            local matcher = glob.gitignore(true, m.matchOption, globInteferFace)
            matcher:setOption('root', path)
            log.debug('getLibraryMatchers', path, nPath)
            m.libraryMatchers[#m.libraryMatchers+1] = {
                path    = nPath,
                matcher = matcher
            }
        end
    end

    m.libraryVersion = config.get 'version'
    return m.libraryMatchers
end

--- 文件是否被忽略
---@async
function m.isIgnored(uri)
    local path = m.getRelativePath(uri)
    local ignore = m.getNativeMatcher()
    if not ignore then
        return false
    end
    return ignore(path)
end

---@async
function m.isValidLuaUri(uri)
    if not files.isLua(uri) then
        return false
    end
    if  m.isIgnored(uri)
    and not files.isLibrary(uri) then
        return false
    end
    return true
end

local function loadFileFactory(root, progressData, isLibrary)
    return function (path) ---@async
        local uri = furi.encode(path)
        if files.isLua(uri) then
            if not isLibrary and progressData.preload >= config.get 'Lua.workspace.maxPreload' then
                if not m.hasHitMaxPreload then
                    m.hasHitMaxPreload = true
                    proto.request('window/showMessageRequest', {
                        type    = define.MessageType.Info,
                        message = lang.script('MWS_MAX_PRELOAD', config.get 'Lua.workspace.maxPreload'),
                        actions = {
                            {
                                title = lang.script.WINDOW_INCREASE_UPPER_LIMIT,
                            },
                            {
                                title = lang.script.WINDOW_CLOSE,
                            }
                        }
                    }, function (item)
                        if not item then
                            return
                        end
                        if item.title == lang.script.WINDOW_INCREASE_UPPER_LIMIT then
                            client.setConfig {
                                {
                                    key    = 'Lua.workspace.maxPreload',
                                    action = 'set',
                                    value  = config.get 'Lua.workspace.maxPreload'
                                           + math.max(1000, config.get 'Lua.workspace.maxPreload'),
                                }
                            }
                        end
                    end)
                end
                return
            end
            if not isLibrary then
                progressData.preload = progressData.preload + 1
            end
            progressData.max = progressData.max + 1
            progressData:update()
            pub.task('loadFile', uri, function (text)
                local loader = function ()
                    if text then
                        log.info(('Preload file at: %s , size = %.3f KB'):format(uri, #text / 1024.0))
                        if isLibrary then
                            log.info('++++As library of:', root)
                            files.setLibraryPath(uri, root)
                        end
                        files.setText(uri, text, false)
                    else
                        files.remove(uri)
                    end
                    progressData.read = progressData.read + 1
                    progressData:update()
                end
                if progressData.loaders then
                    progressData.loaders[#progressData.loaders+1] = loader
                else
                    loader()
                end
            end)
        end
        if files.isDll(uri) then
            progressData.max = progressData.max + 1
            progressData:update()
            pub.task('loadFile', uri, function (content)
                if content then
                    log.info(('Preload file at: %s , size = %.3f KB'):format(uri, #content / 1024.0))
                    if isLibrary then
                        log.info('++++As library of:', root)
                    end
                    files.saveDll(uri, content)
                end
                progressData.read = progressData.read + 1
                progressData:update()
            end)
        end
        await.delay()
    end
end

---@async
function m.awaitLoadFile(uri)
    local progressBar <close> = progress.create(lang.script.WORKSPACE_LOADING)
    local progressData = {
        max     = 0,
        read    = 0,
        preload = 0,
        update  = function (self)
            progressBar:setMessage(('%d/%d'):format(self.read, self.max))
            progressBar:setPercentage(self.read / self.max * 100)
        end
    }
    local nativeLoader    = loadFileFactory(m.path, progressData)
    local native          = m.getNativeMatcher()
    if native then
        log.info('Scan files at:', m.path)
        native:scan(furi.decode(uri), nativeLoader)
    end
end

--- 预读工作区内所有文件
---@async
function m.awaitPreload()
    local diagnostic = require 'provider.diagnostic'
    await.close 'preload'
    await.setID 'preload'
    await.sleep(0.1)
    diagnostic.pause()
    m.libraryMatchers = nil
    m.nativeMatcher   = nil
    m.fileLoaded      = 0
    m.fileFound       = 0
    m.cache           = {}
    for i, watchers in ipairs(m.watchers) do
        watchers()
        m.watchers[i] = nil
    end
    local progressBar <close> = progress.create(lang.script.WORKSPACE_LOADING)
    local progressData = {
        max     = 0,
        read    = 0,
        preload = 0,
        loaders = {},
        update  = function (self)
            progressBar:setMessage(('%d/%d'):format(self.read, self.max))
            progressBar:setPercentage(self.read / self.max * 100)
            m.fileLoaded = self.read
            m.fileFound  = self.max
        end
    }
    log.info('Preload start.')
    local nativeLoader    = loadFileFactory(m.path, progressData)
    local native          = m.getNativeMatcher()
    local librarys        = m.getLibraryMatchers()
    if native then
        log.info('Scan files at:', m.path)
        native:scan(m.path, nativeLoader)
    end
    for _, library in ipairs(librarys) do
        local libraryLoader = loadFileFactory(library.path, progressData, true)
        log.info('Scan library at:', library.path)
        library.matcher:scan(library.path, libraryLoader)
        m.watchers[#m.watchers+1] = fw.watch(library.path)
    end

    local isLoadingFiles = false
    local function loadSomeFiles()
        if isLoadingFiles then
            return
        end
        await.call(function () ---@async
            isLoadingFiles = true
            while true do
                local loader = table.remove(progressData.loaders)
                if not loader then
                    break
                end
                loader()
                await.delay()
            end
            isLoadingFiles = false
        end)
    end

    log.info(('Found %d files.'):format(progressData.max))
    while true do
        loadSomeFiles()
        log.info(('Loaded %d/%d files'):format(progressData.read, progressData.max))
        progressData:update()
        if progressData.read >= progressData.max then
            break
        end
        await.sleep(0.1)
    end
    progressBar:remove()

    log.info('Preload finish.')

    diagnostic.start()
end

--- 查找符合指定file path的所有uri
---@param path string
function m.findUrisByFilePath(path)
    if type(path) ~= 'string' then
        return {}
    end
    local lpath = furi.encode(path):gsub('^file:///', '')
    local vm    = require 'vm'
    local resultCache = vm.getCache 'findUrisByRequirePath.result'
    if resultCache[path] then
        return resultCache[path].results, resultCache[path].posts
    end
    tracy.ZoneBeginN('findUrisByFilePath #1')
    local strict = config.get 'Lua.runtime.pathStrict'
    local results = {}
    local posts = {}
    for uri in files.eachFile() do
        if not uri:find(lpath, 1, true) then
            goto CONTINUE
        end
        local relat = m.getRelativePath(uri)
        local pathLen = #path
        local curPath = relat
        local curLen  = #curPath
        local seg = curPath:sub(curLen - pathLen, curLen - pathLen)
        if seg == '/' or seg == '\\' or seg == '' then
            if strict and seg ~= '' then
                goto CONTINUE
            end
            local see = curPath:sub(curLen - pathLen + 1, curLen)
            if see == path then
                results[#results+1] = uri
                local post = curPath:sub(1, curLen - pathLen)
                posts[uri] = post:gsub('^[/\\]+', '')
            end
        end
        ::CONTINUE::
    end
    tracy.ZoneEnd()
    resultCache[path] = {
        results = results,
        posts   = posts,
    }
    return results, posts
end

--- 查找符合指定require path的所有uri
---@param path string
function m.findUrisByRequirePath(path)
    if type(path) ~= 'string' then
        return {}
    end
    local vm    = require 'vm'
    local cache = vm.getCache 'findUrisByRequirePath'
    if cache[path] then
        return cache[path].results, cache[path].searchers
    end
    tracy.ZoneBeginN('findUrisByRequirePath')
    local results = {}
    local mark = {}
    local searchers = {}
    for uri in files.eachDll() do
        local opens = files.getDllOpens(uri) or {}
        for _, open in ipairs(opens) do
            if open == path then
                results[#results+1] = uri
            end
        end
    end

    local input = path:gsub('%.', '/')
                      :gsub('%%', '%%%%')
    for _, luapath in ipairs(config.get 'Lua.runtime.path') do
        local part = m.normalize(luapath:gsub('%?', input))
        local uris, posts = m.findUrisByFilePath(part)
        for _, uri in ipairs(uris) do
            if not mark[uri] then
                mark[uri] = true
                results[#results+1] = uri
                searchers[uri] = posts[uri] .. luapath
            end
        end
    end
    tracy.ZoneEnd()
    cache[path] = {
        results   = results,
        searchers = searchers,
    }
    return results, searchers
end

function m.normalize(path)
    if not path then
        return nil
    end
    path = path:gsub('%$%{(.-)%}', function (key)
        if key == '3rd' then
            return (ROOT / 'meta' / '3rd'):string()
        end
        if key:sub(1, 4) == 'env:' then
            local env = os.getenv(key:sub(5))
            return env
        end
    end)
    path = util.expandPath(path)
    if platform.OS == 'Windows' then
        path = path:gsub('[/\\]+', '\\')
                   :gsub('[/\\]+$', '')
    else
        path = path:gsub('[/\\]+', '/')
                   :gsub('[/\\]+$', '')
    end
    return path
end

---@return string
function m.getAbsolutePath(path)
    if not path or path == '' then
        return nil
    end
    path = m.normalize(path)
    if fs.path(path):is_relative() then
        if not m.path then
            return nil
        end
        path = m.normalize(m.path .. '/' .. path)
    end
    return path
end

---@param uriOrPath uri|string
---@return string
function m.getRelativePath(uriOrPath)
    local path
    if uriOrPath:sub(1, 5) == 'file:' then
        path = furi.decode(uriOrPath)
    else
        path = uriOrPath
    end
    if not m.path then
        local relative = m.normalize(path)
        return relative:gsub('^[/\\]+', '')
    end
    local _, pos = m.normalize(path):find(m.path, 1, true)
    if pos then
        return m.normalize(path:sub(pos + 1)):gsub('^[/\\]+', '')
    else
        return m.normalize(path):gsub('^[/\\]+', '')
    end
end

function m.isWorkspaceUri(uri)
    if not m.uri then
        return false
    end
    local ruri = m.uri
    return uri:sub(1, #ruri) == ruri
end

--- 获取工作区等级的缓存
function m.getCache(name)
    if not m.cache[name] then
        m.cache[name] = {}
    end
    return m.cache[name]
end

function m.flushCache()
    m.cache = {}
end

function m.reload()
    if not m.inited then
        return
    end
    if TEST then
        return
    end
    await.call(m.awaitReload)
end

function m.init()
    if m.inited then
        return
    end
    m.inited = true
    m.reload()
end

---@async
function m.awaitReload()
    m.ready = false
    m.hasHitMaxPreload = false
    files.flushAllLibrary()
    files.removeAllClosed()
    files.flushCache()
    plugin.init()
    m.awaitPreload()
    m.ready = true
    local waiting = m.waitingReady
    m.waitingReady = {}
    for _, waker in ipairs(waiting) do
        waker()
    end
end

---等待工作目录加载完成
---@async
function m.awaitReady()
    if m.isReady() then
        return
    end
    await.wait(function (waker)
        m.waitingReady[#m.waitingReady+1] = waker
    end)
end

function m.isReady()
    return m.ready == true
end

function m.getLoadProcess()
    return m.fileLoaded, m.fileFound
end

files.watch(function (ev, uri) ---@async
    if  ev == 'close'
    and m.isIgnored(uri)
    and not files.isLibrary(uri) then
        files.remove(uri)
    end
end)

config.watch(function (key, value, oldValue)
    if key:find '^Lua.runtime'
    or key:find '^Lua.workspace'
    or key:find '^files' then
        if value ~= oldValue then
            m.reload()
        end
    end
end)

fw.event(function (changes) ---@async
    m.awaitReady()
    for _, change in ipairs(changes) do
        local path = change.path
        local uri  = furi.encode(path)
        if  not m.isWorkspaceUri(uri)
        and not files.isLibrary(uri) then
            goto CONTINUE
        end
        if     change.type == 'create' then
            log.debug('FileChangeType.Created', uri)
            m.awaitLoadFile(uri)
        elseif change.type == 'delete' then
            log.debug('FileChangeType.Deleted', uri)
            files.remove(uri)
            local childs = files.getChildFiles(uri)
            for _, curi in ipairs(childs) do
                log.debug('FileChangeType.Deleted.Child', curi)
                files.remove(curi)
            end
        elseif change.type == 'change' then
            if m.isValidLuaUri(uri) then
                -- 如果文件处于关闭状态，则立即更新；否则等待didChange协议来更新
                if not files.isOpen(uri) then
                    files.setText(uri, pub.awaitTask('loadFile', uri), false)
                end
            else
                local filename = fs.path(path):filename():string()
                -- 排除类文件发生更改需要重新扫描
                if filename == '.gitignore'
                or filename == '.gitmodules' then
                    m.reload()
                    break
                end
            end
        end
        ::CONTINUE::
    end
end)

return m
