local hover = require 'matcher.hover'

local function isContainPos(obj, pos)
    if obj.start <= pos and obj.finish + 1 >= pos then
        return true
    end
    return false
end

local function findArgCount(args, pos)
    for i, arg in ipairs(args) do
        if isContainPos(arg, pos) then
            return i
        end
    end
    return #args + 1
end

-- 找出范围包含pos的，且有dirty标记的call
local function findDirtyCall(vm, pos)
    local results = {}
    for _, call in ipairs(vm.results.calls) do
        if isContainPos(call.args, pos) then
            local n = findArgCount(call.args, pos)
            results[#results+1] = {
                func = call.func,
                var = vm.results.sources[call.lastObj],
                source = call.lastObj,
                select = n,
                args = call.args,
            }
        end
    end
    -- 可能处于 'func1(func2(' 的嵌套中，因此距离越远的函数层级越低
    table.sort(results, function (a, b)
        return a.args.start < b.args.start
    end)
    return results
end

return function (vm, pos)
    local calls = findDirtyCall(vm, pos)
    if #calls == 0 then
        return nil
    end

    local hovers = {}
    for _, call in ipairs(calls) do
        local hvr = hover(call.var, call.source, nil, call.select)
        if hvr.argLabel then
            hovers[#hovers+1] = hvr
        end
    end

    if #hovers == 0 then
        return nil
    end

    return hovers
end
