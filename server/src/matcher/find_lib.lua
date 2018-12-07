local lni = require 'lni'
local fs = require 'bee.filesystem'

local function mergeEnum(lib, locale)
    if not lib or not locale then
        return
    end
    local pack = {}
    for _, enum in ipairs(lib) do
        if enum.enum then
            pack[enum.enum] = enum
        end
    end
    for _, enum in ipairs(locale) do
        if pack[enum.enum] then
            pack[enum.enum].description = enum.description
        end
    end
end

local function mergeField(lib, locale)
    if not lib or not locale then
        return
    end
    local pack = {}
    for _, field in ipairs(lib) do
        if field.field then
            pack[field.field] = field
        end
    end
    for _, field in ipairs(locale) do
        if pack[field.field] then
            pack[field.field].description = field.description
        end
    end
end

local function mergeLocale(libs, locale)
    if not libs or not locale then
        return
    end
    for name in pairs(locale) do
        if libs[name] then
            libs[name].description = locale[name].description
            mergeEnum(libs[name].enums, locale[name].enums)
            mergeField(libs[name].fields, locale[name].fields)
        end
    end
end

local function mergeLibs(target, libs)
    if not libs then
        return
    end
    for name, lib in pairs(libs) do
        target.names[#target.names+1] = name
        target.libs[#target.libs+1] = lib
    end
end

local function loadLocale(language, relative)
    local localePath = ROOT / 'locale' / language / relative
    local localeBuf = io.load(localePath)
    if localeBuf then
        local locale = table.container()
        xpcall(lni.classics, log.error, localeBuf, localePath:string(), {locale})
        return locale
    end
    return nil
end

local Libs
local function getLibs()
    if Libs then
        return Libs
    end
    local language = require 'language'
    Libs = setmetatable({
        names = {},
        libs = {},
    }, {
        __pairs = function (self)
            local i = 0
            return function ()
                i = i + 1
                return self.names[i], self.libs[i]
            end
        end,
    })
    for path in io.scan(ROOT / 'libs') do
        local libs
        local buf = io.load(path)
        if buf then
            libs = table.container()
            xpcall(lni.classics, log.error, buf, path:string(), {libs})
        end
        local relative = fs.relative(path, ROOT)

        local locale = loadLocale('en-US', relative)
        mergeLocale(libs, locale)
        if language ~= 'en-US' then
            locale = loadLocale(language, relative)
            mergeLocale(libs, locale)
        end
        mergeLibs(Libs, libs)
    end

    return Libs
end

local function isGlobal(var)
    if var.type ~= 'field' then
        return false
    end
    if not var.parent then
        return false
    end
    return var.parent.key == '_ENV' or var.parent.key == '_G'
end

local function checkSourceAsGlobal(value, name)
    if value.key == name and isGlobal(value) then
        return name
    end
    return nil
end

local function checkSourceAsLibrary(value, name)
    if value.type ~= 'lib' then
        return nil
    end
    if value.name == name then
        return name
    end
    return nil
end

local function checkSource(value, name, lib)
    if not lib.source then
        return checkSourceAsGlobal(value, name)
    end
    for _, source in ipairs(lib.source) do
        if source.type == 'global' then
            local fullKey = checkSourceAsGlobal(value, name)
            if fullKey then
                return fullKey
            end
        elseif source.type == 'library' then
            local fullKey = checkSourceAsLibrary(value, name)
            if fullKey then
                return fullKey
            end
        end
    end
    return nil
end

local function checkParentAsGlobal(parentValue, name, parent)
    local parentName = checkSourceAsGlobal(parentValue, parent.name)
    if not parentName then
        return nil
    end
    return ('%s.%s'):format(parent.name, name)
end

local function checkParentAsLibrary(parentValue, name, parent)
    local parentName = checkSourceAsLibrary(parentValue, parent.name)
    if not parentName then
        return nil
    end
    return ('%s.%s'):format(parent.name, name)
end

local function checkParentAsObject(parentValue, name, parent)
    if parentValue.type ~= parent.name then
        return nil
    end
    return ('*%s:%s'):format(parent.name, name)
end

local function checkParent(value, name, lib)
    if not lib.parent then
        return nil
    end
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

local function findLib(var, libs)
    local value = var.value or var
    for name, lib in pairs(libs) do
        local fullKey = checkSource(value, name, lib)
        if fullKey then
            return lib, fullKey, false
        end
        local fullKey, oo = checkParent(value, name, lib)
        if fullKey then
            return lib, fullKey, oo
        end
    end
    return nil, nil, nil
end

return function (var)
    local libs = getLibs()
    local lib, fullKey, oo = findLib(var, libs)
    return lib, fullKey, oo
end
