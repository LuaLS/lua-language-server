---@meta

---@class cc.EventListener :cc.Ref
local EventListener={ }
cc.EventListener=EventListener




---*  Enables or disables the listener.<br>
---* note Only listeners with `enabled` state will be able to receive events.<br>
---* When an listener was initialized, it's enabled by default.<br>
---* An event listener can receive events when it is enabled and is not paused.<br>
---* paused state is always false when it is a fixed priority listener.<br>
---* param enabled True if enables the listener.
---@param enabled boolean
---@return self
function EventListener:setEnabled (enabled) end
---*  Checks whether the listener is enabled.<br>
---* return True if the listener is enabled.
---@return boolean
function EventListener:isEnabled () end
---*  Clones the listener, its subclasses have to override this method.
---@return self
function EventListener:clone () end
---*  Checks whether the listener is available.<br>
---* return True if the listener is available.
---@return boolean
function EventListener:checkAvailable () end