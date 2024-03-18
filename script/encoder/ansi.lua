local platform = require 'bee.platform'
local windows

if platform.os == 'windows' then
    windows = require 'bee.windows'
end

local m = {}

function m.toutf8(text)
    if not windows then
        return text
    end
    return windows.a2u(text)
end

function m.fromutf8(text)
    if not windows then
        return text
    end
    return windows.u2a(text)
end

return m
