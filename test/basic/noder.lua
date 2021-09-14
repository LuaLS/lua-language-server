local noder  = require 'core.noder'
local files  = require 'files'
local util   = require 'utility'
local guide  = require 'parser.guide'
local catch  = require 'catch'

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
        local newScript, catched = catch(script, '?')
        files.setText('', newScript)
        local source = getSource(catched['?'][1][1])
        assert(source)
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
    id   = 'l:6',
}

TEST [[
local x
print(<?x?>)
]] {
    id   = 'l:6',
}

TEST [[
local x
<?x?> = 1
]] {
    id   = 'l:6',
}

TEST [[
print(<?X?>)
]] {
    id   = 'g:.X',
}

TEST [[
print(<?X?>)
]] {
    id   = 'g:.X',
}

TEST [[
local x
print(x.y.<?z?>)
]] {
    id   = 'l:6|.y|.z',
}

TEST [[
local x
function x:<?f?>() end
]] {
    id   = 'l:6|.f',
}

TEST [[
print(X.Y.<?Z?>)
]] {
    id   = 'g:.X|.Y|.Z',
}

TEST [[
function x:<?f?>() end
]] {
    id   = 'g:.x|.f',
}

TEST [[
{
    <?x?> = 1,
}
]] {
    id   = 't:0|.x',
}

TEST [[
return <?X?>
]] {
    id      = 'g:.X',
}

TEST [[
function f()
    return <?X?>
end
]] {
    id      = 'g:.X',
}

TEST [[
::<?label?>::
goto label
]] {
    id      = 'l:2',
}

TEST [[
::label::
goto <?label?>
]] {
    id      = 'l:2',
}
