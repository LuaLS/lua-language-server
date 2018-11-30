local env = require 'matcher.env'
local mt = {}
mt.__index = mt

function mt:isContainPos(obj)
    return obj.start <= self.pos and obj.finish + 1 >= self.pos
end

function mt:getVar(str)
    return 
    self.env.var[str] or
    self:getField(self.env.var._ENV, str) -- 这里不需要用getVar来递归获取_ENV
end

function mt:createLocal(str, source)
    local var = {}
    var[1] = {
        type   = 'local',
        source = source,
    }
    self.env.var[str] = var
    return var
end

function mt:createGlobal(str, source)
    local var = {}
    var[1] = {
        type   = 'global',
        source = source,
    }
    self:addField(self:getVar '_ENV', str, var)
    return var
end

function mt:addField(parent, str, var)
    if not parent.childs then
        parent.childs = {}
    end
    parent.childs[str] = var
    return var
end

function mt:getField(parent, str)
    if not parent.childs then
        return nil
    end
    return parent.childs[str]
end

function mt:checkName(name)
    if self:isContainPos(name) then
        local var = self:getVar(name[1])
        if var then
            self.result = {
                type = 'var',
                var  = var,
            }
            self.stop = true
        end
    end
end

function mt:checkDots(dots)
    if self:isContainPos(dots) then
        local dots = self.env.dots
        if dots then
            self.result = {
                type = 'dots',
                dots = dots,
            }
            self.stop = true
        end
    end
end

function mt:searchCall(call)
    for _, exp in ipairs(call) do
        self:searchExp(exp)
    end
    return nil
end

function mt:searchSimple(simple)
    self:checkName(simple[1])
    for i = 2, #simple do
        local obj = simple[i]
        local tp = obj.type
        if     tp == 'call' then
            self:searchCall(obj)
        else
            if obj.index then
                self:searchExp(obj)
            end
        end
    end
end

function mt:searchBinary(exp)
    return self:searchExp(exp[1]) or self:searchExp(exp[2])
end

function mt:searchUnary(exp)
    return self:searchExp(exp[1])
end

function mt:searchTable(exp)
    for _, obj in ipairs(exp) do
        if obj.type == 'pair' then
            self:searchExp(obj[2])
        else
            self:searchExp(obj)
        end
    end
end

function mt:searchExp(exp)
    local tp = exp.type
    if     tp == 'nil' then
    elseif tp == 'string' then
    elseif tp == 'boolean' then
    elseif tp == 'number' then
    elseif tp == 'name' then
        self:checkName(exp)
    elseif tp == 'simple' then
        self:searchSimple(exp)
    elseif tp == 'binary' then
        self:searchBinary(exp)
    elseif tp == 'unary' then
        self:searchUnary(exp)
    elseif tp == '...' then
        self:checkDots(exp)
    elseif tp == 'function' then
        self:searchFunction(exp)
    elseif tp == 'table' then
        self:searchTable(exp)
    end
end

function mt:searchReturn(action)
    for _, exp in ipairs(action) do
        self:searchExp(exp)
    end
end

function mt:markSimple(simple)
    local name = simple[1]
    for i = 2, #simple do
        local obj = simple[i]
        local tp  = obj.type
        if tp == ':' then
            self:createLocal('self', obj)
        end
    end
end

function mt:markSet(simple)
    if simple.type == 'name' then
        local var = self:getVar(simple[1]) or self:createGlobal(simple[1], simple)
        -- 插入赋值信息
        var[#var+1] = {
            type   = 'set',
            source = simple,
        }
        self:checkName(simple)
    else
        self:searchSimple(simple)
        self:markSimple(simple)
    end
end

function mt:markLocal(name)
    if name.type == 'name' then
        local str = name[1]
        -- 创建一个局部变量
        self:createLocal(str, name)
        self:checkName(name)
    elseif name.type == '...' then
        self.env.dots = name
    elseif name.type == ':' then
        -- 创建一个局部变量
        self:createLocal('self', name)
    end
end

function mt:forList(list, callback)
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
    -- 要先计算赋值
    self:forList(values, function (value)
        self:searchExp(value)
    end)
    self:forList(keys, function (key)
        self:markSet(key)
    end)
end

function mt:markLocals(action)
    local keys = action[1]
    local values = action[2]
    -- 要先计算赋值
    if values then
        self:forList(values, function (value)
            self:searchExp(value)
        end)
    end
    self:forList(keys, function (key)
        self:markLocal(key)
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
    if func.name then
        self:markSet(func.name)
    end
    if func.arg then
        self:forList(func.arg, function (arg)
            self:markLocal(arg)
        end)
    end
    self:searchActions(func)
    self.env:pop()
end

function mt:searchLocalFunction(func)
    self:markLocal(func.name)
    self.env:push()
    if func.arg then
        self:forList(func.arg, function (arg)
            self:markLocal(arg)
        end)
    end
    self:searchActions(func)
    self.env:pop()
end

function mt:searchAction(action)
    local tp = action.type
    if     tp == 'do' then
        self:searchDo(action)
    elseif tp == 'break' then
    elseif tp == 'return' then
        self:searchReturn(action)
    elseif tp == 'label' then
    elseif tp == 'goto' then
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
        if self.stop then
            return self.result
        end
    end
    return nil
end

local function parseResult(result)
    local tp = result.type
    if     tp == 'var' then
        local first = result.var[1]
        local source = first.source
        return true, source.start, source.finish
    elseif tp == 'dots' then
        local dots = result.dots
        return true, dots.start, dots.finish
    end
end

return function (ast, pos)
    local searcher = setmetatable({
        pos = pos,
        env = env {var = {}, usable = {}, label = {}},
    }, mt)
    searcher:createLocal('_ENV')
    searcher:searchActions(ast)

    if not searcher.result then
        return false
    end

    return parseResult(searcher.result)
end
