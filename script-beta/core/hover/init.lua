local files     = require 'files'
local guide     = require 'parser.guide'
local vm        = require 'vm'
local getLabel  = require 'core.hover.label'

local function getHoverAsFunction(source)
    local values = vm.getValue(source)
    local labels = {}
    for _, value in ipairs(values) do
        if value.type == 'function' then
            labels[#labels+1] = getLabel(value.source, source)
        end
    end

    local label = table.concat(labels, '\n')
    return {
        label  = label,
        source = source,
    }
end

local function getHoverAsValue(source)
    local label = getLabel(source, source)
    return {
        label  = label,
        source = source,
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
