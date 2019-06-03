local setmetatable = setmetatable
local pairs = pairs
local tableInsert = table.insert
local mathMax = math.max
local mathFloor = math.floor

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
        xpcall(self._onTimer, log.error, self)
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

function ac.clock()
    return curFrame / 1000.0
end

function ac.timer_size()
    local n = 0
    for _, ts in pairs(timer) do
        n = n + #ts
    end
    return n
end

function ac.timer_all()
    local tbl = {}
    for _, ts in pairs(timer) do
        for i, t in ipairs(ts) do
            if t then
                tbl[#tbl + 1] = t
            end
        end
    end
    return tbl
end

local function update(delta)
    if curIndex ~= 0 then
        curFrame = curFrame - 1
    end
    maxFrame = maxFrame + delta * 1000.0
    while curFrame < maxFrame do
        curFrame = curFrame + 1
        onTick()
    end
end

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

function ac.wait(timeout, onTimer)
    local t = setmetatable({
        ['_timeout'] = mathMax(mathFloor(timeout * 1000.0), 1),
        ['_onTimer'] = onTimer,
        ['_timerCount'] = 1,
    }, mt)
    mTimeout(t, t._timeout)
    return t
end

function ac.loop(timeout, onTimer)
    local t = setmetatable({
        ['_timeout'] = mathFloor(timeout * 1000.0),
        ['_onTimer'] = onTimer,
    }, mt)
    mTimeout(t, t._timeout)
    return t
end

function ac.timer(timeout, count, onTimer)
    if count == 0 then
        return ac.loop(timeout, onTimer)
    end
    local t = setmetatable({
        ['_timeout'] = mathFloor(timeout * 1000.0),
        ['_onTimer'] = onTimer,
        ['_timerCount'] = count,
    }, mt)
    mTimeout(t, t._timeout)
    return t
end

local function utimer_initialize(u)
    if not u._timers then
        u._timers = {}
    end
    if #u._timers > 0 then
        return
    end
    u._timers[1] = ac.loop(0.01, function()
        local timers = u._timers
        for i = #timers, 2, -1 do
            if timers[i]._removed then
                local len = #timers
                timers[i] = timers[len]
                timers[len] = nil
            end
        end
        if #timers == 1 then
            timers[1]:remove()
            timers[1] = nil
        end
    end)
end

function ac.uwait(u, timeout, onTimer)
    utimer_initialize(u)
    local t = ac.wait(timeout, onTimer)
    tableInsert(u._timers, t)
    return t
end

function ac.uloop(u, timeout, onTimer)
    utimer_initialize(u)
    local t = ac.loop(timeout, onTimer)
    tableInsert(u._timers, t)
    return t
end

function ac.utimer(u, timeout, count, onTimer)
    utimer_initialize(u)
    local t = ac.timer(timeout, count, onTimer)
    tableInsert(u._timers, t)
    return t
end

return update
