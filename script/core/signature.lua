local files      = require 'files'
local guide      = require 'parser.guide'
local vm         = require 'vm'
local hoverLabel = require 'core.hover.label'
local hoverDesc  = require 'core.hover.description'

local function findNearCall(uri, ast, pos)
    local text = files.getText(uri)
    -- 检查 `f()$` 的情况，注意要区别于 `f($`
    if text:sub(pos, pos) == ')' then
        return nil
    end

    local nearCall
    guide.eachSourceContain(ast.ast, pos, function (src)
        if src.type == 'call'
        or src.type == 'table'
        or src.type == 'function' then
            if not nearCall or nearCall.start < src.start then
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

local function makeOneSignature(source, oop, index)
    local label = hoverLabel(source, oop)
    -- 去掉返回值
    label = label:gsub('%s*->.+', '')
    local params = {}
    local i = 0
    for start, finish in label:gmatch '[%(%)%,]%s*().-()%s*%f[%(%)%,%[%]]' do
        i = i + 1
        params[i] = {
            label = {start, finish-1},
        }
    end
    -- 不定参数
    if index > i and i > 0 then
        local lastLabel = params[i].label
        local text = label:sub(lastLabel[1], lastLabel[2])
        if text == '...' then
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

local function makeSignatures(call, pos)
    local node = call.node
    local oop = node.type == 'method'
             or node.type == 'getmethod'
             or node.type == 'setmethod'
    local index
    local args = call.args
    if args then
        for i, arg in ipairs(args) do
            if arg.start <= pos and arg.finish >= pos then
                index = i
                break
            end
        end
        if not index then
            index = #args + 1
        end
    else
        index = 1
    end
    local signs = {}
    local defs = vm.getDefs(node, 0)
    local mark = {}
    for _, src in ipairs(defs) do
        src = guide.getObjectValue(src) or src
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

return function (uri, pos)
    local ast = files.getAst(uri)
    if not ast then
        return nil
    end
    local call = findNearCall(uri, ast, pos)
    if not call then
        return nil
    end
    local signs = makeSignatures(call, pos)
    if not signs or #signs == 0 then
        return nil
    end
    return signs
end
