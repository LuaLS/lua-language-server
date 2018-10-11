local parser = require 'parser'

local pos
local defs = {}
local scopes
local result

local function getResult(name, p)
    result = {name, p}
end

local function scopeInit()
    scopes = {{}}
end

local function scopeSet(name, p)
    local scope = scopes[#scopes]
    scope[name] = p
end

local function scopeGet(name)
    for i = #scopes, 1, -1 do
        local scope = scopes[i]
        local p = scope[name]
        if p then
            return p
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
    getResult(name, scopeGet(name))
end

function defs.Name(p, str)
    checkDifinition(str, p)
    return {str, p}
end

function defs.LocalVar(name)
    scopeSet(name[1], name[2])
end

function defs.LocalSet(name)
    scopeSet(name[1], name[2])
end

function defs.Function(func)
    local names = func.name
    if names and #names == 1 then
        local name = names[1]
        scopeSet(name[1], name[2])
    end
    return func
end

function defs.DoStart()
    scopePush()
end

function defs.Do()
    scopePop()
end

function defs.IfStart()
    scopePush()
end

function defs.If()
    scopePop()
end

function defs.ElseIfStart()
    scopePush()
end

function defs.ElseIf()
    scopePop()
end

function defs.ElseStart()
    scopePush()
end

function defs.Else()
    scopePop()
end

return function (buf, pos_)
    pos = pos_
    result = nil
    scopeInit()

    parser.grammar(buf, 'Lua', defs)

    if not result then
        return false, 'No word'
    end
    local name, start = result[1], result[2]
    if not start then
        return false, 'No match'
    end
    return true, start, start + #name - 1
end
