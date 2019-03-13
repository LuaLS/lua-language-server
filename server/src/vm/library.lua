local sourceMgr = require 'vm.source'

local createValue
local createFunction

local CHILD_CACHE = {}

local buildLibValue
local buildLibChild

function buildLibValue(lib)
    if not createValue then
        createValue = require 'vm.value'
        createFunction = require 'vm.function'
    end
    local tp = lib.type
    local value
    if     tp == 'table' then
        value = createValue('table', sourceMgr.dummy())
    elseif tp == 'function' then
        value = createValue('function', sourceMgr.dummy())
        local func = createFunction()
        value:setFunction(func)
        if lib.args then
            for _, arg in ipairs(lib.args) do
                func:createLibArg(arg)
            end
        end
        if lib.returns then
            for i, rtn in ipairs(lib.returns) do
                if rtn.type == '...' then
                    func:returnDots(i)
                else
                    func:setReturn(i, buildLibValue(rtn))
                end
            end
        end
    elseif tp == 'string' then
        value = createValue('string', sourceMgr.dummy())
    elseif tp == 'boolean' then
        value = createValue('boolean', sourceMgr.dummy())
    elseif tp == 'number' then
        value = createValue('number', sourceMgr.dummy())
    elseif tp == 'integer' then
        value = createValue('integer', sourceMgr.dummy())
    elseif tp == 'nil' then
        value = createValue('nil', sourceMgr.dummy())
    else
        value = createValue(tp or 'any', sourceMgr.dummy())
    end
    value:setLib(lib)

    if lib.child then
        for fName, fLib in pairs(lib.child) do
            local fValue = buildLibValue(fLib)
            value:rawSet(fName, fValue)
        end
    end

    return value
end

function buildLibChild(lib)
    if not createValue then
        createValue = require 'vm.value'
        createFunction = require 'vm.function'
    end
    if CHILD_CACHE[lib] then
        return CHILD_CACHE[lib]
    end
    local child = {}
    for fName, fLib in pairs(lib.child) do
        local fValue = buildLibValue(fLib)
        child[fName] = fValue
    end
    CHILD_CACHE[lib] = child
    return child
end

return {
    value = buildLibValue,
    child = buildLibChild,
}
