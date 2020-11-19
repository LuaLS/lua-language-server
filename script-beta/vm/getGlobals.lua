local guide   = require 'parser.guide'
local vm      = require 'vm.vm'
local files   = require 'files'
local library = require 'library'
local util    = require 'utility'
local config  = require 'config'

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
    local results = guide.findGlobals(ast.ast)
    local mark = {}
    for _, res in ipairs(results) do
        if mark[res] then
            goto CONTINUE
        end
        mark[res] = true
        local name = guide.getSimpleName(res)
        if name then
            if not globals[name] then
                globals[name] = {}
            end
            globals[name][#globals[name]+1] = res
        end
        ::CONTINUE::
    end
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
    local results = guide.findGlobals(ast.ast)
    local mark = {}
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
                end
                globals[name][#globals[name]+1] = res
            end
        end
        ::CONTINUE::
    end
    return globals
end

local function insertLibrary(results, name)
    if name:sub(1, 2) == 's|' then
        local libname = name:sub(3)
        results[#results+1] = library.global[libname]
        local asName = config.config.runtime.special[libname]
        results[#results+1] = library.global[asName]
    elseif name == '*' then
        for _, lib in pairs(library.global) do
            results[#results+1] = lib
        end
    end
end

local function getGlobals(name)
    local results = {}
    for uri in files.eachFile() do
        local globals = getGlobalsOfFile(uri)
        if name == '*' then
            for _, sources in util.sortPairs(globals) do
                for _, source in ipairs(sources) do
                    results[#results+1] = source
                end
            end
        else
            if globals[name] then
                for _, source in ipairs(globals[name]) do
                    results[#results+1] = source
                end
            end
        end
    end
    insertLibrary(results, name)
    return results
end

local function getGlobalSets(name)
    local results = {}
    for uri in files.eachFile() do
        local globals = getGlobalSetsOfFile(uri)
        if name == '*' then
            for _, sources in util.sortPairs(globals) do
                for _, source in ipairs(sources) do
                    results[#results+1] = source
                end
            end
        else
            if globals[name] then
                for _, source in ipairs(globals[name]) do
                    results[#results+1] = source
                end
            end
        end
    end
    insertLibrary(results, name)
    return results
end

local function fastGetAnyGlobals()
    local results = {}
    local mark = {}
    for uri in files.eachFile() do
        local cache = files.getCache(uri)
        cache.globals = cache.globals or getGlobalsOfFile(uri)
        for destName, sources in util.sortPairs(cache.globals) do
            if not mark[destName] then
                mark[destName] = true
                results[#results+1] = sources[1]
            end
        end
    end
    insertLibrary(results, '*')
    return results
end

local function fastGetAnyGlobalSets()
    local results = {}
    local mark = {}
    for uri in files.eachFile() do
        local cache = files.getCache(uri)
        cache.globalSets = cache.globalSets or getGlobalSetsOfFile(uri)
        for destName, sources in util.sortPairs(cache.globalSets) do
            if not mark[destName] then
                mark[destName] = true
                results[#results+1] = sources[1]
            end
        end
    end
    insertLibrary(results, '*')
    return results
end

function vm.getGlobals(key)
    if key == '*' and config.config.intelliSense.fastGlobal then
        local cache = vm.getCache('fastGetAnyGlobals')[key]
        if cache ~= nil then
            return cache
        end
        cache = fastGetAnyGlobals()
        vm.getCache('fastGetAnyGlobals')[key] = cache
        return cache
    else
        local cache = vm.getCache('getGlobals')[key]
        if cache ~= nil then
            return cache
        end
        cache = getGlobals(key)
        vm.getCache('getGlobals')[key] = cache
        return cache
    end
end

function vm.getGlobalSets(key)
    if key == '*' and config.config.intelliSense.fastGlobal then
        local cache = vm.getCache('fastGetAnyGlobalSets')[key]
        if cache ~= nil then
            return cache
        end
        cache = fastGetAnyGlobalSets()
        vm.getCache('fastGetAnyGlobalSets')[key] = cache
        return cache
    end
    local cache = vm.getCache('getGlobalSets')[key]
    if cache ~= nil then
        return cache
    end
    cache = getGlobalSets(key)
    vm.getCache('getGlobalSets')[key] = cache
    return cache
end

files.watch(function (ev, uri)
    if ev == 'update' then
        getGlobalsOfFile(uri)
        getGlobalSetsOfFile(uri)
    end
end)
