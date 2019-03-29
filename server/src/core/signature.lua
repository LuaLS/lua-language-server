local getFunctionHover = require 'core.hover.function'
local getFunctionHoverAsLib = require 'core.hover.lib_function'
local findLib = require 'core.find_lib'
local buildValueName = require 'core.hover.name'
local findSource = require 'core.find_source'

local function findCall(vm, pos)
    local results = {}
    for _, src in ipairs(vm.sources) do
        if      src.type == 'call' 
            and src.start <= pos
            and src.finish >= pos
        then
            results[#results+1] = src
        end
    end
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
    local func, args = call:bindCall()
    if not func then
        return
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
        hover = getFunctionHover(name, func:getFunction(), object, select)
    end
    if hover and hover.argLabel then
        return hover
    end
end

local function isInFunctionOrTable(call, pos)
    local func, args = call:bindCall()
    if not func then
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

    local hovers = {}
    for _, call in ipairs(calls) do
        hovers[#hovers+1] = getHover(call, pos)
    end

    if #hovers == 0 then
        return nil
    end

    return hovers
end
