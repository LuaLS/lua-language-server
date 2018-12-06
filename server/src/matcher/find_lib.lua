local lni = require 'lni'

local function mergeLocale(libs, locale)
    for name, obj in pairs(locale) do
        if libs[name] then
            libs[name].description = obj.description
        end
    end
end

local Libs
local function getLibs()
    if Libs then
        return Libs
    end
    Libs = {}
    for path in io.scan(ROOT / 'libs') do
        local buf = io.load(path)
        if buf then
            xpcall(lni.classics, log.error, buf, path:string(), {Libs})
        end
    end

    local language = require 'language'
    local locale = {}
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
