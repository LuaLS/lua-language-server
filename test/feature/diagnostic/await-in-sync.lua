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

-- 实参传给 `async fun()` 形参的函数字面量：函数体内即为异步上下文
TEST_DIAGNOSTIC [[
---@type async fun(ev: string)
local callback

---@param f async fun()
local function call(f) end

local function trigger()
    call(function ()
        callback('x')
    end)
end
]] { '-await-in-sync' }

-- 传给非 async 形参的函数字面量：函数体内仍是同步上下文
TEST_DIAGNOSTIC [[
---@type async fun(ev: string)
local callback

---@param f fun()
local function call(f) end

local function trigger()
    call(function ()
        <?callback?>('x')
    end)
end
]] { 'await-in-sync' }

TEST_DIAGNOSTIC [[
---@type async fun(ev: string)
local callback

---@param f async fun()
local function call(f) end

local function trigger()
    call(function () ---@async
        callback('x')
    end)
end
]] { '-await-in-sync' }

-- 作为实参传入的函数字面量：注解写在 function 之前
TEST_DIAGNOSTIC [[
coroutine = {}

---@async
function coroutine.yield(...)
end

local m = {}

function m.register(name, def)
end

m.register('initialized') {
    ---@async
    function (params)
        coroutine.yield()
    end
}
]] { '-await-in-sync' }

-- 作为实参传入的函数字面量：注解写在 function 之后
TEST_DIAGNOSTIC [[
coroutine = {}

---@async
function coroutine.yield(...)
end

local m = {}

function m.register(name, def)
end

m.register('initialized') {
    function (params) ---@async
        coroutine.yield()
    end
}
]] { '-await-in-sync' }

TEST_DIAGNOSTIC [[
coroutine = {}

---@async
function coroutine.yield(...)
end

local pub = {}

---@async
function pub.awaitTask(name, params)
end

local awaitTask = pub.awaitTask

---@async
---@param name   string
---@param params any
---@diagnostic disable-next-line: duplicate-set-field
pub.awaitTask = function (name, params)
    return awaitTask(name, params)
end
]] { '-await-in-sync' }
