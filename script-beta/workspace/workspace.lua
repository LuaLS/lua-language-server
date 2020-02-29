local pub        = require 'pub'
local fs         = require 'bee.filesystem'
local furi       = require 'file-uri'
local files      = require 'files'
local config     = require 'config'
local glob       = require 'glob'
local platform   = require 'bee.platform'
local await      = require 'await'
local diagnostic = require 'provider.diagnostic'

local m = {}
m.type = 'workspace'
m.ignoreVersion = -1
m.ignoreMatcher = nil
m.preloadVersion = 0
m.uri = ''
m.path = ''

--- 初始化工作区
function m.init(name, uri)
    m.name = name
    m.uri  = uri
    m.path = furi.decode(uri)
    log.info('Workspace inited: ', uri)
    local logPath = ROOT / 'log' / (uri:gsub('[/:]+', '_') .. '.log')
    log.info('Log path: ', logPath)
    log.init(ROOT, logPath)
end

--- 创建排除文件匹配器
function m.getIgnoreMatcher()
    if m.ignoreVersion == config.version then
        return m.ignoreMatcher
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
                log.info('Ignore by .gitignore:', line)
                pattern[#pattern+1] = line
            end
        end
    end
    -- config.workspace.library
    for path in pairs(config.config.workspace.library) do
        log.info('Ignore by library:', path)
        pattern[#pattern+1] = path
    end

    m.ignoreMatcher = glob.gitignore(pattern)

    if platform.OS == "Windows" then
        m.ignoreMatcher:setOption 'ignoreCase'
    end

    m.ignoreVersion = config.version
    return m.ignoreMatcher
end

--- 文件是否被忽略
function m.isIgnored(uri)
    local path = furi.decode(uri)
    local ignore = m.getIgnoreMatcher()
    return ignore(path)
end

--- 预读工作区内所有文件
function m.awaitPreload()
    if not m.uri then
        return
    end
    local max = 0
    local read = 0
    log.info('Preload start.')
    local ignore = m.getIgnoreMatcher()

    ignore:setInterface('type', function (path)
        if fs.is_directory(fs.path(m.path .. '/' .. path)) then
            return 'directory'
        else
            return 'file'
        end
    end)

    ignore:setInterface('list', function (path)
        local paths = {}
        for fullpath in fs.path(m.path .. '/' .. path):list_directory() do
            paths[#paths+1] = fullpath:string()
        end
        return paths
    end)

    ignore:scan(function (path)
        local uri = furi.encode(m.path .. '/' .. path)
        if not files.isLua(uri) then
            return
        end
        max = max + 1
        pub.task('loadFile', uri, function (text)
            read = read + 1
            --log.info(('Preload file at: %s , size = %.3f KB'):format(uri, #text / 1000.0))
            files.setText(uri, text)
        end)
    end)

    log.info(('Found %d files.'):format(max))
    while true do
        log.info(('Loaded %d/%d files'):format(read, max))
        if read >= max then
            break
        end
        await.sleep(0.1, function ()
            return m.preloadVersion
        end)
    end

    log.info('Preload finish.')
    diagnostic.start()
end

--- 查找符合指定file path的所有uri
---@param path string
---@param whole boolean
function m.findUrisByFilePath(path, whole)
    local results = {}
    for uri in files.eachFile() do
        local pathLen = #path
        local uriLen  = #uri
        if whole then
            local seg = uri:sub(uriLen - pathLen, uriLen - pathLen)
            if seg == '/' or seg == '\\' or seg == '' then
                local see = uri:sub(uriLen - pathLen + 1, uriLen)
                if files.eq(see, path) then
                    results[#results+1] = uri
                end
            end
        else
            for i = uriLen, uriLen - pathLen + 1, -1 do
                local see = uri:sub(i - pathLen + 1, i)
                if files.eq(see, path) then
                    results[#results+1] = uri
                end
            end
        end
    end
    return results
end

--- 查找符合指定require path的所有uri
---@param path string
---@param whole boolean
function m.findUrisByRequirePath(path, whole)
    local results = {}
    local mark = {}
    local input = path:gsub('%.', '/')
    for _, luapath in ipairs(config.config.runtime.path) do
        local part = luapath:gsub('%?', input)
        local uris = m.findUrisByFilePath(part, whole)
        for _, uri in ipairs(uris) do
            if not mark[uri] then
                mark[uri] = true
                results[#results+1] = uri
            end
        end
    end
    return results
end

function m.getRelativePath(uri)
    local path = furi.decode(uri)
    return fs.relative(fs.path(path), fs.path(m.path)):string()
end

function m.reload()
    m.preloadVersion = m.preloadVersion + 1
    files.removeAll()
    await.create(function ()
        m.awaitPreload()
    end)
end

return m
