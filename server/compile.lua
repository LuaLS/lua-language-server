local fs = require 'bee.filesystem'
local root = fs.current_path()

local function compileRelease()
    local msvc = require 'msvc'
    if not msvc:initialize(141, 'utf8') then
        error('Cannot found Visual Studio Toolset.')
    end

    local property = {
        Configuration = 'Release',
        Platform = 'x86'
    }
    msvc:compile('build', root / 'bee.lua' / 'bee.sln', property)
end

local function copyFile()
    local source = root / 'bee.lua' / 'bin' / 'msvc_x86_Release'
    local target = root / 'bin'
    for _, name in ipairs {
        'bee.dll',
        {'lua.exe', 'lua-language-server.exe'},
        'lua54.dll',
    } do
        if type(name) == 'string' then
            fs.copy_file(source / name, target / name, true)
        else
            fs.copy_file(source / name[1], target / name[2], true)
        end
    end
end

compileRelease()
copyFile()

print 'make complete.'
