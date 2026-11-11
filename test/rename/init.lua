---@diagnostic disable: await-in-sync
local core   = require 'core.rename'
local files  = require 'files'
local catch  = require 'catch'
local guide  = require 'parser.guide'
local config = require 'config'

local function replace(text, positions)
    local state = files.getState(TESTURI)
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
            files.setText(TESTURI, oldScript)
            local state = files.getState(TESTURI)
            local offset = oldScript:find('[^%w_]'..oldName..'[^%w_]')
            assert(offset)
            local position = guide.offsetToPosition(state, offset)

            local positions = core.rename(TESTURI, position, newName)
            local script = oldScript
            if positions then
                script = replace(script, positions)
            end
            assert(script == expectScript)
            files.remove(TESTURI)
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

TEST ('field1', 'field2') [[
---@class A
---@field field1 number

---@type A
local t

print(t.field1)
]] [[
---@class A
---@field field2 number

---@type A
local t

print(t.field2)
]]

TEST ('A', 'C') [[
---@class A

---@class B: A
]] [[
---@class C

---@class B: C
]]

TEST ('A', 'C') [[
---@class B: A
]] [[
---@class B: C
]]

for _, declaration in ipairs {
    '---@class OldName',
    '---@alias OldName string',
    '---@enum OldName',
} do
    local renamed = declaration:gsub('OldName', 'NewName')
    TEST ('OldName', 'NewName') (declaration .. [[

---@see OldName
---@type OldName
local value
OldName = 1
print(OldName)
]]) (renamed .. [[

---@see NewName
---@type NewName
local value
OldName = 1
print(OldName)
]])

    TEST ('OldName', 'NewName') ([[
---@see OldName
]] .. declaration .. [[

---@type OldName
local value
OldName = 1
print(OldName)
]]) ([[
---@see NewName
]] .. renamed .. [[

---@type NewName
local value
OldName = 1
print(OldName)
]])
end

TEST ('Missing', 'NewName') [[
---@see Missing
]] [[
---@see Missing
]]

TEST ('OldName', 'NewName') [[
---@see OldName
OldName = 1
]] [[
---@see OldName
OldName = 1
]]

TEST ('RepeatedType', 'RenamedType') (
    '---@class RepeatedType\n'
    .. ('---@see RepeatedType\n'):rep(64)
    .. 'RepeatedType = 1\nprint(RepeatedType)\n'
) (
    '---@class RenamedType\n'
    .. ('---@see RenamedType\n'):rep(64)
    .. 'RepeatedType = 1\nprint(RepeatedType)\n'
)

do
    local scope = require 'workspace.scope'
    local folder = scope.createFolder(TESTURI .. '.rename-a')
    local otherFolder = scope.createFolder(TESTURI .. '.rename-b')
    local classUri = folder.uri .. '/class.lua'
    local uri = folder.uri .. '/see.lua'
    local otherUri = otherFolder.uri .. '/other.lua'
    local classScript = '---@class OldName\n'
    local seeScript = '---@see OldName\nOldName = 1\nprint(OldName)\n'
    local _ <close> = function ()
        files.remove(classUri)
        files.remove(uri)
        files.remove(otherUri)
        folder:remove()
        otherFolder:remove()
    end
    files.setText(classUri, classScript)
    files.setText(uri, seeScript)
    files.setText(otherUri, classScript .. seeScript)
    for _, sourceUri in ipairs { classUri, uri } do
        local state = files.getState(sourceUri)
        local script = files.getText(sourceUri)
        local offset = assert(script:find('OldName', 1, true))
        local position = guide.offsetToPosition(state, offset)
        local prepared = assert(core.prepareRename(sourceUri, position))
        assert(prepared.text == 'OldName')
        local positions = assert(core.rename(sourceUri, position, 'NewName'))
        assert(#positions == 2)
        local found = {}
        for _, edit in ipairs(positions) do
            local editState = files.getState(edit.uri)
            local editScript = files.getText(edit.uri)
            local editOffset = assert(editScript:find('OldName', 1, true)) - 1
            assert(edit.start == guide.offsetToPosition(editState, editOffset))
            assert(edit.finish == guide.offsetToPosition(editState, editOffset + #'OldName'))
            assert(edit.text == 'NewName')
            found[edit.uri] = true
        end
        assert(found[classUri] and found[uri])
    end
end

for _, script in ipairs {
    '---@see Missing\n',
    '---@see OldName\nOldName = 1\n',
} do
    files.setText(TESTURI, script)
    local state = files.getState(TESTURI)
    local position = guide.offsetToPosition(state, #'---@see ')
    assert(core.prepareRename(TESTURI, position) == nil)
    files.remove(TESTURI)
end
