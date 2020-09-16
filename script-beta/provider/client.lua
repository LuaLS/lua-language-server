local nonil = require 'without-check-nil'

local m = {}

function m.client()
    nonil.enable()
    local name = m.info.clientInfo.name
    nonil.disable()
    return name
end

function m.init(t)
    m.info = t
end

return m
