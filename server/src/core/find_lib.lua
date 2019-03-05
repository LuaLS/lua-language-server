local function getParentName(lib, isObject)
    for _, parent in ipairs(lib.parent) do
        if isObject then
            if parent.type == 'object' then
                return parent.nick or parent.name
            end
        else
            if parent.type ~= 'object' then
                return parent.nick or parent.name
            end
        end
    end
    return ''
end

local function findLib(source)
    local value = source:bindValue()
    local lib = value:getLib()
    if not lib then
        return nil
    end
    if lib.parent then
        if source:getFlag 'object' then
            -- *string:sub
            local fullKey = ('*%s:%s'):format(getParentName(lib, true), lib.name)
            return lib, fullKey, true
        else
            local parentValue = source:getFlag 'parent'
            if parentValue and parentValue:getType() == 'string' then
                -- *string.sub
                local fullKey = ('*%s.%s'):format(getParentName(lib, false), lib.name)
                return lib, fullKey, false
            else
                -- string.sub
                local fullKey = ('%s.%s'):format(getParentName(lib, false), lib.name)
                return lib, fullKey, false
            end
        end
    else
        local name = lib.nick or lib.name
        return lib, name, false
    end
end

return function (source)
    if source:bindValue() then
        local lib, fullKey, oo = findLib(source)
        return lib, fullKey, oo
    end
    return nil
end
