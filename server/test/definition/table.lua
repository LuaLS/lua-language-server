TEST [[
local t
t.<!x!> = 1
t.<?x?> = 1
]]

TEST [[
t.<!x!> = 1
t.<?x?> = 1
]]

TEST [[
local <!t!>
t.x = 1
<?t?>.x = 1
]]

TEST [[
t.<!x!> = 1
t.<?x?>.y = 1
]]

TEST [[
local t
t.<!x!> = 1
t.<?x?>()
]]

TEST [[
local t
t[<!1!>] = 1
t[<?1?>]()
]]

TEST [[
local t
t[<!true!>] = 1
t[<?true?>]()
]]

TEST [[
local t
t[<!"method"!>] = 1
t[<?"method"?>]()
]]

TEST [[
local t
t[<!"longString"!>] = 1
t[<?[==[longString]==]?>]()
]]
