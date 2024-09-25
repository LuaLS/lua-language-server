local files    = require 'files'
local vm       = require 'vm'
local config   = require 'config'
local guide    = require 'parser.guide'
local await    = require 'await'
local define   = require 'proto.define'
local lang     = require 'language'
local substr   = require 'core.substring'

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
        if source[1] == '_' then
            return
        end
        if source.value and guide.isLiteral(source.value) then
            return
        end
        if source.parent.type == 'funcargs' then
            if not config.get(uri, 'Lua.hint.paramType') then
                return
            end
        else
            if not config.get(uri, 'Lua.hint.setType') then
                return
            end
        end
        await.delay()
        local view = vm.getInfer(source):view(uri)
        if view == 'any'
        or view == 'unknown'
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
            text   = ': ' .. view,
            offset = src.finish,
            kind   = define.InlayHintKind.Type,
            where  = 'right',
            source = source,
        }
    end)
end

local function getParams(func)
    if not func.args or #func.args == 0 then
        return nil
    end
    local params = {}
    for _, arg in ipairs(func.args) do
        if arg.type == '...' then
            break
        end
        params[#params+1] = arg
    end
    if #params == 0 then
        return nil
    end
    return params
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
    local paramConfig = config.get(uri, 'Lua.hint.paramName')
    if not paramConfig or paramConfig == 'Disable' then
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
        local params
        for _, def in ipairs(defs) do
            if def.type == 'function' then
                params = getParams(def)
                if params then
                    break
                end
            end
        end
        if not params then
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
                local param = params[i]
                if param and param[1] then
                    results[#results+1] = {
                        text    = param[1] .. ':',
                        offset  = arg.start,
                        kind    = define.InlayHintKind.Parameter,
                        where   = 'left',
                        source  = param,
                    }
                end
            end
        end
    end)
end

---@async
local function arrayIndex(uri, results, start, finish)
    local state = files.getState(uri)
    if not state then
        return
    end
    local option = config.get(uri, 'Lua.hint.arrayIndex')
    if option == 'Disable' then
        return
    end

    local mixedOrLargeTable = {}
    local function isMixedOrLargeTable(tbl)
        if mixedOrLargeTable[tbl] ~= nil then
            return mixedOrLargeTable[tbl]
        end
        if #tbl > 3 then
            mixedOrLargeTable[tbl] = true
            return true
        end
        for _, child in ipairs(tbl) do
            if child.type ~= 'tableexp' then
                mixedOrLargeTable[tbl] = true
                return true
            end
        end
        mixedOrLargeTable[tbl] = false
        return false
    end

    ---@async
    guide.eachSourceType(state.ast, 'table', function (source)
        if source.finish < start or source.start > finish then
            return
        end
        await.delay()
        if option == 'Auto' then
            if not isMixedOrLargeTable(source) then
                return
            end
        end
        local list = {}
        local max  = 0
        for _, field in ipairs(source) do
            if  field.type == 'tableexp'
            and field.start < finish
            and field.finish > start then
                list[#list+1] = field
                if field.tindex > max then
                    max = field.tindex
                end
            end
        end

        if #list > 0 then
            local length = #tostring(max)
            local fmt    = '[%0' .. length .. 'd]'
            for _, field in ipairs(list) do
                results[#results+1] = {
                    text   = fmt:format(field.tindex),
                    offset = field.start,
                    kind   = define.InlayHintKind.Other,
                    where  = 'left',
                    source = field.parent,
                }
            end
        end
    end)

end

---@async
local function awaitHint(uri, results, start, finish)
    local awaitConfig = config.get(uri, 'Lua.hint.await')
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
            text    = 'await ',
            offset  = node.start,
            kind    = define.InlayHintKind.Other,
            where   = 'left',
            tooltip = lang.script.HOVER_AWAIT_TOOLTIP,
        }
    end)
end

local blockTypes = {
    'main',
    'function',
    'for',
    'loop',
    'in',
    'do',
    'repeat',
    'while',
    'ifblock',
    'elseifblock',
    'elseblock',
}

---@async
local function semicolonHint(uri, results, _start, _finish)
    local state = files.getState(uri)
    if not state then
        return
    end
    local mode = config.get(uri, 'Lua.hint.semicolon')
    if mode == 'Disable' then
        return
    end
    local subber = substr(state)
    ---@async
    guide.eachSourceTypes(state.ast, blockTypes, function (src)
        await.delay()
        if #src < 1 then return end

        for i = 1, #src - 1 do
            local current = src[i]
            local next    = src[i+1]
            local left    = current.range or current.finish
            local right   = next.start
            local text    = subber(current.finish, right)
            if mode == 'All' then
                if not text:find '[,;]' then
                    results[#results+1] = {
                        text    = ';',
                        offset  = left,
                        kind    = define.InlayHintKind.Other,
                        where   = 'right',
                    }
                end
            elseif mode == 'SameLine' then
                if not text:find '[,;\r\n]' then
                    results[#results+1] = {
                        text    = ';',
                        offset  = left,
                        kind    = define.InlayHintKind.Other,
                        where   = 'right',
                    }
                end
            end
        end

        if mode == 'All' then
            local last = src[#src]
            results[#results+1] = {
                text    = ';',
                offset  = last.range or last.finish,
                kind    = define.InlayHintKind.Other,
                where   = 'right',
            }
        end
    end)
end

---@async
return function (uri, start, finish)
    local results = {}
    typeHint(uri, results, start, finish)
    paramName(uri, results, start, finish)
    awaitHint(uri, results, start, finish)
    arrayIndex(uri, results, start, finish)
    semicolonHint(uri, results, start, finish)
    return results
end
