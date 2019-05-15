local lni = require 'lni'
local fs = require 'bee.filesystem'
local config = require 'config'

local Library = {}

local function mergeEnum(lib, locale)
    if not lib or not locale then
        return
    end
    local pack = {}
    for _, enum in ipairs(lib) do
        if enum.enum then
            pack[enum.enum] = enum
        end
        if enum.code then
            pack[enum.code] = enum
        end
    end
    for _, enum in ipairs(locale) do
        if pack[enum.enum] then
            if enum.description then
                pack[enum.enum].description = enum.description
            end
        end
        if pack[enum.code] then
            if enum.description then
                pack[enum.code].description = enum.description
            end
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
            if field.description then
                pack[field.field].description = field.description
            end
        end
    end
end

local function mergeLocale(libs, locale)
    if not libs or not locale then
        return
    end
    for name in pairs(locale) do
        if libs[name] then
            if locale[name].description then
                libs[name].description = locale[name].description
            end
            mergeEnum(libs[name].enums, locale[name].enums)
            mergeField(libs[name].fields, locale[name].fields)
        end
    end
end

local function isMatchVersion(version)
    if not version then
        return true
    end
    local runtimeVersion = config.config.runtime.version
    if type(version) == 'table' then
        for i = 1, #version do
            if version[i] == runtimeVersion then
                return true
            end
        end
    else
        if version == runtimeVersion then
            return true
        end
    end
    return false
end

local function insertGlobal(tbl, key, value)
    if not isMatchVersion(value.version) then
        return false
    end
    if not value.doc then
        value.doc = key
    end
    tbl[key] = value
    return true
end

local function insertOther(tbl, key, value)
    if not value.version then
        return
    end
    if not tbl[key] then
        tbl[key] = {}
    end
    if type(value.version) == 'string' then
        tbl[key][#tbl[key]+1] = value.version
    elseif type(value.version) == 'table' then
        for _, version in ipairs(value.version) do
            if type(version) == 'string' then
                tbl[key][#tbl[key]+1] = version
            end
        end
    end
    table.sort(tbl[key])
end

local function insertCustom(tbl, key, value, libName)
    if not tbl[key] then
        tbl[key] = {}
    end
    tbl[key][#tbl[key]+1] = libName
    table.sort(tbl[key])
end

local function isEnableGlobal(libName)
    if config.config.runtime.library[libName] then
        return true
    end
    if libName:sub(1, 1) == '@' then
        return true
    end
    return false
end

local function mergeSource(alllibs, name, lib, libName)
    if not lib.source then
        if isEnableGlobal(libName) then
            local suc = insertGlobal(alllibs.global, name, lib)
            if not suc then
                insertOther(alllibs.other, name, lib)
            end
        else
            insertCustom(alllibs.custom, name, lib, libName)
        end
        return
    end
    for _, source in ipairs(lib.source) do
        local sourceName = source.name or name
        if source.type == 'global' then
            if isEnableGlobal(libName) then
                local suc = insertGlobal(alllibs.global, sourceName, lib)
                if not suc then
                    insertOther(alllibs.other, sourceName, lib)
                end
            else
                insertCustom(alllibs.custom, sourceName, lib, libName)
            end
        elseif source.type == 'library' then
            insertGlobal(alllibs.library, sourceName, lib)
        elseif source.type == 'object' then
            insertGlobal(alllibs.object, sourceName, lib)
        end
    end
end

local function copy(t)
    local new = {}
    for k, v in pairs(t) do
        new[k] = v
    end
    return new
end

local function insertChild(tbl, name, key, value)
    if not name or not key then
        return
    end
    if not isMatchVersion(value.version) then
        return
    end
    if not value.doc then
        value.doc = ('%s.%s'):format(name, key)
    end
    if not tbl[name] then
        tbl[name] = {
            type = name,
            name = name,
            child = {},
        }
    end
    tbl[name].child[key] = copy(value)
end

local function mergeParent(alllibs, name, lib, libName)
    for _, parent in ipairs(lib.parent) do
        if parent.type == 'global' then
            if isEnableGlobal(libName) then
                insertChild(alllibs.global, parent.name, name, lib)
            end
        elseif parent.type == 'library' then
            insertChild(alllibs.library, parent.name, name, lib)
        elseif parent.type == 'object' then
            insertChild(alllibs.object,  parent.name, name, lib)
        end
    end
end

local function mergeLibs(alllibs, libs, libName)
    if not libs then
        return
    end
    for _, lib in pairs(libs) do
        if lib.parent then
            mergeParent(alllibs, lib.name, lib, libName)
        else
            mergeSource(alllibs, lib.name, lib, libName)
        end
    end
end

local function loadLocale(language, relative)
    local localePath = ROOT / 'locale' / language / relative
    local localeBuf = io.load(localePath)
    if localeBuf then
        local locale = table.container()
        xpcall(lni, log.error, localeBuf, localePath:string(), {locale})
        return locale
    end
    return nil
end

local function fix(libs)
    for name, lib in pairs(libs) do
        lib.name = lib.name or name
        lib.child = {}
    end
end

local function scan(path)
    local result = {path}
    local i = 0
    return function ()
        i = i + 1
        local current = result[i]
        if not current then
            return nil
        end
        if fs.is_directory(current) then
            for path in current:list_directory() do
                result[#result+1] = path
            end
        end
        return current
    end
end

local function init()
    local lang = require 'language'
    local id = lang.id
    Library.global  = table.container()
    Library.library = table.container()
    Library.object  = table.container()
    Library.other   = table.container()
    Library.custom  = table.container()

    for libPath in (ROOT / 'libs'):list_directory() do
        local enableGlobal
        local libName = libPath:filename():string()
        for path in scan(libPath) do
            local libs
            local buf = io.load(path)
            if buf then
                libs = table.container()
                xpcall(lni, log.error, buf, path:string(), {libs})
                fix(libs)
            end
            local relative = fs.relative(path, ROOT)

            local locale = loadLocale('en-US', relative)
            mergeLocale(libs, locale)
            if id ~= 'en-US' then
                locale = loadLocale(id, relative)
                mergeLocale(libs, locale)
            end
            mergeLibs(Library, libs, libName)
        end
    end
end

function Library.reload()
    init()
end

init()

return Library
