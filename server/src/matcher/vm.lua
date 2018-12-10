local env = require 'matcher.env'
local library = require 'matcher.library'

local DefaultSource = { start = 0, finish = 0 }

local mt = {}
mt.__index = mt

function mt:createLocal(key, source)
    local loc = {
        type = 'local',
        key = key,
        source = source or DefaultSource,
    }
    self.results.locals[#self.results.locals+1] = loc
    self.scope.locals[key] = loc
    return loc
end

function mt:createTable(source)
    local tbl = {
        type   = 'table',
        source = source or DefaultSource,
    }
    return tbl
end

function mt:setValue(var, value)
    assert(value.type ~= 'list')
    var.value = value
    return value
end

function mt:getValue(var)
    if not var.value then
        var.value = self:createNil()
    end
    return var.value
end

function mt:createField(pValue, name, source)
    local field = {
        type   = 'field',
        key    = name,
        source = source or DefaultSource,
    }
    self.results.fields[#self.results.fields+1] = field

    if not pValue.child then
        pValue.child = {}
    end
    pValue.child[name] = field

    return field
end

function mt:getField(pValue, name, source)
    local field =  (pValue.child and pValue.child[name])
                or self:createField(pValue, name, source)

    return field
end

function mt:createFunction(source)
    local func = {
        type   = 'function',
        source = source or DefaultSource,
    }
    return func
end

function mt:setFunctionReturn(index, value)
    local func = self.func.func
    if not func.returns then
        func.returns = {
            type = 'list',
        }
    end
    func.returns[index] = value
end

function mt:setFunctionArg(func, index, value)
    if not func.args then
        func.args = {}
    end
    func.args[index] = value
end

function mt:getFunctionReturns(func)
    if not func.returns then
        func.returns = {
            type = 'list',
            [1] = self:createNil(),
        }
    end
    return func.returns
end

function mt:createString(str, source)
    return {
        type   = 'string',
        source = source or DefaultSource,
        value  = str,
    }
end

function mt:createBoolean(bool, source)
    return {
        type   = 'boolean',
        source = source or DefaultSource,
        value  = bool or false,
    }
end

function mt:createNumber(num, source)
    return {
        type   = 'number',
        source = source or DefaultSource,
        value  = num or 0.0,
    }
end

function mt:createInteger(int, source)
    return {
        type   = 'integer',
        source = source or DefaultSource,
        value  = int or 0,
    }
end

function mt:createNil(source)
    return {
        type   = 'nil',
        source = source or DefaultSource,
    }
end

function mt:setLib(obj, lib)
    obj.lib = lib
    local tp = lib.type
    if not tp then
        return
    end
    if     tp == 'table' then
        self:setValue(obj, self:createTable())
    elseif tp == 'function' then
        self:setValue(obj, self:createFunction()) -- TODO
    elseif tp == 'string' then
        self:setValue(obj, self:createString(lib.value))
    elseif tp == 'boolean' then
        self:setValue(obj, self:createBoolean(lib.value))
    elseif tp == 'number' then
        self:setValue(obj, self:createNumber(lib.value))
    elseif tp == 'integer' then
        self:setValue(obj, self:createInteger(lib.value))
    end
end

function mt:call(func, args)
    for i, arg in ipairs(args) do
        self:setFunctionArg(func, i, self:getExp(arg))
    end
    return self:getFunctionReturns(func)
end

function mt:getName(name, source)
    local var = self.scope.locals[name]
             or self:getField(self.scope.locals._ENV, name, source)
    return var
end

function mt:getSimple(simple)
    local value = self:getExp(simple[1])
    local field
    for i = 2, #simple do
        local obj = simple[i]
        local tp  = obj.type

        if     tp == 'call' then
            -- 函数的返回值一定是list
            value = self:call(value, obj)
            if i < #simple then
                value = value[1]
            end
        elseif obj.index then
            if tp == 'name' then
                local var = self:getVar(obj[1])
                field = self:getField(value, self:getValue(var), obj)
            elseif (tp == 'string' or tp == 'number' or tp == 'boolean') then
                field = self:getField(value, obj[1], obj)
            else
                local eValue = self:getExp(obj)
                field = self:getField(value, eValue, obj)
            end
            value = self:getValue(field)
        else
            if tp == 'name' then
                field = self:getField(value, obj[1])
                value = self:getValue(field)
            elseif tp == ':' then
                if field then
                    field.oo = true
                end
            end
        end
    end
    return value, field
end

function mt:getBinary(exp)
    local v1 = self:getExp(exp[1])
    local v2 = self:getExp(exp[2])
    local op = exp.op
    -- TODO 搜索元方法
    if     op == 'or'
        or op == 'and'
        or op == '<='
        or op == '>='
        or op == '<'
        or op == '>'
        or op == '~='
        or op == '=='
    then
        return self:createBoolean()
    elseif op == '|'
        or op == '~'
        or op == '&'
        or op == '<<'
        or op == '>>'
        or op == '//'
    then
        return self:createInteger()
    elseif op == '..' then
        return self:createString()
    elseif op == '+'
        or op == '-'
        or op == '*'
        or op == '/'
        or op == '^'
        or op == '%'
    then
        return self:craeteNumber()
    end
    return nil
end

function mt:getUnary(exp)
    local v1 = self:getExp(exp[1])
    local op = exp.op
    -- TODO 搜索元方法
    if     op == 'not' then
        return self:createBoolean()
    elseif op == '#' then
        return self:createInteger()
    elseif op == '-' then
        return self:createNumber()
    elseif op == '~' then
        return self:createInteger()
    end
    return nil
end

function mt:getDots()
    return self.func.dots
end

function mt:getExp(exp)
    local tp = exp.type
    if     tp == 'nil' then
        return self:createNil(exp)
    elseif tp == 'string' then
        return self:createString(exp[1], exp)
    elseif tp == 'boolean' then
        return self:createBoolean(exp[1], exp)
    elseif tp == 'number' then
        return self:createNumber(exp[1], exp)
    elseif tp == 'name' then
        local var = self:getVar(exp[1], exp)
        return self:getValue(var)
    elseif tp == 'simple' then
        return self:getSimple(exp)
    elseif tp == 'binary' then
        return self:getBinary(exp)
    elseif tp == 'unary' then
        return self:getUnary(exp)
    elseif tp == '...' then
        return self:getDots(exp)
    end
    return nil
end

function mt:doDo(action)
    self.scope:push()
    self:doActions(action)
    self.scope:pop()
end

function mt:doReturn(action)
    for i, exp in ipairs(action) do
        local value = self:getExp(exp)
        self:setFunctionReturn(i, value)
    end
end

function mt:doAction(action)
    local tp = action.type
    if     tp == 'do' then
        self:doDo(action)
    elseif tp == 'break' then
    elseif tp == 'return' then
        self:doReturn(action)
    end
end

function mt:doActions(actions)
    for _, action in ipairs(actions) do
        self:doAction(action)
    end
end

function mt:createEnvironment()
    -- 整个文件是一个函数
    self.func.func = self:createFunction()
    -- 所有脚本都有个隐藏的上值`_ENV`
    local parent = self:createLocal('_ENV')
    local pValue = self:setValue(parent, self:createTable())
    -- 设置全局变量
    for name, info in pairs(library.global) do
        local field = self:createField(pValue, name)
        if info.lib then
            self:setLib(field, info.lib)
        end
        if info.child then
            local fValue = self:getValue(field)
            for fname, flib in pairs(info.child) do
                local ffield = self:createField(fValue, fname)
                self:setLib(ffield, flib)
            end
        end
    end
end

local function compile(ast)
    local vm = setmetatable({
        scope   = env {
            locals = {},
        },
        func    = env {
            labels = {},
        },
        results = {
            locals = {},
            fields = {},
            labels = {},
        }
    }, mt)

    -- 创建初始环境
    vm:createEnvironment()

    -- 执行代码
    vm:doActions(ast)

    return vm.results
end

return function (ast)
    if not ast then
        return nil
    end
    local suc, res = xpcall(compile, log.error, ast)
    if not suc then
        return nil
    end
    return res
end
