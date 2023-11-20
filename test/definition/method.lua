TEST [[
function mt:<!a!>()
end
function mt:b()
    mt:<?a?>()
end
]]

TEST [[
function mt:<!m1!>()
end
function mt:m2()
    self:<?m1?>()
end
]]

TEST [[
function mt:m3()
    mt:<?m4?>()
end
function mt:<!m4!>()
end
]]

TEST [[
function mt:m3()
    self:<?m4?>()
end
function mt:<!m4!>()
end
]]

TEST [[
local mt

function mt:f()
    self.<!x!> = 1
end

mt.<?x?>
]]

TEST [[
function G:f()
    self.<!x!> = 1
end

G.<?x?>
]]

TEST [[
function G.H:f()
    self.<!x!> = 1
end

G.H.<?x?>
]]
