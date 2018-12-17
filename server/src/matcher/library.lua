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
        if enum.code then
            pack[enum.code] = enum
        end
    end
    for _, enum in ipairs(locale) do
        if pack[enum.enum] then
            pack[enum.enum].description = enum.description
        end
        if pack[enum.code] then
            pack[enum.code].description = enum.description
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

local function mergeSource(alllibs, name, lib)
    if not lib.source then
        alllibs.global[name] = lib
        return
    end
    for _, source in ipairs(lib.source) do
        local sourceName = source.name or name
        if source.type == 'global' then
            alllibs.global[sourceName] = lib
        elseif source.type == 'library' then
            alllibs.library[sourceName] = lib
        elseif source.type == 'object' then
            alllibs.object[sourceName] = lib
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

local function insert(tbl, name, key, value)
    if not name or not key then
        return
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

local function mergeParent(alllibs, name, lib)
    for _, parent in ipairs(lib.parent) do
        if parent.type == 'global' then
            insert(alllibs.global,  parent.name, name, lib)
        elseif parent.type == 'library' then
            insert(alllibs.library, parent.name, name, lib)
        elseif parent.type == 'object' then
            insert(alllibs.object,  parent.name, name, lib)
        end
    end
end

local function mergeLibs(alllibs, libs)
    if not libs then
        return
    end
    for _, lib in pairs(libs) do
        if lib.parent then
            mergeParent(alllibs, lib.name, lib)
        else
            mergeSource(alllibs, lib.name, lib)
        end
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

local function fix(libs)
    for name, lib in pairs(libs) do
        lib.name = lib.name or name
        lib.child = {}
    end
end

local function init()
    local language = require 'language'
    local alllibs = {
        global  = table.container(),
        library = table.container(),
        object  = table.container(),
    }
    for path in io.scan(ROOT / 'libs') do
        local libs
        local buf = io.load(path)
        if buf then
            libs = table.container()
            xpcall(lni.classics, log.error, buf, path:string(), {libs})
            fix(libs)
        end
        local relative = fs.relative(path, ROOT)

        local locale = loadLocale('en-US', relative)
        mergeLocale(libs, locale)
        if language ~= 'en-US' then
            locale = loadLocale(language, relative)
            mergeLocale(libs, locale)
        end
        mergeLibs(alllibs, libs)
    end

    return alllibs
end

return init()
