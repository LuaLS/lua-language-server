local nonil = require 'without-check-nil'
local util  = require 'utility'
local lang  = require 'language'

local m = {}

function m.client(newClient)
    if newClient then
        m._client = newClient
    else
        return m._client
    end
end

function m.init(t)
    log.debug('Client init', util.dump(t))
    m.info = t
    nonil.enable()
    m.client(t.clientInfo.name)
    nonil.disable()
    lang(t.locale)
end

return m
