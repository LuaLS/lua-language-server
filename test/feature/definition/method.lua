TEST_DEF [[
function mt:<!a!>()
end
function mt:b()
    mt:<?a?>()
end
]]

TEST_DEF [[
function mt:<!m1!>()
end
function mt:m2()
    self:<?m1?>()
end
]]

TEST_DEF [[
function mt:m3()
    mt:<?m4?>()
end
function mt:<!m4!>()
end
]]

TEST_DEF [[
function mt:m3()
    self:<?m4?>()
end
function mt:<!m4!>()
end
]]

TEST_DEF [[
local mt

function mt:f()
    self.<!x!> = 1
end

mt.<?x?>
]]

TEST_DEF [[
function G:f()
    self.<!x!> = 1
end

G.<?x?>
]]

TEST_DEF [[
function G.H:f()
    self.<!x!> = 1
end

G.H.<?x?>
]]
