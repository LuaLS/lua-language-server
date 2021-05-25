local searcher = require 'core.searcher'
local config   = require 'config'
local noder    = require 'core.noder'
local util     = require 'utility'

local STRING_OR_TABLE = {'STRING_OR_TABLE'}
local BE_RETURN       = {'BE_RETURN'}
local BE_CONNACT      = {'BE_CONNACT'}
local CLASS           = {'CLASS'}
local TABLE           = {'TABLE'}

local TypeSort = {
    ['boolean']  = 1,
    ['string']   = 2,
    ['integer']  = 3,
    ['number']   = 4,
    ['table']    = 5,
    ['function'] = 6,
    ['true']     = 101,
    ['false']    = 102,
    ['nil']      = 999,
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

local function searchInferOfUnary(value, infers)
    local op = value.op.type
    if op == 'not' then
        infers['boolean'] = true
        return
    end
    if op == '#' then
        infers['integer'] = true
        return
    end
    if op == '-' then
        if m.hasType(value[1], 'integer') then
            infers['integer'] = true
        else
            infers['number'] = true
        end
        return
    end
    if op == '~' then
        infers['integer'] = true
        return
    end
end

local function searchInferOfBinary(value, infers)
    local op = value.op.type
    if op == 'and' then
        if m.isTrue(value[1]) then
            mergeTable(infers, m.searchInfers(value[2]))
        else
            mergeTable(infers, m.searchInfers(value[1]))
        end
        return
    end
    if op == 'or' then
        if m.isTrue(value[1]) then
            mergeTable(infers, m.searchInfers(value[1]))
        else
            mergeTable(infers, m.searchInfers(value[2]))
        end
        return
    end
    if op == '=='
    or op == '~='
    or op == '<'
    or op == '>'
    or op == '<='
    or op == '>=' then
        infers['boolean'] = true
        return
    end
    if op == '<<'
    or op == '>>'
    or op == '~'
    or op == '&'
    or op == '|' then
        infers['integer'] = true
        return
    end
    if op == '..' then
        infers['string'] = true
        return
    end
    if op == '^'
    or op == '/' then
        infers['number'] = true
        return
    end
    if op == '+'
    or op == '-'
    or op == '*'
    or op == '%'
    or op == '//' then
        if  m.hasType(value[1], 'integer')
        and m.hasType(value[2], 'integer') then
            infers['integer'] = true
        else
            infers['number'] = true
        end
        return
    end
end

local function searchInferOfValue(value, infers)
    if value.type == 'string' then
        infers['string'] = true
        return true
    end
    if value.type == 'boolean' then
        infers['boolean'] = true
        return true
    end
    if value.type == 'table' then
        infers['table'] = true
        return true
    end
    if value.type == 'number' then
        if math.type(value[1]) == 'integer' then
            infers['integer'] = true
        else
            infers['number'] = true
        end
        return true
    end
    if value.type == 'nil' then
        infers['nil'] = true
        return true
    end
    if value.type == 'function' then
        infers['function'] = true
        return true
    end
    if value.type == 'unary' then
        searchInferOfUnary(value, infers)
        return true
    end
    if value.type == 'binary' then
        searchInferOfBinary(value, infers)
        return true
    end
    return false
end

local function searchLiteralOfValue(value, literals)
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
            local subLiterals = m.searchLiterals(value[1])
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
            local subLiterals = m.searchLiterals(value[1])
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
    return
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
    local version = config.config.runtime.version
    local enableInteger = version == 'Lua 5.3' or version == 'Lua 5.4'
    if infers['any'] and infers['nil'] then
        infers['nil'] = nil
    end
    if infers['number'] then
        enableInteger = false
    end
    if not enableInteger and infers['integer'] then
        infers['integer'] = nil
        infers['number']  = true
    end
    -- stringlib 就是 string
    if infers['stringlib'] then
        infers['stringlib'] = nil
        infers['string'] = true
    end
    -- 如果是通过 .. 来推测的，且结果里没有 number 与 integer，则推测为string
    if infers[BE_CONNACT] then
        infers[BE_CONNACT] = nil
        if not infers['number'] and not infers['integer'] then
            infers['string'] = true
        end
    end
    -- 如果是通过 # 来推测的，且结果里没有其他的 table 与 string，则加入这2个类型
    if infers[STRING_OR_TABLE] then
        infers[STRING_OR_TABLE] = nil
        if not infers['table'] and not infers['string'] then
            infers['table']  = true
            infers['string'] = true
        end
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
    if infers[BE_RETURN] then
        infers[BE_RETURN] = nil
        infers['nil'] = nil
    end
    infers['any'] = nil
end

---合并对象的推断类型
---@param infers string[]
---@return string
function m.viewInfers(infers)
    if infers[0] then
        return infers[0]
    end
    -- 如果有显性的 any ，则直接显示为 any
    if infers['any'] then
        infers[0] = 'any'
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
        infers[0] = 'any'
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
    infers[0] = table.concat(result, '|')
    return infers[0]
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

local function getDocName(doc)
    if not doc then
        return nil
    end
    if doc.type == 'doc.type' then
        local list = {}
        for _, tp in ipairs(doc.types) do
            list[#list+1] = getDocName(tp)
        end
        for _, enum in ipairs(doc.enums) do
            list[#list+1] = getDocName(enum)
        end
        return table.concat(list, '|')
    end
    if doc.type == 'doc.class.name'
    or doc.type == 'doc.type.name' then
        local name = doc[1] or '?'
        return name
    end
    if doc.type == 'doc.type.array' then
        local nodeName = getDocName(doc.node) or '?'
        return nodeName .. '[]'
    end
    if doc.type == 'doc.type.table' then
        local key = getDocName(doc.tkey) or '?'
        local value = getDocName(doc.tvalue) or '?'
        return ('table<%s, %s>'):format(key, value)
    end
    if doc.type == 'doc.type.function' then
        return 'function'
    end
    if doc.type == 'doc.type.enum'
    or doc.type == 'doc.resume' then
        local value = doc[1] or '?'
        return value
    end
end

---显示对象的推断类型
---@param source parser.guide.object
---@return string
local function searchInfer(source, infers)
    if bindClassOrType(source) then
        return
    end
    if searchInferOfValue(source, infers) then
        return
    end
    local value = searcher.getObjectValue(source)
    if value then
        searchInferOfValue(value, infers)
        return
    end
    -- check LuaDoc
    local docName = getDocName(source)
    if docName then
        infers[docName] = true
        infers[CLASS]   = true
        if docName == 'table' then
            infers[TABLE] = true
        end
    end
    if source.parent.type == 'unary' then
        local op = source.parent.op.type
        -- # XX -> string | table
        if op == '#' then
            infers[STRING_OR_TABLE] = true
            return
        end
        if op == '-' then
            infers['number'] = true
            return
        end
        if op == '~' then
            infers['integer'] = true
            return
        end
        return
    end
    if source.parent.type == 'binary' then
        local op = source.parent.op.type
        if op == '+'
        or op == '-'
        or op == '*'
        or op == '/'
        or op == '//'
        or op == '^'
        or op == '%' then
            infers['number'] = true
            return
        end
        if op == '<<'
        or op == '>>'
        or op == '~'
        or op == '|'
        or op == '&' then
            infers['integer'] = true
            return
        end
        if op == '..' then
            infers[BE_CONNACT] = true
            return
        end
    end
    -- X.a -> table
    if source.next and source.next.node == source then
        if source.next.type == 'setfield'
        or source.next.type == 'setindex'
        or source.next.type == 'setmethod'
        or source.next.type == 'getfield'
        or source.next.type == 'getindex' then
            infers['table'] = true
        end
        if source.next.type == 'getmethod' then
            infers[STRING_OR_TABLE] = true
        end
    end
    -- return XX
    if source.parent.type == 'return' then
        infers[BE_RETURN] = true
    end
end

local function searchLiteral(source, literals)
    local value = searcher.getObjectValue(source)
    if value then
        searchLiteralOfValue(value, literals)
        return
    end
end

---搜索对象的推断类型
---@param source parser.guide.object
---@param field? string
---@return string[]
function m.searchInfers(source, field)
    if not source then
        return nil
    end
    local defs = searcher.requestDefinition(source, field)
    local infers = {}
    local mark = {}
    mark[source] = true
    searchInfer(source, infers)
    if source.type == 'field' or source.type == 'method' then
        mark[source.parent] = true
        searchInfer(source.parent, infers)
    end
    for _, def in ipairs(defs) do
        if not mark[def] then
            mark[def] = true
            searchInfer(def, infers)
        end
    end
    local id = noder.getID(source)
    if id then
        local node = noder.getNodeByID(source, id)
        if node and node.sources then
            for _, src in ipairs(node.sources) do
                if not mark[src] then
                    mark[src] = true
                    searchInfer(src, infers)
                end
            end
        end
    end
    cleanInfers(infers)
    return infers
end

---搜索对象的字面量值
---@param source parser.guide.object
---@param field? string
---@return table
function m.searchLiterals(source, field)
    local defs = searcher.requestDefinition(source, field)
    local literals = {}
    local mark = {}
    mark[source] = true
    searchLiteral(source, literals)
    for _, def in ipairs(defs) do
        if not mark[def] then
            mark[def] = true
            searchLiteral(def, literals)
        end
    end
    return literals
end

---搜索并显示推断值
---@param source parser.guide.object
---@param field? string
---@return string
function m.searchAndViewLiterals(source, field)
    if not source then
        return nil
    end
    local literals = m.searchLiterals(source, field)
    local view = m.viewLiterals(literals)
    return view
end

---判断对象的推断值是否是 true
---@param source parser.guide.object
function m.isTrue(source)
    if not source then
        return false
    end
    local literals = m.searchLiterals(source)
    for literal in pairs(literals) do
        if literal ~= false then
            return true
        end
    end
    return false
end

---判断对象的推断类型是否包含某个类型
function m.hasType(source, tp)
    local infers = m.searchInfers(source)
    return infers[tp] or false
end

---搜索并显示推断类型
---@param source parser.guide.object
---@param field? string
---@return string
function m.searchAndViewInfers(source, field)
    if not source then
        return 'any'
    end
    local infers = m.searchInfers(source, field)
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
    local defs = searcher.requestDefinition(source)
    for _, def in ipairs(defs) do
        if def.type == 'doc.class.name' then
            infers[def[1]] = true
        end
    end
    local view = m.viewInfers(infers)
    if view == 'any' then
        return nil
    end
    return view
end

return m
