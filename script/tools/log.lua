---@class Log
---@field private file? file*
---@field private option Log.Option
---@field private logLevel table<Log.Level, integer>
---@field private needTraceBack table<Log.Level, boolean>
---@field trace fun(...): string, string
---@field debug fun(...): string, string
---@field info  fun(...): string, string
---@field warn  fun(...): string, string
---@field error fun(...): string, string
---@field fatal fun(...): string, string
---@overload fun(option: Log.Option): Log
local M = Class 'Log'

-- 设置日志文件的最大大小
M.maxSize = 100 * 1024 * 1024

---@private
M.usedSize = 0

---@type Log.Level
M.level = 'debug'

---@private
M.clock = os.clock

---@private
M.time = os.time

---@private
M.messageFormat = '[%s][%5s][%s]: %s\n'

---@enum (key) Log.Level
M.logLevel = {
    trace = 1,
    debug = 2,
    info  = 3,
    warn  = 4,
    error = 5,
    fatal = 6,
}

M.needTraceBack = {
    trace = true,
    error = true,
    fatal = true,
}

---@param a  table
---@param b? table
---@return table
local function merge(a, b)
    local new = {}
    for k, v in pairs(a) do
        new[k] = v
    end
    if b then
        for k, v in pairs(b) do
            new[k] = v
        end
    end
    return new
end

---@class Log.Option
---@field maxSize? integer # 日志文件的最大大小
---@field path? string # 日志文件的路径，与file二选一
---@field file? file* # 日志文件对象，与path二选一
---@field print? fun(level: Log.Level, message: string, timeStamp: string) # 额外的打印回调
---@field level? Log.Level # 日志等级，低于此等级的日志将不会被记录
---@field logLevel? table<Log.Level, integer> # 自定义日志等级
---@field needTraceBack? table<Log.Level, boolean> # 是否需要打印堆栈信息
---@field time? fun(): integer # 获取当前时刻（秒），需要精确到秒
---@field clock? fun(): number # 获取当前时间（秒），需要精确到毫秒

---@param path string
---@param mode openmode
---@return file*?
---@return string? errmsg
local function ioOpen(path, mode)
    if not io then
        return nil, 'No io module'
    end
    if not io.open then
        return nil, 'No io.open'
    end
    local file, err
    local suc, res = pcall(function ()
        file, err = io.open(path, mode)
    end)
    if not suc then
        return nil, res
    end
    return file, err
end

---@param option Log.Option
function M:__init(option)
    self.maxSize = option.maxSize
    self.level   = option.level
    self.clock   = option.clock
    self.time    = option.time
    if not option.file then
        if option.path then
            local file, err = ioOpen(option.path, 'w+b')
            if file then
                self.file = file
                self.file:setvbuf 'no'
            elseif err then
                if option.print then
                    pcall(option.print, 'warn', err)
                end
            end
        end
    end
    ---@private
    self.option = option
    ---@private
    self.logLevel = merge(M.logLevel, option.logLevel)
    ---@private
    self.needTraceBack = merge(M.needTraceBack, option.needTraceBack)

    for level in pairs(self.logLevel) do
        self[level] = function (...)
            return self:build(level, ...)
        end
    end
    ---@private
    self.startClock = self.clock()
    ---@private
    self.startTime  = self.time()
end

---@private
---@return string
function M:getTimeStamp()
    local deltaClock = self.clock() - self.startClock
    local sec, ms = math.modf((self.startTime + deltaClock) / 1000.0)
    local timeStamp = os.date('%m-%d %H:%M:%S', sec) --[[@as string]]
    timeStamp = ('%s.%03.f'):format(timeStamp, ms * 1000)
    return timeStamp
end

---@private
---@param level string
---@param ... any
---@return string message
---@return string timestamp
function M:build(level, ...)
    local t = table.pack(...)
    for i = 1, t.n do
        t[i] = tostring(t[i])
    end
    local message = table.concat(t, '\t', 1, t.n)

    if self.needTraceBack[level] then
        message = debug.traceback(message, 3)
    end

    local timeStamp = self:getTimeStamp()

    if self.logLevel[level] < self.logLevel[self.level] then
        return message, timeStamp
    end

    if self.option.print then
        pcall(self.option.print, level, message, timeStamp)
    end

    if not self.file then
        return message, timeStamp
    end

    local info = debug.getinfo(2, 'Sl')
    local sourceStr
    if info.currentline == -1 then
        sourceStr = '?'
    else
        sourceStr = ('%s:%d'):format(info.short_src, info.currentline)
    end
    local fullMessage = self.messageFormat:format(timeStamp, level, sourceStr, message)
    self.usedSize = self.usedSize + #fullMessage
    if self.usedSize > self.maxSize then
        self.file:write('[REACH MAX SIZE]!')
        self.file:close()
        self.file = nil
    else
        self.file:write(fullMessage)
    end

    return message, timeStamp
end
