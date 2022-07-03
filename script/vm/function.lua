---@class vm
local vm = require 'vm.vm'

---@param arg parser.object
---@return parser.object?
local function getDocParam(arg)
    if not arg.bindDocs then
        return nil
    end
    for _, doc in ipairs(arg.bindDocs) do
        if doc.type == 'doc.param'
        and doc.param[1] == arg[1] then
            return doc
        end
    end
    return nil
end

---@param func parser.object
---@return integer min
---@return number  max
function vm.countParamsOfFunction(func)
    local min = 0
    local max = 0
    if func.type == 'function' then
        if func.args then
            max = #func.args
            for i = #func.args, 1, -1 do
                local arg = func.args[i]
                if arg.type == '...' then
                    max = math.huge
                elseif arg.type == 'self'
                and    i == 1 then
                    min = i
                    break
                elseif getDocParam(arg)
                and    not vm.compileNode(arg):isNullable() then
                    min = i
                    break
                end
            end
        end
    end
    if func.type == 'doc.type.function' then
        if func.args then
            max = #func.args
            for i = #func.args, 1, -1 do
                local arg = func.args[i]
                if arg.name and arg.name[1] =='...' then
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

---@param node vm.node
---@return integer min
---@return number  max
function vm.countParamsOfNode(node)
    local min, max
    for n in node:eachObject() do
        if n.type == 'function'
        or n.type == 'doc.type.function' then
            ---@cast n parser.object
            local fmin, fmax = vm.countParamsOfFunction(n)
            if not min or fmin < min then
                min = fmin
            end
            if not max or fmax > max then
                max = fmax
            end
        end
    end
    return min or 0, max or math.huge
end

---@param func parser.object
---@param onlyDoc? boolean
---@param mark? table
---@return integer min
---@return number  max
function vm.countReturnsOfFunction(func, onlyDoc, mark)
    if func.type == 'function' then
        ---@type integer?
        local min
        ---@type number?
        local max
        local hasDocReturn
        if func.bindDocs then
            local lastReturn
            local n = 0
            ---@type integer?
            local dmin
            ---@type number?
            local dmax
            for _, doc in ipairs(func.bindDocs) do
                if doc.type == 'doc.return' then
                    hasDocReturn = true
                    for _, ret in ipairs(doc.returns) do
                        n = n + 1
                        lastReturn = ret
                        dmax = n
                        if  (not ret.name or ret.name[1] ~= '...')
                        and not vm.compileNode(ret):isNullable() then
                            dmin = n
                        end
                    end
                end
            end
            if lastReturn then
                if lastReturn.name and lastReturn.name[1] == '...' then
                    dmax = math.huge
                end
            end
            if dmin and (not min or (dmin < min)) then
                min = dmin
            end
            if dmax and (not max or (dmax > max)) then
                max = dmax
            end
        end
        if not onlyDoc and not hasDocReturn and func.returns then
            for _, ret in ipairs(func.returns) do
                local rmin, rmax = vm.countList(ret, mark)
                if not min or rmin < min then
                    min = rmin
                end
                if not max or rmax > max then
                    max = rmax
                end
            end
        end
        return min or 0, max or math.huge
    end
    if func.type == 'doc.type.function' then
        return vm.countList(func.returns)
    end
    error('not a function')
end

---@param func parser.object
---@param mark? table
---@return integer min
---@return number  max
function vm.countReturnsOfCall(func, args, mark)
    local funcs = vm.getMatchedFunctions(func, args)
    ---@type integer?
    local min
    ---@type number?
    local max
    for _, f in ipairs(funcs) do
        local rmin, rmax = vm.countReturnsOfFunction(f, false, mark)
        if not min or rmin < min then
            min = rmin
        end
        if not max or rmax > max then
            max = rmax
        end
    end
    return min or 0, max or math.huge
end

---@param list parser.object[]?
---@param mark? table
---@return integer min
---@return number  max
function vm.countList(list, mark)
    if not list then
        return 0, 0
    end
    local lastArg = list[#list]
    if not lastArg then
        return 0, 0
    end
    if lastArg.type == '...'
    or lastArg.type == 'varargs' then
        return #list - 1, math.huge
    end
    if lastArg.type == 'call' then
        if not mark then
            mark = {}
        end
        if mark[lastArg] then
            return #list - 1, math.huge
        end
        mark[lastArg] = true
        local rmin, rmax = vm.countReturnsOfCall(lastArg.node, lastArg.args, mark)
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
