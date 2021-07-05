---@meta

---@class ccui.RadioButton :ccui.AbstractCheckButton
local RadioButton={ }
ccui.RadioButton=RadioButton




---* Add a callback function which would be called when radio button is selected or unselected.<br>
---* param callback A std::function with type @see `ccRadioButtonCallback`
---@param callback function
---@return self
function RadioButton:addEventListener (callback) end
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
function RadioButton:create (backGround,backGroundSelected,cross,backGroundDisabled,frontCrossDisabled,texType) end
---* 
---@return cc.Ref
function RadioButton:createInstance () end
---* 
---@return string
function RadioButton:getDescription () end
---* Default constructor.<br>
---* lua new
---@return self
function RadioButton:RadioButton () end