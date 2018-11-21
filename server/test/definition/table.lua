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
