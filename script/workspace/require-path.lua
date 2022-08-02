local platform  = require 'bee.platform'
local files     = require 'files'
local furi      = require 'file-uri'
local workspace = require "workspace"
local config    = require 'config'
local scope     = require 'workspace.scope'
local util      = require 'utility'

---@class require-path
local m = {}

---@class require-manager
---@field scp scope
---@field nameMap table<string, string>
---@field visibleCache table<string, require-manager.visibleResult[]>
local mt = {}
mt.__index = mt

---@alias require-manager.visibleResult { searcher: string, name: string }

---@param scp scope
---@return require-manager
local function createRequireManager(scp)
    return setmetatable({
        scp = scp,
        nameMap = {},
        visibleCache = {},
    }, mt)
end

--- `aaa/bbb/ccc.lua` 与 `?.lua` 将返回 `aaa.bbb.cccc`
---@param path string
---@param searcher string
---@return string?
function mt:getRequireNameByPath(path, searcher)
    local separator    = config.get(self.scp.uri, 'Lua.completion.requireSeparator')
    local stemPath     = path
                        : gsub('%.[^%.]+$', '')
                        : gsub('[/\\%.]+', separator)
    local stemSearcher = searcher
                        : gsub('%.[^%.]+$', '')
                        : gsub('[/\\]+', separator)
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

---@param path string
---@return require-manager.visibleResult[]
function mt:getRequireResultByPath(path)
    local uri = furi.encode(path)
    local searchers   = config.get(self.scp.uri, 'Lua.runtime.path')
    local strict      = config.get(self.scp.uri, 'Lua.runtime.pathStrict')
    local libUri      = files.getLibraryUri(self.scp.uri, uri)
    local libraryPath = libUri and furi.decode(libUri)
    local result = {}
    for _, searcher in ipairs(searchers) do
        local isAbsolute = searcher:match '^[/\\]'
                        or searcher:match '^%a+%:'
        searcher = workspace.normalize(searcher)
        if searcher:sub(1, 1) == '.' then
            strict = true
        end
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

        -- handle `../?.lua`
        local parentCount = 0
        for _ = 1, 1000 do
            if searcher:match '^%.%.[/\\]' then
                parentCount = parentCount + 1
                searcher = searcher:sub(4)
            else
                break
            end
        end
        if parentCount > 0 then
            local parentPath = libraryPath
                            or (self.scp.uri and furi.decode(self.scp.uri))
            if parentPath then
                local tail
                for _ = 1, parentCount do
                    parentPath, tail = parentPath:match '^(.+)[/\\]([^/\\]*)$'
                    currentPath = tail .. '/' .. currentPath
                end
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
            local name = self:getRequireNameByPath(cutedPath, searcher)
            if name then
                local mySearcher = searcher
                if head then
                    mySearcher = head .. searcher
                end
                result[#result+1] = {
                    name     = name,
                    searcher = mySearcher,
                }
            end
        until not pos or strict
    end
    return result
end

---@param name string
function mt:addName(name)
    local separator = config.get(self.scp.uri, 'Lua.completion.requireSeparator')
    local fsname = name:gsub('%' .. separator, '/')
    self.nameMap[fsname] = name
end

---@return require-manager.visibleResult[]
function mt:getVisiblePath(path)
    local uri = furi.encode(path)
    if  not self.scp:isChildUri(uri)
    and not self.scp:isLinkedUri(uri) then
        return {}
    end
    path = workspace.normalize(path)
    local result = self.visibleCache[path]
    if not result then
        result = self:getRequireResultByPath(path)
        self.visibleCache[path] = result
    end
    return result
end

--- 查找符合指定require name的所有uri
---@param suri uri
---@param name string
---@return uri[]
---@return table<uri, string>?
function mt:findUrisByRequireName(suri, name)
    if type(name) ~= 'string' then
        return {}
    end
    local searchers   = config.get(self.scp.uri, 'Lua.runtime.path')
    local strict      = config.get(self.scp.uri, 'Lua.runtime.pathStrict')
    local separator   = config.get(self.scp.uri, 'Lua.completion.requireSeparator')
    local path        = name:gsub('%' .. separator, '/')
    local results     = {}
    local searcherMap = {}

    for _, searcher in ipairs(searchers) do
        local fspath = searcher:gsub('%?', (path:gsub('%%', '%%%%')))
        local fullPath = workspace.getAbsolutePath(self.scp.uri, fspath)
        if fullPath then
            local fullUri  = furi.encode(fullPath)
            if  files.exists(fullUri)
            and fullUri ~= suri then
                results[#results+1] = fullUri
                searcherMap[fullUri] = searcher
            end
        end
        if not strict then
            local tail = '/' .. furi.encode(fspath):gsub('^file:[/]*', '')
            for uri in files.eachFile(self.scp.uri) do
                if  not searcherMap[uri]
                and suri ~= uri
                and util.stringEndWith(uri, tail) then
                    results[#results+1] = uri
                    local parentUri = files.getLibraryUri(self.scp.uri, uri) or self.scp.uri
                    if parentUri == nil or parentUri == '' then
                        parentUri = furi.encode ''
                    end
                    local relative  = uri:sub(#parentUri + 1):sub(1, - #tail)
                    searcherMap[uri] = workspace.normalize(relative .. searcher)
                end
            end
        end
    end

    for uri in files.eachDll() do
        local opens = files.getDllOpens(uri) or {}
        for _, open in ipairs(opens) do
            if open == path then
                results[#results+1] = uri
            end
        end
    end

    return results, searcherMap
end

---@param uri uri
---@param path string
---@return require-manager.visibleResult[]
function m.getVisiblePath(uri, path)
    local scp = scope.getScope(uri)
    ---@type require-manager
    local mgr = scp:get 'requireManager'
             or scp:set('requireManager', createRequireManager(scp))
    return mgr:getVisiblePath(path)
end

---@param uri uri
---@param name string
function m.findUrisByRequireName(uri, name)
    local scp = scope.getScope(uri)
    ---@type require-manager
    local mgr = scp:get 'requireManager'
             or scp:set('requireManager', createRequireManager(scp))
    return mgr:findUrisByRequireName(uri, name)
end

files.watch(function (ev, uri)
    if ev == 'create' or ev == 'delete' then
        for _, scp in ipairs(workspace.folders) do
            scp:set('requireManager', nil)
        end
        scope.fallback:set('requireManager', nil)
    end
end)

config.watch(function (uri, key, value, oldValue)
    if key == 'Lua.completion.requireSeparator'
    or key == 'Lua.runtime.path'
    or key == 'Lua.runtime.pathStrict' then
        local scp = scope.getScope(uri)
        scp:set('requireManager', nil)
    end
end)

return m
