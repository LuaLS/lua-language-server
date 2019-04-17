local tonumber = tonumber
local string_char = string.char
local utf8_char = utf8.char
local type = type

local Errs
local State
local function pushError(err)
    if err.finish < err.start then
        err.finish = err.start
    end
    local last = Errs[#Errs]
    if last then
        if last.start <= err.start and last.finish >= err.finish then
            return
        end
    end
    err.level = err.level or 'error'
    Errs[#Errs+1] = err
end

-- goto 单独处理
local RESERVED = {
    ['and']      = true,
    ['break']    = true,
    ['do']       = true,
    ['else']     = true,
    ['elseif']   = true,
    ['end']      = true,
    ['false']    = true,
    ['for']      = true,
    ['function'] = true,
    ['if']       = true,
    ['in']       = true,
    ['local']    = true,
    ['nil']      = true,
    ['not']      = true,
    ['or']       = true,
    ['repeat']   = true,
    ['return']   = true,
    ['then']     = true,
    ['true']     = true,
    ['until']    = true,
    ['while']    = true,
}

local VersionOp = {
    ['&']  = {'Lua 5.3', 'Lua 5.4'},
    ['~']  = {'Lua 5.3', 'Lua 5.4'},
    ['|']  = {'Lua 5.3', 'Lua 5.4'},
    ['<<'] = {'Lua 5.3', 'Lua 5.4'},
    ['>>'] = {'Lua 5.3', 'Lua 5.4'},
    ['//'] = {'Lua 5.3', 'Lua 5.4'},
}

local function checkOpVersion(op, start)
    local versions = VersionOp[op]
    if not versions then
        return
    end
    for i = 1, #versions do
        if versions[i] == State.Version then
            return
        end
    end
    pushError {
        type = 'UNSUPPORT_SYMBOL',
        start = start,
        finish = start + #op - 1,
        version = versions,
        info = {
            version = State.Version,
        }
    }
end

local Exp

local function expSplit(list, start, finish, level)
    if start == finish then
        return list[start]
    end
    local info = Exp[level]
    if not info then
        return
    end
    local func = info[1]
    return func(list, start, finish, level)
end

local function binaryForward(list, start, finish, level)
    local info = Exp[level]
    for i = finish-1, start+2, -1 do
        local op = list[i]
        if info[op] then
            local e1 = expSplit(list, start, i-2, level)
            if not e1 then
                goto CONTINUE
            end
            local e2 = expSplit(list, i+1, finish, level+1)
            if not e2 then
                goto CONTINUE
            end
            checkOpVersion(op, list[i-1])
            return {
                type   = 'binary',
                op     = op,
                start  = e1.start,
                finish = e2.finish,
                [1]    = e1,
                [2]    = e2,
            }
        end
        ::CONTINUE::
    end
    return expSplit(list, start, finish, level+1)
end

local function binaryBackward(list, start, finish, level)
    local info = Exp[level]
    for i = start+2, finish-1 do
        local op = list[i]
        if info[op] then
            local e1 = expSplit(list, start, i-2, level+1)
            if not e1 then
                goto CONTINUE
            end
            local e2 = expSplit(list, i+1, finish, level)
            if not e2 then
                goto CONTINUE
            end
            checkOpVersion(op, list[i-1])
            return {
                type   = 'binary',
                op     = op,
                start  = e1.start,
                finish = e2.finish,
                [1]    = e1,
                [2]    = e2,
            }
        end
        ::CONTINUE::
    end
    return expSplit(list, start, finish, level+1)
end

local function unary(list, start, finish, level)
    local info = Exp[level]
    local op = list[start+1]
    if info[op] then
        local e1 = expSplit(list, start+2, finish, level)
        if e1 then
            checkOpVersion(op, list[start])
            return {
                type   = 'unary',
                op     = op,
                start  = list[start],
                finish = e1.finish,
                [1]    = e1,
            }
        end
    end
    return expSplit(list, start, finish, level+1)
end

Exp = {
    {
        ['or'] = true,
        binaryForward,
    },
    {
        ['and'] = true,
        binaryForward,
    },
    {
        ['<='] = true,
        ['>='] = true,
        ['<']  = true,
        ['>']  = true,
        ['~='] = true,
        ['=='] = true,
        binaryForward,
    },
    {
        ['|'] = true,
        binaryForward,
    },
    {
        ['~'] = true,
        binaryForward,
    },
    {
        ['&'] = true,
        binaryForward,
    },
    {
        ['<<'] = true,
        ['>>'] = true,
        binaryForward,
    },
    {
        ['..'] = true,
        binaryBackward,
    },
    {
        ['+'] = true,
        ['-'] = true,
        binaryForward,
    },
    {
        ['*']  = true,
        ['//'] = true,
        ['/']  = true,
        ['%']  = true,
        binaryForward,
    },
    {
        ['^'] = true,
        binaryBackward,
    },
    {
        ['not'] = true,
        ['#']   = true,
        ['~']   = true,
        ['-']   = true,
        unary,
    },
}

local Defs = {
    Nil = function (pos)
        return {
            type   = 'nil',
            start  = pos,
            finish = pos + 2,
        }
    end,
    True = function (pos)
        return {
            type   = 'boolean',
            start  = pos,
            finish = pos + 3,
            [1]    = true,
        }
    end,
    False = function (pos)
        return {
            type   = 'boolean',
            start  = pos,
            finish = pos + 4,
            [1]    = false,
        }
    end,
    LongComment = function (beforeEq, afterEq, missPos)
        if missPos then
            pushError {
                type   = 'MISS_SYMBOL',
                start  = missPos,
                finish = missPos,
                info   = {
                    symbol = ']' .. ('='):rep(afterEq-beforeEq) .. ']'
                }
            }
        end
    end,
    String = function (start, str, finish)
        return {
            type   = 'string',
            start  = start,
            finish = finish - 1,
            [1]    = str,
        }
    end,
    LongString = function (beforeEq, afterEq, str, missPos)
        if missPos then
            pushError {
                type   = 'MISS_SYMBOL',
                start  = missPos,
                finish = missPos,
                info   = {
                    symbol = ']' .. ('='):rep(afterEq-beforeEq) .. ']'
                }
            }
        end
        return str
    end,
    Char10 = function (char)
        char = tonumber(char)
        if not char or char < 0 or char > 255 then
            return ''
        end
        return string_char(char)
    end,
    Char16 = function (pos, char)
        if State.Version == 'Lua 5.1' then
            pushError {
                type = 'ERR_ESC',
                start = pos-1,
                finish = pos,
            }
            return char
        end
        return string_char(tonumber(char, 16))
    end,
    CharUtf8 = function (pos, char)
        if  State.Version ~= 'Lua 5.3'
        and State.Version ~= 'Lua 5.4'
        and State.Version ~= 'LuaJIT'
        then
            pushError {
                type = 'ERR_ESC',
                start = pos-3,
                finish = pos-2,
            }
            return char
        end
        if #char == 0 then
            pushError {
                type = 'UTF8_SMALL',
                start = pos-3,
                finish = pos,
            }
            return ''
        end
        local v = tonumber(char, 16)
        if not v then
            for i = 1, #char do
                if not tonumber(char:sub(i, i), 16) then
                    pushError {
                        type = 'MUST_X16',
                        start = pos + i - 1,
                        finish = pos + i - 1,
                    }
                end
            end
            return ''
        end
        if State.Version == 'Lua 5.4' then
            if v < 0 or v > 0x7FFFFFFF then
                pushError {
                    type = 'UTF8_MAX',
                    start = pos-3,
                    finish = pos+#char,
                    info = {
                        min = '00000000',
                        max = '7FFFFFFF',
                    }
                }
            end
        else
            if v < 0 or v > 0x10FFFF then
                pushError {
                    type = 'UTF8_MAX',
                    start = pos-3,
                    finish = pos+#char,
                    version = v <= 0x7FFFFFFF and 'Lua 5.4' or nil,
                    info = {
                        min = '000000',
                        max = '10FFFF',
                    }
                }
            end
        end
        if v >= 0 and v <= 0x10FFFF then
            return utf8_char(v)
        end
        return ''
    end,
    Number = function (start, number, finish)
        local n = tonumber(number)
        if n then
            State.LastNumber = {
                type   = 'number',
                start  = start,
                finish = finish - 1,
                [1]    = n,
            }
            return State.LastNumber
        else
            pushError {
                type   = 'MALFORMED_NUMBER',
                start  = start,
                finish = finish - 1,
            }
            State.LastNumber = {
                type   = 'number',
                start  = start,
                finish = finish - 1,
                [1]    = 0,
            }
            return State.LastNumber
        end
    end,
    FFINumber = function (start, symbol)
        if math.type(State.LastNumber[1]) == 'float' then
            pushError {
                type = 'UNKNOWN_SYMBOL',
                start = start,
                finish = start + #symbol - 1,
                info = {
                    symbol = symbol,
                }
            }
            State.LastNumber[1] = 0
            return
        end
        if State.Version ~= 'LuaJIT' then
            pushError {
                type = 'UNSUPPORT_SYMBOL',
                start = start,
                finish = start + #symbol - 1,
                version = 'LuaJIT',
                info = {
                    version = State.Version,
                }
            }
            State.LastNumber[1] = 0
        end
    end,
    ImaginaryNumber = function (start, symbol)
        if State.Version ~= 'LuaJIT' then
            pushError {
                type = 'UNSUPPORT_SYMBOL',
                start = start,
                finish = start + #symbol - 1,
                version = 'LuaJIT',
                info = {
                    version = State.Version,
                }
            }
        end
        State.LastNumber[1] = 0
    end,
    Name = function (start, str, finish)
        local isKeyWord
        if RESERVED[str] then
            isKeyWord = true
        elseif str == 'goto' then
            if State.Version ~= 'Lua 5.1' and State.Version ~= 'LuaJIT' then
                isKeyWord = true
            end
        end
        if isKeyWord then
            pushError {
                type = 'KEYWORD',
                start = start,
                finish = finish - 1,
            }
        end
        return {
            type   = 'name',
            start  = start,
            finish = finish - 1,
            [1]    = str,
        }
    end,
    Simple = function (first, ...)
        if ... then
            local obj = {
                type = 'simple',
                start = first.start,
                first, ...,
            }
            local last = obj[#obj]
            obj.finish = last.finish
            return obj
        elseif first == '' then
            return nil
        else
            return first
        end
    end,
    SimpleCall = function (simple)
        if not simple then
            return nil
        end
        if simple.type ~= 'simple' then
            pushError {
                type   = 'EXP_IN_ACTION',
                start  = simple.start,
                finish = simple.finish,
            }
            return simple
        end
        local last = simple[#simple]
        if last.type == 'call' then
            return simple
        end
        local colon = simple[#simple-1]
        if colon and colon.type == ':' then
            -- 型如 `obj:method`，将错误让给MISS_SYMBOL
            return simple
        end
        pushError {
            type   = 'EXP_IN_ACTION',
            start  = simple[1].start,
            finish = last.finish,
        }
        return simple
    end,
    Exp = function (first, ...)
        if not ... then
            return first
        end
        local list = {first, ...}
        return expSplit(list, 1, #list, 1)
    end,
    Prefix = function (start, exp, finish)
        return exp
    end,
    Index = function (start, exp, finish)
        return {
            type = 'index',
            start = start,
            finish = finish - 1,
            [1] = exp,
        }
    end,
    Call = function (start, arg, finish)
        if arg == nil then
            return {
                type = 'call',
                start = start,
                finish = finish - 1,
            }
        end
        if arg.type == 'list' then
            arg.type = 'call'
            arg.start = start
            arg.finish = finish - 1
            return arg
        end
        local obj = {
            type = 'call',
            start = start,
            finish = finish - 1,
            [1]  = arg,
        }
        return obj
    end,
    DOTS = function (start)
        return {
            type   = '...',
            start  = start,
            finish = start + 2,
        }
    end,
    COLON = function (start)
        return {
            type   = ':',
            start  = start,
            finish = start,
        }
    end,
    DOT = function (start)
        return {
            type   = '.',
            start  = start,
            finish = start,
        }
    end,
    Function = function (start, arg, ...)
        local obj = {
            type  = 'function',
            start = start,
            arg   = arg,
            ...
        }
        local max = #obj
        obj.finish = obj[max] - 1
        obj[max]   = nil
        return obj
    end,
    NamedFunction = function (start, name, arg, ...)
        local obj = {
            type  = 'function',
            start = start,
            name  = name,
            arg   = arg,
            ...
        }
        local max = #obj
        obj.finish = obj[max] - 1
        obj[max]   = nil
        return obj
    end,
    LocalFunction = function (start, name, arg, ...)
        local obj = {
            type  = 'localfunction',
            start = start,
            name  = name,
            arg   = arg,
            ...
        }
        local max = #obj
        obj.finish = obj[max] - 1
        obj[max]   = nil
        return obj
    end,
    Table = function (start, ...)
        local args = {...}
        local max = #args
        local finish = args[max] - 1
        local table = {
            type   = 'table',
            start  = start,
            finish = finish
        }
        start = start + 1
        local wantField = true
        for i = 1, max-1 do
            local arg = args[i]
            local isField = type(arg) == 'table'
            if wantField and not isField then
                pushError {
                    type = 'MISS_EXP',
                    start = start,
                    finish = arg - 1,
                }
            elseif not wantField and isField then
                pushError {
                    type = 'MISS_SYMBOL',
                    start = start,
                    finish = arg.start-1,
                    info = {
                        symbol = ',',
                    }
                }
            end
            if isField then
                table[#table+1] = arg
                wantField = false
                start = arg.finish + 1
            else
                wantField = true
                start = arg
            end
        end
        return table
    end,
    NewField = function (key, value)
        return {
            type = 'pair',
            start = key.start,
            finish = value.finish,
            key, value,
        }
    end,
    NewIndex = function (start, key, finish, value)
        key.index = true
        return {
            type = 'pair',
            start = key.start,
            finish = value.finish,
            key, value,
        }
    end,
    List = function (first, second, ...)
        if second then
            local list = {
                type = 'list',
                start = first.start,
                first, second, ...
            }
            local last = list[#list]
            list.finish = last.finish
            return list
        elseif first == '' then
            return nil
        else
            return first
        end
    end,
    ArgList = function (...)
        if ... == '' then
            return nil
        end
        local args = table.pack(...)
        local list = {}
        local max = args.n
        args.n = nil
        local wantName = true
        for i = 1, max do
            local obj = args[i]
            if type(obj) == 'number' then
                if wantName then
                    pushError {
                        type = 'MISS_NAME',
                        start = obj,
                        finish = obj,
                    }
                end
                wantName = true
            else
                if not wantName then
                    pushError {
                        type = 'MISS_SYMBOL',
                        start = obj.start-1,
                        finish = obj.start-1,
                        info = {
                            symbol = ',',
                        }
                    }
                end
                wantName = false
                list[#list+1] = obj
                if obj.type == '...' then
                    if i < max then
                        local a = args[i+1]
                        local b = args[max]
                        pushError {
                            type = 'ARGS_AFTER_DOTS',
                            start = type(a) == 'number' and a or a.start,
                            finish = type(b) == 'number' and b or b.finish,
                        }
                    end
                    break
                end
            end
        end
        if wantName then
            local last = args[max]
            pushError {
                type = 'MISS_NAME',
                start = last+1,
                finish = last+1,
            }
        end
        if #list == 0 then
            return nil
        elseif #list == 1 then
            return list[1]
        else
            list.type = 'list'
            list.start = list[1].start
            list.finish = list[#list].finish
            return list
        end
    end,
    CallArgList = function (start, ...)
        local args = {...}
        local max = #args
        local finish = args[max] - 1
        local exps = {
            type = 'list',
            start = start,
            finish = finish,
        }
        local wantExp = true
        for i = 1, max-1 do
            local arg = args[i]
            local isExp = type(arg) == 'table'
            if wantExp and not isExp then
                pushError {
                    type = 'MISS_EXP',
                    start = start,
                    finish = arg - 1,
                }
            elseif not wantExp and isExp then
                pushError {
                    type = 'MISS_SYMBOL',
                    start = start,
                    finish = arg.start-1,
                    info = {
                        symbol = ',',
                    }
                }
            end
            if isExp then
                exps[#exps+1] = arg
                wantExp = false
                start = arg.finish + 1
            else
                wantExp = true
                start = arg
            end
        end
        if wantExp then
            pushError {
                type = 'MISS_EXP',
                start = start,
                finish = finish,
            }
        end
        if #exps == 0 then
            return nil
        elseif #exps == 1 then
            return exps[1]
        else
            return exps
        end
    end,
    Nothing = function ()
        return nil
    end,
    None = function()
        return
    end,
    Skip = function ()
        return false
    end,
    Set = function (keys, values)
        return {
            type = 'set',
            keys, values,
        }
    end,
    ToClose = function (start)
        if State.Version == 'Lua 5.4' then
            return {
                type = 'toclose',
                start = start,
                finish = start + #'*toclose' - 1,
            }
        end
        pushError {
            type = 'UNSUPPORT_SYMBOL',
            start = start,
            finish = start + #'*toclose' - 1,
            version = 'Lua 5.4',
            info = {
                version = State.Version,
            }
        }
        return nil
    end,
    Local = function (toclose, keys, values)
        return {
            type = 'local',
            keys, values, toclose
        }
    end,
    DoBody = function (...)
        if ... == '' then
            return {
                type = 'do',
            }
        else
            return {
                type = 'do',
                ...
            }
        end
    end,
    Do = function (start, action, finish)
        action.start  = start
        action.finish = finish - 1
        return action
    end,
    Break = function (finish, ...)
        if State.Break > 0 then
            local breakChunk = {
                type = 'break',
            }
            if not ... then
                return breakChunk
            end
            local action = select(-1, ...)
            if not action then
                return breakChunk
            end
            if State.Version == 'Lua 5.1' or State.Version == 'LuaJIT' then
                pushError {
                    type = 'ACTION_AFTER_BREAK',
                    start = finish - #'break',
                    finish = finish - 1,
                }
            end
            return breakChunk, action
        else
            pushError {
                type = 'BREAK_OUTSIDE',
                start = finish - #'break',
                finish = finish - 1,
            }
            if not ... then
                return false
            end
            local action = select(-1, ...)
            if not action then
                return false
            end
            return action
        end
    end,
    BreakStart = function ()
        State.Break = State.Break + 1
    end,
    BreakEnd = function ()
        State.Break = State.Break - 1
    end,
    Return = function (start, exp, finish)
        if not finish then
            finish = exp
            exp = {
                type = 'return',
                start = start,
                finish = finish - 1,
            }
        else
            if exp.type == 'list' then
                exp.type = 'return'
                exp.start = start
                exp.finish = finish - 1
            else
                exp = {
                    type = 'return',
                    start = start,
                    finish = finish - 1,
                    [1] = exp,
                }
            end
        end
        return exp
    end,
    Label = function (start, name, finish)
        if State.Version == 'Lua 5.1' then
            pushError {
                type = 'UNSUPPORT_SYMBOL',
                start = start,
                finish = finish - 1,
                version = {'Lua 5.2', 'Lua 5.3', 'Lua 5.4', 'LuaJIT'},
                info = {
                    version = State.Version,
                }
            }
            return false
        end
        name.type = 'label'
        local labels = State.Label[#State.Label]
        local str = name[1]
        if labels[str] then
            --pushError {
            --    type = 'REDEFINE_LABEL',
            --    start = name.start,
            --    finish = name.finish,
            --    info = {
            --        label = str,
            --        related = {labels[str].start, labels[str].finish},
            --    }
            --}
        else
            labels[str] = name
        end
        return name
    end,
    GoTo = function (start, name, finish)
        if State.Version == 'Lua 5.1' then
            pushError {
                type = 'UNSUPPORT_SYMBOL',
                start = start,
                finish = finish - 1,
                version = {'Lua 5.2', 'Lua 5.3', 'Lua 5.4', 'LuaJIT'},
                info = {
                    version = State.Version,
                }
            }
            return false
        end
        name.type = 'goto'
        local labels = State.Label[#State.Label]
        labels[#labels+1] = name
        return name
    end,
    -- TODO 这里的检查不完整，但是完整的检查比较复杂，开销比较高
    -- 不能jump到另一个局部变量的作用域
    -- 函数会切断goto与label
    -- 不能从block外jump到block内，但是可以从block内jump到block外
    LabelStart = function ()
        State.Label[#State.Label+1] = {}
    end,
    LabelEnd = function ()
        local labels = State.Label[#State.Label]
        State.Label[#State.Label] = nil
        for i = 1, #labels do
            local name = labels[i]
            local str = name[1]
            if not labels[str] then
                pushError {
                    type = 'NO_VISIBLE_LABEL',
                    start = name.start,
                    finish = name.finish,
                    info = {
                        label = str,
                    }
                }
            end
        end
    end,
    IfBlock = function (exp, start, ...)
        local obj = {
            filter = exp,
            start  = start,
            ...
        }
        local max = #obj
        obj.finish = obj[max]
        obj[max]   = nil
        return obj
    end,
    ElseIfBlock = function (exp, start, ...)
        local obj = {
            filter = exp,
            start  = start,
            ...
        }
        local max = #obj
        obj.finish = obj[max]
        obj[max]   = nil
        return obj
    end,
    ElseBlock = function (start, ...)
        local obj = {
            start  = start,
            ...
        }
        local max = #obj
        obj.finish = obj[max]
        obj[max]   = nil
        return obj
    end,
    If = function (start, ...)
        local obj = {
            type  = 'if',
            start = start,
            ...
        }
        local max = #obj
        obj.finish = obj[max] - 1
        obj[max]   = nil
        return obj
    end,
    Loop = function (start, arg, min, max, step, ...)
        local obj = {
            type  = 'loop',
            start = start,
            arg   = arg,
            min   = min,
            max   = max,
            step  = step,
            ...
        }
        local max = #obj
        obj.finish = obj[max] - 1
        obj[max]   = nil
        return obj
    end,
    In = function (start, arg, exp, ...)
        local obj = {
            type  = 'in',
            start = start,
            arg   = arg,
            exp   = exp,
            ...
        }
        local max = #obj
        obj.finish = obj[max] - 1
        obj[max]   = nil
        return obj
    end,
    While = function (start, filter, ...)
        local obj = {
            type   = 'while',
            start  = start,
            filter = filter,
            ...
        }
        local max = #obj
        obj.finish = obj[max] - 1
        obj[max]   = nil
        return obj
    end,
    Repeat = function (start, ...)
        local obj = {
            type  = 'repeat',
            start = start,
            ...
        }
        local max = #obj
        obj.finish = obj[max] - 1
        obj.filter = obj[max-1]
        obj[max]   = nil
        obj[max-1] = nil
        return obj
    end,
    Lua = function (...)
        if ... == '' then
            return {}
        end
        return {...}
    end,

    -- EmmyLua 支持
    EmmyName = function (start, str)
        return {
            type   = 'emmyName',
            start  = start,
            finish = start + #str - 1,
            [1]    = str,
        }
    end,
    DirtyEmmyName = function (pos)
        pushError {
            type = 'MISS_NAME',
            start = pos,
            finish = pos,
        }
        return {
            type   = 'emmyName',
            start  = pos,
            finish = pos,
            [1]    = ''
        }
    end,
    EmmyClass = function (class, extends)
        return {
            type = 'emmyClass',
            [1] = class,
            [2] = extends,
        }
    end,
    EmmyType = function (typeDef, ...)
        if ... then
            typeDef.enum = {...}
        end
        return typeDef
    end,
    EmmyCommonType = function (...)
        return {
            type = 'emmyType',
            ...
        }
    end,
    EmmyArrayType = function (typeName)
        typeName.type = 'emmyArrayType'
        return typeName
    end,
    EmmyTableType = function (typeName, keyType, valueType)
        typeName.type = 'emmyTableType'
        typeName[2] = keyType
        typeName[3] = valueType
        return typeName
    end,
    EmmyFunctionType = function (...)
        return {
            type = 'emmyFunctionType',
            ...
        }
    end,
    EmmyAlias = function (name, emmyName)
        return {
            type = 'emmyAlias',
            [1]  = name,
            [2]  = emmyName,
        }
    end,
    EmmyParam = function (argName, emmyName)
        return {
            type = 'emmyParam',
            [1]  = argName,
            [2]  = emmyName,
        }
    end,
    EmmyReturn = function (...)
        return {
            type = 'emmyReturn',
            ...
        }
    end,
    EmmyField = function (access, fieldName, ...)
        return {
            type = 'emmyField',
            access, fieldName,
            ...
        }
    end,
    EmmyGenericBlock = function (genericName, parentName)
        return { genericName, parentName }
    end,
    EmmyGeneric = function (...)
        return {
            type = 'emmyGeneric',
            ...
        }
    end,
    EmmyVararg = function (typeName)
        return {
            type = 'emmyVararg',
            typeName,
        }
    end,
    EmmyLanguage = function (language)
        return {
            type = 'emmyLanguage',
            language,
        }
    end,
    EmmySee = function (className, methodName)
        return {
            type = 'emmySee',
            className, methodName
        }
    end,

    -- 捕获错误
    UnknownSymbol = function (start, symbol)
        pushError {
            type = 'UNKNOWN_SYMBOL',
            start = start,
            finish = start + #symbol - 1,
            info = {
                symbol = symbol,
            }
        }
        return false
    end,
    DirtyName = function (pos)
        pushError {
            type = 'MISS_NAME',
            start = pos,
            finish = pos,
        }
        return {
            type   = 'name',
            start  = pos,
            finish = pos,
            [1]    = ''
        }
    end,
    DirtyExp = function (pos)
        pushError {
            type = 'MISS_EXP',
            start = pos,
            finish = pos,
        }
        return {
            type   = 'name',
            start  = pos,
            finish = pos,
            [1]    = ''
        }
    end,
    MissExp = function (pos)
        pushError {
            type = 'MISS_EXP',
            start = pos,
            finish = pos,
        }
    end,
    MissExponent = function (start, finish)
        pushError {
            type = 'MISS_EXPONENT',
            start = start,
            finish = finish - 1,
        }
    end,
    MissQuote1 = function (pos)
        pushError {
            type = 'MISS_SYMBOL',
            start = pos,
            finish = pos,
            info = {
                symbol = '"'
            }
        }
    end,
    MissQuote2 = function (pos)
        pushError {
            type = 'MISS_SYMBOL',
            start = pos,
            finish = pos,
            info = {
                symbol = "'"
            }
        }
    end,
    MissEscX = function (pos)
        pushError {
            type = 'MISS_ESC_X',
            start = pos-2,
            finish = pos+1,
        }
    end,
    MissTL = function (pos)
        pushError {
            type = 'MISS_SYMBOL',
            start = pos,
            finish = pos,
            info = {
                symbol = '{',
            }
        }
    end,
    MissTR = function (pos)
        pushError {
            type = 'MISS_SYMBOL',
            start = pos,
            finish = pos,
            info = {
                symbol = '}',
            }
        }
        return pos + 1
    end,
    MissBR = function (pos)
        pushError {
            type = 'MISS_SYMBOL',
            start = pos,
            finish = pos,
            info = {
                symbol = ']',
            }
        }
        return pos + 1
    end,
    MissPL = function (pos)
        pushError {
            type = 'MISS_SYMBOL',
            start = pos,
            finish = pos,
            info = {
                symbol = '(',
            }
        }
    end,
    DirtyPR = function (pos)
        pushError {
            type = 'MISS_SYMBOL',
            start = pos,
            finish = pos,
            info = {
                symbol = ')',
            }
        }
        return pos + 1
    end,
    MissPR = function (pos)
        pushError {
            type = 'MISS_SYMBOL',
            start = pos,
            finish = pos,
            info = {
                symbol = ')',
            }
        }
    end,
    ErrEsc = function (pos)
        pushError {
            type = 'ERR_ESC',
            start = pos-1,
            finish = pos,
        }
    end,
    MustX16 = function (pos, str)
        pushError {
            type = 'MUST_X16',
            start = pos,
            finish = pos + #str - 1,
        }
    end,
    MissAssign = function (pos)
        pushError {
            type = 'MISS_SYMBOL',
            start = pos,
            finish = pos,
            info = {
                symbol = '=',
            }
        }
    end,
    MissTableSep = function (pos)
        pushError {
            type = 'MISS_SYMBOL',
            start = pos,
            finish = pos,
            info = {
                symbol = ','
            }
        }
    end,
    MissField = function (pos)
        pushError {
            type = 'MISS_FIELD',
            start = pos,
            finish = pos,
        }
    end,
    MissMethod = function (pos)
        pushError {
            type = 'MISS_METHOD',
            start = pos,
            finish = pos,
        }
    end,
    MissLabel = function (pos)
        pushError {
            type = 'MISS_SYMBOL',
            start = pos,
            finish = pos,
            info = {
                symbol = '::',
            }
        }
    end,
    MissEnd = function (pos)
        pushError {
            type = 'MISS_SYMBOL',
            start = pos,
            finish = pos,
            info = {
                symbol = 'end',
            }
        }
    end,
    MissDo = function (pos)
        pushError {
            type = 'MISS_SYMBOL',
            start = pos,
            finish = pos,
            info = {
                symbol = 'do',
            }
        }
    end,
    MissComma = function (pos)
        pushError {
            type = 'MISS_SYMBOL',
            start = pos,
            finish = pos,
            info = {
                symbol = ',',
            }
        }
    end,
    MissIn = function (pos)
        pushError {
            type = 'MISS_SYMBOL',
            start = pos,
            finish = pos,
            info = {
                symbol = 'in',
            }
        }
    end,
    MissUntil = function (pos)
        pushError {
            type = 'MISS_SYMBOL',
            start = pos,
            finish = pos,
            info = {
                symbol = 'until',
            }
        }
    end,
    MissThen = function (pos)
        pushError {
            type = 'MISS_SYMBOL',
            start = pos,
            finish = pos,
            info = {
                symbol = 'then',
            }
        }
    end,
    ExpInAction = function (start, exp, finish)
        pushError {
            type = 'EXP_IN_ACTION',
            start = start,
            finish = finish - 1,
        }
        return exp
    end,
    AfterReturn = function (rtn, ...)
        if not ... then
            return rtn
        end
        local action = select(-1, ...)
        if not action then
            return rtn
        end
        pushError {
            type = 'ACTION_AFTER_RETURN',
            start = rtn.start,
            finish = rtn.finish,
        }
        return rtn, action
    end,
}

return function (self, lua, mode, version)
    Errs = {}
    State= {
        Break = 0,
        Label = {{}},
        Version = version,
    }
    local suc, res, err = pcall(self.grammar, lua, mode, Defs)
    if not suc then
        return nil, res
    end
    if not res then
        pushError(err)
        return nil, Errs
    end
    return res, Errs
end
