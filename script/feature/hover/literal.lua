ls.feature.provider.hover(function (param, action)
    local source = param.source
    if source.kind ~= 'string' then
        return
    end
    ---@cast source LuaParser.Node.String
    local str = source.value
    local len = #str
    local charLen = ls.util.utf8Len(str, 1, -1)
    local label
    if len == charLen then
        label = "'{} 个字节'" % { len }
    else
        label = "'{} 个字节，{} 个字符'" % { len, charLen }
    end
    action.push { label = label }
end)

ls.feature.provider.hover(function (param, action)
    local source = param.source
    if source.kind ~= 'integer' and source.kind ~= 'float' then
        return
    end
    ---@cast source LuaParser.Node.Integer | LuaParser.Node.Float
    if source.numBase == 10 then
        return
    end
    action.push { label = source.toString }
end)
