local platform = require 'bee.platform'

assert(_VERSION == 'Lua 5.4', '必须是 Lua 5.4')

local arch = (function()
    if string.packsize then
        local size = string.packsize "T"
        if size == 8 then
            return 64
        end
        if size == 4 then
            return 32
        end
    else
        if platform ~= "windows" then
            return 64
        end
        local size = #tostring(io.stderr)
        if size <= 15 then
            return 32
        end
        return 64
    end
    assert(false, "unknown arch")
end)()

assert(arch == 64, '必须是 x84_64')
