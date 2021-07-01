local files    = require 'files'
local infer    = require 'core.infer'
local vm       = require 'vm'
local config   = require 'config'
local guide    = require 'parser.guide'

local function typeHint(uri, edits, start, finish)
    local ast = files.getState(uri)
    if not ast then
        return
    end
    local mark = {}
    guide.eachSourceBetween(ast.ast, start, finish, function (source)
        if  source.type ~= 'local'
        and source.type ~= 'setglobal'
        and source.type ~= 'tablefield'
        and source.type ~= 'tableindex'
        and source.type ~= 'setfield'
        and source.type ~= 'setindex' then
            return
        end
        if source.dummy then
            return
        end
        if source[1] == '_' then
            return
        end
        if source.value and guide.isLiteral(source.value) then
            return
        end
        if source.parent.type == 'funcargs' then
            if not config.get 'Lua.hint.paramType' then
                return
            end
        else
            if not config.get 'Lua.hint.setType' then
                return
            end
        end
        local view = infer.searchAndViewInfers(source)
        if view == 'any'
        or view == 'nil' then
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
        if mark[src] then
            return
        end
        mark[src] = true
        edits[#edits+1] = {
            newText = (':%s'):format(view),
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
    if not config.get 'Lua.hint.paramName' then
        return
    end
    local ast = files.getState(uri)
    if not ast then
        return
    end
    local mark = {}
    guide.eachSourceBetween(ast.ast, start, finish, function (source)
        if source.type ~= 'call' then
            return
        end
        if not hasLiteralArgInCall(source) then
            return
        end
        local defs = vm.getDefs(source.node)
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
            if not mark[arg] and guide.isLiteral(arg) then
                mark[arg] = true
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
