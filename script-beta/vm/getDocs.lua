local files   = require 'files'
local util    = require 'utility'
local guide   = require 'parser.guide'
local vm      = require 'vm.vm'

local builtin = {}
for _, name in ipairs {
    'any'          ,
    'nil'          ,
    'void'         ,
    'boolean'      ,
    'number'       ,
    'integer'      ,
    'thread'       ,
    'table'        ,
    'file'         ,
    'string'       ,
    'userdata'     ,
    'lightuserdata',
    'function'     ,
} do
    builtin[#builtin+1] = {
        type   = 'doc.class.name',
        start  = 0,
        finish = 0,
        [1]    = name,
    }
end

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
    for _, source in ipairs(builtin) do
        if name == '*' or name == source[1] then
            results[#results+1] = source
        end
    end
    return results
end

function vm.getDocEnums(doc, mark, results)
    mark = mark or {}
    if mark[doc] then
        return nil
    end
    mark[doc] = true
    results = results or {}
    for _, enum in ipairs(doc.enums) do
        results[#results+1] = enum
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

function vm.getDocTypes(name)
    local cache = vm.getCache('getDocTypes')[name]
    if cache ~= nil then
        return cache
    end
    cache = getDocTypes(name)
    vm.getCache('getDocTypes')[name] = cache
    return cache
end
