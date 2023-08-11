TEST [[
local print, _G
print(<!x!>)
print(<!log!>)
print(<!X!>)
print(<!Log!>)
print(<!y!>)
print(Z)
print(_G)
Z = 1
]]

TEST [[
X = table[<!x!>]
]]
TEST [[
T1 = 1
_ENV.T2 = 1
_G.T3 = 1
_ENV._G.T4 = 1
_G._G._G.T5 = 1
rawset(_G, 'T6', 1)
rawset(_ENV, 'T7', 1)
print(T1)
print(T2)
print(T3)
print(T4)
print(T5)
print(T6)
print(T7)
]]

TEST [[
---@class c
c = {}
]]
