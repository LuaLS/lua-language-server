---@meta

---
---`lovr` is the single global table that is exposed to every LÖVR app. It contains a set of **modules** and a set of **callbacks**.
---
---@class lovr
lovr = {}

---
---Get the current major, minor, and patch version of LÖVR.
---
---@return number major # The major version.
---@return number minor # The minor version.
---@return number patch # The patch number.
function lovr.getVersion() end

---
---This is not a real object, but describes the behavior shared by all objects.  Think of it as the superclass of all LÖVR objects.
---
---In addition to the methods here, all objects have a `__tostring` metamethod that returns the name of the object's type.  So to check if a LÖVR object is an instance of "Blob", you can do `tostring(object) == 'Blob'`.
---
---@class lovr.Object
local Object = {}

---
---Immediately destroys Lua's reference to the object it's called on.  After calling this function on an object, it is an error to do anything with the object from Lua (call methods on it, pass it to other functions, etc.).  If nothing else is using the object, it will be destroyed immediately, which can be used to destroy something earlier than it would normally be garbage collected in order to reduce memory.
---
function Object:release() end
