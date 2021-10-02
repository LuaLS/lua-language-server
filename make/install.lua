local fs = require 'bee.filesystem'
local pf = require 'bee.platform'
local CWD = fs.current_path()
local output = CWD / 'bin' / pf.OS

if pf.OS == 'Windows' then
    require 'msvc'.copy_vcrt('x64', output)
end
