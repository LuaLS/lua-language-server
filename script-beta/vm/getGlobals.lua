local guide   = require 'parser.guide'
local vm      = require 'vm.vm'
local files   = require 'files'
local library = require 'library'
local util    = require 'utility'
local config  = require 'config'

local function getGlobalsOfFile(uri)
    local globals = {}
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
        local cache = files.getCache(uri)
        cache.globals = cache.globals or getGlobalsOfFile(uri)
        if name == '*' then
            for _, sources in util.sortPairs(cache.globals) do
                for _, source in ipairs(sources) do
                    results[#results+1] = source
                end
            end
        else
            if cache.globals[name] then
                for _, source in ipairs(cache.globals[name]) do
                    results[#results+1] = source
                end
            end
        end
    end
    insertLibrary(results, name)
    return results
end

local function getAnyGlobalsFast()
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

function vm.getGlobals(name)
    if name == '*' and config.config.intelliSense.fastGlobal then
        return getAnyGlobalsFast()
    end
    local cache = vm.getCache('getGlobals')[name]
    if cache ~= nil then
        return cache
    end
    cache = getGlobals(name)
    vm.getCache('getGlobals')[name] = cache
    return cache
end

function vm.getGlobalSets(name)
    local cache = vm.getCache('getGlobalSets')[name]
    if cache ~= nil then
        return cache
    end
    cache = {}
    local refs = getGlobals(name)
    for _, source in ipairs(refs) do
        if vm.isSet(source) then
            cache[#cache+1] = source
        end
    end
    vm.getCache('getGlobalSets')[name] = cache
    return cache
end
