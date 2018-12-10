local env = require 'matcher.env'
local mt = {}
mt.__index = mt

function mt:getVar(key, source)
    if key == nil then
        return nil
    end
    local var = self.env.var[key]
             or self:getField(self.env.var._ENV, key, source) -- 这里不需要用getVar来递归获取_ENV
    if not var and source then
        var = self:addField(self:getVar '_ENV', key, source)
    end
    if var and var.meta then
        var = var.meta
    end
    return var
end

function mt:addInfo(obj, type, source)
    if not obj then
        return nil
    end
    obj[#obj+1] = {
        type = type,
        source = source,
    }
    return obj
end

function mt:createVar(type, key, source)
    local var = {
        type = type,
        key = key,
        source = source,
        childs = {},
    }
    self.results.vars[#self.results.vars+1] = var
    return var
end

function mt:createLabel(key)
    local lbl = {
        key = key,
        type = 'label',
    }
    self.results.labels[#self.results.labels+1] = lbl
    return lbl
end

function mt:createDots()
    local dots = {
        type = 'dots',
    }
    self.results.dots[#self.results.dots+1] = dots
    return dots
end

function mt:createLib(name)
    local lib = {
        name = name,
        type = 'lib',
        childs = {},
    }
    return lib
end

function mt:createLocal(key, source, var)
    if key == nil then
        return nil
    end
    if not var then
        var = self:createVar('local', key, source)
        self:addInfo(var, 'local', source)
    end
    local old = self.env.var[key]
    if old then
        local shadow = old.shadow
        if not shadow then
            shadow = { old }
            old.shadow = shadow
        end
        var.shadow = shadow
        shadow[#shadow+1] = var
    end
    self.env.var[key] = var
    return var
end

function mt:addField(parent, key, source)
    if parent == nil or key == nil then
        return nil
    end
    assert(source)
    local var = parent.childs[key]
    if not var then
        var = self:createVar('field', key, source)
        parent.childs[key] = var
        var.parent = parent
    end
    return var
end

function mt:getField(parent, key, source)
    if parent == nil or key == nil then
        return nil
    end
    local var
    if parent.childs then
        var = parent.childs[key]
    end
    if not var and source then
        var = self:addField(parent, key, source)
    end
    return var
end

function mt:isGlobal(var)
    if var.type ~= 'field' then
        return false
    end
    if not var.parent then
        return false
    end
    return var.parent.key == '_ENV' or var.parent.key == '_G'
end

function mt:getApi(func)
    if not func then
        return nil
    end
    func = func.value or func
    if self:isGlobal(func) then
        return func.key
    end
    return nil
end

function mt:checkName(name)
    local var = self:getVar(name[1], name)
    self:addInfo(var, 'get', name)
    return var
end

function mt:checkDots(source)
    local dots = self.env.dots
    if not dots then
        return
    end
    self:addInfo(dots, 'get', source)
end

function mt:fixCallAsSetMetaTable(results)
    local obj = results[1]
    local metatable = results[2]
    if metatable then
        local index = self:getField(metatable, '__index')
        if obj then
            self:setMeta(obj, index)
            return obj
        else
            return index
        end
    else
        return obj
    end
end

function mt:fixCallAsRequire(results)
    local libname = results[1]
    if not libname then
        return
    end
    libname = libname.value or libname
    if libname.type ~= 'string' then
        return
    end
    return self:createLib(libname.string)
end

function mt:searchCall(call, func, lastobj)
    local results = {}
    for i, exp in ipairs(call) do
        results[i] = self:searchExp(exp)
    end

    if lastobj then
        table.insert(self.results.calls, {
            call    = call,
            func    = func,
            lastobj = lastobj,
            results = results,
        })
    end

    local api = self:getApi(func)

    if api == 'setmetatable' then
        return self:fixCallAsSetMetaTable(results)
    end

    if api == 'require' then
        return self:fixCallAsRequire(results)
    end

    return nil
end

function mt:searchSimple(simple)
    local name = simple[1]
    local var
    if name.type == 'name' then
        var = self:getVar(name[1], name)
    end
    if name.type == 'string' then
        var = self:getString(name)
    end
    self:searchExp(simple[1])
    for i = 2, #simple do
        local obj = simple[i]
        local tp = obj.type
        if     tp == 'call' then
            var = self:searchCall(obj, var, simple[i-1])
        elseif tp == ':' then
        elseif tp == 'name' then
            if obj.index then
                self:checkName(obj)
                var = nil
            else
                var = self:getField(var, obj[1], obj)
                self:addInfo(var, 'get', obj)
            end
        elseif obj.index and (obj.type == 'string' or obj.type == 'number' or obj.type == 'boolean') then
            var = self:getField(var, obj[1], obj)
            self:addInfo(var, 'get', obj)
        else
            self:searchExp(obj)
            var = nil
        end
    end
    return var
end

function mt:searchBinary(exp)
    self:searchExp(exp[1])
    self:searchExp(exp[2])
end

function mt:searchUnary(exp)
    self:searchExp(exp[1])
end

function mt:searchTable(exp)
    local tbl = {
        type = 'table',
        valuetype = 'table',
        childs = {},
    }
    for _, obj in ipairs(exp) do
        if obj.type == 'pair' then
            local key, value = obj[1], obj[2]
            local res = self:searchExp(value)
            local var = self:addField(tbl, key[1], key)
            self:setValue(var, res)
            self:addInfo(var, 'set', key)
        else
            self:searchExp(obj)
        end
    end
    return tbl
end

function mt:getString(exp)
    return {
        type = 'string',
        string = exp[1],
        valuetype = 'string',
        childs = {},
    }
end

function mt:getBoolean(exp)
    return {
        type = 'boolean',
        boolean = exp[1],
        valuetype = 'boolean',
    }
end

function mt:getNumber(exp)
    return {
        type = 'number',
        number = exp[1],
        valuetype = 'number',
    }
end

function mt:searchExp(exp)
    local tp = exp.type
    if     tp == 'nil' then
    elseif tp == 'string' then
        return self:getString(exp)
    elseif tp == 'boolean' then
        return self:getBoolean(exp)
    elseif tp == 'number' then
        return self:getNumber(exp)
    elseif tp == 'name' then
        return self:checkName(exp)
    elseif tp == 'simple' then
        return self:searchSimple(exp)
    elseif tp == 'binary' then
        self:searchBinary(exp)
    elseif tp == 'unary' then
        self:searchUnary(exp)
    elseif tp == '...' then
        self:checkDots(exp)
    elseif tp == 'function' then
        return self:searchFunction(exp)
    elseif tp == 'table' then
        return self:searchTable(exp)
    end
    return nil
end

function mt:searchReturn(action)
    for _, exp in ipairs(action) do
        self:searchExp(exp)
    end
end

function mt:setValue(var, value)
    if not var or not value then
        return
    end
    var.value = value.value or value
    local group = var.group or value.group
    if not group then
        group = {}
    end
    if not group[var] then
        var.group = group
        group[var] = var
    end
    if not group[value] then
        value.group = group
        group[value] = value
    end
    if value.childs then
        var.childs = value.childs
        for _, child in pairs(value.childs) do
            child.parent = var
        end
    end
end

function mt:setMeta(var, meta)
    if not var or not meta then
        return
    end
    var.childs.meta = meta
    meta.childs.meta = var
end

function mt:markSimple(simple)
    local name = simple[1]
    local var
    if name.type == 'name' then
        var = self:getVar(name[1], name)
    end
    if name.type == 'string' then
        var = self:getString(name)
    end
    self:searchExp(simple[1])
    for i = 2, #simple do
        local obj = simple[i]
        local tp  = obj.type
        if     tp == 'call' then
            var = self:searchCall(obj, var, simple[i-1])
        elseif tp == ':' then
            var = self:createLocal('self', simple[i-1], self:getVar(simple[i-1][1]))
            var.disableRename = true
        elseif tp == 'name' then
            if obj.index then
                self:checkName(obj)
                var = nil
            else
                if i == #simple then
                    var = self:addField(var, obj[1], obj)
                    self:addInfo(var, 'set', obj)
                else
                    var = self:getField(var, obj[1], obj)
                    self:addInfo(var, 'get', obj)
                end
            end
        elseif obj.index and (obj.type == 'string' or obj.type == 'number' or obj.type == 'boolean') then
            if i == #simple then
                var = self:addField(var, obj[1], obj)
                self:addInfo(var, 'set', obj)
            else
                var = self:getField(var, obj[1], obj)
                self:addInfo(var, 'get', obj)
            end
        else
            self:searchExp(obj)
            var = nil
        end
    end
    return var
end

function mt:markSet(simple, value)
    if simple.type == 'name' then
        local var = self:getVar(simple[1], simple)
        self:addInfo(var, 'set', simple)
        self:setValue(var, value)
        return var
    else
        local var = self:markSimple(simple)
        self:setValue(var, value)
        return var
    end
end

function mt:markLocal(name, value)
    if name.type == 'name' then
        local str = name[1]
        -- 创建一个局部变量
        local var = self:createLocal(str, name)
        self:setValue(var, value)
        return var
    elseif name.type == '...' then
        local dots = self:createDots()
        self:addInfo(dots, 'local', name)
        self.env.dots = dots
        return dots
    elseif name.type == ':' then
        -- 创建一个局部变量
        local var = self:createLocal('self', name)
        return var
    end
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

function mt:markSets(action)
    local keys = action[1]
    local values = action[2]
    local results = {}
    -- 要先计算赋值
    local i = 0
    self:forList(values, function (value)
        i = i + 1
        results[i] = self:searchExp(value)
    end)
    local i = 0
    self:forList(keys, function (key)
        i = i + 1
        self:markSet(key, results[i])
    end)
end

function mt:markLocals(action)
    local keys = action[1]
    local values = action[2]
    local results = {}
    -- 要先计算赋值
    local i = 0
    self:forList(values, function (value)
        i = i + 1
        results[i] = self:searchExp(value)
    end)
    local i = 0
    self:forList(keys, function (key)
        i = i + 1
        self:markLocal(key, results[i])
    end)
end

function mt:searchIfs(action)
    for _, block in ipairs(action) do
        self.env:push()
        if block.filter then
            self:searchExp(block.filter)
        end
        self:searchActions(block)
        self.env:pop()
    end
end

function mt:searchLoop(action)
    self.env:push()
    self:markLocal(action.arg)
    self:searchExp(action.min)
    self:searchExp(action.max)
    if action.step then
        self:searchExp(action.step)
    end
    self:searchActions(action)
    self.env:pop()
end

function mt:searchIn(action)
    self:forList(action.exp, function (exp)
        self:searchExp(exp)
    end)
    self.env:push()
    self:forList(action.arg, function (arg)
        self:markLocal(arg)
    end)
    self:searchActions(action)
    self.env:pop()
end

function mt:searchDo(action)
    self.env:push()
    self:searchActions(action)
    self.env:pop()
end

function mt:searchWhile(action)
    self:searchExp(action.filter)
    self.env:push()
    self:searchActions(action)
    self.env:pop()
end

function mt:searchRepeat(action)
    self.env:push()
    self:searchActions(action)
    self:searchExp(action.filter)
    self.env:pop()
end

function mt:searchFunction(func)
    local obj = {
        type = 'function',
        valuetype = 'function',
        args = {},
        actions = {},
    }
    self.env:push()
    self.env:cut 'dots'
    self.env.label = {}
    if func.name then
        obj.name = self:markSet(func.name, obj)
    end
    self:forList(func.arg, function (arg)
        obj.args[#obj.args+1] = self:markLocal(arg)
    end)
    for _, action in ipairs(func) do
        obj.actions[#obj.actions+1] = self:searchAction(action)
    end
    self.env:pop()
    return obj
end

function mt:searchLocalFunction(func)
    local obj = {
        type = 'function',
        valuetype = 'function',
        args = {},
        actions = {},
    }
    if func.name then
        obj.name = self:markLocal(func.name, obj)
    end
    self.env:push()
    self:forList(func.arg, function (arg)
        obj.args[#obj.args+1] = self:markLocal(arg)
    end)
    for _, action in ipairs(func) do
        obj.actions[#obj.actions+1] = self:searchAction(action)
    end
    self.env:pop()
    return obj
end

function mt:markLabel(label)
    local str = label[1]
    if not self.env.label[str] then
        self.env.label[str] = self:createLabel(str)
    end
    self:addInfo(self.env.label[str], 'set', label)
end

function mt:searchGoTo(obj)
    local str = obj[1]
    if not self.env.label[str] then
        self.env.label[str] = self:createLabel(str)
    end
    self:addInfo(self.env.label[str], 'goto', obj)
end

function mt:searchAction(action)
    local tp = action.type
    if     tp == 'do' then
        self:searchDo(action)
    elseif tp == 'break' then
    elseif tp == 'return' then
        self:searchReturn(action)
    elseif tp == 'label' then
        self:markLabel(action)
    elseif tp == 'goto' then
        self:searchGoTo(action)
    elseif tp == 'set' then
        self:markSets(action)
    elseif tp == 'local' then
        self:markLocals(action)
    elseif tp == 'simple' then
        self:searchSimple(action)
    elseif tp == 'if' then
        self:searchIfs(action)
    elseif tp == 'loop' then
        self:searchLoop(action)
    elseif tp == 'in' then
        self:searchIn(action)
    elseif tp == 'while' then
        self:searchWhile(action)
    elseif tp == 'repeat' then
        self:searchRepeat(action)
    elseif tp == 'function' then
        self:searchFunction(action)
    elseif tp == 'localfunction' then
        self:searchLocalFunction(action)
    end
end

function mt:searchActions(actions)
    for _, action in ipairs(actions) do
        self:searchAction(action)
    end
    return nil
end

local function compile(ast)
    local searcher = setmetatable({
        env = env {
            var = {},
            usable = {}
        },
        results = {
            labels = {},
            vars = {},
            dots = {},
            calls = {},
        }
    }, mt)
    searcher.env.label = {}
    searcher:createLocal('_ENV', { start = -1, finish = -1 })
    searcher:searchActions(ast)

    return searcher.results
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
