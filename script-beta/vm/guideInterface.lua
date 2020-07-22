local vm    = require 'vm.vm'
local files = require 'files'
local ws    = require 'workspace'

local m = {}

function m.searchFileReturn(results, ast)
    local returns = ast.returns
    for _, ret in ipairs(returns) do
        if ret[1] then
            if ret[1].type == 'table' then
                vm.mergeResults(results, { ret[1] })
            else
                local newRes = vm.getDefs(ret[1])
                vm.mergeResults(results, newRes)
            end
        end
    end
end

function m.require(args)
    local reqName = args[1] and args[1][1]
    if not reqName then
        return nil
    end
    local results = {}
    local uris = ws.findUrisByRequirePath(reqName, true)
    for _, uri in ipairs(uris) do
        local ast = files.getAst(uri)
        if ast then
            m.searchFileReturn(results, ast.ast)
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
        return m.require(args)
    end
end
