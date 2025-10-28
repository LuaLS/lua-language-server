---@class PriorityQueue
local M = {}
M.__index = M

M.index = 0

---@type any[]?
M.orderedValues = nil

---@package
function M:init()
    self.scores = {}
    self.orders = {}
end

---@param value any
---@param score? number
function M:insert(value, score)
    self.index = self.index + 1
    self.scores[value] = score or 0
    self.orders[value] = self.index
    self.orderedValues = nil
end

function M:remove(value)
    self.scores[value] = nil
    self.orders[value] = nil
    self.orderedValues = nil
end

---@return any[]
function M:toArray()
    if not self.orderedValues then
        self.orderedValues = {}
        for value in pairs(self.scores) do
            self.orderedValues[#self.orderedValues+1] = value
        end
        table.sort(self.orderedValues, function (a, b)
            local scoreA = self.scores[a]
            local scoreB = self.scores[b]
            if scoreA == scoreB then
                return self.orders[a] < self.orders[b]
            else
                return scoreA > scoreB
            end
        end)
    end
    return self.orderedValues
end

---@return fun(): any, number?
function M:pairs()
    local values = self:toArray()
    local index = 0
    return function ()
        index = index + 1
        local value = values[index]
        if value then
            return value, self.scores[value]
        end
        return nil, nil
    end
end

---@class PriorityQueue.API
local API = {}

---@return PriorityQueue
function API.create()
    local self = setmetatable({}, M)
    self:init()
    return self
end

return API
