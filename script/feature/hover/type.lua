ls.feature.provider.hover(function (param, action)
    local source = param.source
    if source.kind ~= 'catid' then
        return
    end

    ---@cast source LuaParser.Node.CatID

    local type = param.vm.rt.type(source.id)
    if type:isClassLike() then
        action.push {
            label = '(class) ' .. type:view()
        }
        return
    end

    if type:isAliasLike() then
        action.push {
            label = '(alias) {} 展开为 {}' % {
                type:view(),
                type.value:view {
                    noFunctionDetail = true,
                },
            }
        }
        return
    end
end)
