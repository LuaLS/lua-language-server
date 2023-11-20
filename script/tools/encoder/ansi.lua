local platform = require 'bee.platform'
local unicode

if platform.OS == 'Windows' then
    unicode = require 'bee.unicode'
end

local m = {}

function m.toutf8(text)
    if not unicode then
        return text
    end
    return unicode.a2u(text)
end

function m.fromutf8(text)
    if not unicode then
        return text
    end
    return unicode.u2a(text)
end

return m
