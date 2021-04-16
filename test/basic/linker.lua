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
TEST [[
local <?x?>
]] {
    id   = 'l:9',
}

TEST [[
local x
print(<?x?>)
]] {
    id   = '7',
    mode = 'local',
}

TEST [[
local x
<?x?> = 1
]] {
    id   = '7',
    mode = 'local',
}

TEST [[
print(<?X?>)
]] {
    id   = '"X"',
    mode = 'global',
}

TEST [[
print(<?X?>)
]] {
    id   = '"X"',
    mode = 'global',
}

TEST [[
local x
print(x.y.<?z?>)
]] {
    id   = '7|"y"|"z"',
    mode = 'local',
}

TEST [[
local x
function x:<?f?>() end
]] {
    id   = '7|"f"',
    mode = 'local',
}

TEST [[
print(X.Y.<?Z?>)
]] {
    id   = '"X"|"Y"|"Z"',
    mode = 'global',
}

TEST [[
function x:<?f?>() end
]] {
    id   = '"x"|"f"',
    mode = 'global',
}

TEST [[
{
    <?x?> = 1,
}
]] {
    id   = '1|"x"',
    mode = 'table',
}

CARE['freturn'] = true
TEST [[
return <?X?>
]] {
    id      = '"X"',
    mode    = 'global',
    freturn = 0,
}

TEST [[
function f()
    return <?X?>
end
]] {
    id      = '"X"',
    mode    = 'global',
    freturn = 1,
}

TEST [[
::<?label?>::
goto label
]] {
    id      = '5',
    mode    = 'local',
}

TEST [[
::label::
goto <?label?>
]] {
    id      = '3',
    mode    = 'local',
}
