---@meta

---@class ccui.RadioButtonGroup :ccui.Widget
local RadioButtonGroup={ }
ccui.RadioButtonGroup=RadioButtonGroup




---* Remove a radio button from this group.<br>
---* param radio button instance
---@param radioButton ccui.RadioButton
---@return self
function RadioButtonGroup:removeRadioButton (radioButton) end
---* Query whether no-selection is allowed or not.<br>
---* param true means no-selection is allowed, false means no-selection is not allowed.
---@return boolean
function RadioButtonGroup:isAllowedNoSelection () end
---* Get the index of selected radio button.<br>
---* return the selected button's index. Returns -1 if no button is selected.
---@return int
function RadioButtonGroup:getSelectedButtonIndex () end
---* Set a flag for allowing no-selection feature.<br>
---* If it is allowed, no radio button can be selected.<br>
---* If it is not allowed, one radio button must be selected all time except it is empty.<br>
---* Default is not allowed.<br>
---* param true means allowing no-selection, false means disallowing no-selection.
---@param allowedNoSelection boolean
---@return self
function RadioButtonGroup:setAllowedNoSelection (allowedNoSelection) end
---@overload fun(int0:ccui.RadioButton):self
---@overload fun(int:int):self
---@param index int
---@return self
function RadioButtonGroup:setSelectedButtonWithoutEvent (index) end
---* Add a callback function which would be called when radio button is selected or unselected.<br>
---* param callback A std::function with type @see `ccRadioButtonGroupCallback`
---@param callback function
---@return self
function RadioButtonGroup:addEventListener (callback) end
---* Remove all radio button from this group.
---@return self
function RadioButtonGroup:removeAllRadioButtons () end
---* Get a radio button in this group by index.<br>
---* param index of the radio button<br>
---* return radio button instance. Returns nullptr if out of index.
---@param index int
---@return ccui.RadioButton
function RadioButtonGroup:getRadioButtonByIndex (index) end
---* Get the number of radio buttons in this group.<br>
---* return the number of radio buttons in this group
---@return int
function RadioButtonGroup:getNumberOfRadioButtons () end
---* Add a radio button into this group.<br>
---* param radio button instance
---@param radioButton ccui.RadioButton
---@return self
function RadioButtonGroup:addRadioButton (radioButton) end
---@overload fun(int0:ccui.RadioButton):self
---@overload fun(int:int):self
---@param index int
---@return self
function RadioButtonGroup:setSelectedButton (index) end
---* Create and return a empty RadioButtonGroup instance pointer.
---@return self
function RadioButtonGroup:create () end
---* 
---@return string
function RadioButtonGroup:getDescription () end
---* Default constructor.<br>
---* lua new
---@return self
function RadioButtonGroup:RadioButtonGroup () end