local socket = require "bee.socket"
local select = require "bee.select"
local fs = require "bee.filesystem"

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
        return f(self, ...)
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
local function update_stream(s, event)
    if event & SELECT_READ ~= 0 then
        local data = s._fd:recv()
        if data == nil then
            s:close()
        elseif data == false then
        else
            on_event(s, "data", data)
        end
    end
    if event & SELECT_WRITE ~= 0 then
        local n = s._fd:send(s._writebuf)
        if n == nil then
            s.shutdown_w = true
            close_write(s)
        elseif n == false then
        else
            s._writebuf = s._writebuf:sub(n + 1)
            if s._writebuf == "" then
                close_write(s)
            end
        end
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

local m = {}

function m.listen(protocol, address, port)
    local fd; do
        local err
        fd, err = socket.create(protocol)
        if not fd then
            return nil, err
        end
        if protocol == "unix" then
            fs.remove(address)
        end
    end
    do
        local ok, err = fd:bind(address, port)
        if not ok then
            fd:close()
            return nil, err
        end
    end
    do
        local ok, err = fd:listen()
        if not ok then
            fd:close()
            return nil, err
        end
    end
    local s = {
        _fd = fd,
        _flags = SELECT_READ,
        _event = {},
        shutdown_r = false,
        shutdown_w = true,
    }
    selector:event_add(fd, SELECT_READ, function ()
        local new_fd, err = fd:accept()
        if new_fd == nil then
            fd:close()
            on_event(s, "error", err)
            return
        elseif new_fd == false then
        else
            local new_s = setmetatable({
                _fd = new_fd,
                _flags = SELECT_READ,
                _event = {},
                _writebuf = "",
                shutdown_r = false,
                shutdown_w = false,
            }, stream_mt)
            if on_event(s, "accepted", new_s) then
                selector:event_add(new_fd, new_s._flags, function (event)
                    update_stream(new_s, event)
                end)
            else
                new_fd:close()
            end
        end
    end)
    return setmetatable(s, listen_mt)
end

function m.connect(protocol, address, port)
    local fd; do
        local err
        fd, err = socket.create(protocol)
        if not fd then
            return nil, err
        end
    end
    do
        local ok, err = fd:connect(address, port)
        if ok == nil then
            fd:close()
            return nil, err
        end
    end
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
            on_event(s, "connected")
            setmetatable(s, stream_mt)
            if s._writebuf ~= "" then
                update_stream(s, SELECT_WRITE)
                if s._writebuf ~= "" then
                    s._flags = SELECT_READ | SELECT_WRITE
                else
                    s._flags = SELECT_READ
                end
            else
                s._flags = SELECT_READ
            end
            selector:event_add(s._fd, s._flags, function (event)
                update_stream(s, event)
            end)
        else
            s:close()
            on_event(s, "error", err)
        end
    end)
    return setmetatable(s, connect_mt)
end

function m.update(timeout)
    for func, event in selector:wait(timeout or 0) do
        func(event)
    end
end

return m
