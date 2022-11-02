local files    = require 'files'
local guide    = require 'parser.guide'
local matchKey = require 'core.matchkey'
local define   = require 'proto.define'
local await    = require 'await'
local vm       = require 'vm'

local function buildSource(uri, source, key, results)
    if     source.type == 'local'
    or     source.type == 'setlocal'
    or     source.type == 'setglobal' then
        local name = source[1]
        if matchKey(key, name) then
            results[#results+1] = {
                name   = name,
                skind  = define.SymbolKind.Variable,
                ckind  = define.CompletionItemKind.Variable,
                source = source,
            }
        end
    elseif source.type == 'setfield'
    or     source.type == 'tablefield' then
        local field = source.field
        local name  = field and field[1]
        if name and matchKey(key, name) then
            results[#results+1] = {
                name   = name,
                skind  = define.SymbolKind.Field,
                ckind  = define.CompletionItemKind.Field,
                source = field,
            }
        end
    elseif source.type == 'setmethod' then
        local method = source.method
        local name   = method and method[1]
        if name and matchKey(key, name) then
            results[#results+1] = {
                name   = name,
                skind  = define.SymbolKind.Method,
                ckind  = define.CompletionItemKind.Method,
                source = method,
            }
        end
    end
end

local function searchFile(uri, key, results)
    local ast = files.getState(uri)
    if not ast then
        return
    end

    guide.eachSource(ast.ast, function (source)
        buildSource(uri, source, key, results)
    end)
end

---@async
---@param key string
---@param results table[]
local function searchGlobalAndClass(key, results)
    for _, global in pairs(vm.getAllGlobals()) do
        local name = global:getCodeName()
        if matchKey(key, name) then
            for _, set in ipairs(global:getAllSets()) do
                local skind, ckind
                if set.type == 'doc.class' then
                    skind = define.SymbolKind.Class
                    ckind = define.CompletionItemKind.Class
                elseif set.type == 'doc.alias' then
                    skind = define.SymbolKind.Struct
                    ckind = define.CompletionItemKind.Struct
                else
                    skind = define.SymbolKind.Variable
                    ckind = define.CompletionItemKind.Variable
                end
                results[#results+1] = {
                    name   = name,
                    skind  = skind,
                    ckind  = ckind,
                    source = set,
                }
            end
            await.delay()
        end
    end
end

---@async
---@param key string
---@param results table[]
local function searchClassField(key, results)
    local class, inField = key:match('^(.+)%.(.-)$')
    if not class then
        return
    end
    local global = vm.getGlobal('type', class)
    if not global then
        return
    end
    local set = global:getAllSets()[1]
    if not set then
        return
    end
    local suri = guide.getUri(set)
    vm.getClassFields(suri, global, nil, false, function (field, isMark)
        if field.type == 'generic' then
            return
        end
        ---@cast field -vm.generic
        local keyName = guide.getKeyName(field)
        if not keyName then
            return
        end
        if not matchKey(inField, keyName) then
            return
        end
        results[#results+1] = {
            name   = class .. '.' .. keyName,
            skind  = define.SymbolKind.Field,
            ckind  = define.SymbolKind.Field,
            source = field,
        }
    end)
end

---@async
---@param key string
---@param results table[]
local function searchWords(key, results)
    for uri in files.eachFile() do
        searchFile(uri, key, results)
        if #results > 1000 then
            break
        end
        await.delay()
    end
end

---@async
return function (key, includeWords)
    local results = {}

    searchGlobalAndClass(key, results)
    searchClassField(key, results)
    if includeWords then
        searchWords(key, results)
    end

    return results
end
