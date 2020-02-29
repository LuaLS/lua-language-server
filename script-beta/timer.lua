local setmetatable = setmetatable
local mathMax      = math.max
local mathFloor    = math.floor
local osClock      = os.clock

_ENV = nil

local curFrame = 0
local maxFrame = 0
local curIndex = 0
local freeQueue = {}
local timer = {}

local function allocQueue()
    local n = #freeQueue
    if n > 0 then
        local r = freeQueue[n]
        freeQueue[n] = nil
        return r
    else
        return {}
    end
end

local function mTimeout(self, timeout)
    if self._pauseRemaining or self._running then
        return
    end
    local ti = curFrame + timeout
    local q = timer[ti]
    if q == nil then
        q = allocQueue()
        timer[ti] = q
    end
    self._timeoutFrame = ti
    self._running = true
    q[#q + 1] = self
end

local function mWakeup(self)
    if self._removed then
        return
    end
    self._running = false
    if self._onTimer then
        self:_onTimer()
    end
    if self._removed then
        return
    end
    if self._timerCount then
        if self._timerCount > 1 then
            self._timerCount = self._timerCount - 1
            mTimeout(self, self._timeout)
        else
            self._removed = true
        end
    else
        mTimeout(self, self._timeout)
    end
end

local function getRemaining(self)
    if self._removed then
        return 0
    end
    if self._pauseRemaining then
        return self._pauseRemaining
    end
    if self._timeoutFrame == curFrame then
        return self._timeout or 0
    end
    return self._timeoutFrame - curFrame
end

local function onTick()
    local q = timer[curFrame]
    if q == nil then
        curIndex = 0
        return
    end
    for i = curIndex + 1, #q do
        local callback = q[i]
        curIndex = i
        q[i] = nil
        if callback then
            mWakeup(callback)
        end
    end
    curIndex = 0
    timer[curFrame] = nil
    freeQueue[#freeQueue + 1] = q
end

local m = {}
local mt = {}
mt.__index = mt
mt.type = 'timer'

function mt:__tostring()
    return '[table:timer]'
end

function mt:__call()
    if self._onTimer then
        self:_onTimer()
    end
end

function mt:remove()
    self._removed = true
end

function mt:pause()
    if self._removed or self._pauseRemaining then
        return
    end
    self._pauseRemaining = getRemaining(self)
    self._running = false
    local ti = self._timeoutFrame
    local q = timer[ti]
    if q then
        for i = #q, 1, -1 do
            if q[i] == self then
                q[i] = false
                return
            end
        end
    end
end

function mt:resume()
    if self._removed or not self._pauseRemaining then
        return
    end
    local timeout = self._pauseRemaining
    self._pauseRemaining = nil
    mTimeout(self, timeout)
end

function mt:restart()
    if self._removed or self._pauseRemaining or not self._running then
        return
    end
    local ti = self._timeoutFrame
    local q = timer[ti]
    if q then
        for i = #q, 1, -1 do
            if q[i] == self then
                q[i] = false
                break
            end
        end
    end
    self._running = false
    mTimeout(self, self._timeout)
end

function mt:remaining()
    return getRemaining(self) / 1000.0
end

function mt:onTimer()
    self:_onTimer()
end

function m.wait(timeout, onTimer)
    local t = setmetatable({
        ['_timeout'] = mathMax(mathFloor(timeout * 1000.0), 1),
        ['_onTimer'] = onTimer,
        ['_timerCount'] = 1,
    }, mt)
    mTimeout(t, t._timeout)
    return t
end

function m.loop(timeout, onTimer)
    local t = setmetatable({
        ['_timeout'] = mathFloor(timeout * 1000.0),
        ['_onTimer'] = onTimer,
    }, mt)
    mTimeout(t, t._timeout)
    return t
end

function m.timer(timeout, count, onTimer)
    if count == 0 then
        return m.loop(timeout, onTimer)
    end
    local t = setmetatable({
        ['_timeout'] = mathFloor(timeout * 1000.0),
        ['_onTimer'] = onTimer,
        ['_timerCount'] = count,
    }, mt)
    mTimeout(t, t._timeout)
    return t
end

function m.clock()
    return curFrame / 1000.0
end

local lastClock = osClock()
function m.update()
    local currentClock = osClock()
    local delta = currentClock - lastClock
    lastClock = currentClock
    if curIndex ~= 0 then
        curFrame = curFrame - 1
    end
    maxFrame = maxFrame + delta * 1000.0
    while curFrame < maxFrame do
        curFrame = curFrame + 1
        onTick()
    end
end

return m
