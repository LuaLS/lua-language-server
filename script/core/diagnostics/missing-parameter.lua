local files  = require 'files'
local guide  = require 'parser.guide'
local vm     = require 'vm'
local lang   = require 'language'

local function countCallArgs(source)
    local result = 0
    if not source.args then
        return 0
    end
    result = result + #source.args
    return result
end

---@return integer
local function countFuncArgs(source)
    if not source.args or #source.args == 0 then
        return 0
    end
    local count = 0
    for i = #source.args, 1, -1 do
        local arg = source.args[i]
        if  arg.type ~= '...'
        and not vm.compileNode(arg):isNullable() then
            return i
        end
    end
    return count
end

local function getFuncArgs(func)
    local funcArgs
    local defs = vm.getDefs(func)
    for _, def in ipairs(defs) do
        if def.type == 'function'
        or def.type == 'doc.type.function' then
            local args = countFuncArgs(def)
            if not funcArgs or args < funcArgs then
                funcArgs = args
            end
        end
    end
    return funcArgs
end

return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    guide.eachSourceType(state.ast, 'call', function (source)
        local callArgs = countCallArgs(source)

        local func = source.node
        local funcArgs = getFuncArgs(func)

        if not funcArgs then
            return
        end

        local delta = callArgs - funcArgs
        if delta >= 0 then
            return
        end
        callback {
            start  = source.start,
            finish = source.finish,
            message = lang.script('DIAG_MISS_ARGS', funcArgs, callArgs),
        }
    end)
end
