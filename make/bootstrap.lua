local main
local i = 1
while arg[i] do
    if arg[i] == '-E' then
    elseif arg[i] == '-e' then
        i = i + 1
        local expr = assert(arg[i], "'-e' needs argument")
        assert(load(expr, "=(command line)"))()
        -- exit after the executing
        return
    elseif not main and arg[i]:sub(1, 1) ~= '-' then
        main = i
    end
    i = i + 1
end

if main then
    for i = -1, -999, -1 do
        if not arg[i] then
            for j = i + 1, -1 do
                arg[j - main + 1] = arg[j]
            end
            break
        end
    end
    for j = 1, #arg do
        arg[j - main] = arg[j]
    end
    for j = #arg - main + 1, #arg do
        arg[j] = nil
    end
else
    arg[0] = 'main.lua'
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
