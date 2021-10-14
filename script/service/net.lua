local socket = require "bee.socket"

local readfds = {}
local writefds = {}
local map = {}

local function FD_SET(set, fd)
    for i = 1, #set do
        if fd == set[i] then
            return
        end
    end
    set[#set+1] = fd
end

local function FD_CLR(set, fd)
    for i = 1, #set do
        if fd == set[i] then
            set[i] = set[#set]
            set[#set] = nil
            return
        end
    end
end

local function fd_set_read(fd)
    FD_SET(readfds, fd)
end

local function fd_clr_read(fd)
    FD_CLR(readfds, fd)
end

local function fd_set_write(fd)
    FD_SET(writefds, fd)
end

local function fd_clr_write(fd)
    FD_CLR(writefds, fd)
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
    fd:close()
    map[fd] = nil
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
        fd_set_write(self._fd)
    end
    self._writebuf = self._writebuf .. data
end
function stream:is_closed()
    return self.shutdown_w and self.shutdown_r
end
function stream:close()
    if not self.shutdown_r then
        self.shutdown_r = true
        fd_clr_read(self._fd)
    end
    if self.shutdown_w or self._writebuf == ""  then
        self.shutdown_w = true
        fd_clr_write(self._fd)
        close(self)
    end
end
function stream:update(timeout)
    local fd = self._fd
    local r = {fd}
    local w = r
    if self._writebuf == "" then
        w = nil
    end
    local rd, wr = socket.select(r, w, timeout or 0)
    if rd then
        if #rd > 0 then
            self:select_r()
        end
        if #wr > 0 then
            self:select_w()
        end
    end
end
local function close_write(self)
    fd_clr_write(self._fd)
    if self.shutdown_r then
        fd_clr_read(self._fd)
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
    else
        self._writebuf = self._writebuf:sub(n + 1)
        if self._writebuf == "" then
            close_write(self)
        end
    end
end

local function accept_stream(fd)
    local self = setmetatable({
        _fd = fd,
        _event = {},
        _writebuf = "",
        shutdown_r = false,
        shutdown_w = false,
    }, stream_mt)
    map[fd] = self
    fd_set_read(fd)
    return self
end
local function connect_stream(self)
    setmetatable(self, stream_mt)
    fd_set_read(self._fd)
    if self._writebuf ~= "" then
        self:select_w()
    else
        fd_clr_write(self._fd)
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
    fd_clr_read(self._fd)
    close(self)
end
function listen:update(timeout)
    local fd = self._fd
    local r = {fd}
    local rd = socket.select(r, nil, timeout or 0)
    if rd then
        if #rd > 0 then
            self:select_r()
        end
    end
end
function listen:select_r()
    local newfd = self._fd:accept()
    if newfd:status() then
        local news = accept_stream(newfd)
        on_event(self, "accept", news)
    end
end
local function new_listen(fd)
    local s = {
        _fd = fd,
        _event = {},
        shutdown_r = false,
        shutdown_w = true,
    }
    map[fd] = s
    fd_set_read(fd)
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
    fd_clr_write(self._fd)
    close(self)
end
function connect:update(timeout)
    local fd = self._fd
    local w = {fd}
    local rd, wr = socket.select(nil, w, timeout or 0)
    if rd then
        if #wr > 0 then
            self:select_w()
        end
    end
end
function connect:select_w()
    local ok, err = self._fd:status()
    if ok then
        connect_stream(self)
        on_event(self, "connect")
    else
        on_event(self, "error", err)
        self:close()
    end
end
local function new_connect(fd)
    local s = {
        _fd = fd,
        _event = {},
        _writebuf = "",
        shutdown_r = false,
        shutdown_w = false,
    }
    map[fd] = s
    fd_set_write(fd)
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
    local rd, wr = socket.select(readfds, writefds, timeout or 0)
    if rd then
        for i = 1, #rd do
            local fd = rd[i]
            local s = map[fd]
            s:select_r()
        end
        for i = 1, #wr do
            local fd = wr[i]
            local s = map[fd]
            s:select_w()
        end
    end
end

return m
