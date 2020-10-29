local files      = require 'files'
local guide      = require 'parser.guide'
local vm         = require 'vm'
local getLabel   = require 'core.hover.label'
local getDesc    = require 'core.hover.description'
local util       = require 'utility'
local findSource = require 'core.find-source'
local lang       = require 'language'

local function getHoverAsFunction(source)
    local values = vm.getInfers(source, 'deep')
    local desc   = getDesc(source)
    local labels = {}
    local defs = 0
    local protos = 0
    local other = 0
    local oop = source.type == 'method'
             or source.type == 'getmethod'
             or source.type == 'setmethod'
    for _, value in ipairs(values) do
        if value.type == 'function' then
            local label = getLabel(value.source, oop)
            if label then
                defs = defs + 1
                labels[label] = (labels[label] or 0) + 1
                if labels[label] == 1 then
                    protos = protos + 1
                end
            end
        elseif value.type == 'table'
        or     value.type == 'boolean'
        or     value.type == 'string'
        or     value.type == 'number' then
            other = other + 1
        end
    end

    if defs == 1 and other == 0 then
        return {
            label       = next(labels),
            source      = source,
            description = desc,
        }
    end

    local lines = {}
    if defs > 1 then
        lines[#lines+1] = lang.script('HOVER_MULTI_DEF_PROTO', defs, protos)
    end
    if other > 0 then
        lines[#lines+1] = lang.script('HOVER_MULTI_PROTO_NOT_FUNC', other)
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
        label       = label,
        source      = source,
        description = desc,
    }
end

local function getHoverAsValue(source)
    local oop = source.type == 'method'
             or source.type == 'getmethod'
             or source.type == 'setmethod'
    local label = getLabel(source, oop)
    local desc  = getDesc(source)
    return {
        label       = label,
        source      = source,
        description = desc,
    }
end

local function getHover(source)
    vm.setSearchLevel(5)
    local isFunction = vm.hasInferType(source, 'function', 'deep')
    if isFunction then
        return getHoverAsFunction(source)
    else
        return getHoverAsValue(source)
    end
end

local accept = {
    ['local']     = true,
    ['setlocal']  = true,
    ['getlocal']  = true,
    ['setglobal'] = true,
    ['getglobal'] = true,
    ['field']     = true,
    ['method']    = true,
    ['string']    = true,
    ['number']    = true,
}

local function getHoverByUri(uri, offset)
    local ast = files.getAst(uri)
    if not ast then
        return nil
    end
    local source = findSource(ast, offset, accept)
    if not source then
        return nil
    end
    local hover = getHover(source)
    return hover
end

return {
    get   = getHover,
    byUri = getHoverByUri,
}
