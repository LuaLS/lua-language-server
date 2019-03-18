local getName = require 'core.name'

return function (source)
    if not source then
        return ''
    end
    local value = source:bindValue()
    if not value then
        return ''
    end
    local func = value:getFunction()
    local declarat
    if func and func:getSource() then
        declarat = func:getSource().name
    else
        declarat = source
    end
    if not declarat then
        -- 如果声明者没有给名字，则找一个合适的名字
        local name = value:eachInfo(function (info, src)
            if info.type == 'local' or info.type == 'set' or info.type == 'return' then
                if src.type == 'name' and src.uri == value.uri then
                    return src[1]
                end
            end
        end)
        return name or ''
    end

    return getName(declarat, source)
end
