local files  = require 'files'
local guide  = require 'parser.guide'
local vm     = require 'vm'
local lang   = require 'language'
local define = require 'proto.define'

local function countCallArgs(source)
    local result = 0
    if not source.args then
        return 0
    end
    result = result + #source.args
    return result
end

local function countFuncArgs(source)
    local result = 0
    if not source.args or #source.args == 0 then
        return result
    end
    if source.args[#source.args].type == '...' then
        return math.maxinteger
    end
    result = result + #source.args
    return result
end

local function countOverLoadArgs(source, doc)
    local result = 0
    local func = doc.overload
    if not func.args or #func.args == 0 then
        return result
    end
    if func.args[#func.args].type == '...' then
        return math.maxinteger
    end
    result = result + #func.args
    return result
end

local function getFuncArgs(func)
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
            if def.bindDocs then
                for _, doc in ipairs(def.bindDocs) do
                    if doc.type == 'doc.overload' then
                        args = countOverLoadArgs(def, doc)
                        if not funcArgs or args > funcArgs then
                            funcArgs = args
                        end
                    end
                end
            end
        end
    end
    return funcArgs
end

return function (uri, callback)
    local ast = files.getState(uri)
    if not ast then
        return
    end

    local cache = vm.getCache 'redundant-parameter'

    guide.eachSourceType(ast.ast, 'call', function (source)
        -- parameters be expanded by iterator
        if source.node.iterator then
            return
        end
        local callArgs = countCallArgs(source)
        if callArgs == 0 then
            return
        end

        local func = source.node
        local funcArgs = getFuncArgs(func)

        if not funcArgs then
            return
        end

        local delta = callArgs - funcArgs
        if delta <= 0 then
            return
        end
        if callArgs == 1 and source.node.type == 'getmethod' then
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
