local fs             = require 'bee.filesystem'
local time           = require 'bee.time'

local monotonic      = time.monotonic
local osDate         = os.date
local ioOpen         = io.open
local tablePack      = table.pack
local tableConcat    = table.concat
local tostring       = tostring
local debugTraceBack = debug.traceback
local mathModf       = math.modf
local debugGetInfo   = debug.getinfo
local ioStdErr       = io.stderr

_ENV = nil

local m = {}

m.file = nil
m.startTime = time.time() - monotonic()
m.size = 0
m.maxSize = 100 * 1024 * 1024

local function trimSrc(src)
    if src:sub(1, 1) == '@' then
        src = src:sub(2)
    end
    return src
end

local function init_log_file()
    if not m.file then
        m.file = ioOpen(m.path, 'w')
        if not m.file then
            return
        end
        m.file:write('')
        m.file:close()
        m.file = ioOpen(m.path, 'ab')
        if not m.file then
            return
        end
        m.file:setvbuf 'no'
    end
end

local function pushLog(level, ...)
    if not m.path then
        return
    end
    local t = tablePack(...)
    for i = 1, t.n do
        t[i] = tostring(t[i])
    end
    local str = tableConcat(t, '\t', 1, t.n)
    if level == 'error' then
        str = str .. '\n' .. debugTraceBack(nil, 3)
    end
    local info = debugGetInfo(3, 'Sl')
    return m.raw(0, level, str, info.source, info.currentline, monotonic())
end

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
    return pushLog('error', ...)
end

function m.raw(thd, level, msg, source, currentline, clock)
    if level == 'error' then
        ioStdErr:write(msg .. '\n')
        if not m.firstError then
            m.firstError = msg
        end
    end
    if m.size > m.maxSize then
        return
    end
    init_log_file()
    if not m.file then
        return ''
    end
    local sec, ms = mathModf((m.startTime + clock) / 1000)
    local timestr = osDate('%H:%M:%S', sec)
    local agl = ''
    if #level < 5 then
        agl = (' '):rep(5 - #level)
    end
    local buf
    if currentline == -1 then
        buf = ('[%s.%03.f][%s]%s[#%d]: %s\n'):format(timestr, ms * 1000, level, agl, thd, msg)
    else
        buf = ('[%s.%03.f][%s]%s[#%d:%s:%s]: %s\n'):format(timestr, ms * 1000, level, agl, thd, trimSrc(source), currentline, msg)
    end
    m.size = m.size + #buf
    if m.size > m.maxSize then
        m.file:write(buf:sub(1, m.size - m.maxSize))
        m.file:write('[REACH MAX SIZE]')
    else
        m.file:write(buf)
    end
    return buf
end

function m.init(root, path)
    local lastBuf
    if m.file then
        m.file:close()
        m.file = nil
        local file = ioOpen(m.path, 'rb')
        if file then
            lastBuf = file:read(m.maxSize)
            file:close()
        end
    end
    m.path = path:string()
    m.prefixLen = #root:string()
    m.size = 0
    if not fs.exists(path:parent_path()) then
        fs.create_directories(path:parent_path())
    end
    if lastBuf then
        init_log_file()
        if m.file then
            m.file:write(lastBuf)
            m.size = m.size + #lastBuf
        end
    end
end

return m
