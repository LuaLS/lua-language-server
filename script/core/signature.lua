local files      = require 'files'
local searcher   = require 'core.searcher'
local vm         = require 'vm'
local hoverLabel = require 'core.hover.label'
local hoverDesc  = require 'core.hover.description'
local guide      = require 'parser.guide'
local lookback   = require 'core.look-backward'

local function findNearCall(uri, ast, pos)
    local text  = files.getText(uri)
    local state = files.getState(uri)
    local nearCall
    guide.eachSourceContain(ast.ast, pos, function (src)
        if src.type == 'call'
        or src.type == 'table'
        or src.type == 'function' then
            local finishOffset = guide.positionToOffset(state, src.finish)
            -- call(),$
            if  src.finish <= pos
            and text:sub(finishOffset, finishOffset) == ')' then
                return
            end
            -- {},$
            if  src.finish <= pos
            and text:sub(finishOffset, finishOffset) == '}' then
                return
            end
            if not nearCall or nearCall.start <= src.start then
                nearCall = src
            end
        end
    end)
    if not nearCall then
        return nil
    end
    if nearCall.type ~= 'call' then
        return nil
    end
    return nearCall
end

---@async
local function makeOneSignature(source, oop, index)
    local label = hoverLabel(source, oop)
    -- 去掉返回值
    label = label:gsub('%s*->.+', '')
    local params = {}
    local i = 0
    local argStart, argLabel = label:match '()(%b())'
    local converted = argLabel
        : sub(2, -2)
        : gsub('%b<>', function (str)
            return ('_'):rep(#str)
        end)
        : gsub('%b()', function (str)
            return ('_'):rep(#str)
        end)
        : gsub('[%[%]%(%)]', '_')
    for start, finish in converted:gmatch '%s*()[^,]+()' do
        i = i + 1
        params[i] = {
            label = {start + argStart - 1, finish - 1 + argStart},
        }
    end
    -- 不定参数
    if index > i and i > 0 then
        local lastLabel = params[i].label
        local text = label:sub(lastLabel[1] + 1, lastLabel[2])
        if text:sub(1, 3) == '...' then
            index = i
        end
    end
    return {
        label       = label,
        params      = params,
        index       = index,
        description = hoverDesc(source),
    }
end

---@async
local function makeSignatures(text, call, pos)
    local node = call.node
    local oop = node.type == 'method'
             or node.type == 'getmethod'
             or node.type == 'setmethod'
    local index
    if call.args then
        local args = {}
        for _, arg in ipairs(call.args) do
            if not arg.dummy then
                args[#args+1] = arg
            end
        end
        local uri   = guide.getUri(call)
        local state = files.getState(uri)
        for i, arg in ipairs(args) do
            local startOffset = guide.positionToOffset(state, arg.start)
            startOffset =  lookback.findTargetSymbol(text, startOffset, '(')
                        or lookback.findTargetSymbol(text, startOffset, ',')
                        or startOffset
            local startPos = guide.offsetToPosition(state, startOffset)
            if startPos > pos then
                index = i - 1
                break
            end
            if pos <= arg.finish then
                index = i
                break
            end
        end
        if not index then
            local offset     = guide.positionToOffset(state, pos)
            local backSymbol = lookback.findSymbol(text, offset)
            if backSymbol == ','
            or backSymbol == '(' then
                index = #args + 1
            else
                index = #args
            end
        end
    else
        index = 1
    end
    local signs = {}
    local defs = vm.getDefs(node)
    local mark = {}
    for _, src in ipairs(defs) do
        src = searcher.getObjectValue(src) or src
        if src.type == 'function'
        or src.type == 'doc.type.function' then
            if not mark[src] then
                mark[src] = true
                signs[#signs+1] = makeOneSignature(src, oop, index)
            end
        end
    end
    return signs
end

---@async
return function (uri, pos)
    local state = files.getState(uri)
    if not state then
        return nil
    end
    local text = files.getText(uri)
    local offset = guide.positionToOffset(state, pos)
    pos = guide.offsetToPosition(state, lookback.skipSpace(text, offset))
    local call = findNearCall(uri, state, pos)
    if not call then
        return nil
    end
    local signs = makeSignatures(text, call, pos)
    if not signs or #signs == 0 then
        return nil
    end
    return signs
end
