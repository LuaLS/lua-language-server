local hover = require 'matcher.hover'

local function isContainPos(obj, pos)
    if obj.start <= pos and obj.finish >= pos then
        return true
    end
    return false
end

local function findArgCount(args, pos)
    for i, arg in ipairs(args) do
        if isContainPos(arg, pos) then
            return i, arg
        end
    end
    return #args + 1, nil
end

-- 找出范围包含pos的call
local function findCall(vm, pos)
    local results = {}
    for _, call in ipairs(vm.results.calls) do
        if isContainPos(call.args, pos) then
            local n, arg = findArgCount(call.args, pos)
            if arg and arg.type == 'string' then
                return nil
            end
            local var = vm.results.sources[call.lastObj]
            if var then
                results[#results+1] = {
                    func = call.func,
                    var = var,
                    source = call.lastObj,
                    select = n,
                    args = call.args,
                }
            end
        end
    end
    -- 可能处于 'func1(func2(' 的嵌套中，因此距离越远的函数层级越低
    table.sort(results, function (a, b)
        return a.args.start < b.args.start
    end)
    return results
end

return function (vm, pos)
    local calls = findCall(vm, pos)
    if not calls or #calls == 0 then
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
