---@class Node.Flow: Node.RefModule
local M = Class 'Node.Flow'

Extends('Node.Flow', 'Node.RefModule')

---@class Node.Flow.VariableInfo
---@field var   Node.Variable
---@field start integer

---@class Node.Flow.Action
---@field kind 'assign'
---@field info Node.Flow.VariableInfo

---@param scope Scope
---@param location Node.Location
function M:__init(scope, location)
    self.scope = scope
    self.location = location
    ---@private
    ---@type table<Node.Variable, Node.Flow.VariableInfo[]>
    self.variables = {}
    ---@type Node.Flow.Action[]
    self.actions = {}
end

---@param var Node.Variable
---@param offset integer
function M:addVariable(var, offset)
    local master = var:getMasterVariable()
    if not self.variables[master] then
        self.variables[master] = {}
    end
    table.insert(self.variables[master], {
        var   = var,
        start = offset,
    })
end

---@type boolean
M.runned = nil

M.__getter.runned = function ()
    return false, true
end

function M:run()
    if self.runned then
        return
    end
    self.runned = true

    for v in pairs(self.variables) do
        self.variables[v] = {}
    end

    for _, action in ipairs(self.actions) do
        local kind = action.kind
    end
end

---@param var Node.Variable
---@param offset integer
---@return Node
function M:variable(var, offset)
    local infos = self.variables[var]
    if not infos then
        return var.scope.rt.UNKNOWN
    end
    local result = var
    for _, info in ipairs(infos) do
        if offset >= info.start then
            result = info.var
        else
            break
        end
    end
    return result
end
