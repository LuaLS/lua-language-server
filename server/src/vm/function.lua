local createMulti = require 'vm.multi'
local valueMgr = require 'vm.value'
local localMgr = require 'vm.local'
local sourceMgr = require 'vm.source'
local listMgr = require 'vm.list'

local Watch = setmetatable({}, {__mode = 'kv'})

local mt = {}
mt.__index = mt
mt.type = 'function'
mt._runed = 0
mt._top = 0

function mt:getSource()
    return listMgr.get(self.source)
end

function mt:getUri()
    local source = self:getSource()
    return source and source.uri or ''
end

function mt:push(source)
    if self._removed then
        return
    end
    self._top = self._top + 1
    self.locals[self._top] = {}
    self.finishs[self._top] = source and source.finish or math.maxinteger
end

function mt:pop()
    if self._removed then
        return
    end
    local closed = self.finishs[self._top]
    local closedLocals = self.locals[self._top]
    self.locals[self._top] = nil
    for _, loc in pairs(closedLocals) do
        loc:close(closed)
    end
    self._top = self._top - 1
end

function mt:saveLocal(name, loc)
    if self._removed then
        return
    end
    if loc.type ~= 'local' then
        error('saveLocal必须是local')
    end
    local old = self:loadLocal(name)
    if old then
        loc:shadow(old)
    end
    self.locals[self._top][name] = loc
end

function mt:loadLocal(name)
    for i = self._top, 1, -1 do
        local locals = self.locals[i]
        local loc = locals[name]
        if loc then
            return loc
        end
    end
    return nil
end

function mt:eachLocal(callback)
    local mark = {}
    for i = self._top, 1, -1 do
        local locals = self.locals[i]
        for name, loc in pairs(locals) do
            if not mark[name] then
                mark[name] = true
                local res = callback(name, loc)
                if res ~= nil then
                    return res
                end
            end
        end
    end
    return nil
end

function mt:saveLabel(label)
    if self._removed then
        return
    end
    if not self._label then
        self._label = {}
    end
    self._label[#self._label+1] = label
end

function mt:loadLabel(name)
    if not self._label then
        return nil
    end
    for _, label in ipairs(self._label) do
        if label:getName() == name then
            return label
        end
    end
    return nil
end

function mt:setReturn(index, value)
    if self._removed then
        return
    end
    self:set('hasReturn', true)
    if not self.returns then
        self.returns = createMulti()
    end
    if value then
        self.returns[index] = value
    end
end

function mt:mergeReturn(index, value)
    if self._removed then
        return
    end
    self:set('hasReturn', true)
    if not self.returns then
        self.returns = createMulti()
    end
    if value then
        if self.returns[index] then
            self.returns[index]:mergeValue(value)
        else
            self.returns[index] = value
        end
    end
end

function mt:getReturn(index)
    if self._removed then
        return nil
    end
    if self.maxReturns and index and self.maxReturns < index then
        return nil
    end
    if not self.returns then
        self.returns = createMulti()
    end
    if index then
        return self.returns:get(index)
    else
        return self.returns
    end
end

function mt:returnDots(index)
    if not self.returns then
        self.returns = createMulti()
    end
    --self.returns[index] = createMulti()
end

function mt:loadDots()
    if not self._dots then
        self._dots = createMulti()
    end
    return self._dots
end

function mt:setObject(value, source)
    self._objectValue = value
    self._objectSource = source
end

function mt:getObject()
    return self._objectSource, self._objectValue
end

function mt:hasRuned()
    return self._runed > 0
end

function mt:needSkip()
    return self._runed > 3
end

function mt:run(vm)
    if self._removed then
        return
    end
    if not self:getSource() then
        return
    end

    self._runed = self._runed + 1

    -- 第一次运行函数时，创建函数的参数
    if self._runed == 1 then
        -- 如果是面向对象形式的函数，创建隐藏的参数self
        if self._objectSource then
            local loc = localMgr.create('self', vm:instantSource(self._objectSource), self._objectValue)
            loc:set('hide', true)
            self:saveLocal('self', loc)
            self.args[#self.args+1] = loc
        end

        -- 显性声明的参数
        self:createArgs(vm)
    end

    if self:needSkip() then
        return
    end

    -- 向局部变量中填充参数
    for i, loc in ipairs(self.args) do
        loc:setValue(self.argValues[i])
    end
    if self._dots then
        self._dots = createMulti()
        for i = #self.args + 1, #self.argValues do
            self._dots:push(self.argValues[i])
        end
    end
end

function mt:setArgs(values)
    for i = 1, #self.argValues do
        self.argValues[i] = nil
    end
    for i = 1, #values do
        self.argValues[i] = values[i]
    end
end

function mt:createArg(vm, arg)
    vm:instantSource(arg)
    arg:set('arg', true)
    if arg.type == 'name' then
        local loc = localMgr.create(arg[1], arg, valueMgr.create('nil', arg))
        self:saveLocal(arg[1], loc)
        self.args[#self.args+1] = loc
    elseif arg.type == '...' then
        self._dots = createMulti()
    end
end

function mt:createLibArg(arg, source)
    if arg.type == '...' then
        self._dots = createMulti()
    else
        local name = arg.name or '_'
        local loc = localMgr.create(name, source, valueMgr.create('any', source))
        self:saveLocal(name, loc)
        self.args[#self.args+1] = loc
    end
end

function mt:hasDots()
    return self._dots ~= nil
end

function mt:createArgs(vm)
    if not self:getSource() then
        return
    end
    local args = self:getSource().arg
    if not args then
        return
    end
    if args.type == 'list' then
        for _, arg in ipairs(args) do
            self:createArg(vm, arg)
        end
    else
        self:createArg(vm, args)
    end
end

function mt:set(name, v)
    if not self._flag then
        self._flag = {}
    end
    self._flag[name] = v
end

function mt:get(name)
    if not self._flag then
        return nil
    end
    return self._flag[name]
end

function mt:getSource()
    if self._removed then
        return nil
    end
    return listMgr.get(self.source)
end

function mt:kill()
    if self._removed then
        return
    end
    self._removed = true
    listMgr.clear(self.id)
end

local function create(source)
    if not source then
        error('Function need source')
    end
    local id = source.id
    if not id then
        error('Not instanted source')
    end
    local self = setmetatable({
        source = id,
        locals = {},
        finishs = {},
        args = {},
        argValues = {},
    }, mt)
    self:push(source)

    local id = listMgr.add(self)
    self.id = id
    Watch[self] = id
    return self
end

return {
    create = create,
    watch = Watch,
}
