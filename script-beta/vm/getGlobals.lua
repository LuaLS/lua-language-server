local guide   = require 'parser.guide'
local vm      = require 'vm.vm'
local files   = require 'files'
local library = require 'library'
local util    = require 'utility'
local config  = require 'config'

local function searchRawset(ref, results)
    if guide.getKeyName(ref) ~= 's|rawset' then
        return
    end
    local call = ref.parent
    if call.type ~= 'call' or call.node ~= ref then
        return
    end
    if not call.args then
        return
    end
    local arg1 = call.args[1]
    if arg1.special ~= '_G' then
        -- 不会吧不会吧，不会真的有人写成 `rawset(_G._G._G, 'xxx', value)` 吧
        return
    end
    results[#results+1] = call
end

local function searchG(ref, results)
    while ref and guide.getKeyName(ref) == 's|_G' do
        results[#results+1] = ref
        ref = ref.next
    end
    if ref then
        results[#results+1] = ref
        searchRawset(ref, results)
    end
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
