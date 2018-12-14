local env = require 'matcher.env'
local library = require 'matcher.library'

local DefaultSource = { start = 0, finish = 0 }

local mt = {}
mt.__index = mt

function mt:createLocal(key, source, value)
    local loc = {
        type = 'local',
        key = key,
        source = source or DefaultSource,
    }

    local shadow = self.scope.locals[key]
    if shadow then
        local group
        if shadow.shadow then
            group = shadow.shadow
        else
            group = { shadow }
            shadow.shadow = group
        end
        group[#group+1] = loc
        loc.shadow = group
    end

    self.scope.locals[key] = loc
    self.results.locals[#self.results.locals+1] = loc

    self:addInfo(loc, 'local', source)
    self:setValue(loc, value, source)
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
    if source then
        local other = self.results.sources[source]
        if other then
            if other.type == 'multi-source' then
                other[#other+1] = obj
            else
                other = {
                    type = 'multi-source',
                    [1] = other,
                    [2] = obj,
                }
            end
        else
            self.results.sources[source] = obj
        end
    end
    return obj
end

function mt:createDots(index, source)
    local dots = {
        type = 'dots',
        source = source or DefaultSource,
        func = self:getCurrentFunction(),
        index = index,
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
    for index, obj in ipairs(source) do
        if obj.type == 'pair' then
            local value = self:getExp(obj[2])
            local key   = obj[1]
            if key.index then
                local index = self:getIndex(key)
                local field = self:createField(tbl, index, key)
                if value.type == 'list' then
                    self:setValue(field, value[1], key)
                else
                    self:setValue(field, value, key)
                end
            else
                if key.type == 'name' then
                    local index = key[1]
                    local field = self:createField(tbl, index, key)
                    if value.type == 'list' then
                        self:setValue(field, value[1], key)
                    else
                        self:setValue(field, value, key)
                    end
                end
            end
        else
            local value
            if obj.type == '...' then
                value = { type = 'list' }
                self:unpackDots(value, 1)
            else
                value = self:getExp(obj)
            end
            if value.type == 'list' then
                if index == #source then
                    for i, v in ipairs(value) do
                        local field = self:createField(tbl, n + i)
                        self:setValue(field, v)
                    end
                else
                    n = n + 1
                    local field = self:createField(tbl, n)
                    self:setValue(field, value[1])
                end
            else
                n = n + 1
                local field = self:createField(tbl, n)
                self:setValue(field, value)
            end
        end
    end
    return tbl
end

function mt:mergeValue(a, b, mark)
    if a == b then
        return
    end
    if not mark then
        mark = {}
    end
    if mark[a] or mark[b] then
        return
    end
    mark[a] = true
    mark[b] = true
    self:mergeChild(a, b, mark)
    for k in pairs(a) do
        a[k] = nil
    end
    for k, v in pairs(b) do
        a[k] = v
    end
end

function mt:mergeField(a, b, mark)
    if a == b then
        return
    end
    if not mark then
        mark = {}
    end
    for i, info in ipairs(a) do
        a[i] = nil
        b[#b+1] = info
    end
    for i, v in ipairs(b) do
        a[i] = v
    end
    self:mergeValue(a.value, b.value, mark)
end

function mt:mergeChild(a, b, mark)
    if a == b then
        return
    end
    if not a.child and not b.child then
        return
    end
    if not mark then
        mark = {}
    end
    local child = a.child or {}
    local other = b.child or {}
    a.child = nil
    b.child = nil
    for k, v in pairs(other) do
        if child[k] then
            self:mergeField(v, child[k], mark)
        else
            child[k] = v
        end
    end
    a.child = child
    b.child = child
end

function mt:setValue(var, value, source)
    if value and value.type == 'list' then
        error('Cant set value list')
    end
    value = value or self:createValue('any', source)
    if var.value then
        if value.type == 'any' then
            self:mergeChild(var.value, value)
        else
            self:mergeValue(var.value, value)
        end
        value = var.value
    else
        var.value = value
    end
    if source and source.start then
        self:addInfo(var, 'set', source)
        if not value.declarat then
            value.declarat = source
        end
    end
    return value
end

function mt:getValue(var)
    if not var.value then
        var.value = self:createValue('any')
    end
    return var.value
end

function mt:createField(pValue, name, source)
    if pValue.type == 'local' or pValue.type == 'field' then
        error('Only value can create field')
    end
    local field = {
        type   = 'field',
        key    = name,
        source = source or DefaultSource,
    }

    if not pValue.child then
        pValue.child = {}
    end
    pValue.child[name] = field
    self:inference(pValue, 'table')

    return field
end

function mt:getField(pValue, name, source)
    local field =  (pValue.child and pValue.child[name])
                or self:createField(pValue, name, source)

    return field
end

function mt:buildFunction(exp, object)
    local func = self:createValue('function')
    func.args = {}
    func.argValues = {}

    if not exp then
        return func
    end

    self.scope:push()
    self.chunk:push()
    self.chunk:cut 'dots'
    self.chunk:cut 'labels'
    self.chunk.func = func

    if object then
        local var = self:createLocal('self', object.source, self:getValue(object))
        var.disableRename = true
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
            func.argValues[#func.args] = self:getValue(var)
        elseif arg.type == '...' then
            self:createDots(#func.args+1, arg)
            for _ = 1, 10 do
                func.argValues[#func.argValues+1] = self:createValue('any', arg)
            end
            stop = true
        end
    end)

    self:doActions(exp)

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

function mt:countList(list)
    if not list then
        return 0
    end
    if list.type == 'list' then
        return #list
    end
    return 1
end

function mt:updateFunctionArgs(func)
    if not func.argValues then
        return
    end
    if not func.args then
        return
    end

    local values = func.argValues
    for i, var in ipairs(func.args) do
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

function mt:setFunctionArg(func, values)
    if not func.argValues then
        func.argValues = {}
    end
    for i = 1, #values do
        if not func.argValues[i] then
            func.argValues[i] = values[i]
        end
        self:inference(values[i], func.argValues[i].type)
        self:inference(func.argValues[i], values[i].type)
    end

    self:updateFunctionArgs(func)
end

function mt:getFunctionArg(func, i)
    if not func.argValues then
        func.argValues = {}
    end
    if not func.argValues[i] then
        for n = #func.argValues+1, i do
            func.argValues[n] = self:createValue('any')
        end
    end
    return func.argValues[i]
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

function mt:callSetMetaTable(func, values)
    if not values[1] then
        values[1] = self:createValue('any')
    end
    if not values[2] then
        values[2] = self:createValue('any')
    end
    self:setFunctionReturn(func, 1, values[1])

    values[1].metatable = values[2]
    -- 检查 __index
    self:checkMetaIndex(values[1], values[2])
end

function mt:callRequire(func, values)
    if not values[1] then
        values[1] = self:createValue('any')
    end
    local str = values[1].value
    if type(str) == 'string' then
        local lib = library.library[str]
        if lib then
            local value = self:getLibValue(lib, 'library')
            self:setFunctionReturn(func, 1, value)
            return
        end
    end
    self:setFunctionReturn(func, 1, nil)
end

function mt:call(func, values)
    self:inference(func, 'function')
    local lib = func.lib
    if lib then
        if lib.args then
            for i, arg in ipairs(lib.args) do
                self:inference(self:getFunctionArg(func, i), arg.type)
            end
        end
        if lib.returns then
            for i, rtn in ipairs(lib.returns) do
                self:inference(self:getFunctionReturns(func, i), rtn.type)
            end
        end
        if lib.special then
            if lib.special == 'setmetatable' then
                self:callSetMetaTable(func, values)
            elseif lib.special == 'require' then
                self:callRequire(func, values)
            end
        end
    end

    self:setFunctionArg(func, values)

    return self:getFunctionReturns(func)
end

function mt:getCurrentFunction()
    return self.chunk.func
end

function mt:setFunctionReturn(func, index, value)
    func.hasReturn = true
    if not func.returns then
        func.returns = {
            type = 'list',
            [1] = self:createValue('any'),
        }
    end
    if value then
        if value.type == 'list' then
            for i, v in ipairs(value) do
                func.returns[index+i-1] = v
            end
        else
            func.returns[index] = value
        end
    else
        func.returns[index] = self:createValue('any')
    end
end

function mt:getFunctionReturns(func, i)
    if not func.returns then
        func.returns = {
            type = 'list',
            [1] = self:createValue('any'),
        }
    end
    if i then
        if not func.returns[i] then
            for n = #func.returns+1, i do
                func.returns[n] = self:createValue('any')
            end
        end
        return func.returns[i]
    else
        return func.returns
    end
end

function mt:inference(value, type)
    if value.type == 'any' then
        value.type = type
    end
end

function mt:createValue(type, source, v)
    local value = {
        type = type,
        source = source or DefaultSource,
        value = v,
    }
    local lib = library.object[type]
    if lib then
        self:getLibChild(value, lib, 'object')
    end
    return value
end

function mt:getLibChild(value, lib, parentType)
    if lib.child then
        if self.libraryChild[lib] then
            value.child = self.libraryChild[lib]
            return
        end
        self.libraryChild[lib] = {}
        for fName, fLib in pairs(lib.child) do
            local fField = self:createField(value, fName)
            local fValue = self:getLibValue(fLib, parentType)
            self:setValue(fField, fValue)
        end
        if value.child then
            for k, v in pairs(value.child) do
                self.libraryChild[lib][k] = v
            end
        end
        value.child = self.libraryChild[lib]
    end
end

function mt:getLibValue(lib, parentType, v)
    if self.libraryValue[lib] then
        return self.libraryValue[lib]
    end
    local tp = lib.type
    local value
    if     tp == 'table' then
        value = self:createValue('table')
    elseif tp == 'function' then
        value = self:createValue('function')
        if lib.returns then
            for i, rtn in ipairs(lib.returns) do
                self:setFunctionReturn(value, i, self:getLibValue(rtn, parentType))
            end
        end
        if lib.args then
            local values = {}
            for i, arg in ipairs(lib.args) do
                values[i] = self:getLibValue(arg, parentType) or self:createValue('any')
            end
            self:setFunctionArg(value, values)
        end
    elseif tp == 'string' then
        value = self:createValue('string', nil, v or lib.value)
    elseif tp == 'boolean' then
        value = self:createValue('boolean', nil, v or lib.value)
    elseif tp == 'number' then
        value = self:createValue('number', nil, v or lib.value)
    elseif tp == 'integer' then
        value = self:createValue('integer', nil, v or lib.value)
    elseif tp == 'nil' then
        value = self:createValue('nil')
    else
        value = self:createValue(tp)
    end
    self.libraryValue[lib] = value
    value.lib = lib
    value.parentType = parentType

    self:getLibChild(value, lib, parentType)

    return value
end

function mt:getName(name, source)
    local loc = self.scope.locals[name]
    if loc then
        return loc
    end
    local ENV = self.scope.locals._ENV
    local global = self:getField(self:getValue(ENV), name, source)
    global.parent = ENV
    return global
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

-- expect表示遇到 ... 时，期待的返回数量
function mt:unpackDots(res, expect)
    local dots = self:getDots(1)
    local func = dots.func
    local start = dots.index
    if expect then
        local finish = start + expect - 1
        for i = start, finish do
            res[#res+1] = self:getFunctionArg(func, i)
        end
    else
        if not func.argValues then
            return
        end
        for i = start, #func.argValues do
            res[#res+1] = func.argValues[i]
        end
    end
end

function mt:unpackList(list, expect)
    local res = {}
    if list.type == 'list' or list.type == 'call' then
        for i, exp in ipairs(list) do
            if exp.type == '...' then
                self:unpackDots(res, expect)
                break
            end
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
    elseif list.type == '...' then
        self:unpackDots(res, expect)
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
    for _, v in ipairs(res) do
        if v.type == 'list' then
            error('Unpack list')
        end
    end
    return res
end

function mt:getSimple(simple, mode)
    local value = self:getExp(simple[1])
    local field
    local parentName
    if simple[1].type == 'name' then
        field = self:getName(simple[1][1])
        parentName = field.key
    else
        field = self:createValue('any', simple[1])
        parentName = '?'
    end
    local object
    local lastField = field
    for i = 2, #simple do
        local obj = simple[i]
        local tp  = obj.type

        if     tp == 'call' then
            local args = self:unpackList(obj)
            if object then
                table.insert(args, 1, self:getValue(object))
            end
            -- 函数的返回值一定是list
            value = self:call(value, args)
            if i < #simple then
                value = value[1] or self:createValue('any')
            end
            self.results.calls[#self.results.calls+1] = {
                call = obj,
                lastObj = simple[i-1],
                nextObj = simple[i+1],
            }
            parentName = parentName .. '(...)'
        elseif obj.index then
            local index = self:getIndex(obj)
            field = self:getField(value, index, obj)
            field.parentValue = value
            value = self:getValue(field)
            if mode == 'value' or i < #simple then
                if obj.start then
                    self:addInfo(field, 'get', obj)
                end
            end
            obj.object = object
            obj.parentName = parentName
            if obj.type == 'string' then
                parentName = ('%s[%q]'):format(parentName, index)
            elseif obj.type == 'number' or obj.type == 'boolean' then
                parentName = ('%s[%s]'):format(parentName, index)
            else
                parentName = ('%s[?]'):format(parentName)
            end
        else
            if tp == 'name' then
                field = self:getField(value, obj[1], obj)
                field.parentValue = value
                value = self:getValue(field)
                if mode == 'value' or i < #simple then
                    self:addInfo(field, 'get', obj)
                end
                field.parent = lastField
                lastField = field
                obj.object = object
                obj.parentName = parentName
                parentName = parentName .. '.' .. field.key
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

function mt:isTrue(v)
    if v.type == 'nil' then
        return false
    end
    if v.type == 'boolean' and not v.value then
        return false
    end
    return true
end

function mt:getBinary(exp)
    local v1 = self:getExp(exp[1])
    local v2 = self:getExp(exp[2])
    local op = exp.op
    -- TODO 搜索元方法
    if     op == 'or' then
        if self:isTrue(v1) then
            return v1
        else
            return v2
        end
    elseif op == 'and' then
        if self:isTrue(v1) then
            return v2
        else
            return v1
        end
    elseif op == '<='
        or op == '>='
        or op == '<'
        or op == '>'
    then
        self:inference(v1, 'number')
        self:inference(v2, 'number')
        return self:createValue('boolean')
    elseif op == '~='
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
        self:inference(v1, 'integer')
        self:inference(v2, 'integer')
        return self:createValue('integer')
    elseif op == '..' then
        self:inference(v1, 'string')
        self:inference(v2, 'string')
        return self:createValue('string')
    elseif op == '+'
        or op == '-'
        or op == '*'
        or op == '/'
        or op == '^'
        or op == '%'
    then
        self:inference(v1, 'number')
        self:inference(v2, 'number')
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
        self:inference(v1, 'table')
        return self:createValue('integer')
    elseif op == '-' then
        self:inference(v1, 'number')
        return self:createValue('number')
    elseif op == '~' then
        self:inference(v1, 'integer')
        return self:createValue('integer')
    end
    return nil
end

function mt:getDots()
    if not self.chunk.dots then
        self:createDots(1)
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
        if exp.type == '...' then
            local values = {}
            self:unpackDots(values)
            for x, v in ipairs(values) do
                self:setFunctionReturn(self:getCurrentFunction(), i + x - 1, v)
            end
            break
        else
            local value = self:getExp(exp)
            self:setFunctionReturn(self:getCurrentFunction(), i, value)
        end
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
    local n = self:countList(action[1])
    -- 要先计算值
    local values = self:unpackList(action[2], n)
    self:forList(action[1], function (key)
        local value = table.remove(values, 1)
        if key.type == 'name' then
            local var = self:getName(key[1], key)
            self:setValue(var, value, key)
        elseif key.type == 'simple' then
            local field = self:getSimple(key, 'field')
            self:setValue(field, value, key[#key])
        end
    end)
end

function mt:doLocal(action)
    local n = self:countList(action[1])
    local values
    if action[2] then
        values = self:unpackList(action[2], n)
    end
    self:forList(action[1], function (key)
        local value
        if values then
            value = table.remove(values, 1)
        end
        self:createLocal(key[1], key, value)
    end)
end

function mt:doIf(action)
    for _, block in ipairs(action) do
        if block.filter then
            self:getExp(block.filter)
        end

        self.scope:push()
        self:doActions(block)
        self.scope:pop()
    end
end

function mt:doLoop(action)

    local min = self:getExp(action.min)
    self:getExp(action.max)
    if action.step then
        self:getExp(action.step)
    end

    self.scope:push()
    self:createLocal(action.arg[1], action.arg, min)
    self:doActions(action)
    self.scope:pop()
end

function mt:doIn(action)
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

    self.scope:push()
    local args = self:unpackList(list)
    local values = self:call(func, args)
    self:forList(action.arg, function (arg)
        local value = table.remove(values, 1)
        self:createLocal(arg[1], arg, value)
    end)

    self:doActions(action)

    self.scope:pop()
end

function mt:doWhile(action)

    self:getExp(action.filter)

    self.scope:push()
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
    self:setValue(var, func, source)
end

function mt:doLocalFunction(action)
    local name = action.name
    local var = self:createLocal(name[1], name)
    local func = self:buildFunction(action)
    self:setValue(var, func, name)
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
    local envValue = self:setValue(parent, self:buildTable())
    -- _ENV 有个特殊标记
    envValue.ENV = true
    -- 隐藏的参数`...`
    self:createDots(1)

    -- 设置全局变量
    for name, lib in pairs(library.global) do
        local field = self:createField(envValue, name)
        local value = self:getLibValue(lib, 'global')
        value = self:setValue(field, value)
    end

    -- 设置 _G 使用 _ENV 的child
    local g = self:getField(envValue, '_G')
    local gValue = self:getValue(g)
    gValue.child = envValue.child
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
            labels = {},
            funcs  = {},
            calls  = {},
            sources= {},
        },
        libraryValue = {},
        libraryChild = {},
    }, mt)

    -- 创建初始环境
    vm:createEnvironment()

    -- 执行代码
    vm:doActions(ast)

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
