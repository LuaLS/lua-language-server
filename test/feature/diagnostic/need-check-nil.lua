-- 回归：比较条件（`>`）不产生收窄，也不应污染后续读取
TEST_DIAGNOSTIC [[
local function f(name)
    while true do
        local parent, nextPos = name:match '^([^%.]+)()'
        if not parent then
            break
        end
        if nextPos > #name then
            break
        else
            name = name:sub(nextPos + 1)
        end
    end
end
f('a.b')
]] { '-need-check-nil' }

TEST_DIAGNOSTIC [[
---@type number?
local x
print(<?x?>.y)
]] { 'need-check-nil' }

TEST_DIAGNOSTIC [[
local x = nil
print(<?x?>.y)
]] { 'need-check-nil' }

TEST_DIAGNOSTIC [[
---@return number
local x = 1
print(x.y)
]] { '-need-check-nil' }

TEST_DIAGNOSTIC [[
local x = 1
print(x.y)
]] { '-need-check-nil' }

TEST_DIAGNOSTIC [[
---@type any
local lm
if not lm.notest then
    lm.notest = true
end
]] { '-need-check-nil' }

TEST_DIAGNOSTIC [[
---@type any
local x
print(x.y)
]] { '-need-check-nil' }

TEST_DIAGNOSTIC [[
---@param has_seen table?
local function f(has_seen)
    if not has_seen then
        has_seen = {}
    end
    local x = has_seen[1]
end
]] { '-need-check-nil' }

TEST_DIAGNOSTIC [[
---@param has_seen table?
local function f(has_seen)
    if has_seen == nil then
        has_seen = {}
    end
    local x = has_seen[1]
end
]] { '-need-check-nil' }

TEST_DIAGNOSTIC [[
---@type table?
local t
if not t then
    t = {}
end
t.x = 1
local y = t.x
]] { '-need-check-nil' }

TEST_DIAGNOSTIC [[
---@generic T: table, V
---@param t T
---@return fun<V>(table: V[], i?: integer):integer, V
---@return T
---@return integer i
function ipairs(t) end

local function f(json_data)
    for _, section in ipairs(json_data) do
        return section.DOC
    end
end
f(1)
]] { '-need-check-nil' }

-- 短路：`or` 右侧只在左侧为假时求值，此时左侧已确定非 nil
TEST_DIAGNOSTIC [[
---@class A
---@field type string

---@param a A?
local function f(a)
    if not a or a.type ~= 'string' then
        return
    end
    print(a.type)
end
]] { '-need-check-nil' }

TEST_DIAGNOSTIC [[
---@class A
---@field type string

---@param a A?
local function f(a)
    if a == nil or a.type ~= 'string' then
        return
    end
    print(a.type)
end
]] { '-need-check-nil' }

-- 短路：`and` 右侧只在左侧为真时求值
TEST_DIAGNOSTIC [[
---@class A
---@field type string

---@param a A?
local function f(a)
    if a and a.type == 'string' then
        print(a.type)
    end
end
]] { '-need-check-nil' }

-- 反向护栏：没有守卫时仍要提示
TEST_DIAGNOSTIC [[
---@class A
---@field type string

---@param a A?
local function f(a)
    print(<?a?>.type)
end
]] { 'need-check-nil' }

-- 探针：`---@cast` 之后不应丢掉守卫得到的非 nil 收窄
TEST_DIAGNOSTIC [[
---@class A
---@field k integer
---@field other integer

---@param x A?
local function f(x)
    if not x then
        return
    end
    if x.k == 1 then
        ---@cast x A
        print(x.other)
    end
end
]] { '-need-check-nil' }

-- 探针：多个「以 return 结尾」的分支之后，守卫得到的收窄不应丢失
TEST_DIAGNOSTIC [[
---@class R
---@field a? boolean
---@field b? boolean
---@field c? string

---@param x R?
---@return boolean
local function f(x)
    if not x then
        return false
    end
    if x.a then
        return true
    end
    if x.b then
        return true
    end
    print(x.c)
    return false
end
]] { '-need-check-nil' }

-- 探针：动态键写入 nil 不应让基变量变成可能 nil
TEST_DIAGNOSTIC [[
---@param mark table
---@param k string
local function f(mark, k)
    if mark[k] then
        return
    end
    mark[k] = true
    for _, v in ipairs({ 1, 2 }) do
        if v == 3 then
            mark[k] = nil
            return
        end
    end
    mark[k] = nil
end
]] { '-need-check-nil' }

-- 探针：闭包赋值得到的局部变量 + `or` 守卫
TEST_DIAGNOSTIC [[
---@class P
---@field type string

---@param list P[]
local function f(list)
    local near
    local function each(cb)
        for _, source in ipairs(list) do
            cb(source)
        end
    end
    each(function (source)
        near = source
    end)
    if not near or near.type ~= 'string' then
        return
    end
    print(near.type)
end
]] { '-need-check-nil' }

TEST_DIAGNOSTIC [[
---@class N
---@field type string
---@field cate? string

---@param list N[]
local function f(list)
    for i = 1, #list do
        local c = list[i]
        if c.type == 'nil'
        or (c.type == 'global' and c.cate == 'type') then
            print(i)
        end
    end
end
]] { '-need-check-nil' }

-- 闭包里对外层变量（upvalue）的守卫收窄：注解值作为收窄基值
TEST_DIAGNOSTIC [[
---@class timer
---@field restart fun(self: timer)

---@type timer?
local delayTimer

local function f()
    if delayTimer then
        delayTimer:restart()
    end
end
]] { '-need-check-nil' }

TEST_DIAGNOSTIC [[
---@class timer
---@field restart fun(self: timer)

---@type timer?
local delayTimer

local function f()
    if not delayTimer then
        return
    end
    delayTimer:restart()
end
]] { '-need-check-nil' }

-- 无注解（any）的外层变量不做收窄：truthy 标记不应盖住读值
TEST_DIAGNOSTIC [[
local param

local function f()
    if param then
        print(param.anything)
        param:anyMethod()
    end
end
]] { '-need-check-nil', '-undefined-field' }
