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
