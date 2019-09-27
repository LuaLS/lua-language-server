local guide = require 'parser.guide'
local type = type

_ENV = nil

local pushError, Compile, CompileBlock, Cache, Block, GoToTag, Version, ENVMode

--[[
-- value 类右字面量创建，在set get call中传递
-- obj 用 vref 表标记当前可能的 value 是哪些
Value
    type    -> 确定类型
    literal -> 字面量对象
    tag     -> 特殊标记
    ref     -> 值的引用者
    child   -> 值的child
    func    -> 函数对象
--]]

local function addValue(obj, value)
    local vref = obj.vref
    if not vref then
        vref = {}
        obj.vref = vref
        Cache[vref] = {}
    end
    local cache = Cache[vref]
    if cache[value] then
        return
    end
    cache[value] = true
    vref[#vref+1] = value
    local valueRef = value.ref
    if not valueRef then
        valueRef = {}
        value.ref = valueRef
    end
    valueRef[#valueRef+1] = obj
end

local function getValue(obj)
    local vref = obj.vref
    if vref then
        return vref
    end
    addValue(obj, {})
    return obj.vref
end

local function mergeValue(obj1, obj2)
    local vref1 = obj1.vref
    local vref2 = obj2.vref
    if not vref2 then
        return
    end
    if not vref1 then
        vref1 = {}
        obj1.vref = vref1
        Cache[vref1] = {}
    end
    local cache = Cache[vref1]
    for i = 1, #vref2 do
        local value = vref2[i]
        if not cache[value] then
            cache[value] = true
            vref1[#vref1+1] = value
            local valueRef = value.ref
            if not valueRef then
                valueRef = {}
                value.ref = valueRef
            end
            valueRef[#valueRef+1] = obj1
        end
    end
end

local function setChildValue(obj, key, value)
    if not value then
        return
    end
    local objVref   = getValue(obj)
    local keyName   = guide.getKeyName(key)
    local valueVref = getValue(value)
    for i = 1, #objVref do
        local v = objVref[i]
        if not v.child then
            v.child = {}
        end
        v.child[keyName] = valueVref
    end
end

local function addLocalRef(node, obj)
    if not node.ref then
        node.ref = {}
    end
    node.ref[#node.ref+1] = obj
    obj.node = node
end

local vmMap = {
    ['getname'] = function (obj)
        local loc = guide.getLocal(obj, obj[1], obj.start)
        if loc then
            obj.type = 'getlocal'
            obj.loc  = loc
            if not loc.ref then
                loc.ref = {}
            end
            loc.ref[#loc.ref+1] = obj
        else
            obj.type = 'getglobal'
            if ENVMode == '_ENV' then
                local node = guide.getLocal(obj, '_ENV', obj.start)
                if node then
                    addLocalRef(node, obj)
                end
            end
        end
        return obj
    end,
    ['getfield'] = function (obj)
        Compile(obj.node, obj)
    end,
    ['call'] = function (obj)
        Compile(obj.node, obj)
        Compile(obj.args, obj)
    end,
    ['callargs'] = function (obj)
        for i = 1, #obj do
            Compile(obj[i], obj)
        end
    end,
    ['binary'] = function (obj)
        Compile(obj[1], obj)
        Compile( obj[2], obj)
    end,
    ['unary'] = function (obj)
        Compile(obj[1], obj)
    end,
    ['varargs'] = function (obj)
        local func = guide.getParentFunction(obj)
        if func then
            local index = guide.getFunctionVarArgs(func)
            if not index then
                pushError {
                    type   = 'UNEXPECT_DOTS',
                    start  = obj.start,
                    finish = obj.finish,
                }
            end
        end
    end,
    ['paren'] = function (obj)
        Compile(obj.exp, obj)
    end,
    ['getindex'] = function (obj)
        Compile(obj.node, obj)
        Compile(obj.index, obj)
    end,
    ['setindex'] = function (obj)
        Compile(obj.node, obj)
        Compile(obj.index, obj)
        Compile(obj.value, obj)
    end,
    ['getmethod'] = function (obj)
        Compile(obj.node, obj)
        Compile(obj.method, obj)
    end,
    ['setmethod'] = function (obj)
        Compile(obj.node, obj)
        Compile(obj.method, obj)
        local value = obj.value
        value.localself = {
            type   = 'local',
            start  = 0,
            finish = 0,
            method = obj,
            effect = obj.finish,
            [1]    = 'self',
        }
        Compile(value, obj)
    end,
    ['function'] = function (obj)
        local lastBlock = Block
        Block = obj
        if obj.localself then
            Compile(obj.localself, obj)
            obj.localself = nil
        end
        Compile(obj.args, obj)
        for i = 1, #obj do
            Compile(obj[i], obj)
        end
        Block = lastBlock
    end,
    ['funcargs'] = function (obj)
        for i = 1, #obj do
            Compile(obj[i], obj)
        end
    end,
    ['table'] = function (obj)
        for i = 1, #obj do
            Compile(obj[i], obj)
        end
    end,
    ['tablefield'] = function (obj)
        Compile(obj.value, obj)
    end,
    ['tableindex'] = function (obj)
        Compile(obj.index, obj)
        Compile(obj.value, obj)
    end,
    ['index'] = function (obj)
        Compile(obj.index, obj)
    end,
    ['select'] = function (obj)
        local vararg = obj.vararg
        if vararg.parent then
            if not vararg.extParent then
                vararg.extParent = {}
            end
            vararg.extParent[#vararg.extParent+1] = obj
        else
            Compile(vararg, obj)
        end
    end,
    ['setname'] = function (obj)
        Compile(obj.value, obj)
        local loc = guide.getLocal(obj, obj[1], obj.start)
        if loc then
            obj.type = 'setlocal'
            obj.loc  = loc
            if not loc.ref then
                loc.ref = {}
            end
            loc.ref[#loc.ref+1] = obj
        else
            obj.type = 'setglobal'
            if ENVMode == '_ENV' then
                local node = guide.getLocal(obj, '_ENV', obj.start)
                if node then
                    addLocalRef(node, obj)
                    setChildValue(node, obj, obj.value)
                end
            end
        end
    end,
    ['local'] = function (obj)
        local attrs = obj.attrs
        if attrs then
            for i = 1, #attrs do
                Compile(attrs[i], obj)
            end
        end
        if Block then
            if not Block.locals then
                Block.locals = {}
            end
            Block.locals[#Block.locals+1] = obj
        end
        if obj.localfunction then
            obj.localfunction = nil
        end
        Compile(obj.value, obj)
    end,
    ['setfield'] = function (obj)
        Compile(obj.node, obj)
        Compile(obj.value, obj)
    end,
    ['do'] = function (obj)
        local lastBlock = Block
        Block = obj
        CompileBlock(obj, obj)
        Block = lastBlock
    end,
    ['return'] = function (obj)
        for i = 1, #obj do
            Compile(obj[i], obj)
        end
        if Block and Block[#Block] ~= obj then
            pushError {
                type   = 'ACTION_AFTER_RETURN',
                start  = obj.start,
                finish = obj.finish,
            }
        end
    end,
    ['label'] = function (obj)
        local block = guide.getBlock(obj)
        if block then
            if not block.labels then
                block.labels = {}
            end
            local name = obj[1]
            local label = guide.getLabel(block, name)
            if label then
                pushError {
                    type   = 'REDEFINED_LABEL',
                    start  = obj.start,
                    finish = obj.finish,
                    relative = {
                        {
                            label.start,
                            label.finish,
                        }
                    }
                }
            end
            block.labels[name] = obj
        end
    end,
    ['goto'] = function (obj)
        GoToTag[#GoToTag+1] = obj
    end,
    ['if'] = function (obj)
        for i = 1, #obj do
            Compile(obj[i], obj)
        end
    end,
    ['ifblock'] = function (obj)
        local lastBlock = Block
        Block = obj
        Compile(obj.filter, obj)
        CompileBlock(obj, obj)
        Block = lastBlock
    end,
    ['elseifblock'] = function (obj)
        local lastBlock = Block
        Block = obj
        Compile(obj.filter, obj)
        CompileBlock(obj, obj)
        Block = lastBlock
    end,
    ['elseblock'] = function (obj)
        local lastBlock = Block
        Block = obj
        CompileBlock(obj, obj)
        Block = lastBlock
    end,
    ['loop'] = function (obj)
        local lastBlock = Block
        Block = obj
        Compile(obj.loc, obj)
        Compile(obj.max, obj)
        Compile(obj.step, obj)
        CompileBlock(obj, obj)
        Block = lastBlock
    end,
    ['in'] = function (obj)
        local lastBlock = Block
        Block = obj
        local keys = obj.keys
        for i = 1, #keys do
            Compile(keys[i], obj)
        end
        CompileBlock(obj, obj)
        Block = lastBlock
    end,
    ['while'] = function (obj)
        local lastBlock = Block
        Block = obj
        Compile(obj.filter, obj)
        CompileBlock(obj, obj)
        Block = lastBlock
    end,
    ['repeat'] = function (obj)
        local lastBlock = Block
        Block = obj
        CompileBlock(obj, obj)
        Compile(obj.filter, obj)
        Block = lastBlock
    end,
    ['break'] = function (obj)
        if not guide.getBreakBlock(obj) then
            pushError {
                type   = 'BREAK_OUTSIDE',
                start  = obj.start,
                finish = obj.finish,
            }
        end
    end,
    ['main'] = function (obj)
        Block = obj
        if ENVMode == '_ENV' then
            local env = {
                type   = 'local',
                start  = 0,
                finish = 0,
                effect = 0,
                [1]    = '_ENV',
            }
            Compile(env, obj)
            addValue(env, {
                type = 'table',
                tag  = '_ENV',
            })
        end
        CompileBlock(obj, obj)
        Block = nil
    end,
}

function CompileBlock(obj, parent)
    for i = 1, #obj do
        local act = obj[i]
        local f = vmMap[act.type]
        if f then
            act.parent = parent
            f(act)
        end
    end
end

function Compile(obj, parent)
    if not obj then
        return nil
    end
    local f = vmMap[obj.type]
    if not f then
        return
    end
    obj.parent = parent
    f(obj)
end

local function compileGoTo(obj)
    local name = obj[1]
    local label = guide.getLabel(obj, name)
    if not label then
        pushError {
            type   = 'NO_VISIBLE_LABEL',
            start  = obj.start,
            finish = obj.finish,
            info   = {
                label = name,
            }
        }
        return
    end
    -- 如果有局部变量在 goto 与 label 之间声明，
    -- 并在 label 之后使用，则算作语法错误

    -- 如果 label 在 goto 之前声明，那么不会有中间声明的局部变量
    if obj.start > label.start then
        return
    end

    local block = guide.getBlock(obj)
    local locals = block and block.locals
    if not locals then
        return
    end

    for i = 1, #locals do
        local loc = locals[i]
        -- 检查局部变量声明位置为 goto 与 label 之间
        if loc.start < obj.start or loc.finish > label.finish then
            goto CONTINUE
        end
        -- 检查局部变量的使用位置在 label 之后
        local refs = loc.ref
        if not refs then
            goto CONTINUE
        end
        for j = 1, #refs do
            local ref = refs[j]
            if ref.finish > label.finish then
                pushError {
                    type   = 'JUMP_LOCAL_SCOPE',
                    start  = obj.start,
                    finish = obj.finish,
                    info   = {
                        loc = loc[1],
                    },
                    relative = {
                        {
                            start  = label.start,
                            finish = label.finish,
                        },
                        {
                            start  = loc.start,
                            finish = loc.finish,
                        }
                    },
                }
                return
            end
        end
        ::CONTINUE::
    end
end

local function PostCompile()
    for i = 1, #GoToTag do
        compileGoTo(GoToTag[i])
    end
end

return function (self, lua, mode, version)
    local state, err = self:parse(lua, mode, version)
    if not state then
        return nil, err
    end
    pushError = state.pushError
    Version = version
    if version == 'Lua 5.1' or version == 'LuaJIT' then
        ENVMode = 'fenv'
    else
        ENVMode = '_ENV'
    end
    Cache = {}
    GoToTag = {}
    if type(state.ast) == 'table' then
        Compile(state.ast)
    end
    PostCompile()
    Cache = nil
    return state
end
