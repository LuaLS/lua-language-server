local args = {}
local sep  = package.config:sub(1,1)
local main = '.' .. sep .. 'main.lua'

local i = 1
while arg[i] do
    if arg[i] == '-E' then
    elseif arg[i] == '-e' then
        i = i + 1
        local expr = assert(arg[i], "'-e' needs argument")
        assert(load(expr, "=(command line)"))()
    elseif arg[i]:sub(1, 1) == '-' then
        args[#args+1] = arg[i]
    else
        main = arg[i]
    end
    i = i + 1
end

local root; do
    local sepp = sep
    if sepp == '\\' then
        sepp = '/\\'
    end
    local pattern = "["..sepp.."][^"..sepp.."]+"
    root = package.cpath:match("([^;]+)"..pattern..pattern..pattern.."$")
end

local fs = require "bee.filesystem"
fs.current_path(fs.path(root))

package.path = table.concat({
    root .. "/script/?.lua",
    root .. "/script/?/init.lua",
}, ";")

assert(loadfile(main))(table.unpack(args))
