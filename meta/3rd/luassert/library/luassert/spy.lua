---@meta

---@class luassert_spy
---@return luassert_spy
local spy = function(callback)
end

---@param callback function
---@return function warp_callback
---@nodiscard
function spy.new(callback)
end


---comment spy function on obj[name]
---@param obj any
---@param name string
---@return any
---@nodiscard
function spy.on(obj, name)
end


---comment obj is spy
---@param obj any
---@return boolean
function spy.is_spy(obj)
end


function spy.returned_with(...)
end


function spy.called(...)
end


function spy.called_with(...)
end


---comment
---@param count integer
function spy.called_at_least(count)
end


---comment
---@param count integer
function spy.called_at_most(count)
end


---comment
---@param count integer
function spy.called_more_than(count)
end


---comment
---@param count integer
function spy.called_less_than(count)
end


return spy;
