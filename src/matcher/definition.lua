local parser = require 'parser'

local pos
local defs = {}
local scopes
local result

local function getResult(name, p)
    result = {name, p}
    for k in pairs(defs) do
        defs[k] = nil
    end
end

local function scopeInit()
    scopes = {{}}
end

local function scopeSet(name, p)
    local scope = scopes[#scopes]
    scope[name] = p
end

local function scopeGet(name)
    local scope = scopes[#scopes]
    return scope[name]
end

local function checkDifinition(name, p)
    if pos < p or pos > p + #name then
        return
    end
    getResult(name, scopeGet(name))
end

function defs.Name(p, name)
    checkDifinition(name, p)
    return name
end

function defs.LocalVar(p, name)
    scopeSet(name, p)
end

return function (buf, pos_)
    pos = pos_
    scopeInit()
    parser.grammar(buf, 'Lua', defs)

    if not result then
        return nil
    end
    local name, start = result[1], result[2]
    if not start then
        return nil
    end
    return start, start + #name - 1
end
