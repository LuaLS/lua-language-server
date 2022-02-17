local util = require 'utility'

---@class parser.object
---@field _localID string

local compileMap = util.switch()
    : getMap()

local m = {}

m.ID_SPLITE = '\x1F'

function m.getID(source)
    local compiler = compileMap[source.type]
    if compiler then
        return compiler(source)
    end
    return false
end

return m
