local fs = require 'bee.filesystem'

local log = {}

log.file = nil
log.start_time = os.time() - os.clock()
log.size = 0
log.max_size = 100 * 1024 * 1024

local function trim_src(src)
    src = src:sub(log.prefix_len + 3, -5)
    src = src:gsub('^[/\\]+', '')
    src = src:gsub('[\\/]+', '.')
    return src
end

local function init_log_file()
    if not log.file then
        log.file = io.open(log.path, 'w')
        if not log.file then
            return
        end
        log.file:write('')
        log.file:close()
        log.file = io.open(log.path, 'ab')
        if not log.file then
            return
        end
        log.file:setvbuf 'no'
    end
end

local function push_log(level, ...)
    if not log.path then
        return
    end
    if log.size > log.max_size then
        return
    end
    local t = table.pack(...)
    for i = 1, t.n do
        t[i] = tostring(t[i])
    end
    local str = table.concat(t, '\t', 1, t.n)
    if level == 'error' then
        str = str .. '\n' .. debug.traceback(nil, 3)
        io.stderr:write(str .. '\n')
    end
    init_log_file()
    if not log.file then
        return
    end
    local sec, ms = math.modf(log.start_time + os.clock())
    local timestr = os.date('%Y-%m-%d %H:%M:%S', sec)
    local info = debug.getinfo(3, 'Sl')
    local buf
    if info and info.currentline > 0 then
        buf = ('[%s.%03.f][%s][%s:%s]: %s\n'):format(timestr, ms * 1000, level, trim_src(info.source), info.currentline, str)
    else
        buf = ('[%s.%03.f][%s]: %s\n'):format(timestr, ms * 1000, level, str)
    end
    log.file:write(buf)
    log.size = log.size + #buf
    if log.size > log.max_size then
        log.file:write('[REACH MAX SIZE]')
    end
    return str
end

function log.info(...)
    push_log('info', ...)
end

function log.debug(...)
    push_log('debug', ...)
end

function log.trace(...)
    push_log('trace', ...)
end

function log.warn(...)
    push_log('warn', ...)
end

function log.error(...)
    return push_log('error', ...)
end

function log.init(root, path)
    local lastBuf
    if log.file then
        log.file:close()
        log.file = nil
        local file = io.open(log.path, 'rb')
        if file then
            lastBuf = file:read 'a'
            file:close()
        end
    end
    log.path = path:string()
    log.prefix_len = #root:string()
    log.size = 0
    if not fs.exists(path:parent_path()) then
        fs.create_directories(path:parent_path())
    end
    if lastBuf then
        init_log_file()
        if log.file then
            log.file:write(lastBuf)
            log.size = log.size + #lastBuf
        end
    end
end

return log
