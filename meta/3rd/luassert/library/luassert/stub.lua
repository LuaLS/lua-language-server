---@meta

---@class luassert_stub : luassert_spy
---@param object any
---@param key string
---@param function_or_return1? function|any
---@param ... any @result values
---@return luassert_stub
local stub = function(object, key, function_or_return1, ...)
end

---@param object any
---@param key string
---@param function_or_return1? function|any
---@param ... any @result values
---@return luassert_stub
function stub.new(object, key, function_or_return1, ...)
end


function stub:revert()
end

return stub
