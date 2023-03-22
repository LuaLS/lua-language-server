local config = require 'config'
local util   = require 'utility'

-- disable all default groups to make isolated tests
config.set(nil, 'Lua.diagnostics.groupFileStatus', 
{
    ['ambiguity']     = 'None',
    ['await']         = 'None',
    ['codestyle']     = 'None',
    ['strict-conventions']   = 'None',
    ['duplicate']     = 'None',
    ['global']        = 'None',
    ['luadoc']        = 'None',
    ['redefined']     = 'None',
    ['strict']        = 'None',
    ['strong']        = 'None',
    ['type-check']    = 'None',
    ['unbalanced']    = 'None',
    ['unused']        = 'None'
})

-- enable single diagnostic that is to be tested
config.set(nil, 'Lua.diagnostics.neededFileStatus',
{
    ['global-element'] = 'Any!' -- override groupFileStatus
})

-- check that local elements are not warned about
TEST [[
local x = 123
x = 321
<!Y!> = "global"
<!z!> = "global"
]]

TEST [[
local function test1()
    print()
end

function <!Test2!>()
    print()
end
]]

TEST [[
local function closure1()
    local elem1 = 1
    <!elem2!> = 2
end

function <!Closure2!>()
    local elem1 = 1
    <!elem2!> = 2
end
]]

-- add elements to exemption list
config.set(nil, 'Lua.diagnostics.globals',
{
    'GLOBAL1',
    'GLOBAL2',
    'GLOBAL_CLOSURE'
})

TEST [[
GLOBAL1 = "allowed"
<!global2!> = "not allowed"
<!GLOBAL3!> = "not allowed"
]]

TEST [[
function GLOBAL1()
    print()
end
]]

TEST [[
local function closure1()
    local elem1 = 1
    GLOBAL1 = 2
end

function GLOBAL_CLOSURE()
    local elem1 = 1
    GLOBAL2 = 2
    <!elem2!> = 2
end
]]

-- reset configurations
config.set(nil, 'Lua.diagnostics.groupFileStatus', 
{})
config.set(nil, 'Lua.diagnostics.neededFileStatus',
{})
config.set(nil, 'Lua.diagnostics.globals',
{})