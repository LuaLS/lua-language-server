local files     = require 'files'
local guide     = require 'parser.guide'
local vm        = require 'vm'
local funcHover = require 'core.hover.function'

local function getHoverAsFunction(source)
    local values = vm.getValue(source)
    for _, value in ipairs(values) do
        if value.type == 'function' then
            local funcLabel = funcHover.label(value.source)
        end
    end
end

local function getHover(source)
    local isFunction = vm.hasType(source, 'function')
    if isFunction then
        getHoverAsFunction(source)
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
        or source.type == 'method' then
            return getHover(source)
        end
    end)
    return hover
end
