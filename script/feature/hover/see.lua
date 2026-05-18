ls.feature.provider.hover(function (param, action)
    if param.source.kind ~= 'catseename' then
        return
    end
    local source = param.source
    ---@cast source LuaParser.Node.CatSeeName

    local rt = param.scope.rt
    local names = ls.util.split(source.id, '.')

    for i = 2, #names do
        local t = rt.type(table.concat(names, '.', 1, i - 1))
        local fields = rt:findFields(t, names[i])
        for _, field in ipairs(fields) do
            local fieldValue = field.value:simplify():view { noFunctionDetail = true }
            local label = '(field) {}: {}' % { source.id, fieldValue }
            action.push { label = label }
            return
        end
    end
end)
