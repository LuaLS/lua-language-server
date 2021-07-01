local proto  = require 'proto.proto'
local util   = require 'utility'
local timer  = require "timer"
local config = require 'config'

local nextToken = util.counter()

local m = {}

m.map = {}

---@class progress
local mt = {}
mt.__index     = mt
mt._token      = nil
mt._title      = nil
mt._message    = nil
mt._removed    = false
mt._clock      = 0.0
mt._delay      = 0.0
mt._percentage = 0.0
mt._showed     = false
mt._dirty      = true
mt._updated    = 0.0
mt._onCancel   = nil

---移除进度条
function mt:remove()
    if self._removed then
        return
    end
    self._removed = true
    local token = self._token
    m.map[token] = nil
    if self._showed then
        self._showed = false
        proto.notify('$/progress', {
            token = token,
            value = {
                kind = 'end',
            }
        })
        --log.info('Remove progress:', token, self._title)
    end
end

---设置描述
---@param message string # 描述
function mt:setMessage(message)
    if self._message == message then
        return
    end
    self._message = message
    self._dirty   = true
    self:_update()
end

---设置百分比
---@param per number # 百分比（1-100）
function mt:setPercentage(per)
    if self._percentage == per then
        return
    end
    self._percentage = math.floor(per)
    self._dirty      = true
    self:_update()
end

---取消事件
function mt:onCancel(callback)
    self._onCancel = callback
    self:_update()
end

function mt:_update()
    if self._removed then
        return
    end
    if not self._dirty then
        return
    end
    if  not self._showed
    and self._clock + self._delay <= os.clock() then
        self._updated = os.clock()
        self._dirty = false
        if not config.get 'Lua.window.progressBar' then
            return
        end
        proto.request('window/workDoneProgress/create', {
            token = self._token,
        })
        proto.notify('$/progress', {
            token = self._token,
            value = {
                kind        = 'begin',
                title       = self._title,
                cancellable = self._onCancel ~= nil,
                message     = self._message,
                percentage  = self._percentage,
            }
        })
        self._showed  = true
        --log.info('Create progress:', self._token, self._title)
        return
    end
    if not self._showed then
        return
    end
    if not config.get 'Lua.window.progressBar' then
        self:remove()
        return
    end
    if os.clock() - self._updated < 0.05 then
        return
    end
    self._dirty = false
    self._updated = os.clock()
    proto.notify('$/progress', {
        token = self._token,
        value = {
            kind        = 'report',
            message     = self._message,
            percentage  = self._percentage,
        }
    })
    --log.info('Report progress:', self._token, self._title, self._message, self._percentage)
end

function mt:__close()
    --log.info('Close progress:', self._token, self._title, self._message)
    self:remove()
end

function m.update()
    ---@param prog progress
    for _, prog in pairs(m.map) do
        if prog._removed then
            goto CONTINUE
        end
        prog:_update()
        ::CONTINUE::
    end
end

---创建一个进度条
---@param title string # 标题
---@param delay number # 至少经过这么久之后才会显示出来
function m.create(title, delay)
    local prog = setmetatable({
        _token = nextToken(),
        _title = title,
        _clock = os.clock(),
        _delay = delay,
    }, mt)

    m.map[prog._token] = prog

    return prog
end

---取消一个进度条
function m.cancel(token)
    local prog = m.map[token]
    if not prog then
        return
    end
    xpcall(prog._onCancel, log.error, prog)
    prog:remove()
end

timer.loop(0.1, m.update)

return m
