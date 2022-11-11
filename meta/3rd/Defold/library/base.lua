------@meta
---
---
---@class vector3
---@field x number
---@field y number
---@field z number
---@operator sub(vector3): vector3
---@operator add(vector3): vector3

---@class vector4
---@field x number
---@field y number
---@field z number
---@field w number
---@operator sub(vector4): vector4
---@operator add(vector4): vector4

---@class quaternion
---@field x number
---@field y number
---@field z number
---@field w number

---@alias quat quaternion

---@class url string|hash
---@field socket string|hash
---@field path string|hash
---@field fragment string|hash

---@alias hash userdata
---@alias constant userdata
---@alias bool boolean
---@alias float number
---@alias object userdata
---@alias matrix4 userdata
---@alias node userdata

--mb use number instead of vector4
---@alias vector vector4

--luasocket
---@alias master userdata
---@alias unconnected userdata
---@alias client userdata

--render
---@alias constant_buffer userdata
---@alias render_target userdata
---@alias predicate userdata

--- Calls error if the value of its argument `v` is false (i.e., **nil** or
--- **false**); otherwise, returns all its arguments. In case of error,
--- `message` is the error object; when absent, it defaults to "assertion
--- failed!"
---@generic ANY
---@overload fun(v:any):any
---@param v ANY
---@param message string
---@return ANY
function assert(v,message) return v end

---@param self object
function init(self) end

---@param self object
---@param dt number
function update(self, dt) end

---@param self object
---@param message_id hash
---@param message table
---@param sender url
function on_message(self, message_id, message, sender) end

---@param self object
---@param action_id hash
---@param action table
function on_input(self, action_id, action) end

---@param self object
function final(self) end;
