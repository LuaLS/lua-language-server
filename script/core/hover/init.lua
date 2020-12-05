local files      = require 'files'
local guide      = require 'parser.guide'
local vm         = require 'vm'
local getLabel   = require 'core.hover.label'
local getDesc    = require 'core.hover.description'
local util       = require 'utility'
local findSource = require 'core.find-source'
local lang       = require 'language'

local function eachFunctionAndOverload(value, callback)
    callback(value)
    if not value.bindDocs then
        return
    end
    for _, doc in ipairs(value.bindDocs) do
        if doc.type == 'doc.overload' then
            callback(doc.overload)
        end
    end
end

local function getHoverAsFunction(source)
    local values = vm.getDefs(source, 0)
    local desc   = getDesc(source)
    local labels = {}
    local defs = 0
    local protos = 0
    local other = 0
    local oop = source.type == 'method'
             or source.type == 'getmethod'
             or source.type == 'setmethod'
    local mark = {}
    for _, def in ipairs(values) do
        def = guide.getObjectValue(def) or def
        if def.type == 'function'
        or def.type == 'doc.type.function' then
            eachFunctionAndOverload(def, function (value)
                if mark[value] then
                    return
                end
                mark[value] =true
                local label = getLabel(value, oop)
                if label then
                    defs = defs + 1
                    labels[label] = (labels[label] or 0) + 1
                    if labels[label] == 1 then
                        protos = protos + 1
                    end
                end
                desc = desc or getDesc(value)
            end)
        elseif def.type == 'table'
        or     def.type == 'boolean'
        or     def.type == 'string'
        or     def.type == 'number' then
            other = other + 1
            desc = desc or getDesc(def)
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
    if not desc then
        local values = vm.getDefs(source, 0)
        for _, def in ipairs(values) do
            desc = getDesc(def)
            if desc then
                break
            end
        end
    end
    return {
        label       = label,
        source      = source,
        description = desc,
    }
end

local function getHoverAsDocName(source)
    local label = getLabel(source)
    local desc  = getDesc(source)
    return {
        label       = label,
        source      = source,
        description = desc,
    }
end

local function getHover(source)
    if source.type == 'doc.type.name' then
        return getHoverAsDocName(source)
    end
    local isFunction = vm.hasInferType(source, 'function', 0)
    if isFunction then
        return getHoverAsFunction(source)
    else
        return getHoverAsValue(source)
    end
end

local accept = {
    ['local']         = true,
    ['setlocal']      = true,
    ['getlocal']      = true,
    ['setglobal']     = true,
    ['getglobal']     = true,
    ['field']         = true,
    ['method']        = true,
    ['string']        = true,
    ['number']        = true,
    ['doc.type.name'] = true,
    ['function']      = true,
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
