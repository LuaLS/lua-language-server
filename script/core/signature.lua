local getFunctionHover = require 'core.hover.function'
local getFunctionHoverAsLib = require 'core.hover.lib_function'
local getFunctionHoverAsEmmy = require 'core.hover.emmy_function'
local findLib = require 'core.find_lib'
local buildValueName = require 'core.hover.name'
local findSource = require 'core.find_source'

local function findCall(vm, pos)
    local results = {}
    vm:eachSource(function (src)
        if      src.type == 'call'
            and src.start <= pos
            and src.finish >= pos
        then
            results[#results+1] = src
        end
    end)
    if #results == 0 then
        return nil
    end
    -- 可能处于 'func1(func2(' 的嵌套中，将最近的call放到最前面
    table.sort(results, function (a, b)
        return a.start > b.start
    end)
    return results
end

local function getSelect(args, pos)
    if not args then
        return 1
    end
    for i, arg in ipairs(args) do
        if arg.start <= pos and arg.finish >= pos - 1 then
            return i
        end
    end
    return #args + 1
end

local function getFunctionSource(call)
    local simple = call:get 'simple'
    for i, source in ipairs(simple) do
        if source == call then
            return simple[i-1]
        end
    end
    return nil
end

local function getHover(call, pos)
    local args = call:bindCall()
    if not args then
        return nil
    end

    local value = call:findCallFunction()
    if not value then
        return nil
    end

    local select = getSelect(args, pos)
    local source = getFunctionSource(call)
    local object = source:get 'object'
    local lib, fullkey = findLib(source)
    local name = fullkey or buildValueName(source)
    local hover
    if lib then
        hover = getFunctionHoverAsLib(name, lib, object, select)
    else
        local emmy = value:getEmmy()
        if emmy and emmy.type == 'emmy.functionType' then
            hover = getFunctionHoverAsEmmy(name, emmy, object, select)
        else
            ---@type emmyFunction
            local func = value:getFunction()
            hover = getFunctionHover(name, func, object, select)
            local overLoads = func and func:getEmmyOverLoads()
            if overLoads then
                for _, ol in ipairs(overLoads) do
                    hover = getFunctionHoverAsEmmy(name, ol, object, select)
                end
            end
        end
    end
    return hover
end

local function isInFunctionOrTable(call, pos)
    local args = call:bindCall()
    if not args then
        return false
    end
    local select = getSelect(args, pos)
    local arg = args[select]
    if not arg then
        return false
    end
    if arg.type == 'function' or arg.type == 'table' then
        return true
    end
    return false
end

return function (vm, pos)
    local source = findSource(vm, pos) or findSource(vm, pos-1)
    if not source or source.type == 'string' then
        return
    end
    local calls = findCall(vm, pos)
    if not calls or #calls == 0 then
        return nil
    end

    local nearCall = calls[1]
    if isInFunctionOrTable(nearCall, pos) then
        return nil
    end

    local hover = getHover(nearCall, pos)
    if not hover then
        return nil
    end

    -- skip `name(`
    local head = #hover.name + 1
    hover.label = ('%s(%s)'):format(hover.name, hover.argStr)
    if hover.argLabel then
        hover.argLabel[1] = hover.argLabel[1] + head
        hover.argLabel[2] = hover.argLabel[2] + head
    end
    
    return { hover }
end
