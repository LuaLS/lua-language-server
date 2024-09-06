---@class vm
local vm    = require 'vm.vm'
local guide = require 'parser.guide'
local util  = require 'utility'

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
---@return integer def
function vm.countParamsOfFunction(func)
    local min = 0
    local max = 0
    local def = 0
    if func.type == 'function' then
        if func.args then
            max = #func.args
            def = max
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
            def = max
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
    return min, max, def
end

---@param source parser.object
---@return integer min
---@return number  max
---@return integer def
function vm.countParamsOfSource(source)
    local min = 0
    local max = 0
    local def = 0
    local overloads = {}
    if source.bindDocs then
        for _, doc in ipairs(source.bindDocs) do
            if doc.type == 'doc.overload' then
                overloads[doc.overload] = true
            end
        end
    end
    local hasDocFunction
    for nd in vm.compileNode(source):eachObject() do
        if nd.type == 'doc.type.function' and not overloads[nd] then
            hasDocFunction = true
            ---@cast nd parser.object
            local dmin, dmax, ddef = vm.countParamsOfFunction(nd)
            if dmin > min then
                min = dmin
            end
            if dmax > max then
                max = dmax
            end
            if ddef > def then
                def = ddef
            end
        end
    end
    if not hasDocFunction then
        local dmin, dmax, ddef = vm.countParamsOfFunction(source)
        if dmin > min then
            min = dmin
        end
        if dmax > max then
            max = dmax
        end
        if ddef > def then
            def = ddef
        end
    end
    return min, max, def
end

---@param node vm.node
---@return integer min
---@return number  max
---@return integer def
function vm.countParamsOfNode(node)
    local min, max, def
    for n in node:eachObject() do
        if n.type == 'function'
        or n.type == 'doc.type.function' then
            ---@cast n parser.object
            local fmin, fmax, fdef = vm.countParamsOfFunction(n)
            if not min or fmin < min then
                min = fmin
            end
            if not max or fmax > max then
                max = fmax
            end
            if not def or fdef > def then
                def = fdef
            end
        end
    end
    return min or 0, max or math.huge, def or 0
end

---@param func parser.object
---@param onlyDoc? boolean
---@param mark? table
---@return integer min
---@return number  max
---@return integer def
function vm.countReturnsOfFunction(func, onlyDoc, mark)
    if func.type == 'function' then
        ---@type integer?, number?, integer?
        local min, max, def
        local hasDocReturn
        if func.bindDocs then
            local lastReturn
            local n = 0
            ---@type integer?, number?, integer?
            local dmin, dmax, ddef
            for _, doc in ipairs(func.bindDocs) do
                if doc.type == 'doc.return' then
                    hasDocReturn = true
                    for _, ret in ipairs(doc.returns) do
                        n = n + 1
                        lastReturn = ret
                        dmax = n
                        ddef = n
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
            if ddef and (not def or (ddef > def)) then
                def = ddef
            end
        end
        if not onlyDoc and not hasDocReturn and func.returns then
            for _, ret in ipairs(func.returns) do
                local dmin, dmax, ddef = vm.countList(ret, mark)
                if not min or dmin < min then
                    min = dmin
                end
                if not max or dmax > max then
                    max = dmax
                end
                if not def or ddef > def then
                    def = ddef
                end
            end
        end
        return min or 0, max or math.huge, def or 0
    end
    if func.type == 'doc.type.function' then
        return vm.countList(func.returns)
    end
    error('not a function')
end

---@param source parser.object
---@return integer min
---@return number  max
---@return integer def
function vm.countReturnsOfSource(source)
    local overloads = {}
    local hasDocFunction
    local min, max, def
    if source.bindDocs then
        for _, doc in ipairs(source.bindDocs) do
            if doc.type == 'doc.overload' then
                overloads[doc.overload] = true
                local dmin, dmax, ddef = vm.countReturnsOfFunction(doc.overload)
                if not min or dmin < min then
                    min = dmin
                end
                if not max or dmax > max then
                    max = dmax
                end
                if not def or ddef > def then
                    def = ddef
                end
            end
        end
    end
    for nd in vm.compileNode(source):eachObject() do
        if nd.type == 'doc.type.function' and not overloads[nd] then
            ---@cast nd parser.object
            hasDocFunction = true
            local dmin, dmax, ddef = vm.countReturnsOfFunction(nd)
            if not min or dmin < min then
                min = dmin
            end
            if not max or dmax > max then
                max = dmax
            end
            if not def or ddef > def then
                def = ddef
            end
        end
    end
    if not hasDocFunction then
        local dmin, dmax, ddef = vm.countReturnsOfFunction(source, true)
        if not min or dmin < min then
            min = dmin
        end
        if not max or dmax > max then
            max = dmax
        end
        if not def or ddef > def then
            def = ddef
        end
    end
    return min, max, def
end

---@param func parser.object
---@param mark? table
---@return integer min
---@return number  max
---@return integer def
function vm.countReturnsOfCall(func, args, mark)
    local funcs = vm.getMatchedFunctions(func, args, mark)
    if not funcs then
        return 0, math.huge, 0
    end
    ---@type integer?, number?, integer?
    local min, max, def
    for _, f in ipairs(funcs) do
        local rmin, rmax, rdef = vm.countReturnsOfFunction(f, false, mark)
        if not min or rmin < min then
            min = rmin
        end
        if not max or rmax > max then
            max = rmax
        end
        if not def or rdef > def then
            def = rdef
        end
    end
    return min or 0, max or math.huge, def or 0
end

---@param list parser.object[]?
---@param mark? table
---@return integer min
---@return number  max
---@return integer def
function vm.countList(list, mark)
    if not list then
        return 0, 0, 0
    end
    local lastArg = list[#list]
    if not lastArg then
        return 0, 0, 0
    end
    ---@type integer, number, integer
    local min, max, def = #list, #list, #list
    if lastArg.type == '...'
    or lastArg.type == 'varargs'
    or (lastArg.type == 'doc.type' and lastArg.name and lastArg.name[1] == '...') then
        max = math.huge
    elseif lastArg.type == 'call' then
        if not mark then
            mark = {}
        end
        if mark[lastArg] then
            min = min - 1
            max = math.huge
        else
            mark[lastArg] = true
            local rmin, rmax, rdef = vm.countReturnsOfCall(lastArg.node, lastArg.args, mark)
            return min - 1 + rmin, max - 1 + rmax, def - 1 + rdef
        end
    end
    for i = min, 1, -1 do
        local arg = list[i]
        if  arg.type == 'doc.type'
        and ((arg.name and arg.name[1] == '...')
            or vm.compileNode(arg):isNullable()) then
            min = i - 1
        else
            break
        end
    end
    return min, max, def
end

---@param uri uri
---@param args parser.object[]
---@return boolean
local function isAllParamMatched(uri, args, params)
    if not params then
        return false
    end
    for i = 1, #args do
        if not params[i] then
            break
        end
        local argNode = vm.compileNode(args[i])
        local defNode = vm.compileNode(params[i])
        if not vm.canCastType(uri, defNode, argNode) then
            return false
        end
    end
    return true
end

---@param uri uri
---@param args parser.object[]
---@param func parser.object
---@return number
local function calcFunctionMatchScore(uri, args, func)
    if vm.isVarargFunctionWithOverloads(func)
    or vm.isFunctionWithOnlyOverloads(func)
    or not isAllParamMatched(uri, args, func.args)
    then
        return -1
    end
    local matchScore = 0
    for i = 1, math.min(#args, #func.args) do
        local arg, param = args[i], func.args[i]
        local defLiterals, literalsCount = vm.getLiterals(param)
        if defLiterals then
            for n in vm.compileNode(arg):eachObject() do
                -- if param's literals map contains arg's literal, this is narrower than a subtype match
                if defLiterals[guide.getLiteral(n)] then
                    -- the more the literals defined in the param, the less bonus score will be added
                    -- this favors matching overload param with exact literal value, over alias/enum that has many literal values
                    matchScore = matchScore + 1/literalsCount
                    break
                end
            end
        end
    end
    return matchScore
end

---@param func parser.object
---@param args? parser.object[]
---@return parser.object[]?
function vm.getExactMatchedFunctions(func, args)
    local funcs = vm.getMatchedFunctions(func, args)
    if not args or not funcs then
        return funcs
    end
    if #funcs == 1 then
        return funcs
    end
    local uri = guide.getUri(func)
    local matchScores = {}
    for i, n in ipairs(funcs) do
        matchScores[i] = calcFunctionMatchScore(uri, args, n)
    end

    local maxMatchScore = math.max(table.unpack(matchScores))
    if maxMatchScore == -1 then
        -- all should be removed
        return nil
    end

    local minMatchScore = math.min(table.unpack(matchScores))
    if minMatchScore == maxMatchScore then
        -- all should be kept
        return funcs
    end

    -- remove functions that have matchScore < maxMatchScore
    local needRemove = {}
    for i, matchScore in ipairs(matchScores) do
        if matchScore < maxMatchScore then
            needRemove[#needRemove + 1] = i
        end
    end
    util.tableMultiRemove(funcs, needRemove)
    return funcs
end

---@param func parser.object
---@param args? parser.object[]
---@param mark? table
---@return parser.object[]?
function vm.getMatchedFunctions(func, args, mark)
    local funcs = {}
    local node = vm.compileNode(func)
    for n in node:eachObject() do
        if n.type == 'function'
        or n.type == 'doc.type.function' then
            funcs[#funcs+1] = n
        end
    end

    local amin, amax = vm.countList(args, mark)

    local matched = {}
    for _, n in ipairs(funcs) do
        local min, max = vm.countParamsOfFunction(n)
        if amin >= min and amax <= max then
            matched[#matched+1] = n
        end
    end

    if #matched == 0 then
        return nil
    else
        return matched
    end
end

---@param func table
---@return boolean
function vm.isVarargFunctionWithOverloads(func)
    if func.type ~= 'function' then
        return false
    end
    if not func.args then
        return false
    end
    if func._varargFunction ~= nil then
        return func._varargFunction
    end
    if func.args[1] and func.args[1].type == 'self' then
        if not func.args[2] or func.args[2].type ~= '...' then
            func._varargFunction = false
            return false
        end
    else
        if not func.args[1] or func.args[1].type ~= '...' then
            func._varargFunction = false
            return false
        end
    end
    if not func.bindDocs then
        func._varargFunction = false
        return false
    end
    for _, doc in ipairs(func.bindDocs) do
        if doc.type == 'doc.overload' then
            func._varargFunction = true
            return true
        end
    end
    func._varargFunction = false
    return false
end

---@param func table
---@return boolean
function vm.isFunctionWithOnlyOverloads(func)
    if func.type ~= 'function' then
        return false
    end
    if func._onlyOverloadFunction ~= nil then
        return func._onlyOverloadFunction
    end

    if not func.bindDocs then
        func._onlyOverloadFunction = false
        return false
    end
    local hasOverload = false
    for _, doc in ipairs(func.bindDocs) do
        if doc.type == 'doc.overload' then
            hasOverload = true
        elseif doc.type == 'doc.param'
        or doc.type == 'doc.return'
        then
            -- has specified @param or @return, thus not only @overload
            func._onlyOverloadFunction = false
            return false
        end
    end
    func._onlyOverloadFunction = hasOverload
    return true
end

---@param func parser.object
---@return boolean
function vm.isEmptyFunction(func)
    if #func > 0 then
        return false
    end
    local startRow  = guide.rowColOf(func.start)
    local finishRow = guide.rowColOf(func.finish)
    return finishRow - startRow <= 1
end
