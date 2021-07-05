---@meta

---@class ccs.DisplayManager :cc.Ref
local DisplayManager={ }
ccs.DisplayManager=DisplayManager




---* 
---@return cc.Node
function DisplayManager:getDisplayRenderNode () end
---* 
---@return vec2_table
function DisplayManager:getAnchorPointInPoints () end
---* 
---@return int
function DisplayManager:getDisplayRenderNodeType () end
---* 
---@param index int
---@return self
function DisplayManager:removeDisplay (index) end
---* 
---@param force boolean
---@return self
function DisplayManager:setForceChangeDisplay (force) end
---* 
---@param bone ccs.Bone
---@return boolean
function DisplayManager:init (bone) end
---* 
---@return size_table
function DisplayManager:getContentSize () end
---* 
---@return rect_table
function DisplayManager:getBoundingBox () end
---@overload fun(ccs.DisplayData0:cc.Node,int:int):self
---@overload fun(ccs.DisplayData:ccs.DisplayData,int:int):self
---@param displayData ccs.DisplayData
---@param index int
---@return self
function DisplayManager:addDisplay (displayData,index) end
---@overload fun(float:float,float:float):self
---@overload fun(float0:vec2_table):self
---@param x float
---@param y float
---@return boolean
function DisplayManager:containPoint (x,y) end
---* Change display by index. You can just use this method to change display in the display list.<br>
---* The display list is just used for this bone, and it is the displays you may use in every frame.<br>
---* Note : if index is the same with prev index, the method will not effect<br>
---* param index The index of the display you want to change<br>
---* param force If true, then force change display to specified display, or current display will set to  display index edit in the flash every key frame.
---@param index int
---@param force boolean
---@return self
function DisplayManager:changeDisplayWithIndex (index,force) end
---* 
---@param name string
---@param force boolean
---@return self
function DisplayManager:changeDisplayWithName (name,force) end
---* 
---@return boolean
function DisplayManager:isForceChangeDisplay () end
---* 
---@return int
function DisplayManager:getCurrentDisplayIndex () end
---* 
---@return vec2_table
function DisplayManager:getAnchorPoint () end
---* 
---@return array_table
function DisplayManager:getDecorativeDisplayList () end
---* Determines if the display is visible<br>
---* see setVisible(bool)<br>
---* return true if the node is visible, false if the node is hidden.
---@return boolean
function DisplayManager:isVisible () end
---* Sets whether the display is visible<br>
---* The default value is true, a node is default to visible<br>
---* param visible   true if the node is visible, false if the node is hidden.
---@param visible boolean
---@return self
function DisplayManager:setVisible (visible) end
---* 
---@param bone ccs.Bone
---@return self
function DisplayManager:create (bone) end
---* 
---@return self
function DisplayManager:DisplayManager () end