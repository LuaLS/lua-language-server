local parser = require 'parser'

local pos
local defs = {}
local scopes
local logics
local result
local namePos
local colonPos

local DUMMY_TABLE = {}

local function logicPush()
    logics[#logics+1] = 0
end

local function logicPop()
    logics[#logics] = nil
end

local function logicAdd()
    logics[#logics] = logics[#logics] + 1
end

local function logicGet()
    local list = {}
    for i = 1, #logics do
        list[i] = logics[i]
    end
    return list
end

local function scopeInit()
    scopes = {{}}
end

local function scopeGet(name)
    for i = #scopes, 1, -1 do
        local scope = scopes[i]
        local list = scope[name]
        if list then
            return list
        end
    end
    return nil
end

local function scopeSet(obj)
    obj.logic = logicGet()
    local name = obj[1]
    local scope = scopes[#scopes]
    local list = scope[name]
    if list then
        list[#list+1] = obj
    else
        scope[name] = {obj}
    end
end

local function scopePush()
    scopes[#scopes+1] = {}
end

local function scopePop()
    scopes[#scopes] = nil
end

local function globalSet(obj)
    obj.logic = logicGet()
    local name = obj[1]
    for i = #scopes, 1, -1 do
        local scope = scopes[i]
        local list = scope[name]
        if list then
            list[#list+1] = obj
            return
        end
    end
    local scope = scopes[1]
    scope[name] = {obj}
end

local function sameLogic(cur, target)
    for i = 1, #cur do
        if target[i] == nil then
            break
        end
        if cur[i] ~= target[i] then
            return false
        end
    end
    return true
end

local function mustCovered(results, target)
    for _, result in ipairs(results) do
        local logic = result.logic
        if #logic == #target then
            local isSame = true
            for i = 1, #logic do
                if logic[i] ~= target[i] then
                    isSame = false
                end
            end
            if isSame then
                return true
            end
        end
    end
    return false
end

local function checkImplementation(name, p)
    if result ~= nil then
        return
    end
    if pos < p or pos > p + #name then
        return
    end
    local list = scopeGet(name)
    if list then
        local logic = logicGet()
        result = {}
        for i = #list, 1, -1 do
            local obj = list[i]
            local name, start, finish = obj[1], obj[2], obj[3]
            if not finish then
                finish = start + #name - 1
            end
            -- 如果不在同一个分支里，则跳过
            if not sameLogic(logic, obj.logic) then
                goto CONTINUE
            end
            -- 如果该分支已经有确定值，则跳过
            if mustCovered(result, obj.logic) then
                goto CONTINUE
            end
            result[#result+1] = {start, finish, logic = obj.logic}
            -- 如果分支长度比自己小，则一定是确信值，不用再继续找了
            if #obj.logic <= #logic then
                break
            end
            ::CONTINUE::
        end
    else
        result = false
    end
end

function defs.NamePos(p)
    namePos = p
end

function defs.Name(str)
    checkImplementation(str, namePos)
    return {str, namePos, type = 'name'}
end

function defs.DOTSPos(p)
    namePos = p
end

function defs.DOTS(str)
    checkImplementation(str, namePos)
    return {str, namePos, type = 'name'}
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

function defs.Set(simples)
    for _, simple in ipairs(simples) do
        if simple.type == 'simple' and #simple == 1 then
            local obj = simple[1]
            local name = obj[1]
            globalSet(obj)
        end
    end
end

function defs.Simple(...)
    return { type = 'simple', ... }
end

function defs.ArgList(...)
    if ... == '' then
        return DUMMY_TABLE
    end
    return { type = 'list', ... }
end

function defs.FuncName(...)
    if ... == '' then
        return DUMMY_TABLE
    end
    return { type = 'simple', ... }
end

function defs.FunctionDef(simple, args)
    if #simple == 1 then
        globalSet(simple[1])
    end
    scopePush()
    -- 判断隐藏的局部变量self
    if #simple > 0 then
        local name = simple[#simple]
        if name.colon then
            scopeSet {'self', name.colon, name.colon, type = 'name'}
        end
    end
    for _, arg in ipairs(args) do
        if arg.type == 'simple' and #arg == 1 then
            local name = arg[1]
            scopeSet(name)
        end
        if arg.type == 'name' then
            scopeSet(arg)
        end
    end
end

function defs.FunctionLoc(simple, args)
    if #simple == 1 then
        scopeSet(simple[1])
    end
    scopePush()
    -- 判断隐藏的局部变量self
    if #simple > 0 then
        local name = simple[#simple]
        if name.colon then
            scopeSet {'self', name.colon, name.colon, type = 'name'}
        end
    end
    for _, arg in ipairs(args) do
        if arg.type == 'simple' and #arg == 1 then
            local name = arg[1]
            scopeSet(name)
        end
        if arg.type == 'name' then
            scopeSet(arg)
        end
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
    logicPush()
    scopePush()
end

function defs.If()
    scopePop()
end

function defs.ElseIfDef()
    logicAdd()
    scopePush()
end

function defs.ElseIf()
    scopePop()
end

function defs.ElseDef()
    logicAdd()
    scopePush()
end

function defs.Else()
    scopePop()
end

function defs.EndIf()
    logicPop()
end

function defs.LoopDef(name)
    logicPush()
    scopePush()
    scopeSet(name)
end

function defs.Loop()
    scopePop()
    logicPop()
end

function defs.LoopStart(name, exp)
    return name
end

function defs.NameList(...)
    return { type = 'list', ... }
end

function defs.SimpleList(...)
    return { type = 'list', ... }
end

function defs.InDef(names)
    logicPush()
    scopePush()
    for _, name in ipairs(names) do
        scopeSet(name)
    end
end

function defs.In()
    scopePop()
    logicPop()
end

function defs.WhileDef()
    logicPush()
    scopePush()
end

function defs.While()
    scopePop()
    logicPop()
end

function defs.RepeatDef()
    logicPush()
    scopePush()
end

function defs.Until()
    scopePop()
    logicPop()
end

return function (buf, pos_)
    pos = pos_
    result = nil
    logics = {}
    scopeInit()

    local suc, err = parser.grammar(buf, 'Lua', defs)
    if not suc then
        return false, '语法错误', err
    end

    if not result then
        return false, 'No word'
    end
    return true, result
end
