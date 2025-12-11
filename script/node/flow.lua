---@class Node.Flow: Node.RefModule
local M = Class 'Node.Flow'

Extends('Node.Flow', 'Node.RefModule')

---@class Node.Flow.VariableInfo
---@field value Node
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
function M:addVariable(var)
    if self.variables[var] then
        return
    end
    self.variables[var] = {}
    var.flow = self
    self:addRef(var)
    var:addRef(self)
end

---@param var Node.Variable
---@param node Node
---@param offset integer
function M:addAssign(var, node, offset)
    self:addVariable(var)
    self.actions[#self.actions+1] = {
        kind = 'assign',
        info = {
            value = node,
            start = offset,
        },
    }
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
        if kind == 'assign' then
            self:parseAssign(action.info)
        end
    end
end

---@param info Node.Flow.VariableInfo
function M:parseAssign(info)
    local value = info.value
    if value.kind == 'variable' then
        ---@cast value Node.Variable
        if value.flow then
            value = value.flow:variable(value, info.start)
        end
    end
    table.insert(self.variables[value], {
        value = value,
        start = info.start,
    })
end

---@param var Node.Variable
---@param offset integer
---@return Node
function M:variable(var, offset)
    self:run()

    local infos = self.variables[var]
    if not infos then
        return var.scope.rt.UNKNOWN
    end
    return var
end
