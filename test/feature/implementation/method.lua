TEST_IMPL [[
local mt = {}
function mt:<!m1!>()
end
mt:<?m1?>()
]]

TEST_IMPL [[
local mt = {}
function mt:<!m1!>()
end
function mt:m2()
    self:<?m1?>()
end
]]

TEST_IMPL [[
function <!foo!>()
end
<?foo?>()
]]

TEST_IMPL [[
function <!foo!>()
end
<?<!foo!>?> = nil
]]
