local guide   = require 'parser.guide'
---@type vm
local vm      = require 'vm.vm'
local files   = require 'files'
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
    for key in pairs(config.config.diagnostics.globals) do
        if name == '*' or name == key then
            results[#results+1] = {
                type   = 'dummy',
                start  = 0,
                finish = 0,
                [1]    = key
            }
        end
    end
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
    for key in pairs(config.config.diagnostics.globals) do
        if name == '*' or name == key then
            results[#results+1] = {
                type   = 'dummy',
                start  = 0,
                finish = 0,
                [1]    = key
            }
        end
    end
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

function vm.getGlobals(key)
    local cache = vm.getCache('getGlobals')[key]
    if cache ~= nil then
        return cache
    end
    cache = getGlobals(key)
    vm.getCache('getGlobals')[key] = cache
    return cache
end

function vm.getGlobalSets(key)
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
