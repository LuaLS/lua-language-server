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

local obj = setmetatable({}, mt)
obj:<?method1?>()
]]

TEST [[
local mt
function mt:<!method1!>()
end

local obj = setmetatable({}, { __index = mt })
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

TEST [[
local sm = setmetatable
local mt
mt.__index = mt
function mt:<!method1!>()
end

local obj = sm({}, mt)
obj:<?method1?>()
]]

-- TODO 更换 meta__index 的实现
-- 表和__index之间不共享child
-- 编译完成后进行后处理，如果某个field只有读取操作，则将值链接到meta表中

--TEST [[
--local mt = {}
--function mt:<!x!>()
--end
--
--local obj = setmetatable({}, {__index = mt})
--function obj:x()
--end
--
--mt:<?x?>()
--]]
--
--TEST [[
--local mt = {}
--function mt:x()
--end
--
--local obj = setmetatable({}, {__index = mt})
--function obj:<!x!>()
--end
--
--obj:<?x?>()
--]]
