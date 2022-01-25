local platform  = require 'bee.platform'
local files     = require 'files'
local furi      = require 'file-uri'
local workspace = require "workspace"
local config    = require 'config'
local collector = require 'core.collector'
local scope     = require 'workspace.scope'

---@class require-path
local m = {}

local function addRequireName(suri, uri, name)
    local separator    = config.get(uri, 'Lua.completion.requireSeparator')
    local fsname = name:gsub('%' .. separator, '/')
    local scp = scope.getScope(suri)
    ---@type collector
    local clt = scp:get('requireName') or scp:set('requireName', collector())
    clt:subscribe(uri, fsname, name)
end

--- `aaa/bbb/ccc.lua` 与 `?.lua` 将返回 `aaa.bbb.cccc`
local function getOnePath(uri, path, searcher)
    local separator    = config.get(uri, 'Lua.completion.requireSeparator')
    local stemPath     = path
                        : gsub('%.[^%.]+$', '')
                        : gsub('[/\\%.]+', separator)
    local stemSearcher = searcher
                        : gsub('%.[^%.]+$', '')
                        : gsub('[/\\%.]+', separator)
    local start        = stemSearcher:match '()%?' or 1
    if stemPath:sub(1, start - 1) ~= stemSearcher:sub(1, start - 1) then
        return nil
    end
    for pos = #stemPath, start, -1 do
        local word = stemPath:sub(start, pos)
        local newSearcher = stemSearcher:gsub('%?', (word:gsub('%%', '%%%%')))
        if newSearcher == stemPath then
            return word
        end
    end
    return nil
end

function m.getVisiblePath(suri, path)
    local searchers = config.get(suri, 'Lua.runtime.path')
    local strict    = config.get(suri, 'Lua.runtime.pathStrict')
    path = workspace.normalize(path)
    local uri = furi.encode(path)
    local scp = scope.getScope(suri)
    if  not scp:isChildUri(uri)
    and not scp:isLinkedUri(uri) then
        return {}
    end
    local libraryPath = furi.decode(files.getLibraryUri(suri, uri))
    local cache = scp:get('visiblePath') or scp:set('visiblePath', {})
    local result = cache[path]
    if not result then
        result = {}
        cache[path] = result
        for _, searcher in ipairs(searchers) do
            local isAbsolute = searcher:match '^[/\\]'
                            or searcher:match '^%a+%:'
            searcher = workspace.normalize(searcher)
            local cutedPath = path
            local currentPath = path
            local head
            local pos = 1
            if not isAbsolute then
                if libraryPath then
                    currentPath = currentPath:sub(#libraryPath + 2)
                else
                    currentPath = workspace.getRelativePath(uri)
                end
            end
            repeat
                cutedPath = currentPath:sub(pos)
                head = currentPath:sub(1, pos - 1)
                pos = currentPath:match('[/\\]+()', pos)
                if platform.OS == 'Windows' then
                    searcher = searcher :gsub('[/\\]+', '\\')
                else
                    searcher = searcher :gsub('[/\\]+', '/')
                end
                local expect = getOnePath(suri, cutedPath, searcher)
                if expect then
                    local mySearcher = searcher
                    if head then
                        mySearcher = head .. searcher
                    end
                    result[#result+1] = {
                        searcher = mySearcher,
                        expect   = expect,
                    }
                    addRequireName(suri, uri, expect)
                end
            until not pos or strict
        end
    end
    return result
end

--- 查找符合指定require path的所有uri
---@param path string
function m.findUrisByRequirePath(suri, path)
    if type(path) ~= 'string' then
        return {}
    end
    local separator = config.get(suri, 'Lua.completion.requireSeparator')
    local fspath = path:gsub('%' .. separator, '/')
    tracy.ZoneBeginN('findUrisByRequirePath')
    local results = {}
    local searchers = {}
    for uri in files.eachDll() do
        local opens = files.getDllOpens(uri) or {}
        for _, open in ipairs(opens) do
            if open == fspath then
                results[#results+1] = uri
            end
        end
    end

    ---@type collector
    local clt = scope.getScope(suri):get('requireName')
    if clt then
        for _, uri in clt:each(suri, fspath) do
            local infos = m.getVisiblePath(suri, furi.decode(uri))
            for _, info in ipairs(infos) do
                local fsexpect = info.expect:gsub('%' .. separator, '/')
                if fsexpect == fspath then
                    results[#results+1] = uri
                    searchers[uri] = info.searcher
                end
            end
        end
    end

    tracy.ZoneEnd()
    return results, searchers
end

local function createVisiblePath(uri)
    for _, scp in ipairs(workspace.folders) do
        m.getVisiblePath(scp.uri, furi.decode(uri))
    end
    m.getVisiblePath(nil, furi.decode(uri))
end

local function removeVisiblePath(uri)
    local path = furi.decode(uri)
    path = workspace.normalize(path)
    for _, scp in ipairs(workspace.folders) do
        scp:get('visiblePath')[path] = nil
        ---@type collector
        local clt = scp:get('requireName')
        if clt then
            clt:dropUri(uri)
        end
    end
    scope.fallback:get('visiblePath')[path] = nil
    ---@type collector
    local clt = scope.fallback:get('requireName')
    if clt then
        clt:dropUri(uri)
    end
end

function m.flush(suri)
    local scp = scope.getScope(suri)
    scp:set('visiblePath', {})
    ---@type collector
    local clt = scp:get('requireName')
    if clt then
        clt:dropAll()
    end
    for uri in files.eachFile(suri) do
        m.getVisiblePath(scp.uri, furi.decode(uri))
    end
end

for _, scp in ipairs(scope.folders) do
    m.flush(scp.uri)
end
m.flush(nil)

files.watch(function (ev, uri)
    if ev == 'create' then
        createVisiblePath(uri)
    end
    if ev == 'remove' then
        removeVisiblePath(uri)
    end
end)

config.watch(function (uri, key, value, oldValue)
    if key == 'Lua.completion.requireSeparator'
    or key == 'Lua.runtime.path'
    or key == 'Lua.runtime.pathStrict' then
        m.flush(uri)
    end
end)

return m
