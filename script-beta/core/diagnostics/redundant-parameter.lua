local files  = require 'files'
local guide  = require 'parser.guide'
local vm     = require 'vm'
local lang   = require 'language'
local define = require 'proto.define'
local await  = require 'await'

local function countLibraryArgs(source)
    local func = vm.getLibrary(source)
    if not func then
        return nil
    end
    local result = 0
    if not func.args then
        return result
    end
    if func.args[#func.args].type == '...' then
        return math.maxinteger
    end
    result = result + #func.args
    return result
end

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
    if not source.args then
        return result
    end
    if source.args[#source.args].type == '...' then
        return math.maxinteger
    end
    if source.parent and source.parent.type == 'setmethod' then
        result = result + 1
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
        if not vm.hasType(func, 'function') then
            return
        end
        local values = vm.getValue(func)
        for _, value in ipairs(values) do
            if value.type and value.source.type == 'function' then
                local args = countFuncArgs(value.source)
                if not funcArgs or args > funcArgs then
                    funcArgs = args
                end
            end
        end

        funcArgs = funcArgs or countLibraryArgs(func)
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
