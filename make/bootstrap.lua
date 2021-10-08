local i = 1
while true do
    if arg[i] == '-E' then
    elseif arg[i] == '-e' then
        i = i + 1
        local expr = assert(arg[i], "'-e' needs argument")
        assert(load(expr, "=(command line)"))()
    else
        break
    end
    i = i + 1
end

if arg[i] == nil then
    return
end

for j = -1, #arg do
    arg[j - i] = arg[j]
end
for j = #arg - i + 1, #arg do
    arg[j] = nil
end

local root; do
    local sep = package.config:sub(1,1)
    if sep == '\\' then
        sep = '/\\'
    end
    local pattern = "["..sep.."][^"..sep.."]+"
    root = package.cpath:match("([^;]+)"..pattern..pattern..pattern.."$")
end

local fs = require "bee.filesystem"
fs.current_path(fs.path(root))

package.path = table.concat({
    root .. "/script/?.lua",
    root .. "/script/?/init.lua",
}, ";")
assert(loadfile(arg[0]))(table.unpack(arg))
