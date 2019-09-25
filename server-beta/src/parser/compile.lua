local guide = require 'parser.guide'
local type = type

_ENV = nil

local pushError, Root, Compile, CompileBlock, Cache, Block, GoToTag, Version, ENVMode

local vmMap = {
    ['nil'] = function (obj)
        Root[#Root+1] = obj
        return #Root
    end,
    ['boolean'] = function (obj)
        Root[#Root+1] = obj
        return #Root
    end,
    ['string'] = function (obj)
        Root[#Root+1] = obj
        return #Root
    end,
    ['number'] = function (obj)
        Root[#Root+1] = obj
        return #Root
    end,
    ['...'] = function (obj)
        Root[#Root+1] = obj
        return #Root
    end,
    ['getname'] = function (obj)
        Root[#Root+1] = obj
        local id = #Root
        local loc = guide.getLocal(Root, obj, obj[1], obj.start)
        if loc then
            obj.type = 'getlocal'
            obj.loc  = Cache[loc]
            if not loc.ref then
                loc.ref = {}
            end
            loc.ref[#loc.ref+1] = id
        else
            obj.type = 'getglobal'
        end
        return id
    end,
    ['getfield'] = function (obj)
        local node = obj.node
        Root[#Root+1] = obj
        local id = #Root
        obj.node = Compile(node, id)
        return id
    end,
    ['call'] = function (obj)
        Root[#Root+1] = obj
        local id = #Root
        local node = obj.node
        local args = obj.args
        if node then
            obj.node = Compile(node, id)
        end
        if args then
            obj.args = Compile(args, id)
        end
        return id
    end,
    ['callargs'] = function (obj)
        Root[#Root+1] = obj
        local id = #Root
        for i = 1, #obj do
            local arg = obj[i]
            obj[i] = Compile(arg, id)
        end
        return id
    end,
    ['binary'] = function (obj)
        local e1 = obj[1]
        local e2 = obj[2]
        Root[#Root+1] = obj
        local id = #Root
        obj[1] = Compile(e1, id)
        obj[2] = Compile(e2, id)
        return id
    end,
    ['unary'] = function (obj)
        local e = obj[1]
        Root[#Root+1] = obj
        local id = #Root
        obj[1] = Compile(e, id)
        return id
    end,
    ['varargs'] = function (obj)
        local func = guide.getParentFunction(Root, obj)
        if func then
            local index = guide.getFunctionVarArgs(Root, func)
            if not index then
                pushError {
                    type   = 'UNEXPECT_DOTS',
                    start  = obj.start,
                    finish = obj.finish,
                }
            end
        end
        Root[#Root+1] = obj
        return #Root
    end,
    ['paren'] = function (obj)
        local exp = obj.exp
        Root[#Root+1] = obj
        local id = #Root
        obj.exp = Compile(exp, id)
        return id
    end,
    ['getindex'] = function (obj)
        Root[#Root+1] = obj
        local id = #Root
        local node = obj.node
        obj.node = Compile(node, id)
        local index = obj.index
        if index then
            obj.index = Compile(index, id)
        end
        return id
    end,
    ['setindex'] = function (obj)
        Root[#Root+1] = obj
        local id = #Root
        local node = obj.node
        obj.node = Compile(node, id)
        local index = obj.index
        if index then
            obj.index = Compile(index, id)
        end
        local value = obj.value
        if value then
            obj.value = Compile(value, id)
        end
        return id
    end,
    ['getmethod'] = function (obj)
        Root[#Root+1] = obj
        local id = #Root
        local node = obj.node
        local method = obj.method
        obj.node = Compile(node, id)
        if method then
            obj.method = Compile(method, id)
        end
        return id
    end,
    ['setmethod'] = function (obj)
        Root[#Root+1] = obj
        local id = #Root
        local node = obj.node
        local method = obj.method
        local value = obj.value
        obj.node = Compile(node, id)
        if method then
            obj.method = Compile(method, id)
        end
        obj.value = Compile(value, id)
        return id
    end,
    ['method'] = function (obj)
        Root[#Root+1] = obj
        return #Root
    end,
    ['function'] = function (obj)
        local lastBlock = Block
        Block = obj
        Root[#Root+1] = obj
        local id = #Root
        local args = obj.args
        if args then
            obj.args = Compile(args, id)
        end
        for i = 1, #obj do
            local act = obj[i]
            obj[i] = Compile(act, id)
        end
        Block = lastBlock
        return id
    end,
    ['funcargs'] = function (obj)
        Root[#Root+1] = obj
        local id = #Root
        for i = 1, #obj do
            local arg = obj[i]
            obj[i] = Compile(arg, id)
        end
        return id
    end,
    ['table'] = function (obj)
        Root[#Root+1] = obj
        local id = #Root
        for i = 1, #obj do
            local v = obj[i]
            obj[i] = Compile(v, id)
        end
        return id
    end,
    ['tablefield'] = function (obj)
        Root[#Root+1] = obj
        local id = #Root
        local value = obj.value
        if value then
            obj.value = Compile(value, id)
        end
        return id
    end,
    ['tableindex'] = function (obj)
        Root[#Root+1] = obj
        local id = #Root
        local index = obj.index
        local value = obj.value
        obj.index = Compile(index, id)
        obj.value = Compile(value, id)
        return id
    end,
    ['index'] = function (obj)
        Root[#Root+1] = obj
        local id = #Root
        local index = obj.index
        obj.index = Compile(index, id)
        return id
    end,
    ['select'] = function (obj)
        Root[#Root+1] = obj
        local id = #Root
        local vararg = obj.vararg
        if not Cache[vararg] then
            obj.vararg = Compile(vararg, id)
            Cache[vararg] = obj.vararg
        else
            obj.vararg = Cache[vararg]
            if not vararg.extParent then
                vararg.extParent = {}
            end
            vararg.extParent[#vararg.extParent+1] = id
        end
        return id
    end,
    ['setname'] = function (obj)
        Root[#Root+1] = obj
        local id = #Root
        local value = obj.value
        if value then
            obj.value = Compile(value, id)
        end
        local loc = guide.getLocal(Root, obj, obj[1], obj.start)
        if loc then
            obj.type = 'setlocal'
            obj.loc  = Cache[loc]
            if not loc.ref then
                loc.ref = {}
            end
            loc.ref[#loc.ref+1] = id
        else
            obj.type = 'setglobal'
        end
        return id
    end,
    ['local'] = function (obj)
        Root[#Root+1] = obj
        local id = #Root
        local attrs = obj.attrs
        if attrs then
            for i = 1, #attrs do
                local attr = attrs[i]
                attrs[i] = Compile(attr, id)
            end
        end
        if Block then
            if not Block.locals then
                Block.locals = {}
            end
            Block.locals[#Block.locals+1] = id
        end
        if obj.localfunction then
            obj.localfunction = nil
            Cache[obj] = id
            local value = obj.value
            if value then
                obj.value = Compile(value, id)
            end
        else
            local value = obj.value
            if value then
                obj.value = Compile(value, id)
            end
            Cache[obj] = id
        end
        return id
    end,
    ['localattr'] = function (obj)
        Root[#Root+1] = obj
        return #Root
    end,
    ['setfield'] = function (obj)
        Root[#Root+1] = obj
        local id = #Root
        local node  = obj.node
        local value = obj.value
        obj.node  = Compile(node, id)
        obj.value = Compile(value, id)
        return id
    end,
    ['do'] = function (obj)
        local lastBlock = Block
        Block = obj
        Root[#Root+1] = obj
        local id = #Root
        CompileBlock(obj, id)
        Block = lastBlock
        return id
    end,
    ['return'] = function (obj)
        Root[#Root+1] = obj
        local id = #Root
        for i = 1, #obj do
            local act = obj[i]
            obj[i] = Compile(act, id)
        end
        if Block and Block[#Block] ~= obj then
            pushError {
                type   = 'ACTION_AFTER_RETURN',
                start  = obj.start,
                finish = obj.finish,
            }
        end
        return id
    end,
    ['label'] = function (obj)
        Root[#Root+1] = obj
        local id = #Root
        local block = guide.getBlock(Root, obj)
        if block then
            if not block.labels then
                block.labels = {}
            end
            local name = obj[1]
            local label = guide.getLabel(Root, block, name)
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
            block.labels[name] = id
        end
        return id
    end,
    ['goto'] = function (obj)
        Root[#Root+1] = obj
        local id = #Root
        GoToTag[#GoToTag+1] = obj
        return id
    end,
    ['if'] = function (obj)
        Root[#Root+1] = obj
        local id = #Root
        for i = 1, #obj do
            local block = obj[i]
            obj[i] = Compile(block, id)
        end
        return id
    end,
    ['ifblock'] = function (obj)
        local lastBlock = Block
        Block = obj
        Root[#Root+1] = obj
        local id = #Root
        local filter = obj.filter
        obj.filter = Compile(filter, id)
        CompileBlock(obj, id)
        Block = lastBlock
        return id
    end,
    ['elseifblock'] = function (obj)
        local lastBlock = Block
        Block = obj
        Root[#Root+1] = obj
        local id = #Root
        local filter = obj.filter
        if filter then
            obj.filter = Compile(filter, id)
        end
        CompileBlock(obj, id)
        Block = lastBlock
        return id
    end,
    ['elseblock'] = function (obj)
        local lastBlock = Block
        Block = obj
        Root[#Root+1] = obj
        local id = #Root
        CompileBlock(obj, id)
        Block = lastBlock
        return id
    end,
    ['loop'] = function (obj)
        local lastBlock = Block
        Block = obj
        Root[#Root+1] = obj
        local id = #Root
        local loc = obj.loc
        local max = obj.max
        local step = obj.step
        if loc then
            obj.loc = Compile(loc, id)
        end
        if max then
            obj.max = Compile(max, id)
        end
        if step then
            obj.step = Compile(step, id)
        end
        CompileBlock(obj, id)
        Block = lastBlock
        return id
    end,
    ['in'] = function (obj)
        local lastBlock = Block
        Block = obj
        Root[#Root+1] = obj
        local id = #Root
        local keys = obj.keys
        for i = 1, #keys do
            local loc = keys[i]
            keys[i] = Compile(loc, id)
        end
        CompileBlock(obj, id)
        Block = lastBlock
        return id
    end,
    ['while'] = function (obj)
        local lastBlock = Block
        Block = obj
        Root[#Root+1] = obj
        local id = #Root
        local filter = obj.filter
        obj.filter = Compile(filter, id)
        CompileBlock(obj, id)
        Block = lastBlock
        return id
    end,
    ['repeat'] = function (obj)
        local lastBlock = Block
        Block = obj
        Root[#Root+1] = obj
        local id = #Root
        CompileBlock(obj, id)
        local filter = obj.filter
        obj.filter = Compile(filter, id)
        Block = lastBlock
        return id
    end,
    ['break'] = function (obj)
        if not guide.getBreakBlock(Root, obj) then
            pushError {
                type   = 'BREAK_OUTSIDE',
                start  = obj.start,
                finish = obj.finish,
            }
        end
        Root[#Root+1] = obj
        return #Root
    end,
    ['main'] = function (obj)
        Block = obj
        Root[#Root+1] = obj
        local id = #Root
        if ENVMode == '_ENV' then
            Compile({
                type   = 'local',
                start  = 0,
                finish = 0,
                effect = 0,
                [1]    = '_ENV',
            }, id)
        end
        CompileBlock(obj, id)
        Block = nil
        return id
    end,
}

function CompileBlock(obj, parent)
    for i = 1, #obj do
        local act = obj[i]
        local f = vmMap[act.type]
        if f then
            act.parent = parent
            obj[i] = f(act)
        end
    end
end

function Compile(obj, parent)
    if not obj then
        return nil
    end
    local f = vmMap[obj.type]
    if not f then
        return nil
    end
    obj.parent = parent
    return f(obj)
end

local function compileGoTo(obj)
    local name = obj[1]
    local label = guide.getLabel(Root, obj, name)
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

    local block = guide.getBlock(Root, obj)
    local locals = block and block.locals
    if not locals then
        return
    end

    for i = 1, #locals do
        local loc = Root[locals[i]]
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
            local ref = Root[refs[j]]
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
    Root = state.root
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
    state.ast = nil
    Cache = nil
    return state
end
