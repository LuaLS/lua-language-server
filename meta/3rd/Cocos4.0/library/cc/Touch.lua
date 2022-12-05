---@meta

---@class cc.Touch :cc.Ref
local Touch={ }
cc.Touch=Touch




---*  Returns the previous touch location in screen coordinates. <br>
---* return The previous touch location in screen coordinates.
---@return vec2_table
function Touch:getPreviousLocationInView () end
---*  Returns the current touch location in OpenGL coordinates.<br>
---* return The current touch location in OpenGL coordinates.
---@return vec2_table
function Touch:getLocation () end
---*  Returns the delta of 2 current touches locations in screen coordinates.<br>
---* return The delta of 2 current touches locations in screen coordinates.
---@return vec2_table
function Touch:getDelta () end
---*  Returns the start touch location in screen coordinates.<br>
---* return The start touch location in screen coordinates.
---@return vec2_table
function Touch:getStartLocationInView () end
---*  Returns the current touch force for 3d touch.<br>
---* return The current touch force for 3d touch.
---@return float
function Touch:getCurrentForce () end
---*  Returns the start touch location in OpenGL coordinates.<br>
---* return The start touch location in OpenGL coordinates.
---@return vec2_table
function Touch:getStartLocation () end
---*  Get touch id.<br>
---* js getId<br>
---* lua getId<br>
---* return The id of touch.
---@return int
function Touch:getID () end
---@overload fun(int:int,float:float,float:float,float:float,float:float):self
---@overload fun(int:int,float:float,float:float):self
---@param id int
---@param x float
---@param y float
---@param force float
---@param maxForce float
---@return self
function Touch:setTouchInfo (id,x,y,force,maxForce) end
---*  Returns the maximum touch force for 3d touch.<br>
---* return The maximum touch force for 3d touch.
---@return float
function Touch:getMaxForce () end
---*  Returns the current touch location in screen coordinates.<br>
---* return The current touch location in screen coordinates.
---@return vec2_table
function Touch:getLocationInView () end
---*  Returns the previous touch location in OpenGL coordinates.<br>
---* return The previous touch location in OpenGL coordinates.
---@return vec2_table
function Touch:getPreviousLocation () end
---*  Constructor.<br>
---* js ctor
---@return self
function Touch:Touch () end