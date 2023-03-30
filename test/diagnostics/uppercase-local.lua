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
    ['uppercase-local'] = 'Any!' -- override groupFileStatus
})

-- check that global elements are not warned about
TEST [[
Var1 = "global"
VAR2 = "global"

local x = true
local <!Y!> = false
local <!Var!> = false
]]

TEST [[
local function test1()
    print()
end

local function <!Test2!>()
    print()
end
]]

TEST [[
local function closure1()
    local elem1 = 1
    local <!Elem2!> = 2
end

local function <!Closure2!>()
    local elem1 = 1
    local <!Elem2!> = 2
end
]]

-- reset configurations
config.set(nil, 'Lua.diagnostics.groupFileStatus', 
{})
config.set(nil, 'Lua.diagnostics.neededFileStatus',
{})
config.set(nil, 'Lua.diagnostics.globals',
{})