local brave          = require 'pub.brave'

local tablePack      = table.pack
local tostring       = tostring
local tableConcat    = table.concat
local debugTraceBack = debug.traceback
local debugGetInfo   = debug.getinfo

_ENV = nil

local function pushLog(level, ...)
    local t = tablePack(...)
    for i = 1, t.n do
        t[i] = tostring(t[i])
    end
    local str = tableConcat(t, '\t', 1, t.n)
    if level == 'error' then
        str = str .. '\n' .. debugTraceBack(nil, 3)
    end
    local info = debugGetInfo(3, 'Sl')
    brave.push('log', {
        msg  = str,
        info = info,
    })
    return str
end

local m = {}

function m.info(...)
    pushLog('info', ...)
end

function m.debug(...)
    pushLog('debug', ...)
end

function m.trace(...)
    pushLog('trace', ...)
end

function m.warn(...)
    pushLog('warn', ...)
end

function m.error(...)
    pushLog('error', ...)
end

return m
