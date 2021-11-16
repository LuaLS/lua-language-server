local searcher = require 'core.searcher'
local config   = require 'config'
local noder    = require 'core.noder'
local util     = require 'utility'
local vm       = require "vm.vm"

local CLASS           = {'CLASS'}
local TABLE           = {'TABLE'}
local CACHE           = {'CACHE'}

local TypeSort = {
    ['boolean']  = 1,
    ['string']   = 2,
    ['integer']  = 3,
    ['number']   = 4,
    ['table']    = 5,
    ['function'] = 6,
    ['true']     = 101,
    ['false']    = 102,
}

local m = {}

local function mergeTable(a, b)
    if not b then
        return
    end
    for v in pairs(b) do
        a[v] = true
    end
end

local function isBaseType(source, mark)
    return m.hasType(source, 'number', mark)
        or m.hasType(source, 'integer', mark)
        or m.hasType(source, 'string', mark)
end

local function searchInferOfUnary(value, infers, mark)
    local op = value.op.type
    if op == 'not' then
        infers['boolean'] = true
        return
    end
    if op == '#' then
        if m.hasType(value[1], 'table', mark)
        or m.hasType(value[1], 'string', mark) then
            infers['integer'] = true
        end
        return
    end
    if op == '-' then
        if m.hasType(value[1], 'integer', mark) then
            infers['integer'] = true
        elseif isBaseType(value[1], mark) then
            infers['number'] = true
        end
        return
    end
    if op == '~' then
        if isBaseType(value[1], mark) then
            infers['integer'] = true
        end
        return
    end
end

local function searchInferOfBinary(value, infers, mark)
    local op = value.op.type
    if op == 'and' then
        if m.isTrue(value[1], mark) then
            mergeTable(infers, m.searchInfers(value[2], nil, mark))
        else
            mergeTable(infers, m.searchInfers(value[1], nil, mark))
        end
        return
    end
    if op == 'or' then
        if m.isTrue(value[1], mark) then
            mergeTable(infers, m.searchInfers(value[1], nil, mark))
        else
            mergeTable(infers, m.searchInfers(value[2], nil, mark))
        end
        return
    end
    -- must return boolean
    if op == '=='
    or op == '~='
    or op == '<'
    or op == '>'
    or op == '<='
    or op == '>=' then
        infers['boolean'] = true
        return
    end
    -- check number
    if op == '<<'
    or op == '>>'
    or op == '~'
    or op == '&'
    or op == '|' then
        if  isBaseType(value[1], mark)
        and isBaseType(value[2], mark) then
            infers['integer'] = true
        end
        return
    end
    if op == '..' then
        if  isBaseType(value[1], mark)
        and isBaseType(value[2], mark) then
            infers['string'] = true
        end
        return
    end
    if op == '^'
    or op == '/' then
        if  isBaseType(value[1], mark)
        and isBaseType(value[2], mark) then
            infers['number'] = true
        end
        return
    end
    if op == '+'
    or op == '-'
    or op == '*'
    or op == '%'
    or op == '//' then
        if  m.hasType(value[1], 'integer', mark)
        and m.hasType(value[2], 'integer', mark) then
            infers['integer'] = true
        elseif isBaseType(value[1], mark)
        and    isBaseType(value[2], mark) then
            infers['number'] = true
        end
        return
    end
end

local function searchInferOfValue(value, infers, mark)
    if value.type == 'string' then
        infers['string'] = true
        return true
    end
    if value.type == 'boolean' then
        infers['boolean'] = true
        return true
    end
    if value.type == 'table' then
        if value.array then
            local node = m.searchAndViewInfers(value.array, nil, mark)
            if node ~= 'any' then
                local infer = node .. '[]'
                infers[infer] = true
            end
        else
            infers['table'] = true
        end
        return true
    end
    if value.type == 'integer' then
        infers['integer'] = true
        return true
    end
    if value.type == 'number' then
        infers['number'] = true
        return true
    end
    if value.type == 'function' then
        infers['function'] = true
        return true
    end
    if value.type == 'unary' then
        searchInferOfUnary(value, infers, mark)
        return true
    end
    if value.type == 'binary' then
        searchInferOfBinary(value, infers, mark)
        return true
    end
    return false
end

local function searchLiteralOfValue(value, literals, mark)
    if value.type == 'string'
    or value.type == 'boolean'
    or value.type == 'number'
    or value.type == 'integer' then
        local v = value[1]
        if v ~= nil then
            literals[v] = true
        end
        return
    end
    if value.type == 'unary' then
        local op = value.op.type
        if op == '-' then
            local subLiterals = m.searchLiterals(value[1], nil, mark)
            if subLiterals then
                for subLiteral in pairs(subLiterals) do
                    local num = tonumber(subLiteral)
                    if num then
                        literals[-num] = true
                    end
                end
            end
        end
        if op == '~' then
            local subLiterals = m.searchLiterals(value[1], nil, mark)
            if subLiterals then
                for subLiteral in pairs(subLiterals) do
                    local num = math.tointeger(subLiteral)
                    if num then
                        literals[~num] = true
                    end
                end
            end
        end
    end
end

local function bindClassOrType(source)
    if not source.bindDocs then
        return false
    end
    for _, doc in ipairs(source.bindDocs) do
        if doc.type == 'doc.class'
        or doc.type == 'doc.type' then
            return true
        end
    end
    return false
end

local function cleanInfers(infers)
    local version = config.get 'Lua.runtime.version'
    local enableInteger = version == 'Lua 5.3' or version == 'Lua 5.4'
    infers['unknown'] = nil
    if infers['number'] then
        enableInteger = false
    end
    if not enableInteger and infers['integer'] then
        infers['integer'] = nil
        infers['number']  = true
    end
    -- stringlib 就是 string
    if infers['stringlib'] and infers['string'] then
        infers['stringlib'] = nil
    end
    --  如果有doc标记，则先移除table类型
    if infers[CLASS] then
        infers[CLASS] = nil
        infers['table'] = nil
    end
    -- 用doc标记的table，加入table类型
    if infers[TABLE] then
        infers[TABLE] = nil
        infers['table'] = true
    end
    if infers['function'] then
        for k in pairs(infers) do
            if k:sub(1, 4) == 'fun(' then
                infers[k] = nil
            end
        end
    end
end

---合并对象的推断类型
---@param infers string[]
---@return string
function m.viewInfers(infers)
    if infers[CACHE] then
        return infers[CACHE]
    end
    -- 如果有显性的 any ，则直接显示为 any
    if infers['any'] then
        infers[CACHE] = 'any'
        return 'any'
    end
    local result = {}
    local count = 0
    for infer in pairs(infers) do
        count = count + 1
        result[count] = infer
    end
    -- 如果没有任何显性类型，则推测为 unkonwn ，显示为 any
    if count == 0 then
        infers[CACHE] = 'any'
        return 'any'
    end
    table.sort(result, function (a, b)
        local sa = TypeSort[a] or 100
        local sb = TypeSort[b] or 100
        if sa == sb then
            return a < b
        else
            return sa < sb
        end
    end)
    local limit = config.get 'Lua.hover.enumsLimit'
    if limit < 0 then
        limit = 0
    end
    infers[CACHE] = table.concat(result, '|', 1, math.min(count, limit))
    if count > limit then
        infers[CACHE] = ('%s...(+%d)'):format(infers[CACHE], count - limit)
    end
    return infers[CACHE]
end

---合并对象的值
---@param literals string[]
---@return string
function m.viewLiterals(literals)
    local result = {}
    local count = 0
    for infer in pairs(literals) do
        count = count + 1
        result[count] = util.viewLiteral(infer)
    end
    if count == 0 then
        return nil
    end
    table.sort(result)
    local view = table.concat(result, '|')
    return view
end

function m.viewDocName(doc)
    if not doc then
        return nil
    end
    if doc.type == 'doc.type' then
        local list = {}
        for _, tp in ipairs(doc.types) do
            list[#list+1] = m.getDocName(tp)
        end
        for _, enum in ipairs(doc.enums) do
            list[#list+1] = m.getDocName(enum)
        end
        return table.concat(list, '|')
    end
    return m.getDocName(doc)
end

function m.getDocName(doc)
    if not doc then
        return nil
    end
    if doc.type == 'doc.class.name'
    or doc.type == 'doc.type.name' then
        local name = doc[1] or '?'
        if doc.typeGeneric then
            return '<' .. name .. '>'
        else
            return tostring(name)
        end
    end
    if doc.type == 'doc.type.array' then
        local nodeName = m.viewDocName(doc.node) or '?'
        return nodeName .. '[]'
    end
    if doc.type == 'doc.type.table' then
        local node  = m.viewDocName(doc.node)   or '?'
        local key   = m.viewDocName(doc.tkey)   or '?'
        local value = m.viewDocName(doc.tvalue) or '?'
        return ('%s<%s, %s>'):format(node, key, value)
    end
    if doc.type == 'doc.type.function' then
        return m.viewDocFunction(doc)
    end
    if doc.type == 'doc.type.enum'
    or doc.type == 'doc.resume' then
        local value = doc[1] or '?'
        return tostring(value)
    end
    if doc.type == 'doc.type.ltable' then
        return 'table'
    end
end

function m.viewDocFunction(doc)
    if doc.type ~= 'doc.type.function' then
        return ''
    end
    local args = {}
    for i, arg in ipairs(doc.args) do
        args[i] = ('%s: %s'):format(arg.name[1], arg.extends and m.viewDocName(arg.extends) or 'any')
    end
    local label = ('fun(%s)'):format(table.concat(args, ', '))
    if #doc.returns > 0 then
        local returns = {}
        for i, rtn in ipairs(doc.returns) do
            returns[i] = m.viewDocName(rtn)
        end
        label = ('%s:%s'):format(label, table.concat(returns, ', '))
    end
    return label
end

---显示对象的推断类型
---@param source parser.guide.object
---@param mark table
---@return string
local function searchInfer(source, infers, mark)
    if mark[source] then
        return
    end
    mark[source] = true
    if bindClassOrType(source) then
        return
    end
    if searchInferOfValue(source, infers, mark) then
        return
    end
    local value = searcher.getObjectValue(source)
    if value then
        if  value.type ~= 'function'
        and value.type ~= 'table'
        and value.type ~= 'nil' then
            searchInferOfValue(value, infers, mark)
        end
        return
    end
    -- check LuaDoc
    local docName = m.getDocName(source)
    if docName and docName ~= 'nil' and docName ~= 'unknown' then
        infers[docName] = true
        if not vm.isBuiltinType(docName) then
            infers[CLASS] = true
        end
        if docName == 'table' then
            infers[TABLE] = true
        end
    end
end

local function searchLiteral(source, literals, mark)
    if mark[source] then
        return
    end
    mark[source] = true
    searchLiteralOfValue(source, literals, mark)
    local value = searcher.getObjectValue(source)
    if value then
        if  value.type ~= 'function'
        and value.type ~= 'table' then
            searchLiteralOfValue(value, literals, mark)
        end
        return
    end
end

local function getCachedInfers(source, field)
    local inferCache = vm.getCache 'infers'
    local sourceCache = inferCache[source]
    if not sourceCache then
        sourceCache = {}
        inferCache[source] = sourceCache
    end
    if not field then
        field = ''
    end
    if sourceCache[field] then
        return true, sourceCache[field]
    end
    local infers = {}
    sourceCache[field] = infers
    return false, infers
end

---搜索对象的推断类型
---@param source parser.guide.object
---@param field? string
---@param mark? table
---@return string[]
function m.searchInfers(source, field, mark)
    if not source then
        return nil
    end
    if source.type == 'setlocal'
    or source.type == 'getlocal' then
        source = source.node
    end
    local suc, infers = getCachedInfers(source, field)
    if suc then
        return infers
    end
    local isParam = source.parent.type == 'funcargs'
    local defs = vm.getDefs(source, field)
    mark = mark or {}
    if not field then
        searchInfer(source, infers, mark)
    end
    for _, def in ipairs(defs) do
        if def.typeGeneric and not isParam then
            goto CONTINUE
        end
        if def.type == 'setlocal' then
            goto CONTINUE
        end
        searchInfer(def, infers, mark)
        ::CONTINUE::
    end
    if source.type == 'doc.type' then
        for _, def in ipairs(source.types) do
            if def.typeGeneric then
                searchInfer(def, infers, mark)
            end
        end
    end
    cleanInfers(infers)
    return infers
end

---搜索对象的字面量值
---@param source parser.guide.object
---@param field? string
---@param mark? table
---@return table
function m.searchLiterals(source, field, mark)
    local defs = vm.getDefs(source, field)
    local literals = {}
    mark = mark or {}
    if not field then
        searchLiteral(source, literals, mark)
    end
    for _, def in ipairs(defs) do
        searchLiteral(def, literals, mark)
    end
    return literals
end

---搜索并显示推断值
---@param source parser.guide.object
---@param field? string
---@return string
function m.searchAndViewLiterals(source, field, mark)
    if not source then
        return nil
    end
    local literals = m.searchLiterals(source, field, mark)
    local view = m.viewLiterals(literals)
    return view
end

---判断对象的推断值是否是 true
---@param source parser.guide.object
---@param mark? table
function m.isTrue(source, mark)
    if not source then
        return false
    end
    mark = mark or {}
    if not mark.isTrue then
        mark.isTrue = {}
    end
    if mark.isTrue[source] == nil then
        mark.isTrue[source] = false
        local literals = m.searchLiterals(source, nil, mark)
        for literal in pairs(literals) do
            if literal ~= false then
                mark.isTrue[source] = true
                break
            end
        end
    end
    return mark.isTrue[source]
end

---判断对象的推断类型是否包含某个类型
function m.hasType(source, tp, mark)
    mark = mark or {}
    local infers = m.searchInfers(source, nil, mark)
    if not infers then
        return false
    end
    if infers[tp] then
        return true
    end
    if tp == 'function' then
        for infer in pairs(infers) do
            if infer ~= CACHE and infer:sub(1, 4) == 'fun(' then
                return true
            end
        end
    end
    return false
end

---搜索并显示推断类型
---@param source parser.guide.object
---@param field? string
---@return string
function m.searchAndViewInfers(source, field, mark)
    if not source then
        return 'any'
    end
    local infers = m.searchInfers(source, field, mark)
    local view = m.viewInfers(infers)
    return view
end

---搜索并显示推断的class
---@param source parser.guide.object
---@return string?
function m.getClass(source)
    if not source then
        return nil
    end
    local infers = {}
    local defs = vm.getDefs(source)
    for _, def in ipairs(defs) do
        if def.type == 'doc.class.name' then
            if not vm.isBuiltinType(def[1]) then
                infers[def[1]] = true
            end
        end
    end
    cleanInfers(infers)
    local view = m.viewInfers(infers)
    if view == 'any' then
        return nil
    end
    return view
end

return m
