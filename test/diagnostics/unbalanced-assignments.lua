TEST [[
local x, <!y!>, <!z!> = 1
]]

TEST [[
local x, y, <!z!> = 1, 2
]]

TEST [[
local x, y, z = print()
]]

TEST [[
local x, y, z
]]

TEST [[
local x, y, z
x, <!y!>, <!z!> = 1
]]

TEST [[
X, <!Y!>, <!Z!> = 1
]]

TEST [[
T = {}
T.x, <!T.y!>, <!T.z!> = 1
]]

TEST [[
T = {}
T['x'], <!T['y']!>, <!T['z']!> = 1
]]
