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
local sp         = require 'bee.subprocess'
local timer      = require 'timer'
local progress   = require 'progress'
local define     = require "proto.define"

local m = {}
m.type = 'workspace'
m.nativeVersion  = -1
m.libraryVersion = -1
m.nativeMatcher  = nil
m.requireCache   = {}
m.cache          = {}
m.matchOption    = {
    ignoreCase = platform.OS == 'Windows',
}

--- 初始化工作区
function m.init(uri)
    log.info('Workspace inited: ', uri)
    if not uri then
        return
    end
    m.uri  = uri
    m.path = m.normalize(furi.decode(uri))
    local logPath = fs.path(LOGPATH) / (uri:gsub('[/:]+', '_') .. '.log')
    log.info('Log path: ', logPath)
    log.init(ROOT, logPath)
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
            for fullpath in fullPath:list_directory() do
                paths[#paths+1] = fullpath:string()
            end
        end)
        return paths
    end
}

--- 创建排除文件匹配器
function m.getNativeMatcher()
    if not m.path then
        return nil
    end
    if m.nativeMatcher then
        return m.nativeMatcher
    end

    local pattern = {}
    -- config.workspace.ignoreDir
    for path in pairs(config.config.workspace.ignoreDir) do
        log.info('Ignore directory:', path)
        pattern[#pattern+1] = path
    end
    -- config.files.exclude
    for path, ignore in pairs(config.other.exclude) do
        if ignore then
            log.info('Ignore by exclude:', path)
            pattern[#pattern+1] = path
        end
    end
    -- config.workspace.ignoreSubmodules
    if config.config.workspace.ignoreSubmodules then
        local buf = pub.awaitTask('loadFile', furi.encode(m.path .. '/.gitmodules'))
        if buf then
            for path in buf:gmatch('path = ([^\r\n]+)') do
                log.info('Ignore by .gitmodules:', path)
                pattern[#pattern+1] = path
            end
        end
    end
    -- config.workspace.useGitIgnore
    if config.config.workspace.useGitIgnore then
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
    -- config.workspace.library
    for path in pairs(config.config.workspace.library) do
        log.info('Ignore by library:', path)
        pattern[#pattern+1] = path
    end

    m.nativeMatcher = glob.gitignore(pattern, m.matchOption, globInteferFace)

    m.nativeVersion = config.version
    return m.nativeMatcher
end

--- 创建代码库筛选器
function m.getLibraryMatchers()
    if m.libraryMatchers then
        return m.libraryMatchers
    end

    local librarys = {}
    for path in pairs(config.config.workspace.library) do
        librarys[m.normalize(path)] = true
    end
    if library.metaPath then
        librarys[m.normalize(library.metaPath)] = true
    end
    m.libraryMatchers = {}
    for path in pairs(librarys) do
        if fs.exists(fs.path(path)) then
            local nPath = fs.absolute(fs.path(path)):string()
            local matcher = glob.gitignore(true, m.matchOption, globInteferFace)
            if platform.OS == 'Windows' then
                matcher:setOption 'ignoreCase'
            end
            log.debug('getLibraryMatchers', path, nPath)
            m.libraryMatchers[#m.libraryMatchers+1] = {
                path    = nPath,
                matcher = matcher
            }
        end
    end

    m.libraryVersion = config.version
    return m.libraryMatchers
end

--- 文件是否被忽略
function m.isIgnored(uri)
    local path = m.getRelativePath(uri)
    local ignore = m.getNativeMatcher()
    if not ignore then
        return false
    end
    return ignore(path)
end

local function loadFileFactory(root, progressData, isLibrary)
    return function (path)
        local uri = furi.encode(path)
        if files.isLua(uri) then
            if not isLibrary and progressData.preload >= config.config.workspace.maxPreload then
                if not m.hasHitMaxPreload then
                    m.hasHitMaxPreload = true
                    local item = proto.awaitRequest('window/showMessageRequest', {
                        type    = define.MessageType.Info,
                        message = lang.script('MWS_MAX_PRELOAD', config.config.workspace.maxPreload),
                        actions = {
                            {
                                title = lang.script.WINDOW_INCREASE_UPPER_LIMIT,
                            },
                            {
                                title = lang.script.WINDOW_CLOSE,
                            }
                        }
                    })
                    if not item then
                        return
                    end
                    if item.title == lang.script.WINDOW_INCREASE_UPPER_LIMIT then
                        proto.notify('$/command', {
                            command   = 'lua.config',
                            data      = {
                                key    = 'Lua.workspace.maxPreload',
                                action = 'set',
                                value  = config.config.workspace.maxPreload + math.max(1000, config.config.workspace.maxPreload),
                            }
                        })
                    end
                end
                return
            end
            if not isLibrary then
                progressData.preload = progressData.preload + 1
            end
            progressData.max = progressData.max + 1
            progressData:update()
            pub.task('loadFile', uri, function (text)
                progressData.read = progressData.read + 1
                progressData:update()
                if text then
                    log.info(('Preload file at: %s , size = %.3f KB'):format(uri, #text / 1000.0))
                    if isLibrary then
                        log.info('++++As library of:', root)
                        files.setLibraryPath(uri, root)
                    end
                    files.setText(uri, text, false)
                else
                    files.remove(uri)
                end
            end)
        end
        if files.isDll(uri) then
            progressData.max = progressData.max + 1
            progressData:update()
            pub.task('loadFile', uri, function (content)
                progressData.read = progressData.read + 1
                progressData:update()
                if content then
                    log.info(('Preload file at: %s , size = %.3f KB'):format(uri, #content / 1000.0))
                    if isLibrary then
                        log.info('++++As library of:', root)
                    end
                    files.saveDll(uri, content)
                end
            end)
        end
    end
end

--- 预读工作区内所有文件
function m.awaitPreload()
    local diagnostic = require 'provider.diagnostic'
    await.close 'preload'
    await.setID 'preload'
    await.sleep(0.1)
    diagnostic.pause()
    m.libraryMatchers = nil
    m.nativeMatcher   = nil
    m.cache           = {}
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
    end

    log.info(('Found %d files.'):format(progressData.max))
    while true do
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
    local lpath = path:lower():gsub('[/\\]+', '/')
    local vm    = require 'vm'
    local resultCache = vm.getCache 'findUrisByRequirePath.result'
    if resultCache[path] then
        return resultCache[path].results, resultCache[path].posts
    end
    tracy.ZoneBeginN('findUrisByFilePath #1')
    local results = {}
    local posts = {}
    for uri in files.eachFile() do
        if not uri:find(lpath, 1, true) then
            goto CONTINUE
        end
        local pathLen = #path
        local curPath = furi.decode(files.getOriginUri(uri))
        local curLen  = #curPath
        local seg = curPath:sub(curLen - pathLen, curLen - pathLen)
        if seg == '/' or seg == '\\' or seg == '' then
            local see = curPath:sub(curLen - pathLen + 1, curLen)
            if files.eq(see, path) then
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
    for _, luapath in ipairs(config.config.runtime.path) do
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
    if platform.OS == 'Windows' then
        path = path:gsub('[/\\]+', '\\')
                   :gsub('[/\\]+$', '')
                   :gsub('^%a+%:', function (str)
                        return str:upper()
                   end)
    else
        path = path:gsub('[/\\]+', '/')
                   :gsub('[/\\]+$', '')
    end
    return path
end

function m.getRelativePath(uri)
    local path = furi.decode(uri)
    if not m.path then
        local relative = m.normalize(path)
        return relative:gsub('^[/\\]+', '')
    end
    local _, pos
    if platform.OS == 'Windows' then
        _, pos = m.normalize(path):lower():find(m.path:lower(), 1, true)
    else
        _, pos = m.normalize(path):find(m.path, 1, true)
    end
    if pos then
        return m.normalize(path:sub(pos + 1)):gsub('^[/\\]+', '')
    else
        return m.normalize(path):gsub('^[/\\]+', '')
    end
end

--- 获取工作区等级的缓存
function m.getCache(name)
    if not m.cache[name] then
        m.cache[name] = {}
    end
    return m.cache[name]
end

function m.reload()
    await.call(m.awaitReload)
end

function m.awaitReload()
    local rpath = require 'workspace.require-path'
    local plugin     = require 'plugin'
    m.ready = false
    m.hasHitMaxPreload = false
    files.flushAllLibrary()
    files.removeAllClosed()
    files.flushCache()
    rpath.flush()
    plugin.init()
    m.awaitPreload()
    m.ready = true
end

---等待工作目录加载完成
function m.awaitReady()
    while not m.ready do
        await.sleep(0.1)
    end
end

function m.isReady()
    return m.ready == true
end

files.watch(function (ev, uri)
    if  ev == 'close'
    and m.isIgnored(uri)
    and not files.isLibrary(uri) then
        files.remove(uri)
    end
end)

return m
