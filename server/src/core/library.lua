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

local function insertGlobal(tbl, key, value)
    if value.version then
        local runtimeVersion = config.config.runtime.version
        if type(value.version) == 'table' then
            local ok
            for _, version in ipairs(value.version) do
                if version == runtimeVersion then
                    ok = true
                    break
                end
            end
            if not ok then
                return false
            end
        else
            if value.version ~= runtimeVersion then
                return false
            end
        end
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

local function mergeSource(alllibs, name, lib)
    if not lib.source then
        local suc = insertGlobal(alllibs.global, name, lib)
        if not suc then
            insertOther(alllibs.other, name, lib)
        end
        return
    end
    for _, source in ipairs(lib.source) do
        local sourceName = source.name or name
        if source.type == 'global' then
            local suc = insertGlobal(alllibs.global, sourceName, lib)
            if not suc then
                insertOther(alllibs.other, sourceName, lib)
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
    if value.version then
        local runtimeVersion = config.config.runtime.version
        if type(value.version) == 'table' then
            local ok
            for _, version in ipairs(value.version) do
                if version == runtimeVersion then
                    ok = true
                    break
                end
            end
            if not ok then
                return
            end
        else
            if value.version ~= runtimeVersion then
                return
            end
        end
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
            insertChild(alllibs.global,  parent.name, name, lib)
        elseif parent.type == 'library' then
            insertChild(alllibs.library, parent.name, name, lib)
        elseif parent.type == 'object' then
            insertChild(alllibs.object,  parent.name, name, lib)
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

    for path in scan(ROOT / 'libs') do
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
        mergeLibs(Library, libs)
    end
end

function Library.reload()
    init()
end

init()

return Library
