---@class love
love = {}

---
---Gets the current running version of LÖVE.
---
---@return number major # The major version of LÖVE, i.e. 0 for version 0.9.1.
---@return number minor # The minor version of LÖVE, i.e. 9 for version 0.9.1.
---@return number revision # The revision version of LÖVE, i.e. 1 for version 0.9.1.
---@return string codename # The codename of the current version, i.e. 'Baby Inspector' for version 0.9.1.
function love.getVersion() end

---
---Gets whether LÖVE displays warnings when using deprecated functionality. It is disabled by default in fused mode, and enabled by default otherwise.
---
---When deprecation output is enabled, the first use of a formally deprecated LÖVE API will show a message at the bottom of the screen for a short time, and print the message to the console.
---
---@return boolean enabled # Whether deprecation output is enabled.
function love.hasDeprecationOutput() end

---
---Sets whether LÖVE displays warnings when using deprecated functionality. It is disabled by default in fused mode, and enabled by default otherwise.
---
---When deprecation output is enabled, the first use of a formally deprecated LÖVE API will show a message at the bottom of the screen for a short time, and print the message to the console.
---
---@param enable boolean # Whether to enable or disable deprecation output.
function love.setDeprecationOutput(enable) end

---@class love.Data: love.Object
local Data = {}

---
---Creates a new copy of the Data object.
---
---@return love.Data clone # The new copy.
function Data:clone() end

---
---Gets an FFI pointer to the Data.
---
---This function should be preferred instead of Data:getPointer because the latter uses light userdata which can't store more all possible memory addresses on some new ARM64 architectures, when LuaJIT is used.
---
---@return ffi.cdata* pointer # A raw void* pointer to the Data, or nil if FFI is unavailable.
function Data:getFFIPointer() end

---
---Gets a pointer to the Data. Can be used with libraries such as LuaJIT's FFI.
---
---@return lightuserdata pointer # A raw pointer to the Data.
function Data:getPointer() end

---
---Gets the Data's size in bytes.
---
---@return number size # The size of the Data in bytes.
function Data:getSize() end

---
---Gets the full Data as a string.
---
---@return string data # The raw data.
function Data:getString() end

---@class love.Object
local Object = {}

---
---Destroys the object's Lua reference. The object will be completely deleted if it's not referenced by any other LÖVE object or thread.
---
---This method can be used to immediately clean up resources without waiting for Lua's garbage collector.
---
---@return boolean success # True if the object was released by this call, false if it had been previously released.
function Object:release() end

---
---Gets the type of the object as a string.
---
---@return string type # The type as a string.
function Object:type() end

---
---Checks whether an object is of a certain type. If the object has the type with the specified name in its hierarchy, this function will return true.
---
---@param name string # The name of the type to check for.
---@return boolean b # True if the object is of the specified type, false otherwise.
function Object:typeOf(name) end
