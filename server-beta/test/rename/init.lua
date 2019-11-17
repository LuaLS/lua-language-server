local core  = require 'core.rename'
local files = require 'files'

local function replace(text, positions)
    local buf = {}
    table.sort(positions, function (a, b)
        return a.start < b.start
    end)
    local lastPos = 1
    for _, info in ipairs(positions) do
        buf[#buf+1] = text:sub(lastPos, info.start - 1)
        buf[#buf+1] = info.text
        lastPos = info.finish + 1
    end
    buf[#buf+1] = text:sub(lastPos)
    return table.concat(buf)
end

function TEST(oldName, newName)
    return function (oldScript)
        return function (newScript)
            files.removeAll()
            files.setText('', oldScript)
            local pos = oldScript:find('[^%w_]'..oldName..'[^%w_]')
            assert(pos)

            local positions = core.rename('', pos+1, newName)
            local script = oldScript
            if positions then
                script = replace(script, positions)
            end
            assert(script == newScript)
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
