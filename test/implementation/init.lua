local core  = require 'core.implementation'
local files = require 'files'
local vm    = require 'vm'
local catch = require 'catch'

rawset(_G, 'TEST', true)

local function founded(targets, results)
    if #targets ~= #results then
        return false
    end
    for _, target in ipairs(targets) do
        for _, result in ipairs(results) do
            if target[1] == result[1] and target[2] == result[2] then
                goto NEXT
            end
        end
        do return false end
        ::NEXT::
    end
    return true
end

---@async
function TEST(script)
    local newScript, catched = catch(script, '!?')

    files.setText(TESTURI, newScript)

    local results = core(TESTURI, catched['?'][1][1])
    if results then
        local positions = {}
        for i, result in ipairs(results) do
            if not vm.isMetaFile(result.uri) then
                positions[#positions+1] = { result.target.start, result.target.finish }
            end
        end
        assert(founded(catched['!'], positions))
    else        assert(#catched['!'] == 0)
    end

    files.remove(TESTURI)
end

TEST [[
---@class A
---@field x number
local M

M.<!x!> = 1


print(M.<?x?>)
]]

TEST [[
---@class A
---@field f fun()
local M

function M.<!f!>() end


print(M.<?f?>)
]]

TEST [[
---@class A
local M

function M:<!event!>(name) end

---@class A
---@field event fun(self, name: 'ev1')
---@field event fun(self, name: 'ev2')

---@type A
local m

m:<?event?>('ev1')
]]
