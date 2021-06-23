local files      = require 'files'
local searcher   = require 'core.searcher'
local vm         = require 'vm'
local getLabel   = require 'core.hover.label'
local getDesc    = require 'core.hover.description'
local util       = require 'utility'
local findSource = require 'core.find-source'
local lang       = require 'language'
local markdown   = require 'provider.markdown'
local infer      = require 'core.infer'

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

local function getHoverAsValue(source)
    local label = getLabel(source)
    local desc  = getDesc(source)
    if not desc then
        local values = vm.getDefs(source)
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

local function getHoverAsFunction(source)
    local values = vm.getDefs(source)
    local desc   = getDesc(source)
    local labels = {}
    local defs = 0
    local protos = 0
    local other = 0
    local mark = {}
    for _, def in ipairs(values) do
        def = searcher.getObjectValue(def) or def
        if def.type == 'function'
        or def.type == 'doc.type.function' then
            eachFunctionAndOverload(def, function (value)
                if mark[value] then
                    return
                end
                mark[value] =true
                local label = getLabel(value)
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
        or     def.type == 'integer'
        or     def.type == 'number' then
            other = other + 1
            desc = desc or getDesc(def)
        end
    end

    if defs == 0 then
        return getHoverAsValue(source)
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

local function getHoverAsDocName(source)
    local label = getLabel(source)
    local desc  = getDesc(source)
    return {
        label       = label,
        source      = source,
        description = desc,
    }
end

local function isFunction(source)
    local defs = vm.getAllDefs(source)
    for _, def in ipairs(defs) do
        if def.type == 'function' then
            return true
        end
    end
    return false
end

local function getHover(source)
    if source.type == 'doc.type.name' then
        return getHoverAsDocName(source)
    end
    if isFunction(source) then
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
    ['integer']       = true,
    ['doc.type.name'] = true,
    ['function']      = true,
}

local function getHoverByUri(uri, offset)
    local ast = files.getState(uri)
    if not ast then
        return nil
    end
    local source = findSource(ast, offset, accept)
    if not source then
        return nil
    end
    local hover = getHover(source)
    if SHOWSOURCE then
        hover.description = ('%s\n---\n\n```lua\n%s\n```'):format(
            hover.description or '',
            util.dump(source, {
                deep = 1,
            })
        )
    end
    return hover
end

return {
    get   = getHover,
    byUri = getHoverByUri,
}
