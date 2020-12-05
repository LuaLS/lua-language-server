local core = require 'core.reference'
local files = require 'files'

local function catch_target(script)
    local list = {}
    local cur = 1
    while true do
        local start, finish  = script:find('<[!?].-[!?]>', cur)
        if not start then
            break
        end
        list[#list+1] = { start + 2, finish - 2 }
        cur = finish + 1
    end
    return list
end

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

function TEST(script)
    files.removeAll()
    local target = catch_target(script)
    local start  = script:find('<[?~]')
    local finish = script:find('[?~]>')
    local pos = (start + finish) // 2 + 1
    local new_script = script:gsub('<[!?~]', '  '):gsub('[!?~]>', '  ')
    files.setText('', new_script)

    local results = core('', pos)
    if results then
        local positions = {}
        for i, result in ipairs(results) do
            positions[i] = { result.target.start, result.target.finish }
        end
        assert(founded(target, positions))
    else
        assert(#target == 0)
    end
end

TEST [[
local <?a?> = 1
<!a!> = <!a!>
]]

TEST [[
<?a?> = 1
<!a!> = <!a!>
]]

TEST [[
local t
t.<?a?> = 1
t.<!a!> = t.<!a!>
]]

TEST [[
t.<?a?> = 1
t.<!a!> = t.<!a!>
]]

TEST [[
:: <!LABEL!> ::
goto <?LABEL?>
if true then
    goto <!LABEL!>
end
]]

TEST [[
:: <?LABEL?> ::
goto <!LABEL!>
if true then
    goto <!LABEL!>
end
]]

TEST [[
local a = 1
local <?a?> = 1
<!a!> = <!a!>
]]

TEST [[
local t = {
    <!a!> = 1
}
print(t.<?a?>)
]]

TEST [[
local t = {
    <?a?> = 1
}
print(t.<!a!>)
]]

TEST [[
t[<?'a'?>] = 1
print(t.<!a!>)
]]

TEST [[
local t = {
    [<?'a'?>] = 1
}
print(t.<!a!>)
]]

TEST [[
table.<!dump!>()
function table.<?dump?>()
end
]]

TEST [[
local function f()
    return <~<!function~> ()
    end!>
end

local <!f2!> = f()
]]

TEST [[
local function f()
    return nil, <~<!function~> ()
    end!>
end

local _, <!f2!> = f()
]]

TEST [[
local <?x?>
local function f()
    return <!x!>
end
local y = f()
]]

TEST [[
local <?x?>
local function f()
    return function ()
        return <!x!>
    end
end
local y = f()()
]]

TEST [[
local t = {}
t.<?x?> = 1
t[a.b.x] = 1
]]

TEST [[
local t = {}
t.x = 1
t[a.b.<?x?>] = 1
]]

TEST [[
local t
local <!f!> = t.<?f?>

<!f!>()

return {
    <!f!> = <!f!>,
}
]]

TEST [[
self = {
    results = {
        <?labels?> = {},
    }
}
self[self.results.<!labels!>] = lbl
]]

TEST [[
a.b.<?c?> = 1
print(a.b.<!c!>)
]]

TEST [[
local <!mt!> = {}
function <!mt!>:x()
    <?self?>:x()
end
]]

TEST [[
local <?mt?> = {}
function <!mt!>:x()
    <!self!>:x()
end
]]

TEST [[
local mt = {}
function mt:<!x!>()
    self:<?x?>()
end
]]

TEST [[
local mt = {}
function mt:<?x?>()
    self:<!x!>()
end
]]

TEST [[
a.<!b!>.c = 1
print(a.<?b?>.c)
]]

TEST [[
local <?f?>
local t = {
    <!a!> = <!f!>
}
print(t.<!a!>)
]]

TEST [[
local <!f!>
local <!t!> = <?f?>
]]

TEST [[
local <!f!>
a.<!t!> = <?f?>
]]

TEST [[
<!t!>.f = <?t?>
]]

TEST [[
local <!f!>
local <?t?> = <!f!>
]]

TEST [[
local <!t!>
<!t!>.<!f!> = <?t?>
]]

TEST [[
_G.<?xxx?> = 1

print(<!xxx!>)
]]

TEST [[
---@class <!Class!>
---@type <?Class?>
---@type <!Class!>
]]

TEST [[
---@class <?Class?>
---@type <!Class!>
---@type <!Class!>
]]

TEST [[
---@class Class
local <?t?>
---@type Class
local <!x!>
]]

TEST [[
---@class Class
local <!t!>
---@type Class
local <?x?>
]]

-- BUG
TEST [[
---@return <?any?>
function f() end
]]

TEST [[
---@class Dog
local mt = {}
function mt:<?eat?>()
end

---@class Master
local mt2 = {}
function mt2:init()
    ---@type Dog
    local foo = self:doSomething()
    ---@type Dog
    self.dog = getDog()
end
function mt2:feed()
    self.dog:<!eat!>()
end
function mt2:doSomething()
end
]]
