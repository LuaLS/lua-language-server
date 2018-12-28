
return function (result, source)
    local func = result.value
    local declarat = func.declarat or source
    if declarat then
        local key
        if declarat.type == 'name' then
            key = declarat[1]
        elseif declarat.type == 'string' then
            key = ('%q'):format(declarat[1])
        elseif declarat.type == 'number' or declarat.type == 'boolean' then
            key = tostring(declarat[1])
        elseif func.type == 'function' then
            key = ''
        elseif type(result.key) == 'string' then
            key = result.key
        else
            key = ''
        end

        local parentName = declarat.parentName

        if not parentName then
            return key or ''
        end

        if parentName == '?' then
            local parentType = result.parentValue and result.parentValue.type
            if parentType == 'table' then
            else
                parentName = '*' .. parentType
            end
        end
        if source.object then
            return parentName .. ':' .. key
        else
            if parentName then
                if declarat.index then
                    return parentName .. '[' .. key .. ']'
                else
                    return parentName .. '.' .. key
                end
            else
                return key
            end
        end
    end
    return result.key or ''
end
