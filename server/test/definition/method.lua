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
mt.__index = mt
function mt:<!method1!>()
end

local obj = setmetatable({}, mt)
obj:<?method1?>()
]]

TEST [[
local mt
mt.__index = mt
function mt:<!method1!>()
end

local obj = setmetatable(1, mt)
obj:<?method1?>()
]]

TEST [[
local mt
function mt:<!method1!>()
end

local obj = setmetatable(1, { __index = mt })
obj:<?method1?>()
]]

TEST [[
local mt
local api
function mt:<!method1!>()
end

setmetatable(api, { __index = mt })
api:<?method1?>()
]]

TEST [[
local mt
function mt:x()
    self.<?init?>()
end

local obj = setmetatable({}, { __index = mt })
obj.<!init!> = 1
]]

TEST [[
local mt
function mt:x()
    self.<?init?>()
end

local obj = setmetatable({ <!init!> = 1 }, { __index = mt })
]]

TEST [[
local mt
function mt:x()
    self.a.<?out?>()
end

local obj = setmetatable({
    a = {
        <!out!> = 1,
    }
}, { __index = mt })
]]
