local pub        = require 'pub'
local fs         = require 'bee.filesystem'
local furi       = require 'file-uri'
local files      = require 'files'
local config     = require 'config'
local glob       = require 'glob'
local platform   = require 'bee.platform'
local await      = require 'await'
local client     = require 'client'
local util       = require 'utility'
local fw         = require 'filewatch'
local scope      = require 'workspace.scope'
local loading    = require 'workspace.loading'
local inspect    = require 'inspect'
local lang       = require 'language'

---@class workspace
local m = {}
m.type = 'workspace'
m.watchList = {}

--- 注册事件
---@param callback async fun(ev: string, uri: uri)
function m.watch(callback)
    m.watchList[#m.watchList+1] = callback
end

function m.onWatch(ev, uri)
    for _, callback in ipairs(m.watchList) do
        await.call(function ()
            callback(ev, uri)
        end)
    end
end

function m.initRoot(uri)
    m.rootUri  = uri
    log.info('Workspace init root: ', uri)

    local logPath = fs.path(LOGPATH) / (uri:gsub('[/:]+', '_') .. '.log')
    client.logMessage('Log', 'Log path: ' .. furi.encode(logPath:string()))
    log.info('Log path: ', logPath)
    log.init(ROOT, logPath)
end

--- 初始化工作区
function m.create(uri, folderName)
    log.info('Workspace create: ', uri)
    local scp = scope.createFolder(uri, folderName)
    m.folders[#m.folders+1] = scp
    if uri == furi.encode '/'
    or uri == furi.encode(os.getenv 'HOME' or '') then
        if not FORCE_ACCEPT_WORKSPACE then
            client.showMessage('Error', lang.script('WORKSPACE_NOT_ALLOWED', furi.decode(uri)))
            scp:set('bad root', true)
        end
    end
end

function m.remove(uri)
    log.info('Workspace remove: ', uri)
    for i, scp in ipairs(m.folders) do
        if scp.uri == uri then
            scp:remove()
            table.remove(m.folders, i)
            scp:set('ready', false)
            scp:set('nativeMatcher', nil)
            scp:set('libraryMatcher', nil)
            scp:removeAllLinks()
            m.flushFiles(scp)
            return
        end
    end
end

function m.reset()
    ---@type scope[]
    m.folders = {}
    m.rootUri = nil
end
m.reset()

function m.getRootUri(uri)
    local scp = scope.getScope(uri)
    return scp.uri
end

local globInteferFace = {
    type = function (path, data)
        if data[path] then
            return data[path]
        end
        local result
        pcall(function ()
            if fs.is_directory(fs.path(path)) then
                result = 'directory'
                data[path] = 'directory'
            else
                result = 'file'
                data[path] = 'file'
            end
        end)
        return result
    end,
    list = function (path, data)
        if data[path] == 'file' then
            return nil
        end
        local fullPath = fs.path(path)
        if not fs.is_directory(fullPath) then
            data[path] = 'file'
            return nil
        end
        data[path] = true
        local paths = {}
        pcall(function ()
            for fullpath, status in fs.pairs(fullPath) do
                local pathString = fullpath:string()
                paths[#paths+1] = pathString
                local st = status:type()
                if st == 'directory'
                or st == 'symlink'
                or st == 'junction' then
                    data[pathString] = 'directory'
                else
                    data[pathString] = 'file'
                end
            end
        end)
        return paths
    end
}

local addonRepositoryPathUpdated = false
--- 创建排除文件匹配器
---@param scp scope
function m.getNativeMatcher(scp)
    if scp:get 'nativeMatcher' then
        return scp:get 'nativeMatcher'
    end

    local pattern = {}
    for path, ignore in pairs(config.get(scp.uri, 'files.exclude')) do
        if ignore then
            log.debug('Ignore by exclude:', path)
            pattern[#pattern+1] = path
        end
    end
    if scp.uri and config.get(scp.uri, 'Lua.workspace.useGitIgnore') then
        local buf = util.loadFile(furi.decode(scp.uri) .. '/.gitignore')
        if buf then
            for line in buf:gmatch '[^\r\n]+' do
                if line:sub(1, 1) ~= '#' then
                    log.debug('Ignore by .gitignore:', line)
                    pattern[#pattern+1] = line
                end
            end
        end
        buf = util.loadFile(furi.decode(scp.uri).. '/.git/info/exclude')
        if buf then
            for line in buf:gmatch '[^\r\n]+' do
                if line:sub(1, 1) ~= '#' then
                    log.debug('Ignore by .git/info/exclude:', line)
                    pattern[#pattern+1] = line
                end
            end
        end
    end
    if scp.uri and config.get(scp.uri, 'Lua.workspace.ignoreSubmodules') then
        local buf = util.loadFile(furi.decode(scp.uri) .. '/.gitmodules')
        if buf then
            for path in buf:gmatch('path = ([^\r\n]+)') do
                log.debug('Ignore by .gitmodules:', path)
                pattern[#pattern+1] = path
            end
        end
    end
    for _, path in ipairs(config.get(scp.uri, 'Lua.workspace.library')) do
        if not addonRepositoryPathUpdated then
            addonRepositoryPathUpdated = true
            local addonRepositoryPath = config.get(scp.uri, 'Lua.addonRepositoryPath')
            files.updateAddonsPath(addonRepositoryPath)
        end
        path = m.getAbsolutePath(scp.uri, path)
        if path then
            log.debug('Ignore by library:', path)
            debug[#pattern+1] = path
        end
    end
    for _, path in ipairs(config.get(scp.uri, 'Lua.workspace.ignoreDir')) do
        log.debug('Ignore directory:', path)
        pattern[#pattern+1] = path
    end

    local matcher = glob.gitignore(pattern, {
        root       = scp.uri and furi.decode(scp.uri),
        ignoreCase = platform.os == 'windows',
    }, globInteferFace)

    scp:set('nativeMatcher', matcher)
    return matcher
end

--- 创建代码库筛选器
---@param scp scope
function m.getLibraryMatchers(scp)
    if scp:get 'libraryMatcher' then
        return scp:get 'libraryMatcher'
    end
    log.debug('Build library matchers:', scp)

    local pattern = {}
    for path, ignore in pairs(config.get(scp.uri, 'files.exclude')) do
        if ignore then
            log.debug('Ignore by exclude:', path)
            pattern[#pattern+1] = path
        end
    end
    for _, path in ipairs(config.get(scp.uri, 'Lua.workspace.ignoreDir')) do
        log.debug('Ignore directory:', path)
        pattern[#pattern+1] = path
    end

    local librarys = {}
    for _, path in ipairs(config.get(scp.uri, 'Lua.workspace.library')) do
        path = m.getAbsolutePath(scp.uri, path)
        if path then
            librarys[files.normalize(path)] = true
        end
    end
    local metaPaths = scp:get 'metaPaths'
    log.debug('meta path:', inspect(metaPaths))
    if metaPaths then
        for _, metaPath in ipairs(metaPaths) do
            librarys[files.normalize(metaPath)] = true
        end
    end

    local matchers = {}
    for path in pairs(librarys) do
        if fs.exists(fs.path(path)) then
            local nPath = fs.absolute(fs.path(path)):string()
            local matcher = glob.gitignore(pattern, {
                root       = path,
                ignoreCase = platform.os == 'windows',
            }, globInteferFace)
            matchers[#matchers+1] = {
                uri     = furi.encode(nPath),
                matcher = matcher
            }
        end
    end

    scp:set('libraryMatcher', matchers)
    --log.debug('library matcher:', inspect(matchers))

    return matchers
end

--- 文件是否被忽略
---@param uri uri
function m.isIgnored(uri)
    local scp    = scope.getScope(uri)
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
    m.awaitReady(uri)
    local scp = scope.getScope(uri)
    local ld <close> = loading.create(scp)
    local native = m.getNativeMatcher(scp)
    log.info('Scan files at:', uri)
    ---@async
    native:scan(furi.decode(uri), function (path)
        local uri = files.getRealUri(furi.encode(path))
        scp:get('cachedUris')[uri] = true
        ld:loadFile(uri)
    end)
    ld:loadAll(uri)
end

function m.removeFile(uri)
    for _, scp in ipairs(m.folders) do
        if scp:isChildUri(uri)
        or scp:isLinkedUri(uri) then
            local cachedUris = scp:get 'cachedUris'
            if cachedUris and cachedUris[uri] then
                cachedUris[uri] = nil
                files.delRef(uri)
            end
        end
    end
end

--- 预读工作区内所有文件
---@async
---@param scp scope
function m.awaitPreload(scp)
    await.close('preload:' .. scp:getName())
    await.setID('preload:' .. scp:getName())
    await.sleep(0.1)

    scp:flushGC()

    if scp:isRemoved() then
        return
    end

    local ld <close> = loading.create(scp)
    scp:set('loading', ld)

    log.info('Preload start:', scp:getName())

    local native   = m.getNativeMatcher(scp)
    local librarys = m.getLibraryMatchers(scp)

    if scp.uri and not scp:get('bad root') then
        log.info('Scan files at:', scp:getName())
        scp:gc(fw.watch(files.normalize(furi.decode(scp.uri)), true, function (path)
            local rpath = m.getRelativePath(path)
            if native(rpath) then
                return false
            end
            return true
        end))
        local count = 0
        ---@async
        native:scan(furi.decode(scp.uri), function (path)
            local uri = files.getRealUri(furi.encode(path))
            scp:get('cachedUris')[uri] = true
            ld:loadFile(uri)
        end, function (_) ---@async
            count = count + 1
            if count == 100000 then
                client.showMessage('Warning', lang.script('WORKSPACE_SCAN_TOO_MUCH', count, furi.decode(scp.uri)))
            end
        end)
    end

    for _, libMatcher in ipairs(librarys) do
        log.info('Scan library at:', libMatcher.uri)
        local count = 0
        scp:gc(fw.watch(furi.decode(libMatcher.uri), true, function (path)
            local rpath = m.getRelativePath(path)
            if libMatcher.matcher(rpath) then
                return false
            end
            return true
        end))
        scp:addLink(libMatcher.uri)
        ---@async
        libMatcher.matcher:scan(furi.decode(libMatcher.uri), function (path)
            local uri = files.getRealUri(furi.encode(path))
            scp:get('cachedUris')[uri] = true
            ld:loadFile(uri, libMatcher.uri)
        end, function () ---@async
            count = count + 1
            if count == 100000 then
                client.showMessage('Warning', lang.script('WORKSPACE_SCAN_TOO_MUCH', count, furi.decode(libMatcher.uri)))
            end
        end)
    end

    -- must wait for other scopes to add library
    await.sleep(0.1)

    log.info(('Found %d files at:'):format(ld.max), scp:getName())
    ld:loadAll(scp:getName())
    log.info('Preload finish at:', scp:getName())
end

--- 查找符合指定file path的所有uri
---@param path string
function m.findUrisByFilePath(path)
    if type(path) ~= 'string' then
        return {}
    end
    local myUri = furi.encode(path)
    local vm    = require 'vm'
    local resultCache = vm.getCache 'findUrisByFilePath.result'
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


---@param folderUri? uri
---@param path string
---@return string?
function m.getAbsolutePath(folderUri, path)
    path = files.normalize(path)
    if fs.path(path):is_relative() then
        if not folderUri then
            return nil
        end
        local folderPath = furi.decode(folderUri)
        path = files.normalize(folderPath .. '/' .. path)
    end
    return path
end

---@param uriOrPath uri|string
---@return string
---@return boolean suc
function m.getRelativePath(uriOrPath)
    local path, uri
    if uriOrPath:sub(1, 5) == 'file:' then
        path = furi.decode(uriOrPath)
        uri  = uriOrPath
    else
        path = uriOrPath
        uri  = furi.encode(uriOrPath)
    end
    local scp = scope.getScope(uri)
    if not scp.uri then
        local relative = files.normalize(path)
        return relative:gsub('^[/\\]+', ''), false
    end
    local _, pos = files.normalize(path):find(furi.decode(scp.uri), 1, true)
    if pos then
        return files.normalize(path:sub(pos + 1)):gsub('^[/\\]+', ''), true
    else
        return files.normalize(path):gsub('^[/\\]+', ''), false
    end
end

---@param scp scope
function m.reload(scp)
    ---@async
    await.call(function ()
        m.awaitReload(scp)
    end)
end

function m.init()
    if m.rootUri then
        for _, folder in ipairs(scope.folders) do
            m.reload(folder)
        end
    end
    m.reload(scope.fallback)
end

---@param scp scope
function m.flushFiles(scp)
    local cachedUris = scp:get 'cachedUris'
    scp:set('cachedUris', {})
    if not cachedUris then
        return
    end
    for uri in pairs(cachedUris) do
        files.delRef(uri)
    end
end

---@param scp scope
function m.resetFiles(scp)
    local cachedUris = scp:get 'cachedUris'
    if cachedUris then
        for uri in pairs(cachedUris) do
            files.resetText(uri)
        end
    end
    for uri in pairs(files.openMap) do
        if scope.getScope(uri) == scp then
            files.resetText(uri)
        end
    end
end

---@async
---@param scp scope
function m.awaitReload(scp)
    await.unique('workspace reload:' .. scp:getName())
    await.sleep(0.1)
    scp:set('ready', false)
    scp:set('nativeMatcher', nil)
    scp:set('libraryMatcher', nil)
    scp:removeAllLinks()
    m.flushFiles(scp)
    m.onWatch('startReload', scp.uri)
    m.awaitPreload(scp)
    scp:set('ready', true)
    local waiting = scp:get('waitingReady')
    if waiting then
        scp:set('waitingReady', nil)
        for _, waker in ipairs(waiting) do
            waker()
        end
    end

    m.onWatch('reload', scp.uri)
end

---@return scope
function m.getFirstScope()
    return m.folders[1] or scope.fallback
end

---等待工作目录加载完成
---@async
function m.awaitReady(uri)
    if m.isReady(uri) then
        return
    end
    local scp = scope.getScope(uri)
    local waitingReady = scp:get('waitingReady')
                    or   scp:set('waitingReady', {})
    await.wait(function (waker)
        waitingReady[#waitingReady+1] = waker
    end)
end

---@param uri uri
---@return boolean
function m.isReady(uri)
    local scp = scope.getScope(uri)
    return scp:get('ready') == true
end

---@return boolean
function m.isAllReady()
    local scp = scope.fallback
    if not scp:get 'ready' then
        return false
    end
    for _, folder in ipairs(scope.folders) do
        if not folder:get 'ready' then
            return false
        end
    end
    return true
end

function m.getLoadingProcess(uri)
    local scp = scope.getScope(uri)
    ---@type workspace.loading
    local ld  = scp:get 'loading'
    if ld then
        return ld.read, ld.max
    else
        return 0, 0
    end
end

config.watch(function (uri, key, value, oldValue)
    if key:find '^Lua.runtime'
    or key:find '^Lua.workspace'
    or key:find '^Lua.type'
    or key:find '^files' then
        if value ~= oldValue then
            local scp = scope.getScope(uri)
            m.reload(scp)
            m.resetFiles(scp)
        end
    end
end)

fw.event(function (ev, path) ---@async
    local uri  = furi.encode(path)

    if     ev == 'create' then
        log.debug('FileChangeType.Created', uri)
        m.awaitLoadFile(uri)
    elseif ev == 'delete' then
        log.debug('FileChangeType.Deleted', uri)
        files.remove(uri)
        m.removeFile(uri)
        local childs = files.getChildFiles(uri)
        for _, curi in ipairs(childs) do
            log.debug('FileChangeType.Deleted.Child', curi)
            files.remove(curi)
            m.removeFile(uri)
        end
    elseif ev == 'change' then
        if m.isValidLuaUri(uri) then
            -- 如果文件处于关闭状态，则立即更新；否则等待didChange协议来更新
            if not files.isOpen(uri) then
                files.setText(uri, pub.awaitTask('loadFile', furi.decode(uri)), false)
            end
        end
    end

    local filename = fs.path(path):filename():string()
    -- 排除类文件发生更改需要重新扫描
    if filename == '.gitignore'
    or filename == '.gitmodules' then
        local scp = scope.getScope(uri)
        if scp.type ~= 'fallback' then
            m.reload(scp)
        end
    end
end)

return m
