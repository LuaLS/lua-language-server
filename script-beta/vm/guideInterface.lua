local vm    = require 'vm.vm'
local files = require 'files'
local ws    = require 'workspace'

local m = {}

function m.searchFileReturn(results, ast, index)
    local returns = ast.returns
    for _, ret in ipairs(returns) do
        local exp = ret[index]
        if exp then
            if exp.type == 'table' then
                vm.mergeResults(results, { exp })
            else
                local newRes = vm.getDefs(exp)
                vm.mergeResults(results, newRes)
            end
        end
    end
end

function m.require(args, index)
    local reqName = args[1] and args[1][1]
    if not reqName then
        return nil
    end
    local results = {}
    local uris = ws.findUrisByRequirePath(reqName, true)
    for _, uri in ipairs(uris) do
        local ast = files.getAst(uri)
        if ast then
            m.searchFileReturn(results, ast.ast, index)
        end
    end
    return results
end

function m.dofile(args, index)
    local reqName = args[1] and args[1][1]
    if not reqName then
        return
    end
    local results = {}
    local uris = ws.findUrisByFilePath(reqName, true)
    for _, uri in ipairs(uris) do
        local ast = files.getAst(uri)
        if ast then
            m.searchFileReturn(results, ast.ast, index)
        end
    end
    return results
end

vm.interface = {}

function vm.interface.call(func, args, index)
    local lib = vm.getLibrary(func)
    if not lib then
        return nil
    end
    if lib.name == 'require' and index == 1 then
        return m.require(args, index)
    end
    if lib.name == 'dofile' then
        return m.dofile(args, index)
    end
end

function vm.interface.global(name)
    return vm.getGlobals(name)
end
