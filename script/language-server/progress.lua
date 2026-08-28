local beeTime = require 'bee.time'

local nextToken = ls.util.counter()

---@type table<integer, Progress>
local allProgress = {}

---@return LanguageClient?
local function getClient()
    local server = ls.server
    if not server then
        return nil
    end
    return server.client
end

---@param uri Uri?
---@return boolean
local function isProgressBarEnabled(uri)
    if not uri then
        return true
    end
    local scope = ls.scope.find(uri)
    if not scope then
        return true
    end
    return scope.config:get(uri, 'Lua.window.progressBar') ~= false
end

---@class Progress: Class.Base
---@field package _uri         Uri?
---@field package _token       integer
---@field package _title       string
---@field package _message     string?
---@field package _removed     boolean
---@field package _clock       number
---@field package _delay       number
---@field package _percentage  number
---@field package _showed      boolean
---@field package _dirty       boolean
---@field package _updated     number
---@field package _onCancel    fun(prog: Progress)?
local M = Class 'Progress'

M._removed    = false
M._clock      = 0.0
M._delay      = 0.0
M._percentage = 0.0
M._showed     = false
M._dirty      = true
M._updated    = 0.0

---@param uri Uri?
---@param title string
---@param delay number
function M:__init(uri, title, delay)
    self._token = nextToken()
    self._title = title
    self._clock = beeTime.monotonic()
    self._delay = delay * 1000
    self._uri   = uri
    allProgress[self._token] = self
end

function M:remove()
    if self._removed then
        return
    end
    self._removed = true
    allProgress[self._token] = nil
    if self._showed then
        self._showed = false
        local client = getClient()
        if client then
            client:notify('$/progress', {
                token = self._token,
                value = {
                    kind = 'end',
                },
            })
        end
    end
end

---@return boolean
function M:isRemoved()
    return self._removed
end

---@param message string
function M:setMessage(message)
    if self._message == message then
        return
    end
    self._message = message
    self._dirty   = true
    self:update()
end

---@param per number
function M:setPercentage(per)
    if self._percentage == per then
        return
    end
    self._percentage = math.floor(per)
    self._dirty      = true
    self:update()
end

---@param callback fun(prog: Progress)
function M:onCancel(callback)
    self._onCancel = callback
    self:update()
end

function M:update()
    if self._removed then
        return
    end
    if not self._dirty then
        return
    end
    local now = beeTime.monotonic()
    if  not self._showed
    and self._clock + self._delay <= now then
        self._updated = now
        self._dirty   = false
        if not isProgressBarEnabled(self._uri) then
            return
        end
        local client = getClient()
        if not client then
            return
        end
        client:request('window/workDoneProgress/create', {
            token = self._token,
        }, function () end)
        client:notify('$/progress', {
            token = self._token,
            value = {
                kind        = 'begin',
                title       = self._title,
                cancellable = self._onCancel ~= nil,
                message     = self._message,
                percentage  = self._percentage,
            },
        })
        self._showed = true
        return
    end
    if not self._showed then
        return
    end
    if not isProgressBarEnabled(self._uri) then
        self:remove()
        return
    end
    if now - self._updated < 50 then
        return
    end
    self._dirty   = false
    self._updated = now
    local client = getClient()
    if not client then
        return
    end
    client:notify('$/progress', {
        token = self._token,
        value = {
            kind       = 'report',
            message    = self._message,
            percentage = self._percentage,
        },
    })
end

function M:__close()
    self:remove()
end

ls.progress = {}

---@param uri Uri?
---@param title string
---@param delay number
---@return Progress
function ls.progress.create(uri, title, delay)
    return New 'Progress' (uri, title, delay)
end

---@param token integer | string
function ls.progress.cancel(token)
    local prog = allProgress[token]
    if not prog then
        return
    end
    if prog._onCancel then
        xpcall(prog._onCancel, log.error, prog)
    end
    prog:remove()
end

ls.timer.loop(0.1, function ()
    for _, prog in pairs(allProgress) do
        if not prog:isRemoved() then
            prog:update()
        end
    end
end)
