local lni = require 'lni'

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
    for name in pairs(locale) do
        if libs[name] then
            libs[name].description = locale[name].description
            mergeEnum(libs[name].enums, locale[name].enums)
            mergeField(libs[name].fields, locale[name].fields)
        end
    end
end

local Libs
local function getLibs()
    if Libs then
        return Libs
    end
    Libs = table.container()
    for path in io.scan(ROOT / 'libs') do
        local buf = io.load(path)
        if buf then
            xpcall(lni.classics, log.error, buf, path:string(), {Libs})
        end
    end

    local language = require 'language'
    local locale = table.container()
    for path in io.scan(ROOT / 'locale' / language / 'libs') do
        local buf = io.load(path)
        if buf then
            xpcall(lni.classics, log.error, buf, path:string(), {locale})
        end
    end

    mergeLocale(Libs, locale)

    return Libs
end

return function (var)
    local key = var.key
    local libs = getLibs()
    return libs[key], key
end
