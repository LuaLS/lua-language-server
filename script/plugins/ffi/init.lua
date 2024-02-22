local cdriver                = require 'plugins.ffi.c-parser.cdriver'
local util                   = require 'plugins.ffi.c-parser.util'
local utility                = require 'utility'
local SDBMHash               = require 'SDBMHash'
local config                 = require 'config'
local fs                     = require 'bee.filesystem'
local ws                     = require 'workspace'
local furi                   = require 'file-uri'

local namespace <const>      = 'ffi.namespace*.'

--TODO:supprot 32bit ffi, need config
local knownTypes             = {
    ["bool"] = 'boolean',
    ["char"] = 'integer',
    ["short"] = 'integer',
    ["int"] = 'integer',
    ["long"] = 'integer',
    ["float"] = 'number',
    ["double"] = 'number',
    ["signed"] = 'integer',
    ["__signed"] = 'integer',
    ["__signed__"] = 'integer',
    ["unsigned"] = 'integer',
    ["ptrdiff_t"] = 'integer',
    ["size_t"] = 'integer',
    ["ssize_t"] = 'integer',
    ["wchar_t"] = 'integer',
    ["int8_t"] = 'integer',
    ["int16_t"] = 'integer',
    ["int32_t"] = 'integer',
    ["int64_t"] = 'integer',
    ["uint8_t"] = 'integer',
    ["uint16_t"] = 'integer',
    ["uint32_t"] = 'integer',
    ["uint64_t"] = 'integer',
    ["intptr_t"] = 'integer',
    ["uintptr_t"] = 'integer',
    ["__int8"] = 'integer',
    ["__int16"] = 'integer',
    ["__int32"] = 'integer',
    ["__int64"] = 'integer',
    ["_Bool"] = 'boolean',
    ["__ptr32"] = 'integer',
    ["__ptr64"] = 'integer',
    --[[
    ["_Complex"] = 1,
    ["complex"] = 1,
    ["__complex"] = 1,
    ["__complex__"] = 1,
]]
    ["unsignedchar"] = 'integer',
    ["unsignedshort"] = 'integer',
    ["unsignedint"] = 'integer',
    ["unsignedlong"] = 'integer',
    ["signedchar"] = 'integer',
    ["signedshort"] = 'integer',
    ["signedint"] = 'integer',
    ["signedlong"] = 'integer',
}

local blackKeyWord <const>   = {
    ['and']      = "_and",
    ['do']       = "_do",
    ['elseif']   = "_elseif",
    ['end']      = "_end",
    ['false']    = "_false",
    ['function'] = "_function",
    ['in']       = "_in",
    ['local']    = "_local",
    ['nil']      = "_nil",
    ['not']      = "_not",
    ['or']       = "_or",
    ['repeat']   = "_repeat",
    ['then']     = "_then",
    ['true']     = "_true",
}

local invaildKeyWord <const> = {
    const = true,
    restrict = true,
    volatile = true,
}

local constName <const>      = 'm'

---@class ffi.builder
local builder                = { switch_ast = utility.switch() }

function builder:getTypeAst(name)
    for i, asts in ipairs(self.globalAsts) do
        if asts[name] then
            return asts[name]
        end
    end
end

function builder:needDeref(ast)
    if not ast then
        return false
    end
    if ast.type == 'typedef' then
        -- maybe no name
        ast = ast.def[1]
        if type(ast) ~= 'table' then
            return self:needDeref(self:getTypeAst(ast))
        end
    end
    if ast.type == 'struct' or ast.type == 'union' then
        return true
    else
        return false
    end
end

function builder:getType(name)
    if type(name) == 'table' then
        local t = ""
        local isStruct
        if name.type then
            t = t .. name.type .. "@"
            name = name.name
        end
        for _, n in ipairs(name) do
            if type(n) == 'table' then
                n = n.full_name
            end
            if invaildKeyWord[n] then
                goto continue
            end
            if not isStruct then
                isStruct = self:needDeref(self:getTypeAst(n))
            end
            t = t .. n
            ::continue::
        end
        -- deref 一级指针
        if isStruct and t:sub(#t) == '*' then
            t = t:sub(1, #t - 1)
        end
        name = t
    end
    if knownTypes[name] then
        return knownTypes[name]
    end
    return namespace .. name
end

function builder:isVoid(ast)
    if not ast then
        return false
    end
    if ast.type == 'typedef' then
        return self:isVoid(self:getTypeAst(ast.def[1]) or ast.def[1])
    end

    local typename = type(ast.type) == 'table' and ast.type[1] or ast
    if typename == 'void' then
        return true
    end
    return self:isVoid(self:getTypeAst(typename))
end

local function getArrayType(arr)
    if type(arr) ~= "table" then
        return arr and '[]' or ''
    end
    local res = ''
    for i, v in ipairs(arr) do
        res = res .. '[]'
    end
    return res
end

local function getValidName(name)
    return blackKeyWord[name] or name
end

function builder:buildStructOrUnion(lines, tt, name)
    lines[#lines+1] = '---@class ' .. self:getType(name)
    for _, field in ipairs(tt.fields or {}) do
        if field.name and field.type then
            lines[#lines+1] = ('---@field %s %s%s'):format(getValidName(field.name), self:getType(field.type),
                getArrayType(field.isarray))
        end
    end
end

function builder:buildFunction(lines, tt, name)
    local param_names = {}
    for i, param in ipairs(tt.params or {}) do
        local param_name = getValidName(param.name)
        lines[#lines+1] = ('---@param %s %s%s'):format(param_name, self:getType(param.type), getArrayType(param.idxs))
        param_names[#param_names+1] = param_name
    end
    if tt.vararg then
        param_names[#param_names+1] = '...'
    end
    if tt.ret then
        if not self:isVoid(tt.ret) then
            lines[#lines+1] = ('---@return %s'):format(self:getType(tt.ret.type))
        end
    end
    lines[#lines+1] = ('function m.%s(%s) end'):format(name, table.concat(param_names, ', '))
end

function builder:buildTypedef(lines, tt, name)
    local def = tt.def[1]
    if type(def) == 'table' and not def.name then
        -- 这个时候没有主类型，只有一个别名,直接创建一个别名结构体
        self.switch_ast(def.type, self, lines, def, name)
    else
        lines[#lines+1] = ('---@alias %s %s'):format(self:getType(name), self:getType(def))
    end
end

local calculate

local function binop(enumer, val, fn)
    local e1, e2 = calculate(enumer, val[1]), calculate(enumer, val[2])
    if type(e1) == "number" and type(e2) == "number" then
        return fn(e1, e2)
    else
        return { e1, e2, op = val.op }
    end
end
do
    local ops = {
        ['+'] = function (a, b) return a + b end,
        ['-'] = function (a, b) return a - b end,
        ['*'] = function (a, b) return a * b end,
        ['/'] = function (a, b) return a / b end,
        ['&'] = function (a, b) return a & b end,
        ['|'] = function (a, b) return a | b end,
        ['~'] = function (a, b)
            if not b then
                return ~a
            end
            return a ~ b
        end,
        ['<<'] = function (a, b) return a << b end,
        ['>>'] = function (a, b) return a >> b end,
    }
    calculate = function (enumer, val)
        if ops[val.op] then
            return binop(enumer, val, ops[val.op])
        end
        val = util.expandSingle(val)
        if type(val) == "string" then
            if enumer[val] then
                return enumer[val]
            end
            return tonumber(val)
        end
        return val
    end
end

local function pushEnumValue(enumer, name, v)
    v = tonumber(util.expandSingle(v))
    enumer[name] = v
    enumer[#enumer+1] = v
    return v
end

function builder:buildEnum(lines, tt, name)
    local enumer = {}
    for i, val in ipairs(tt.values) do
        local name = val.name
        local v = val.value
        if not v then
            if i == 1 then
                v = 0
            else
                v = tt.values[i - 1].realValue + 1
            end
        end
        if type(v) == 'table' and v.op then
            v = calculate(enumer, v)
        end
        if v then
            val.realValue = pushEnumValue(enumer, name, v)
        end
    end
    local alias = {}
    for k, v in pairs(enumer) do
        alias[#alias+1] = type(k) == 'number' and v or ([['%s']]):format(k)
        if type(k) ~= 'number' then
            lines[#lines+1] = ('m.%s = %s'):format(k, v)
        end
    end
    if name then
        lines[#lines+1] = ('---@alias %s %s'):format(self:getType(name), table.concat(alias, ' | '))
    end
end

builder.switch_ast
    :case 'struct'
    :case 'union'
    :call(builder.buildStructOrUnion)
    :case 'enum'
    :call(builder.buildEnum)
    : case 'function'
    :call(builder.buildFunction)
    :case 'typedef'
    :call(builder.buildTypedef)

local function stringStartsWith(self, searchString, position)
    if position == nil or position < 0 then
        position = 0
    end
    return string.sub(self, position + 1, #searchString + position) == searchString
end
local firstline = ('---@meta \n ---@class %s \n local %s = {}'):format(namespace, constName)
local m = {}
local function compileCode(lines, asts, b)
    for _, ast in ipairs(asts) do
        local tt = ast.type

        if tt.type == 'enum' and not stringStartsWith(ast.name, 'enum@') then
            goto continue
        end
        if not tt.name then
            if tt.type ~= 'enum' then
                goto continue
            end
            --匿名枚举也要创建具体的值
            lines = lines or { firstline }
            builder.switch_ast(tt.type, b, lines, tt)
        else
            tt.full_name = ast.name
            lines = lines or { firstline }
            builder.switch_ast(tt.type, b, lines, tt, tt.full_name)
            lines[#lines+1] = '\n'
        end
        ::continue::
    end
    return lines
end
function m.compileCodes(codes)
    ---@class ffi.builder
    local b = setmetatable({ globalAsts = {}, cacheEnums = {} }, { __index = builder })

    local lines
    for _, code in ipairs(codes) do
        local asts = cdriver.process_context(code)
        if not asts then
            goto continue
        end
        table.insert(b.globalAsts, asts)
        lines = compileCode(lines, asts, b)
        ::continue::
    end
    return lines
end

function m.build_single(codes, fileDir, uri)
    local texts = m.compileCodes(codes)
    if not texts then
        return
    end
    local fullPath = fileDir /ws.getRelativePath(uri)

    if fullPath:stem():string():find '%.' then
        local newPath = fullPath:parent_path() / (fullPath:stem():string():gsub('%.', '/') .. ".lua")
        fs.create_directories(newPath:parent_path())
        fullPath = newPath
    end

    utility.saveFile(tostring(fullPath), table.concat(texts, '\n'))
    return true
end

return m
