---@param rootPath string
---@return string?
local function loadVersion(rootPath)
    local changelog = ls.util.loadFile(rootPath .. '/changelog.md')
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

---@param rootPath string
---@return string
function M.getVersion(rootPath)
    if not M.version then
        M.version = loadVersion(rootPath) or '<Unknown>'
    end

    return M.version
end

return M
