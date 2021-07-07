local fsu = require 'fs-utility'

local function loadVersion()
    local changelog = fsu.loadFile(ROOT / 'changelog.md')
    if not changelog then
        return
    end

    local version, pos = changelog:match '%#%# (%d+%.%d+%.%d+)()'
    if not version then
        return
    end

    if not changelog:find('^[\r\n]+`', pos) then
        version = version .. '-dev'
    end
    return version
end

local m = {}

function m.getVersion()
    if not m.version then
        m.version = loadVersion() or '<Unknown>'
    end

    return m.version
end

return m
