---@class vm
---@field memoryAPI? table
local vm = require 'vm.vm'

---@class vm.memoryAPI
---@field root    string
---@field classes vm.memoryAPI.class[]

---@class vm.memoryAPI.class
---@field namespace   string
---@field baseClass   string
---@field attribute   string
---@field integerface string[]
---@field fields      vm.memoryAPI.field[]
---@field methods     vm.memoryAPI.method[]

---@class vm.memoryAPI.field
---@field name     string
---@field typeName string
---@field comment  string
---@field location string

---@class vm.memoryAPI.method
---@field name           string
---@field comment        string
---@field location       string
---@field isStatic       boolean
---@field returnTypeName string
---@field params         {name: string, typeName: string}[]

---@param api vm.memoryAPI
function vm.saveMemoryAPI(api)
    vm.memoryAPI = api
end
