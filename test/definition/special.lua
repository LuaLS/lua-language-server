TEST [[
_ENV.<!x!> = 1
print(<?x?>)
]]

TEST [[
_G.<!x!> = 1
print(<?x?>)
]]

TEST [[
<!rawset(_G, 'x', 1)!>
print(<?x?>)
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
function mt:<!method1!>()
end

setmetatable(api, { __index = mt })
api:<?method1?>()
]]

TEST [[
local mt
local api
function mt:<!method1!>()
end

setmetatable(api, { __index = mt })
api:<?method1?>()
]]

-- TODO 不支持从方法内部找外部的赋值
--TEST [[
--local mt
--function mt:x()
--    self.<?init?>()
--end
--
--local obj, _ = setmetatable({}, { __index = mt })
--obj.<!init!> = 1
--obj:x()
--]]

-- TODO 不支持从方法内部找外部的赋值
--TEST [[
--local mt
--function mt:x()
--    self.<?init?>()
--end
--
--local obj = setmetatable({ <!init!> = 1 }, { __index = mt })
--obj:x()
--]]

-- TODO 不支持从方法内部找外部的赋值
--TEST [[
--local mt
--function mt:x()
--    self.a.<?out?>()
--end
--
--local obj = setmetatable({
--    a = {
--        <!out!> = 1,
--    }
--}, { __index = mt })
--obj:x()
--]]

TEST [[
local sm = setmetatable
local mt
mt.__index = mt
function mt:<!method1!>()
end

local obj = sm({}, mt)
obj:<?method1?>()
]]

TEST [[
local mt = {}
function mt:<!x!>()
end

local obj = setmetatable({}, {__index = mt})
function obj:x()
end

mt:<?x?>()
]]

-- TODO 通过代码执行顺序来判断?
TEST [[
local mt = {}
function mt:<!x!>()
end

local obj = setmetatable({}, {__index = mt})
function obj:<!x!>()
end

obj:<?x?>()
]]

TEST [[
local mt = {}

mt.<!xx!> = 1

mt.yy = function (self)
    print(self.<?xx?>)
end
]]
