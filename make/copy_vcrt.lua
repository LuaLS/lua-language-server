local output, arch = ...
local fs = require 'bee.filesystem'
require 'msvc'.copy_vcrt(
    arch == "x86" and 'x86' or 'x64',
    fs.current_path() / output
)
