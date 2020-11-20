local nonil = require 'without-check-nil'
local util  = require 'utility'

local m = {}

function m.client()
    nonil.enable()
    local name = m.info.clientInfo.name
    nonil.disable()
    return name
end

function m.init(t)
    log.debug('Client init', util.dump(t))
    m.info = t
end

return m
