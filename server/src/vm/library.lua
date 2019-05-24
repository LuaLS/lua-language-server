local sourceMgr = require 'vm.source'

local valueMgr
local functionMgr

local CHILD_CACHE = {}
local VALUE_CACHE = {}
local Special = {}

local buildLibValue
local buildLibChild

function buildLibValue(lib)
    if VALUE_CACHE[lib] then
        return VALUE_CACHE[lib]
    end
    if not valueMgr then
        valueMgr = require 'vm.value'
        functionMgr = require 'vm.function'
    end
    local tp = lib.type
    local value
    if     tp == 'table' then
        value = valueMgr.create('table', sourceMgr.dummy())
    elseif tp == 'function' then
        local dummySource = sourceMgr.dummy()
        value = valueMgr.create('function', dummySource)
        local func = functionMgr.create(dummySource)
        value:setFunction(func)
        if lib.args then
            for _, arg in ipairs(lib.args) do
                func:createLibArg(arg, sourceMgr.dummy())
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
            if lib.special == 'pairs' then
                func:setReturn(1, Special['next'])
            end
            if lib.special == 'ipairs' then
                func:setReturn(1, Special['@ipairs'])
            end
        end
    elseif tp == 'string' then
        value = valueMgr.create('string', sourceMgr.dummy())
    elseif tp == 'boolean' then
        value = valueMgr.create('boolean', sourceMgr.dummy())
    elseif tp == 'number' then
        value = valueMgr.create('number', sourceMgr.dummy())
    elseif tp == 'integer' then
        value = valueMgr.create('integer', sourceMgr.dummy())
    elseif tp == 'nil' then
        value = valueMgr.create('nil', sourceMgr.dummy())
    else
        value = valueMgr.create(tp or 'any', sourceMgr.dummy())
    end
    value:setLib(lib)
    VALUE_CACHE[lib] = value

    if lib.child then
        for fName, fLib in pairs(lib.child) do
            local fValue = buildLibValue(fLib)
            value:rawSet(fName, fValue)
            value:addInfo('set child', sourceMgr.dummy(), fName, fValue)
        end
    end

    if lib.special == 'next' then
        Special['next'] = value
    end
    if lib.special == '@ipairs' then
        Special['@ipairs'] = value
        return nil
    end

    return value
end

function buildLibChild(lib)
    if not valueMgr then
        valueMgr = require 'vm.value'
        functionMgr = require 'vm.function'
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

local function clearCache()
    CHILD_CACHE = {}
    VALUE_CACHE = {}
end

return {
    value = buildLibValue,
    child = buildLibChild,
    clear = clearCache,
    special = Special,
}
