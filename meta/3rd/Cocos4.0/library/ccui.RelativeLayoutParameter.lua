---@meta

---@class ccui.RelativeLayoutParameter :ccui.LayoutParameter
local RelativeLayoutParameter={ }
ccui.RelativeLayoutParameter=RelativeLayoutParameter




---* Sets RelativeAlign parameter for LayoutParameter.<br>
---* see RelativeAlign<br>
---* param align Relative align in  `RelativeAlign`.
---@param align int
---@return self
function RelativeLayoutParameter:setAlign (align) end
---* Set widget name your widget want to relative to.<br>
---* param name Relative widget name.
---@param name string
---@return self
function RelativeLayoutParameter:setRelativeToWidgetName (name) end
---* Get a name of LayoutParameter in Relative Layout.<br>
---* return name Relative name in string.
---@return string
function RelativeLayoutParameter:getRelativeName () end
---* Get the relative widget name.<br>
---* return name A relative widget name in string.
---@return string
function RelativeLayoutParameter:getRelativeToWidgetName () end
---* Set a name for LayoutParameter in Relative Layout.<br>
---* param name A string name.
---@param name string
---@return self
function RelativeLayoutParameter:setRelativeName (name) end
---* Get RelativeAlign parameter for LayoutParameter.<br>
---* see RelativeAlign<br>
---* return  A RelativeAlign variable.
---@return int
function RelativeLayoutParameter:getAlign () end
---* Create a RelativeLayoutParameter instance.<br>
---* return A initialized LayoutParameter which is marked as "autorelease".
---@return self
function RelativeLayoutParameter:create () end
---* 
---@return ccui.LayoutParameter
function RelativeLayoutParameter:createCloneInstance () end
---* 
---@param model ccui.LayoutParameter
---@return self
function RelativeLayoutParameter:copyProperties (model) end
---* Default constructor<br>
---* lua new
---@return self
function RelativeLayoutParameter:RelativeLayoutParameter () end