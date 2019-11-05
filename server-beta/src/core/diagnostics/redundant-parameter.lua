local files    = require 'files'
local guide    = require 'parser.guide'
local searcher = require 'searcher'
local lang     = require 'language'
local define   = require 'proto.define'
local library  = require 'library'

local function packLibraryArgs(source)
    local func = searcher.getLibrary(source)
    if not func then
        return nil
    end
    local result = {}
    if not func.args then
        return result
    end
    for _, lib in ipairs(func.args) do
        result[#result+1] = lib
    end
    return result
end

local function packCallArgs(source)
    local result = {}
    if not source.args then
        return result
    end
    if source.node and source.node.type == 'getmethod' then
        result[#result+1] = source.node.node
    end
    for _, arg in ipairs(source.args) do
        result[#result+1] = arg
    end
    return result
end

local function packFuncArgs(source)
    local result = {}
    if not source.args then
        return result
    end
    if source.parent and source.parent.type == 'setmethod' then
        result[#result+1] = source.parent.node
    end
    for _, arg in ipairs(source.args) do
        result[#result+1] = arg
    end
    return result
end

return function (uri, callback)
    local ast = files.getAst(uri)
    if not ast then
        return
    end

    guide.eachSourceType(ast.ast, 'call', function (source)
        local callArgs = packCallArgs(source)
        if not callArgs then
            return
        end

        local func = source.node
        local funcArgs
        searcher.eachRef(func, function (info)
            if info.mode == 'value' then
                local src = info.source
                if src.type == 'function' then
                    local args = packFuncArgs(src)
                    if args and (not funcArgs or #funcArgs < #args) then
                        funcArgs = args
                    end
                end
            end
        end)

        funcArgs = funcArgs or packLibraryArgs(func)
        if not funcArgs then
            return
        end

        local lastArg = funcArgs[#funcArgs]
        if lastArg and lastArg.type == '...' then
            return
        end

        for i = #funcArgs + 1, #callArgs do
            local arg = callArgs[i]
            callback {
                start   = arg.start,
                finish  = arg.finish,
                tags    = { define.DiagnosticTag.Unnecessary },
                message = lang.script('DIAG_OVER_MAX_ARGS', #funcArgs, #callArgs)
            }
        end
    end)
end
