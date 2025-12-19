---@param coder Coder
---@param block LuaParser.Node.Block
local function parseBlock(coder, block)
    coder:pushBlock()
    for _, child in ipairs(block.childs) do
        coder:withIndentation(function ()
            coder:compile(child)
        end, child)
        coder:addLine('')
    end
    coder:popBlock()
end

---@param coder Coder
---@param index integer
---@param condition LuaParser.Node.Exp
---@param mainStack Coder.Flow.Stack
local function compileCondition(coder, index, condition, mainStack)
    coder:compile(condition)

    local exp = condition:trim()

    local mainVar = mainStack:getVar(exp, true)
    if mainVar then
        local value  = coder:getCustomKey('narrow|b:{}|{}' % { index, exp.uniqueKey })
        local shadow = coder:getCustomKey('shadow|b:{}|{}' % { index, exp.uniqueKey })
        coder:addLine('{value} = rt.narrow({varKey}):truly()' % {
            value  = value,
            varKey = coder:getKey(exp),
        })
        coder:addLine('{shadow} = {var}:shadow({value})' % {
            shadow = shadow,
            var    = coder:getKey(exp),
            value  = value,
        })
        mainVar.narrowedValue = value
        mainVar.currentKey = shadow

        local var = coder.flow:getVar(exp, true)
        if var then
            var.currentKey = shadow
        end
    end

end

---@param coder Coder
---@param index integer
---@param var Coder.Variable
local function compileOtherSide(coder, index, var)
    local narrowedValue = var.narrowedValue
    if not narrowedValue then
        return
    end
    local ohValue, count = narrowedValue:gsub('|b:%d+|', '|oh:' .. index .. '|', 1)
    if count == 0 then
        return
    end
    local value  = ohValue
    local shadow = ohValue:gsub('narrow|', 'shadow|', 1)
    coder:addLine('{value} = {narrow}:otherSide()' % {
        value  = value,
        narrow = var.narrowedValue,
    })
    coder:addLine('{shadow} = {var}:shadow({value})' % {
        shadow = shadow,
        var    = var.currentKey,
        value  = value,
    })
    var.narrowedValue = value
    var.currentKey = shadow
end

---@param var Coder.Variable
---@param stacks Coder.Flow.Stack[]
---@return string?
local function mergeChanges(var, stacks)
    local hasChanged = false

    for _, stack in ipairs(stacks) do
        local svar = stack.variables[var.name]
        if svar then
            hasChanged = true
            break
        end
    end

    if not hasChanged then
        return nil
    end

    local originKey = var.narrowedValue:gmatch('^r%[narrow|oh:%d+|(.-)%]$')
    if not originKey then
        return nil
    end

    local unions = {}
    for i, stack in ipairs(stacks) do
        local svar = stack.variables[var.name]
        local key = svar and svar.currentKey
        if key then
            unions[#unions+1] = key
        else
            unions[#unions+1] = 'r[narrow]'
        end
    end
end

ls.vm.registerCoderProvider('main', function (coder, source)
    ---@cast source LuaParser.Node.Main

    local env = source.localMap['_ENV']
    if env then
        coder:addLine('{key} = rt.VAR_G' % {
            key = coder:getKey(env),
        })
        coder:addLine('{var} = {key}' % {
            var = coder:getVariableKey(env),
            key = coder:getKey(env),
        })
        coder:addLine('')
    end

    local varargs = source.localMap['...']
    coder:compile(varargs)

    parseBlock(coder, source)
end)

ls.vm.registerCoderProvider('do', function (coder, source)
    ---@cast source LuaParser.Node.Do

    parseBlock(coder, source)
end)

ls.vm.registerCoderProvider('if', function (coder, source)
    ---@cast source LuaParser.Node.If

    local mainStack = coder.flow:pushStack()
    ---@type Coder.Flow.Stack[]
    local childStacks = {}
    for i, child in ipairs(source.childs) do
        local childStack = coder.flow:pushStack()
        if child.subtype == 'if' then
            compileCondition(coder, i, child.condition, mainStack)
        end
        if child.subtype == 'elseif' then
            compileCondition(coder, i, child.condition, mainStack)
        end
        coder:withIndentation(function ()
            childStacks[#childStacks+1] = childStack
            parseBlock(coder, child)
        end, child)
        coder.flow:popStack()

        for _, var in pairs(coder.flow:currentStack().variables) do
            if var.narrowedValue then
                compileOtherSide(coder, i, var)
            end
        end
    end

    local changedVars = {}
    for _, var in pairs(coder.flow:currentStack().variables) do
        if var.narrowedValue then
            changedVars[var.name] = mergeChanges(var, childStacks)
        end
    end
    coder.flow:popStack()
end)

ls.vm.registerCoderProvider('for', function (coder, source)
    ---@cast source LuaParser.Node.For

    for _, var in pairs(source.vars) do
        coder:compile(var)
    end
    for _, exp in pairs(source.exps) do
        coder:compile(exp)
    end
    if source.subtype == 'incomplete' then
        return
    end
    if source.subtype == 'in' then
        local listKey = coder:getCustomKey('explist|' .. source.uniqueKey)
        coder:addLine('{list} = rt.list { {exps} }' % {
            list = listKey,
            exps = table.concat(
                ls.util.map(source.exps, function (exp)
                    return coder:getKey(exp)
                end),
                ', '
            ),
        })
        local forfKey = coder:getCustomKey('forf|' .. source.uniqueKey)
        coder:addLine('{forf} = rt.select({list}, 1)' % {
            forf = forfKey,
            list = listKey,
        })
        local forsKey = coder:getCustomKey('fors|' .. source.uniqueKey)
        coder:addLine('{fors} = rt.select({list}, 2)' % {
            fors = forsKey,
            list = listKey,
        })
        local forvarKey = coder:getCustomKey('forvar|' .. source.uniqueKey)
        coder:addLine('{forvar} = rt.select({list}, 3)' % {
            forvar = forvarKey,
            list   = listKey,
        })
        local callKey = coder:getCustomKey('forcall|' .. source.uniqueKey)
        coder:addLine('{call} = rt.fcall({forf}, { {fors}, {forvar} })' % {
            call    = callKey,
            forf    = forfKey,
            fors    = forsKey,
            forvar  = forvarKey,
        })

        for i, var in pairs(source.vars) do
            coder:compileAssign(var, i, 'rt.select({call}, {index})' % {
                call  = callKey,
                index = i,
            })
        end
    end

    parseBlock(coder, source)
end)

ls.vm.registerCoderProvider('while', function (coder, source)
    ---@cast source LuaParser.Node.While

    coder:compile(source.condition)
    parseBlock(coder, source)
end)

ls.vm.registerCoderProvider('repeat', function (coder, source)
    ---@cast source LuaParser.Node.Repeat

    parseBlock(coder, source)
    coder:compile(source.condition)
end)
