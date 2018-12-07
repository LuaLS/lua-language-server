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
        local locale
        local buf = io.load(path)
        if buf then
            libs = table.container()
            xpcall(lni.classics, log.error, buf, path:string(), {libs})
        end
        local relative = fs.relative(path, ROOT)
        local localePath = ROOT / 'locale' / language / relative
        local localeBuf = io.load(localePath)
        if localeBuf then
            locale = table.container()
            xpcall(lni.classics, log.error, localeBuf, localePath:string(), {locale})
        end

        mergeLocale(libs, locale)
        mergeLibs(Libs, libs)
    end

    return Libs
end

local function checkLib(var, lib)
    return var.key
end

local function findLib(var, libs)
    local key = var.key
    for name, lib in pairs(libs) do
        if name == key then
            local fullkey = checkLib(var, lib)
            if fullkey then
                return lib, fullkey
            end
        end
    end
    return nil, nil
end

return function (var)
    local libs = getLibs()
    local lib, key = findLib(var, libs)
    return lib, key
end
