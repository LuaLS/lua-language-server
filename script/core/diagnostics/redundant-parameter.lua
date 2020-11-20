local files  = require 'files'
local guide  = require 'parser.guide'
local vm     = require 'vm'
local lang   = require 'language'
local define = require 'proto.define'
local await  = require 'await'

local function countCallArgs(source)
    local result = 0
    if not source.args then
        return 0
    end
    if source.node and source.node.type == 'getmethod' then
        result = result + 1
    end
    result = result + #source.args
    return result
end

local function countFuncArgs(source)
    local result = 0
    if source.parent and source.parent.type == 'setmethod' then
        result = result + 1
    end
    if not source.args then
        return result
    end
    if source.args[#source.args].type == '...' then
        return math.maxinteger
    end
    result = result + #source.args
    return result
end

return function (uri, callback)
    local ast = files.getAst(uri)
    if not ast then
        return
    end

    guide.eachSourceType(ast.ast, 'call', function (source)
        local callArgs = countCallArgs(source)
        if callArgs == 0 then
            return
        end

        local func = source.node
        local funcArgs
        local defs = vm.getDefs(func)
        for _, def in ipairs(defs) do
            if def.value then
                def = def.value
            end
            if def.type == 'function' then
                local args = countFuncArgs(def)
                if not funcArgs or args > funcArgs then
                    funcArgs = args
                end
            end
        end

        if not funcArgs then
            return
        end

        local delta = callArgs - funcArgs
        if delta <= 0 then
            return
        end
        for i = #source.args - delta + 1, #source.args do
            local arg = source.args[i]
            if arg then
                callback {
                    start   = arg.start,
                    finish  = arg.finish,
                    tags    = { define.DiagnosticTag.Unnecessary },
                    message = lang.script('DIAG_OVER_MAX_ARGS', funcArgs, callArgs)
                }
            end
        end
    end)
end
