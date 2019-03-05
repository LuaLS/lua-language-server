return function (source)
    local value = source:bindValue()
    local func = value:getFunction()
    local declarat
    if func then
        declarat = func.source.name
    else
        declarat = source
    end
    if not declarat then
        return source:getName() or ''
    end

    local key
    if declarat.type == 'name' then
        key = declarat[1]
    elseif declarat.type == 'string' then
        key = ('%q'):format(declarat[1])
    elseif declarat.type == 'number' or declarat.type == 'boolean' then
        key = tostring(declarat[1])
    else
        key = ''
    end
    return key
end
