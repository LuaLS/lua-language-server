local noder  = require 'core.noder'
local files  = require 'files'
local util   = require 'utility'
local guide  = require 'parser.guide'

local function getSource(pos)
    local ast = files.getState('')
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
        noder.compileNodes(source)
        local result = {
            id = noder.getID(source),
        }

        expect['id'] = expect['id']:gsub('|', '\x1F')

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
    id   = 'l:7',
}

TEST [[
local x
<?x?> = 1
]] {
    id   = 'l:7',
}

TEST [[
print(<?X?>)
]] {
    id   = 'g:"X"',
}

TEST [[
print(<?X?>)
]] {
    id   = 'g:"X"',
}

TEST [[
local x
print(x.y.<?z?>)
]] {
    id   = 'l:7|"y"|"z"',
}

TEST [[
local x
function x:<?f?>() end
]] {
    id   = 'l:7|"f"',
}

TEST [[
print(X.Y.<?Z?>)
]] {
    id   = 'g:"X"|"Y"|"Z"',
}

TEST [[
function x:<?f?>() end
]] {
    id   = 'g:"x"|"f"',
}

TEST [[
{
    <?x?> = 1,
}
]] {
    id   = 't:1|"x"',
}

TEST [[
return <?X?>
]] {
    id      = 'g:"X"',
}

TEST [[
function f()
    return <?X?>
end
]] {
    id      = 'g:"X"',
}

TEST [[
::<?label?>::
goto label
]] {
    id      = 'l:5',
}

TEST [[
::label::
goto <?label?>
]] {
    id      = 'l:3',
}
