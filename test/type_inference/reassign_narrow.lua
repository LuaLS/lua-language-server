-- Narrowing across if-blocks that reassign the variable, when an earlier
-- query position inside the branch is compiled first (as happens in a real
-- editor session). Regression tests for the revert in 3.18.2: the circular
-- dependency guard must not lose the branch assignment's type in code after
-- the block.
local files = require 'files'
local guide = require 'parser.guide'
local catch = require 'catch'
local vm    = require 'vm'

local function getSource(pos)
    local state = files.getState(TESTURI)
    if not state then
        return
    end
    local result
    guide.eachSourceContain(state.ast, pos, function (source)
        if source.type == 'local'
        or source.type == 'getlocal'
        or source.type == 'setlocal'
        or source.type == 'setglobal'
        or source.type == 'getglobal'
        or source.type == 'field'
        or source.type == 'method'
        or source.type == 'function'
        or source.type == 'table'
        or source.type == 'doc.type.name' then
            result = source
        end
    end)
    return result
end

-- Queries `<?...?>` first and `<!...!>` second against the same file text,
-- so caches populated by the first query are visible to the second.
local function TEST2(wanted1, wanted2)
    return function (script)
        local newScript, catched = catch(script, '?!')
        files.setText(TESTURI, newScript)
        local source1 = getSource(catched['?'][1][1])
        assert(source1)
        local result1 = vm.getInfer(source1):view(TESTURI)
        assert(wanted1 == result1, ('Query 1 failed! Wanted: %s Got: %s'):format(wanted1, result1))
        local source2 = getSource(catched['!'][1][1])
        assert(source2)
        local result2 = vm.getInfer(source2):view(TESTURI)
        assert(wanted2 == result2, ('Query 2 failed! Wanted: %s Got: %s'):format(wanted2, result2))
        files.remove(TESTURI)
    end
end

TEST2('string', 'string?') [[
---@type integer?
local x

if x then
    x = x .. 's'
    print(<?x?>)
end

print(<!x!>)
]]

TEST2('integer', 'integer?') [[
---@type integer?
local x

if x then
    x = x + 1
    print(<?x?>)
end

print(<!x!>)
]]

TEST2('string', 'string?') [[
---@type integer?
local x

if x then
    x = tostring(x)
    print(<?x?>)
end

print(<!x!>)
]]

TEST2('string', 'string|integer') [[
---@type integer?
local x

if not x then
    x = 's' .. tostring(x)
    print(<?x?>)
end

print(<!x!>)
]]
