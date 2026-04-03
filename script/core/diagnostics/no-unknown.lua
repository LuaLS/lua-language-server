local files   = require 'files'
local guide   = require 'parser.guide'
local lang    = require 'language'
local vm      = require 'vm'
local await   = require 'await'

local types = {
    'local',
    'setlocal',
    'setglobal',
    'getglobal',
    'setfield',
    'setindex',
    'tablefield',
    'tableindex',
}

---@async
return function (uri, callback)
    local ast = files.getState(uri)
    if not ast then
        return
    end

    ---@async
    guide.eachSourceTypes(ast.ast, types, function (source)
        await.delay()
        if vm.getInfer(source):view(uri) == 'unknown' then
            -- When a node only contains a 'variable' object whose base
            -- declaration has a known type, this is a false positive caused
            -- by circular dependency during compilation, not a true unknown.
            local dominated = false
            local node = vm.getNode(source)
            if node then
                for n in node:eachObject() do
                    if n.type == 'variable' and n.base and n.base.value then
                        local baseView = vm.getInfer(n.base):view(uri)
                        if baseView ~= 'unknown' then
                            dominated = true
                            break
                        end
                    end
                end
            end
            if not dominated then
                callback {
                    start   = source.start,
                    finish  = source.finish,
                    message = lang.script('DIAG_UNKNOWN'),
                }
            end
        end
    end)
end
