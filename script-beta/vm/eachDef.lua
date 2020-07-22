local vm    = require 'vm.vm'
local guide = require 'parser.guide'
local ws    = require 'workspace'
local files = require 'files'

local m = {}

function m.searchFileReturn(results, ast, index)
    local returns = ast.returns
    for _, ret in ipairs(returns) do
        local exp = ret[index]
        if exp then
            local newRes = m.eachDef(ret[index])
            if #newRes == 0 then
                newRes[1] = exp
            end
            vm.mergeResults(results, newRes)
        end
    end
end

function m.require(results, args, index)
    local reqName = args[1] and args[1][1]
    if not reqName then
        return
    end
    local uris = ws.findUrisByRequirePath(reqName, true)
    for _, uri in ipairs(uris) do
        local ast = files.getAst(uri)
        if ast then
            m.searchFileReturn(results, ast.ast, index)
        end
    end
end

function m.dofile(results, args, index)
    local reqName = args[1] and args[1][1]
    if not reqName then
        return
    end
    local uris = ws.findUrisByFilePath(reqName, true)
    for _, uri in ipairs(uris) do
        local ast = files.getAst(uri)
        if ast then
            m.searchFileReturn(results, ast.ast, index)
        end
    end
end

function m.searchDefAcrossRequire(results)
    for _, source in ipairs(results) do
        local func, args, index = guide.getCallValue(source)
        if not func then
            goto CONTINUE
        end
        local lib = vm.getLibrary(func)
        if not lib then
            goto CONTINUE
        end
        if lib.name == 'require' and index == 1 then
            m.require(results, args, index)
        end
        if lib.name == 'dofile' then
            m.dofile(results, args, index)
        end
        ::CONTINUE::
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
