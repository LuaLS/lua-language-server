local tonumber = tonumber
local string_char = string.char
local utf8_char = utf8.char

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
    CharUtf8 = function (char)
        char = tonumber(char, 16)
        if not char or char < 0 or char > 0x10ffff then
            -- TODO 记录错误
            return ''
        end
        return utf8_char(char)
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
    DirtyName = function (pos)
        return {
            type   = 'name',
            start  = pos,
            finish = pos,
            [1]    = ''
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
    Index = function (exp)
        exp.index = true
        return exp
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
        local e1, op = ...
        if not op then
            return e1
        end
        local args = {...}
        local e1 = args[#args]
        for i = #args - 1, 1, -1 do
            op = args[i]
            e1 = {
                type   = 'unary',
                op     = op,
                start  = e1.start,
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
    Table = function (start, table, finish)
        if table then
            table.start  = start
            table.finish = finish - 1
        else
            table = {
                type   = 'table',
                start  = start,
                finish = finish - 1,
            }
        end
        return table
    end,
    TableFields = function (...)
        if ... == '' then
            return nil
        else
            return {
                type = 'table',
                ...,
            }
        end
    end,
    NewField = function (key, value)
        return {
            type = 'pair',
            key, value,
        }
    end,
    NewIndex = function (key, value)
        key.index = true
        return {
            type = 'pair',
            key, value,
        }
    end,
    List = function (first, second, ...)
        if second then
            return {
                type = 'list',
                first, second, ...
            }
        elseif first == '' then
            return nil
        else
            return first
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
}

return function (self, lua, mode)
    local suc, res, err = pcall(self.grammar, lua, mode, defs)
    if not suc then
        return nil, res
    end
    if not res then
        return nil, {err}
    end
    return res
end
