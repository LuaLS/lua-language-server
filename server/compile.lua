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
    msvc:compile('build', root / 'bee.lua' / 'project' / 'bee.sln', property)
end

local function copyFile()
    local source = root / 'bee.lua' / 'bin' / 'msvc_x86_Release'
    local target = root / 'bin'
    for _, name in ipairs {'bee.dll', 'lua.exe', 'lua54.dll'} do
        fs.copy_file(source / name, target / name, true)
    end
end

compileRelease()
copyFile()

print 'make complete.'
