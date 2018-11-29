local env = require 'matcher.env'
local mt = {}
mt.__index = mt

function mt:isContainPos(obj)
    return obj.start <= self.pos and obj.finish >= self.pos
end

function mt:checkName(name)
    if self:isContainPos(name) then
        local str = name[1]
        self.result = self.env.var[str] or self.env.var._ENV[str]
        self.stop = true
        return self.result
    else
        return nil
    end
end

function mt:checkDots(dots)
    if self:isContainPos(dots) then
        return self.env.dots
    else
        return nil
    end
end

function mt:searchCall(call)
    for _, exp in ipairs(call) do
        local result = searchExp(exp)
        if result then
            return result
        end
    end
    return nil
end

function mt:searchSimple(simple)
    local result = self:checkName(simple[1])
    if result then
        return result
    end
    for i = 2, #simple do
        local obj = simple[i]
        local tp = obj.type
        if     tp == 'call' then
            result = self:searchCall(obj)
        elseif tp == ':' then
        else
            if obj.index then
                result = self:searchExp(obj)
            end
        end
        if result then
            return result
        end
    end
    return nil
end

function mt:searchBinary(exp)
    return self:searchExp(exp[1]) or self:searchExp(exp[2])
end

function mt:searchUnary(exp)
    return self:searchExp(exp[1])
end

function mt:searchExp(exp)
    local tp = exp.type
    local result
    if     tp == 'nil' then
    elseif tp == 'string' then
    elseif tp == 'boolean' then
    elseif tp == 'number' then
    elseif tp == 'name' then
        result = self:checkName(exp)
    elseif tp == 'simple' then
        result = self:searchSimple(exp)
    elseif tp == 'binary' then
        result = self:searchBinary(exp)
    elseif tp == 'unary' then
        result = self:searchUnary(exp)
    elseif tp == '...' then
        result = self:checkDots(exp)
    elseif tp == 'function' then
    elseif tp == 'table' then
    end
    return result
end

function mt:searchReturn(action)
    local exps = action[1]
    if not exps then
        return nil
    end
    for _, exp in ipairs(exps) do
        local result = self:searchExp(exp)
        if result then
            return result
        end
    end
    return nil
end

function mt:checkThenSearchActionsIn(actions)
    if self:isContainPos(actions) then
        return self:searchActionsIn(actions)
    else
        return nil
    end
end

function mt:markSet(simple)
    if simple.type == 'name' then
        local str = simple[1]
        local var = self.env.var[str] -- 是否是一个局部变量？
        if not var then
            var = self.env.var._ENV[str] -- 是否是一个全局变量？
            if not var then
                -- 创建一个全局变量
                var = {}
                self.env.var._ENV[str] = var
            end
        end
        -- 插入赋值信息
        var[#var+1] = {
            type   = 'set',
            source = simple,
        }
        self:checkName(simple)
    else
        self:searchSimple(simple)
    end
end

function mt:createLocal(str, type, source)
    local var = {}
    self.env.var[str] = var
    var[1] = {
        type   = type,
        source = source,
    }
end

function mt:markLocal(simple)
    if simple.type == 'name' then
        local str = simple[1]
        -- 创建一个局部变量
        self:createLocal(str, 'local', simple)
        self:checkName(simple)
    else
        slef:searchSimple(simple)
    end
end

function mt:markSets(action)
    local simples = action[1]
    if simples.type == 'list' then
        for _, simple in ipairs(simples) do
            self:markSet(simple)
        end
    else
        self:markSet(simples)
    end
end

function mt:markLocals(action)
    local simples = action[1]
    if simple.type == 'list' then
        for _, simple in ipairs(simples) do
            self:markLocal(simple)
        end
    else
        self:markLocal(simples)
    end
end

function mt:searchAction(action)
    local tp = action.type
    local result
    if     tp == 'do' then
        result = self:checkThenSearchActionsIn(action)
    elseif tp == 'break' then
    elseif tp == 'return' then
        result = self:searchReturn(action)
    elseif tp == 'label' then
    elseif tp == 'goto' then
    elseif tp == 'set' then
        self:markSets(action)
    elseif tp == 'local' then
        self:markLocals(action)
    end
    return result
end

function mt:searchActionsIn(actions)
    for _, action in ipairs(actions) do
        self:searchAction(action)
        if self.stop then
            return self.result
        end
    end
    return nil
end

return function (ast, pos)
    local searcher = setmetatable({
        pos = pos,
        env = env {var = {}, usable = {}, label = {}},
    }, mt)
    searcher.env.var._ENV = {}
    searcher:searchActionsIn(ast)

    if not searcher.result then
        return false
    end

    local source = searcher.result[1].source
    return true, source.start, source.finish
end
