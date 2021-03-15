local files  = require 'files'
local guide  = require 'core.guide'
local vm     = require 'vm'
local config = require 'config'

local function typeHint(uri, edits, start, finish)
    local ast = files.getAst(uri)
    if not ast then
        return
    end
    guide.eachSourceBetween(ast.ast, start, finish, function (source)
        if  source.type ~= 'local'
        and source.type ~= 'setglobal'
        and source.type ~= 'tablefield'
        and source.type ~= 'tableindex'
        and source.type ~= 'setfield'
        and source.type ~= 'setindex' then
            return
        end
        if source[1] == '_' then
            return
        end
        if source.value and guide.isLiteral(source.value) then
            return
        end
        if source.parent.type == 'funcargs' then
            if not config.config.hint.paramType then
                return
            end
        else
            if not config.config.hint.setType then
                return
            end
        end
        local infer = vm.getInferType(source, 0)
        if infer == 'any'
        or infer == 'nil' then
            return
        end
        local src = source
        if source.type == 'tablefield' then
            src = source.field
        elseif source.type == 'tableindex' then
            src = source.index
        end
        if not src then
            return
        end
        edits[#edits+1] = {
            newText = (':%s'):format(infer),
            start   = src.finish,
            finish  = src.finish,
        }
    end)
end

local function getArgNames(func)
    if not func.args or #func.args == 0 then
        return nil
    end
    local names = {}
    if func.parent.type == 'setmethod' then
        names[#names+1] = 'self'
    end
    for _, arg in ipairs(func.args) do
        if arg.type == '...' then
            break
        end
        names[#names+1] = arg[1] or ''
    end
    if #names == 0 then
        return nil
    end
    return names
end

local function hasLiteralArgInCall(call)
    if not call.args then
        return false
    end
    for _, arg in ipairs(call.args) do
        if guide.isLiteral(arg) then
            return true
        end
    end
    return false
end

local function paramName(uri, edits, start, finish)
    if not config.config.hint.paramName then
        return
    end
    local ast = files.getAst(uri)
    if not ast then
        return
    end
    guide.eachSourceBetween(ast.ast, start, finish, function (source)
        if source.type ~= 'call' then
            return
        end
        if not hasLiteralArgInCall(source) then
            return
        end
        local defs = vm.getDefs(source.node, 0)
        if not defs then
            return
        end
        local args
        for _, def in ipairs(defs) do
            if def.value then
                def = def.value
            end
            if def.type == 'function' then
                args = getArgNames(def)
                if args then
                    break
                end
            end
        end
        if not args then
            return
        end
        if source.node and source.node.type == 'getmethod' then
            table.remove(args, 1)
        end
        for i, arg in ipairs(source.args) do
            if guide.isLiteral(arg) then
                if args[i] and args[i] ~= '' then
                    edits[#edits+1] = {
                        newText = ('%s:'):format(args[i]),
                        start   = arg.start,
                        finish  = arg.start - 1,
                    }
                end
            end
        end
    end)
end

return function (uri, start, finish)
    local edits = {}
    typeHint(uri, edits, start, finish)
    paramName(uri, edits, start, finish)
    return edits
end
