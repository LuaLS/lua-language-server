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
