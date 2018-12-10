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

function mt:addInfo(obj, type, source)
    obj[#obj+1] = {
        type = type,
        source = source,
    }
    return obj
end

function mt:createDots(source)
    local dots = {
        type = 'dots',
        source = source or DefaultSource,
    }
    self.func.dots = dots
    return dots
end

function mt:createTable(source)
    local tbl = {
        type   = 'table',
        source = source or DefaultSource,
    }
    if not source then
        return tbl
    end
    local n = 0
    for _, obj in ipairs(source) do
        if obj.type == 'pair' then
            local value = self:getExp(obj[2])
            local key   = obj[1]
            if key.index then
                local index = self:getIndex(key)
                local field = self:createField(tbl, index, key)
                self:setValue(field, value)
            else
                if key.type == 'name' then
                    local index = key[1]
                    local field = self:createField(tbl, index, key)
                    self:setValue(field, value)
                end
            end
        else
            local value = self:getExp(obj)
            n = n + 1
            local field = self:createField(tbl, n)
            self:setValue(field, value)
        end
    end
    return tbl
end

function mt:setValue(var, value)
    assert(not value or value.type ~= 'list')
    var.value = value or self:createNil(var)
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

function mt:createFunction(exp)
    local func = {
        type = 'function',
        args = {},
        returns = {
            type = 'list',
        },
    }

    if exp then
        local stop
        self:forList(exp.args, function (arg)
            if stop then
                return
            end
            if arg.type == 'name' then
                func.args[#func.args+1] = self:createLocal(arg[1], arg)
            elseif arg.type == '...' then
                func.args[#func.args+1] = self:createDots(arg)
                stop = true
            end
        end)
    end

    self.func.func = func
    self.results.funcs[#self.results.funcs+1] = func
    self.newFuncs[#self.newFuncs+1] = func
    return func
end

function mt:forList(list, callback)
    if not list then
        return
    end
    if list.type == 'list' then
        for i = 1, #list do
            callback(list[i])
        end
    else
        callback(list)
    end
end

function mt:call(func, values)
    if func.used then
        return self:getFunctionReturns(func)
    end
    func.used = true
    self.func:push()
    self.scope:push()
    self.func:cut 'labels'
    self.func:cut 'dots'

    for i = 1, #func.args do
        local var = func.arg[i]
        if var then
            if var.type == 'dots' then
                local list = {
                    type = 'list',
                }
                for n = i, #values do
                    list[n-i+1] = values[n]
                end
                self:setValue(var, list)
                break
            else
                self:setValue(var, values[i])
            end
        end
    end

    self:doActions(func)

    self.func:pop()
    self.scope:pop()
    return self:getFunctionReturns(func)
end

function mt:getCurrentFunction()
    return self.func.func
end

function mt:setFunctionReturn(index, value)
    local func = self:getCurrentFunction()
    func.returns[index] = value
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

function mt:getName(name, source)
    local var = self.scope.locals[name]
             or self:getField(self.scope.locals._ENV, name, source)
    return var
end

function mt:getIndex(obj)
    local tp = obj.type
    if tp == 'name' then
        local var = self:getName(obj[1])
        return self:getValue(var)
    elseif (tp == 'string' or tp == 'number' or tp == 'boolean') then
        return obj[1]
    else
        return self:getExp(obj)
    end
end

function mt:getSimple(simple)
    local value = self:getExp(simple[1])
    local field
    local object
    for i = 2, #simple do
        local obj = simple[i]
        local tp  = obj.type

        if     tp == 'call' then
            local args = {}
            if object then
                args[1] = object
            end
            for _, arg in ipairs(obj) do
                args[#args+1] = self:getExp(arg)
            end
            -- 函数的返回值一定是list
            value = self:call(value, args)
            if i < #simple then
                value = value[1]
            end
        elseif obj.index then
            local index = self:getIndex(obj)
            field = self:getField(value, index, obj)
            value = self:getValue(field)
        else
            if tp == 'name' then
                field = self:getField(value, obj[1])
                value = self:getValue(field)
            elseif tp == ':' then
                object = value
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
        return self:createNumber()
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
    if not self.func.dots then
        self:createDots()
    end
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
        local var = self:getName(exp[1], exp)
        self:addInfo(var, 'get', exp)
        return self:getValue(var)
    elseif tp == 'simple' then
        return self:getSimple(exp)
    elseif tp == 'binary' then
        return self:getBinary(exp)
    elseif tp == 'unary' then
        return self:getUnary(exp)
    elseif tp == '...' then
        local var = self:getDots()
        self:addInfo(var, 'get', exp)
        return self:getValue(var)
    elseif tp == 'function' then
        return self:createFunction(exp)
    elseif tp == 'table' then
        return self:createTable(exp)
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

function mt:createLabel(action)
    local name = action[1]
    if not self.func.labels[name] then
        local label = {
            type = 'label',
            key = name,
        }
        self.func.labels[name] = label
        self.results.labels[#self.results.labels+1] = label
    end
    self:addInfo(self.func.labels[name], 'set', action)
end

function mt:doAction(action)
    local tp = action.type
    if     tp == 'do' then
        self:doDo(action)
    elseif tp == 'break' then
    elseif tp == 'return' then
        self:doReturn(action)
    elseif tp == 'label' then
        self:createLabel(action)
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
    -- 隐藏的上值`_ENV`
    local parent = self:createLocal('_ENV')
    -- 隐藏的参数`...`
    self:createDots()

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
            funcs  = {},
        },
        newFuncs = {},
    }, mt)

    -- 创建初始环境
    vm:createEnvironment()

    -- 执行代码
    vm:doActions(ast)

    -- 把所有没跑过的函数跑一遍（可能会创建新的函数，需要一直跑到没有新的函数为止）
    while true do
        local func = table.remove(vm.newFuncs, 1)
        if not func then
            break
        end
        vm:call(func)
    end

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
