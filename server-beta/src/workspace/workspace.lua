local pub      = require 'pub'
local fs       = require 'bee.filesystem'
local furi     = require 'file-uri'
local files    = require 'files'
local config   = require 'config'
local glob     = require 'glob'
local platform = require 'bee.platform'

local m = {}
m.type = 'workspace'
m.ignoreVersion = -1
m.ignoreMatcher = nil

--- 初始化工作区
function m.init(name, uri)
    m.name = name
    m.uri  = uri
    m.path = furi.decode(uri)
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
        local buf = pub.task('loadFile', furi.encode(m.path .. '/.gitmodules'))
        if buf then
            for path in buf:gmatch('path = ([^\r\n]+)') do
                log.info('Ignore by .gitmodules:', path)
                pattern[#pattern+1] = path
            end
        end
    end
    -- config.workspace.useGitIgnore
    if config.config.workspace.useGitIgnore then
        local buf = pub.task('loadFile', furi.encode(m.path .. '/.gitignore'))
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

--- 预读工作区内所有文件（异步）
function m.preload()
    if not m.uri then
        return
    end
    log.info('Preload start.')
    local ignore = m.getIgnoreMatcher()

    ignore:setInterface('type', function (path)
        if pub.task('isDirectory', furi.encode(m.path .. '/' .. path)) then
            return 'directory'
        else
            return 'file'
        end
    end)

    ignore:setInterface('list', function (path)
        local uris = pub.task('listDirectory', furi.encode(m.path .. '/' .. path))
        local paths = {}
        for i, uri in ipairs(uris) do
            paths[i] = furi.decode(uri)
        end
        return paths
    end)

    ignore:scan(function (path)
        local uri = furi.encode(m.path .. '/' .. path)
        if not files.isLua(uri) then
            return
        end
        pub.syncTask('loadFile', uri, function (text)
            log.info(('Preload file at: %s , size = %.3f KB'):format(uri, #text / 1000.0))
            files.setText(uri, text)
        end)
    end)

    log.info('Preload finish.')
end

return m
