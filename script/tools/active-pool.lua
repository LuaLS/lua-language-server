local lk = ls.tools.linkedTable

---@class ActivePool
local M = {}
M.__index = M

---@param rules [integer, number][] # array of [keepNum, aliveTime]
function M:init(rules)
    self.rules = {}
    self.nodes = lk.create()
    self.timeMap = {}

    for i, rule in ipairs(rules) do
        self.rules[i] = rule
    end
    table.sort(self.rules, function (a, b)
        return a[1] > b[1]
    end)
end

---@param obj any
---@param time number
function M:push(obj, time)
    self.nodes:pop(obj)
    self.nodes:pushTail(obj)
    self.timeMap[obj] = time
end

---@param time number
---@param onTimeUp? fun(obj: any)
function M:update(time, onTimeUp)
    local timeUps = {}
    for i, rule in ipairs(self.rules) do
        local keepNum   = rule[1]
        local aliveTime = rule[2]
        local nextRule = self.rules[i + 1]

        while self.nodes:getSize() <= keepNum do
            if nextRule and self.nodes:getSize() <= nextRule[1] then
                goto next
            end
            local obj = self.nodes:getHead()
            if not obj then
                goto over
            end
            local objTime = self.timeMap[obj]
            if time - objTime <= aliveTime then
                goto over
            end

            self.nodes:pop(obj)
            self.timeMap[obj] = nil
            timeUps[#timeUps+1] = obj
        end
        ::next::
    end

    ::over::

    if onTimeUp then
        for _, obj in ipairs(timeUps) do
            onTimeUp(obj)
        end
    end
end

---@return any[]
function M:toArray()
    return self.nodes:toArray()
end

---@class ActivePool.API
local API = {}

---@param rules [integer, number][] # array of [keepNum, aliveTime]
---@return ActivePool
function API.create(rules)
    local ap = setmetatable({}, M)
    ap:init(rules)
    return ap
end

return API
