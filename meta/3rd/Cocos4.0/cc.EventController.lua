---@meta

---@class cc.EventController :cc.Event
local EventController={ }
cc.EventController=EventController




---*  Gets the event type of the controller.<br>
---* return The event type of the controller.
---@return int
function EventController:getControllerEventType () end
---*  Sets the connect status.<br>
---* param True if it's connected.
---@param isConnected boolean
---@return self
function EventController:setConnectStatus (isConnected) end
---*  Gets the connect status.<br>
---* return True if it's connected.
---@return boolean
function EventController:isConnected () end
---* 
---@param keyCode int
---@return self
function EventController:setKeyCode (keyCode) end
---* 
---@return cc.Controller
function EventController:getController () end
---*  Gets the key code of the controller.<br>
---* return The key code of the controller.
---@return int
function EventController:getKeyCode () end
---@overload fun(int:int,cc.Controller:cc.Controller,int2:boolean):self
---@overload fun(int:int,cc.Controller:cc.Controller,int:int):self
---@param type int
---@param controller cc.Controller
---@param keyCode int
---@return self
function EventController:EventController (type,controller,keyCode) end