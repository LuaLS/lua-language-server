ls.vm.registerRunnerParser('table', function (runner, source)
    ---@cast source LuaParser.Node.Table

    local t = runner.node.table()

    for _, field in ipairs(source.fields) do
        local key
        if field.key.kind == 'tablefieldid' then
            key = field.key.id
        else
            key = runner:lazyParse(field.key)
        end
        local nfield = runner:makeNodeField(field.key, key, field.value)
        t:addField(nfield)
    end

    return t
end)
