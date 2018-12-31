local tonumber = tonumber
local string_char = string.char
local utf8_char = utf8.char
local type = type

local Errs
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

local defs = {
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
            -- TODO 记录错误
            return ''
        end
        return string_char(char)
    end,
    Char16 = function (char)
        return string_char(tonumber(char, 16))
    end,
    CharUtf8 = function (pos, char)
        if #char == 0 then
            pushError {
                type = 'UTF8_SMALL',
                start = pos-3,
                finish = pos,
            }
            return ''
        end
        if #char > 6 then
            pushError {
                type = 'UTF8_LARGE',
                start = pos-3,
                finish = pos+#char,
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
        if v < 0 or v > 0x10ffff then
            pushError {
                type = 'UTF8_MAX',
                start = pos-3,
                finish = pos+#char,
                info = {
                    min = '000000',
                    max = '10ffff',
                }
            }
            return ''
        end
        return utf8_char(v)
    end,
    Number = function (start, number, finish)
        return {
            type   = 'number',
            start  = start,
            finish = finish - 1,
            [1]    = tonumber(number),
        }
    end,
    Name = function (start, str, finish)
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
    Binary = function (...)
        local e1, op = ...
        if not op then
            return e1
        end
        local args = {...}
        local e1 = args[1]
        local e2
        for i = 2, #args, 2 do
            op, e2 = args[i], args[i+1]
            e1 = {
                type   = 'binary',
                op     = op,
                start  = e1.start,
                finish = e2.finish,
                [1]    = e1,
                [2]    = e2,
            }
        end
        return e1
    end,
    Unary = function (...)
        local args = {...}
        local e1 = args[#args]
        for i = #args - 1, 1, -2 do
            local start = args[i-1]
            local op = args[i]
            e1 = {
                type   = 'unary',
                op     = op,
                start  = start,
                finish = e1.finish,
                [1]    = e1,
            }
        end
        return e1
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
    Function = function (start, name, arg, ...)
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
    Set = function (keys, values)
        return {
            type = 'set',
            keys, values,
        }
    end,
    Local = function (keys, values)
        return {
            type = 'local',
            keys, values,
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
    Break = function ()
        return {
            type = 'break',
        }
    end,
    Return = function (exp)
        if exp == nil or exp == '' then
            exp = {
                type = 'return'
            }
        else
            if exp.type == 'list' then
                exp.type = 'return'
            else
                exp = {
                    type = 'return',
                    [1] = exp,
                }
            end
        end
        return exp
    end,
    Label = function (name)
        name.type = 'label'
        return name
    end,
    GoTo = function (name)
        name.type = 'goto'
        return name
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
    MissPR = function (pos)
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
}

return function (self, lua, mode)
    Errs = {}
    local suc, res, err = pcall(self.grammar, lua, mode, defs)
    if not suc then
        return nil, res
    end
    if not res then
        pushError(err)
        return nil, Errs
    end
    return res, Errs
end
