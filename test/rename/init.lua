local core   = require 'core.rename'
local files  = require 'files'
local catch  = require 'catch'
local guide  = require 'parser.guide'
local config = require 'config'

local function replace(text, positions)
    local state = files.getState('')
    local buf = {}
    table.sort(positions, function (a, b)
        return a.start < b.start
    end)
    local lastPos = 1
    for _, info in ipairs(positions) do
        local start  = guide.positionToOffset(state, info.start)
        local finish = guide.positionToOffset(state, info.finish)
        buf[#buf+1] = text:sub(lastPos, start)
        buf[#buf+1] = info.text
        lastPos = finish + 1
    end
    buf[#buf+1] = text:sub(lastPos)
    return table.concat(buf)
end

function TEST(oldName, newName)
    return function (oldScript)
        return function (expectScript)
            files.removeAll()
            files.setText('', oldScript)
            local state = files.getState('')
            local offset = oldScript:find('[^%w_]'..oldName..'[^%w_]')
            assert(offset)
            local position = guide.offsetToPosition(state, offset)

            local positions = core.rename('', position, newName)
            local script = oldScript
            if positions then
                script = replace(script, positions)
            end
            assert(script == expectScript)
        end
    end
end

TEST ('a', 'b') [[
local a = 1
]] [[
local b = 1
]]

TEST ('a', 'b') [[
local a = 1
a = 2
a = a
]] [[
local b = 1
b = 2
b = b
]]

TEST ('a', 'b') [[
t.a = 1
a = t.a
a = t['a']
a = t["a"]
a = t[ [=[a]=] ]
]] [[
t.b = 1
a = t.b
a = t['b']
a = t["b"]
a = t[ [=[b]=] ]
]]

TEST ('a', 'b') [[
:: a ::
goto a
]] [[
:: b ::
goto b
]]

TEST ('a', 'b') [[
local function f(a)
    return a
end
]] [[
local function f(b)
    return b
end
]]

config.set('Lua.IntelliSense.traceBeSetted', true)
TEST ('a', '!!!') [[
t = {
    a = 0
}
t.a = 1
a = t.a
]] [[
t = {
    ["!!!"] = 0
}
t["!!!"] = 1
a = t["!!!"]
]]

TEST ('a', '!!!') [[
t = {
    ['a'] = 0
}
t.a = 1
a = t.a
]] [[
t = {
    ['!!!'] = 0
}
t["!!!"] = 1
a = t["!!!"]
]]
config.set('Lua.IntelliSense.traceBeSetted', false)

TEST ('a', '"') [[
print(t[ "a" ])
]] [[
print(t[ "\"" ])
]]

TEST ('a', '!!!') [[
function mt:a()
end
mt:a()
]] [[
mt["!!!"] = function (self)
end
mt:!!!()
]]

TEST ('a', '!!!') [[
function mt:a(x, y)
end
mt:a()
]] [[
mt["!!!"] = function (self, x, y)
end
mt:!!!()
]]

TEST ('a', '!!!') [[
a = a
]] [[
_ENV["!!!"] = _ENV["!!!"]
]]

TEST ('a', '!!!') [[
function a() end
]] [[
_ENV["!!!"] = function () end
]]

TEST ('a', 'a.b') [[
function a() end
a()
]] [[
function a.b() end
a.b()
]]

TEST ('a', 'a:b') [[
function a() end
a()
]] [[
function a:b() end
a:b()
]]

TEST ('class1', 'class2') [[
---@class class1

---@type class1

---@param x class1
]] [[
---@class class2

---@type class2

---@param x class2
]]

TEST ('alias1', 'alias2') [[
---@alias alias1 class

---@type alias1

---@param x alias1
]] [[
---@alias alias2 class

---@type alias2

---@param x alias2
]]

TEST ('arg1', 'arg2') [[
---@param arg1 number
function f(arg1)
    print(arg1)
end
]] [[
---@param arg2 number
function f(arg2)
    print(arg2)
end
]]
