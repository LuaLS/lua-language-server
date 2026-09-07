test.scope.config:set(test.rootUri, 'Lua.diagnostics.neededFileStatus', { ['await-in-sync'] = 'Any' })

TEST_DIAGNOSTIC [[
---@async
local function asyncFunction()
end

local function syncFunction()
    <?asyncFunction?>()
end
]] { 'await-in-sync' }

TEST_DIAGNOSTIC [[
---@async
local function asyncFunction()
end

---@async
local function syncFunction()
    asyncFunction()
end
]] { '-await-in-sync' }

TEST_DIAGNOSTIC [[
---@async
function globalAsync()
end

local function syncFunction()
    <?globalAsync?>()
end
]] { 'await-in-sync' }

TEST_DIAGNOSTIC [[
---@async
local function asyncFunction()
end

asyncFunction()
]] { '-await-in-sync' }

TEST_DIAGNOSTIC [[
---@type async fun()
local f

local function syncFunction()
    <?f?>()
end
]] { 'await-in-sync' }

TEST_DIAGNOSTIC [[
---@type async fun()
local f

---@async
local function syncFunction()
    f()
end
]] { '-await-in-sync' }

TEST_DIAGNOSTIC [[
local t = {}

---@async
function t.method()
end

local function syncFunction()
    <?t.method?>()
end
]] { 'await-in-sync' }

TEST_DIAGNOSTIC [[
local t = {}

---@async
function t:method()
end

local function syncFunction()
    <?t:method?>()
end
]] { 'await-in-sync' }

TEST_DIAGNOSTIC [[
coroutine = {}

---@async
function coroutine.yield(...)
end

local f = function () ---@async
end

local function syncFunction()
    <?f?>()
end
]] { 'await-in-sync' }

TEST_DIAGNOSTIC [[
coroutine = {}

---@async
function coroutine.yield(...)
end

local f = function () ---@async
    coroutine.yield()
end
]] { '-await-in-sync' }

TEST_DIAGNOSTIC [[
local f = function() end ---@async

local function syncFunction()
    <?f?>()
end
]] { 'await-in-sync' }

TEST_DIAGNOSTIC [[
local function f()
end

local function syncFunction()
    f()
end
]] { '-await-in-sync' }

TEST_DIAGNOSTIC [[
coroutine = {}

---@async
function coroutine.yield(...)
end

function syncFunction()
    <?coroutine.yield?>()
end
]] { 'await-in-sync' }

TEST_DIAGNOSTIC [[
coroutine = {}

---@async
function coroutine.yield(...)
end

---@async
function syncFunction()
    coroutine.yield()
end
]] { '-await-in-sync' }

TEST_DIAGNOSTIC [[
---@async
local function asyncFunction()
end

local function syncFunction()
    local x = <?asyncFunction?>()
end
]] { 'await-in-sync' }

TEST_DIAGNOSTIC [[
---@async
local function asyncFunction()
    asyncFunction()
end
]] { '-await-in-sync' }

TEST_DIAGNOSTIC [[
---@async
local function asyncFunction()
end

local function outer()
    local function inner()
        <?asyncFunction?>()
    end
end
]] { 'await-in-sync' }

TEST_DIAGNOSTIC [[
coroutine = {}

---@async
function coroutine.yield(...)
end

local function syncFunction()
    while true do
        ---@async
        local f = (function ()
            coroutine.yield()
        end)
    end
end
]] { '-await-in-sync' }

TEST_DIAGNOSTIC [[
coroutine = {}

---@async
function coroutine.yield(...)
end

local parser = (function ()
    while true do
        ---@async
        local proto = (function (len)
            coroutine.yield()
        end)
    end
end)
]] { '-await-in-sync' }

TEST_DIAGNOSTIC [[
coroutine = {}

---@async
function coroutine.yield(...)
end

local function syncFunction()
    do
        ---@async
        local f = (function ()
            coroutine.yield()
        end)
    end
    if true then
        ---@async
        local g = (function ()
            coroutine.yield()
        end)
    end
    repeat
        ---@async
        local h = (function ()
            coroutine.yield()
        end)
    until true
end
]] { '-await-in-sync' }
