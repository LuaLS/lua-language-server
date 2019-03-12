local library = require 'core.library'
local createValue = require 'vm.value'
local createLocal = require 'vm.local'
local createLabel = require 'vm.label'
local createFunction = require 'vm.function'
local instantSource = require 'vm.source'
local buildGlobal = require 'vm.global'
local createMulti = require 'vm.multi'
local libraryBuilder = require 'vm.library'

local mt = {}
mt.__index = mt

function mt:getDefaultSource()
    return {
        start = 0,
        finish = 0,
        uri = self:getUri(),
    }
end

function mt:scopePush(source)
    self.currentFunction:push(source)
end

function mt:scopePop()
    self.currentFunction:pop()
end

function mt:eachInfo(var, callback)
    if not self.results.infos[var] then
        return nil
    end
    for _, info in ipairs(self.results.infos[var]) do
        local res = callback(info)
        if res ~= nil then
            return res
        end
    end
    return nil
end

function mt:buildTable(source)
    local tbl = self:createValue('table', source)
    if not source then
        return tbl
    end
    local n = 0
    for index, obj in ipairs(source) do
        if obj.type == 'pair' then
            local value = self:getFirstInMulti(self:getExp(obj[2]))
            local key   = obj[1]
            self:instantSource(key)
            key:bindValue(value, 'set')
            if key.index then
                local index = self:getIndex(key)
                key:set('parent', tbl)
                tbl:addInfo('set child', key, index)
                tbl:setChild(index, value)
            else
                if key.type == 'name' then
                    key:set('parent', tbl)
                    key:set('table index', true)
                    tbl:addInfo('set child', key, key[1])
                    tbl:setChild(key[1], value)
                end
            end
        else
            local value = self:getExp(obj)
            if value.type == 'multi' then
                if index == #source then
                    value:eachValue(function (_, v)
                        n = n + 1
                        tbl:addInfo('set child', obj, n)
                        tbl:setChild(n, v)
                    end)
                else
                    n = n + 1
                    tbl:addInfo('set child', obj, n)
                    tbl:setChild(n, self:getFirstInMulti(value))
                end
            else
                n = n + 1
                tbl:addInfo('set child', obj, n)
                tbl:setChild(n, value)
            end
            -- 处理写了一半的 key = value，把name类的数组元素视为哈希键
            if obj.type == 'name' then
                obj:set('table index', true)
            end
        end
    end
    return tbl
end

function mt:runFunction(func)
    func:run(self)

    if not func.source then
        return
    end

    if func:needSkip() then
        return
    end

    -- 暂时使用这种方式激活参数的source
    for _, arg in ipairs(func.args) do
        if arg.source ~= func:getObject() then
            self:bindLocal(arg.source, arg, 'local')
        end
    end

    local originFunction = self:getCurrentFunction()
    self:setCurrentFunction(func)
    func:push(func.source)

    self:doActions(func.source)

    func:pop()
    self:setCurrentFunction(originFunction)
end

function mt:buildFunction(exp)
    if exp and exp:bindFunction() then
        return exp:bindFunction()
    end

    local value = self:createFunction(exp)

    if not exp then
        return value
    end

    exp:bindFunction(value)
    local func = value:getFunction()

    self:eachLocal(function (name, loc)
        func:saveLocal(name, loc)
    end)

    return value
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

function mt:callSetMetaTable(func, values, source)
    if not values[1] then
        values[1] = self:createValue('any')
    end
    if not values[2] then
        values[2] = self:createValue('any')
    end
    func:setReturn(1, values[1])
    values[1]:setMetaTable(values[2], source)
end

function mt:getRequire(strValue, destVM)
    -- 取出对方的主函数
    local main = destVM.main
    -- 获取主函数返回值，注意不能修改对方的环境
    local mainValue = main:getFunction():getReturn(1)
    if not mainValue then
        mainValue = self:createValue('any', nil)
        mainValue.uri = destVM.uri
    end

    return mainValue
end

function mt:getLoadFile(strValue, destVM)
    -- 取出对方的主函数
    local main = destVM.main
    -- loadfile 的返回值就是对方的主函数
    local mainValue = main

    return mainValue
end

function mt:tryRequireOne(strValue, mode)
    if not self.lsp or not self.lsp.workspace then
        return nil
    end
    local str = strValue:getLiteral()
    if type(str) == 'string' then
        -- 支持 require 'xxx' 的转到定义
        local strSource = strValue.source
        self:instantSource(strSource)
        local uri
        if mode == 'require' then
            uri = self.lsp.workspace:searchPath(self:getUri(), str)
        elseif mode == 'loadfile' then
            uri = self.lsp.workspace:loadPath(self:getUri(), str)
        elseif mode == 'dofile' then
            uri = self.lsp.workspace:loadPath(self:getUri(), str)
        end
        if not uri then
            return nil
        end

        strSource:set('target uri', uri)
        -- 如果取不到VM（不编译），则做个标记，之后再取一次
        local destVM = self.lsp:getVM(uri)
        self.lsp:compileChain(self:getUri(), uri)
        if destVM then
            if mode == 'require' then
                return self:getRequire(strValue, destVM)
            elseif mode == 'loadfile' then
                return self:getLoadFile(strValue, destVM)
            elseif mode == 'dofile' then
                return self:getRequire(strValue, destVM)
            end
        end
    end
    return nil
end

function mt:callRequire(func, values)
    if not values[1] then
        values[1] = self:createValue('any')
    end
    local str = values[1]:getLiteral()
    if type(str) ~= 'string' then
        return
    end
    local lib = library.library[str]
    if lib then
        local value = libraryBuilder.value(lib)
        func:setReturn(1, value)
        return
    else
        local requireValue = self:tryRequireOne(values[1], 'require')
        if not requireValue then
            requireValue = self:createValue('boolean')
            requireValue:set('cross file', true)
        end
        func:setReturn(1, requireValue)
    end
end

function mt:callLoadFile(func, values)
    if not values[1] then
        values[1] = self:createValue('any')
    end
    local str = values[1]:getLiteral()
    if type(str) ~= 'string' then
        return
    end
    local requireValue = self:tryRequireOne(values[1], 'loadfile')
    if not requireValue then
        requireValue = self:createValue('any')
        requireValue:set('cross file', true)
    end
    func:setReturn(1, requireValue)
end

function mt:callDoFile(func, values)
    if not values[1] then
        values[1] = self:createValue('any')
    end
    local str = values[1]:getLiteral()
    if type(str) ~= 'string' then
        return
    end
    local requireValue = self:tryRequireOne(values[1], 'dofile')
    if not requireValue then
        requireValue = self:createValue('any')
        requireValue.isRequire = true
    end
    func:setReturn(1, requireValue)
end

function mt:callLibrary(func, values, source, lib)
    if lib.args then
        for i, arg in ipairs(lib.args) do
            local value = values[i]
            if value and arg.type ~= '...' then
                value:setType(arg.type, 1.0)
            end
        end
    end
    if lib.returns then
        for i, rtn in ipairs(lib.returns) do
            if rtn.type == '...' then
                --func:getReturn(i):setType('any', 0.0)
            else
                func:getReturn(i):setType(rtn.type or 'any', 1.0)
            end
        end
    end
    if lib.special then
        if lib.special == 'setmetatable' then
            self:callSetMetaTable(func, values, source)
        elseif lib.special == 'require' then
            self:callRequire(func, values)
        elseif lib.special == 'loadfile' then
            self:callLoadFile(func, values)
        elseif lib.special == 'dofile' then
            self:callDoFile(func, values)
        end
    end
end

function mt:call(value, values, source)
    local lib = value:getLib()
    local func = value:getFunction()
    value:setType('function', 0.5)
    if not func then
        return
    end
    self:instantSource(source)
    if lib then
        self:callLibrary(func, values, source, lib)
    else
        if func.source then
            if not source:get 'called' then
                source:set('called', true)
                func:setArgs(values)
                self:runFunction(func)
            end
        else
            func:setReturn(1, self:createValue('any', source))
        end
    end

    return func:getReturn()
end

function mt:createValue(tp, source, literal)
    local value = createValue(tp, source, literal)
    value.uri = self:getUri()
    return value
end

function mt:getName(name, source)
    if source then
        self:instantSource(source)
        if source:bindLocal() then
            local loc = source:bindLocal()
            return loc:getValue()
        end
    end
    local loc = self:loadLocal(name)
    if loc then
        source:bindLocal(loc, 'get')
        return loc:getValue()
    end
    local global = source:bindValue()
    if global then
        return global
    end
    local ENV = self:loadLocal('_ENV')
    local ENVValue = ENV:getValue()
    ENVValue:addInfo('get child', source, name)
    global = ENVValue:getChild(name, source)
    source:bindValue(global, 'get')
    source:set('global', true)
    source:set('parent', ENVValue)
    if not global:getLib() then
        if self.lsp then
            self.lsp.global:markGet(self:getUri())
        end
    end
    return global
end

function mt:setName(name, source, value)
    self:instantSource(source)
    local loc = self:loadLocal(name)
    if loc then
        loc:setValue(value)
        source:bindLocal(loc, 'set')
        return
    end
    local global = source:bindValue()
    if global then
        return global
    end
    local ENV = self:loadLocal('_ENV')
    local ENVValue = ENV:getValue()
    source:bindValue(value, 'set')
    ENVValue:addInfo('set child', source, name)
    ENVValue:setChild(name, value)
    source:set('global', true)
    source:set('parentValue', ENVValue)
    if self.lsp then
        self.lsp.global:markSet(self:getUri())
    end
end

function mt:getIndex(source)
    if source.type == 'name' then
        local value = self:getName(source[1], source)
        source:set('in index', true)
        return value
    elseif source.type == 'string' or source.type == 'number' or source.type == 'boolean' then
        return source[1]
    else
        return self:getExp(source)
    end
end

function mt:unpackList(list)
    local values = createMulti()
    local exps = createMulti()
    if not list then
        return values
    end
    if list.type == 'list' or list.type == 'call' or list.type == 'return' then
        for i, exp in ipairs(list) do
            self:instantSource(exp)
            exps:push(exp)
            if exp.type == '...' then
                values:merge(self:loadDots())
                break
            end
            local value = self:getExp(exp)
            if value.type == 'multi' then
                if i == #list then
                    value:eachValue(function (_, v)
                        values:push(v)
                    end)
                else
                    values:push(self:getFirstInMulti(value))
                end
            else
                values:push(value)
            end
        end
    elseif list.type == '...' then
        self:instantSource(list)
        exps:push(list)
        values:merge(self:loadDots())
    else
        self:instantSource(list)
        exps:push(list)
        local value = self:getExp(list)
        if value.type == 'multi' then
            value:eachValue(function (_, v)
                values:push(v)
            end)
        else
            values:push(value)
        end
    end
    return values, exps
end

function mt:getFirstInMulti(multi)
    if not multi then
        return multi
    end
    if multi.type == 'multi' then
        return self:getFirstInMulti(multi[1])
    else
        return multi
    end
end

function mt:getSimple(simple, max)
    self:instantSource(simple)
    local first = simple[1]
    self:instantSource(first)
    local value = self:getExp(first)
    value = self:getFirstInMulti(value) or createValue('nil')
    first:bindValue(value, 'get')
    if not max then
        max = #simple
    elseif max < 0 then
        max = #simple + 1 + max
    end
    local object
    for i = 2, max do
        local source = simple[i]
        self:instantSource(source)
        source:set('simple', simple)
        value = self:getFirstInMulti(value) or createValue('nil')

        if source.type == 'call' then
            local values, args = self:unpackList(source)
            local func = value
            if object then
                table.insert(values, 1, object)
                table.insert(args, 1, simple[i-3])
            end
            object = nil
            source:bindCall(func, args)
            value = self:call(func, values, source) or createValue('any')
        elseif source.type == 'index' then
            source:set('parent', value)
            local child = source[1]
            local index = self:getIndex(child)
            value:addInfo('get child', source, index)
            value = value:getChild(index, source)
            source:bindValue(value, 'get')
        elseif source.type == 'name' then
            source:set('parent', value)
            source:set('object', object)
            value:addInfo('get child', source, source[1])
            value = value:getChild(source[1], source)
            source:bindValue(value, 'get')
        elseif source.type == ':' then
            object = value
            source:set('parent', value)
            source:set('object', object)
        elseif source.type == '.' then
            source:set('parent', value)
        end
    end
    return value
end

function mt:isTrue(v)
    if v:getType() == 'nil' then
        return false
    end
    if v:getType() == 'boolean' and not v:getLiteral() then
        return false
    end
    return true
end

function mt:getBinary(exp)
    local v1 = self:getExp(exp[1])
    local v2 = self:getExp(exp[2])
    v1 = self:getFirstInMulti(v1) or createValue('nil', exp[1])
    v2 = self:getFirstInMulti(v2) or createValue('nil', exp[2])
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
        v1:setType('number', 0.5)
        v2:setType('number', 0.5)
        v1:setType('string', 0.1)
        v2:setType('string', 0.1)
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
    then
        v1:setType('integer', 0.5)
        v2:setType('integer', 0.5)
        v1:setType('number', 0.5)
        v2:setType('number', 0.5)
        v1:setType('string', 0.1)
        v2:setType('string', 0.1)
        if math.type(v1:getLiteral()) == 'integer' and math.type(v2:getLiteral()) == 'integer' then
            if op == '|' then
                return self:createValue('integer', exp, v1:getLiteral() | v2:getLiteral())
            elseif op == '~' then
                return self:createValue('integer', exp, v1:getLiteral() ~ v2:getLiteral())
            elseif op == '&' then
                return self:createValue('integer', exp, v1:getLiteral() &v2:getLiteral())
            elseif op == '<<' then
                return self:createValue('integer', exp, v1:getLiteral() << v2:getLiteral())
            elseif op == '>>' then
                return self:createValue('integer', exp, v1:getLiteral() >> v2:getLiteral())
            end
        end
        return self:createValue('integer')
    elseif op == '..' then
        v1:setType('string', 0.5)
        v2:setType('string', 0.5)
        v1:setType('number', 0.1)
        v2:setType('number', 0.1)
        if type(v1:getLiteral()) == 'string' and type(v2:getLiteral()) == 'string' then
            return self:createValue('string', nil, v1:getLiteral() .. v2:getLiteral())
        end
        return self:createValue('string')
    elseif op == '+'
        or op == '-'
        or op == '*'
        or op == '/'
        or op == '^'
        or op == '%'
        or op == '//'
    then
        v1:setType('number', 0.5)
        v2:setType('number', 0.5)
        if type(v1:getLiteral()) == 'number' and type(v2:getLiteral()) == 'number' then
            if op == '+' then
                return self:createValue('number', exp, v1:getLiteral() + v2:getLiteral())
            elseif op == '-' then
                return self:createValue('number', exp, v1:getLiteral() - v2:getLiteral())
            elseif op == '*' then
                return self:createValue('number', exp, v1:getLiteral() * v2:getLiteral())
            elseif op == '/' then
                if v2:getLiteral() ~= 0 then
                    return self:createValue('number', exp, v1:getLiteral() / v2:getLiteral())
                end
            elseif op == '^' then
                return self:createValue('number', exp, v1:getLiteral() ^ v2:getLiteral())
            elseif op == '%' then
                if v2:getLiteral() ~= 0 then
                    return self:createValue('number', exp, v1:getLiteral() % v2:getLiteral())
                end
            elseif op == '//' then
                if v2:getLiteral() ~= 0 then
                    return self:createValue('number', exp, v1:getLiteral() // v2:getLiteral())
                end
            end
        end
        return self:createValue('number')
    end
    return nil
end

function mt:getUnary(exp)
    local v1 = self:getExp(exp[1])
    v1 = self:getFirstInMulti(v1)
    local op = exp.op
    -- TODO 搜索元方法
    if     op == 'not' then
        return self:createValue('boolean')
    elseif op == '#' then
        v1:setType('table', 0.5)
        v1:setType('string', 0.5)
        if type(v1:getLiteral()) == 'string' then
            return self:createValue('integer', exp, #v1:getLiteral())
        end
        return self:createValue('integer')
    elseif op == '-' then
        v1:setType('number', 0.5)
        if type(v1:getLiteral()) == 'number' then
            return self:createValue('number', exp, -v1:getLiteral())
        end
        return self:createValue('number')
    elseif op == '~' then
        v1:setType('integer', 0.5)
        if math.type(v1:getLiteral()) == 'integer' then
            return self:createValue('integer', exp, ~v1:getLiteral())
        end
        return self:createValue('integer')
    end
    return nil
end

function mt:getExp(exp)
    self:instantSource(exp)
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
        local value = self:getName(exp[1], exp)
        return value
    elseif tp == 'simple' then
        return self:getSimple(exp)
    elseif tp == 'binary' then
        return self:getBinary(exp)
    elseif tp == 'unary' then
        return self:getUnary(exp)
    elseif tp == 'function' then
        return self:buildFunction(exp)
    elseif tp == 'table' then
        return self:buildTable(exp)
    elseif tp == '...' then
        return self:loadDots()
    elseif tp == 'list' then
        return self:getMultiByList(exp)
    end
    error('Unkown exp type: ' .. tostring(tp))
end

function mt:getMultiByList(list)
    local multi = createMulti()
    for i, exp in ipairs(list) do
        multi:push(self:getExp(exp), i == #list)
    end
    return multi
end

function mt:doDo(action)
    self:scopePush(action)
    self:doActions(action)
    self:scopePop()
end

function mt:doReturn(action)
    if #action == 0 then
        return
    end
    self:instantSource(action)
    local values = self:unpackList(action)
    local func = self:getCurrentFunction()
    values:eachValue(function (n, value)
        value.uri = self:getUri()
        func:setReturn(n, value)
        value:addInfo('return', action[n])
    end)
end

function mt:doLabel(source)
    local name = source[1]
    local label = self:loadLabel(name)
    if label then
        self:bindLabel(source, label, 'set')
    else
        label = self:createLabel(name, source, 'set')
    end
end

function mt:createLabel(name, source, action)
    local label = self:bindLabel(source)
    if label then
        self:saveLabel(label)
        return label
    end

    label = createLabel(name, source)
    self:saveLabel(label)
    self:bindLabel(source, label, action)
    return label
end

function mt:doGoTo(source)
    local name = source[1]
    local label = self:loadLabel(name)
    if label then
        self:bindLabel(source, label, 'get')
    else
        label = self:createLabel(name, source, 'get')
    end
end

function mt:setOne(var, value)
    if not value then
        value = createValue('nil')
    end
    self:instantSource(var)
    if var.type == 'name' then
        self:setName(var[1], var, value)
    elseif var.type == 'simple' then
        local parent = self:getSimple(var, -2)
        local key = var[#var]
        self:instantSource(key)
        key:set('simple', var)
        key:set('parent', parent)
        if key.type == 'index' then
            local index = self:getIndex(key[1])
            parent:addInfo('set child', key[1], index)
            parent:setChild(index, value)
        elseif key.type == 'name' then
            local index = key[1]
            parent:addInfo('set child', key, index)
            parent:setChild(index, value)
        end
        key:bindValue(value, 'set')
    end
end

function mt:doSet(action)
    if not action[2] then
        return
    end
    -- 要先计算值
    local vars = action[1]
    local exps = action[2]
    local value = self:getExp(exps)
    local values = {}
    if value.type == 'multi' then
        value:eachValue(function (i, v)
            values[i] = v
        end)
    else
        values[1] = value
    end
    local i = 0
    self:forList(vars, function (var)
        i = i + 1
        self:setOne(var, values[i])
    end)
end

function mt:doLocal(action)
    local vars = action[1]
    local exps = action[2]
    local values
    if exps then
        local value = self:getExp(exps)
        values = {}
        if value.type == 'multi' then
            value:eachValue(function (i, v)
                values[i] = v
            end)
        else
            values[1] = value
        end
    end
    local i = 0
    self:forList(vars, function (key)
        i = i + 1
        local value
        if values then
            value = values[i]
        end
        self:createLocal(key[1], key, value)
    end)
end

function mt:doIf(action)
    for _, block in ipairs(action) do
        if block.filter then
            self:getExp(block.filter)
        end

        self:scopePush(block)
        self:doActions(block)
        self:scopePop()
    end
end

function mt:doLoop(action)

    local min = self:getFirstInMulti(self:getExp(action.min))
    self:getExp(action.max)
    if action.step then
        self:getExp(action.step)
    end

    self:scopePush(action)
    self:createLocal(action.arg[1], action.arg, min)
    self:doActions(action)
    self:scopePop()
end

function mt:doIn(action)
    local args = self:unpackList(action.exp)

    self:scopePush(action)
    local func = table.remove(args, 1) or createValue('any')
    local values = self:call(func, args, action) or createMulti()
    self:forList(action.arg, function (arg)
        local value = table.remove(values, 1)
        self:createLocal(arg[1], arg, value)
    end)

    self:doActions(action)

    self:scopePop()
end

function mt:doWhile(action)

    self:getExp(action.filter)

    self:scopePush(action)
    self:doActions(action)
    self:scopePop()
end

function mt:doRepeat(action)
    self:scopePush(action)
    self:doActions(action)
    self:getExp(action.filter)
    self:scopePop()
end

function mt:doFunction(action)
    self:instantSource(action)
    local name = action.name
    if name then
        if name.type == 'simple' then
            local parent = self:getSimple(name, -2)
            if name[#name-1].type == ':' then
                local value = self:buildFunction(action)
                local source = name[#name]
                self:instantSource(source)
                source:set('object', parent)
                if source.type == 'index' then
                    local index = self:getIndex(source[1])
                    parent:addInfo('set child', source[1], index)
                    parent:setChild(index, value)
                elseif source.type == 'name' then
                    local index = source[1]
                    parent:addInfo('set child', source, index)
                    parent:setChild(index, value)
                end
                source:bindValue(value, 'set')

                local func = value:getFunction()
                if #name == 3 then
                    -- function x:b()
                    local loc = self:loadLocal(name[1][1])
                    if loc then
                        func:setObject(parent, loc.source)
                    else
                        func:setObject(parent, name[#name-2])
                    end
                else
                    func:setObject(parent, name[#name-2])
                end
            else
                local value = self:buildFunction(action)
                local source = name[#name]
                self:instantSource(source)
                if source.type == 'index' then
                    local index = self:getIndex(source[1])
                    parent:addInfo('set child', source[1], index)
                    parent:setChild(index, value)
                elseif source.type == 'name' then
                    local index = source[1]
                    parent:addInfo('set child', source, index)
                    parent:setChild(index, value)
                end
                source:bindValue(value, 'set')
            end
        else
            local value = self:buildFunction(action)
            self:setName(name[1], name, value)
        end
    else
        self:buildFunction(action)
    end
end

function mt:doLocalFunction(action)
    self:instantSource(action)
    local name = action.name
    if name then
        if name.type == 'simple' then
            self:buildFunction(action)
        else
            local loc = self:createLocal(name[1], name)
            local func = self:buildFunction(action)
            func:addInfo('local', name)
            loc:setValue(func)
            loc:setInitValue(func)
        end
    end
end

function mt:doAction(action)
    if not action then
        -- Skip
        return
    end
    local tp = action.type
    if     tp == 'do' then
        self:doDo(action)
    elseif tp == 'break' then
    elseif tp == 'return' then
        self:doReturn(action)
    elseif tp == 'label' then
        self:doLabel(action)
    elseif tp == 'goto' then
        self:doGoTo(action)
    elseif tp == 'set' then
        self:doSet(action)
    elseif tp == 'local' then
        self:doLocal(action)
    elseif tp == 'simple' then
        -- call
        self:getSimple(action)
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
    else
        self:getExp(action)
    end
end

function mt:doActions(actions)
    for _, action in ipairs(actions) do
        self:doAction(action)
        if coroutine.isyieldable() then
            if self.lsp:isNeedCompile(self.uri) then
                coroutine.yield()
            else
                coroutine.yield('stop')
            end
        end
    end
end

function mt:createFunction(source)
    local value = self:createValue('function', source)
    local func = createFunction(source)
    value:setFunction(func)
    value:setType('function', 1.0)
    if source:getUri() == self.uri then
        self.funcs[#self.funcs+1] = func
    end
    return value
end

function mt:callLeftFuncions()
    for _, func in ipairs(self.funcs) do
        if not func:hasRuned() then
            self:runFunction(func)
        end
    end
end

function mt:setCurrentFunction(func)
    self.currentFunction = func
end

function mt:getCurrentFunction()
    return self.currentFunction
end

function mt:saveLocal(name, loc)
    self.currentFunction:saveLocal(name, loc)
end

function mt:loadLocal(name)
    return self.currentFunction:loadLocal(name)
end

function mt:eachLocal(callback)
    return self.currentFunction:eachLocal(callback)
end

function mt:saveLabel(label)
    self.currentFunction:saveLabel(label)
end

function mt:loadLabel(name)
    return self.currentFunction:loadLabel(name)
end

function mt:loadDots()
    return self.currentFunction:loadDots()
end

function mt:getUri()
    return self.currentFunction and self.currentFunction:getUri() or self.uri
end

function mt:instantSource(source)
    if instantSource(source) then
        source:setUri(self:getUri())
        self.sources[#self.sources+1] = source
    end
end

function mt:bindLocal(source, loc, action)
    if not source then
        return
    end
    self:instantSource(source)
    if loc then
        source:bindLocal(loc, action)
    else
        return source:bindLocal()
    end
end

function mt:bindLabel(source, label, action)
    self:instantSource(source)
    if label then
        source:bindLabel(label, action)
    else
        return source:bindLabel()
    end
end

function mt:createLocal(key, source, value)
    local loc = self:bindLocal(source)
    if loc then
        self:saveLocal(key, loc)
        return loc
    end

    if not value then
        value = createValue('nil', self:getDefaultSource())
    end

    loc = createLocal(key, source, value)
    self:saveLocal(key, loc)
    self:bindLocal(source, loc, 'local')
    value:addInfo('local', source)
    return loc
end

function mt:createEnvironment(ast)
    -- 整个文件是一个函数
    self.main = self:createFunction(ast)
    self:setCurrentFunction(self.main:getFunction())
    -- 全局变量`_G`
    local global = buildGlobal(self.lsp)
    -- 隐藏的上值`_ENV`
    local env = self:createLocal('_ENV', nil, global)
    env:set('hide', true)
    self.env = env
end

function mt:eachSource(callback)
    local sources = self.sources
    for i = 1, #sources do
        callback(sources[i])
    end
end

local function compile(ast, lsp, uri)
    local vm = setmetatable({
        funcs   = {},
        sources = {},
        main    = nil,
        env     = nil,
        lsp     = lsp,
        uri     = uri or '',
    }, mt)

    -- 创建初始环境
    ast.uri = vm.uri
    vm:instantSource(ast)
    vm:createEnvironment(ast)

    -- 检查所有没有调用过的函数，调用一遍
    vm:callLeftFuncions()

    return vm
end

return function (ast, lsp, uri)
    if not ast then
        return nil
    end
    local suc, res = xpcall(compile, log.error, ast, lsp, uri)
    if not suc then
        return nil, res
    end
    return res
end
