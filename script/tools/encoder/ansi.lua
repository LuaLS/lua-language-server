local platform = require 'bee.platform'
local win

if platform.os == 'windows' then
    win = require 'bee.windows'
end

local m = {}

function m.toutf8(text)
    if not win then
        return text
    end
    return win.a2u(text)
end

function m.fromutf8(text)
    if not win then
        return text
    end
    return win.u2a(text)
end

return m
