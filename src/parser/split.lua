local m = require 'lpeglabel'

local NL = m.P'\r\n' + m.S'\r\n'
local LINE = m.C(1 - NL)

return function (str)
    local MATCH = m.Ct((LINE * NL)^0 * LINE)
    return MATCH:match(str)
end
