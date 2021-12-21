local platform  = require 'bee.platform'
local files     = require 'files'
local furi      = require 'file-uri'
local workspace = require "workspace"
local config    = require 'config'
local m = {}

m.cache = {}

--- `aaa/bbb/ccc.lua` 与 `?.lua` 将返回 `aaa.bbb.cccc`
local function getOnePath(path, searcher)
    local separator    = config.get 'Lua.completion.requireSeparator'
    local stemPath     = path
                        : gsub('%.[^%.]+$', '')
                        : gsub('[/\\%.]+', separator)
    local stemSearcher = searcher
                        : gsub('%.[^%.]+$', '')
                        : gsub('[/\\%.]+', separator)
    local start        = stemSearcher:match '()%?' or 1
    for pos = start, #stemPath do
        local word = stemPath:sub(start, pos)
        local newSearcher = stemSearcher:gsub('%?', (word:gsub('%%', '%%%%')))
        if newSearcher == stemPath then
            return word
        end
    end
    return nil
end

function m.getVisiblePath(path)
    local searchers = config.get 'Lua.runtime.path'
    local strict    = config.get 'Lua.runtime.pathStrict'
    path = workspace.normalize(path)
    local uri = furi.encode(path)
    local libraryPath = files.getLibraryPath(uri)
    if not m.cache[path] then
        local result = {}
        m.cache[path] = result
        if libraryPath then
            libraryPath = libraryPath:gsub('^[/\\]+', '')
        end
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
                    pos = #libraryPath + 2
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
                local expect = getOnePath(cutedPath, searcher)
                if expect then
                    local mySearcher = searcher
                    if head then
                        mySearcher = head .. searcher
                    end
                    result[#result+1] = {
                        searcher = mySearcher,
                        expect   = expect,
                    }
                end
            until not pos or strict
        end
    end
    return m.cache[path]
end

--- 查找符合指定require path的所有uri
---@param path string
function m.findUrisByRequirePath(path)
    if type(path) ~= 'string' then
        return {}
    end
    local separator = config.get 'Lua.completion.requireSeparator'
    local fspath = path:gsub('%' .. separator, '/')
    local vm    = require 'vm'
    local cache = vm.getCache 'findUrisByRequirePath'
    if cache[path] then
        return cache[path].results, cache[path].searchers
    end
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

    for uri in files.eachFile() do
        local infos = m.getVisiblePath(furi.decode(uri))
        for _, info in ipairs(infos) do
            local fsexpect = info.expect:gsub('%' .. separator, '/')
            if fsexpect == fspath then
                results[#results+1] = uri
                searchers[uri] = info.searcher
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

function m.flush()
    m.cache = {}
end

files.watch(function (ev)
    if ev == 'create'
    or ev == 'remove' then
        m.flush()
    end
end)

config.watch(function (key, value, oldValue)
    if key == 'Lua.completion.requireSeparator'
    or key == 'Lua.runtime.path'
    or key == 'Lua.runtime.pathStrict' then
        m.flush()
    end
end)

return m
