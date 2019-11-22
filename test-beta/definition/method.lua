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
