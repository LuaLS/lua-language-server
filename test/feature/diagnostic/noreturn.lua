TEST_DIAGNOSTIC [[
---@noreturn
local function fatal(msg) end

---@param v integer?
---@return {f: integer}
local function f(v)
    if not v then
        fatal("no")
    end
    return {f = v}
end
f()
]] { '-return-type-mismatch', '-need-check-nil' }

TEST_DIAGNOSTIC [[
---@noreturn
local function fatal(msg) end

local function err(msg)
    fatal(msg)
end

---@param v integer?
---@return {f: integer}
local function f(v)
    if not v then
        err("no")
    end
    return {f = v}
end
f()
]] { '-return-type-mismatch', '-need-check-nil' }

TEST_DIAGNOSTIC [[
local function log(msg) end

---@param v integer?
---@return {f: integer}
local function f(v)
    if not v then
        log("miss")
    end
    return <?{f = v}?>
end
f()
]] { 'return-type-mismatch' }

TEST_DIAGNOSTIC [[
---@param log any
---@param v integer?
---@return {f: integer}
local function f(v, log)
    if not v then
        log("miss")
    end
    return <?{f = v}?>
end
f(1, nil)
]] { 'return-type-mismatch' }

TEST_DIAGNOSTIC [[
---@noreturn
local function fatal(msg) end

local function ok(msg) end

---@param cb fun(msg: any)
---@param v integer?
---@return {f: integer}
local function f(v, cb)
    if not v then
        cb("x")
    end
    return <?{f = v}?>
end
f(1, fatal)
f(1, ok)
]] { 'return-type-mismatch' }
