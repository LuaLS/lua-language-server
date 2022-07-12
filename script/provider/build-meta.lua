local fs     = require 'bee.filesystem'
local config = require 'config'
local util   = require 'utility'

local m = {}

---@class meta
---@field root    string
---@field classes meta.class[]

---@class meta.class
---@field namespace   string
---@field baseClass   string
---@field attribute   string
---@field integerface string[]
---@field fields      meta.field[]
---@field methods     meta.method[]

---@class meta.field
---@field name     string
---@field typeName string
---@field comment  string
---@field location string

---@class meta.method
---@field name           string
---@field comment        string
---@field location       string
---@field isStatic       boolean
---@field returnTypeName string
---@field params         {name: string, typeName: string}[]

---@param api meta
---@return string
local function buildText(api)
    local lines = {}
    for _, class in ipairs(api.classes) do
        
    end

    lines[#lines+1] = ''
    return table.concat(lines, '\n')
end

---@param name string
---@param api meta
function m.build(name, api)
    local encoding = config.get(nil, 'Lua.runtime.fileEncoding')
    local filePath = fs.path(METAPATH) / (name .. ' ' .. encoding .. '.lua')

    local text = buildText(api)

    util.saveFile(filePath:string(), text)
end

return m
