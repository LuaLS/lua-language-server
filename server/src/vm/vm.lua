local library = require 'core.library'
local createValue = require 'vm.value'
local createLocal = require 'vm.local'
local createLabel = require 'vm.label'
local createFunction = require 'vm.function'
local instantSource = require 'vm.source'
local buildGlobal = require 'vm.global'
local createMulti = require 'vm.multi'

local mt = {}
mt.__index = mt

function mt:getDefaultSource()
    return {
        start = 0,
        finish = 0,
        uri = self:getUri(),
    }
end

function mt:createDummyVar(source, value)
    if source and source.bind then
        return source.bind
    end
    local loc = {
        type = 'local',
        key = '',
        source = source or self:getDefaultSource(),
    }

    if source then
        source.bind = loc
        self.results.sources[#self.results.sources+1] = source
        source.isLocal = true
    end

    self:setValue(loc, value, source)
    return loc
end

function mt:createArg(key, source, value)
    local loc = self:createLocal(key, source, value)
    if source then
        source.isArg = true
    end
    return loc
end

function mt:scopePush()
    self.currentFunction:push()
end

function mt:scopePop()
    self.currentFunction:pop()
end

function mt:addInfo(var, type, source, value)
    if not source then
        error('Miss source')
    end
    if not source.start then
        error('Miss start: ' .. table.dump(source))
    end
    if var.type ~= 'local' and var.type ~= 'field' and var.type ~= 'label' then
        error('Must be local, field or label: ' .. table.dump(var))
    end
    local info = {
        type = type,
        source = source or self:getDefaultSource(),
        value = value,
    }
    if not self.results.infos[var] then
        self.results.infos[var] = {}
    end
    self.results.infos[var][#self.results.infos[var]+1] = info
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

function mt:createDots(index, source)
    local dots = {
        type = 'dots',
        source = source or self:getDefaultSource(),
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
            key.uri = self.chunk.func.uri
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
                    local field = self:createField(tbl, key[1], key)
                    key.isIndex = true
                    if value.type == 'list' then
                        self:setValue(field, value[1], key)
                    else
                        self:setValue(field, value, key)
                    end
                end
            end
        else
            local value = self:getExp(obj)
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
            -- 处理写了一半的 key = value，把name类的数组元素视为哈希键
            if obj.type == 'name' then
                obj.isIndex = true
            end
        end
    end
    return tbl
end

function mt:setValue(var, value, source)
    if value and value.type == 'list' then
        error('Cant set value list')
    end
    value = value or self:createValue('any', source)
    if source and source.start then
        self:addInfo(var, 'set', source, value)
        value:addInfo('set', source)
    end
    if var.GLOBAL then
        value.GLOBAL = true
    end
    var.value = value
    return value
end

function mt:getValue(var, source)
    if not var.value then
        var.value = self:createValue('any', source or self:getDefaultSource())
        if var.GLOBAL then
            var.value.GLOBAL = true
        end
    end
    return var.value
end

function mt:isGlobal(field)
    return field.GLOBAL == true
end

function mt:runFunction(func)
    func:run()

    if not func.source then
        return
    end

    local originFunction = self:getCurrentFunction()

    self:doActions(func.source)

    self:setCurrentFunction(originFunction)
end

function mt:buildFunction(exp, object, colon)
    if exp and exp.func then
        return exp.func
    end

    local func = self:createValue('function', exp)
    func.args = {}
    func.argValues = {}

    if not exp then
        return func
    end

    func.built = exp
    func.upvalues = {}
    func.object = object
    func.colon = colon
    func.uri = exp.uri
    exp.func = func
    for name, loc in pairs(self.scope.locals) do
        func.upvalues[name] = loc
    end

    self.results.funcs[#self.results.funcs+1] = func

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

function mt:setFunctionArg(func, values)
    if not func.argValues then
        func.argValues = {}
    end
    for i = 1, #values do
        func.argValues[i] = values[i]
    end
    if func.dots then
        local dotsIndex = #func.args
        for i = dotsIndex, #values do
            func.dots:set(i - dotsIndex + 1, values[i])
        end
    end
end

function mt:getFunctionArg(func, i)
    if not func.argValues then
        func.argValues = {}
    end
    return func.argValues[i]
end

function mt:callSetMetaTable(func, values, source)
    if not values[1] then
        values[1] = self:createValue('any')
    end
    if not values[2] then
        values[2] = self:createValue('any')
    end
    self:setFunctionReturn(func, 1, values[1])
    values[1]:setMetaTable(values[2], source)
end

function mt:getRequire(strValue, destVM)
    -- 取出对方的主函数
    local main = destVM.results.main
    -- 获取主函数返回值，注意不能修改对方的环境
    local mainValue
    if main.returns then
        mainValue = self:selectList(main.returns, 1)
    else
        mainValue = self:createValue('boolean', nil, true)
        mainValue.uri = destVM.uri
    end

    return mainValue
end

function mt:getLoadFile(strValue, destVM)
    -- 取出对方的主函数
    local main = destVM.results.main
    -- loadfile 的返回值就是对方的主函数
    local mainValue = main

    return mainValue
end

function mt:tryRequireOne(strValue, mode)
    if not self.lsp or not self.lsp.workspace then
        return nil
    end
    local str = strValue:getValue()
    if type(str) == 'string' then
        -- 支持 require 'xxx' 的转到定义
        local strSource = strValue.source
        strSource.bind = strValue
        self.results.sources[#self.results.sources+1] = strSource
        strValue.isRequire = true

        local uri
        if mode == 'require' then
            uri = self.lsp.workspace:searchPath(self.chunk.func.uri, str)
        elseif mode == 'loadfile' then
            uri = self.lsp.workspace:loadPath(self.chunk.func.uri, str)
        elseif mode == 'dofile' then
            uri = self.lsp.workspace:loadPath(self.chunk.func.uri, str)
        end
        if not uri then
            return nil
        end

        strValue.uri = uri
        -- 如果取不到VM（不编译），则做个标记，之后再取一次
        local destVM = self.lsp:getVM(uri)
        self.lsp:compileChain(self.chunk.func.uri, uri)
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
    local str = values[1]:getValue()
    if type(str) ~= 'string' then
        return
    end
    local lib = library.library[str]
    if lib then
        local value = self:getLibValue(lib, 'library')
        self:setFunctionReturn(func, 1, value)
        return
    else
        local requireValue = self:tryRequireOne(values[1], 'require')
        if not requireValue then
            requireValue = self:createValue('boolean')
            requireValue.isRequire = true
        end
        self:setFunctionReturn(func, 1, requireValue)
    end
end

function mt:callLoadFile(func, values)
    if not values[1] then
        values[1] = self:createValue('any')
    end
    local str = values[1]:getValue()
    if type(str) ~= 'string' then
        return
    end
    local requireValue = self:tryRequireOne(values[1], 'loadfile')
    if not requireValue then
        requireValue = self:createValue('any')
        requireValue.isRequire = true
    end
    self:setFunctionReturn(func, 1, requireValue)
end

function mt:callDoFile(func, values)
    if not values[1] then
        values[1] = self:createValue('any')
    end
    local str = values[1]:getValue()
    if type(str) ~= 'string' then
        return
    end
    local requireValue = self:tryRequireOne(values[1], 'dofile')
    if not requireValue then
        requireValue = self:createValue('any')
        requireValue.isRequire = true
    end
    self:setFunctionReturn(func, 1, requireValue)
end

function mt:call(func, values, source)
    local lib = func.lib
    if lib then
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
                    self:getFunctionReturns(func, i):setType('any', 0.0)
                else
                    self:getFunctionReturns(func, i):setType(rtn.type or 'any', 1.0)
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
    else
        if not func.built then
            self:setFunctionReturn(func, 1, self:createValue('any', source))
        end
    end

    if not source.hasRuned and func.built then
        source.hasRuned = true
        self:setFunctionArg(func, values)
        self:runFunction(func)
    end

    return self:getFunctionReturns(func)
end

function mt:setFunctionReturn(func, index, value)
    func.hasReturn = true
    if not func.returns then
        func.returns = createMulti()
    end
    if value then
        func.returns[index] = value
    else
        func.returns[index] = self:createValue('any', func.source)
    end
end

function mt:getFunctionReturns(func, i)
    if func.maxReturns and i and func.maxReturns < i then
        return self:createValue('nil')
    end
    if not func.returns then
        func.returns = createMulti()
    end
    if i then
        return func.returns:get(i)
    else
        return func.returns
    end
end

function mt:createValue(tp, source, v)
    local value = createValue(tp, source, v)
    local lib = library.object[tp]
    if lib then
        self:getLibChild(value, lib, 'object')
    end
    return value
end

function mt:getName(name, source)
    if source then
        self:instantSource(source)
        if source:bindLocal() then
            return source:bindLocal()
        end
    end
    local loc = self:loadLocal(name)
    if loc then
        source:bindLocal(loc)
        return loc:getValue()
    end
    local ENV = self:loadLocal('_ENV')
    local ENVValue = ENV:getValue()
    local global = ENVValue:getChild(name)
    if global then
        return global
    else
        global = self:createValue('any')
        return global
    end
end

function mt:setName(name, source, value)
    self:instantSource(source)
    local loc = self:loadLocal(name)
    if loc then
        source:bindLocal(loc)
        loc:setValue(value)
        return
    end
    local ENV = self:loadLocal('_ENV')
    local ENVValue = ENV:getValue()
    ENVValue:setChild(name, value)
end

function mt:getIndex(source)
    self:instantSource(source)
    if source.type == 'name' then
        local value = self:getName(source[1], source)
        return value
    elseif source.type == 'string' or source.type == 'number' or source.type == 'boolean' then
        return source[1]
    else
        return self:getExp(source)
    end
end

-- expect表示遇到 ... 时，期待的返回数量
function mt:unpackDots(res, expect)
    local dots = self:loadDots(expect)
    for _, v in ipairs(dots) do
        res[#res+1] = v
    end
end

function mt:unpackList(list, expect)
    local res = {
        type = 'list',
    }
    if not list then
        return res
    end
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

function mt:getFirstInMulti(multi)
    if multi.type == 'multi' then
        return multi[1]
    else
        return multi
    end
end

function mt:getSimple(simple, mode)
    local value = self:getExp(simple[1])
    local field
    local parentName
    local tp = simple[1].type
    simple[1].uri = self.chunk.func.uri
    if tp == 'name' then
        field = self:getName(simple[1][1], simple[1])
        parentName = field.key
    elseif tp == 'string' or tp == 'number' or tp == 'nil' or tp == 'boolean' then
        local v = self:createValue(tp, simple[1], simple[1][1])
        field = self:createDummyVar(simple[1], v)
        parentName = '*' .. tp
    else
        local v = self:createValue('any', simple[1])
        field = self:createDummyVar(simple[1], v)
        parentName = '?'
    end
    local object
    local colon
    local lastField = field
    for i = 2, #simple do
        local obj = simple[i]
        local tp  = obj.type
        obj.uri = self.chunk.func.uri
        obj.isSuffix = true
        value = self:selectList(value, 1)

        if     tp == 'call' then
            value:setType('function', 0.9)
            local args = self:unpackList(obj)
            if object then
                table.insert(args, 1, self:getValue(object, obj))
            end
            local func = value
            -- 函数的返回值一定是list
            value = self:call(func, args, obj)
            if i < #simple then
                value = value[1] or self:createValue('any', obj)
            end
            self.results.calls[#self.results.calls+1] = {
                args = obj,
                lastObj = simple[i-1],
                nextObj = simple[i+1],
                func = func,
            }
            parentName = parentName .. '(...)'
        elseif tp == 'index' then
            value:setType('table', 0.8)
            value:setType('string', 0.2)
            local child = obj[1]
            obj.indexName = parentName
            local index = self:getIndex(child)
            if mode == 'value' or i < #simple then
                field = self:getField(value, index, obj) or self:createField(value, index, obj)
                value = self:getValue(field, obj)
                self:addInfo(field, 'get', obj)
                value:addInfo('get', obj)
            else
                field = self:createField(value, index, obj)
                value = self:getValue(field, obj)
            end
            field.parent = lastField
            if obj[1].type == 'string' then
                parentName = ('%s[%q]'):format(parentName, index)
            elseif obj[1].type == 'number' or obj[1].type == 'boolean' then
                parentName = ('%s[%s]'):format(parentName, index)
            else
                parentName = ('%s[?]'):format(parentName)
            end
        elseif tp == 'name' then
            value:setType('table', 0.8)
            value:setType('string', 0.2)
            if mode == 'value' or i < #simple then
                field = self:getField(value, obj[1], obj) or self:createField(value, obj[1], obj)
                value = self:getValue(field, obj)
                self:addInfo(field, 'get', obj)
                value:addInfo('get', obj)
            else
                field = self:createField(value, obj[1], obj)
                value = self:getValue(field, obj)
            end
            field.parent = lastField
            lastField = field
            obj.object = object
            obj.parentName = parentName
            parentName = parentName .. '.' .. field.key
        elseif tp == ':' then
            value:setType('table', 0.8)
            value:setType('string', 0.2)
            object = field
            simple[i-1].colon = obj
            colon = colon
        elseif tp == '.' then
            value:setType('table', 0.8)
            value:setType('string', 0.2)
            simple[i-1].dot = obj
        end
    end
    if mode == 'value' then
        return value, object
    elseif mode == 'field' then
        return field, object, colon
    end
    error('Unknow simple mode: ' .. mode)
end

function mt:getSimple(simple, max)
    local first = simple[1]
    self:instantSource(first)
    local value = self:getExp(first)
    if not max then
        max = #simple
    elseif max < 0 then
        max = #simple + 1 - max
    end
    local object
    for i = 2, max do
        local source = simple[i]
        self:instantSource(source)
        value = self:getFirstInMulti(value)

        if source.type == 'call' then
            local args = self:unpackList(source)
            local func = value
            if object then
                table.insert(args, 1, object)
            end
            value = self:call(func, args, source)
        elseif source.type == 'index' then
            local child = source[1]
            local index = self:getIndex(child)
            value = value:getChild(index) or createValue('any')
        elseif source.type == 'name' then
            value = value:getChild(source[1]) or createValue('any')
        elseif source.type == ':' then
            object = value
        elseif source.type == '.' then
        end
    end
    return value
end

function mt:isTrue(v)
    if v:getType() == 'nil' then
        return false
    end
    if v:getType() == 'boolean' and not v:getValue() then
        return false
    end
    return true
end

function mt:selectList(list, n)
    if list.type ~= 'list' then
        return list
    end
    return list[n] or self:createValue('nil')
end

function mt:getBinary(exp)
    local v1 = self:getExp(exp[1])
    local v2 = self:getExp(exp[2])
    v1 = self:selectList(v1, 1)
    v2 = self:selectList(v2, 1)
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
        v1:setType('number', 0.9)
        v2:setType('number', 0.9)
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
        v1:setType('integer', 0.9)
        v2:setType('integer', 0.9)
        v1:setType('number', 0.9)
        v2:setType('number', 0.9)
        v1:setType('string', 0.1)
        v2:setType('string', 0.1)
        if math.type(v1:getValue()) == 'integer' and math.type(v2:getValue()) == 'integer' then
            if op == '|' then
                return self:createValue('integer', exp, v1:getValue() | v2:getValue())
            elseif op == '~' then
                return self:createValue('integer', exp, v1:getValue() ~ v2:getValue())
            elseif op == '&' then
                return self:createValue('integer', exp, v1:getValue() &v2:getValue())
            elseif op == '<<' then
                return self:createValue('integer', exp, v1:getValue() << v2:getValue())
            elseif op == '>>' then
                return self:createValue('integer', exp, v1:getValue() >> v2:getValue())
            end
        end
        return self:createValue('integer')
    elseif op == '..' then
        v1:setType('string', 0.9)
        v2:setType('string', 0.9)
        v1:setType('number', 0.1)
        v2:setType('number', 0.1)
        if type(v1:getValue()) == 'string' and type(v2:getValue()) == 'string' then
            return self:createValue('string', nil, v1:getValue() .. v2:getValue())
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
        v1:setType('number', 0.9)
        v2:setType('number', 0.9)
        if type(v1:getValue()) == 'number' and type(v2:getValue()) == 'number' then
            if op == '+' then
                return self:createValue('number', exp, v1:getValue() + v2:getValue())
            elseif op == '-' then
                return self:createValue('number', exp, v1:getValue() - v2:getValue())
            elseif op == '*' then
                return self:createValue('number', exp, v1:getValue() * v2:getValue())
            elseif op == '/' then
                if v2:getValue() ~= 0 then
                    return self:createValue('number', exp, v1:getValue() / v2:getValue())
                end
            elseif op == '^' then
                return self:createValue('number', exp, v1:getValue() ^ v2:getValue())
            elseif op == '%' then
                if v2:getValue() ~= 0 then
                    return self:createValue('number', exp, v1:getValue() % v2:getValue())
                end
            elseif op == '//' then
                if v2:getValue() ~= 0 then
                    return self:createValue('number', exp, v1:getValue() // v2:getValue())
                end
            end
        end
        return self:createValue('number')
    end
    return nil
end

function mt:getUnary(exp)
    local v1 = self:getExp(exp[1])
    v1 = self:selectList(v1, 1)
    local op = exp.op
    -- TODO 搜索元方法
    if     op == 'not' then
        return self:createValue('boolean')
    elseif op == '#' then
        v1:setType('table', 0.9)
        v1:setType('string', 0.9)
        if type(v1:getValue()) == 'string' then
            return self:createValue('integer', exp, #v1:getValue())
        end
        return self:createValue('integer')
    elseif op == '-' then
        v1:setType('number', 0.9)
        if type(v1:getValue()) == 'number' then
            return self:createValue('number', exp, -v1:getValue())
        end
        return self:createValue('number')
    elseif op == '~' then
        v1:setType('integer', 0.9)
        if math.type(v1:getValue()) == 'integer' then
            return self:createValue('integer', exp, ~v1:getValue())
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
        self.results.strings[#self.results.strings+1] = exp
        return self:createValue('string', exp, exp[1])
    elseif tp == 'boolean' then
        return self:createValue('boolean', exp, exp[1])
    elseif tp == 'number' then
        return self:createValue('number', exp, exp[1])
    elseif tp == 'name' then
        local value = self:getName(exp[1], exp)
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
    elseif tp == '...' then
        local value = { type = 'list' }
        self:unpackDots(value)
        return value
    elseif tp == 'list' then
        return self:getMultiByList(exp)
    end
    error('Unkown exp type: ' .. tostring(tp))
end

function mt:getMultiByList(list)
    local multi = createMulti()
    for _, exp in ipairs(list) do
        multi:push(self:getExp(exp))
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
    local value = self:getExp(action[1])
    local func = self:getCurrentFunction()
    if value.type == 'multi' then
        value:eachValue(function (i, v)
            func:setReturn(i, v)
        end)
    else
        func:setReturn(1, value)
    end
end

function mt:doLabel(source)
    local name = source[1]
    self:createLabel(name, source)
end

function mt:createLabel(name, source)
    local label = self:bindLabel(source)
    if label then
        self:saveLabel(label)
        return label
    end

    label = createLabel(name, source)
    self:saveLabel(label)
    self:bindLabel(source, label)
    return label
end

function mt:doGoTo(source)
    local name = source[1]
    local label = self:loadLabel(name)
    if not label then
        label = self:createLabel(name, source)
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
        if key.type == 'index' then
            local index = self:getIndex(key[1])
            parent:setChild(index, value)
        elseif key.type == 'name' then
            local index = key[1]
            parent:setChild(index, value)
        end
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
    local func = table.remove(args, 1) or self:createValue('any')
    local values = self:call(func, args, action)
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
    local name = action.name
    local var, object, colon
    local source
    if name then
        if name.type == 'simple' then
            var, object, colon = self:getSimple(name, 'field')
            source = name[#name]
        else
            var = self:getName(name[1], name)
            source = name
        end
    end
    local func = self:buildFunction(action, object, colon)
    if var then
        self:setValue(var, func, source)
    end
end

function mt:doLocalFunction(action)
    local name = action.name
    if name then
        if name.type == 'simple' then
            local var, object = self:getSimple(name, 'field')
            local func = self:buildFunction(action, object)
            self:setValue(var, func, name[#name])
        else
            local loc = self:createLocal(name[1], name)
            local func = self:buildFunction(action)
            func:addInfo('local', name)
            self:setValue(loc, func, name[#name])
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
    local value = createValue('function', source)
    local func = createFunction(source)
    value:setFunction(func)
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
    return self.currentFunction:loadLocal(name)
end

function mt:loadDots(expect)
    return self.currentFunction:loadDots(expect)
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

function mt:bindLocal(source, loc)
    if not source then
        return
    end
    self:instantSource(source)
    if loc then
        source:bindLocal(loc)
    else
        return source:bindLocal()
    end
end

function mt:bindLabel(source, label)
    self:instantSource(source)
    if label then
        source:bindLabel(label)
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
    self:bindLocal(source, loc)
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
    env:setFlag('hide', true)
    self.env = env
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

    vm.scope = nil
    vm.chunk = nil

    return vm
end

return function (ast, lsp, uri)
    if not ast then
        return nil
    end
    local suc, res = xpcall(compile, log.error, ast, lsp, uri)
    if not suc then
        return nil
    end
    return res
end
