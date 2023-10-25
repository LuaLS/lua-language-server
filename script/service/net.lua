local socket = require "bee.socket"
local select = require "bee.select"
local selector = select.create()
local SELECT_READ <const> = select.SELECT_READ
local SELECT_WRITE <const> = select.SELECT_WRITE

local function fd_set_read(s)
    if s._flags & SELECT_READ ~= 0 then
        return
    end
    s._flags = s._flags | SELECT_READ
    selector:event_mod(s._fd, s._flags)
end

local function fd_clr_read(s)
    if s._flags & SELECT_READ == 0 then
        return
    end
    s._flags = s._flags & (~SELECT_READ)
    selector:event_mod(s._fd, s._flags)
end

local function fd_set_write(s)
    if s._flags & SELECT_WRITE ~= 0 then
        return
    end
    s._flags = s._flags | SELECT_WRITE
    selector:event_mod(s._fd, s._flags)
end

local function fd_clr_write(s)
    if s._flags & SELECT_WRITE == 0 then
        return
    end
    s._flags = s._flags & (~SELECT_WRITE)
    selector:event_mod(s._fd, s._flags)
end

local function on_event(self, name, ...)
    local f = self._event[name]
    if f then
        f(self, ...)
    end
end

local function close(self)
    local fd = self._fd
    on_event(self, "close")
    selector:event_del(fd)
    fd:close()
end

local stream_mt = {}
local stream = {}
stream_mt.__index = stream
function stream_mt:__newindex(name, func)
    if name:sub(1, 3) == "on_" then
        self._event[name:sub(4)] = func
    end
end
function stream:write(data)
    if self.shutdown_w then
        return
    end
    if data == "" then
        return
    end
    if self._writebuf == "" then
        fd_set_write(self)
    end
    self._writebuf = self._writebuf .. data
end
function stream:is_closed()
    return self.shutdown_w and self.shutdown_r
end
function stream:close()
    if not self.shutdown_r then
        self.shutdown_r = true
        fd_clr_read(self)
    end
    if self.shutdown_w or self._writebuf == ""  then
        self.shutdown_w = true
        fd_clr_write(self)
        close(self)
    end
end
local function close_write(self)
    fd_clr_write(self)
    if self.shutdown_r then
        close(self)
    end
end
function stream:select_r()
    local data = self._fd:recv()
    if data == nil then
        self:close()
    elseif data == false then
    else
        on_event(self, "data", data)
    end
end
function stream:select_w()
    local n = self._fd:send(self._writebuf)
    if n == nil then
        self.shutdown_w = true
        close_write(self)
    elseif n == false then
    else
        self._writebuf = self._writebuf:sub(n + 1)
        if self._writebuf == "" then
            close_write(self)
        end
    end
end
local function update_stream(s, event)
    if event & SELECT_READ ~= 0 then
        s:select_r()
    end
    if event & SELECT_WRITE ~= 0 then
        s:select_w()
    end
end

local function accept_stream(fd)
    local s = setmetatable({
        _fd = fd,
        _flags = SELECT_READ,
        _event = {},
        _writebuf = "",
        shutdown_r = false,
        shutdown_w = false,
    }, stream_mt)
    selector:event_add(fd, SELECT_READ, function (event)
        update_stream(s, event)
    end)
    return s
end
local function connect_stream(s)
    setmetatable(s, stream_mt)
    selector:event_del(s._fd)
    if s._writebuf ~= "" then
        s._flags = SELECT_READ | SELECT_WRITE
        selector:event_add(s._fd, SELECT_READ | SELECT_WRITE, function (event)
            update_stream(s, event)
        end)
        s:select_w()
    else
        s._flags = SELECT_READ
        selector:event_add(s._fd, SELECT_READ, function (event)
            update_stream(s, event)
        end)
    end
end


local listen_mt = {}
local listen = {}
listen_mt.__index = listen
function listen_mt:__newindex(name, func)
    if name:sub(1, 3) == "on_" then
        self._event[name:sub(4)] = func
    end
end
function listen:is_closed()
    return self.shutdown_r
end
function listen:close()
    self.shutdown_r = true
    close(self)
end
local function new_listen(fd)
    local s = {
        _fd = fd,
        _flags = SELECT_READ,
        _event = {},
        shutdown_r = false,
        shutdown_w = true,
    }
    selector:event_add(fd, SELECT_READ, function ()
        local newfd, err = fd:accept()
        if not newfd then
            on_event(s, "error", err)
            return
        end
        local ok, err = newfd:status()
        if not ok then
            on_event(s, "error", err)
            return
        end
        if newfd:status() then
            local news = accept_stream(newfd)
            on_event(s, "accept", news)
        end
    end)
    return setmetatable(s, listen_mt)
end

local connect_mt = {}
local connect = {}
connect_mt.__index = connect
function connect_mt:__newindex(name, func)
    if name:sub(1, 3) == "on_" then
        self._event[name:sub(4)] = func
    end
end
function connect:write(data)
    if data == "" then
        return
    end
    self._writebuf = self._writebuf .. data
end
function connect:is_closed()
    return self.shutdown_w
end
function connect:close()
    self.shutdown_w = true
    close(self)
end
local function new_connect(fd)
    local s = {
        _fd = fd,
        _flags = SELECT_WRITE,
        _event = {},
        _writebuf = "",
        shutdown_r = false,
        shutdown_w = false,
    }
    selector:event_add(fd, SELECT_WRITE, function ()
        local ok, err = fd:status()
        if ok then
            connect_stream(s)
            on_event(s, "connect")
        else
            on_event(s, "error", err)
            s:close()
        end
    end)
    return setmetatable(s, connect_mt)
end

local m = {}

function m.listen(protocol, ...)
    local fd, err = socket(protocol)
    if not fd then
        return nil, err
    end
    local ok
    ok, err = fd:bind(...)
    if not ok then
        fd:close()
        return nil, err
    end
    ok, err = fd:listen()
    if not ok then
        fd:close()
        return nil, err
    end
    return new_listen(fd)
end

function m.connect(protocol, ...)
    local fd, err = socket(protocol)
    if not fd then
        return nil, err
    end
    local ok
    ok, err = fd:connect(...)
    if ok == nil then
        fd:close()
        return nil, err
    end
    return new_connect(fd)
end

function m.update(timeout)
    for func, event in selector:wait(timeout or 0) do
        func(event)
    end
end

return m
