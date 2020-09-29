local guide   = require 'parser.guide'
local vm      = require 'vm.vm'
local files   = require 'files'
local library = require 'library'
local util    = require 'utility'

local function searchG(ref, results)
    
end

local function searchEnvRef(ref, results)
    if     ref.type == 'setglobal'
    or     ref.type == 'getglobal' then
        results[#results+1] = ref
        searchG(ref, results)
    elseif ref.type == 'getlocal' then
        results[#results+1] = ref.next
        searchG(ref.next, results)
    end
end

local function getGlobalsOfFile(uri)
    local globals = {}
    local ast = files.getAst(uri)
    if not ast then
        return globals
    end
    local results = {}
    local env = guide.getENV(ast.ast)
    if env.ref then
        for _, ref in ipairs(env.ref) do
            searchEnvRef(ref, results)
        end
    end
    for _, res in ipairs(results) do
        local name = guide.getSimpleName(res)
        if name then
            if not globals[name] then
                globals[name] = {}
            end
            globals[name][#globals[name]+1] = res
        end
    end
    return globals
end

local function insertLibrary(results, name)
    if name:sub(1, 2) == 's|' then
        results[#results+1] = library.global[name:sub(3)]
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

function vm.getGlobals(name)
    local cache = vm.getCache('getGlobals')[name]
    if cache ~= nil then
        return cache
    end
    cache = getGlobals(name)
    vm.getCache('getGlobals')[name] = cache
    return cache
end

function vm.getGlobalSets(name)
    local cache = vm.getCache('getGlobalDefs')[name]
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
    vm.getCache('getGlobalDefs')[name] = cache
    return cache
end
