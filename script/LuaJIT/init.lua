local files             = require 'files'
local searchCode        = require 'LuaJIT.searchCode'
local cdefRerence       = require 'LuaJIT.cdefRerence'
local cdriver           = require 'LuaJIT.c-parser.cdriver'
local util              = require 'utility'

local namespace <const> = 'ffi.namespace*.'

--TODO:supprot 32bit ffi, need config
local knownTypes        = {
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

local constName <const> = 'm'

---@class ffi.builder
local builder           = { switch_ast = util.switch() }

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
        for _, n in ipairs(name) do
            if type(n) == 'table' then
                n = n.name
            end
            if not isStruct then
                isStruct = self:needDeref(self:getTypeAst(n))
            end
            t = t .. n
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

function builder:buildStructOrUnion(lines, ast, tt, name)
    lines[#lines+1] = '---@class ' .. self:getType(name)
    for _, field in ipairs(tt.fields or {}) do
        if field.name and field.type then
            lines[#lines+1] = ('---@field %s %s'):format(field.name, self:getType(field.type))
        end
    end
end

function builder:buildFunction(lines, ast, tt, name)
    local param_names = {}
    for i, param in ipairs(tt.params or {}) do
        lines[#lines+1] = ('---@param %s %s'):format(param.name, self:getType(param.type))
        param_names[#param_names+1] = param.name
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

function builder:buildTypedef(lines, ast, tt, name)
    local def = tt.def[1]
    if type(def) == 'table' and not def.name then
        -- 这个时候没有主类型，只有一个别名,直接创建一个别名结构体
        self.switch_ast(def.type, self, lines, def, def, name)
    else
        lines[#lines+1] = ('---@alias %s %s'):format(name, self:getType(def))
    end
end

function builder:buildEnum(lines, ast, tt, name)
    --TODO
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


local firstline = ('---@meta \n ---@class %s \n local %s = {}'):format(namespace, constName)
local m = {}
function m.compileCodes(codes)
    ---@class ffi.builder
    local b = setmetatable({ globalAsts = {} }, { __index = builder })

    local lines
    for _, code in ipairs(codes) do
        local asts = cdriver.process_context(code)
        if not asts then
            goto continue
        end
        lines = lines or { firstline }
        table.insert(b.globalAsts, asts)
        for _, ast in ipairs(asts) do
            local tt = ast.type
            if tt.name then
                tt.name = ast.name
                builder.switch_ast(tt.type, b, lines, ast, tt, tt.name)
                lines[#lines+1] = '\n'
            end
        end
        ::continue::
    end
    return lines
end

---@async
files.watch(function (ev, uri)
    if ev == 'compile' then
        local refs = cdefRerence()
        if not refs or #refs == 0 then
            return
        end

        local codes = searchCode(refs, uri)
        if not codes then
            return
        end
        local res = m.compileCodes(codes)
    end
end)

return m
