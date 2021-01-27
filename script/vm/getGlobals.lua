local guide   = require 'parser.guide'
local await   = require "await"
---@type vm
local vm      = require 'vm.vm'
local files   = require 'files'
local util    = require 'utility'
local config  = require 'config'
local ws      = require 'workspace'

local function getGlobalsOfFile(uri)
    local cache = files.getCache(uri)
    if cache.globals then
        return cache.globals
    end
    local globals = {}
    cache.globals = globals
    local ast = files.getAst(uri)
    if not ast then
        return globals
    end
    tracy.ZoneBeginN 'getGlobalsOfFile'
    local results = guide.findGlobals(ast.ast)
    local subscribe = ws.getCache 'globalSubscribe'
    subscribe[uri] = {}
    local mark = {}
    if not globals['*'] then
        globals['*'] = {}
    end
    for _, res in ipairs(results) do
        if mark[res] then
            goto CONTINUE
        end
        mark[res] = true
        local name = guide.getSimpleName(res)
        if name then
            if not globals[name] then
                globals[name] = {}
                subscribe[uri][#subscribe[uri]+1] = name
            end
            globals[name][#globals[name]+1] = res
            globals['*'][#globals['*']+1] = res
        end
        ::CONTINUE::
    end
    tracy.ZoneEnd()
    return globals
end

local function getGlobalSetsOfFile(uri)
    local cache = files.getCache(uri)
    if cache.globalSets then
        return cache.globalSets
    end
    local globals = {}
    cache.globalSets = globals
    local ast = files.getAst(uri)
    if not ast then
        return globals
    end
    tracy.ZoneBeginN 'getGlobalSetsOfFile'
    local results = guide.findGlobals(ast.ast)
    local subscribe = ws.getCache 'globalSetsSubscribe'
    subscribe[uri] = {}
    local mark = {}
    if not globals['*'] then
        globals['*'] = {}
    end
    for _, res in ipairs(results) do
        if mark[res] then
            goto CONTINUE
        end
        mark[res] = true
        if vm.isSet(res) then
            local name = guide.getSimpleName(res)
            if name then
                if not globals[name] then
                    globals[name] = {}
                    subscribe[uri][#subscribe[uri]+1] = name
                end
                globals[name][#globals[name]+1] = res
                globals['*'][#globals['*']+1] = res
            end
        end
        ::CONTINUE::
    end
    tracy.ZoneEnd()
    return globals
end

local function getGlobals(name)
    tracy.ZoneBeginN 'getGlobals #2'
    local results = {}
    local n = 0
    local uris = files.getAllUris()
    for i = 1, #uris do
        local globals = getGlobalsOfFile(uris[i])[name]
        if globals then
            for j = 1, #globals do
                n = n + 1
                results[n] = globals[j]
            end
        end
    end
    local dummyCache = vm.getCache 'globalDummy'
    for key in pairs(config.config.diagnostics.globals) do
        if name == '*' or name == key then
            if not dummyCache[key] then
                dummyCache[key] = {
                    type   = 'dummy',
                    start  = 0,
                    finish = 0,
                    [1]    = key
                }
            end
            n = n + 1
            results[n] = dummyCache[key]
        end
    end
    tracy.ZoneEnd()
    return results
end

local function getGlobalSets(name)
    tracy.ZoneBeginN 'getGlobalSets #2'
    local results = {}
    local n = 0
    local uris = files.getAllUris()
    for i = 1, #uris do
        local globals = getGlobalSetsOfFile(uris[i])[name]
        if globals then
            for j = 1, #globals do
                n = n + 1
                results[n] = globals[j]
            end
        end
    end
    local dummyCache = vm.getCache 'globalDummy'
    for key in pairs(config.config.diagnostics.globals) do
        if name == '*' or name == key then
            if not dummyCache[key] then
                dummyCache[key] = {
                    type   = 'dummy',
                    start  = 0,
                    finish = 0,
                    [1]    = key
                }
            end
            n = n + 1
            results[n] = dummyCache[key]
        end
    end
    tracy.ZoneEnd()
    return results
end

local function fastGetAnyGlobals()
    local results = {}
    local mark = {}
    for uri in files.eachFile() do
        --local globalSets = getGlobalsOfFile(uri)
        --for destName, sources in util.sortPairs(globalSets) do
        --    if not mark[destName] then
        --        mark[destName] = true
        --        results[#results+1] = sources[1]
        --    end
        --end
        local globals = getGlobalsOfFile(uri)
        for destName, sources in util.sortPairs(globals) do
            if not mark[destName] then
                mark[destName] = true
                results[#results+1] = sources[1]
            end
        end
    end
    return results
end

local function fastGetAnyGlobalSets()
    local results = {}
    local mark = {}
    for uri in files.eachFile() do
        local globals = getGlobalSetsOfFile(uri)
        for destName, sources in util.sortPairs(globals) do
            if not mark[destName] then
                mark[destName] = true
                results[#results+1] = sources[1]
            end
        end
    end
    return results
end

local function checkNeedUpdate()
    local getGlobalCache      = ws.getCache 'getGlobals'
    local getGlobalSetsCache  = ws.getCache 'getGlobalSets'
    local needUpdateGlobals   = ws.getCache 'needUpdateGlobals'
    for uri in pairs(needUpdateGlobals) do
        needUpdateGlobals[uri] = nil
        if files.exists(uri) then
            for name in pairs(getGlobalsOfFile(uri)) do
                getGlobalCache[name] = nil
            end
            for name in pairs(getGlobalSetsOfFile(uri)) do
                getGlobalSetsCache[name] = nil
            end
        end
    end
end

function vm.getGlobals(key)
    checkNeedUpdate()
    local cache = ws.getCache('getGlobals')[key]
    if cache ~= nil then
        return cache
    end
    cache = getGlobals(key)
    ws.getCache('getGlobals')[key] = cache
    return cache
end

function vm.getGlobalSets(key)
    checkNeedUpdate()
    local cache = ws.getCache('getGlobalSets')[key]
    if cache ~= nil then
        return cache
    end
    tracy.ZoneBeginN('getGlobalSets')
    cache = getGlobalSets(key)
    ws.getCache('getGlobalSets')[key] = cache
    tracy.ZoneEnd()
    return cache
end

files.watch(function (ev, uri)
    if ev == 'update' then
        local globalSubscribe     = ws.getCache 'globalSubscribe'
        local globalSetsSubscribe = ws.getCache 'globalSetsSubscribe'
        local getGlobalCache      = ws.getCache 'getGlobals'
        local getGlobalSetsCache  = ws.getCache 'getGlobalSets'
        local needUpdateGlobals   = ws.getCache 'needUpdateGlobals'
        uri = files.asKey(uri)
        if globalSubscribe[uri] then
            for _, name in ipairs(globalSubscribe[uri]) do
                getGlobalCache[name] = nil
                getGlobalCache['*'] = nil
            end
        end
        if globalSetsSubscribe[uri] then
            for _, name in ipairs(globalSetsSubscribe[uri]) do
                getGlobalSetsCache[name] = nil
                getGlobalSetsCache['*'] = nil
            end
        end
        needUpdateGlobals[uri] = true
    end
end)
