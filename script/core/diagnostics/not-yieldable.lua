local files = require 'files'
local await = require 'await'
local guide = require 'parser.guide'
local vm    = require 'vm'
local lang  = require 'language'
local infer = require 'core.infer'

local function isYieldAble(defs, i)
    local hasFuncDef
    for _, def in ipairs(defs) do
        if def.type == 'function' then
            hasFuncDef = true
            local arg = def.args and def.args[i]
            if arg then
                if infer.hasType(arg, 'any')
                or vm.isAsync(arg, true) then
                    return true
                end
            end
        end
        if def.type == 'doc.type.function' then
            hasFuncDef = true
            local arg = def.args and def.args[i]
            if arg then
                if infer.hasType(arg.extends, 'any')
                or vm.isAsync(arg.extends, true) then
                    return true
                end
            end
        end
    end
    return not hasFuncDef
end

---@async
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
            and not vm.isLinkedCall(source.node, i)
            and not isYieldAble(defs, i) then
                callback {
                    start   = arg.start,
                    finish  = arg.finish,
                    message = lang.script('DIAG_NOT_YIELDABLE', i),
                }
            end
        end
    end)
end
