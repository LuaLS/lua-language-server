local proto = require 'proto.proto'
local util  = require 'utility'
local timer = require "timer"

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
mt._delay      = 1.0
mt._percentage = nil
mt._showed     = false
mt._dirty      = true
mt._updated    = 0.0

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
        log.info('Remove progress:', token, self._title)
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

function mt:_update()
    if self._removed then
        return
    end
    if not self._showed then
        return
    end
    if not self._dirty then
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
            cancellable = false,
            message     = self._message,
            percentage  = self._percentage,
        }
    })
    log.info('Report progress:', self._token, self._title, self._message)
end

function mt:__close()
    log.info('Close progress:', self._token, self._message)
    self:remove()
end

function m.update()
    local clock = os.clock()
    ---@param prog progress
    for token, prog in pairs(m.map) do
        if prog._removed then
            goto CONTINUE
        end
        if  not prog._showed
        and prog._clock + prog._delay <= clock then
            prog._showed = true
            proto.request('window/workDoneProgress/create', {
                token = token,
            })
            proto.notify('$/progress', {
                token = token,
                value = {
                    kind        = 'begin',
                    title       = prog._title,
                    cancellable = false,
                    message     = prog._message,
                    percentage  = prog._percentage,
                }
            })
            log.info('Create progress:', token, prog._title)
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

timer.loop(0.1, m.update)

return m
