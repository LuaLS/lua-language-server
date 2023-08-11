local config = require 'config'

TEST [[
local <!x!>
]]

TEST [[
local y
local x <close> = y
]]

TEST [[
local function x()
end
x()
]]

TEST [[
return function (x)
    x.a = 1
end
]]

TEST [[
local <!t!> = {}
<!t!>.a = 1
]]

TEST [[
InstanceName = 1
Instance = _G[InstanceName]
]]

TEST [[
local _ = (''):sub(1, 2)
]]

TEST [[
local mt, x
function mt:m()
    function x:m()
    end
end
return mt, x
]]

TEST [[
local mt = {}
function mt:f()
end
return mt
]]

TEST [[
local <!mt!> = {}
function <!mt!>:f()
end
]]

TEST [[
local <!x!> = {}
<!x!>.a = 1
]]

TEST [[
local <!x!> = {}
<!x!>['a'] = 1
]]

TEST [[
local function f(<!self!>)
    return 'something'
end
f()
]]

TEST [[
local function f(var)
    print(var)
end
local var
f(var)
]]

TEST [[
local <!t!> = {}
<!t!>[1] = 1
]]

config.add(nil, 'Lua.diagnostics.unusedLocalExclude', 'll_*')

TEST [[
local <!xx!>
local ll_1
local ll_2
local <!ll!>
]]

config.remove(nil, 'Lua.diagnostics.unusedLocalExclude', 'll_*')
