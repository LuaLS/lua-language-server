local libs = require 'matcher.library'

local function isGlobal(var)
    if var.type ~= 'field' then
        return false
    end
    if not var.parent then
        return false
    end
    return var.parent.key == '_ENV' or var.parent.key == '_G'
end

local function checkSourceAsGlobal(value, name, showname)
    if value.key == name and isGlobal(value) then
        return showname or name
    end
    return nil
end

local function checkSourceAsLibrary(value, name, showname)
    if value.type ~= 'lib' then
        return nil
    end
    if value.name == name then
        return showname or name
    end
    return nil
end

local function checkSource(value, libname, lib)
    if not lib.source then
        return checkSourceAsGlobal(value, libname)
    end
    for _, source in ipairs(lib.source) do
        if source.type == 'global' then
            local fullKey = checkSourceAsGlobal(value, source.name or libname, source.nick or libname)
            if fullKey then
                return fullKey
            end
        elseif source.type == 'library' then
            local fullKey = checkSourceAsLibrary(value, source.name or libname, source.nick or libname)
            if fullKey then
                return fullKey
            end
        end
    end
    return nil
end

local function checkParentAsGlobal(parentValue, name, parent)
    local parentName = checkSourceAsGlobal(parentValue, parent.name, parent.nick)
    if not parentName then
        return nil
    end
    return ('%s.%s'):format(parentName, name)
end

local function checkParentAsLibrary(parentValue, name, parent)
    local parentName = checkSourceAsLibrary(parentValue, parent.name, parent.nick)
    if not parentName then
        return nil
    end
    return ('%s.%s'):format(parentName, name)
end

local function checkParentAsObject(parentValue, name, parent)
    if parentValue.type ~= parent.name then
        return nil
    end
    return ('*%s:%s'):format(parent.name, name)
end

local function checkParent(value, name, lib)
    if name ~= value.key then
        return nil
    end
    local parentValue = value.parent
    if not parentValue then
        return nil
    end
    parentValue = parentValue.value or parentValue
    for _, parent in ipairs(lib.parent) do
        if parent.type == 'global' then
            local fullKey = checkParentAsGlobal(parentValue, name, parent)
            if fullKey then
                return fullKey, false
            end
        elseif parent.type == 'library' then
            local fullKey = checkParentAsLibrary(parentValue, name, parent)
            if fullKey then
                return fullKey, false
            end
        elseif parent.type == 'object' then
            local fullKey = checkParentAsObject(parentValue, name, parent)
            if fullKey then
                return fullKey, true
            end
        end
    end
    return nil
end

local function findLib(var)
    local value = var.value or var
    for libname, lib in pairs(libs) do
        if lib.parent then
            local fullKey, oo = checkParent(value, libname, lib)
            if fullKey then
                return lib, fullKey, oo
            end
        else
            local fullKey = checkSource(value, libname, lib)
            if fullKey then
                return lib, fullKey, false
            end
        end
    end
    return nil, nil, nil
end

return function (var)
    local lib, fullKey, oo = findLib(var)
    return lib, fullKey, oo
end
