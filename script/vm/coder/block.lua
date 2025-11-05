---@param coder VM.Coder
---@param block LuaParser.Node.Block
local function parseBlock(coder, block)
    coder:pushBlock()
    for _, child in ipairs(block.childs) do
        coder:withIndentation(function ()
            coder:compile(child)
        end, child.code)
        coder:addLine('')
    end
    coder:popBlock()
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

    for _, child in ipairs(source.childs) do
        if child.subtype == 'if' then
            coder:compile(child.condition)
        end
        if child.subtype == 'elseif' then
            coder:compile(child.condition)
        end
        coder:withIndentation(function ()
            parseBlock(coder, child)
        end, child.code)
    end
end)
