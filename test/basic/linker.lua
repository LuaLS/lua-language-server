local linker = require 'core.linker'
local files  = require 'files'
local util   = require 'utility'
local guide  = require 'core.guide'

local function getSource(pos)
    local ast = files.getAst('')
    return guide.eachSourceContain(ast.ast, pos, function (source)
        if source.type == 'local'
        or source.type == 'getlocal'
        or source.type == 'setlocal'
        or source.type == 'setglobal'
        or source.type == 'getglobal'
        or source.type == 'setfield'
        or source.type == 'getfield'
        or source.type == 'setmethod'
        or source.type == 'getmethod'
        or source.type == 'tablefield'
        or source.type == 'setindex'
        or source.type == 'getindex'
        or source.type == 'tableindex'
        or source.type == 'label'
        or source.type == 'goto' then
            return source
        end
    end)
end

local CARE = {}
local function TEST(script)
    return function (expect)
        files.removeAll()
        local start  = script:find('<?', 1, true)
        local finish = script:find('?>', 1, true)
        local pos = (start + finish) // 2 + 1
        local newScript = script:gsub('<[!?]', '  '):gsub('[!?]>', '  ')
        files.setText('', newScript)
        local source = getSource(pos)
        assert(source)
        local result = linker.getLink(source)
        for key in pairs(CARE) do
            assert(result[key] == expect[key])
        end
    end
end

CARE['id'] = true
CARE['loc'] = true
TEST [[
local <?x?>
]] {
    id  = '9',
    loc = true,
}

TEST [[
local x
print(<?x?>)
]] {
    id  = '7',
    loc = true,
}

TEST [[
local x
<?x?> = 1
]] {
    id  = '7',
    loc = true,
}

CARE['global'] = true
TEST [[
print(<?X?>)
]] {
    id     = '"X"',
    global = true,
}

TEST [[
print(<?X?>)
]] {
    id     = '"X"',
    global = true,
}

TEST [[
local x
print(x.y.<?z?>)
]] {
    id  = '7|"y"|"z"',
    loc = true,
}

TEST [[
local x
function x:<?f?>() end
]] {
    id  = '7|"f"',
    loc = true,
}

TEST [[
print(X.Y.<?Z?>)
]] {
    id     = '"X"|"Y"|"Z"',
    global = true,
}

TEST [[
function x:<?f?>() end
]] {
    id     = '"x"|"f"',
    global = true,
}

CARE['tfield'] = true
TEST [[
{
    <?x?> = 1,
}
]] {
    id     = '1|"x"',
    tfield = true,
}

CARE['freturn'] = true
TEST [[
return <?X?>
]] {
    id      = '"X"',
    global  = true,
    freturn = 0,
}

TEST [[
function f()
    return <?X?>
end
]] {
    id      = '"X"',
    global  = true,
    freturn = 1,
}

TEST [[
::<?label?>::
goto label
]] {
    id      = '5',
    loc     = true,
}

TEST [[
::label::
goto <?label?>
]] {
    id      = '3',
    loc     = true,
}
