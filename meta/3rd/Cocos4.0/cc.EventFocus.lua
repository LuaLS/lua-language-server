---@meta

---@class cc.EventFocus :cc.Event
local EventFocus={ }
cc.EventFocus=EventFocus




---*  Constructor.<br>
---* param widgetLoseFocus The widget which lose focus.<br>
---* param widgetGetFocus The widget which get focus.<br>
---* js ctor
---@param widgetLoseFocus ccui.Widget
---@param widgetGetFocus ccui.Widget
---@return self
function EventFocus:EventFocus (widgetLoseFocus,widgetGetFocus) end