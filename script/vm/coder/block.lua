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

ls.vm.registerCoderProvider('main', function (coder, source)
    ---@cast source LuaParser.Node.Main

    coder:startTracer(source)
    local env = source.ast:findLocal(source.ast.envMode, 0)
    assert(env)
    coder:compile(env)
    coder:addLine('{varKey}:setMasterVariable(rt.VAR_G)' % {
        varKey = coder:getKey(env),
    })
    coder:addLine('')

    local varargs = source.ast:findLocal('...', 0)

    if varargs then
        coder:compile(varargs)
    end

    parseBlock(coder, source)
    coder:finishTracer()
end)

ls.vm.registerCoderProvider('do', function (coder, source)
    ---@cast source LuaParser.Node.Do

    parseBlock(coder, source)
end)

ls.vm.registerCoderProvider('if', function (coder, source)
    ---@cast source LuaParser.Node.If

    coder:getTracer():pushStack('if')
    for _, child in ipairs(source.childs) do
        coder:withIndentation(function ()
            coder:getTracer():pushStack()
            if child.condition then
                coder:getTracer():pushStack('condition')
                coder:compile(child.condition)
                coder:getTracer():popStack()
            end
            parseBlock(coder, child)
            coder:getTracer():popStack()
        end, child)
    end
    coder:getTracer():popStack()
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
