local function loadVersion()
    local changelogUri = luals.uri.join(luals.runtime.rootUri, 'changelog.md')
    local changelog = luals.util.loadFile(luals.uri.decode(changelogUri))
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

---@class Runtime.VersionParser
local M = {}

---@return string
function M.getVersion()
    if not M.version then
        M.version = loadVersion() or '<Unknown>'
    end

    return M.version
end

return M
