local fw   = require 'bee.filewatch'
local fs   = require 'bee.filesystem'
local glob = require 'tools.glob'

---@alias FileWatch.Event 'create' | 'delete' | 'modify'
---@alias FileWatch.Callback fun(path: string, event: FileWatch.Event)

---@class FileWatch
local M = Class 'FileWatch'

-- Global settings
local globalIgnoreCase     = false
local globalRecursive      = false
local globalFollowSymlinks = false

-- All active watchers
---@type FileWatch[]
local watchers = {}

--- 共享原生 watcher 缓存
--- sharedWatchers[nativeBaseDir][optionsBits] = { watcher, instances }
---@type table<string, table<integer, { watcher: bee.filewatch.watch, instances: FileWatch[] }>>
local sharedWatchers = {}

--- Normalize path separators to forward slashes
---@param path string
---@return string
local function normalizePath(path)
    return (path:gsub('\\', '/'))
end

--- 将 3 个布尔选项编码为位掩码
---@param recursive boolean
---@param followSymlinks boolean
---@param ignoreCase boolean
---@return integer
local function optionsBits(recursive, followSymlinks, ignoreCase)
    return (recursive     and 1 or 0)
         + (followSymlinks and 2 or 0)
         + (ignoreCase     and 4 or 0)
end

--- Parse a glob path into a base directory and a glob pattern
---@param pathGlob string
---@return string baseDir       -- normalized (forward-slash) for glob matching
---@return string nativeBaseDir -- original OS path for bee.filewatch
---@return string pattern
local function parseGlob(pathGlob)
    local normalized = normalizePath(pathGlob)

    -- Find the first glob character
    local globStart = normalized:find('[%*%?%[%{]')

    if not globStart then
        -- No glob characters
        local isDir = normalized:sub(-1) == '/'
                   or fs.is_directory(pathGlob)
        if isDir then
            if normalized:sub(-1) ~= '/' then
                normalized = normalized .. '/'
            end
            return normalized, pathGlob, '**'
        end
        -- Specific file: watch parent directory
        local lastSlash = normalized:match('.*()/')
        if lastSlash then
            local nativeSlash = pathGlob:match('.*()[/\\]')
            return normalized:sub(1, lastSlash),
                   pathGlob:sub(1, nativeSlash),
                   normalized:sub(lastSlash + 1)
        else
            return './', './', normalized
        end
    end

    -- Find the last '/' before the first glob character
    local prefix = normalized:sub(1, globStart - 1)
    local lastSlash = prefix:match('.*()/')

    if lastSlash then
        local nativePrefix = pathGlob:sub(1, globStart - 1)
        local nativeSlash  = nativePrefix:match('.*()[/\\]')
        return normalized:sub(1, lastSlash),
               pathGlob:sub(1, nativeSlash or lastSlash),
               normalized:sub(lastSlash + 1)
    else
        return './', './', normalized
    end
end

--- Map bee.filewatch event type to FileWatch event
---@param beeEvent string
---@param path string
---@return FileWatch.Event
local function classifyEvent(beeEvent, path)
    if beeEvent == 'modify' then
        return 'modify'
    end
    -- 'rename': check existence to distinguish create vs delete
    if fs.exists(path) then
        return 'create'
    else
        return 'delete'
    end
end

---从创建到第一次 `update` 之间的文件变化会被忽略，
---因此应在设置好所有参数后再调用 `update`。
function M:__init(pathGlob, callback)
    self._callback       = callback
    self._events         = nil -- nil = all events
    self._ignoreCase     = nil
    self._recursive      = nil
    self._followSymlinks = nil
    self._shared         = nil ---@type { watcher: bee.filewatch.watch, instances: FileWatch[] }?
    self._bits           = nil ---@type integer?

    -- Parse glob
    self._baseDir, self._nativeBaseDir, self._pattern = parseGlob(pathGlob)

    -- Register
    watchers[#watchers + 1] = self
end

---@package
---在第一次 update 时初始化，相同 baseDir + 选项的实例共享同一个原生 watcher
function M:_init()
    if self._shared then
        return
    end

    local recursive = self._recursive
    if recursive == nil then recursive = globalRecursive end
    local followSymlinks = self._followSymlinks
    if followSymlinks == nil then followSymlinks = globalFollowSymlinks end
    local ignoreCase = self._ignoreCase
    if ignoreCase == nil then ignoreCase = globalIgnoreCase end

    self._glob = glob.glob(self._pattern, {
        ignoreCase = ignoreCase,
        root       = self._baseDir,
    })

    local bits  = optionsBits(recursive, followSymlinks, ignoreCase)
    local byDir = sharedWatchers[self._nativeBaseDir]
    if not byDir then
        byDir = {}
        sharedWatchers[self._nativeBaseDir] = byDir
    end

    local shared = byDir[bits]
    if not shared then
        local watcher = fw.create()
        watcher:set_recursive(recursive)
        watcher:set_follow_symlinks(followSymlinks)
        watcher:add(self._nativeBaseDir)
        shared = { watcher = watcher, instances = {} }
        byDir[bits] = shared
    end

    shared.instances[#shared.instances + 1] = self
    self._shared = shared
    self._bits   = bits
end

function M:dispose()
    for i = #watchers, 1, -1 do
        if watchers[i] == self then
            table.remove(watchers, i)
            break
        end
    end

    local shared = self._shared
    if shared then
        for i = #shared.instances, 1, -1 do
            if shared.instances[i] == self then
                table.remove(shared.instances, i)
                break
            end
        end
        if #shared.instances == 0 then
            local byDir = sharedWatchers[self._nativeBaseDir]
            if byDir then
                byDir[self._bits] = nil
                if not next(byDir) then
                    sharedWatchers[self._nativeBaseDir] = nil
                end
            end
        end
        self._shared = nil
    end
end

---指定关注哪些事件，默认关注全部
---@param ... FileWatch.Event
---@return FileWatch
function M:event(...)
    self._events = {}
    for i = 1, select('#', ...) do
        self._events[select(i, ...)] = true
    end
    return self
end

---指定是否忽略大小写，默认使用全局配置
---@param ignore boolean
---@return FileWatch
function M:ignoreCase(ignore)
    self._ignoreCase = ignore
    return self
end

---如果路径是个目录，是否递归追踪目录下的文件，默认使用全局配置
---@param recursive boolean
---@return FileWatch
function M:recursive(recursive)
    self._recursive = recursive
    return self
end

---是否追踪符号链接，默认使用全局配置
---@param follow boolean
---@return FileWatch
function M:followSymlinks(follow)
    self._followSymlinks = follow
    return self
end

---@package
---处理一个原生事件，进行 glob 过滤和事件分类后触发回调
---@param eventType string
---@param path string
function M:_dispatch(eventType, path)
    local normalized = normalizePath(path)
    if self._glob:check(normalized) then
        local event = classifyEvent(eventType, path)
        if not self._events or self._events[event] then
            self._callback(normalized, event)
        end
    end
end

---@class FileWatch.API
local API = {}

---创建文件监控器。从创建到第一次 `update` 之间的文件变化会被忽略，
---因此应在设置好所有参数后再调用 `update`。
---@param pathGlob string # 必须是绝对路径，可以使用glob，如 `"D:/test/**/*.lua"`
---@param callback FileWatch.Callback
---@return FileWatch
function API.watch(pathGlob, callback)
    local inst = New 'FileWatch' (pathGlob, callback)
    return inst
end

---调用 update 进行一次检查。
---相同 baseDir + 选项的 watcher 共享同一个原生监控器，
---每次 update 只轮询一次原生事件，然后分发给所有关联实例。
function API.update()
    -- 确保所有 watcher 已初始化
    for _, w in ipairs(watchers) do
        w:_init()
    end
    -- 对每个共享原生 watcher 轮询一次，分发到所有实例
    for _, byBits in pairs(sharedWatchers) do
        for _, shared in pairs(byBits) do
            while true do
                local eventType, path = shared.watcher:select()
                if not eventType or not path then
                    break
                end
                for _, inst in ipairs(shared.instances) do
                    inst:_dispatch(eventType, path)
                end
            end
        end
    end
end

---指定是否忽略大小写的全局配置，默认不忽略
---@param ignore boolean
function API.ignoreCase(ignore)
    globalIgnoreCase = ignore
end

---如果路径是个目录，是否递归追踪目录下的文件的全局配置，默认不追踪
---@param recursive boolean
function API.recursive(recursive)
    globalRecursive = recursive
end

---是否追踪符号链接的全局配置，默认不追踪
---@param follow boolean
function API.followSymlinks(follow)
    globalFollowSymlinks = follow
end

return API
