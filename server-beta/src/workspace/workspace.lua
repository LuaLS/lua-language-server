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
end

--- 创建排除文件匹配器
function m.buildIgnoreMatcher()
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
        local buf = pub.task('loadFile', furi.encode((ROOT / '.gitmodules'):string()))
        if buf then
            for path in buf:gmatch('path = ([^\r\n]+)') do
                log.info('Ignore by .gitmodules:', path)
                pattern[#pattern+1] = path
            end
        end
    end
    -- config.workspace.useGitIgnore
    if config.config.workspace.useGitIgnore then
        local buf = pub.task('loadFile', furi.encode((ROOT / '.gitignore'):string()))
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

    local matcher = glob.gitignore(pattern)

    if platform.OS == "Windows" then
        matcher:setOption 'ignoreCase'
    end

    return matcher
end

--- 文件是否被忽略
function m.isIgnored(uri)
    local path = furi.decode(uri)
    if m.ignoreVersion == config.version then
        return m.ignoreMatcher(path)
    end
    m.ignoreMatcher = m.buildIgnoreMatcher()
    m.ignoreVersion = config.version
    return m.ignoreMatcher(path)
end

--- 预读工作区内所有文件（异步）
function m.preload()
    if not m.uri then
        return
    end
    log.info('Preload start.')
    local function scan(dir, callback)
        local result = pub.task('listDirectory', dir)
        if not result then
            return
        end
        for i = 1, #result.uris do
            local childUri = result.uris[i]
            if not m.isIgnored(childUri) then
                if result.dirs[childUri] then
                    scan(childUri, callback)
                elseif files.isLua(childUri) then
                    callback(childUri)
                end
            end
        end
    end
    scan(m.uri, function (uri)
        pub.syncTask('loadFile', uri, function (text)
            log.debug('Preload file at: ' .. uri, #text)
            files.setText(uri, text)
        end)
    end)
    log.info('Preload finish.')
end

return m
