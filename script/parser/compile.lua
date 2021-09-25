local guide       = require 'parser.guide'
local parse       = require 'parser.parse'
local newparser   = require 'parser.newparser'
local type        = type
local tableInsert = table.insert
local pairs       = pairs
local os          = os

local specials = {
    ['_G']           = true,
    ['rawset']       = true,
    ['rawget']       = true,
    ['setmetatable'] = true,
    ['require']      = true,
    ['dofile']       = true,
    ['loadfile']     = true,
    ['pcall']        = true,
    ['xpcall']       = true,
    ['pairs']        = true,
    ['ipairs']       = true,
}

_ENV = nil

local LocalLimit = 200
local pushError, Compile, CompileBlock, Block, GoToTag, ENVMode, Compiled, LocalCount, Version, Root, Options

local function addRef(node, obj)
    if not node.ref then
        node.ref = {}
    end
    node.ref[#node.ref+1] = obj
    obj.node = node
end

local function addSpecial(name, obj)
    if not Root.specials then
        Root.specials = {}
    end
    if not Root.specials[name] then
        Root.specials[name] = {}
    end
    Root.specials[name][#Root.specials[name]+1] = obj
    obj.special = name
end

local vmMap = {
    ['getname'] = function (obj)
        local loc = guide.getLocal(obj, obj[1], obj.start)
        if loc then
            obj.type = 'getlocal'
            obj.loc  = loc
            addRef(loc, obj)
            if loc.special then
                addSpecial(loc.special, obj)
            end
        else
            obj.type = 'getglobal'
            local node = guide.getLocal(obj, ENVMode, obj.start)
            if node then
                addRef(node, obj)
            end
            local name = obj[1]
            if specials[name] then
                addSpecial(name, obj)
            elseif Options and Options.special then
                local asName = Options.special[name]
                if specials[asName] then
                    addSpecial(asName, obj)
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
        if obj.node and obj.node.type == 'getmethod' then
            if not obj.args then
                obj.args = {
                    type   = 'callargs',
                    start  = obj.start,
                    finish = obj.finish,
                    parent = obj,
                }
            end
            local newNode = {}
            for k, v in pairs(obj.node.node) do
                newNode[k] = v
            end
            newNode.mirror = obj.node.node
            newNode.dummy  = true
            newNode.parent = obj.args
            obj.node.node.mirror = newNode
            tableInsert(obj.args, 1, newNode)
            Compiled[newNode] = true
        end
        Compile(obj.args, obj)
    end,
    ['callargs'] = function (obj)
        for i = 1, #obj do
            Compile(obj[i], obj)
        end
    end,
    ['binary'] = function (obj)
        Compile(obj[1], obj)
        Compile(obj[2], obj)
    end,
    ['unary'] = function (obj)
        Compile(obj[1], obj)
    end,
    ['varargs'] = function (obj)
        local func = guide.getParentFunction(obj)
        if func then
            local index, vararg = guide.getFunctionVarArgs(func)
            if not index then
                pushError {
                    type   = 'UNEXPECT_DOTS',
                    start  = obj.start,
                    finish = obj.finish,
                }
            end
            if vararg then
                if not vararg.ref then
                    vararg.ref = {}
                end
                vararg.ref[#vararg.ref+1] = obj
                obj.node = vararg
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
        local localself = {
            type   = 'local',
            start  = value.start,
            finish = value.start,
            method = obj,
            effect = obj.finish,
            tag    = 'self',
            dummy  = true,
            [1]    = 'self',
        }
        if not value.args then
            value.args = {
                type   = 'funcargs',
                start  = obj.start,
                finish = obj.finish,
            }
        end
        tableInsert(value.args, 1, localself)
        Compile(value, obj)
    end,
    ['function'] = function (obj)
        local lastBlock = Block
        local LastLocalCount = LocalCount
        Block = obj
        LocalCount = 0
        Compile(obj.args, obj)
        for i = 1, #obj do
            Compile(obj[i], obj)
        end
        Block = lastBlock
        LocalCount = LastLocalCount
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
    ['tableexp'] = function (obj)
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
            addRef(loc, obj)
            if loc.attrs then
                local const
                for i = 1, #loc.attrs do
                    local attr = loc.attrs[i][1]
                    if attr == 'const'
                    or attr == 'close' then
                        const = true
                        break
                    end
                end
                if const then
                    pushError {
                        type   = 'SET_CONST',
                        start  = obj.start,
                        finish = obj.finish,
                    }
                end
            end
        else
            obj.type = 'setglobal'
            local node = guide.getLocal(obj, ENVMode, obj.start)
            if node then
                addRef(node, obj)
            end
            local name = obj[1]
            if specials[name] then
                addSpecial(name, obj)
            elseif Options and Options.special then
                local asName = Options.special[name]
                if specials[asName] then
                    addSpecial(asName, obj)
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
            LocalCount = LocalCount + 1
            if LocalCount > LocalLimit then
                pushError {
                    type   = 'LOCAL_LIMIT',
                    start  = obj.start,
                    finish = obj.finish,
                }
            end
        end
        if obj.localfunction then
            obj.localfunction = nil
        end
        Compile(obj.value, obj)
        if obj.value and obj.value.special then
            addSpecial(obj.value.special, obj)
        end
    end,
    ['setfield'] = function (obj)
        Compile(obj.node, obj)
        Compile(obj.value, obj)
    end,
    ['do'] = function (obj)
        local lastBlock = Block
        Block = obj
        CompileBlock(obj, obj)
        if Block.locals then
            LocalCount = LocalCount - #Block.locals
        end
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
        local func = guide.getParentFunction(obj)
        if func then
            if not func.returns then
                func.returns = {}
            end
            func.returns[#func.returns+1] = obj
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
                if Version == 'Lua 5.4'
                or block == guide.getBlock(label) then
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
        if Block.locals then
            LocalCount = LocalCount - #Block.locals
        end
        Block = lastBlock
    end,
    ['elseifblock'] = function (obj)
        local lastBlock = Block
        Block = obj
        Compile(obj.filter, obj)
        CompileBlock(obj, obj)
        if Block.locals then
            LocalCount = LocalCount - #Block.locals
        end
        Block = lastBlock
    end,
    ['elseblock'] = function (obj)
        local lastBlock = Block
        Block = obj
        CompileBlock(obj, obj)
        if Block.locals then
            LocalCount = LocalCount - #Block.locals
        end
        Block = lastBlock
    end,
    ['loop'] = function (obj)
        local lastBlock = Block
        Block = obj
        Compile(obj.loc, obj)
        Compile(obj.max, obj)
        Compile(obj.step, obj)
        CompileBlock(obj, obj)
        if Block.locals then
            LocalCount = LocalCount - #Block.locals
        end
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
        if Block.locals then
            LocalCount = LocalCount - #Block.locals
        end
        Block = lastBlock
    end,
    ['while'] = function (obj)
        local lastBlock = Block
        Block = obj
        Compile(obj.filter, obj)
        CompileBlock(obj, obj)
        if Block.locals then
            LocalCount = LocalCount - #Block.locals
        end
        Block = lastBlock
    end,
    ['repeat'] = function (obj)
        local lastBlock = Block
        Block = obj
        CompileBlock(obj, obj)
        Compile(obj.filter, obj)
        if Block.locals then
            LocalCount = LocalCount - #Block.locals
        end
        Block = lastBlock
    end,
    ['break'] = function (obj)
        local block = guide.getBreakBlock(obj)
        if block then
            if not block.breaks then
                block.breaks = {}
            end
            block.breaks[#block.breaks+1] = obj
        else
            pushError {
                type   = 'BREAK_OUTSIDE',
                start  = obj.start,
                finish = obj.finish,
            }
        end
    end,
    ['main'] = function (obj)
        Block = obj
        Compile({
            type   = 'local',
            start  = 0,
            finish = 0,
            effect = 0,
            tag    = '_ENV',
            special= '_G',
            [1]    = ENVMode,
        }, obj)
        --- _ENV 是上值，不计入局部变量计数
        LocalCount = 0
        CompileBlock(obj, obj)
        Block = nil
    end,
}

function CompileBlock(obj, parent)
    for i = 1, #obj do
        local act = obj[i]
        act.parent = parent
        local f = vmMap[act.type]
        if f then
            f(act)
        end
    end
end

function Compile(obj, parent)
    if not obj then
        return nil
    end
    if Compiled[obj] then
        return
    end
    Compiled[obj] = true
    obj.parent = parent
    local f = vmMap[obj.type]
    if not f then
        return
    end
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
    if not label.ref then
        label.ref = {}
    end
    label.ref[#label.ref+1] = obj
    obj.node = label

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

return function (lua, mode, version, options)
    do
        local state, err = newparser(lua, mode, version, options)
        return state, err
    end
    local state, err = parse(lua, mode, version, options)
    if not state then
        return nil, err
    end
    --if options and options.delay then
    --    options.delay()
    --end
    local clock = os.clock()
    pushError = state.pushError
    ENVMode = state.ENVMode
    Compiled = {}
    GoToTag = {}
    LocalCount = 0
    Version = version
    Root = state.ast
    if Root then
        Root.state = state
    end
    Options = options
    if type(state.ast) == 'table' then
        Compile(state.ast)
    end
    PostCompile()
    state.compileClock = os.clock() - clock
    Compiled = nil
    GoToTag = nil
    return state
end
