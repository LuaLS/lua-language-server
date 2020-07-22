local vm    = require 'vm.vm'
local guide = require 'parser.guide'
local ws    = require 'workspace'
local files = require 'files'

local m = {}

function m.searchFileReturn(results, ast)
    local returns = ast.returns
    for _, ret in ipairs(returns) do
        if ret[1] then
            m.eachDef(ret[1], results)
        end
    end
end

function m.require(results, args)
    local reqName = args[1] and args[1][1]
    if not reqName then
        return
    end
    local uris = ws.findUrisByRequirePath(reqName, true)
    for _, uri in ipairs(uris) do
        local ast = files.getAst(uri)
        if ast then
            m.searchFileReturn(results, ast.ast)
        end
    end
end

function m.searchDefAcrossRequire(results)
    for _, source in ipairs(results) do
        local func, args, index = guide.getCallValue(source)
        if func and index == 1 then
            local lib = vm.getLibrary(func)
            if lib and lib.name == 'require' then
                m.require(results, args)
            end
        end
    end
end

function m.searchLibrary(source, results)
    if not source then
        return
    end
    local lib = vm.getLibrary(source)
    if not lib then
        return
    end
    vm.mergeResults(results, { lib })
end

function m.eachDef(source, results)
    results = results or {}
    local lock = vm.lock('eachDef', source)
    if not lock then
        return results
    end

    local myResults = guide.requestDefinition(source, vm.interface)
    m.searchDefAcrossRequire(myResults)
    vm.mergeResults(results, myResults)
    m.searchLibrary(source, results)
    m.searchLibrary(guide.getObjectValue(source), results)

    lock()

    return results
end

function vm.getDefs(source)
    local cache = vm.cache.eachDef[source] or m.eachDef(source)
    vm.cache.eachDef[source] = cache
    return cache
end

function vm.eachDef(source, callback)
    local results = vm.getDefs(source)
    for i = 1, #results do
        callback(results[i])
    end
end
