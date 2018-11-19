local parser = require 'parser'

local pos
local defs = {}
local scopes
local result
local namePos
local colonPos

local DUMMY_TABLE = {}

local function scopeInit()
    scopes = {{}}
end

local function scopeSet(obj)
    local scope = scopes[#scopes]
    local name = obj[1]
    scope[name] = obj
end

local function scopeGet(name)
    for i = #scopes, 1, -1 do
        local scope = scopes[i]
        local obj = scope[name]
        if obj then
            return obj
        end
    end
    return nil
end

local function scopePush()
    scopes[#scopes+1] = {}
end

local function scopePop()
    scopes[#scopes] = nil
end

local function checkDifinition(name, p)
    if pos < p or pos > p + #name then
        return
    end
    result = scopeGet(name)
end

function defs.NamePos(p)
    namePos = p
end

function defs.Name(str)
    checkDifinition(str, namePos)
    return {str, namePos}
end

function defs.DOTSPos(p)
    namePos = p
end

function defs.DOTS(str)
    checkDifinition(str, namePos)
    return {str, namePos}
end

function defs.COLONPos(p)
    colonPos = p
end

function defs.ColonName(name)
    name.colon = colonPos
    return name
end

function defs.LocalVar(names)
    for _, name in ipairs(names) do
        scopeSet(name)
    end
end

function defs.LocalSet(names)
    for _, name in ipairs(names) do
        scopeSet(name)
    end
end

function defs.ArgList(...)
    if ... == '' then
        return DUMMY_TABLE
    end
    return {...}
end

function defs.FuncName(...)
    if ... == '' then
        return DUMMY_TABLE
    end
    return {...}
end

function defs.FunctionDef(names, args)
    if #names == 1 then
        scopeSet(names[1])
    end
    scopePush()
    -- 判断隐藏的局部变量self
    if #names > 0 then
        local name = names[#names]
        if name.colon then
            scopeSet {'self', name.colon, name.colon}
        end
    end
    for _, arg in ipairs(args) do
        scopeSet(arg)
    end
end

function defs.Function()
    scopePop()
end

function defs.DoDef()
    scopePush()
end

function defs.Do()
    scopePop()
end

function defs.IfDef()
    scopePush()
end

function defs.If()
    scopePop()
end

function defs.ElseIfDef()
    scopePush()
end

function defs.ElseIf()
    scopePop()
end

function defs.ElseDef()
    scopePush()
end

function defs.Else()
    scopePop()
end

function defs.LoopDef(name)
    scopePush()
    scopeSet(name)
end

function defs.Loop()
    scopePop()
end

function defs.LoopStart(name, exp)
    return name
end

function defs.NameList(...)
    return {...}
end

function defs.InDef(names)
    scopePush()
    for _, name in ipairs(names) do
        scopeSet(name)
    end
end

function defs.In()
    scopePop()
end

function defs.WhileDef()
    scopePush()
end

function defs.While()
    scopePop()
end

function defs.RepeatDef()
    scopePush()
end

function defs.Until()
    scopePop()
end

return function (buf, pos_)
    pos = pos_
    result = nil
    scopeInit()

    local suc, err = parser.grammar(buf, 'Lua', defs)
    if not suc then
        return false, '语法错误', err
    end

    if not result then
        return false, 'No word'
    end
    local name, start, finish = result[1], result[2], result[3]
    if not start then
        return false, 'No match'
    end
    if not finish then
        finish = start + #name - 1
    end
    return true, start, finish
end
