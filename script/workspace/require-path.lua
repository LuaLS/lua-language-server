local platform  = require 'bee.platform'
local files     = require 'files'
local furi      = require 'file-uri'
local workspace = require "workspace"
local config    = require 'config'
local scope     = require 'workspace.scope'
local util      = require 'utility'
local plugin    = require 'plugin'

---@class require-path
local m = {}

---@class require-manager
---@field scp scope
---@field nameMap table<string, string>
---@field visibleCache table<string, require-manager.visibleResult[]>
---@field requireCache table<string, table>
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
        requireCache = {},
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
    local vm  = require 'vm'
    local uri = furi.encode(path)
    local result = {}
    if vm.isMetaFile(uri) then
        local metaName = vm.getMetaName(uri)
        if metaName then
            if vm.isMetaFileRequireable(uri) then
                result[#result+1] = {
                    name = metaName,
                    searcher = '[[meta]]',
                }
            end
            return result
        end
    end
    local searchers   = config.get(self.scp.uri, 'Lua.runtime.path')
    local strict      = config.get(self.scp.uri, 'Lua.runtime.pathStrict')
    local libUri      = files.getLibraryUri(self.scp.uri, uri)
    local libraryPath = libUri and furi.decode(libUri)
    for _, searcher in ipairs(searchers) do
        local isAbsolute = searcher:match '^[/\\]'
                        or searcher:match '^%a+%:'
        searcher = files.normalize(searcher)
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

        repeat
            cutedPath = currentPath:sub(pos)
            head = currentPath:sub(1, pos - 1)
            pos = currentPath:match('[/\\]+()', pos)
            if platform.os == 'windows' then
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
    path = files.normalize(path)
    local result = self.visibleCache[path]
    if not result then
        result = self:getRequireResultByPath(path)
        self.visibleCache[path] = result
    end
    return result
end

--- 查找符合指定require name的所有uri
---@param name string
---@return uri[]
---@return table<uri, string>?
function mt:searchUrisByRequireName(name)
    local vm          = require 'vm'
    local searchers   = config.get(self.scp.uri, 'Lua.runtime.path')
    local strict      = config.get(self.scp.uri, 'Lua.runtime.pathStrict')
    local separator   = config.get(self.scp.uri, 'Lua.completion.requireSeparator')
    local path        = name:gsub('%' .. separator, '/')
    local results     = {}
    local searcherMap = {}
    local excludes    = {}

    local pluginSuccess, pluginResults = plugin.dispatch('ResolveRequire', self.scp.uri, name)
    if pluginSuccess and pluginResults ~= nil then
        return pluginResults
    end

    for uri in files.eachFile(self.scp.uri) do
        if vm.isMetaFileRequireable(uri) then
            local metaName = vm.getMetaName(uri)
            if metaName == name then
                results[#results+1] = uri
                return results
            end
            if metaName then
                excludes[uri] = true
            end
        end
    end

    for _, searcher in ipairs(searchers) do
        local fspath = searcher:gsub('%?', (path:gsub('%%', '%%%%')))
        fspath = files.normalize(fspath)
        local tail = '/' .. furi.encode(fspath):gsub('^file:[/]*', '')
        for uri in files.eachFile(self.scp.uri) do
            if  not searcherMap[uri]
            and not excludes[uri]
            and util.stringEndWith(uri, tail)
            and (not vm.isMetaFile(uri) or vm.isMetaFileRequireable(uri)) then
                local parentUri = files.getLibraryUri(self.scp.uri, uri) or self.scp.uri
                if parentUri == nil or parentUri == '' then
                    parentUri = furi.encode '/'
                end
                local relative = uri:sub(#parentUri + 1):sub(1, - #tail)
                if not strict
                or relative == '/'
                or relative == '' then
                    results[#results+1] = uri
                    searcherMap[uri] = files.normalize(relative .. searcher)
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

--- 查找符合指定require name的所有uri，并排除当前文件
---@param suri uri
---@param name string
---@return uri[]
---@return table<uri, string>?
function mt:findUrisByRequireName(suri, name)
    if type(name) ~= 'string' then
        return {}
    end
    local cache = self.requireCache[name]
    if not cache then
        local results, searcherMap = self:searchUrisByRequireName(name)
        cache = {
            results = results,
            searcherMap = searcherMap,
        }
        self.requireCache[name] = cache
    end
    local results = {}
    local searcherMap = {}
    for _, uri in ipairs(cache.results) do
        if uri ~= suri then
            results[#results+1] = uri
            searcherMap[uri] = cache.searcherMap and cache.searcherMap[uri]
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
---@return uri[]
---@return table<uri, string>?
function m.findUrisByRequireName(uri, name)
    local scp = scope.getScope(uri)
    ---@type require-manager
    local mgr = scp:get 'requireManager'
             or scp:set('requireManager', createRequireManager(scp))
    return mgr:findUrisByRequireName(uri, name)
end

---@param suri uri
---@param uri uri
---@param name string
---@return boolean
function m.isMatchedUri(suri, uri, name)
    local searchers   = config.get(suri, 'Lua.runtime.path')
    local strict      = config.get(suri, 'Lua.runtime.pathStrict')
    local separator   = config.get(suri, 'Lua.completion.requireSeparator')
    local path        = name:gsub('%' .. separator, '/')

    for _, searcher in ipairs(searchers) do
        local fspath = searcher:gsub('%?', (path:gsub('%%', '%%%%')))
        fspath = files.normalize(fspath)
        local tail = '/' .. furi.encode(fspath):gsub('^file:[/]*', '')
        if util.stringEndWith(uri, tail) then
            local parentUri = files.getLibraryUri(suri, uri) or uri
            if parentUri == nil or parentUri == '' then
                parentUri = furi.encode '/'
            end
            local relative = uri:sub(#parentUri + 1):sub(1, - #tail)
            if not strict
            or relative == '/'
            or relative == '' then
                return true
            end
        end
    end
    return false
end

files.watch(function (_ev, _uri)
    for _, scp in ipairs(workspace.folders) do
        scp:set('requireManager', nil)
    end
    scope.fallback:set('requireManager', nil)
end)

config.watch(function (uri, key, _value, _oldValue)
    if key == 'Lua.completion.requireSeparator'
    or key == 'Lua.runtime.path'
    or key == 'Lua.runtime.pathStrict' then
        local scp = scope.getScope(uri)
        scp:set('requireManager', nil)
    end
end)

return m
