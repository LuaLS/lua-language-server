TEST [[
local m = {}

function <!m:fff!>()
end

function <!m:fff!>()
end

return m
]]

TEST [[
local m = {}

function <!m:fff!>()
end

do
    function <!m:fff!>()
    end
end

return m
]]

TEST [[
local m = {}

m.x = true
m.x = false

return m
]]

TEST [[
local m = {}

m.x = io.open('')
m.x = nil

return m
]]

TEST [[
---@class A
X = {}

function <!X.f!>() end

function <!X.f!>() end
]]

TEST [[
---@meta

---@class A
X = {}

function X.f() end

function X.f() end
]]

TEST [[
---@class A
X = {}

if true then
    function X.f() end
else
    function X.f() end
end
]]

TEST [[
---@class A
X = {}

function X:f() end

---@type x
local x

function x:f() end
]]

TEST [[
---@class A
X = {}

function X:f() end

---@type x
local x

function <!x:f!>() end

function <!x:f!>() end
]]
