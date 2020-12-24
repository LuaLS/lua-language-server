local files   = require 'files'
local util    = require 'utility'
local guide   = require 'parser.guide'
---@type vm
local vm      = require 'vm.vm'
local config  = require 'config'

local function getTypesOfFile(uri)
    local types = {}
    local ast = files.getAst(uri)
    if not ast or not ast.ast.docs then
        return types
    end
    guide.eachSource(ast.ast.docs, function (src)
        if src.type == 'doc.type.name'
        or src.type == 'doc.class.name'
        or src.type == 'doc.extends.name'
        or src.type == 'doc.alias.name' then
            local name = src[1]
            if name then
                if not types[name] then
                    types[name] = {}
                end
                types[name][#types[name]+1] = src
            end
        end
    end)
    return types
end

local function getDocTypes(name)
    local results = {}
    for uri in files.eachFile() do
        local cache = files.getCache(uri)
        cache.classes = cache.classes or getTypesOfFile(uri)
        if name == '*' then
            for _, sources in util.sortPairs(cache.classes) do
                for _, source in ipairs(sources) do
                    results[#results+1] = source
                end
            end
        else
            if cache.classes[name] then
                for _, source in ipairs(cache.classes[name]) do
                    results[#results+1] = source
                end
            end
        end
    end
    return results
end

function vm.getDocEnums(doc, mark, results)
    if not doc then
        return nil
    end
    mark = mark or {}
    if mark[doc] then
        return nil
    end
    mark[doc] = true
    results = results or {}
    for _, enum in ipairs(doc.enums) do
        results[#results+1] = enum
    end
    for _, resume in ipairs(doc.resumes) do
        results[#results+1] = resume
    end
    for _, unit in ipairs(doc.types) do
        if unit.type == 'doc.type.name' then
            for _, other in ipairs(vm.getDocTypes(unit[1])) do
                if other.type == 'doc.alias.name' then
                    vm.getDocEnums(other.parent.extends, mark, results)
                end
            end
        end
    end
    return results
end

function vm.getDocTypeUnits(doc, mark, results)
    mark = mark or {}
    if mark[doc] then
        return nil
    end
    mark[doc] = true
    results = results or {}
    for _, enum in ipairs(doc.enums) do
        results[#results+1] = enum
    end
    for _, resume in ipairs(doc.resumes) do
        results[#results+1] = resume
    end
    for _, unit in ipairs(doc.types) do
        if unit.type == 'doc.type.name' then
            for _, other in ipairs(vm.getDocTypes(unit[1])) do
                if other.type == 'doc.alias.name' then
                    vm.getDocTypeUnits(other.parent.extends, mark, results)
                elseif other.type == 'doc.class.name' then
                    results[#results+1] = other
                end
            end
        else
            results[#results+1] = unit
        end
    end
    return results
end

function vm.getDocTypes(name)
    local cache = vm.getCache('getDocTypes')[name]
    if cache ~= nil then
        return cache
    end
    cache = getDocTypes(name)
    vm.getCache('getDocTypes')[name] = cache
    return cache
end

function vm.getDocClass(name)
    local cache = vm.getCache('getDocClass')[name]
    if cache ~= nil then
        return cache
    end
    cache = {}
    local results = getDocTypes(name)
    for _, doc in ipairs(results) do
        if doc.type == 'doc.class.name' then
            cache[#cache+1] = doc
        end
    end
    vm.getCache('getDocClass')[name] = cache
    return cache
end

function vm.isMetaFile(uri)
    local status = files.getAst(uri)
    if not status then
        return false
    end
    local cache = files.getCache(uri)
    if cache.isMeta ~= nil then
        return cache.isMeta
    end
    cache.isMeta = false
    if not status.ast.docs then
        return false
    end
    for _, doc in ipairs(status.ast.docs) do
        if doc.type == 'doc.meta' then
            cache.isMeta = true
            return true
        end
    end
    return false
end

function vm.getValidVersions(doc)
    if doc.type ~= 'doc.version' then
        return
    end
    local valids = {
        ['Lua 5.1'] = false,
        ['Lua 5.2'] = false,
        ['Lua 5.3'] = false,
        ['Lua 5.4'] = false,
        ['LuaJIT']  = false,
    }
    for _, version in ipairs(doc.versions) do
        if version.ge and type(version.version) == 'number' then
            for ver in pairs(valids) do
                local verNumber = tonumber(ver:sub(-3))
                if verNumber and verNumber >= version.version then
                    valids[ver] = true
                end
            end
        elseif version.le and type(version.version) == 'number' then
            for ver in pairs(valids) do
                local verNumber = tonumber(ver:sub(-3))
                if verNumber and verNumber <= version.version then
                    valids[ver] = true
                end
            end
        elseif type(version.version) == 'number' then
            valids[('Lua %.1f'):format(version.version)] = true
        elseif 'JIT' == version.version then
            valids['LuaJIT'] = true
        end
    end
    if valids['Lua 5.1'] then
        valids['LuaJIT'] = true
    end
    return valids
end

local function isDeprecated(value)
    if not value.bindDocs then
        return false
    end
    for _, doc in ipairs(value.bindDocs) do
        if doc.type == 'doc.deprecated' then
            return true
        elseif doc.type == 'doc.version' then
            local valids = vm.getValidVersions(doc)
            if not valids[config.config.runtime.version] then
                return true
            end
        end
    end
    return false
end

function vm.isDeprecated(value, deep)
    if deep then
        local defs = vm.getDefs(value, 0)
        if #defs == 0 then
            return false
        end
        for _, def in ipairs(defs) do
            if not isDeprecated(def) then
                return false
            end
        end
        return true
    else
        return isDeprecated(value)
    end
end
