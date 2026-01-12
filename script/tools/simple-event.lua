---@class SimpleEvent
local M = Class 'SimpleEvent'

function M:__init()
    self.events = {}
end

---@param callback fun(...)
---@return function unsubscribe
function M:on(callback)
    table.insert(self.events, callback)
    return function ()
        for i, cb in ipairs(self.events) do
            if cb == callback then
                table.remove(self.events, i)
                return
            end
        end
    end
end

---@param callback fun(...)
---@return function unsubscribe
function M:once(callback)
    local unsubscribe
    unsubscribe = self:on(function (...)
        unsubscribe()
        callback(...)
    end)
    return unsubscribe
end

function M:fire(...)
    for _, callback in ipairs(self.events) do
        xpcall(callback, log.error, ...)
    end
end

return {
    create = function ()
        return New 'SimpleEvent' ()
    end
}
