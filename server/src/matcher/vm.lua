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
    self.scope.locals[key] = loc
    self.results.locals[#self.results.locals+1] = loc

    local value = self:createValue('nil', source)
    self:setValue(loc, value)
    self:addInfo(loc, 'local', source)
    return loc
end

function mt:addInfo(obj, type, source)
    if source and not source.start then
        error('Miss start: ' .. table.dump(source))
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

function mt:buildTable(source)
    local tbl = self:createValue('table', source)
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
                if value.type == 'list' then
                    self:setValue(field, value[1])
                    self:addInfo(field, 'set', key)
                else
                    self:setValue(field, value)
                    self:addInfo(field, 'set', key)
                end
            else
                if key.type == 'name' then
                    local index = key[1]
                    local field = self:createField(tbl, index, key)
                    if value.type == 'list' then
                        self:setValue(field, value[1])
                        self:addInfo(field, 'set', key)
                    else
                        self:setValue(field, value)
                        self:addInfo(field, 'set', key)
                    end
                end
            end
        else
            local value = self:getExp(obj)
            if value.type == 'list' then
                for i, v in ipairs(value) do
                    local field = self:createField(tbl, n + i)
                    self:setValue(field, v)
                end
                break
            else
                n = n + 1
                local field = self:createField(tbl, n)
                self:setValue(field, value)
            end
        end
    end
    return tbl
end

function mt:coverValue(target, source)
    local child = target.child
    for k in pairs(target) do
        target[k] = nil
    end
    for k, v in pairs(source) do
        target[k] = v
    end
    if child then
        if not target.child then
            target.child = {}
        end
        for k, v in pairs(child) do
            if target.child[k] == nil then
                target.child[k] = v
            end
        end
    end
end

function mt:setValue(var, value)
    assert(not value or value.type ~= 'list')
    value = value or self:createValue('nil', var)
    if var.value then
        if var.value.type == 'nil' then
            -- 允许覆盖nil
            if value.type ~= 'nil' then
                self:coverValue(var.value, value)
            end
        end
        value = var.value
    else
        var.value = value
    end
    return value
end

function mt:getValue(var)
    if not var.value then
        var.value = self:createValue('nil')
    end
    return var.value
end

function mt:createField(pValue, name, source)
    assert(pValue.type ~= 'local' and pValue.type ~= 'field')
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

function mt:buildFunction(exp, object)
    local func = self:createValue('function')
    func.returns = {
        type = 'list',
    }
    func.args = {}

    if not exp then
        return func
    end

    self.scope:push()
    self.chunk:push()
    self.chunk:cut 'dots'
    self.chunk:cut 'labels'

    if object then
        local var = self:createLocal('self', object.source)
        self:setValue(var, self:getValue(object))
        func.args[1] = var
    end

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

    self:doActions(exp)

    self.chunk.func = func
    self.results.funcs[#self.results.funcs+1] = func

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

function mt:setFunctionArgs(func, values)
    if not func.args then
        return
    end

    for i, var in ipairs(func.args) do
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

function mt:callSetMetaTable(values)
    values[1].metatable = values[2]
    self:setFunctionReturn(self:getCurrentFunction(), 1, values[1])
    self.metas[#self.metas+1] = values[1]
end

function mt:call(func, values)
    local lib = func.lib
    if lib and lib.special then
        if lib.special == 'setmetatable' then
            self:callSetMetaTable(values)
        end
    end

    self:setFunctionArgs(func, values)

    return self:getFunctionReturns(func)
end

function mt:getCurrentFunction()
    return self.chunk.func
end

function mt:setFunctionReturn(func, index, value)
    func.returns[index] = value or self:createValue('nil')
end

function mt:getFunctionReturns(func)
    if not func.returns then
        func.returns = {
            type = 'list',
            [1] = self:createValue('nil'),
        }
    end
    return func.returns
end

function mt:createValue(type, source, v)
    local value = {
        type = type,
        source = source or DefaultSource,
        value = v,
    }
    return value
end

function mt:getLibValue(lib)
    local tp = lib.type
    if not tp then
        return
    end
    local value
    if     tp == 'table' then
        value = self:buildTable()
    elseif tp == 'function' then
        value = self:buildFunction()
        if lib.returns then
            for i, rtn in ipairs(lib.returns) do
                self:setFunctionReturn(value, i, self:getLibValue(rtn))
            end
        end
        if lib.args then
            local values = {}
            for i, arg in ipairs(lib.args) do
                values[i] = self:getLibValue(arg) or self:createValue('nil')
            end
            self:setFunctionArgs(value, values)
        end
    elseif tp == 'string' then
        value = self:createValue('string', nil, lib.value)
    elseif tp == 'boolean' then
        value = self:createValue('boolean', nil, lib.value)
    elseif tp == 'number' then
        value = self:createValue('number', nil, lib.value)
    elseif tp == 'integer' then
        value = self:createValue('integer', nil, lib.value)
    elseif tp == 'nil' then
        value = self:createValue('nil')
    else
        value = self:createValue(tp)
    end
    return value
end

function mt:getName(name, source)
    local var = self.scope.locals[name]
             or self:getField(self:getValue(self.scope.locals._ENV), name, source)
    return var
end

function mt:getIndex(obj)
    local tp = obj.type
    if tp == 'name' then
        local var = self:getName(obj[1])
        local value = self:getValue(var)
        self:addInfo(var, 'get', obj)
        return value
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
    if simple[1].type == 'name' then
        field = self:getName(simple[1][1])
    else
        field = self:createValue('nil', simple[1])
    end
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
                value = value[1] or self:createValue('nil')
            end
        elseif obj.index then
            local index = self:getIndex(obj)
            field = self:getField(value, index, obj)
            value = self:getValue(field)
            if mode == 'value' or i < #simple then
                if obj.start then
                    self:addInfo(field, 'get', obj)
                end
            end
        else
            if tp == 'name' then
                field = self:getField(value, obj[1], obj)
                value = self:getValue(field)
                if mode == 'value' or i < #simple then
                    self:addInfo(field, 'get', obj)
                end
            elseif tp == ':' then
                object = field
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
        return self:createValue('boolean')
    elseif op == '|'
        or op == '~'
        or op == '&'
        or op == '<<'
        or op == '>>'
        or op == '//'
    then
        return self:createValue('integer')
    elseif op == '..' then
        return self:createValue('string')
    elseif op == '+'
        or op == '-'
        or op == '*'
        or op == '/'
        or op == '^'
        or op == '%'
    then
        return self:createValue('number')
    end
    return nil
end

function mt:getUnary(exp)
    local v1 = self:getExp(exp[1])
    local op = exp.op
    -- TODO 搜索元方法
    if     op == 'not' then
        return self:createValue('boolean')
    elseif op == '#' then
        return self:createValue('integer')
    elseif op == '-' then
        return self:createValue('number')
    elseif op == '~' then
        return self:createValue('integer')
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
        return self:createValue('nil', exp)
    elseif tp == 'string' then
        return self:createValue('string', exp, exp[1])
    elseif tp == 'boolean' then
        return self:createValue('boolean', exp, exp[1])
    elseif tp == 'number' then
        return self:createValue('number', exp, exp[1])
    elseif tp == 'name' then
        local var = self:getName(exp[1], exp)
        local value = self:getValue(var)
        self:addInfo(var, 'get', exp)
        return value
    elseif tp == 'simple' then
        return self:getSimple(exp, 'value')
    elseif tp == 'binary' then
        return self:getBinary(exp)
    elseif tp == 'unary' then
        return self:getUnary(exp)
    elseif tp == '...' then
        -- TODO 传递不定参数
        local var = self:getDots()
        local value = self:getValue(var)
        self:addInfo(var, 'get', exp)
        return value
    elseif tp == 'function' then
        return self:buildFunction(exp)
    elseif tp == 'table' then
        return self:buildTable(exp)
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
    if not action[2] then
        return
    end
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
            local source = key[#key]
            if source.start then
                self:addInfo(field, 'set', source)
            end
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
            self:setValue(var, table.remove(values, 1))
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
    local source
    if name.type == 'simple' then
        var, object = self:getSimple(name, 'field')
        source = name[#name]
    else
        var = self:getName(name[1], name)
        source = name
    end
    local func = self:buildFunction(action, object)
    self:setValue(var, func)
    if source.start then
        self:addInfo(var, 'set', source)
    end
end

function mt:doLocalFunction(action)
    local name = action.name
    local var = self:createLocal(name[1], name)
    local func = self:buildFunction(action)
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
    self.chunk.func = self:buildFunction()
    -- 隐藏的上值`_ENV`
    local parent = self:createLocal('_ENV')
    -- 隐藏的参数`...`
    self:createDots()

    local pValue = self:setValue(parent, self:buildTable())
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

function mt:mergeChild(a, b)
    if not a.child and not b.child then
        return
    end
    local child = a.child or {}
    a.child = nil
    b.child = nil
    for k, v in pairs(b.child or {}) do
        if child[k] then
            self:coverValue(v, child[k])
        else
            child[k] = v
        end
    end
    a.child = child
    b.child = child
end

function mt:checkMetaIndex(value, meta)
    local index = self:getField(meta, '__index')
    if not index then
        return
    end
    local indexValue = self:getValue(index)
    -- TODO 支持function
    self:mergeChild(value, indexValue)
end

function mt:checkMeta()
    for _, value in ipairs(self.metas) do
        local meta = value.metatable
        self:checkMetaIndex(value, meta)
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
        metas = {},
    }, mt)

    -- 创建初始环境
    vm:createEnvironment()

    -- 执行代码
    vm:doActions(ast)

    -- 后处理meta
    vm:checkMeta()

    return vm
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
