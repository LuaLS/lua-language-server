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
    self:addInfo(loc, 'local', source)
    return loc
end

function mt:addInfo(obj, type, source)
    if source and not source.start then
        error('Miss start')
    end
    obj[#obj+1] = {
        type = type,
        source = source or DefaultSource,
    }
    return obj
end

function mt:createDots(source)
    local dots = {
        type = 'dots',
        source = source or DefaultSource,
    }
    self.chunk.dots = dots
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

function mt:coverValue(target, source)
    for k in pairs(target) do
        target[k] = nil
    end
    for k, v in pairs(source) do
        target[k] = v
    end
end

function mt:setValue(var, value)
    assert(not value or value.type ~= 'list')
    if var.value then
        if var.value.type == 'nil' then
            -- 允许覆盖nil
            if value.type ~= 'nil' then
                self:coverValue(var.value, value)
            end
        end
    else
        var.value = value or self:createNil(var)
    end
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

function mt:createFunction(exp, object)
    local func = {
        type = 'function',
        returns = {
            type = 'list',
        },
        args = {},
    }

    if not exp then
        return func
    end

    self.scope:push()
    self.chunk:push()
    self.chunk:cut 'dots'
    self.chunk:cut 'labels'

    local stop
    self:forList(exp.arg, function (arg)
        if stop then
            return
        end
        if arg.type == 'name' then
            local var = self:createLocal(arg[1], arg)
            func.args[#func.args+1] = var
        elseif arg.type == '...' then
            local dots = self:createDots(arg)
            func.args[#func.args+1] = dots
            stop = true
        end
    end)
    if object then
        local var = self:createLocal('self', object.source)
        table.insert(func.args, 1, var)
    end

    self:doActions(exp)

    self.chunk.func = func
    self.results.funcs[#self.results.funcs+1] = func
    self.newFuncs[#self.newFuncs+1] = func

    self.chunk:pop()
    self.scope:pop()

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

    if not func.args then
        return self:getFunctionReturns(func)
    end

    for i, var in ipairs(func.args) do
        if var then
            if var.type == 'dots' then
                local list = {
                    type = 'list',
                }
                if values then
                    for n = i, #values do
                        list[n-i+1] = values[n]
                    end
                    self:setValue(var, list)
                else
                    self:setValue(var, nil)
                end
                break
            else
                if values then
                    self:setValue(var, values[i])
                else
                    self:setValue(var, nil)
                end
            end
        end
    end

    return self:getFunctionReturns(func)
end

function mt:getCurrentFunction()
    return self.chunk.func
end

function mt:setFunctionReturn(func, index, value)
    func.returns[index] = value or self:createNil()
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

function mt:createCustom(tp, source)
    return {
        type = tp,
        source = source or DefaultSource,
    }
end

function mt:getLibValue(lib)
    local tp = lib.type
    if not tp then
        return
    end
    local value
    if     tp == 'table' then
        value = self:createTable()
    elseif tp == 'function' then
        value = self:createFunction()
        if lib.returns then
            for i, rtn in ipairs(lib.returns) do
                self:setFunctionReturn(value, i, self:getLibValue(rtn))
            end
        end
        if lib.args then
            local values = {}
            for i, arg in ipairs(lib.args) do
                values[i] = self:getLibValue(arg) or self:createNil()
            end
            self:call(value, values)
        end
    elseif tp == 'string' then
        value = self:createString(lib.value)
    elseif tp == 'boolean' then
        value = self:createBoolean(lib.value)
    elseif tp == 'number' then
        value = self:createNumber(lib.value)
    elseif tp == 'integer' then
        value = self:createInteger(lib.value)
    elseif tp == 'nil' then
        value = self:createNil()
    else
        value = self:createCustom(tp)
    end
    return value
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
        self:addInfo(var, 'get', obj)
        return self:getValue(var)
    elseif (tp == 'string' or tp == 'number' or tp == 'boolean') then
        return obj[1]
    else
        return self:getExp(obj)
    end
end

function mt:unpackList(list)
    local res = {}
    if list.type == 'list' or list.type == 'call' then
        for i, exp in ipairs(list) do
            local value = self:getExp(exp)
            if value.type == 'list' then
                if i == #list then
                    for _, v in ipairs(value) do
                        res[#res+1] = v
                    end
                else
                    res[#res+1] = value[1]
                end
            else
                res[#res+1] = value
            end
        end
    else
        local value = self:getExp(list)
        if value.type == 'list' then
            for i, v in ipairs(value) do
                res[i] = v
            end
        else
            res[1] = value
        end
    end
    return res
end

function mt:getSimple(simple, mode)
    local value = self:getExp(simple[1])
    local field
    local object
    for i = 2, #simple do
        local obj = simple[i]
        local tp  = obj.type

        if     tp == 'call' then
            local args = self:unpackList(obj)
            if object then
                table.insert(args, 1, object)
            end
            -- 函数的返回值一定是list
            value = self:call(value, args)
            if i < #simple then
                value = value[1]
            end
        elseif obj.index then
            local index = self:getIndex(obj)
            field = self:getField(value, index, obj)
            if mode == 'value' or i < #simple then
                self:addInfo(field, 'get', obj)
            end
            value = self:getValue(field)
        else
            if tp == 'name' then
                field = self:getField(value, obj[1])
                if mode == 'value' or i < #simple then
                    self:addInfo(field, 'get', obj)
                end
                value = self:getValue(field)
            elseif tp == ':' then
                object = value
            end
        end
    end
    if mode == 'value' then
        return value, object
    elseif mode == 'field' then
        return field, object
    end
    error('Unknow simple mode: ' .. mode)
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
    if not self.chunk.dots then
        self:createDots()
    end
    return self.chunk.dots
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
        return self:getSimple(exp, 'value')
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
    error('Unkown exp type: ' .. tostring(tp))
end

function mt:doDo(action)
    self.scope:push()
    self:doActions(action)
    self.scope:pop()
end

function mt:doReturn(action)
    for i, exp in ipairs(action) do
        local value = self:getExp(exp)
        self:setFunctionReturn(self:getCurrentFunction(), i, value)
    end
end

function mt:createLabel(action)
    local name = action[1]
    if not self.chunk.labels[name] then
        local label = {
            type = 'label',
            key = name,
        }
        self.chunk.labels[name] = label
        self.results.labels[#self.results.labels+1] = label
    end
    return self.chunk.labels[name]
end

function mt:doSet(action)
    -- 要先计算值
    local values = self:unpackList(action[2])
    self:forList(action[1], function (key)
        local value = table.remove(values, 1)
        if key.type == 'name' then
            local var = self:getName(key[1], key)
            self:setValue(var, value)
            self:addInfo(var, 'set', key)
        elseif key.type == 'simple' then
            local field = self:getSimple(key, 'field')
            self:setValue(field, value)
            self:addInfo(field, 'set', key)
        end
    end)
end

function mt:doLocal(action)
    local values
    if action[2] then
        values = self:unpackList(action[2])
    end
    self:forList(action[1], function (key)
        local var = self:createLocal(key[1], key)
        if values then
            local value = table.remove(values, 1)
            self:setValue(var, value)
            self:addInfo(var, 'set', key)
        end
    end)
end

function mt:doIf(action)
    for _, block in ipairs(action) do
        self.scope:push()
        if block.filter then
            self:getExp(block.filter)
        end

        self:doActions(block)

        self.scope:pop()
    end
end

function mt:doLoop(action)
    self.scope:push()

    local min = self:getExp(action.min)
    self:getExp(action.max)
    if action.step then
        self:getExp(action.step)
    end

    local arg = self:createLocal(action.arg[1], action.arg)
    self:setValue(arg, min)
    self:addInfo(arg, 'set', action.arg)

    self:doActions(action)

    self.scope:pop()
end

function mt:doIn(action)
    self.scope:push()

    local func
    local list = {
        type = 'list'
    }
    if action.exp.type == 'list' then
        func = self:getExp(action.exp[1])
        for i = 2, #action.exp do
            list[i-1] = action.exp[i]
        end
    else
        func = self:getExp(action.exp)
    end
    local args = self:unpackList(list)
    local values = self:call(func, args)
    self:forList(action.arg, function (arg)
        local var = self:createLocal(arg[1], arg)
        self:setValue(var, table.remove(values, 1))
        self:addInfo(var, 'set', arg)
    end)

    self:doActions(action)

    self.scope:pop()
end

function mt:doWhile(action)
    self.scope:push()

    self:getExp(action.filter)

    self:doActions(action)

    self.scope:pop()
end

function mt:doRepeat(action)
    self.scope:push()

    self:doActions(action)
    self:getExp(action.filter)

    self.scope:pop()
end

function mt:doFunction(action)
    local name = action.name
    local var, object
    if name.type == 'simple' then
        var, object = self:getSimple(name, 'field')
    else
        var = self:getName(name[1], name)
    end
    local func = self:createFunction(action, object)
    self:setValue(var, func)
    self:addInfo(var, 'set', var.source)
end

function mt:doLocalFunction(action)
    local name = action.name
    local var = self:createLocal(name[1], name)
    local func = self:createFunction(action)
    self:setValue(var, func)
    self:addInfo(var, 'set', name)
end

function mt:doAction(action)
    local tp = action.type
    if     tp == 'do' then
        self:doDo(action)
    elseif tp == 'break' then
    elseif tp == 'return' then
        self:doReturn(action)
    elseif tp == 'label' then
        local label = self:createLabel(action)
        self:addInfo(label, 'set', action)
    elseif tp == 'goto' then
        local label = self:createLabel(action)
        self:addInfo(label, 'goto', action)
    elseif tp == 'set' then
        self:doSet(action)
    elseif tp == 'local' then
        self:doLocal(action)
    elseif tp == 'simple' then
        self:getSimple(action, 'value')
    elseif tp == 'if' then
        self:doIf(action)
    elseif tp == 'loop' then
        self:doLoop(action)
    elseif tp == 'in' then
        self:doIn(action)
    elseif tp == 'while' then
        self:doWhile(action)
    elseif tp == 'repeat' then
        self:doRepeat(action)
    elseif tp == 'function' then
        self:doFunction(action)
    elseif tp == 'localfunction' then
        self:doLocalFunction(action)
    end
end

function mt:doActions(actions)
    for _, action in ipairs(actions) do
        self:doAction(action)
    end
end

function mt:createEnvironment()
    -- 整个文件是一个函数
    self.chunk.func = self:createFunction()
    -- 隐藏的上值`_ENV`
    local parent = self:createLocal('_ENV')
    -- 隐藏的参数`...`
    self:createDots()

    local pValue = self:setValue(parent, self:createTable())
    -- 设置全局变量
    for name, info in pairs(library.global) do
        local field = self:createField(pValue, name)
        if info.lib then
            local value = self:getLibValue(info.lib)
            self:setValue(field, value)
            value.lib = info.lib
        end
        if info.child then
            local fValue = self:getValue(field)
            for fname, flib in pairs(info.child) do
                local ffield = self:createField(fValue, fname)
                local value = self:getLibValue(flib)
                self:setValue(ffield, value)
                value.lib = flib
            end
        end
    end
end

local function compile(ast)
    local vm = setmetatable({
        scope   = env {
            locals = {},
        },
        chunk   = env {
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
