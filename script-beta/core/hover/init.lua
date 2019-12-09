local files     = require 'files'
local guide     = require 'parser.guide'
local vm        = require 'vm'
local getLabel  = require 'core.hover.label'
local getDesc   = require 'core.hover.description'
local util      = require 'utility'

local function getHoverAsFunction(source)
    local values = vm.getValue(source)
    local labels = {}
    local defs = 0
    local protos = 0
    local other = 0
    for _, value in ipairs(values) do
        if value.type == 'function' then
            local label = getLabel(value.source, source)
            defs = defs + 1
            labels[label] = (labels[label] or 0) + 1
            if labels[label] == 1 then
                protos = protos + 1
            end
        else
            other = other + 1
        end
    end

    if defs == 1 and other == 0 then
        return {
            label  = next(labels),
            source = source,
        }
    end

    -- TODO 翻译
    local lines = {}
    if defs > 1 then
        lines[#lines+1] = ('(%d 个定义，%d 个原型)'):format(defs, protos)
    end
    if other > 0 then
        lines[#lines+1] = ('(%d 个非函数定义)'):format(other)
    end
    if defs > 1 then
        for label, count in util.sortPairs(labels) do
            lines[#lines+1] = ('(%d) %s'):format(count, label)
        end
    else
        lines[#lines+1] = next(labels)
    end
    local label = table.concat(lines, '\n')
    return {
        label  = label,
        source = source,
    }
end

local function getHoverAsValue(source)
    local label = getLabel(source, source)
    local desc  = getDesc(source)
    return {
        label       = label,
        description = desc,
        source      = source,
    }
end

local function getHover(source)
    local isFunction = vm.hasType(source, 'function')
    if isFunction then
        return getHoverAsFunction(source)
    else
        return getHoverAsValue(source)
    end
end

return function (uri, offset)
    local ast = files.getAst(uri)
    if not ast then
        return nil
    end
    local hover = guide.eachSourceContain(ast.ast, offset, function (source)
        if source.type == 'local'
        or source.type == 'setlocal'
        or source.type == 'getlocal'
        or source.type == 'setglobal'
        or source.type == 'getglobal'
        or source.type == 'field'
        or source.type == 'method'
        or source.type == 'string' then
            return getHover(source)
        end
    end)
    return hover
end
