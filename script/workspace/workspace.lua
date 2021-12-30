local pub        = require 'pub'
local fs         = require 'bee.filesystem'
local furi       = require 'file-uri'
local files      = require 'files'
local config     = require 'config'
local glob       = require 'glob'
local platform   = require 'bee.platform'
local await      = require 'await'
local library    = require 'library'
local client     = require 'client'
local plugin     = require 'plugin'
local util       = require 'utility'
local fw         = require 'filewatch'
local scope      = require 'workspace.scope'
local loading    = require 'workspace.loading'

---@class workspace
local m = {}
m.type = 'workspace'
---@type scope[]
m.folders = {}

function m.initRoot(uri)
    m.rootUri  = uri
    log.info('Workspace init root: ', uri)

    local logPath = fs.path(LOGPATH) / (uri:gsub('[/:]+', '_') .. '.log')
    client.logMessage('Log', 'Log path: ' .. furi.encode(logPath:string()))
    log.info('Log path: ', logPath)
    log.init(ROOT, logPath)
end

--- 初始化工作区
function m.create(uri)
    log.info('Workspace create: ', uri)
    local path = m.normalize(furi.decode(uri))
    fw.watch(path)
    local scp = scope.createFolder(uri)
    m.folders[#m.folders+1] = scp
end

function m.getRootUri(uri)
    local scp = m.getScope(uri)
    return scp.uri
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
---@param scp scope
function m.getNativeMatcher(scp)
    if scp:get 'nativeMatcher' then
        return scp:get 'nativeMatcher'
    end

    local pattern = {}
    -- config.get(nil, 'files.exclude'
    for path, ignore in pairs(config.get(scp.uri, 'files.exclude')) do
        if ignore then
            log.info('Ignore by exclude:', path)
            pattern[#pattern+1] = path
        end
    end
    -- config.get(nil, 'workspace.useGitIgnore'
    if config.get(scp.uri, 'Lua.workspace.useGitIgnore') then
        local buf = pub.awaitTask('loadFile', m.rootUri .. '/.gitignore')
        if buf then
            for line in buf:gmatch '[^\r\n]+' do
                if line:sub(1, 1) ~= '#' then
                    log.info('Ignore by .gitignore:', line)
                    pattern[#pattern+1] = line
                end
            end
        end
        buf = pub.awaitTask('loadFile', m.rootUri .. '/.git/info/exclude')
        if buf then
            for line in buf:gmatch '[^\r\n]+' do
                if line:sub(1, 1) ~= '#' then
                    log.info('Ignore by .git/info/exclude:', line)
                    pattern[#pattern+1] = line
                end
            end
        end
    end
    -- config.get(nil, 'workspace.ignoreSubmodules'
    if config.get(scp.uri, 'Lua.workspace.ignoreSubmodules') then
        local buf = pub.awaitTask('loadFile', m.rootUri .. '/.gitmodules')
        if buf then
            for path in buf:gmatch('path = ([^\r\n]+)') do
                log.info('Ignore by .gitmodules:', path)
                pattern[#pattern+1] = path
            end
        end
    end
    -- config.get(nil, 'workspace.library'
    for path in pairs(config.get(scp.uri, 'Lua.workspace.library')) do
        path = m.getAbsolutePath(path)
        if path then
            log.info('Ignore by library:', path)
            pattern[#pattern+1] = path
        end
    end
    -- config.get(nil, 'workspace.ignoreDir'
    for _, path in ipairs(config.get(scp.uri, 'Lua.workspace.ignoreDir')) do
        log.info('Ignore directory:', path)
        pattern[#pattern+1] = path
    end

    local matcher = glob.gitignore(pattern, {
        root       = furi.decode(scp.uri),
        ignoreCase = platform.OS == 'Windows',
    }, globInteferFace)

    scp:set('nativeMatcher', matcher)
    return matcher
end

--- 创建代码库筛选器
---@param scp scope
function m.getLibraryMatchers(scp)
    if scp:get 'nativeMatcher' then
        return scp:get 'nativeMatcher'
    end

    local librarys = {}
    for path in pairs(config.get(scp.uri, 'Lua.workspace.library')) do
        path = m.getAbsolutePath(path)
        if path then
            librarys[m.normalize(path)] = true
        end
    end
    -- TODO
    if library.metaPath then
        librarys[m.normalize(library.metaPath)] = true
    end

    local matchers = {}
    for path in pairs(librarys) do
        if fs.exists(fs.path(path)) then
            local nPath = fs.absolute(fs.path(path)):string()
            local matcher = glob.gitignore(true, {
                root       = path,
                ignoreCase = platform.OS == 'Windows',
            }, globInteferFace)
            matchers[#matchers+1] = {
                uri     = furi.encode(nPath),
                matcher = matcher
            }
        end
    end

    scp:set('nativeMatcher', matchers)

    return matchers
end

--- 文件是否被忽略
---@async
---@param uri uri
function m.isIgnored(uri)
    local scp    = m.getScope(uri)
    local path   = m.getRelativePath(uri)
    local ignore = m.getNativeMatcher(scp)
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

---@async
function m.awaitLoadFile(uri)
    local scp = m.getScope(uri)
    local ld <close> = loading.create(scp)
    local native = m.getNativeMatcher(scp)
    log.info('Scan files at:', uri)
    ---@async
    native:scan(furi.decode(uri), function (path)
        ld:scanFile(furi.encode(path))
    end)
    ld:loadAll()
end

--- 预读工作区内所有文件
---@async
---@param scp scope
function m.awaitPreload(scp)
    await.close 'preload'
    await.setID 'preload'
    await.sleep(0.1)

    local watchers = scp:get 'watchers'
    if watchers then
        for _, dispose in ipairs(watchers) do
            dispose()
        end
    end
    watchers = {}
    scp:set('watchers', watchers)

    local ld <close> = loading.create(scp)
    scp:set('loading', ld)

    log.info('Preload start:', scp.uri)

    local native   = m.getNativeMatcher(scp)
    local librarys = m.getLibraryMatchers(scp)

    do
        log.info('Scan files at:', m.rootUri)
        ---@async
        native:scan(furi.decode(scp.uri), function (path)
            ld:scanFile(furi.encode(path))
        end)
    end

    for _, libMatcher in ipairs(librarys) do
        log.info('Scan library at:', libMatcher.uri)
        ---@async
        libMatcher.matcher:scan(furi.decode(libMatcher.uri), function (path)
            ld:scanFile(furi.encode(path), libMatcher.uri)
        end)
        watchers[#watchers+1] = fw.watch(furi.decode(libMatcher.uri))
    end

    log.info(('Found %d files.'):format(ld.max))
    ld:loadAll()
    log.info('Preload finish.')
end

--- 查找符合指定file path的所有uri
---@param path string
function m.findUrisByFilePath(path)
    if type(path) ~= 'string' then
        return {}
    end
    local myUri = furi.encode(path)
    local vm    = require 'vm'
    local resultCache = vm.getCache 'findUrisByRequirePath.result'
    if resultCache[path] then
        return resultCache[path]
    end
    local results = {}
    for uri in files.eachFile() do
        if uri == myUri then
            results[#results+1] = uri
        end
    end
    resultCache[path] = results
    return results
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
    path = path:gsub('^%.[/\\]+', '')
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
function m.getAbsolutePath(folderUriOrPath, path)
    if not path or path == '' then
        return nil
    end
    path = m.normalize(path)
    if fs.path(path):is_relative() then
        if not folderUriOrPath then
            return nil
        end
        local folderPath
        if folderUriOrPath:sub(1, 5) == 'file:' then
            folderPath = furi.decode(folderUriOrPath)
        else
            folderPath = folderUriOrPath
        end
        path = m.normalize(folderPath .. '/' .. path)
    end
    return path
end

---@param uriOrPath uri|string
---@return string
function m.getRelativePath(uriOrPath)
    local path, uri
    if uriOrPath:sub(1, 5) == 'file:' then
        path = furi.decode(uriOrPath)
        uri  = uriOrPath
    else
        path = uriOrPath
        uri  = furi.encode(uriOrPath)
    end
    local scp = m.getScope(uri)
    if not scp.uri then
        local relative = m.normalize(path)
        return relative:gsub('^[/\\]+', '')
    end
    local _, pos = m.normalize(path):find(furi.decode(scp.uri), 1, true)
    if pos then
        return m.normalize(path:sub(pos + 1)):gsub('^[/\\]+', '')
    else
        return m.normalize(path):gsub('^[/\\]+', '')
    end
end

---@param scp scope
function m.reload(scp)
    if not m.inited then
        return
    end
    if TEST then
        return
    end
    ---@async
    await.call(function ()
        m.awaitReload(scp)
    end)
end

function m.init()
    if m.inited then
        return
    end
    m.inited = true
    if m.rootUri then
        for _, folder in ipairs(scope.folders) do
            m.reload(folder)
        end
    else
        m.reload(scope.fallback)
    end
end

---@param scp scope
function m.removeFiles(scp)
    local cachedUris = scp:get 'cachedUris'
    if not cachedUris then
        return
    end
    scp:set('cachedUris', nil)
    for _, uri in ipairs(cachedUris) do
        files.delRef(uri)
    end
end

---@param scp scope
function m.resetFiles(scp)
    local cachedUris = scp:get 'cachedUris'
    if not cachedUris then
        return
    end
    for _, uri in ipairs(cachedUris) do
        files.resetText(uri)
    end
end

---@async
---@param scp scope
function m.awaitReload(scp)
    m.removeFiles(scp)
    plugin.init(scp)
    m.awaitPreload(scp)
    scp:set('ready', true)
    local waiting = scp:get('waitingReady')
    if waiting then
        scp:set('waitingReady', nil)
        for _, waker in ipairs(waiting) do
            waker()
        end
    end
end

---@param uri uri
---@return scope
function m.getScope(uri)
    return scope.getFolder(uri)
        or scope.getLinkedScope(uri)
        or scope.fallback
end

---等待工作目录加载完成
---@async
function m.awaitReady(uri)
    if m.isReady(uri) then
        return
    end
    local scp = m.getScope(uri)
    local waitingReady = scp:get('waitingReady')
                    or   scp:set('waitingReady', {})
    await.wait(function (waker)
        waitingReady[#waitingReady+1] = waker
    end)
end

---@param uri uri
function m.isReady(uri)
    local scp = m.getScope(uri)
    return scp:get('ready') == true
end

function m.getLoadingProcess(uri)
    local scp = m.getScope(uri)
    ---@type workspace.loading
    local ld  = scp:get 'loading'
    return ld.read, ld.max
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
    -- TODO
    m.awaitReady()
    for _, change in ipairs(changes) do
        local path = change.path
        local uri  = furi.encode(path)
        local scp  = m.getScope(uri)
        if scp.type == 'fallback' then
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
                    m.reload(scp)
                    break
                end
            end
        end
        ::CONTINUE::
    end
end)

return m
