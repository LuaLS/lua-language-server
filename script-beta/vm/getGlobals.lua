local guide = require 'parser.guide'
local vm    = require 'vm.vm'
local files = require 'files'

local function getGlobalsOfFile(uri)
    local globals = {}
    local ast = files.getAst(uri)
    if not ast then
        return globals
    end
    local env = guide.getENV(ast.ast)
    local results = guide.requestFields(env)
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

local function getGlobals(name)
    local results = {}
    for uri in files:eachFile() do
        local cache = files.getCache(uri)
        cache.globals = cache.globals or getGlobalsOfFile(uri)
        if cache.globals[name] then
            for _, source in ipairs(cache.globals[name]) do
                results[#results+1] = source
            end
        end
    end
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
