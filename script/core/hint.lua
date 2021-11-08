local files    = require 'files'
local infer    = require 'core.infer'
local vm       = require 'vm'
local config   = require 'config'
local guide    = require 'parser.guide'
local await    = require 'await'
local define   = require 'proto.define'

---@async
local function typeHint(uri, results, start, finish)
    local state = files.getState(uri)
    if not state then
        return
    end
    local mark = {}
    guide.eachSourceBetween(state.ast, start, finish, function (source) ---@async
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
        await.delay()
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
        results[#results+1] = {
            text   = ':' .. view,
            offset = src.finish,
            kind   = define.InlayHintKind.Type,
            where  = 'right',
        }
    end)
end

local function getArgNames(func)
    if not func.args or #func.args == 0 then
        return nil
    end
    local names = {}
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

---@async
local function paramName(uri, results, start, finish)
    local paramConfig = config.get 'Lua.hint.paramName'
    if not paramConfig or paramConfig == 'None' then
        return
    end
    local state = files.getState(uri)
    if not state then
        return
    end
    local mark = {}
    guide.eachSourceBetween(state.ast, start, finish, function (source) ---@async
        if source.type ~= 'call' then
            return
        end
        if paramConfig == 'Literal' and not hasLiteralArgInCall(source) then
            return
        end
        if not source.args then
            return
        end
        await.delay()
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
        local firstIndex = 1
        if source.node and source.node.type == 'getmethod' then
            firstIndex = 2
        end
        for i = firstIndex, #source.args do
            local arg = source.args[i]
            if  not mark[arg]
            and (paramConfig ~= 'Literal' or guide.isLiteral(arg)) then
                mark[arg] = true
                if args[i] and args[i] ~= '' then
                    results[#results+1] = {
                        text   = args[i] .. ':',
                        offset = arg.start,
                        kind   = define.InlayHintKind.Parameter,
                        where  = 'left',
                    }
                end
            end
        end
    end)
end

---@async
local function awaitHint(uri, results, start, finish)
    local awaitConfig = config.get 'Lua.hint.await'
    if not awaitConfig then
        return
    end
    local state = files.getState(uri)
    if not state then
        return
    end
    guide.eachSourceBetween(state.ast, start, finish, function (source) ---@async
        if source.type ~= 'call' then
            return
        end
        await.delay()
        local node = source.node
        if not vm.isAsyncCall(source) then
            return
        end
        results[#results+1] = {
            text   = 'await ',
            offset = node.start,
            kind   = define.InlayHintKind.Other,
            where  = 'left',
        }
    end)
end

---@async
return function (uri, start, finish)
    local results = {}
    typeHint(uri, results, start, finish)
    awaitHint(uri, results, start, finish)
    paramName(uri, results, start, finish)
    return results
end
