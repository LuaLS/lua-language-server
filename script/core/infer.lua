local searcher = require 'core.searcher'
local config   = require 'config'

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
    or value.tyoe == 'number'
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
        end
        if op == '~' then
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
    if infers['number'] then
        enableInteger = false
    end
    if not enableInteger and infers['integer'] then
        infers['integer'] = nil
        infers['number']  = true
    end
end

---合并对象的推断类型
---@param infers string[]
---@return string
function m.viewInfers(infers)
    -- 如果有显性的 any ，则直接显示为 any
    if infers['any'] then
        return 'any'
    end
    local count = 0
    for infer in pairs(infers) do
        count = count + 1
        infers[count] = infer
    end
    for i = count + 1, #infers do
        infers[i] = nil
    end
    -- 如果没有任何显性类型，则推测为 unkonwn ，显示为 any
    if count == 0 then
        return 'any'
    end
    table.sort(infers)
    return table.concat(infers, '|', 1, count)
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
    if source.type == 'doc.class.name' then
        local name = source[1]
        if name then
            infers[name] = true
        end
        return
    end
    -- X.a -> table
    if source.next and source.next.node == source then
        if source.next.type == 'setfield'
        or source.next.type == 'setindex'
        or source.next.type == 'setmethod' then
            infers['table'] = true
        end
        return
    end
    -- return XX
    if source.parent.type == 'return' then
        infers['any'] = true
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
---@return string[]
function m.searchInfers(source)
    if not source then
        return nil
    end
    local defs = searcher.requestDefinition(source)
    local infers = {}
    searchInfer(source, infers)
    for _, def in ipairs(defs) do
        searchInfer(def, infers)
    end
    cleanInfers(infers)
    return infers
end

---搜索对象的字面量值
---@param source parser.guide.object
---@return table
function m.searchLiterals(source)
    local defs = searcher.requestDefinition(source)
    local literals = {}
    searchLiteral(source, literals)
    for _, def in ipairs(defs) do
        searchLiteral(def, literals)
    end
    return literals
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
    return infers[tp]
end

---搜索并显示推断类型
---@param source parser.guide.object
---@return string
function m.searchAndViewInfers(source)
    if not source then
        return 'any'
    end
    local infers = m.searchInfers(source)
    local view = m.viewInfers(infers)
    return view
end

return m
