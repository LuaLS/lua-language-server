local files = require 'files'
local await = require 'await'
local guide = require 'parser.guide'
local vm    = require 'vm'
local lang  = require 'language'

local function isYieldAble(defs, i)
    local hasFuncDef
    for _, def in ipairs(defs) do
        if def.type == 'function' then
            hasFuncDef = true
            local arg = def.args and def.args[i]
            if arg and vm.isAsync(arg, true) then
                return true
            end
        end
        if def.type == 'doc.type.function' then
            hasFuncDef = true
            local arg = def.args and def.args[i]
            if arg and vm.isAsync(arg.extends, true) then
                return true
            end
        end
    end
    return not hasFuncDef
end

return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    guide.eachSourceType(state.ast, 'call', function (source) ---@async
        if not source.args then
            return
        end
        await.delay()
        local defs = vm.getDefs(source.node)
        if #defs == 0 then
            return
        end
        for i, arg in ipairs(source.args) do
            if  vm.isAsync(arg, true)
            and not isYieldAble(defs, i) then
                callback {
                    start   = source.node.start,
                    finish  = source.node.finish,
                    message = lang.script('DIAG_NOT_YIELDABLE', i),
                }
            end
        end
    end)
end
