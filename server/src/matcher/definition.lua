local parser = require 'parser'

local pos
local defs = {}
local scopes
local result
local namePos
local nameFinishPos
local colonPos

local DUMMY_TABLE = {}

local function scopeInit()
    scopes = {{}}
end

local function scopeLocal(obj)
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

local function scopeSet(obj)
    local name = obj[1]
    if not scopeGet(name) then
        local scope = scopes[1]
        scope[name] = obj
    end
end

local function scopeGetTable(parent, name)
    if not parent then
        return nil
    end
    if not parent.child then
        return nil
    end
    if not parent.child[name] then
        return nil
    end
    return parent.child[name]
end

local function scopeSetTable(parent, obj)
    if not parent then
        return
    end
    local name = obj[1]
    if not parent.child then
        parent.child = {}
    end
    if not parent.child[name] then
        parent.child[name] = obj
    end
end

local function scopeSetSimple(simple)
    if simple.type ~= 'simple' then
        return
    end
    scopeSet(simple[1])
    local tbl = scopeGet(simple[1][1])
    for i = 2, #simple - 1 do
        tbl = scopeGetTable(tbl, simple[i][1])
    end
    scopeSetTable(tbl, simple[#simple])
end

local function scopeGetSimple(simple, index)
    if simple.type ~= 'simple' then
        return
    end
    if not index then
        index = #simple
    end
    local tbl = scopeGet(simple[1][1])
    for i = 2, index do
        tbl = scopeGetTable(tbl, simple[i][1])
    end
    return tbl
end

local function scopePush()
    scopes[#scopes+1] = {}
end

local function scopePop()
    scopes[#scopes] = nil
end

local function checkName(obj)
    local name = obj[1]
    local start = obj[2]
    local str = obj.string or name
    local finish = obj[3] or (start + #str)
    if pos < start or pos > finish then
        return
    end
    result = {
        type = 'name',
        object = scopeGet(name),
    }
end

local function checkSimple(simple)
    if simple.type ~= 'simple' then
        return
    end
    for i = 2, #simple do
        local obj = simple[i]
        if obj.type == 'name' then
            local name = obj[1]
            local start = obj[2]
            local str = obj.string or name
            local finish = obj[3] or (start + #str)
            if pos >= start and pos <= finish then
                result = {
                    type = 'simple',
                    table = scopeGetSimple(simple, i-1),
                    name = name,
                }
            end
        end
    end
end

function defs.NamePos(p)
    namePos = p
end

function defs.Name(str)
    local obj = {'STRING|' .. str, namePos, string = str, type = 'name'}
    checkName(obj)
    return obj
end

function defs.TRUE(p)
    local obj = {'true', p, type = 'name'}
    return obj
end

function defs.FALSE(p)
    local obj = {'false', p, type = 'name'}
    return obj
end

function defs.NumberPos(p)
    namePos = p
end

function defs.Number(str)
    local dump = ('%q'):format(tonumber(str))
    local obj = {'NUMBER|' .. dump, namePos, string = str, type = 'name'}
    return obj
end

function defs.String(start, str, finish)
    local obj = {
        'STRING|' .. str,
        start,
        finish-1,
        string = str,
        type = 'name'
    }
    return obj
end

function defs.DOTSPos(p)
    namePos = p
end

function defs.DOTS()
    local obj = {'...', namePos, type = 'name'}
    checkName(obj)
    return obj
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
        scopeLocal(name)
    end
end

function defs.LocalSet(names)
    for _, name in ipairs(names) do
        scopeLocal(name)
    end
end

function defs.Set(simples)
    for _, simple in ipairs(simples) do
        if simple.type == 'simple' then
            scopeSetSimple(simple)
        end
    end
end

function defs.Simple(...)
    local simple = { type = 'simple', ... }
    checkSimple(simple)
    return simple
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
    scopeSetSimple(simple)
    scopePush()
    -- 判断隐藏的局部变量self
    if #simple > 0 then
        local name = simple[#simple]
        if name.colon then
            scopeLocal {
                'STRING|self',
                name.colon,
                name.colon,
                string = 'self',
                type = 'name'
            }
        end
    end
    for _, arg in ipairs(args) do
        if arg.type == 'simple' and #arg == 1 then
            local name = arg[1]
            scopeLocal(name)
        end
        if arg.type == 'name' then
            scopeLocal(arg)
        end
    end
end

function defs.FunctionLoc(simple, args)
    if #simple == 1 then
        scopeLocal(simple[1])
    end
    scopePush()
    -- 判断隐藏的局部变量self
    if #simple > 0 then
        local name = simple[#simple]
        if name.colon then
            scopeLocal {
                'STRING|self',
                name.colon,
                name.colon,
                string = 'self',
                type = 'name'
            }
        end
    end
    for _, arg in ipairs(args) do
        if arg.type == 'simple' and #arg == 1 then
            local name = arg[1]
            scopeLocal(name)
        end
        if arg.type == 'name' then
            scopeLocal(arg)
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
    scopeLocal(name)
end

function defs.Loop()
    scopePop()
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
    scopePush()
    for _, name in ipairs(names) do
        scopeLocal(name)
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

local function parseResult(callback)
    local obj
    if result.type == 'name' then
        obj = result.object
    elseif result.type == 'simple' then
        local tbl = result.table
        local name = result.name
        obj = scopeGetTable(tbl, name)
    end

    if not obj then
        return
    end
    
    local str, start, finish = (obj.string or obj[1]), obj[2], obj[3]
    if not start then
        return
    end
    if not finish then
        finish = start + #str - 1
    end
    callback(start, finish)
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

    local list = {}
    parseResult(function (start, finish)
        list[#list+1] = {start, finish}
    end)

    if #list == 0 then
        return false, 'No match'
    end

    return true, list[1][1], list[1][2]
end
