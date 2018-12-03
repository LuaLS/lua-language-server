local env = require 'matcher.env'
local mt = {}
mt.__index = mt

function mt:isContainPos(obj)
    return obj.start <= self.pos and obj.finish + 1 >= self.pos
end

function mt:getVar(key, source)
    if key == nil then
        return nil
    end
    local var = self.env.var[key]
             or self:getField(self.env.var._ENV, key, source) -- 这里不需要用getVar来递归获取_ENV
    if not var then
        var = self:addField(self:getVar '_ENV', key, source)
    end
    if var and var.meta then
        var = var.meta
    end
    return var
end

function mt:addVarInfo(var, info)
    if not var then
        return nil
    end
    var[#var+1] = info
    return var
end

function mt:createLocal(key, source, var)
    if key == nil then
        return nil
    end
    if not var then
        var = {
            type = 'local',
            source = source,
            childs = {},
        }
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
        var = {
            type = 'field',
            source = source,
            childs = {},
        }
        parent.childs[key] = var
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

function mt:checkVar(var, source)
    if not var or not source then
        return
    end
    if self:isContainPos(source) then
        self.result = {
            type = 'var',
            var  = var,
        }
    end
end

function mt:checkName(name)
    local var = self:getVar(name[1], name)
    self:checkVar(var, name)
    return var
end

function mt:checkDots(dots)
    if self:isContainPos(dots) then
        local dots = self.env.dots
        if dots then
            self.result = {
                type = 'dots',
                dots = dots,
            }
        end
    end
end

function mt:searchCall(call, simple, i)
    local results = {}
    for i, exp in ipairs(call) do
        results[i] = self:searchExp(exp)
    end
    
    -- 特殊处理 setmetatable
    if i == 2 and simple[1][1] == 'setmetatable' then
        local obj = results[1]
        local metatable = results[2]
        if metatable then
            local index = self:getField(metatable, '__index')
            if obj then
                self:setTable(obj, index, 'copy')
                return obj
            else
                return index
            end
        else
            return obj
        end
    end
    return nil
end

function mt:searchSimple(simple)
    local name = simple[1]
    local var
    if name.type == 'name' then
        var = self:getVar(name[1], name)
        self:checkVar(var, name)
    end
    self:searchExp(simple[1])
    for i = 2, #simple do
        local obj = simple[i]
        local tp = obj.type
        self:searchExp(obj)
        if     tp == 'call' then
            var = self:searchCall(obj, simple, i)
        elseif tp == ':' then
        elseif tp == 'name' then
            if obj.index then
                var = nil
            else
                var = self:getField(var, obj[1], obj)
                self:checkVar(var, obj)
            end
        else
            if obj.index then
                if obj.type == 'string' or obj.type == 'number' or obj.type == 'boolean' then
                    var = self:getField(var, obj[1], obj)
                    self:checkVar(var, obj)
                end
            else
                var = nil
            end
        end
    end
    return var
end

function mt:searchBinary(exp)
    return self:searchExp(exp[1]) or self:searchExp(exp[2])
end

function mt:searchUnary(exp)
    return self:searchExp(exp[1])
end

function mt:searchTable(exp)
    local tbl = {
        type = 'table',
        childs = {},
    }
    for _, obj in ipairs(exp) do
        if obj.type == 'pair' then
            local key, value = obj[1], obj[2]
            local res = self:searchExp(value)
            local var = self:addField(tbl, key[1], key)
            self:setTable(var, res)
            self:addVarInfo(var, {
                type   = 'set',
                source = key,
            })
        else
            self:searchExp(obj)
        end
    end
    return tbl
end

function mt:searchExp(exp)
    local tp = exp.type
    if     tp == 'nil' then
    elseif tp == 'string' then
    elseif tp == 'boolean' then
    elseif tp == 'number' then
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
        self:searchFunction(exp)
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

function mt:setTable(var, tbl, mode)
    if not var or not tbl then
        return
    end
    if mode == 'copy' then
        for k, v in pairs(var.childs) do
            if tbl.childs[k] then
                for i, info in ipairs(v) do
                    table.insert(tbl.childs[k], 1, info)
                end
            end
            tbl.childs[k] = v
        end
    end
    var.childs = tbl.childs
end

function mt:markSimple(simple)
    local name = simple[1]
    local var = self:getVar(name[1], name)
    for i = 2, #simple do
        local obj = simple[i]
        local tp  = obj.type
        if     tp == ':' then
            var = self:createLocal('self', simple[i-1], self:getVar(simple[i-1][1]))
        elseif tp == 'name' then
            if not obj.index then
                var = self:addField(var, obj[1], obj)
                if i == #simple then
                    self:addVarInfo(var, {
                        type   = 'set',
                        source = obj,
                    })
                end
            else
                var = nil
            end
        else
            if obj.index then
                var = self:addField(var, obj[1], obj)
                if i == #simple then
                    self:addVarInfo(var, {
                        type   = 'set',
                        source = obj,
                    })
                end
            else
                var = nil
            end
        end
    end
    return var
end

function mt:markSet(simple, tbl)
    if simple.type == 'name' then
        local var = self:getVar(simple[1], simple)
        self:addVarInfo(var, {
            type   = 'set',
            source = simple,
        })
        self:checkVar(var, simple)
        self:setTable(var, tbl)
    else
        self:searchSimple(simple)
        local var = self:markSimple(simple)
        self:setTable(var, tbl)
    end
end

function mt:markLocal(name, tbl)
    if name.type == 'name' then
        local str = name[1]
        -- 创建一个局部变量
        local var = self:createLocal(str, name)
        self:checkVar(var, name)
        self:setTable(var, tbl)
    elseif name.type == '...' then
        self.env.dots = name
    elseif name.type == ':' then
        -- 创建一个局部变量
        self:createLocal('self', name)
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
    self.env:push()
    self.env:cut 'dots'
    self.env.label = {}
    if func.name then
        self:markSet(func.name)
    end
    self:forList(func.arg, function (arg)
        self:markLocal(arg)
    end)
    self:searchActions(func)
    self.env:pop()
end

function mt:searchLocalFunction(func)
    self:markLocal(func.name)
    self.env:push()
    self:forList(func.arg, function (arg)
        self:markLocal(arg)
    end)
    self:searchActions(func)
    self.env:pop()
end

function mt:markLabel(label)
    local str = label[1]
    if not self.env.label[str] then
        self.env.label[str] = {
            type = 'label',
        }
    end
    table.insert(self.env.label[str], label)
end

function mt:searchGoTo(obj)
    local str = obj[1]
    if not self.env.label[str] then
        self.env.label[str] = {
            type = 'label',
        }
    end
    self.result = self.env.label[str]
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

local function parseResult(result)
    local results = {}
    local tp = result.type
    if     tp == 'var' then
        local var = result.var
        if var.type == 'local' then
            local source = var.source
            if not source then
                return false
            end
            results[1] = {source.start, source.finish}
        elseif var.type == 'field' then
            if #var == 0 then
                return false
            end
            for i, info in ipairs(var) do
                if info.type == 'set' then
                    results[i] = {info.source.start, info.source.finish}
                end
            end
        else
            error('unknow var.type:' .. var.type)
        end
    elseif tp == 'dots' then
        local dots = result.dots
        results[1] = {dots.start, dots.finish}
    elseif tp == 'label' then
        for i, label in ipairs(result) do
            results[i] = {label.start, label.finish}
        end
    else
        error('unknow result.type:' .. result.type)
    end
    return true, results
end

return function (ast, pos)
    local searcher = setmetatable({
        pos = pos,
        env = env {var = {}, usable = {}},
    }, mt)
    searcher.env.label = {}
    searcher:createLocal('_ENV')
    searcher:searchActions(ast)

    if not searcher.result then
        return false
    end

    return parseResult(searcher.result)
end
