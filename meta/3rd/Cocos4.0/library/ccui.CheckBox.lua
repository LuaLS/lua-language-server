---@meta

---@class ccui.CheckBox :ccui.AbstractCheckButton
local CheckBox={ }
ccui.CheckBox=CheckBox




---* Add a callback function which would be called when checkbox is selected or unselected.<br>
---* param callback A std::function with type @see `ccCheckBoxCallback`
---@param callback function
---@return self
function CheckBox:addEventListener (callback) end
---@overload fun(string:string,string:string,string:string,string:string,string:string,int:int):self
---@overload fun():self
---@overload fun(string:string,string:string,string2:int):self
---@param backGround string
---@param backGroundSelected string
---@param cross string
---@param backGroundDisabled string
---@param frontCrossDisabled string
---@param texType int
---@return self
function CheckBox:create (backGround,backGroundSelected,cross,backGroundDisabled,frontCrossDisabled,texType) end
---* 
---@return cc.Ref
function CheckBox:createInstance () end
---* 
---@return string
function CheckBox:getDescription () end
---* Default constructor.<br>
---* lua new
---@return self
function CheckBox:CheckBox () end