---@class vm
local vm = require 'vm.vm'

---@param func parser.object
---@return integer min
---@return integer max
function vm.countParamsOfFunction(func)
    local min = 0
    local max = 0
    if func.type == 'function'
    or func.type == 'doc.type.function' then
        if func.args then
            max = #func.args
            min = max
            for i = #func.args, 1, -1 do
                local arg = func.args[i]
                if arg.type == '...'
                or (arg.name and arg.name[1] =='...') then
                    max = math.huge
                elseif not vm.compileNode(arg):isNullable() then
                    min = i
                    break
                end
            end
        end
    end
    return min, max
end

---@param func parser.object
---@return integer min
---@return integer max
function vm.countReturnsOfFunction(func)
    if func.type == 'function' then
        if not func.returns then
            return 0, 0
        end
        local min, max
        for _, ret in ipairs(func.returns) do
            local rmin, rmax = vm.countList(ret)
            if not min or rmin < min then
                min = rmin
            end
            if not max or rmax > max then
                max = rmax
            end
        end
        return min, max
    end
    if func.type == 'doc.type.function' then
        return vm.countList(func.returns)
    end
    return 0, 0
end

---@param func parser.object
---@return integer min
---@return integer max
function vm.countReturnsOfCall(func, args)
    local funcs = vm.getMatchedFunctions(func, args)
    local min
    local max
    for _, f in ipairs(funcs) do
        local rmin, rmax = vm.countReturnsOfFunction(f)
        if not min or rmin < min then
            min = rmin
        end
        if not max or rmax > max then
            max = rmax
        end
    end
    return min or 0, max or 0
end

---@param list parser.object[]?
---@return integer min
---@return integer max
function vm.countList(list)
    if not list then
        return 0, 0
    end
    local lastArg = list[#list]
    if not lastArg then
        return 0, 0
    end
    if lastArg.type == '...' then
        return #list - 1, math.huge
    end
    if lastArg.type == 'call' then
        local rmin, rmax = vm.countReturnsOfCall(lastArg.node, lastArg.args)
        return #list - 1 + rmin, #list - 1 + rmax
    end
    return #list, #list
end

---@param func parser.object
---@param args parser.object[]?
---@return parser.object[]
function vm.getMatchedFunctions(func, args)
    local funcs = {}
    local node = vm.compileNode(func)
    for n in node:eachObject() do
        if n.type == 'function'
        or n.type == 'doc.type.function' then
            funcs[#funcs+1] = n
        end
    end
    if #funcs <= 1 then
        return funcs
    end

    local amin, amax = vm.countList(args)

    local matched = {}
    for _, n in ipairs(funcs) do
        local min, max = vm.countParamsOfFunction(n)
        if amin >= min and amax <= max then
            matched[#matched+1] = n
        end
    end

    if #matched == 0 then
        return funcs
    else
        return matched
    end
end
