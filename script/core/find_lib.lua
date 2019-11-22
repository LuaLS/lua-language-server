local hoverName = require 'core.hover.name'

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
        if source:get 'object' then
            -- *string:sub
            local fullKey = ('*%s:%s'):format(getParentName(lib, true), lib.name)
            return lib, fullKey
        else
            local parentValue = source:get 'parent'
            if parentValue and parentValue:getType() == 'string' then
                -- *string.sub
                local fullKey = ('*%s.%s'):format(getParentName(lib, false), lib.name)
                return lib, fullKey
            else
                -- string.sub
                local fullKey = ('%s.%s'):format(getParentName(lib, false), lib.name)
                return lib, fullKey
            end
        end
    else
        local name = hoverName(source)
        local libName = lib.nick or lib.name
        if name == libName or not libName then
            return lib, name
        elseif name == '' then
            return lib, libName
        else
            return lib, ('%s<%s>'):format(name, libName)
        end
    end
end

return function (source)
    if source:bindValue() then
        local lib, fullKey = findLib(source)
        return lib, fullKey
    end
    if source:get 'in index' then
        source = source:get 'in index'
        local lib, fullKey = findLib(source)
        return lib, fullKey
    end
    return nil
end
