---@class Global
---@field package name string
---@field package links table<uri, GlobalLink>
local Global = C.class 'Global'

---@type table<string, Global>
Global._all = {}
---@type table<uri, table<string, boolean>>
Global._subscription = ls.util.multiTable(2)

function Global:__call(name)
    self.name  = name
    self.links = ls.util.multiTable(2, function ()
        return C.new 'GlobalLink' ()
    end)
    return self
end

---@class GlobalLink
---@field sets parser.object[]
---@field gets parser.object[]
local GlobalLink = C.class 'GlobalLink'

function GlobalLink:__call()
    self.sets = {}
    self.gets = {}
    return self
end
