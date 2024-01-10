TEST [[
---@class <!A : B!>
---@class <!B : C!>
---@class <!C : D!>
---@class <!D : A!>
]]

TEST [[
---@class A : B
---@class B : C
---@class C : D
---@class D
]]

